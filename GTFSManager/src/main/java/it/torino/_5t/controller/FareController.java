package it.torino._5t.controller;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.FareAttributeDAO;
import it.torino._5t.dao.FareRuleDAO;
import it.torino._5t.dao.RouteDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.FareAttribute;
import it.torino._5t.entity.FareRule;
import it.torino._5t.entity.Route;

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
public class FareController {
	private static final Logger logger = LoggerFactory.getLogger(FareController.class);
	
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private RouteDAO routeDAO;
	@Autowired
	private FareAttributeDAO fareAttributeDAO;
	@Autowired
	private FareRuleDAO fareRuleDAO;
	
	@RequestMapping(value = "/tariffe", method = RequestMethod.GET)
	public String showFareAttributes(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		// se c'è una tariffa attiva, la rendo persistent per poter accedere alla lista delle linee
		FareAttribute fareAttribute = (FareAttribute) session.getAttribute("tariffaAttiva");
		if (fareAttribute != null) {
			fareAttributeDAO.updateFareAttribute(fareAttribute);
			model.addAttribute("listaRegole", fareAttribute.getFareRules());
		}
		
		logger.info("Visualizzazione tariffe di " + agency.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		
		model.addAttribute("listaTariffe", a.getFareAttributes());
		model.addAttribute("listaLinee", a.getRoutes());
		model.addAttribute("fareAttribute", new FareAttribute());
		
		return "fare";
	}
	
	// chiamata quando clicco sul pulsante "Crea una tariffa"
	@RequestMapping(value = "/creaTariffa", method = RequestMethod.GET)
	public String showCreateFareAttributeForm(RedirectAttributes redirectAttributes, HttpSession session) {
		redirectAttributes.addFlashAttribute("showCreateForm", true);
		redirectAttributes.addFlashAttribute("fareAttribute", new FareAttribute());
		
		return "redirect:tariffe";
	}
	
	// chiamata al submit del form per la creazione di una nuova tariffa
	@RequestMapping(value = "/tariffe", method = RequestMethod.POST)
	public String submitFareAttributeForm(@ModelAttribute @Valid FareAttribute fareAttribute, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione della tariffa");
			model.addAttribute("listaTariffe", a.getFareAttributes());
			model.addAttribute("showCreateForm", true);
			return "fare";
		}
		
		a.addFareAttribute(fareAttribute);
		
		logger.info("Tariffa creata: " + fareAttribute.getName() + ".");
		
		session.setAttribute("agenziaAttiva", a);
		session.setAttribute("tariffaAttiva", fareAttribute);
		
		return "redirect:tariffe";
	}
	
	// chiamata quando seleziono una tariffa (verrà salvata nella sessione)
	@RequestMapping(value = "/selezionaTariffa", method = RequestMethod.GET)
	public String selectFareAttribute(@RequestParam("id") Integer fareAttributeId, Model model, HttpSession session) {
		FareAttribute fareAttribute = fareAttributeDAO.getFareAttribute(fareAttributeId);
		
		logger.info("Tariffa selezionata: " + fareAttribute.getName() + ".");
		
		session.removeAttribute("regolaLineaAttiva");
		session.setAttribute("tariffaAttiva", fareAttribute);
		
		return "redirect:tariffe";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaTariffa", method = RequestMethod.GET)
	public String deleteFareAttribute(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		FareAttribute fareAttribute = (FareAttribute) session.getAttribute("tariffaAttiva");
		if (fareAttribute == null) {
			return "redirect:tariffe";
		}
		
		a.getFareAttributes().remove(fareAttribute);
		
		logger.info("Tariffa eliminata: " + fareAttribute.getName() + ".");
		
		session.removeAttribute("tariffaAttiva");
		session.removeAttribute("regolaLineaAttiva");
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:tariffe";
	}
	
	// chiamata quando clicco sul pulsante "Modifica tariffa"
	@RequestMapping(value = "/modificaTariffa", method = RequestMethod.GET)
	public String showEditFareAttributeForm(RedirectAttributes redirectAttributes, HttpSession session) {
		FareAttribute fareAttribute = (FareAttribute) session.getAttribute("tariffaAttiva");
		if (fareAttribute == null) {
			return "redirect:tariffe";
		}
		
		redirectAttributes.addFlashAttribute("showEditForm", true);
		redirectAttributes.addFlashAttribute("fareAttribute", fareAttribute);
		
		return "redirect:tariffe";
	}
	
	// chiamata al submit del form per la modifica di una tariffa
	@RequestMapping(value = "/modificaTariffa", method = RequestMethod.POST)
	public String editFareAttribute(@ModelAttribute @Valid FareAttribute fareAttribute, BindingResult bindingResult, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica della tariffa");
			agencyDAO.updateAgency(agency);
			model.addAttribute("listaTariffe", agency.getFareAttributes());
			model.addAttribute("showEditForm", true);
			return "fare";
		}
		
		FareAttribute activeFareAttribute = (FareAttribute) session.getAttribute("tariffaAttiva");
		if (activeFareAttribute == null) {
			return "redirect:tariffe";
		}
		
		// cerco la tariffa attiva tra quelle dell'agenzia e la aggiorno
		for (FareAttribute f: a.getFareAttributes()) {
			if (f.equals(activeFareAttribute)) {
				f.setName(fareAttribute.getName());
				f.setPrice(fareAttribute.getPrice());
				f.setCurrencyType(fareAttribute.getCurrencyType());
				f.setPaymentMethod(fareAttribute.getPaymentMethod());
				f.setTransfers(fareAttribute.getTransfers());
				f.setTransferDuration(fareAttribute.getTransferDuration());
				logger.info("Tariffa modificata: " + f.getName() + ".");
				session.setAttribute("tariffaAttiva", f);
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:tariffe";
	}
	
	// chiamata al submit del form per la creazione di una nuova associazione con una linea
	@RequestMapping(value = "/creaRegolaLinea", method = RequestMethod.POST)
	public String submitFareRuleRouteForm(@RequestParam("routeId") Integer[] routeId, Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		FareAttribute fareAttribute = (FareAttribute) session.getAttribute("tariffaAttiva");
		if (fareAttribute == null) {
			return "redirect:tariffe";
		}
		FareAttribute fa = fareAttributeDAO.getFareAttribute(fareAttribute.getId());
		
		if (routeId.length == 0) {
			logger.error("Nessuna linea selezionata");
			model.addAttribute("listaTariffe", a.getFareAttributes());
			model.addAttribute("showCreateFareRuleForm", true);
			model.addAttribute("fareAttribute", new FareAttribute());
			model.addAttribute("listaRegole", fa.getFareRules());
			return "fare";
		}
		
		boolean addFareRule;
		// cerco la tariffa attiva tra quelle dell'agenzia
		for (FareAttribute f: a.getFareAttributes()) {
			if (f.equals(fareAttribute)) {
				// per tutte le linee che voglio aggiungere
				for (Integer rId: routeId) {
					addFareRule = true;
					Route route = routeDAO.getRoute(rId);
					// controllo se l'associazione esiste già
					for (FareRule fr: f.getFareRules()) {
						if (fr.getFareAttribute().getId() == f.getId() && fr.getRoute().getId() == route.getId()) {
							addFareRule = false;
						}
					}
					// se l'associazione non è ancora stata inserita la aggiungo
					if (addFareRule) {
						FareRule fareRule = new FareRule();
						f.addFareRule(fareRule);
						route.addFareRule(fareRule);
						session.setAttribute("tariffaAttiva", f);
						logger.info("Associazione creata per la tariffa " + fareRule.getFareAttribute().getName() + " con la linea " + fareRule.getRoute().getShortName() + ".");
					} else {
						logger.warn("Associazione già esistente per la tariffa " + f.getName() + " con la linea " + route.getShortName() + ".");
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:tariffe";
	}
	
	// chiamata quando clicco sul pulsante "Elimina associazione"
	@RequestMapping(value = "/eliminaRegolaLinea", method = RequestMethod.GET)
	public String deleteFareRuleRoute(Model model, HttpSession session, @RequestParam("id") Integer[] fareRuleId) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		FareAttribute fareAttribute = (FareAttribute) session.getAttribute("tariffaAttiva");
		if (fareAttribute == null) {
			return "redirect:tariffe";
		}
		
		// cerco tra le tariffe dell'agenzia quella attiva
		FareAttribute activeFareAttribute = null;
		for (FareAttribute f: a.getFareAttributes()) {
			if (f.equals(fareAttribute)) {
				activeFareAttribute = f;
				break;
			}
		}
		logger.info("ids: "+fareRuleId.length);
		// scorro su tutti gli id delle associazioni selezionate
		for (int i=0; i<fareRuleId.length; i++) {
			FareRule fareRule = fareRuleDAO.getFareRule(fareRuleId[i]);
			
			activeFareAttribute.getFareRules().remove(fareRule);
			
			// cerco tra le linee dell'agenzia quella attiva e le tolgo l'associazione selezionata
			for (Route r: a.getRoutes()) {
				if (r.equals(fareRule.getRoute())) {
					r.getFareRules().remove(fareRule);
					session.setAttribute("lineaAttiva", r);
					break;
				}
			}
			
			logger.info("Associazione eliminata tra la tariffa " + fareRule.getFareAttribute().getName() + " con la linea " + fareRule.getRoute().getShortName() + ".");
		}
		
		session.setAttribute("tariffaAttiva", activeFareAttribute);
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:tariffe";
	}
}
