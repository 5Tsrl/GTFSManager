package it.torino._5t.controller;

import java.sql.Time;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.FrequencyDAO;
import it.torino._5t.dao.TripDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Frequency;
import it.torino._5t.entity.Route;
import it.torino._5t.entity.Trip;

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
public class FrequencyController {
	private static final Logger logger = LoggerFactory.getLogger(FrequencyController.class);
	
	@Autowired
	private FrequencyDAO frequencyDAO;
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private TripDAO tripDAO;
	
	@RequestMapping(value = "/servizi", method = RequestMethod.GET)
	public String showFrequencies(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		agencyDAO.updateAgency(agency);
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		Trip trip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		Trip t = tripDAO.loadTrip(trip.getId());
		
		logger.info("Visualizzazione lista servizi di " + trip.getTripShortName() + ".");
		
		model.addAttribute("listaServizi", t.getFrequencies());
		model.addAttribute("frequency", new Frequency());
		
		return "frequency";
	}
	
	// chiamata quando clicco sul pulsante "Crea una corsa"
	@RequestMapping(value = "/creaServizio", method = RequestMethod.GET)
	public String showCreateFrequencyForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("frequency", new Frequency());
		
		return "redirect:servizi";
	}
	
	// chiamata al submit del form per la creazione di un nuovo servizio
	@RequestMapping(value = "/servizi", method = RequestMethod.POST)
	public String submitFrequencyForm(@ModelAttribute @Valid Frequency frequency, BindingResult bindingResult, @RequestParam("start") String startTime, @RequestParam("end") String endTime, Model model, HttpSession session) {
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
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione del servizio");
			tripDAO.updateTrip(trip);
			model.addAttribute("listaServizi", trip.getFrequencies());
			model.addAttribute("showCreateForm", true);
			return "frequency";
		}
		
		String[] startT = startTime.split(":");
		Time start = new Time(Integer.parseInt(startT[0]), Integer.parseInt(startT[1]), 0);
		frequency.setStartTime(start);
		String[] endT = endTime.split(":");
		Time end = new Time(Integer.parseInt(endT[0]), Integer.parseInt(endT[1]), 0);
		frequency.setEndTime(end);
		
		// cerco tra le linee dell'agenzia quella attiva, la corsa attiva della linea selezionata e le aggiungo il servizio
		for (Route r: a.getRoutes()) {
			if (r.getId().equals(route.getId())) {
				for (Trip t: r.getTrips()) {
					if (t.getId().equals(trip.getId())) {
						t.addFrequency(frequency);
						session.setAttribute("servizioAttivo", frequency);
						session.setAttribute("corsaAttiva", t);
						session.setAttribute("lineaAttiva", r);
						session.setAttribute("agenziaAttiva", a);
						break;
					}
				}
				break;
			}
		}
		
		logger.info("Servizio creato dalle " + frequency.getStartTime() + " alle " + frequency.getEndTime() + ".");
		
		return "redirect:servizi";
	}
	
	// chiamata quando seleziono un servizio (verrà salvato nella sessione)
	@RequestMapping(value = "/selezionaServizio", method = RequestMethod.GET)
	public String selectFrequency(@RequestParam("id") Integer tripId, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		agencyDAO.updateAgency(agency);
		
		Frequency frequency = frequencyDAO.getFrequency(tripId);
		
		logger.info("Servizio selezionato: dalle " + frequency.getStartTime() + " alle " + frequency.getEndTime() + ".");
		
		session.setAttribute("servizioAttivo", frequency);
		
		return "redirect:servizi";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaServizio", method = RequestMethod.GET)
	public String deleteFrequency(Model model, HttpSession session) {
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
		
		Frequency frequency = (Frequency) session.getAttribute("servizioAttivo");
		if (frequency == null) {
			return "redirect:servizi";
		}
		
		// cerco tra le linee dell'agenzia quella attiva, la corsa attiva della linea selezionata, il servizio attivo della corsa selezionata e la elimino
		for (Route r: a.getRoutes()) {
			if (r.getId().equals(route.getId())) {
				for (Trip t: r.getTrips()) {
					if (t.getId().equals(trip.getId())) {
						for (Frequency f: t.getFrequencies()) {
							if (f.getId().equals(frequency.getId())) {
								t.getFrequencies().remove(f);
								session.removeAttribute("servizioAttivo");
								session.setAttribute("corsaAttiva", t);
								session.setAttribute("lineaAttiva", r);
								session.setAttribute("agenziaAttiva", a);
								break;
							}
						}
						break;
					}
				}
				break;
			}
		}
		
		logger.info("Servizio eliminato: dalle " + frequency.getStartTime() + " alle " + frequency.getEndTime() + ".");
		
		return "redirect:servizi";
	}
	
	// chiamata quando clicco sul pulsante "Modifica servizio"
	@RequestMapping(value = "/modificaServizio", method = RequestMethod.GET)
	public String showEditFrequencyForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Frequency frequency = (Frequency) session.getAttribute("servizioAttivo");
		if (frequency == null) {
			return "redirect:servizi";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("frequency", frequency);
		
		return "redirect:servizi";
	}
	
	// chiamata al submit del form per la modifica di un servizio
	@RequestMapping(value = "/modificaServizio", method = RequestMethod.POST)
	public String editFrequency(@ModelAttribute @Valid Frequency frequency, BindingResult bindingResult, @RequestParam("start") String startTime, @RequestParam("end") String endTime, Model model, HttpSession session) {
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
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica del servizio");
			tripDAO.updateTrip(trip);
			model.addAttribute("listaServizi", trip.getFrequencies());
			model.addAttribute("showCreateForm", true);
			return "frequency";
		}

		String[] startT = startTime.split(":");
		Time start = new Time(Integer.parseInt(startT[0]), Integer.parseInt(startT[1]), 0);
		frequency.setStartTime(start);
		String[] endT = endTime.split(":");
		Time end = new Time(Integer.parseInt(endT[0]), Integer.parseInt(endT[1]), 0);
		frequency.setEndTime(end);
		
		Frequency activeFrequency = (Frequency) session.getAttribute("servizioAttivo");
		if (activeFrequency == null) {
			return "redirect:servizi";
		}
		
		// cerco tra le linee dell'agenzia quella attiva, tra le corse della linea selezionata quella attiva, tra i servizi della corsa selezionata quello attivo e lo aggiorno
		for (Route r: a.getRoutes()) {
			if (r.getId().equals(route.getId())) {
				for (Trip t: r.getTrips()) {
					if (t.getId().equals(trip.getId())) {
						for (Frequency f: t.getFrequencies()) {
							if (f.getId().equals(activeFrequency.getId())) {
								f.setStartTime(frequency.getStartTime());
								f.setEndTime(frequency.getEndTime());
								f.setHeadwaySecs(frequency.getHeadwaySecs());
								f.setExactTimes(frequency.getExactTimes());
								logger.info("Servizio modificato: dalle " + f.getStartTime() + " alle " + f.getEndTime() + ".");
								session.setAttribute("servizioAttivo", f);
								session.setAttribute("corsaAttiva", t);
								session.setAttribute("lineaAttiva", r);
								session.setAttribute("agenziaAttiva", a);
								break;
							}
						}
						break;
					}
				}
				break;
			}
		}

		return "redirect:servizi";
	}
}
