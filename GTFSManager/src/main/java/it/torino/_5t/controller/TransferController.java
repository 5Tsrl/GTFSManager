package it.torino._5t.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.CalendarDAO;
import it.torino._5t.dao.StopDAO;
import it.torino._5t.dao.TransferDAO;
import it.torino._5t.entity.Stop;
import it.torino._5t.entity.Transfer;

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
public class TransferController {
	private static final Logger logger = LoggerFactory.getLogger(TransferController.class);
	
//	@Autowired
//	private AgencyDAO agencyDAO;
	@Autowired
	private CalendarDAO calendarDAO;
	@Autowired
	private StopDAO stopDAO;
	@Autowired
	private TransferDAO transferDAO;

	@RequestMapping(value = "/trasferimenti", method = RequestMethod.GET)
	public String showTransfers(Model model, HttpSession session) {
//		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
//		if (agency == null) {
//			return "redirect:agenzie";
//		}
//		agencyDAO.updateAgency(agency);
//		
//		logger.info("Visualizzazione lista trasferimenti di " + agency.getName() + ".");
		
		model.addAttribute("listaTrasferimenti", transferDAO.getAllTransfers());
		model.addAttribute("listaFermate", stopDAO.getAllStops());
		model.addAttribute("transfer", new Transfer());
		
		return "transfer";
	}
	
	// chiamata quando clicco sul pulsante "Crea una trasferimento"
	@RequestMapping(value = "/creaTrasferimento", method = RequestMethod.GET)
	public String showCreateTransferForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("transfer", new Transfer());
		
		return "redirect:trasferimenti";
	}
	
	// chiamata al submit del form per la creazione di un nuovo trasferimento
	@RequestMapping(value = "/trasferimenti", method = RequestMethod.POST)
	public String submitTransferForm(@ModelAttribute @Valid Transfer transfer, BindingResult bindingResult, @RequestParam("fromStopId") Integer fromStopId, @RequestParam("toStopId") Integer toStopId, Model model, HttpSession session) {
//		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
//		if (agency == null) {
//			return "redirect:agenzie";
//		}
//		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione del trasferimento");
			model.addAttribute("listaTrasferimenti", transferDAO.getAllTransfers());
			model.addAttribute("listaFermate", stopDAO.getAllStops());
			model.addAttribute("showCreateForm", true);
			return "transfer";
		}
		
		Stop fromStop = stopDAO.getStop(fromStopId);
		fromStop.addFromStopTransfer(transfer);
		Stop toStop = stopDAO.getStop(toStopId);
		toStop.addToStopTransfer(transfer);
		transferDAO.addTransfer(transfer);
		
		logger.info("Trasferimento creato da " + transfer.getFromStop().getName() + " a " + transfer.getToStop().getName() + ".");
		
//		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("trasferimentoAttivo", transfer);
		
		return "redirect:trasferimenti";
	}
	
	// chiamata quando seleziono un trasferimento (verrà salvato nella sessione)
	@RequestMapping(value = "/selezionaTrasferimento", method = RequestMethod.GET)
	public String selectTransfer(@RequestParam("id") Integer transferId, RedirectAttributes redirectAttributes, HttpSession session) {
//		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
//		if (agency == null) {
//			return "redirect:agenzie";
//		}
//		agencyDAO.updateAgency(agency);
		
		Transfer transfer = transferDAO.getTransfer(transferId);
		
		logger.info("Trasferimento selezionato: da " + transfer.getFromStop().getName() + " a " + transfer.getToStop().getName() + ".");
		
		redirectAttributes.addFlashAttribute("listaCalendari", calendarDAO.getAllCalendars());

		session.setAttribute("trasferimentoAttivo", transfer);
		
		return "redirect:trasferimenti";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaTrasferimento", method = RequestMethod.GET)
	public String deleteTransfer(Model model, HttpSession session) {
//		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
//		if (agency == null) {
//			return "redirect:agenzie";
//		}
//		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Transfer transfer = (Transfer) session.getAttribute("trasferimentoAttivo");
		if (transfer == null) {
			return "redirect:trasferimenti";
		}
		
		// rimuovo la trasferimento dal set associato alle fermate di partenza e arrivo
		Stop fromStop = stopDAO.getStop(transfer.getFromStop().getId());
		Stop toStop = stopDAO.getStop(transfer.getToStop().getId());
		for (Stop s: stopDAO.getAllStops()) {
			if (s.equals(fromStop)) {
				s.getFromStopTransfers().remove(transfer);
			}
			if (s.equals(toStop)) {
				s.getFromStopTransfers().remove(transfer);
			}
		}
		
		transferDAO.deleteTransfer(transfer);
		
		logger.info("Trasferimento eliminata: da " + transfer.getFromStop().getName() + " a " + transfer.getToStop().getName() + ".");
		
		session.removeAttribute("trasferimentoAttivo");
//		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:trasferimenti";
	}
	
	// chiamata quando clicco sul pulsante "Modifica trasferimento"
	@RequestMapping(value = "/modificaTrasferimento", method = RequestMethod.GET)
	public String showEditTransferForm(RedirectAttributes redirectAttributes, HttpSession session) {
//		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
//		if (agency == null) {
//			return "redirect:agenzie";
//		}
//		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Transfer transfer = (Transfer) session.getAttribute("trasferimentoAttivo");
		if (transfer == null) {
			return "redirect:trasferimenti";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("transfer", transfer);
		redirectAttributes.addFlashAttribute("listaFermate", stopDAO.getAllStops());
		
		return "redirect:trasferimenti";
	}
	
	// chiamata al submit del form per la modifica di un trasferimento
	@RequestMapping(value = "/modificaTrasferimento", method = RequestMethod.POST)
	public String editTransfer(@ModelAttribute @Valid Transfer transfer, BindingResult bindingResult, @RequestParam("fromStopId") Integer fromStopId, @RequestParam("toStopId") Integer toStopId, Model model, HttpSession session) {
//		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
//		if (agency == null) {
//			return "redirect:agenzie";
//		}
//		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica del trasferimento");
			model.addAttribute("listaTrasferimenti", transferDAO.getAllTransfers());
			model.addAttribute("listaFermate", stopDAO.getAllStops());
			model.addAttribute("showEditForm", true);
			return "transfer";
		}
		
		Transfer activetransfer = (Transfer) session.getAttribute("trasferimentoAttivo");
		if (activetransfer == null) {
			return "redirect:trasferimenti";
		}
		
		Stop fromStop = stopDAO.getStop(fromStopId);
		Stop toStop = stopDAO.getStop(toStopId);
		
		// cerco tra i trasferimenti dell'agenzia quello attivo e lo aggiorno
		for (Transfer t: transferDAO.getAllTransfers()) {
			if (t.equals(activetransfer)) {
				t.setTransferType(transfer.getTransferType());
				t.setMinTransferTime(transfer.getMinTransferTime());
				for (Stop s: stopDAO.getAllStops()) {
					if (s.equals(fromStop)) {
						s.getFromStopTransfers().remove(activetransfer);
						s.addFromStopTransfer(t);
					}
					if (s.equals(toStop)) {
						s.getToStopTransfers().remove(activetransfer);
						s.addToStopTransfer(t);
					}
				}
				logger.info("Trasferimento modificato: da " + t.getFromStop().getName() + " a " + t.getToStop().getName() + ".");
				session.setAttribute("trasferimentoAttivo", t);
				break;
			}
		}
		
//		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:trasferimenti";
	}
}
