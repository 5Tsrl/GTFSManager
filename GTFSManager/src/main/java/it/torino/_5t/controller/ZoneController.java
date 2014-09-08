package it.torino._5t.controller;

import java.util.HashSet;
import java.util.Set;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.ZoneDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.FareAttribute;
import it.torino._5t.entity.FareRule;
import it.torino._5t.entity.Zone;

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
public class ZoneController {
	private static final Logger logger = LoggerFactory.getLogger(ZoneController.class);

	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private ZoneDAO zoneDAO;
	
	@RequestMapping(value = "/zone", method = RequestMethod.GET)
	public String showZones(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		// se c'è una zona attiva, la rendo persistent per poter accedere alla lista delle fermate
		Zone zone = (Zone) session.getAttribute("zonaAttiva");
		if (zone != null) {
			zoneDAO.updateZone(zone);
			model.addAttribute("listaFermate", zone.getStops());
			Set<FareAttribute> faOrigin = new HashSet<FareAttribute>();
			for (FareRule fr: zone.getOriginFareRules()) {
				if (!faOrigin.contains(fr.getFareAttribute())) {
					faOrigin.add(fr.getFareAttribute());
				}
			}
			Set<FareAttribute> faDestination = new HashSet<FareAttribute>();
			for (FareRule fr: zone.getDestinationFareRules()) {
				if (!faDestination.contains(fr.getFareAttribute())) {
					faDestination.add(fr.getFareAttribute());
				}
			}
			model.addAttribute("listaTariffeOrigine", faOrigin);
			model.addAttribute("listaTariffeDestinazione", faDestination);
		}
		
		logger.info("Visualizzazione zone di " + agency.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		
		model.addAttribute("listaZone", a.getZones());
		model.addAttribute("zone", new Zone());
		
		return "zone";
	}
	
	// chiamata quando clicco sul pulsante "Crea una tariffa"
	@RequestMapping(value = "/creaZona", method = RequestMethod.GET)
	public String showCreateFareAttributeForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("zone", new Zone());
		
		return "redirect:zone";
	}
	
	// chiamata al submit del form per la creazione di una nuova zona
	@RequestMapping(value = "/zone", method = RequestMethod.POST)
	public String submitZoneForm(@ModelAttribute @Valid Zone zone, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della zona");
			model.addAttribute("listaZone", a.getZones());
			model.addAttribute("showCreateForm", true);
			Zone zon = (Zone) session.getAttribute("zonaAttiva");
			if (zon != null) {
				zoneDAO.updateZone(zon);
				model.addAttribute("listaFermate", zon.getStops());
				Set<FareAttribute> faOrigin = new HashSet<FareAttribute>();
				for (FareRule fr: zon.getOriginFareRules()) {
					if (!faOrigin.contains(fr.getFareAttribute())) {
						faOrigin.add(fr.getFareAttribute());
					}
				}
				Set<FareAttribute> faDestination = new HashSet<FareAttribute>();
				for (FareRule fr: zon.getDestinationFareRules()) {
					if (!faDestination.contains(fr.getFareAttribute())) {
						faDestination.add(fr.getFareAttribute());
					}
				}
				model.addAttribute("listaTariffeOrigine", faOrigin);
				model.addAttribute("listaTariffeDestinazione", faDestination);
			}
			return "zone";
		}
		
		for (Zone z: a.getZones()) {
			if (z.getGtfsId().equals(zone.getGtfsId())) {
				logger.error("L'id della zona è già presente");
				model.addAttribute("listaZone", a.getZones());
				model.addAttribute("showCreateForm", true);
				model.addAttribute("showAlertDuplicateZone", true);
				Zone zon = (Zone) session.getAttribute("zonaAttiva");
				if (zon != null) {
					zoneDAO.updateZone(zon);
					model.addAttribute("listaFermate", zon.getStops());
					Set<FareAttribute> faOrigin = new HashSet<FareAttribute>();
					for (FareRule fr: zon.getOriginFareRules()) {
						if (!faOrigin.contains(fr.getFareAttribute())) {
							faOrigin.add(fr.getFareAttribute());
						}
					}
					Set<FareAttribute> faDestination = new HashSet<FareAttribute>();
					for (FareRule fr: zon.getDestinationFareRules()) {
						if (!faDestination.contains(fr.getFareAttribute())) {
							faDestination.add(fr.getFareAttribute());
						}
					}
					model.addAttribute("listaTariffeOrigine", faOrigin);
					model.addAttribute("listaTariffeDestinazione", faDestination);
				}
				return "zone";
			}
		}
		
		a.addZone(zone);
		
		logger.info("Zona creata: " + zone.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("zonaAttiva", zone);
		
		return "redirect:zone";
	}
	
	// chiamata quando seleziono una zona (verrà salvata nella sessione)
	@RequestMapping(value = "/selezionaZona", method = RequestMethod.GET)
	public String selectZone(@RequestParam("id") Integer zoneId, Model model, HttpSession session) {
		Zone zone = zoneDAO.getZone(zoneId);
		
		logger.info("Zona selezionata: " + zone.getName() + ".");
		
		session.setAttribute("zonaAttiva", zone);
		
		return "redirect:zone";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaZona", method = RequestMethod.GET)
	public String deleteZoneAttribute(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Zone zone = (Zone) session.getAttribute("zonaAttiva");
		if (zone == null) {
			return "redirect:zone";
		}
		
		a.getZones().remove(zone);
		
		logger.info("Zona eliminata: " + zone.getGtfsId() + ".");
		
		session.removeAttribute("zonaAttiva");
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:zone";
	}
	
	// chiamata quando clicco sul pulsante "Modifica zona"
	@RequestMapping(value = "/modificaZona", method = RequestMethod.GET)
	public String showEditZoneForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Zone zone = (Zone) session.getAttribute("zonaAttiva");
		if (zone == null) {
			return "redirect:zone";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("zone", zone);
		
		return "redirect:zone";
	}
	
	// chiamata al submit del form per la modifica di una tariffa
	@RequestMapping(value = "/modificaZona", method = RequestMethod.POST)
	public String editFareAttribute(@ModelAttribute @Valid Zone zone, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica della zona");
			agencyDAO.updateAgency(agency);
			model.addAttribute("listaZone", agency.getZones());
			model.addAttribute("showEditForm", true);
			Zone zon = (Zone) session.getAttribute("zonaAttiva");
			if (zon != null) {
				zoneDAO.updateZone(zon);
				model.addAttribute("listaFermate", zon.getStops());
				Set<FareAttribute> faOrigin = new HashSet<FareAttribute>();
				for (FareRule fr: zon.getOriginFareRules()) {
					if (!faOrigin.contains(fr.getFareAttribute())) {
						faOrigin.add(fr.getFareAttribute());
					}
				}
				Set<FareAttribute> faDestination = new HashSet<FareAttribute>();
				for (FareRule fr: zon.getDestinationFareRules()) {
					if (!faDestination.contains(fr.getFareAttribute())) {
						faDestination.add(fr.getFareAttribute());
					}
				}
				model.addAttribute("listaTariffeOrigine", faOrigin);
				model.addAttribute("listaTariffeDestinazione", faDestination);
			}
			return "zone";
		}
		
		Zone activeZone = (Zone) session.getAttribute("zonaAttiva");
		if (activeZone == null) {
			return "redirect:zone";
		}
		
		for (Zone z: a.getZones()) {
			if (!activeZone.getGtfsId().equals(zone.getGtfsId()) && z.getGtfsId().equals(zone.getGtfsId())) {
				logger.error("L'id della zona è già presente");
				model.addAttribute("listaZone", a.getZones());
				model.addAttribute("showEditForm", true);
				model.addAttribute("showAlertDuplicateZone", true);
				Zone zon = (Zone) session.getAttribute("zonaAttiva");
				if (zon != null) {
					zoneDAO.updateZone(zon);
					model.addAttribute("listaFermate", zon.getStops());
					Set<FareAttribute> faOrigin = new HashSet<FareAttribute>();
					for (FareRule fr: zon.getOriginFareRules()) {
						if (!faOrigin.contains(fr.getFareAttribute())) {
							faOrigin.add(fr.getFareAttribute());
						}
					}
					Set<FareAttribute> faDestination = new HashSet<FareAttribute>();
					for (FareRule fr: zon.getDestinationFareRules()) {
						if (!faDestination.contains(fr.getFareAttribute())) {
							faDestination.add(fr.getFareAttribute());
						}
					}
					model.addAttribute("listaTariffeOrigine", faOrigin);
					model.addAttribute("listaTariffeDestinazione", faDestination);
				}
				return "zone";
			}
		}
		
		// cerco la tariffa attiva tra quelle dell'agenzia e la aggiorno
		for (Zone z: a.getZones()) {
			if (z.equals(activeZone)) {
				z.setGtfsId(zone.getGtfsId());
				z.setName(zone.getName());
				logger.info("Zona modificata: " + z.getGtfsId() + ".");
				session.setAttribute("zonaAttiva", z);
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:zone";
	}
}
