package it.torino._5t.controller;

import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.StopDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Stop;
import it.torino._5t.entity.Zone;

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
		
		Set<Stop> stations = new HashSet<Stop>();
		for (Stop s: a.getStops()) {
			if (s.getLocationType() == 1) {
				stations.add(s);
			}
		}
		model.addAttribute("listaStazioni", stations);
		model.addAttribute("listaZone", a.getZones());
		model.addAttribute("listaFermate", a.getStops());
		model.addAttribute("stop", new Stop());
		
		return "stop";
	}
	
	// chiamata al submit del form per la creazione di una nuova fermata
	@RequestMapping(value = "/fermate", method = RequestMethod.POST)
	public String submitStopForm(@ModelAttribute @Valid Stop stop, BindingResult bindingResult, @RequestParam("parentStationId") Integer parentStationId, @RequestParam("zoneId") Integer zoneId, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della fermata");
			agencyDAO.updateAgency(agency);
			Set<Stop> stations = new HashSet<Stop>();
			for (Stop s: a.getStops()) {
				if (s.getLocationType() == 1) {
					stations.add(s);
				}
			}
			model.addAttribute("listaStazioni", stations);
			model.addAttribute("listaZone", a.getZones());
			model.addAttribute("listaFermate", a.getStops());
			model.addAttribute("stop", new Stop());
			return "stop";
		}
		
		for (Stop s: stopDAO.getStopsFromAgency(a)) {
			if (s.getGtfsId().equals(stop.getGtfsId())) {
				logger.error("L'id della fermata è già presente");
				Set<Stop> stations = new HashSet<Stop>();
				for (Stop s1: a.getStops()) {
					if (s1.getLocationType() == 1) {
						stations.add(s1);
					}
				}
				model.addAttribute("listaStazioni", stations);
				model.addAttribute("listaZone", a.getZones());
				model.addAttribute("listaFermate", a.getStops());
				model.addAttribute("stop", new Stop());
				model.addAttribute("showAlertDuplicateStop", true);
				return "stop";
			}
		}
		
		// if it has a parent station, save the stop in the parent station children list
		if (parentStationId != null) {
			// unless it is not a station itself
			if (stop.getLocationType() == 1) {
				logger.error("Una stazione non può avere una stazione padre.");
				Set<Stop> stations = new HashSet<Stop>();
				for (Stop s1: a.getStops()) {
					if (s1.getLocationType() == 1) {
						stations.add(s1);
					}
				}
				model.addAttribute("listaStazioni", stations);
				model.addAttribute("listaZone", a.getZones());
				model.addAttribute("listaFermate", a.getStops());
				model.addAttribute("stop", new Stop());
				model.addAttribute("showAlertParentStation", true);
				return "stop";
			}
			for (Stop s: a.getStops()) {
				if (s.getId().equals(parentStationId)) {
					s.addChildStop(stop);
					break;
				}
			}
		}
		
		// if it is in a zone, save the stop in the zone stops list
		if (zoneId != null) {
			for (Zone z: a.getZones()) {
				if (z.getId().equals(zoneId)) {
					z.addStop(stop);
					break;
				}
			}
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
	public String editSop(@ModelAttribute @Valid Stop stop, BindingResult bindingResult, @RequestParam("id") Integer id, @RequestParam("parentStationId") Integer parentStationId, @RequestParam("zoneId") Integer zoneId, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica della fermata");
			agencyDAO.updateAgency(agency);
			Set<Stop> stations = new HashSet<Stop>();
			for (Stop s: a.getStops()) {
				if (s.getLocationType() == 1) {
					stations.add(s);
				}
			}
			model.addAttribute("listaStazioni", stations);
			model.addAttribute("listaZone", a.getZones());
			model.addAttribute("listaFermate", a.getStops());
			model.addAttribute("stop", new Stop());
			return "stop";
		}
		
		Stop activeStop = stopDAO.getStop(id);
		
		for (Stop s: stopDAO.getStopsFromAgency(a)) {
			if (!activeStop.getGtfsId().equals(stop.getGtfsId()) && s.getGtfsId().equals(stop.getGtfsId())) {
				logger.error("L'id della fermata è già presente");
				Set<Stop> stations = new HashSet<Stop>();
				for (Stop s1: a.getStops()) {
					if (s1.getLocationType() == 1) {
						stations.add(s1);
					}
				}
				model.addAttribute("listaStazioni", stations);
				model.addAttribute("listaZone", a.getZones());
				model.addAttribute("listaFermate", a.getStops());
				model.addAttribute("stop", new Stop());
				model.addAttribute("showAlertDuplicateStop", true);
				return "stop";
			}
		}
		
		// if it has a parent station, save the stop in the parent station children list
		if (parentStationId != null) {
			// unless it is not a station itself
			if (stop.getLocationType() == 1) {
				logger.error("Una stazione non può avere una stazione padre.");
				Set<Stop> stations = new HashSet<Stop>();
				for (Stop s1: a.getStops()) {
					if (s1.getLocationType() == 1) {
						stations.add(s1);
					}
				}
				model.addAttribute("listaStazioni", stations);
				model.addAttribute("listaZone", a.getZones());
				model.addAttribute("listaFermate", a.getStops());
				model.addAttribute("stop", new Stop());
				model.addAttribute("showAlertParentStation", true);
				return "stop";
			}
			//logger.info("------> Sì staz padre");
			// remove the stop from the previous parent station, if it had one
			if (activeStop.getParentStation() != null) {
				//logger.info("------> Aveva una staz: la elimino");
				for (Stop s: a.getStops()) {
					if (s.getId().equals(activeStop.getParentStation().getId())) {
						s.getStops().remove(activeStop);
						break;
					}
				}
			}
			for (Stop s: a.getStops()) {
				if (s.getId().equals(parentStationId)) {
					//logger.info("------> NUOVA staz padre aggiunta: " + s.getId() + " " + s.getName());
					s.addChildStop(stop);
					break;
				}
			}
		} else {
			// remove the stop from the previous parent station, if it had one
			//logger.info("------> NO staz padre");
			if (activeStop.getParentStation() != null) {
				//logger.info("------> Aveva una staz: la elimino");
				for (Stop s: a.getStops()) {
					if (s.getId().equals(activeStop.getParentStation().getId())) {
						s.getStops().remove(activeStop);
						break;
					}
				}
			}
		}
		// if it is in a zone, save the stop in the zone stops list
		if (zoneId != null) {
			// remove the stop from the previous zone, if it had one
			if (activeStop.getZone() != null) {
				for (Zone z: a.getZones()) {
					if (z.getId().equals(activeStop.getZone().getId())) {
						z.getStops().remove(activeStop);
						break;
					}
				}
			}
			for (Zone z: a.getZones()) {
				if (z.getId().equals(zoneId)) {
					z.addStop(stop);
					break;
				}
			}
		} else {
			// remove the stop from the previous zone, if it had one
			if (activeStop.getZone() != null) {
				for (Zone z: a.getZones()) {
					if (z.getId().equals(activeStop.getZone().getId())) {
						z.getStops().remove(activeStop);
						break;
					}
				}
			}
		}
				
		// cerco la fermata da modificare tra quelle dell'agenzia e la aggiorno
		for (Stop s: a.getStops()) {
			if (s.equals(activeStop)) {
				s.setGtfsId(stop.getGtfsId());
				s.setCode(stop.getCode());
				s.setName(stop.getName());
				s.setDesc(stop.getDesc());
				s.setLat(stop.getLat());
				s.setLon(stop.getLon());
				s.setZone(stop.getZone());
				s.setUrl(stop.getUrl());
				s.setLocationType(stop.getLocationType());
				s.setParentStation(stop.getParentStation());
				s.setTimezone(stop.getTimezone());
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
		
		// remove the stop from the parent station, if it had one
		if (stop.getParentStation() != null) {
			for (Stop s: a.getStops()) {
				if (s.getId().equals(stop.getParentStation().getId())) {
					s.getStops().remove(stop);
					break;
				}
			}
		}
		// remove the stop from the previous zone, if it had one
		if (stop.getZone() != null) {
			for (Zone z: a.getZones()) {
				if (z.getId().equals(stop.getZone().getId())) {
					z.getStops().remove(stop);
					break;
				}
			}
		}
		a.getStops().remove(stop);
		
		logger.info("Fermata eliminata: " + stop.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		
		redirectAttributes.addFlashAttribute("lat", stop.getLat());
		redirectAttributes.addFlashAttribute("lon", stop.getLon());
		
		return "redirect:fermate";
	}
}
