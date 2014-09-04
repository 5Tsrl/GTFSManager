package it.torino._5t.controller;

import java.util.Enumeration;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.entity.Agency;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

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
public class AgencyController {
	private static final Logger logger = LoggerFactory.getLogger(AgencyController.class);
	
	@Autowired
	private AgencyDAO agencyDAO;

	@RequestMapping(value = "/agenzie", method = RequestMethod.GET)
	public String showAgencies(Model model, HttpSession session) {
		logger.info("Visualizzazione lista agenzie.");
		
		model.addAttribute("listaAgenzie", agencyDAO.getAllAgencies());
		model.addAttribute("agency", new Agency());
		
		return "agency";
	}
	
	
	// chiamata al submit del form per la creazione di una nuova agenzia
	@RequestMapping(value = "/agenzie", method = RequestMethod.POST)
	public String submitAgencyForm(@ModelAttribute @Valid Agency agency, BindingResult bindingResult, Model model, HttpSession session) {
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione dell'agenzia");
			model.addAttribute("listaAgenzie", agencyDAO.getAllAgencies());
			model.addAttribute("showCreateForm", true);
			return "agency";
		}
		for (Agency a: agencyDAO.getAllAgencies()) {
			if (a.getGtfsId().equals(agency.getGtfsId())) {
				logger.error("L'id dell'agenzia è già presente");
				model.addAttribute("listaAgenzie", agencyDAO.getAllAgencies());
				model.addAttribute("showCreateForm", true);
				model.addAttribute("showAlertDuplicateAgency", true);
				return "agency";
			}
		}
		
		agencyDAO.addAgency(agency);
		
		logger.info("Agenzia creata: " + agency.getGtfsId() + ".");
		
		session.setAttribute("agenziaAttiva", agency);
		
		return "redirect:agenzie";
	}
	
	// chiamata quando clicco sul pulsante "Crea un'agenzia"
	@RequestMapping(value = "/creaAgenzia", method = RequestMethod.GET)
	public String showCreateAgencyForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("agency", new Agency());
		
		return "redirect:agenzie";
	}
	
	// chiamata quando clicco sul pulsante "Modifica agenzia"
	@RequestMapping(value = "/modificaAgenzia", method = RequestMethod.GET)
	public String showEditAgencyForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("agency", agency);
		
		return "redirect:agenzie";
	}
	
	// chiamata quando seleziono un'agenzia (verrà salvata nella sessione)
	@RequestMapping(value = "/selezionaAgenzia", method = RequestMethod.GET)
	public String selectAgency(@RequestParam("id") Integer agencyId, Model model, HttpSession session) {
		Agency agency = agencyDAO.getAgency(agencyId);
		
		logger.info("Agenzia selezionata: " + agency.getGtfsId() + ".");
		
		Enumeration attributes = session.getAttributeNames();
		while(attributes.hasMoreElements()) {
			session.removeAttribute((String) attributes.nextElement());
		}
		session.setAttribute("agenziaAttiva", agency);
		
		return "redirect:agenzie";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaAgenzia", method = RequestMethod.GET)
	public String deleteAgency(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		agencyDAO.deleteAgency(agency);
		
		logger.info("Agenzia eliminata: " + agency.getGtfsId() + ".");
		
		Enumeration attributes = session.getAttributeNames();
		while(attributes.hasMoreElements()) {
			session.removeAttribute((String) attributes.nextElement());
		}
		
		return "redirect:agenzie";
	}
	
	// chiamata al submit del form per la modifica di un'agenzia
	@RequestMapping(value = "/modificaAgenzia", method = RequestMethod.POST)
	public String editAgency(@ModelAttribute @Valid Agency agency, BindingResult bindingResult, Model model, HttpSession session) {
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica dell'agenzia");
			model.addAttribute("listaAgenzie", agencyDAO.getAllAgencies());
			model.addAttribute("showEditForm", true);
			return "agency";
		}
		
		Agency activeAgency = (Agency) session.getAttribute("agenziaAttiva");
		
		for (Agency a: agencyDAO.getAllAgencies()) {
			if (!activeAgency.getGtfsId().equals(agency.getGtfsId()) && a.getGtfsId().equals(agency.getGtfsId())) {
				logger.error("L'id dell'agenzia è già presente");
				model.addAttribute("listaAgenzie", agencyDAO.getAllAgencies());
				model.addAttribute("showEditForm", true);
				model.addAttribute("showAlertDuplicateAgency", true);
				return "agency";
			}
			if (a.getId().equals(activeAgency.getId())) {
				a.setGtfsId(agency.getGtfsId());
				a.setName(agency.getName());
				a.setUrl(agency.getUrl());
				a.setTimezone(agency.getTimezone());
				a.setLanguage(agency.getLanguage());
				a.setPhone(agency.getPhone());
				a.setFareUrl(agency.getFareUrl());
				logger.info("Agenzia modificata: " + a.getGtfsId() + ".");
				session.setAttribute("agenziaAttiva", a);
				break;
			}
		}
		
		return "redirect:agenzie";
	}
}
