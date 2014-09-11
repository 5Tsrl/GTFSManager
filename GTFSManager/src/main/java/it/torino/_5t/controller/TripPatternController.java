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

		session.removeAttribute("servizioAttivo");
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
	public String editTrip(@ModelAttribute @Valid TripPattern tripPattern, BindingResult bindingResult, @RequestParam("serviceId") Integer serviceId, Model model, HttpSession session) {
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
						logger.error("L'id della corsa è già presente");
						model.addAttribute("listaSchemiCorse", r.getTripPatterns());
						model.addAttribute("listaCalendari", a.getCalendars());
						model.addAttribute("showEditForm", true);
						model.addAttribute("showAlertDuplicateTripPattern", true);
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
	
//	// chiamata al submit del form per la duplicazione di una corsa
//	@RequestMapping(value = "/duplicaCorsa", method = RequestMethod.POST)
//	public String duplicateTrip(@RequestParam("newGtfsId") String newGtfsId, Model model, HttpSession session) {
//		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
//		if (agency == null) {
//			return "redirect:agenzie";
//		}
//		Agency a = agencyDAO.loadAgency(agency.getId());
//		
//		Route route = (Route) session.getAttribute("lineaAttiva");
//		if (route == null) {
//			return "redirect:linee";
//		}
//		
//		Trip trip = (Trip) session.getAttribute("corsaAttiva");
//		if (trip == null) {
//			return "redirect:corse";
//		}
//		
//		if (newGtfsId == null) {
//			logger.error("Nessun id inserito per la corsa duplicata");
//			model.addAttribute("listaCorse", route.getTrips());
//			model.addAttribute("listaCalendari", a.getCalendars());
//			model.addAttribute("showCreateForm", true);
//			return "trip";
//		}
//		
//		Trip duplicatedTrip = new Trip();
//		duplicatedTrip.setGtfsId(newGtfsId);
//		duplicatedTrip.setTripHeadsign(trip.getTripHeadsign());
//		duplicatedTrip.setTripShortName(trip.getTripShortName());
//		duplicatedTrip.setDirectionId(trip.getDirectionId());
//		duplicatedTrip.setWheelchairAccessible(trip.getWheelchairAccessible());
//		duplicatedTrip.setBikesAllowed(trip.getBikesAllowed());
//		for (Frequency f: trip.getFrequencies()) {
//			duplicatedTrip.addFrequency(new Frequency(f.getTrip(), f.getStartTime(), f.getEndTime(), f.getHeadwaySecs(), f.getExactTimes()));
//		}
//		// cerco tra le linee dell'agenzia quella attiva
//		for (Route r: a.getRoutes()) {
//			if (r.equals(route)) {
//				for (Trip t: tripDAO.getTripsFromRoute(r)) {
//					if (t.getGtfsId().equals(newGtfsId)) {
//						logger.error("L'id della corsa è già presente");
//						model.addAttribute("listaCorse", r.getTrips());
//						model.addAttribute("listaCalendari", a.getCalendars());
//						model.addAttribute("showAlertDuplicateTripPattern", true);
//						model.addAttribute("trip", new Trip());
//						return "trip";
//					}
//				}
//				// tra le corse della linea quella attiva e le modifico l'associazione
//				for (Trip t: r.getTrips()) {
//					if (t.equals(trip)) {
//						for (StopTime st: t.getStopTimes()) {
//							StopTime stopTime = new StopTime(st.getArrivalTime(), st.getDepartureTime(), st.getStopSequence(), st.getStopHeadsign(), st.getPickupType(), st.getDropOffType(), st.getShapeDistTraveled());
//							for (Stop s: a.getStops()) {
//								if (s.getId().equals(st.getStop().getId())) {
//									s.addStopTime(stopTime);
//									break;
//								}
//							}
//							duplicatedTrip.addStopTime(stopTime);
//						}
//						if (t.getShape() != null) {
//							for (Shape s: a.getShapes()) {
//								if (s.getId().equals(t.getShape().getId())) {
//									Shape shape = new Shape();
//									shape.setEncodedPolyline(s.getEncodedPolyline());
//									shape.addTrip(duplicatedTrip);
//									a.addShape(shape);
//									break;
//								}
//							}
//						}
//						break;
//					}
//				}
//				break;
//			}
//		}
//		
//		// cerco tra le linee dell'agenzia quella attiva e le aggiungo la nuova corsa
//		for (Route r: a.getRoutes()) {
//			if (r.equals(route)) {
//				r.addTrip(duplicatedTrip);
//				session.setAttribute("lineaAttiva", r);
//				break;
//			}
//		}
//		
//		Calendar calendar = calendarDAO.getCalendar(trip.getCalendar().getId());
//		calendar.addTrip(duplicatedTrip);
//		
//		logger.info("Corsa creata: " + duplicatedTrip.getTripShortName() + ".");
//		
//		session.removeAttribute("servizioAttivo");
//		session.setAttribute("agenziaAttiva", a);
//		session.setAttribute("corsaAttiva", duplicatedTrip);
//		
//		return "redirect:corse";
//	}
}
