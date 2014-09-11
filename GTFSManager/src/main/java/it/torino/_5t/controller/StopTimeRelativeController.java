package it.torino._5t.controller;

import java.sql.Time;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.ShapeDAO;
import it.torino._5t.dao.StopDAO;
import it.torino._5t.dao.TripPatternDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Route;
import it.torino._5t.entity.Shape;
import it.torino._5t.entity.Stop;
import it.torino._5t.entity.StopTimeRelative;
import it.torino._5t.entity.TripPattern;

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
public class StopTimeRelativeController {
	private static final Logger logger = LoggerFactory.getLogger(StopTimeRelativeController.class);
	
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private TripPatternDAO tripPatternDAO;
	@Autowired
	private StopDAO stopDAO;
	@Autowired
	private ShapeDAO shapeDAO;
	
	private boolean modify = false;
	
	@RequestMapping(value = "/fermateSchemaCorsa", method = RequestMethod.GET)
	public String showStopTimes(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		TripPattern tp = tripPatternDAO.getTripPattern(tripPattern.getId());
		
		logger.info("Visualizzazione fermate di " + tp.getGtfsId());
		
		Set<Stop> stops = new HashSet<Stop>(a.getStops());
		for (StopTimeRelative str: tp.getStopTimeRelatives()) {
			stops.remove(str.getStop());
		}
		
		model.addAttribute("listaFermate", stops);
		model.addAttribute("listaFermateCorsa", tp.getStopTimeRelatives());
		if (!modify && tp.getStopTimeRelatives().size() > 0) {
			model.addAttribute("lat", tp.getStopTimeRelatives().iterator().next().getStop().getLat());
			model.addAttribute("lon", tp.getStopTimeRelatives().iterator().next().getStop().getLon());
			model.addAttribute("zoom", 14);
		} else
			modify = false;
		if (tp.getShape() != null) {
			model.addAttribute("shapeAttivo", tp.getShape());
		}
		model.addAttribute("stopTimeRelative", new StopTimeRelative());
		model.addAttribute("shape", new Shape());
		
		return "stopTimeRelative";
	}
	
	// chiamata al submit del form per l'associazione di una corsa a una fermata
	@RequestMapping(value = "/fermateSchemaCorsa", method = RequestMethod.POST)
	public String submitStopTimeForm(@ModelAttribute @Valid StopTimeRelative stopTimeRelative, BindingResult bindingResult, @RequestParam("arrival") String arrivalTime, @RequestParam("departure") String departureTime, @RequestParam("stopId") Integer stopId, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione dell'associazione tra corsa e fermata");
			agencyDAO.updateAgency(agency);
			Set<Stop> stops = new HashSet<Stop>(a.getStops());
			for (StopTimeRelative str: tripPattern.getStopTimeRelatives()) {
				stops.remove(str.getStop());
			}
			model.addAttribute("listaFermate", stops);
			model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
			model.addAttribute("stopTimeRelative", new StopTimeRelative());
			model.addAttribute("shape", new Shape());
			return "stopTimeRelative";
		}
		
		String[] arrivalT = arrivalTime.split(":");
		Time arrival = new Time(Integer.parseInt(arrivalT[0]), Integer.parseInt(arrivalT[1]), 0);
		stopTimeRelative.setRelativeArrivalTime(arrival);
		String[] departureT = departureTime.split(":");
		Time departure = new Time(Integer.parseInt(departureT[0]), Integer.parseInt(departureT[1]), 0);
		stopTimeRelative.setRelativeDepartureTime(departure);
		
		stopTimeRelative.setStopSequence(tripPattern.getStopTimeRelatives().size() + 1);

		Stop activeStop = stopDAO.getStop(stopId);
		
		// cerco la fermata da modificare tra quelle dell'agenzia e le aggiungo l'associazione con la corsa
		for (Stop s: a.getStops()) {
			if (s.equals(activeStop)) {
				s.addStopTimeRelative(stopTimeRelative);
			}
		}
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le aggiungo la fermata
				for (TripPattern tp: r.getTripPatterns()) {
					logger.info("--->" + tp.getId() + " " + tripPattern.getId() + " -> " + tp.equals(tripPattern));
					if (tp.equals(tripPattern)) {
						tp.addStopTimeRelative(stopTimeRelative);
						session.setAttribute("schemaCorsaAttivo", tp);
						session.setAttribute("lineaAttiva", r);
						logger.info("Fermata " + stopTimeRelative.getStop().getName() + " associata alla corsa " + tp.getTripShortName());
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		redirectAttributes.addFlashAttribute("lat", activeStop.getLat());
		redirectAttributes.addFlashAttribute("lon", activeStop.getLon());
		redirectAttributes.addFlashAttribute("zoom", 16);
		
		modify = true;
		
		return "redirect:fermateSchemaCorsa";
	}
	
	// chiamata al submit del form per la modifica di un'associazione di una corsa a una fermata
	@RequestMapping(value = "/modificaFermataCorsa", method = RequestMethod.POST)
	public String editStopTimeForm(@ModelAttribute @Valid StopTimeRelative stopTimeRelative, BindingResult bindingResult, @RequestParam("arrival") String arrivalTime, @RequestParam("departure") String departureTime, @RequestParam("stopTimeId") Integer stopTimeId, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella modifica dell'associazione tra corsa e fermata");
			agencyDAO.updateAgency(agency);
			Set<Stop> stops = new HashSet<Stop>(a.getStops());
			for (StopTimeRelative str: tripPattern.getStopTimeRelatives()) {
				stops.remove(str.getStop());
			}
			model.addAttribute("listaFermate", stops);
			model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
			model.addAttribute("stopTimeRelative", new StopTimeRelative());
			model.addAttribute("shape", new Shape());
			return "stopTimeRelative";
		}
		
		String[] arrivalT = arrivalTime.split(":");
		Time arrival = new Time(Integer.parseInt(arrivalT[0]), Integer.parseInt(arrivalT[1]), 0);
		stopTimeRelative.setRelativeArrivalTime(arrival);
		String[] departureT = departureTime.split(":");
		Time departure = new Time(Integer.parseInt(departureT[0]), Integer.parseInt(departureT[1]), 0);
		stopTimeRelative.setRelativeDepartureTime(departure);
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le modifico l'associazione
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(tripPattern)) {
						for (StopTimeRelative str: tp.getStopTimeRelatives()) {
							if (str.getId().equals(stopTimeId)) {
								StopTimeRelative activeStopTime = str;
								int precedentStopSequence = str.getStopSequence();
								str.setRelativeArrivalTime(stopTimeRelative.getRelativeArrivalTime());
								str.setRelativeDepartureTime(stopTimeRelative.getRelativeDepartureTime());
								str.setStopSequence(stopTimeRelative.getStopSequence());
								str.setStopHeadsign(stopTimeRelative.getStopHeadsign());
								str.setPickupType(stopTimeRelative.getPickupType());
								str.setDropOffType(stopTimeRelative.getDropOffType());
								// cerco la fermata da modificare tra quelle dell'agenzia e le rimuovo l'associazione con la corsa
								for (Stop s: a.getStops()) {
									if (s.getId().equals(str.getStop().getId())) {
										s.getStopTimeRelatives().remove(activeStopTime);
										s.addStopTimeRelative(str);
										redirectAttributes.addFlashAttribute("lat", s.getLat());
										redirectAttributes.addFlashAttribute("lon", s.getLon());
										modify = true;
										break;
									}
								}
								if (stopTimeRelative.getStopSequence() < precedentStopSequence) {
									// se il nuovo numero di fermata è minore di quello precedente -> bisogna incrementare il numero per gli stopTimeRelative con stopSequence >= del nuovo numero e < del numero precedente
									//logger.info("--->Nuovo stopSequence < precedente");
									for (StopTimeRelative st1: tp.getStopTimeRelatives()) {
										//logger.info("--->st1.stopSequence="+st1.getStopSequence()+" stopTimeRelative.stopSequence="+stopTimeRelative.getStopSequence()+" activeStopTime.stopSequence="+precedentStopSequence+" not equals="+!st1.equals(str));
										if (st1.getStopSequence() >= stopTimeRelative.getStopSequence() && st1.getStopSequence() < precedentStopSequence && !st1.equals(str)) {
											st1.setStopSequence(st1.getStopSequence() + 1);
											//logger.info("---->stopSequence incrementato per " + st1.getStop().getName());
										}
									}
								} else {
									// se il nuovo numero di fermata è maggiore di quello precedente -> bisogna decrementare il numero per gli stopTimeRelative con stopSequence <= del nuovo numero e > del numero precedente
									//logger.info("--->Nuovo stopSequence > precedente");
									for (StopTimeRelative st1: tp.getStopTimeRelatives()) {
										//logger.info("--->st1.stopSequence="+st1.getStopSequence()+" stopTimeRelative.stopSequence="+stopTimeRelative.getStopSequence()+" activeStopTime.stopSequence="+precedentStopSequence+" not equals="+!st1.equals(str));
										if (st1.getStopSequence() <= stopTimeRelative.getStopSequence() && st1.getStopSequence() > precedentStopSequence && !st1.equals(str)) {
											st1.setStopSequence(st1.getStopSequence() - 1);
											//logger.info("---->stopSequence decrementato per " + st1.getStop().getName());
										}
									}
								}
								session.setAttribute("schemaCorsaAttivo", tp);
								session.setAttribute("lineaAttiva", r);
								logger.info("Fermata " + activeStopTime.getStop().getName() + " della corsa " + tp.getTripShortName() + " aggiornata.");
								break;
							}
						}
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
				
		return "redirect:fermateSchemaCorsa";
	}
	
	// chiamata al submit del form per il salvataggio di uno shape
	@RequestMapping(value = "/creaShape", method = RequestMethod.POST)
	public String submitShapeForm(@ModelAttribute @Valid Shape shape, BindingResult bindingResult, @RequestParam("shapeId") Integer shapeId, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione dello shape");
			agencyDAO.updateAgency(agency);
			Set<Stop> stops = new HashSet<Stop>(a.getStops());
			for (StopTimeRelative str: tripPattern.getStopTimeRelatives()) {
				stops.remove(str.getStop());
			}
			model.addAttribute("listaFermate", stops);
			model.addAttribute("listaFermateCorsa", tripPattern.getStopTimeRelatives());
			model.addAttribute("stopTimeRelative", new StopTimeRelative());
			model.addAttribute("shape", new Shape());
			return "stopTimeRelative";
		}
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le aggiungo lo shape
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(tripPattern)) {
						if (shapeId == -1) {
							// non è ancora stato associato nessuno shape alla corsa -> ne creo uno nuovo
							shape.addTripPattern(tp);
							a.addShape(shape);
							logger.info("Shape creato per la corsa " + tp.getTripShortName());
						} else {
							// c'è già uno shape associato alla corsa
							Shape sh = shapeDAO.loadShape(shapeId);
							// cerco tra gli shape dell'agenzia quello associato alla corsa attiva
							for (Shape s: a.getShapes()) {
								if (s.getId() == sh.getId()) {
									if (s.getTripPatterns().size() == 1) {
										// c'è una sola corsa associata allo shape -> aggiorno lo shape
										s.setEncodedPolyline(shape.getEncodedPolyline());
										tp.setShape(s);
										logger.info("Shape aggiornato per la corsa " + tp.getTripShortName());
									} else {
										// c'è più di una corsa associata allo shape -> creo uno shape nuovo
										s.getTripPatterns().remove(tripPattern);
										shape.addTripPattern(tp);
										a.addShape(shape);
										logger.info("Shape creato da shape precedente per la corsa " + tp.getTripShortName());
									}
									break;
								}
							}
						}
						redirectAttributes.addFlashAttribute("lat", tp.getStopTimeRelatives().iterator().next().getStop().getLat());
						redirectAttributes.addFlashAttribute("lon", tp.getStopTimeRelatives().iterator().next().getStop().getLon());
						redirectAttributes.addFlashAttribute("zoom", 14);
						session.setAttribute("schemaCorsaAttivo", tp);
						session.setAttribute("lineaAttiva", r);
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:fermateSchemaCorsa";
	}
	
	// chiamata quando clicco sul pulsante "Elimina"
	@RequestMapping(value = "/eliminaFermataCorsa", method = RequestMethod.GET)
	public String deleteRoute(RedirectAttributes redirectAttributes, @RequestParam("id") Integer id, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Route route = (Route) session.getAttribute("lineaAttiva");
		if (route == null) {
			return "redirect:linee";
		}
		
		TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo");
		if (tripPattern == null) {
			return "redirect:schemiCorse";
		}
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le elimino l'associazione
				for (TripPattern tp: r.getTripPatterns()) {
					if (tp.equals(tripPattern)) {
						StopTimeRelative stopTimeRelative = null;
						for (StopTimeRelative str: tp.getStopTimeRelatives()) {
							if (str.getId().equals(id)) {
								stopTimeRelative = str;
								// cerco la fermata da modificare tra quelle dell'agenzia e le rimuovo l'associazione con la corsa
								for (Stop s: a.getStops()) {
									if (s.getId().equals(str.getStop().getId())) {
										s.getStopTimeRelatives().remove(stopTimeRelative);
										redirectAttributes.addFlashAttribute("lat", s.getLat());
										redirectAttributes.addFlashAttribute("lon", s.getLon());
										modify = true;
									}
								}
							}
						}
						// in tutte le fermate successive bisogna decrementare lo stopSequence
						for (StopTimeRelative str: tp.getStopTimeRelatives()) {
							if (str.getStopSequence() > stopTimeRelative.getStopSequence()) {
								str.setStopSequence(str.getStopSequence() - 1);
							}
						}
						tp.getStopTimeRelatives().remove(stopTimeRelative);
						session.setAttribute("schemaCorsaAttivo", tp);
						session.setAttribute("lineaAttiva", r);
						logger.info("Fermata " + stopTimeRelative.getStop().getName() + " eliminata dalla corsa " + tp.getTripShortName());
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:fermateSchemaCorsa";
	}
}
