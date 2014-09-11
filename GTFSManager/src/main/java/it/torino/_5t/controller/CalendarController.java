package it.torino._5t.controller;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.CalendarDAO;
import it.torino._5t.dao.CalendarDateDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Calendar;
import it.torino._5t.entity.CalendarDate;
import it.torino._5t.entity.TripPattern;

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
public class CalendarController {
	private static final Logger logger = LoggerFactory.getLogger(CalendarController.class);
	
	@Autowired
	private CalendarDAO calendarDAO;
	@Autowired
	private CalendarDateDAO calendarDateDAO;
	@Autowired
	private AgencyDAO agencyDAO;
	
	private boolean modify = false;
	
	@RequestMapping(value = "/calendari", method = RequestMethod.GET)
	public String showCalendars(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		// se c'è un calendario attivo, lo rendo persistent per poter accedere alla lista delle corse
		Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo");
		if (calendar != null) {
			calendarDAO.updateCalendar(calendar);
			model.addAttribute("listaCorse", calendar.getTripPatterns());
			model.addAttribute("listaEccezioni", calendar.getCalendarDates());
		}
		
		logger.info("Visualizzazione calendari di " + agency.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		
		model.addAttribute("listaCalendari", a.getCalendars());
		if (!modify)
			model.addAttribute("calendar", new Calendar());
		else
			modify = false;
		model.addAttribute("calendarDate", new CalendarDate());
		
		return "calendar";
	}
	
	// chiamata quando clicco sul pulsante "Crea un calendario"
	@RequestMapping(value = "/creaCalendario", method = RequestMethod.GET)
	public String showCreateCalendarForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("calendar", new Calendar());
		
		return "redirect:calendari";
	}
	
	// chiamata al submit del form per la creazione di un nuovo calendario
	@RequestMapping(value = "/calendari", method = RequestMethod.POST)
	public String submitCalendarForm(@ModelAttribute @Valid Calendar calendar, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors() || calendar.getStartDate().after(calendar.getEndDate())) {
			logger.error("Errore nella creazione del calendario");
			model.addAttribute("listaCalendari", a.getCalendars());
			model.addAttribute("showCreateForm", true);
			model.addAttribute("calendarDate", new CalendarDate());
			Calendar cal = (Calendar) session.getAttribute("calendarioAttivo");
			if (cal != null) {
				calendarDAO.updateCalendar(cal);
				model.addAttribute("listaCorse", cal.getTripPatterns());
				model.addAttribute("listaEccezioni", cal.getCalendarDates());
			}
			if (calendar.getStartDate().after(calendar.getEndDate()))
				model.addAttribute("showAlertWrongCalendarDates", true);
			return "calendar";
		}
		
		for (Calendar c: calendarDAO.getCalendarsFromAgency(a)) {
			if (c.getGtfsId().equals(calendar.getGtfsId())) {
				logger.error("L'id del calendario è già presente");
				model.addAttribute("listaCalendari", a.getCalendars());
				model.addAttribute("showCreateForm", true);
				model.addAttribute("showAlertDuplicateCalendar", true);
				model.addAttribute("calendarDate", new CalendarDate());
				Calendar cal = (Calendar) session.getAttribute("calendarioAttivo");
				if (cal != null) {
					//calendarDAO.updateCalendar(cal);
					model.addAttribute("listaCorse", cal.getTripPatterns());
					model.addAttribute("listaEccezioni", cal.getCalendarDates());
				}
				if (calendar.getStartDate().after(calendar.getEndDate()))
					model.addAttribute("showAlertWrongCalendarDates", true);
				return "calendar";
			}
		}
		
		a.addCalendar(calendar);
		
		logger.info("Calendario creato: " + calendar.getGtfsId() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("calendarioAttivo", calendar);
		
		return "redirect:calendari";
	}
	
	// chiamata quando seleziono un calendario (verrà salvato nella sessione)
	@RequestMapping(value = "/selezionaCalendario", method = RequestMethod.GET)
	public String selectCalendar(@RequestParam("id") Integer calendarId, Model model, HttpSession session) {
		Calendar calendar = calendarDAO.getCalendar(calendarId);
		
		logger.info("Calendario selezionato: " + calendar.getGtfsId() + ".");
		
		session.removeAttribute("eccezioneAttiva");
		session.setAttribute("calendarioAttivo", calendar);
		
		return "redirect:calendari";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaCalendario", method = RequestMethod.GET)
	public String deleteCalendar(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo");
		if (calendar == null) {
			return "redirect:calendari";
		}
		Calendar c = calendarDAO.loadCalendar(calendar.getId());
		
		// per tutte le corse con questo calendario, setto calendar a null
		for (TripPattern tp: c.getTripPatterns()) {
			tp.setCalendar(null);
		}
		
		a.getCalendars().remove(c);
		
		logger.info("Calendario eliminato: " + calendar.getGtfsId() + ".");
		
		session.removeAttribute("calendarioAttivo");
		session.removeAttribute("eccezioneAttiva");
		
		return "redirect:calendari";
	}
	
	// chiamata quando clicco sul pulsante "Modifica calendario"
	@RequestMapping(value = "/modificaCalendario", method = RequestMethod.GET)
	public String showEditCalendarForm(RedirectAttributes redirectAttributes, HttpSession session) {
		Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo");
		if (calendar == null) {
			return "redirect:calendari";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("calendar", calendar);
		
		modify = true;
		
		return "redirect:calendari";
	}
	
	// chiamata al submit del form per la modifica di un calendario
	@RequestMapping(value = "/modificaCalendario", method = RequestMethod.POST)
	public String editCalendar(@ModelAttribute @Valid Calendar calendar, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors() || calendar.getStartDate().after(calendar.getEndDate())) {
			logger.error("Errore nella modifica del calendario");
			model.addAttribute("listaCalendari", a.getCalendars());
			model.addAttribute("showEditForm", true);
			model.addAttribute("calendarDate", new CalendarDate());
			Calendar cal = (Calendar) session.getAttribute("calendarioAttivo");
			if (cal != null) {
				calendarDAO.updateCalendar(cal);
				model.addAttribute("listaCorse", cal.getTripPatterns());
				model.addAttribute("listaEccezioni", cal.getCalendarDates());
			}
			if (calendar.getStartDate().after(calendar.getEndDate()))
				model.addAttribute("showAlertWrongCalendarDates", true);
			return "calendar";
		}
		
		Calendar activeCalendar = (Calendar) session.getAttribute("calendarioAttivo");
		if (activeCalendar == null) {
			return "redirect:calendari";
		}
		
		for (Calendar c: calendarDAO.getCalendarsFromAgency(a)) {
			if (!activeCalendar.getGtfsId().equals(calendar.getGtfsId()) && c.getGtfsId().equals(calendar.getGtfsId())) {
				logger.error("L'id del calendario è già presente");
				model.addAttribute("listaCalendari", a.getCalendars());
				model.addAttribute("showEditForm", true);
				model.addAttribute("showAlertDuplicateCalendar", true);
				model.addAttribute("calendarDate", new CalendarDate());
				Calendar cal = (Calendar) session.getAttribute("calendarioAttivo");
				if (cal != null) {
					//calendarDAO.updateCalendar(cal);
					model.addAttribute("listaCorse", cal.getTripPatterns());
					model.addAttribute("listaEccezioni", cal.getCalendarDates());
				}
				if (calendar.getStartDate().after(calendar.getEndDate()))
					model.addAttribute("showAlertWrongCalendarDates", true);
				return "calendar";
			}
		}
		
		// cerco il calendario attivo tra quelli dell'agenzia e lo aggiorno
		for (Calendar c: a.getCalendars()) {
			if (c.equals(activeCalendar)) {
				c.setGtfsId(calendar.getGtfsId());
				c.setStartDate(calendar.getStartDate());
				c.setEndDate(calendar.getEndDate());
				c.setMonday(calendar.isMonday());
				c.setTuesday(calendar.isTuesday());
				c.setWednesday(calendar.isWednesday());
				c.setThursday(calendar.isThursday());
				c.setFriday(calendar.isFriday());
				c.setSaturday(calendar.isSaturday());
				c.setSunday(calendar.isSunday());
				logger.info("Calendario modificato: " + c.getGtfsId() + ".");
				session.setAttribute("calendarioAttivo", c);
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:calendari";
	}
	
	// chiamata quando clicco sul pulsante "Crea un'eccezione"
	@RequestMapping(value = "/creaEccezione", method = RequestMethod.GET)
	public String showCreateCalendarDateForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateCalendarDateForm", true);
		redirectAttributes.addFlashAttribute("calendarDate", new CalendarDate());
		
		return "redirect:calendari";
	}
	
	// chiamata al submit del form per la creazione di una nuova eccezione
	@RequestMapping(value = "/creaEccezione", method = RequestMethod.POST)
	public String submitCalendarDateForm(@ModelAttribute @Valid CalendarDate calendarDate, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo");
		if (calendar == null) {
			return "redirect:calendari";
		}
		Calendar cal = calendarDAO.getCalendar(calendar.getId());
		
		if (bindingResult.hasErrors() || calendarDate.getDate().before(cal.getStartDate()) || calendarDate.getDate().after(cal.getEndDate())) {
			logger.error("Errore nella creazione dell'eccezione");
			model.addAttribute("listaCalendari", a.getCalendars());
			model.addAttribute("showCreateCalendarDateForm", true);
			model.addAttribute("calendar", new Calendar());
			model.addAttribute("listaCorse", cal.getTripPatterns());
			model.addAttribute("listaEccezioni", cal.getCalendarDates());
			model.addAttribute("showAlertWrongExceptionDate", true);
			return "calendar";
		}
		
		for (Calendar c: a.getCalendars()) {
			if (c.equals(calendar)){
				c.addCalendarDate(calendarDate);
				session.setAttribute("calendarioAttivo", c);
				break;
			}
		}
		
		logger.info("Eccezione creata: " + calendarDate.getDate() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("eccezioneAttiva", calendarDate);
		
		return "redirect:calendari";
	}
	
	// chiamata quando seleziono un'eccezione (verrà salvato nella sessione)
	@RequestMapping(value = "/selezionaEccezione", method = RequestMethod.GET)
	public String selectCalendarDate(@RequestParam("id") Integer calendarDateId, Model model, HttpSession session) {
		CalendarDate calendarDate = calendarDateDAO.getCalendarDate(calendarDateId);
		
		logger.info("Eccezione selezionata: " + calendarDate.getDate() + ".");
		
		session.setAttribute("eccezioneAttiva", calendarDate);
		
		return "redirect:calendari";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaEccezione", method = RequestMethod.GET)
	public String deleteCalendarDate(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo");
		CalendarDate calendarDate = (CalendarDate) session.getAttribute("eccezioneAttiva");
		if (calendar == null || calendarDate == null) {
			return "redirect:calendari";
		}
		
		// cerco tra i calendari dell'agenzia quello attivo e gli tolgo l'eccezione selezionata
		for (Calendar c: a.getCalendars()) {
			if (c.equals(calendar)){
				c.getCalendarDates().remove(calendarDate);
				session.setAttribute("calendarioAttivo", c);
				break;
			}
		}
		
		logger.info("Eccezione eliminata: " + calendarDate.getDate() + ".");
		
		session.removeAttribute("eccezioneAttiva");
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:calendari";
	}
	
	// chiamata quando clicco sul pulsante "Modifica eccezione"
	@RequestMapping(value = "/modificaEccezione", method = RequestMethod.GET)
	public String showEditCalendarDateForm(RedirectAttributes redirectAttributes, HttpSession session) {
		CalendarDate calendarDate = (CalendarDate) session.getAttribute("eccezioneAttiva");
		if (calendarDate == null) {
			return "redirect:calendari";
		}
		
		redirectAttributes.addFlashAttribute("showEditCalendarDateForm", true);
		redirectAttributes.addFlashAttribute("calendarDate", calendarDate);
		
		return "redirect:calendari";
	}
	
	// chiamata al submit del form per la modifica di un'eccezione
	@RequestMapping(value = "/modificaEccezione", method = RequestMethod.POST)
	public String editCalendarDate(@ModelAttribute @Valid CalendarDate calendarDate, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Calendar activeCalendar = (Calendar) session.getAttribute("calendarioAttivo");
		CalendarDate activeCalendarDate = (CalendarDate) session.getAttribute("eccezioneAttiva");
		if (activeCalendar == null || activeCalendarDate == null) {
			return "redirect:calendari";
		}
		
		if (bindingResult.hasErrors() || calendarDate.getDate().before(activeCalendar.getStartDate()) || calendarDate.getDate().after(activeCalendar.getEndDate())) {
			logger.error("Errore nella modifica dell'eccezione");
			model.addAttribute("listaCalendari", a.getCalendars());
			model.addAttribute("showCreateCalendarDateForm", true);
			model.addAttribute("calendar", new Calendar());
			model.addAttribute("listaCorse", activeCalendar.getTripPatterns());
			model.addAttribute("listaEccezioni", activeCalendar.getCalendarDates());
			model.addAttribute("showAlertWrongExceptionDate", true);
			return "calendar";
		}
		
		// cerco tra i calendari dell'agenzia quello attivo, tra le eccezioni del calendario selezionato quella attiva e la aggiorno
		outerloop:
		for (Calendar c: a.getCalendars()) {
			for (CalendarDate cd: c.getCalendarDates()) {
				if (cd.equals(activeCalendarDate)) {
					cd.setDate(calendarDate.getDate());
					cd.setExceptionType(calendarDate.getExceptionType());
					logger.info("Eccezione modificata: " + cd.getDate() + ".");
					session.setAttribute("calendarioAttivo", c);
					session.setAttribute("eccezioneAttiva", cd);
					break outerloop;
				}
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:calendari";
	}
}
