package it.torino._5t.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.CalendarDAO;
import it.torino._5t.dao.RouteDAO;
import it.torino._5t.dao.TripDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Calendar;
import it.torino._5t.entity.Route;
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
			model.addAttribute("showCreateForm", true);
			return "trip";
		}
		
		// cerco tra le linee dell'agenzia quella attiva e le aggiungo la nuova corsa
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
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
	
	// chiamata quando seleziono una corsa (verr� salvata nella sessione)
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
			model.addAttribute("showEditForm", true);
			return "trip";
		}
		
		Trip activetrip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		
		Calendar calendar = calendarDAO.getCalendar(serviceId);
		
		// cerco tra le linee dell'agenzia quella attiva, tra le corse della linea selezionata quella attiva e la aggiorno
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				for (Trip t: r.getTrips()) {
					if (t.equals(activetrip)) {
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
}