package it.torino._5t.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.CalendarDAO;
import it.torino._5t.dao.RouteDAO;
import it.torino._5t.dao.ShapeDAO;
import it.torino._5t.dao.TripPatternDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Calendar;
import it.torino._5t.entity.Route;
import it.torino._5t.entity.Shape;
import it.torino._5t.entity.Stop;
import it.torino._5t.entity.StopTimeRelative;
import it.torino._5t.entity.Trip;
import it.torino._5t.entity.TripPattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class TripPatternController {
	private static final Logger logger = LoggerFactory.getLogger(TripPatternController.class);
	
	@Autowired
	private TripPatternDAO tripPatternDAO;
	@Autowired
	private RouteDAO routeDAO;
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private CalendarDAO calendarDAO;
	@Autowired
	private ShapeDAO shapeDAO;
	
	@RequestMapping(value = "/schemiCorse", method = RequestMethod.GET)
	public String showTrips(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		agencyDAO.updateAgency(agency);
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		Route r = routeDAO.loadRoute(route.getId());
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern != null) {
			tripPatternDAO.updateTripPattern(tripPattern);
			model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
		}
		
		logger.info("Visualizzazione lista schemi corse di " + route.getShortName() + ".");
		
		//routeDAO.updateRoute(route);
		model.addAttribute("listaSchemiCorse", r.getTripPatterns());
		model.addAttribute("listaCalendari", agency.getCalendars());
		model.addAttribute("tripPattern", new TripPattern());
		
		return "tripPattern";
	}
	
	// chiamata quando clicco sul pulsante "Crea uno schema corsa"
	@RequestMapping(value = "/creaSchemaCorsa", method = RequestMethod.GET)
	public String showCreateTripForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("tripPattern", new TripPattern());
		
		return "redirect:schemiCorse";
	}
	
	// chiamata al submit del form per la creazione di una nuova corsa
	@RequestMapping(value = "/schemiCorse", method = RequestMethod.POST)
	public String submitTripPatternForm(@ModelAttribute @Valid TripPattern tripPattern, BindingResult bindingResult, @RequestParam("serviceId") Integer serviceId, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della corsa");
			routeDAO.updateRoute(route);
			model.addAttribute("listaSchemiCorse", route.getTripPatterns());
			model.addAttribute("listaCalendari", agency.getCalendars());
			TripPattern tripPat = (TripPattern) session.getAttribute("schemaCorsaAttivo");
			if (tripPat != null) {
				tripPatternDAO.updateTripPattern(tripPat);
				model.addAttribute("listaFermateCorsa", tripPat.getStopTimeRelatives());
			}
			model.addAttribute("showCreateForm", true);
			return "tripPattern";
		}
		
		// cerco tra le linee dell'agenzia quella attiva e le aggiungo la nuova corsa
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.getGtfsId().equals(tripPattern.getGtfsId())) {
						logger.error("L'id dello schema corsa è già presente");
						model.addAttribute("listaSchemiCorse", route.getTripPatterns());
						model.addAttribute("listaCalendari", a.getCalendars());
						TripPattern tripPat = (TripPattern) session.getAttribute("schemaCorsaAttivo");
						if (tripPat != null) {
							//tripPatternDAO.updateTripPattern(tripPat);
							model.addAttribute("listaFermateCorsa", tripPat.getStopTimeRelatives());
						}
						model.addAttribute("showCreateForm", true);
						model.addAttribute("showAlertDuplicateTripPattern", true);
						return "tripPattern";
					}
				}
				r.addTripPattern(tripPattern);
				session.setAttribute("lineaAttiva", r);
				break;
			}
		}
		Calendar calendar = calendarDAO.getCalendar(serviceId);
		calendar.addTripPattern(tripPattern);
		
		logger.info("Schema corsa creato: " + tripPattern.getGtfsId() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("schemaCorsaAttivo", tripPattern);
		
		return "redirect:schemiCorse";
	}
	
	// chiamata quando seleziono uno schema corsa (verrà salvata nella sessione)
	@RequestMapping(value = "/selezionaSchemaCorsa", method = RequestMethod.GET)
	public String selectTripPattern(@RequestParam("id") Integer tripPatternId, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		agencyDAO.updateAgency(agency);
		
		TripPattern tripPattern = tripPatternDAO.getTripPattern(tripPatternId);
		
		logger.info("Schema corsa selezionato: " + tripPattern.getGtfsId() + ".");
		
		redirectAttributes.addFlashAttribute("listaCalendari", agency.getCalendars());

		session.removeAttribute("corsaSingolaAttiva");
//		session.setAttribute("lineaAttiva", trip.getRoute());
		session.setAttribute("schemaCorsaAttivo", tripPattern);
		
		return "redirect:schemiCorse";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaSchemaCorsa", method = RequestMethod.GET)
	public String deleteTripPattern(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		// cerco tra le linee dell'agenzia quella attiva e le tolgo lo schema corsa selezionato
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				r.getTripPatterns().remove(tripPattern);
				session.setAttribute("lineaAttiva", r);
				break;
			}
		}
		
		// rimuovo lo schema corsa anche dal set associato al calendario corrispondente
		Calendar calendar = calendarDAO.loadCalendar(tripPattern.getCalendar().getId());
		for (Calendar c: a.getCalendars()) {
			if (c.equals(calendar)) {
				c.getTripPatterns().remove(tripPattern);
			}
		}
		
		logger.info("Schema corsa eliminato: " + tripPattern.getGtfsId() + ".");
		
		session.removeAttribute("schemaCorsaAttivo");
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:schemiCorse";
	}
	
	// chiamata quando clicco sul pulsante "Modifica schema corsa"
	@RequestMapping(value = "/modificaSchemaCorsa", method = RequestMethod.GET)
	public String showEditTripPatternForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("tripPattern", tripPattern);
		redirectAttributes.addFlashAttribute("listaCalendari", a.getCalendars());
		
		return "redirect:schemiCorse";
	}
	
	// chiamata al submit del form per la modifica di uno schema corsa
	@RequestMapping(value = "/modificaSchemaCorsa", method = RequestMethod.POST)
	public String editTripPattern(@ModelAttribute @Valid TripPattern tripPattern, BindingResult bindingResult, @RequestParam("serviceId") Integer serviceId, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica dello schema corsa");
			routeDAO.updateRoute(route);
			model.addAttribute("listaSchemiCorse", route.getTripPatterns());
			model.addAttribute("listaCalendari", agency.getCalendars());
			TripPattern tripPat = (TripPattern) session.getAttribute("schemaCorsaAttivo");
			if (tripPat != null) {
				tripPatternDAO.updateTripPattern(tripPat);
				model.addAttribute("listaFermateCorsa", tripPat.getStopTimeRelatives());
			}
			model.addAttribute("showEditForm", true);
			return "tripPattern";
		}
		
		TripPattern activetrippattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (activetrippattern == null) {
			return "redirect:schemiCorse";
		}
		
		Calendar calendar = calendarDAO.getCalendar(serviceId);
		
		// cerco tra le linee dell'agenzia quella attiva, tra le corse della linea selezionata quella attiva e la aggiorno
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (TripPattern tp: r.getTripPatterns()) {
					if (!activetrippattern.getGtfsId().equals(tripPattern.getGtfsId()) && tp.getGtfsId().equals(tripPattern.getGtfsId())) {
						logger.error("L'id dello schema corsa è già presente");
						model.addAttribute("listaSchemiCorse", r.getTripPatterns());
						model.addAttribute("listaCalendari", a.getCalendars());
						model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
						model.addAttribute("showEditForm", true);
						model.addAttribute("showAlertDuplicateTripPattern", true);
						model.addAttribute("tripPattern", new TripPattern());
						return "tripPattern";
					}
				}
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(activetrippattern)) {
						tp.setGtfsId(tripPattern.getGtfsId());
						tp.setTripHeadsign(tripPattern.getTripHeadsign());
						tp.setTripShortName(tripPattern.getTripShortName());
						tp.setDirectionId(tripPattern.getDirectionId());
						tp.setWheelchairAccessible(tripPattern.getWheelchairAccessible());
						tp.setBikesAllowed(tripPattern.getBikesAllowed());
						for (Calendar c: a.getCalendars()) {
							if (c.equals(calendar)) {
								c.getTripPatterns().remove(activetrippattern);
								c.addTripPattern(tp);
								session.setAttribute("calendarioAttivo", c);
								break;
							}
						}
						logger.info("Schema corsa modificato: " + tp.getGtfsId() + ".");
						session.setAttribute("schemaCorsaAttivo", tp);
						session.setAttribute("lineaAttiva", r);
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:schemiCorse";
	}
	
	// chiamata al submit del form per la duplicazione di una corsa
	@RequestMapping(value = "/duplicaSchemaCorsa", method = RequestMethod.POST)
	public String duplicateTripPattern(@RequestParam("newGtfsId") String newGtfsId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		if (newGtfsId == null) {
			redirectAttributes.addFlashAttribute("showAlertDuplicateTripPattern", true);
			return "redirect:schemiCorse";
		}
		
		TripPattern duplicatedTripPattern = new TripPattern();
		duplicatedTripPattern.setGtfsId(newGtfsId);
		duplicatedTripPattern.setTripHeadsign(tripPattern.getTripHeadsign());
		duplicatedTripPattern.setTripShortName(tripPattern.getTripShortName());
		duplicatedTripPattern.setDirectionId(tripPattern.getDirectionId());
		duplicatedTripPattern.setWheelchairAccessible(tripPattern.getWheelchairAccessible());
		duplicatedTripPattern.setBikesAllowed(tripPattern.getBikesAllowed());
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// controllo che l'id inserito non esista già
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.getGtfsId().equals(newGtfsId)) {
						logger.error("L'id dello schema corsa è già presente");
						redirectAttributes.addFlashAttribute("showAlertDuplicateTripPattern", true);
						return "redirect:schemiCorse";
					}
				}
				// cerco tra gli schemi corsa della linea quello attivo
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(tripPattern)) {
						// associo il calendario
						Calendar calendar = calendarDAO.getCalendar(tp.getCalendar().getId());
						calendar.addTripPattern(duplicatedTripPattern);
						// copio tutte le fermate associate allo schema corsa
						for (StopTimeRelative str: tp.getStopTimeRelatives()) {
							StopTimeRelative stopTimeRelative = new StopTimeRelative(str.getRelativeArrivalTime(), str.getRelativeDepartureTime(), str.getStopSequence(), str.getStopHeadsign(), str.getPickupType(), str.getDropOffType(), str.getShapeDistTraveled());
							for (Stop s: a.getStops()) {
								if (s.getId().equals(str.getStop().getId())) {
									s.addStopTimeRelative(stopTimeRelative);
									break;
								}
							}
							duplicatedTripPattern.addStopTimeRelative(stopTimeRelative);
						}
						// se lo schema corsa ha uno shape associato, lo duplico
						Shape shape = new Shape();
						if (tp.getShape() != null) {
							for (Shape s: a.getShapes()) {
								if (s.getId().equals(tp.getShape().getId())) {
									shape.setEncodedPolyline(s.getEncodedPolyline());
									shape.addTripPattern(duplicatedTripPattern);
									a.addShape(shape);
									break;
								}
							}
						}
						// copio tutte le corse associate allo schema corsa
						/*for (Trip t: tp.getTrips()) {
							Trip trip = new Trip(t.getGtfsId(), t.getStartTime(), t.getEndTime(), t.getHeadwaySecs(), t.getExactTimes(), t.getRoute(), t.getTripHeadsign(), t.getTripShortName(), t.getDirectionId(), t.getBlockId(), t.isSingleTrip(), shape, t.getWheelchairAccessible(), t.getBikesAllowed());
							calendar.addTrip(trip);
							duplicatedTripPattern.addTrip(trip);
							logger.info("----> Added trip: " + trip.getGtfsId());
						}
						logger.info("----> Trips: " + duplicatedTripPattern.getTrips().size());
						break;*/
					}
				}
				r.addTripPattern(duplicatedTripPattern);
				session.setAttribute("lineaAttiva", r);
				break;
			}
		}
		
		logger.info("Schema corsa creato: " + duplicatedTripPattern.getGtfsId() + ".");
		
		session.removeAttribute("corsaSingolaAttiva");
		session.removeAttribute("corsaAFrequenzaAttiva");
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("schemaCorsaAttivo", duplicatedTripPattern);
		
		return "redirect:schemiCorse";
	}
}
