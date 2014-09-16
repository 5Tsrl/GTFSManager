package it.torino._5t.controller;

import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.CalendarDAO;
import it.torino._5t.dao.RouteDAO;
import it.torino._5t.dao.ShapeDAO;
import it.torino._5t.dao.TripDAO;
import it.torino._5t.dao.TripPatternDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Calendar;
import it.torino._5t.entity.Route;
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
public class SingleTripController {
	private static final Logger logger = LoggerFactory.getLogger(SingleTripController.class);
	
	@Autowired
	private TripDAO tripDAO;
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
	
	@RequestMapping(value = "/corseSingole", method = RequestMethod.GET)
	public String showTrips(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		agencyDAO.updateAgency(agency);
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		TripPattern tp = tripPatternDAO.getTripPattern(tripPattern.getId());
		
		logger.info("Visualizzazione lista corse singole di " + tp.getGtfsId() + ".");
		
		List<Trip> singleTrips = new ArrayList<Trip>();
		for (Trip t: tp.getTrips()) {
			if (t.isSingleTrip())
				singleTrips.add(t);
		}
		model.addAttribute("listaCorseSingole", singleTrips);
		model.addAttribute("listaCalendari", agency.getCalendars());
		model.addAttribute("listaFermateCorsa", tp.getStopTimeRelatives());
		model.addAttribute("trip", new Trip());
		
		return "singleTrip";
	}
	
	// chiamata quando clicco sul pulsante "Crea uno schema corsa"
	@RequestMapping(value = "/creaCorsaSingola", method = RequestMethod.GET)
	public String showCreateTripForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("trip", new Trip());
		
		return "redirect:corseSingole";
	}
	
	// chiamata al submit del form per la creazione di una nuova corsa
	@RequestMapping(value = "/corseSingole", method = RequestMethod.POST)
	public String submitTripForm(@ModelAttribute @Valid Trip trip, BindingResult bindingResult, @RequestParam("serviceId") Integer serviceId, @RequestParam("start") String startTime, Model model, HttpSession session) {
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
		tripPatternDAO.updateTripPattern(tripPattern);
		
		List<Trip> singleTrips = new ArrayList<Trip>();
		for (Trip t: tripPattern.getTrips()) {
			if (t.isSingleTrip())
				singleTrips.add(t);
		}
		
		for (Trip t: tripDAO.getAllTrips()) {
			if (t.getGtfsId().equals(trip.getGtfsId())) {
				logger.error("L'id della corsa singola è già presente");
				model.addAttribute("listaCorseSingole", singleTrips);
				model.addAttribute("listaCalendari", a.getCalendars());
				model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
				model.addAttribute("showCreateForm", true);
				model.addAttribute("showAlertDuplicateTrip", true);
				return "singleTrip";
			}
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della corsa");
			model.addAttribute("listaCorseSingole", singleTrips);
			model.addAttribute("listaCalendari", agency.getCalendars());
			model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
			model.addAttribute("showCreateForm", true);
			return "singleTrip";
		}
		
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(tripPattern)) {
						trip.setRoute(tripPattern.getRoute());
						trip.setCalendar(tripPattern.getCalendar());
						trip.setShape(tripPattern.getShape());
						String[] startT = startTime.split(":");
						Time start = new Time(Integer.parseInt(startT[0]), Integer.parseInt(startT[1]), 0);
						trip.setStartTime(start);
						Calendar calendar = calendarDAO.getCalendar(serviceId);
						calendar.addTrip(trip);
						tp.addTrip(trip);
						session.setAttribute("corsaSingolaAttiva", trip);
						session.setAttribute("schemaCorsaAttivo", tp);
						session.setAttribute("agenziaAttiva", a);
						break;
					}
				}
				break;
			}
		}
		
		logger.info("Corsa singola creata: " + trip.getGtfsId() + ".");
		
		
		return "redirect:corseSingole";
	}
	
	// chiamata quando seleziono uno schema corsa (verrà salvata nella sessione)
	@RequestMapping(value = "/selezionaCorsaSingola", method = RequestMethod.GET)
	public String selectTrip(@RequestParam("id") Integer tripId, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		agencyDAO.updateAgency(agency);
		
		Trip trip = tripDAO.getTrip(tripId);
		
		logger.info("Corsa singola selezionata: " + trip.getGtfsId() + ".");
		
		redirectAttributes.addFlashAttribute("listaCalendari", agency.getCalendars());

		session.removeAttribute("servizioAttivo");
		session.setAttribute("corsaSingolaAttiva", trip);
		
		return "redirect:corseSingole";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaCorsaSingola", method = RequestMethod.GET)
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
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		Trip trip = (Trip) session.getAttribute("corsaSingolaAttiva");
		if (trip == null) {
			return "redirect:corseSingole";
		}
		
		// cerco tra le linee dell'agenzia quella attiva e le tolgo lo schema corsa selezionato
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(tripPattern)) {
						tp.getTrips().remove(trip);
						session.setAttribute("schemaCorsaAttivo", tp);
						session.setAttribute("lineaAttiva", r);
						break;
					}
				}
				break;
			}
		}
		
		// rimuovo lo schema corsa anche dal set associato al calendario corrispondente
		Calendar calendar = calendarDAO.loadCalendar(trip.getCalendar().getId());
		for (Calendar c: a.getCalendars()) {
			if (c.equals(calendar)) {
				c.getTrips().remove(trip);
			}
		}
		
		logger.info("Corsa singola eliminata: " + trip.getGtfsId() + ".");
		
		session.removeAttribute("corsaSingolaAttiva");
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:corseSingole";
	}
	
	// chiamata quando clicco sul pulsante "Modifica schema corsa"
	@RequestMapping(value = "/modificaCorsaSingola", method = RequestMethod.GET)
	public String showEditTripForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Trip trip = (Trip) session.getAttribute("corsaSingolaAttiva");
		if (trip == null) {
			return "redirect:corseSingole";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("trip", trip);
		redirectAttributes.addFlashAttribute("listaCalendari", a.getCalendars());
		
		return "redirect:corseSingole";
	}
	
	// chiamata al submit del form per la modifica di uno schema corsa
	@RequestMapping(value = "/modificaCorsaSingola", method = RequestMethod.POST)
	public String editTrip(@ModelAttribute @Valid Trip trip, BindingResult bindingResult, @RequestParam("serviceId") Integer serviceId, @RequestParam("start") String startTime, Model model, HttpSession session) {
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
		tripPatternDAO.updateTripPattern(tripPattern);
		
		Trip activetrip = (Trip) session.getAttribute("corsaSingolaAttiva");
		if (activetrip == null) {
			return "redirect:corseSingole";
		}
		
		List<Trip> singleTrips = new ArrayList<Trip>();
		for (Trip t: tripPattern.getTrips()) {
			if (t.isSingleTrip())
				singleTrips.add(t);
		}
		
		for (Trip t: tripDAO.getAllTrips()) {
			if (!activetrip.getGtfsId().equals(trip.getGtfsId()) && t.getGtfsId().equals(trip.getGtfsId())) {
				logger.error("L'id della corsa singola è già presente");
				model.addAttribute("listaCorseSingole", singleTrips);
				model.addAttribute("listaCalendari", a.getCalendars());
				model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
				model.addAttribute("showCreateForm", true);
				model.addAttribute("showAlertDuplicateTrip", true);
				return "singleTrip";
			}
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della corsa");
			model.addAttribute("listaCorseSingole", singleTrips);
			model.addAttribute("listaCalendari", agency.getCalendars());
			model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
			model.addAttribute("showCreateForm", true);
			return "singleTrip";
		}
		
		Calendar calendar = calendarDAO.getCalendar(serviceId);
		
		// cerco tra le linee dell'agenzia quella attiva e le tolgo lo schema corsa selezionato
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(tripPattern)) {
						for (Trip t: tp.getTrips()) {
							if (t.equals(activetrip)) {
								t.setGtfsId(trip.getGtfsId());
								t.setTripHeadsign(trip.getTripHeadsign());
								t.setTripShortName(trip.getTripShortName());
								t.setCalendar(calendar);
								t.setDirectionId(trip.getDirectionId());
								t.setBlockId(trip.getBlockId());
								t.setWheelchairAccessible(trip.getWheelchairAccessible());
								t.setBikesAllowed(trip.getBikesAllowed());
								String[] startT = startTime.split(":");
								Time start = new Time(Integer.parseInt(startT[0]), Integer.parseInt(startT[1]), 0);
								t.setStartTime(start);
								for (Calendar c: a.getCalendars()) {
									if (c.equals(calendar)) {
										c.getTrips().remove(activetrip);
										c.addTrip(t);
										session.setAttribute("calendarioAttivo", c);
										break;
									}
								}
								session.setAttribute("corsaSingolaAttiva", t);
								session.setAttribute("schemaCorsaAttivo", tp);
								session.setAttribute("lineaAttiva", r);
								logger.info("Corsa singola modificata: " + t.getGtfsId() + ".");
								break;
							}
						}
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:corseSingole";
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
