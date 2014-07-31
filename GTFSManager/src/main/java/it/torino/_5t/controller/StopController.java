package it.torino._5t.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.StopDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Stop;

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
public class StopController {
	private static final Logger logger = LoggerFactory.getLogger(StopController.class);
	
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private StopDAO stopDAO;
	
	@RequestMapping(value = "/fermate", method = RequestMethod.GET)
	public String showStops(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		logger.info("Visualizzazione fermate di " + a.getGtfsId());
		
		session.setAttribute("agenziaAttiva", a);
		
		model.addAttribute("listaFermate", a.getStops());
		model.addAttribute("stop", new Stop());
		
		return "stop";
	}
	
	// chiamata al submit del form per la creazione di una nuova fermata
	@RequestMapping(value = "/fermate", method = RequestMethod.POST)
	public String submitStopForm(@ModelAttribute @Valid Stop stop, BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della fermata");
			agencyDAO.updateAgency(agency);
			model.addAttribute("listaFermate", a.getStops());
			model.addAttribute("stop", new Stop());
			return "stop";
		}
		
		a.addStop(stop);
		
		logger.info("Fermata creata: " + stop.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		
		redirectAttributes.addFlashAttribute("lat", stop.getLat());
		redirectAttributes.addFlashAttribute("lon", stop.getLon());
		
		return "redirect:fermate";
	}
	
	// chiamata al submit del form per la modifica di una linea
	@RequestMapping(value = "/modificaFermata", method = RequestMethod.POST)
	public String editSop(@ModelAttribute @Valid Stop stop, BindingResult bindingResult, @RequestParam("id") Integer id, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica della fermata");
			agencyDAO.updateAgency(agency);
			model.addAttribute("listaFermate", a.getStops());
			model.addAttribute("stop", new Stop());
			return "stop";
		}
		
		Stop activeStop = stopDAO.getStop(id);
		
		// cerco la fermata da modificare tra quelle dell'agenzia e la aggiorno
		for (Stop s: a.getStops()) {
			if (s.equals(activeStop)) {
				s.setCode(stop.getCode());
				s.setName(stop.getName());
				s.setDesc(stop.getDesc());
				s.setLat(stop.getLat());
				s.setLon(stop.getLon());
				s.setUrl(stop.getUrl());
				s.setLocationType(stop.getLocationType());
				//s.setTimezone(stop.getTimezone());
				s.setWheelchairBoarding(stop.getWheelchairBoarding());
				logger.info("Fermata modificata: " + s.getName() + ".");
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		redirectAttributes.addFlashAttribute("lat", stop.getLat());
		redirectAttributes.addFlashAttribute("lon", stop.getLon());
		
		return "redirect:fermate";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaFermata", method = RequestMethod.GET)
	public String deleteRoute(RedirectAttributes redirectAttributes, @RequestParam("id") Integer id, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Stop stop = stopDAO.getStop(id);
		
		a.getStops().remove(stop);
		
		logger.info("Fermata eliminata: " + stop.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		
		redirectAttributes.addFlashAttribute("lat", stop.getLat());
		redirectAttributes.addFlashAttribute("lon", stop.getLon());
		
		return "redirect:fermate";
	}
}
