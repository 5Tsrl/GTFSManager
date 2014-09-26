package it.torino._5t.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.RouteDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Route;

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
public class RouteController {
	private static final Logger logger = LoggerFactory.getLogger(RouteController.class);
	
	@Autowired
	private RouteDAO routeDAO;
	@Autowired
	private AgencyDAO agencyDAO;
	
	@RequestMapping(value = "/linee", method = RequestMethod.GET)
	public String showRoutes(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		// se c'è una linea attiva, la rendo persistent per poter accedere alla lista delle tariffe
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route != null) {
			routeDAO.updateRoute(route);
			model.addAttribute("listaTariffe", route.getFareRules());
		}
		
		logger.info("Visualizzazione lista linee di " + a.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		
		// agency from detached to persistent
		model.addAttribute("listaLinee", a.getRoutes());
		model.addAttribute("route", new Route());
		
		return "route";
	}
	
	// chiamata quando clicco sul pulsante "Crea una linea"
	@RequestMapping(value = "/creaLinea", method = RequestMethod.GET)
	public String showCreateRouteForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("route", new Route());
		
		return "redirect:linee";
	}
	
	// chiamata al submit del form per la creazione di una nuova linea
	@RequestMapping(value = "/linee", method = RequestMethod.POST)
	public String submitRouteForm(@ModelAttribute @Valid Route route, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della linea");
			agencyDAO.updateAgency(agency);
			model.addAttribute("listaLinee", agency.getRoutes());
			model.addAttribute("showCreateForm", true);
			return "route";
		}
		
		for (Route r: routeDAO.getAllRoutes()) {
			if (r.getGtfsId().equals(route.getGtfsId())) {
				logger.error("L'id della linea è già presente");
				model.addAttribute("listaLinee", agency.getRoutes());
				model.addAttribute("showCreateForm", true);
				model.addAttribute("showAlertDuplicateRoute", true);
				return "route";
			}
		}
		
		a.addRoute(route);
		
		logger.info("Linea creata: " + route.getGtfsId() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("lineaAttiva", route);
		
		return "redirect:linee";
	}
	
	// chiamata quando seleziono una linea (verrà salvata nella sessione)
	@RequestMapping(value = "/selezionaLinea", method = RequestMethod.GET)
	public String selectRoute(@RequestParam("id") Integer routeId, Model model, HttpSession session) {
		Route route = routeDAO.getRoute(routeId);
		if (route == null) {
			return "redirect:linee";
		}
		
		logger.info("Linea selezionata: " + route.getGtfsId() + ".");
		
		session.removeAttribute("corsaAttiva");
		session.removeAttribute("servizioAttivo");
		session.setAttribute("lineaAttiva", route);
		
		return "redirect:linee";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaLinea", method = RequestMethod.GET)
	public String deleteRoute(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		a.getRoutes().remove(route);
		
		logger.info("Linea eliminata: " + route.getGtfsId() + ".");
		
		session.removeAttribute("lineaAttiva");
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:linee";
	}
	
	// chiamata quando clicco sul pulsante "Modifica linea"
	@RequestMapping(value = "/modificaLinea", method = RequestMethod.GET)
	public String showEditRouteForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("route", route);
		
		return "redirect:linee";
	}
	
	// chiamata al submit del form per la modifica di una linea
	@RequestMapping(value = "/modificaLinea", method = RequestMethod.POST)
	public String editRoute(@ModelAttribute @Valid Route route, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica della linea");
			agencyDAO.updateAgency(agency);
			model.addAttribute("listaLinee", agency.getRoutes());
			model.addAttribute("showEditForm", true);
			return "route";
		}
		
		Route activeRoute = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		for (Route r: routeDAO.getAllRoutes()) {
			if (!activeRoute.getGtfsId().equals(route.getGtfsId()) && r.getGtfsId().equals(route.getGtfsId())) {
				logger.error("L'id della linea è già presente");
				model.addAttribute("listaLinee", agency.getRoutes());
				model.addAttribute("showEditForm", true);
				model.addAttribute("showAlertDuplicateRoute", true);
				return "route";
			}
		}
		
		// cerco la linea attiva tra quelle dell'agenzia e la aggiorno
		for (Route r: a.getRoutes()) {
			if (r.equals(activeRoute)) {
				r.setGtfsId(route.getGtfsId());
				r.setShortName(route.getShortName());
				r.setLongName(route.getLongName());
				r.setDescription(route.getDescription());
				r.setType(route.getType());
				r.setUrl(route.getUrl());
				r.setColor(route.getColor());
				r.setTextColor(route.getTextColor());
				logger.info("Linea modificata: " + r.getGtfsId() + ".");
				session.setAttribute("lineaAttiva", r);
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:linee";
	}
}
