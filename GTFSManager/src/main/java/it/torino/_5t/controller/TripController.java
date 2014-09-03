package it.torino._5t.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.CalendarDAO;
import it.torino._5t.dao.RouteDAO;
import it.torino._5t.dao.ShapeDAO;
import it.torino._5t.dao.TripDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Calendar;
import it.torino._5t.entity.Frequency;
import it.torino._5t.entity.Route;
import it.torino._5t.entity.Shape;
import it.torino._5t.entity.Stop;
import it.torino._5t.entity.StopTime;
import it.torino._5t.entity.Trip;

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
public class TripController {
	private static final Logger logger = LoggerFactory.getLogger(TripController.class);
	
	@Autowired
	private TripDAO tripDAO;
	@Autowired
	private RouteDAO routeDAO;
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private CalendarDAO calendarDAO;
	@Autowired
	private ShapeDAO shapeDAO;
	
	@RequestMapping(value = "/corse", method = RequestMethod.GET)
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
		
		logger.info("Visualizzazione lista corse di " + route.getShortName() + ".");
		
		//routeDAO.updateRoute(route);
		model.addAttribute("listaCorse", r.getTrips());
		model.addAttribute("listaCalendari", agency.getCalendars());
		model.addAttribute("trip", new Trip());
		
		return "trip";
	}
	
	// chiamata quando clicco sul pulsante "Crea una corsa"
	@RequestMapping(value = "/creaCorsa", method = RequestMethod.GET)
	public String showCreateTripForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("trip", new Trip());
		
		return "redirect:corse";
	}
	
	// chiamata al submit del form per la creazione di una nuova corsa
	@RequestMapping(value = "/corse", method = RequestMethod.POST)
	public String submitTripForm(@ModelAttribute @Valid Trip trip, BindingResult bindingResult, @RequestParam("serviceId") Integer serviceId, Model model, HttpSession session) {
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
			model.addAttribute("listaCorse", route.getTrips());
			model.addAttribute("listaCalendari", agency.getCalendars());
			model.addAttribute("showCreateForm", true);
			return "trip";
		}
		
		// cerco tra le linee dell'agenzia quella attiva e le aggiungo la nuova corsa
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (Trip t: tripDAO.getTripsFromRoute(r)) {
					if (t.getGtfsId().equals(trip.getGtfsId())) {
						logger.error("L'id della corsa è già presente");
						model.addAttribute("listaCorse", r.getTrips());
						model.addAttribute("listaCalendari", a.getCalendars());
						model.addAttribute("showCreateForm", true);
						model.addAttribute("showAlertDuplicateTrip", true);
						return "trip";
					}
				}
				r.addTrip(trip);
				session.setAttribute("lineaAttiva", r);
				break;
			}
		}
		Calendar calendar = calendarDAO.getCalendar(serviceId);
		calendar.addTrip(trip);
		
		logger.info("Corsa creata: " + trip.getTripShortName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("corsaAttiva", trip);
		
		return "redirect:corse";
	}
	
	// chiamata quando seleziono una corsa (verrà salvata nella sessione)
	@RequestMapping(value = "/selezionaCorsa", method = RequestMethod.GET)
	public String selectTrip(@RequestParam("id") Integer tripId, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		agencyDAO.updateAgency(agency);
		
		Trip trip = tripDAO.getTrip(tripId);
		
		logger.info("Corsa selezionata: " + trip.getTripShortName() + ".");
		
		redirectAttributes.addFlashAttribute("listaCalendari", agency.getCalendars());

		session.removeAttribute("servizioAttivo");
//		session.setAttribute("lineaAttiva", trip.getRoute());
		session.setAttribute("corsaAttiva", trip);
		
		return "redirect:corse";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaCorsa", method = RequestMethod.GET)
	public String deleteTrip(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		Trip trip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		
		// cerco tra le linee dell'agenzia quella attiva e le tolgo la corsa selezionata
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				r.getTrips().remove(trip);
				session.setAttribute("lineaAttiva", r);
				break;
			}
		}
		
		// rimuovo la corsa anche dal set associato al calendario corrispondente
		Calendar calendar = calendarDAO.loadCalendar(trip.getCalendar().getId());
		for (Calendar c: a.getCalendars()) {
			if (c.equals(calendar)) {
				c.getTrips().remove(trip);
			}
		}
		
		logger.info("Corsa eliminata: " + trip.getTripShortName() + ".");
		
		session.removeAttribute("corsaAttiva");
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:corse";
	}
	
	// chiamata quando clicco sul pulsante "Modifica corsa"
	@RequestMapping(value = "/modificaCorsa", method = RequestMethod.GET)
	public String showEditTripForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Trip trip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("trip", trip);
		redirectAttributes.addFlashAttribute("listaCalendari", a.getCalendars());
		
		return "redirect:corse";
	}
	
	// chiamata al submit del form per la modifica di una corsa
	@RequestMapping(value = "/modificaCorsa", method = RequestMethod.POST)
	public String editTrip(@ModelAttribute @Valid Trip trip, BindingResult bindingResult, @RequestParam("serviceId") Integer serviceId, Model model, HttpSession session) {
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
			logger.error("Errore nella modifica della corsa");
			routeDAO.updateRoute(route);
			model.addAttribute("listaCorse", route.getTrips());
			model.addAttribute("listaCalendari", agency.getCalendars());
			model.addAttribute("showEditForm", true);
			return "trip";
		}
		
		Trip activetrip = (Trip) session.getAttribute("corsaAttiva");
		if (activetrip == null) {
			return "redirect:corse";
		}
		
		Calendar calendar = calendarDAO.getCalendar(serviceId);
		
		// cerco tra le linee dell'agenzia quella attiva, tra le corse della linea selezionata quella attiva e la aggiorno
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (Trip t: tripDAO.getTripsFromRoute(r)) {
					if (!activetrip.getGtfsId().equals(trip.getGtfsId()) && t.getGtfsId().equals(trip.getGtfsId())) {
						logger.error("L'id della corsa è già presente");
						model.addAttribute("listaCorse", r.getTrips());
						model.addAttribute("listaCalendari", a.getCalendars());
						model.addAttribute("showEditForm", true);
						model.addAttribute("showAlertDuplicateTrip", true);
						return "trip";
					}
				}
				for (Trip t: r.getTrips()) {
					if (t.equals(activetrip)) {
						t.setGtfsId(trip.getGtfsId());
						t.setTripHeadsign(trip.getTripHeadsign());
						t.setTripShortName(trip.getTripShortName());
						t.setDirectionId(trip.getDirectionId());
						t.setWheelchairAccessible(trip.getWheelchairAccessible());
						t.setBikesAllowed(trip.getBikesAllowed());
						for (Calendar c: a.getCalendars()) {
							if (c.equals(calendar)) {
								c.getTrips().remove(activetrip);
								c.addTrip(t);
								session.setAttribute("calendarioAttivo", c);
								break;
							}
						}
						logger.info("Corsa modificata: " + t.getTripShortName() + ".");
						session.setAttribute("corsaAttiva", t);
						session.setAttribute("lineaAttiva", r);
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:corse";
	}
	
	// chiamata al submit del form per la duplicazione di una corsa
	@RequestMapping(value = "/duplicaCorsa", method = RequestMethod.POST)
	public String duplicateTrip(@RequestParam("newGtfsId") String newGtfsId, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		Trip trip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		
		if (newGtfsId == null) {
			logger.error("Nessun id inserito per la corsa duplicata");
			model.addAttribute("listaCorse", route.getTrips());
			model.addAttribute("listaCalendari", a.getCalendars());
			model.addAttribute("showCreateForm", true);
			return "trip";
		}
		
		Trip duplicatedTrip = new Trip();
		duplicatedTrip.setGtfsId(newGtfsId);
		duplicatedTrip.setTripHeadsign(trip.getTripHeadsign());
		duplicatedTrip.setTripShortName(trip.getTripShortName());
		duplicatedTrip.setDirectionId(trip.getDirectionId());
		duplicatedTrip.setWheelchairAccessible(trip.getWheelchairAccessible());
		duplicatedTrip.setBikesAllowed(trip.getBikesAllowed());
		for (Frequency f: trip.getFrequencies()) {
			duplicatedTrip.addFrequency(new Frequency(f.getTrip(), f.getStartTime(), f.getEndTime(), f.getHeadwaySecs(), f.getExactTimes()));
		}
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (Trip t: tripDAO.getTripsFromRoute(r)) {
					if (t.getGtfsId().equals(newGtfsId)) {
						logger.error("L'id della corsa è già presente");
						model.addAttribute("listaCorse", r.getTrips());
						model.addAttribute("listaCalendari", a.getCalendars());
						model.addAttribute("showAlertDuplicateTrip", true);
						model.addAttribute("trip", new Trip());
						return "trip";
					}
				}
				// tra le corse della linea quella attiva e le modifico l'associazione
				for (Trip t: r.getTrips()) {
					if (t.equals(trip)) {
						for (StopTime st: t.getStopTimes()) {
							StopTime stopTime = new StopTime(st.getArrivalTime(), st.getDepartureTime(), st.getStopSequence(), st.getStopHeadsign(), st.getPickupType(), st.getDropOffType(), st.getShapeDistTraveled());
							for (Stop s: a.getStops()) {
								if (s.getId().equals(st.getStop().getId())) {
									s.addStopTime(stopTime);
									break;
								}
							}
							duplicatedTrip.addStopTime(stopTime);
						}
						if (t.getShape() != null) {
							for (Shape s: a.getShapes()) {
								if (s.getId().equals(t.getShape().getId())) {
									Shape shape = new Shape();
									shape.setEncodedPolyline(s.getEncodedPolyline());
									shape.addTrip(duplicatedTrip);
									a.addShape(shape);
									break;
								}
							}
						}
						break;
					}
				}
				break;
			}
		}
		
		// cerco tra le linee dell'agenzia quella attiva e le aggiungo la nuova corsa
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				r.addTrip(duplicatedTrip);
				session.setAttribute("lineaAttiva", r);
				break;
			}
		}
		
		Calendar calendar = calendarDAO.getCalendar(trip.getCalendar().getId());
		calendar.addTrip(duplicatedTrip);
		
		logger.info("Corsa creata: " + duplicatedTrip.getTripShortName() + ".");
		
		session.removeAttribute("servizioAttivo");
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("corsaAttiva", duplicatedTrip);
		
		return "redirect:corse";
	}
}
