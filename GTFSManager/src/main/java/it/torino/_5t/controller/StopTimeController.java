package it.torino._5t.controller;

import java.sql.Time;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.ShapeDAO;
import it.torino._5t.dao.StopDAO;
import it.torino._5t.dao.StopTimeDAO;
import it.torino._5t.dao.TripDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Route;
import it.torino._5t.entity.Shape;
import it.torino._5t.entity.Stop;
import it.torino._5t.entity.StopTime;
import it.torino._5t.entity.Trip;

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
public class StopTimeController {
	private static final Logger logger = LoggerFactory.getLogger(StopTimeController.class);
	
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private TripDAO tripDAO;
	@Autowired
	private StopDAO stopDAO;
	@Autowired
	private StopTimeDAO stopTimeDAO;
	@Autowired
	private ShapeDAO shapeDAO;
	
	private boolean modify = false;
	
	@RequestMapping(value = "/fermateCorse", method = RequestMethod.GET)
	public String showStopTimes(Model model, HttpSession session) {
		Agency agency = (Agency) session.getAttribute("agenziaAttiva");
		if (agency == null) {
			return "redirect:agenzie";
		}
		Agency a = agencyDAO.loadAgency(agency.getId());
		
		Trip trip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		Trip t = tripDAO.loadTrip(trip.getId());
		
		logger.info("Visualizzazione fermate di " + t.getTripShortName());
		
		Set<Stop> stops = new HashSet<Stop>(a.getStops());
		for (StopTime st: t.getStopTimes()) {
			stops.remove(st.getStop());
		}
		
		model.addAttribute("listaFermate", stops);
		model.addAttribute("listaFermateCorsa", t.getStopTimes());
		if (!modify && t.getStopTimes().size() > 0) {
			model.addAttribute("lat", t.getStopTimes().iterator().next().getStop().getLat());
			model.addAttribute("lon", t.getStopTimes().iterator().next().getStop().getLon());
			model.addAttribute("zoom", 14);
		} else
			modify = false;
		if (t.getShape() != null) {
			model.addAttribute("shapeAttivo", t.getShape());
		}
		model.addAttribute("stopTime", new StopTime());
		model.addAttribute("shape", new Shape());
		
		return "stopTime";
	}
	
	// chiamata al submit del form per l'associazione di una corsa a una fermata
	@RequestMapping(value = "/fermateCorse", method = RequestMethod.POST)
	public String submitStopTimeForm(@ModelAttribute @Valid StopTime stopTime, BindingResult bindingResult, @RequestParam("arrival") String arrivalTime, @RequestParam("departure") String departureTime, @RequestParam("stopId") Integer stopId, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
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
			logger.error("Errore nella creazione dell'associazione tra corsa e fermata");
			agencyDAO.updateAgency(agency);
			Set<Stop> stops = new HashSet<Stop>(a.getStops());
			for (StopTime st: trip.getStopTimes()) {
				stops.remove(st.getStop());
			}
			model.addAttribute("listaFermate", stops);
			model.addAttribute("listaFermateCorsa", trip.getStopTimes());
			model.addAttribute("stopTime", new StopTime());
			model.addAttribute("shape", new Shape());
			return "stopTime";
		}
		
		String[] arrivalT = arrivalTime.split(":");
		Time arrival = new Time(Integer.parseInt(arrivalT[0]), Integer.parseInt(arrivalT[1]), 0);
		stopTime.setArrivalTime(arrival);
		String[] departureT = departureTime.split(":");
		Time departure = new Time(Integer.parseInt(departureT[0]), Integer.parseInt(departureT[1]), 0);
		stopTime.setDepartureTime(departure);
		
		stopTime.setStopSequence(trip.getStopTimes().size() + 1);

		Stop activeStop = stopDAO.getStop(stopId);
		
		// cerco la fermata da modificare tra quelle dell'agenzia e le aggiungo l'associazione con la corsa
		for (Stop s: a.getStops()) {
			if (s.equals(activeStop)) {
				s.addStopTime(stopTime);
			}
		}
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le aggiungo la fermata
				for (Trip t: r.getTrips()) {
					logger.info("--->" + t.getId() + " " + trip.getId() + " -> " + t.equals(trip));
					if (t.equals(trip)) {
						t.addStopTime(stopTime);
						session.setAttribute("corsaAttiva", t);
						session.setAttribute("lineaAttiva", r);
						logger.info("Fermata " + stopTime.getStop().getName() + " associata alla corsa " + t.getTripShortName());
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
		
		return "redirect:fermateCorse";
	}
	
	// chiamata al submit del form per la modifica di un'associazione di una corsa a una fermata
	@RequestMapping(value = "/modificaFermataCorsa", method = RequestMethod.POST)
	public String editStopTimeForm(@ModelAttribute @Valid StopTime stopTime, BindingResult bindingResult, @RequestParam("arrival") String arrivalTime, @RequestParam("departure") String departureTime, @RequestParam("stopTimeId") Integer stopTimeId, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
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
			logger.error("Errore nella modifica dell'associazione tra corsa e fermata");
			agencyDAO.updateAgency(agency);
			Set<Stop> stops = new HashSet<Stop>(a.getStops());
			for (StopTime st: trip.getStopTimes()) {
				stops.remove(st.getStop());
			}
			model.addAttribute("listaFermate", stops);
			model.addAttribute("listaFermateCorsa", trip.getStopTimes());
			model.addAttribute("stopTime", new StopTime());
			model.addAttribute("shape", new Shape());
			return "stopTime";
		}
		
		String[] arrivalT = arrivalTime.split(":");
		Time arrival = new Time(Integer.parseInt(arrivalT[0]), Integer.parseInt(arrivalT[1]), 0);
		stopTime.setArrivalTime(arrival);
		String[] departureT = departureTime.split(":");
		Time departure = new Time(Integer.parseInt(departureT[0]), Integer.parseInt(departureT[1]), 0);
		stopTime.setDepartureTime(departure);
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le modifico l'associazione
				for (Trip t: r.getTrips()) {
					if (t.equals(trip)) {
						for (StopTime st: t.getStopTimes()) {
							if (st.getId().equals(stopTimeId)) {
								StopTime activeStopTime = st;
								int precedentStopSequence = st.getStopSequence();
								st.setArrivalTime(stopTime.getArrivalTime());
								st.setDepartureTime(stopTime.getDepartureTime());
								st.setStopSequence(stopTime.getStopSequence());
								st.setStopHeadsign(stopTime.getStopHeadsign());
								st.setPickupType(stopTime.getPickupType());
								st.setDropOffType(stopTime.getDropOffType());
								// cerco la fermata da modificare tra quelle dell'agenzia e le rimuovo l'associazione con la corsa
								for (Stop s: a.getStops()) {
									if (s.getId().equals(st.getStop().getId())) {
										s.getStopTimes().remove(activeStopTime);
										s.addStopTime(st);
										redirectAttributes.addFlashAttribute("lat", s.getLat());
										redirectAttributes.addFlashAttribute("lon", s.getLon());
										modify = true;
										break;
									}
								}
								if (stopTime.getStopSequence() < precedentStopSequence) {
									// se il nuovo numero di fermata è minore di quello precedente -> bisogna incrementare il numero per gli stopTime con stopSequence >= del nuovo numero e < del numero precedente
									//logger.info("--->Nuovo stopSequence < precedente");
									for (StopTime st1: t.getStopTimes()) {
										//logger.info("--->st1.stopSequence="+st1.getStopSequence()+" stopTime.stopSequence="+stopTime.getStopSequence()+" activeStopTime.stopSequence="+precedentStopSequence+" not equals="+!st1.equals(st));
										if (st1.getStopSequence() >= stopTime.getStopSequence() && st1.getStopSequence() < precedentStopSequence && !st1.equals(st)) {
											st1.setStopSequence(st1.getStopSequence() + 1);
											//logger.info("---->stopSequence incrementato per " + st1.getStop().getName());
										}
									}
								} else {
									// se il nuovo numero di fermata è maggiore di quello precedente -> bisogna decrementare il numero per gli stopTime con stopSequence <= del nuovo numero e > del numero precedente
									//logger.info("--->Nuovo stopSequence > precedente");
									for (StopTime st1: t.getStopTimes()) {
										//logger.info("--->st1.stopSequence="+st1.getStopSequence()+" stopTime.stopSequence="+stopTime.getStopSequence()+" activeStopTime.stopSequence="+precedentStopSequence+" not equals="+!st1.equals(st));
										if (st1.getStopSequence() <= stopTime.getStopSequence() && st1.getStopSequence() > precedentStopSequence && !st1.equals(st)) {
											st1.setStopSequence(st1.getStopSequence() - 1);
											//logger.info("---->stopSequence decrementato per " + st1.getStop().getName());
										}
									}
								}
								session.setAttribute("corsaAttiva", t);
								session.setAttribute("lineaAttiva", r);
								logger.info("Fermata " + activeStopTime.getStop().getName() + " della corsa " + t.getTripShortName() + " aggiornata.");
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
				
		return "redirect:fermateCorse";
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
		
		Trip trip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione dello shape");
			agencyDAO.updateAgency(agency);
			Set<Stop> stops = new HashSet<Stop>(a.getStops());
			for (StopTime st: trip.getStopTimes()) {
				stops.remove(st.getStop());
			}
			model.addAttribute("listaFermate", stops);
			model.addAttribute("listaFermateCorsa", trip.getStopTimes());
			model.addAttribute("stopTime", new StopTime());
			model.addAttribute("shape", new Shape());
			return "stopTime";
		}
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le aggiungo lo shape
				for (Trip t: r.getTrips()) {
					if (t.equals(trip)) {
						if (shapeId == -1) {
							// non è ancora stato associato nessuno shape alla corsa -> ne creo uno nuovo
							shape.addTrip(t);
							a.addShape(shape);
							logger.info("Shape creato per la corsa " + t.getTripShortName());
						} else {
							// c'è già uno shape associato alla corsa
							Shape sh = shapeDAO.loadShape(shapeId);
							// cerco tra gli shape dell'agenzia quello associato alla corsa attiva
							for (Shape s: a.getShapes()) {
								if (s.getId() == sh.getId()) {
									if (s.getTrips().size() == 1) {
										// c'è una sola corsa associata allo shape -> aggiorno lo shape
										s.setEncodedPolyline(shape.getEncodedPolyline());
										t.setShape(s);
										logger.info("Shape aggiornato per la corsa " + t.getTripShortName());
									} else {
										// c'è più di una corsa associata allo shape -> creo uno shape nuovo
										s.getTrips().remove(trip);
										shape.addTrip(t);
										a.addShape(shape);
										logger.info("Shape creato da shape precedente per la corsa " + t.getTripShortName());
									}
									break;
								}
							}
						}
						redirectAttributes.addFlashAttribute("lat", t.getStopTimes().iterator().next().getStop().getLat());
						redirectAttributes.addFlashAttribute("lon", t.getStopTimes().iterator().next().getStop().getLon());
						redirectAttributes.addFlashAttribute("zoom", 14);
						session.setAttribute("corsaAttiva", t);
						session.setAttribute("lineaAttiva", r);
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:fermateCorse";
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
		
		Trip trip = (Trip) session.getAttribute("corsaAttiva");
		if (trip == null) {
			return "redirect:corse";
		}
		
		// cerco tra le linee dell'agenzia quella attiva
		for (Route r: a.getRoutes()) {
			if (r.equals(route)) {
				// tra le corse della linea quella attiva e le elimino l'associazione
				for (Trip t: r.getTrips()) {
					if (t.equals(trip)) {
						StopTime stopTime = null;
						for (StopTime st: t.getStopTimes()) {
							if (st.getId().equals(id)) {
								stopTime = st;
								// cerco la fermata da modificare tra quelle dell'agenzia e le rimuovo l'associazione con la corsa
								for (Stop s: a.getStops()) {
									if (s.getId().equals(st.getStop().getId())) {
										s.getStopTimes().remove(stopTime);
										redirectAttributes.addFlashAttribute("lat", s.getLat());
										redirectAttributes.addFlashAttribute("lon", s.getLon());
										modify = true;
									}
								}
							}
						}
						// in tutte le fermate successive bisogna decrementare lo stopSequence
						for (StopTime st: t.getStopTimes()) {
							if (st.getStopSequence() > stopTime.getStopSequence()) {
								st.setStopSequence(st.getStopSequence() - 1);
							}
						}
						t.getStopTimes().remove(stopTime);
						session.setAttribute("corsaAttiva", t);
						session.setAttribute("lineaAttiva", r);
						logger.info("Fermata " + stopTime.getStop().getName() + " eliminata dalla corsa " + t.getTripShortName());
						break;
					}
				}
				break;
			}
		}
		
		session.setAttribute("agenziaAttiva", a);
		
		return "redirect:fermateCorse";
	}
}
