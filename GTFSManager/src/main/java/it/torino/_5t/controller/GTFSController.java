package it.torino._5t.controller;

import it.torino._5t.dao.AgencyDAO;
import it.torino._5t.dao.CalendarDAO;
import it.torino._5t.dao.CalendarDateDAO;
import it.torino._5t.dao.FareAttributeDAO;
import it.torino._5t.dao.FareRuleDAO;
import it.torino._5t.dao.FeedInfoDAO;
import it.torino._5t.dao.FrequencyDAO;
import it.torino._5t.dao.RouteDAO;
import it.torino._5t.dao.ShapeDAO;
import it.torino._5t.dao.StopDAO;
import it.torino._5t.dao.StopTimeDAO;
import it.torino._5t.dao.TransferDAO;
import it.torino._5t.dao.TripDAO;
import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Calendar;
import it.torino._5t.entity.CalendarDate;
import it.torino._5t.entity.FareAttribute;
import it.torino._5t.entity.FareRule;
import it.torino._5t.entity.FeedInfo;
import it.torino._5t.entity.Frequency;
import it.torino._5t.entity.Route;
import it.torino._5t.entity.Shape;
import it.torino._5t.entity.Stop;
import it.torino._5t.entity.StopTime;
import it.torino._5t.entity.Transfer;
import it.torino._5t.entity.Trip;

import java.awt.geom.Point2D;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.sql.Date;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
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
import org.springframework.web.multipart.MultipartFile;

@Controller
public class GTFSController {
	private static final Logger logger = LoggerFactory.getLogger(GTFSController.class);
	
	private static final String AGENCY_FILE_NAME = "agency.txt";
	private static final String CALENDAR_FILE_NAME = "calendar.txt";
	private static final String CALENDAR_DATE_FILE_NAME = "calendar_dates.txt";
	private static final String FARE_ATTRIBUTE_FILE_NAME = "fare_attributes.txt";
	private static final String FARE_RULE_FILE_NAME = "fare_rules.txt";
	private static final String FEED_INFO_FILE_NAME = "feed_info.txt";
	private static final String FREQUENCY_FILE_NAME = "frequencies.txt";
	private static final String ROUTE_FILE_NAME = "routes.txt";
	private static final String SHAPE_FILE_NAME = "shapes.txt";
	private static final String STOP_FILE_NAME = "stops.txt";
	private static final String STOP_TIME_FILE_NAME = "stop_times.txt";
	private static final String TRANSFER_FILE_NAME = "transfers.txt";
	private static final String TRIP_FILE_NAME = "trips.txt";

	private static final String GTFS_HISTORY_DIR_NAME = "C:\\Users\\Andrea\\Documents\\Universita'\\Anno V\\Tesi\\GTFS\\GTFS history\\";
	
	private static final String AGENCY_HEADER = "agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_phone,agency_fare_url\n";
	private static final String CALENDAR_HEADER = "service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date\n";
	private static final String CALENDAR_DATE_HEADER = "service_id,date,exception_type\n";
	private static final String FARE_ATTRIBUTE_HEADER = "fare_id,price,currency_type,payment_method,transfers,transfer_duration\n";
	private static final String FARE_RULE_HEADER = "fare_id,route_id,origin_id,destination_id,contains_id\n";
	private static final String FEED_INFO_HEADER = "feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date,feed_version\n";
	private static final String FREQUENCY_HEADER = "trip_id,start_time,end_time,headway_secs,exact_times\n";
	private static final String ROUTE_HEADER = "route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color\n";
	private static final String SHAPE_HEADER = "shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled\n";
	private static final String STOP_HEADER = "stop_id,stop_code,stop_name,stop_desc,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station,stop_timezone,wheelchair_boarding\n";
	private static final String STOP_TIME_HEADER = "trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type,drop_off_type,shape_dist_traveled\n";
	private static final String TRANSFER_HEADER = "from_stop_id,to_stop_id,transfer_type,min_transfer_time\n";
	private static final String TRIP_HEADER = "route_id,service_id,trip_id,trip_headsign,trip_short_name,direction_id,block_id,shape_id,wheelchair_accessible,bikes_allowed\n";

	private File agencyOutputFile;
	private File calendarOutputFile;
	private File calendarDateOutputFile;
	private File fareAttributeOutputFile;
	private File fareRuleOutputFile;
	private File feedInfoOutputFile;
	private File frequencyOutputFile;
	private File routeOutputFile;
	private File shapeOutputFile;
	private File stopOutputFile;
	private File stopTimeOutputFile;
	private File transferOutputFile;
	private File tripOutputFile;
	
	private File GTFSzip;
	private String zipName;
	private String importedFileName;
	
	private OutputStream agencyOutput;
	private OutputStream calendarOutput;
	private OutputStream calendarDateOutput;
	private OutputStream fareAttributeOutput;
	private OutputStream fareRuleOutput;
	private OutputStream feedInfoOutput;
	private OutputStream frequencyOutput;
	private OutputStream routeOutput;
	private OutputStream shapeOutput;
	private OutputStream stopOutput;
	private OutputStream stopTimeOutput;
	private OutputStream transferOutput;
	private OutputStream tripOutput;
	
	@Autowired
	private AgencyDAO agencyDAO;
	@Autowired
	private CalendarDAO calendarDAO;
	@Autowired
	private CalendarDateDAO calendarDateDAO;
	@Autowired
	private FareAttributeDAO fareAttributeDAO;
	@Autowired
	private FareRuleDAO fareRuleDAO;
	@Autowired
	private FeedInfoDAO feedInfoDAO;
	@Autowired
	private FrequencyDAO frequencyDAO;
	@Autowired
	private RouteDAO routeDAO;
	@Autowired
	private ShapeDAO shapeDAO;
	@Autowired
	private StopDAO stopDAO;
	@Autowired
	private StopTimeDAO stopTimeDAO;
	@Autowired
	private TransferDAO transferDAO;
	@Autowired
	private TripDAO tripDAO;
	
	private FeedInfo currentFeedInfo;

	@RequestMapping(value = "/GTFS", method = RequestMethod.GET)
	public String showManageGTFS(Model model, HttpSession session) {
		logger.info("Visualizzazione pagina per esportazione GTFS.");
		
		model.addAttribute("listaGTFS", feedInfoDAO.getAllFeedInfos());
		model.addAttribute("feedInfo", new FeedInfo());
		
		return "manageGTFS";
	}
	
	@RequestMapping(value = "/scaricaGTFS", method = RequestMethod.GET)
	public String downloadGTFS(Model model, @RequestParam("id") Integer id, HttpSession session, HttpServletResponse response) {
		FeedInfo feedInfo = feedInfoDAO.getFeedInfo(id);
		
		String filename = feedInfo.getName() + ".zip";
		
		logger.info("Download " + filename);
		
		response.setContentType("application/zip");
		
		String headerKey = "Content-Disposition";
		String headerValue = String.format("attachment; filename=\"%s\"", filename);
		
		response.setHeader(headerKey, headerValue);
		
		FileInputStream input;
		try {
			File f = new File(GTFS_HISTORY_DIR_NAME + filename);
			input = new FileInputStream(f);
			OutputStream output = response.getOutputStream();
			IOUtils.copy(input, output);
			output.close();
			input.close();
			response.flushBuffer();
			logger.info(filename + " scaricato.");
		} catch (IOException e) {
			logger.error("Errore nel download del file " + filename);
			e.printStackTrace();
		}
		
		return null;
	}
	
	@RequestMapping(value = "/eliminaGTFS", method = RequestMethod.GET)
	public String deleteGTFS(Model model, @RequestParam("id") Integer[] gtfsId, HttpSession session) {
		for (int i=0; i<gtfsId.length; i++) {
			FeedInfo feedInfo = feedInfoDAO.getFeedInfo(gtfsId[i]);
			feedInfoDAO.deleteFeedInfo(feedInfo);
			File f = new File(GTFS_HISTORY_DIR_NAME + feedInfo.getName() + ".zip");
			f.delete();
			logger.info(feedInfo.getName() + " eliminato.");
		}
		
		return "redirect:GTFS";
	}
	
	@RequestMapping(value = "/creaGTFS", method = RequestMethod.POST)
	public String createGTFS(@ModelAttribute FeedInfo feedInfo, BindingResult bindingResult, Model model, HttpSession session) {
		if (bindingResult.hasErrors()) {
			logger.error("Errore nella creazione del GTFS");
			logger.error(bindingResult.getAllErrors().toString());
			model.addAttribute("listaGTFS", feedInfoDAO.getAllFeedInfos());
			model.addAttribute("feedInfo", new FeedInfo());
			return "manageGTFS";
		}
		
		if (feedInfo.getStartDate().toString().equals("1000-01-01"))
			feedInfo.setStartDate(null);
		if (feedInfo.getEndDate().toString().equals("1000-01-01"))
			feedInfo.setEndDate(null);
		
		currentFeedInfo = feedInfo;
		
		logger.info("Inizio creazione GTFS.");
		
		try {
			zipName = feedInfo.getName();
			initializeOutputStreams();
			fillOutputStreams();
			closeOutputStreams();
			createZipFile();
			feedInfoDAO.addFeedInfo(feedInfo);
		} catch (IOException e) {
			logger.error("Errore nella creazione del file " + zipName);
			e.printStackTrace();
		}
		
		return "redirect:GTFS";
	}
	
	private void initializeOutputStreams() throws IOException {
		agencyOutputFile = File.createTempFile("agency", ".txt");
		calendarOutputFile = File.createTempFile("calendar", ".txt");
		calendarDateOutputFile = File.createTempFile("calendar_dates", ".txt");
		fareAttributeOutputFile = File.createTempFile("fare_attributes", ".txt");
		fareRuleOutputFile = File.createTempFile("fare_rules", ".txt");
		feedInfoOutputFile = File.createTempFile("feed_info", ".txt");
		frequencyOutputFile = File.createTempFile("frequencies", ".txt");
		routeOutputFile = File.createTempFile("routes", ".txt");
		shapeOutputFile = File.createTempFile("shapes", ".txt");
		stopOutputFile = File.createTempFile("stops", ".txt");
		stopTimeOutputFile = File.createTempFile("stop_times", ".txt");
		transferOutputFile = File.createTempFile("transfers", ".txt");
		tripOutputFile = File.createTempFile("trips", ".txt");
		
		agencyOutput = new FileOutputStream(agencyOutputFile);
		agencyOutput.write(AGENCY_HEADER.getBytes());

		calendarOutput = new FileOutputStream(calendarOutputFile);
		calendarOutput.write(CALENDAR_HEADER.getBytes());

		calendarDateOutput = new FileOutputStream(calendarDateOutputFile);
		calendarDateOutput.write(CALENDAR_DATE_HEADER.getBytes());

		fareAttributeOutput = new FileOutputStream(fareAttributeOutputFile);
		fareAttributeOutput.write(FARE_ATTRIBUTE_HEADER.getBytes());

		fareRuleOutput = new FileOutputStream(fareRuleOutputFile);
		fareRuleOutput.write(FARE_RULE_HEADER.getBytes());
		
		feedInfoOutput = new FileOutputStream(feedInfoOutputFile);
		feedInfoOutput.write(FEED_INFO_HEADER.getBytes());

		frequencyOutput = new FileOutputStream(frequencyOutputFile);
		frequencyOutput.write(FREQUENCY_HEADER.getBytes());
		
		routeOutput = new FileOutputStream(routeOutputFile);
		routeOutput.write(ROUTE_HEADER.getBytes());
		
		shapeOutput = new FileOutputStream(shapeOutputFile);
		shapeOutput.write(SHAPE_HEADER.getBytes());
		
		stopOutput = new FileOutputStream(stopOutputFile);
		stopOutput.write(STOP_HEADER.getBytes());
		
		stopTimeOutput = new FileOutputStream(stopTimeOutputFile);
		stopTimeOutput.write(STOP_TIME_HEADER.getBytes());

		transferOutput = new FileOutputStream(transferOutputFile);
		transferOutput.write(TRANSFER_HEADER.getBytes());

		tripOutput = new FileOutputStream(tripOutputFile);
		tripOutput.write(TRIP_HEADER.getBytes());
		
		logger.info("Scrittura header completata.");
	}
	
	private void fillOutputStreams() throws IOException {
		fillAgency();
		fillCalendar();
		fillCalendarDates();
		fillFareAttributes();
		fillFareRules();
		fillFeedInfo();
		fillFrequencies();
		fillRoutes();
		fillShapes();
		fillStops();
		fillStopTimes();
		fillTransfers();
		fillTrips();
	}

	private void fillAgency() throws IOException {
		String row = new String();
		for (Agency a: agencyDAO.getAllAgencies()) {
			row += formatOptionalString(a.getGtfsId()) + ",";
			row += a.getName() + ",";
			row += a.getUrl() + ",";
			row += a.getTimezone() + ",";
			row += formatOptionalString(a.getLanguage()) + ",";
			row += formatOptionalString(a.getPhone()) + ",";
			row += formatOptionalString(a.getFareUrl()) + "\n";
		}
		agencyOutput.write(row.getBytes());
		logger.info("agency.txt completato.");
	}
	
	private void fillCalendar() throws IOException {
		String row = new String();
		for (Calendar c: calendarDAO.getAllCalendars()) {
			row += c.getGtfsId() + ",";
			row += formatBoolean(c.isMonday()) + ",";
			row += formatBoolean(c.isTuesday()) + ",";
			row += formatBoolean(c.isWednesday()) + ",";
			row += formatBoolean(c.isThursday()) + ",";
			row += formatBoolean(c.isFriday()) + ",";
			row += formatBoolean(c.isSaturday()) + ",";
			row += formatBoolean(c.isSunday()) + ",";
			row += formatDate(c.getStartDate()) + ",";
			row += formatDate(c.getEndDate()) + "\n";
		}
		calendarOutput.write(row.getBytes());
		logger.info("calendar.txt completato.");
	}
	
	private void fillCalendarDates() throws IOException {
		String row = new String();
		for (CalendarDate cd: calendarDateDAO.getAllCalendarDates()) {
			row += cd.getCalendar().getGtfsId() + ",";
			row += formatDate(cd.getDate()) + ",";
			row += cd.getExceptionType() + "\n";
		}
		calendarDateOutput.write(row.getBytes());
		logger.info("calendar_dates.txt completato.");
	}
	
	private void fillFareAttributes() throws IOException {
		String row = new String();
		for (FareAttribute fa: fareAttributeDAO.getAllFareAttributes()) {
			row += fa.getGtfsId() + ",";
			row += fa.getPrice() + ",";
			row += fa.getCurrencyType() + ",";
			row += fa.getPaymentMethod() + ",";
			row += formatOptionalInteger(fa.getTransfers()) + ",";
			row += (fa.getTransferDuration() != null ? fa.getTransferDuration() * 60 : "") + "\n";
		}
		fareAttributeOutput.write(row.getBytes());
		logger.info("fare_attributes.txt completato.");
	}
	
	private void fillFareRules() throws IOException {
		String row = new String();
		for (FareRule fr: fareRuleDAO.getAllFareRules()) {
			row += fr.getFareAttribute().getGtfsId() + ",";
			row += (fr.getRoute() != null ? fr.getRoute().getGtfsId() : "") + ",";
			row += (fr.getOrigin() != null ? fr.getOrigin().getGtfsId() : "") + ",";
			row += (fr.getDestination() != null ? fr.getDestination().getGtfsId() : "") + ",";
			row += (fr.getContains() != null ? fr.getContains().getGtfsId() : "") + "\n";
		}
		fareRuleOutput.write(row.getBytes());
		logger.info("fare_rules.txt completato.");
	}
	
	private void fillFeedInfo() throws IOException {
		String row = new String();
		row += currentFeedInfo.getPublisherName() + ",";
		row += currentFeedInfo.getPublisherUrl() + ",";
		row += currentFeedInfo.getLanguage() + ",";
		row += (currentFeedInfo.getStartDate() != null ? formatDate(currentFeedInfo.getStartDate()) : "") + ",";
		row += (currentFeedInfo.getEndDate() != null ? formatDate(currentFeedInfo.getEndDate()) : "") + ",";
		row += formatOptionalString(currentFeedInfo.getVersion()) + "\n";
		feedInfoOutput.write(row.getBytes());
		logger.info("feed_info.txt completato.");
	}
	
	private void fillFrequencies() throws IOException {
		String row = new String();
		for (Frequency f: frequencyDAO.getAllFrequencies()) {
			row += f.getTrip().getGtfsId() + ",";
			row += formatTime(f.getStartTime()) + ",";
			String endTime = formatTime(f.getEndTime());
			if (f.getStartTime().after(f.getEndTime())) {
				// if start time > end time, the time should be represented as a value greater than 24:00:00 in HH:MM:SS local time for the day on which the trip schedule begins. E.g. 25:35:00.
				String[] end = endTime.split(":");
				int hh = Integer.parseInt(end[0]) + 24;
				row += hh + ":" + end[1] + ":" + end[2] + ",";
			} else {
				row += endTime + ",";
			}
			row += f.getHeadwaySecs() * 60 + ",";
			row += f.getExactTimes() + "\n";
		}
		frequencyOutput.write(row.getBytes());
		logger.info("frequencies.txt completato.");
	}
	
	private void fillRoutes() throws IOException {
		String row = new String();
		for (Route r: routeDAO.getAllRoutes()) {
			row += r.getGtfsId() + ",";
			row += (r.getAgency()  != null ? r.getAgency().getGtfsId() : "") + ",";
			row += r.getShortName() + ",";
			row += r.getLongName() + ",";
			row += formatOptionalString(r.getDescription()) + ",";
			row += r.getType() + ",";
			row += formatOptionalString(r.getUrl()) + ",";
			row += formatOptionalString(r.getColor().substring(1).toUpperCase()) + ",";
			row += formatOptionalString(r.getTextColor().substring(1).toUpperCase()) + "\n";
		}
		routeOutput.write(row.getBytes());
		logger.info("routes.txt completato.");
	}
	
	private void fillShapes() throws IOException {
		String row = new String();
		for (Shape s: shapeDAO.getAllShapes()) {
			List<Point2D.Double> points = decodePolyline(s.getEncodedPolyline());
			int sequence = 0;
			for (Point2D.Double p: points) {
				row += s.getId() + ",";
				row += String.format(Locale.ENGLISH, "%.5f", p.getX()) + ",";
				row += String.format(Locale.ENGLISH, "%.5f", p.getY()) + ",";
				row += sequence++ + ",";
				row += String.format(Locale.ENGLISH, "%.4f", computeDistance(p.getX(), p.getY(), points.get(0).getX(), points.get(0).getY())) + "\n";
			}
		}
		shapeOutput.write(row.getBytes());
		logger.info("shapes.txt completato.");
	}
	
	private void fillStops() throws IOException {
		String row = new String();
		for (Stop s: stopDAO.getAllStops()) {
			row += s.getGtfsId() + ",";
			row += formatOptionalString(s.getCode()) + ",";
			row += s.getName() + ",";
			row += formatOptionalString(s.getDesc()) + ",";
			row += s.getLat() + ",";
			row += s.getLon() + ",";
			row += (s.getZone()  != null ? s.getZone().getGtfsId() : "") + ",";
			row += formatOptionalString(s.getUrl()) + ",";
			row += formatOptionalInteger(s.getLocationType()) + ",";
			row += (s.getParentStation()  != null ? s.getParentStation().getId() : "") + ",";
			row += formatOptionalString(s.getTimezone()) + ",";
			row += formatOptionalInteger(s.getWheelchairBoarding()) + "\n";
		}
		stopOutput.write(row.getBytes());
		logger.info("stops.txt completato.");
	}
	
	private void fillStopTimes() throws IOException {
		String row = new String();
		for (StopTime st: stopTimeDAO.getAllStopTimes()) {
			row += st.getTrip().getGtfsId() + ",";
			String arrivalTime = formatTime(st.getArrivalTime());
			if (st.isContinueFromPreviousDay()) {
				// if arrival and departure times continue from previous day, the time should be represented as a value greater than 24:00:00 in HH:MM:SS local time for the day on which the trip schedule begins. E.g. 25:35:00.
				String[] arrival = arrivalTime.split(":");
				int hhArr = Integer.parseInt(arrival[0]) + 24;
				row += hhArr + ":" + arrival[1] + ":" + arrival[2] + ",";
			} else {
				row += arrivalTime + ",";
			}
			String departureTime = formatTime(st.getDepartureTime());
			if (st.getArrivalTime().after(st.getDepartureTime()) || st.isContinueFromPreviousDay()) {
				// if arrival time > departure time or arrival and departure times continue from previous day, the time should be represented as a value greater than 24:00:00 in HH:MM:SS local time for the day on which the trip schedule begins. E.g. 25:35:00.
				String[] departure = departureTime.split(":");
				int hhDep = Integer.parseInt(departure[0]) + 24;
				row += hhDep + ":" + departure[1] + ":" + departure[2] + ",";
			} else {
				row += departureTime + ",";
			}
			row += st.getStop().getGtfsId() + ",";
			row += st.getStopSequence() + ",";
			row += formatOptionalString(st.getStopHeadsign()) + ",";
			row += formatOptionalInteger(st.getPickupType()) + ",";
			row += formatOptionalInteger(st.getDropOffType()) + ",";
			row += formatOptionalDouble(st.getShapeDistTraveled()) + "\n";
		}
		stopTimeOutput.write(row.getBytes());
		logger.info("stop_times.txt completato.");
	}
	
	private void fillTransfers() throws IOException {
		String row = new String();
		for (Transfer t: transferDAO.getAllTransfers()) {
			row += t.getFromStop().getGtfsId() + ",";
			row += t.getToStop().getGtfsId() + ",";
			row += t.getTransferType() + ",";
			row += (t.getMinTransferTime() != null ? t.getMinTransferTime() * 60 : "") + "\n";
		}
		transferOutput.write(row.getBytes());
		logger.info("transfers.txt completato.");
	}
	
	private void fillTrips() throws IOException {
		String row = new String();
		for (Trip t: tripDAO.getAllTrips()) {
			row += t.getRoute().getGtfsId() + ",";
			row += t.getCalendar().getGtfsId() + ",";
			row += t.getGtfsId() + ",";
			row += formatOptionalString(t.getTripHeadsign()) + ",";
			row += formatOptionalString(t.getTripShortName()) + ",";
			row += formatOptionalInteger(t.getDirectionId()) + ",";
			//row += formatOptionalString(t.getBlockId()) + ",";
			row += (t.getShape()  != null ? t.getShape().getId() : "") + ",";
			row += formatOptionalInteger(t.getWheelchairAccessible()) + ",";
			row += formatOptionalInteger(t.getBikesAllowed()) + "\n";
		}
		tripOutput.write(row.getBytes());
		logger.info("trips.txt completato.");
	}

	private void closeOutputStreams() throws IOException {
		tripOutput.close();
		transferOutput.close();
		stopTimeOutput.close();
		stopOutput.close();
		shapeOutput.close();
		routeOutput.close();
		frequencyOutput.close();
		feedInfoOutput.close();
		fareRuleOutput.close();
		fareAttributeOutput.close();
		calendarDateOutput.close();
		calendarOutput.close();
		agencyOutput.close();
		
		logger.info("Scrittura file completata.");
	}
	
	private void createZipFile() throws IOException {
		byte[] buffer = new byte[1024];
		GTFSzip = new File(GTFS_HISTORY_DIR_NAME + zipName + ".zip");
		GTFSzip.createNewFile();
		ZipOutputStream zipOut = new ZipOutputStream(new FileOutputStream(GTFSzip));
		Map<String, FileInputStream> inputFiles = buildFileInputStreamMap();
		for (Map.Entry<String, FileInputStream> inputFile : inputFiles.entrySet()) {
			FileInputStream in = inputFile.getValue();
			try {
				zipOut.putNextEntry(new ZipEntry(inputFile.getKey()));
				int len;
				while((len = in.read(buffer)) > 0) {
					zipOut.write(buffer, 0, len);
				}
				zipOut.closeEntry();
			} finally {
				inputFile.getValue().close();
			}
		}
		zipOut.close();
		
		logger.info(zipName + ".zip creato.");
	}

	private Map<String, FileInputStream> buildFileInputStreamMap() throws FileNotFoundException {
		Map<String, FileInputStream> result = new HashMap<String, FileInputStream>();
		result.put(AGENCY_FILE_NAME, new FileInputStream(agencyOutputFile));
		result.put(CALENDAR_FILE_NAME, new FileInputStream(calendarOutputFile));
		result.put(CALENDAR_DATE_FILE_NAME, new FileInputStream(calendarDateOutputFile));
		result.put(FARE_ATTRIBUTE_FILE_NAME, new FileInputStream(fareAttributeOutputFile));
		result.put(FARE_RULE_FILE_NAME, new FileInputStream(fareRuleOutputFile));
		result.put(FEED_INFO_FILE_NAME, new FileInputStream(feedInfoOutputFile));
		result.put(FREQUENCY_FILE_NAME, new FileInputStream(frequencyOutputFile));
		result.put(ROUTE_FILE_NAME, new FileInputStream(routeOutputFile));
		result.put(SHAPE_FILE_NAME, new FileInputStream(shapeOutputFile));
		result.put(STOP_FILE_NAME, new FileInputStream(stopOutputFile));
		result.put(STOP_TIME_FILE_NAME, new FileInputStream(stopTimeOutputFile));
		result.put(TRANSFER_FILE_NAME, new FileInputStream(transferOutputFile));
		result.put(TRIP_FILE_NAME, new FileInputStream(tripOutputFile));
		return result;
	}
	
	private String formatBoolean(boolean b) {
		if (b)
			return "1";
		else
			return "0";
	}
	
	private String formatOptionalInteger(Integer i) {
		if (i != null)
			return i.toString();
		else
			return "";
	}
	
	private String formatOptionalDouble(Double d) {
		if (d != null)
			return d.toString();
		else
			return "";
	}
	
	private String formatOptionalString(String s) {
		if (s != null)
			return s;
		else
			return "";
	}
	
	private String formatDate(Date date) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		return dateFormat.format(date);
	}
	
	private String formatTime(Time time) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
		return dateFormat.format(time);
	}
	
	private List<Point2D.Double> decodePolyline(String encodedPath) {
        int len = encodedPath.length();

        // For speed we preallocate to an upper bound on the final length, then
        // truncate the array before returning.
        final List<Point2D.Double> path = new ArrayList<Point2D.Double>();
        int index = 0;
        int lat = 0;
        int lng = 0;

        while (index < len) {
            int result = 1;
            int shift = 0;
            int b;
            do {
                b = encodedPath.charAt(index++) - 63 - 1;
                result += b << shift;
                shift += 5;
            } while (b >= 0x1f);
            lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

            result = 1;
            shift = 0;
            do {
                b = encodedPath.charAt(index++) - 63 - 1;
                result += b << shift;
                shift += 5;
            } while (b >= 0x1f);
            lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

            Point2D.Double p = new Point2D.Double(lat * 1e-5, lng * 1e-5);
            path.add(p);
        }

        return path;
    }
	
	private double computeDistance(double lat1, double lng1, double lat2, double lng2) {
	    double earthRadius = 6371; //kilometers
	    double dLat = Math.toRadians(lat2-lat1);
	    double dLng = Math.toRadians(lng2-lng1);
	    double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
	               Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
	               Math.sin(dLng/2) * Math.sin(dLng/2);
	    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
	    double dist = (double) (earthRadius * c);

	    return dist;
	}
	
	@RequestMapping(value = "/importaGTFS", method = RequestMethod.POST)
	public String uploadGTFS(Model model, @RequestParam("file") MultipartFile uploadedFile, HttpSession session) {
		try {
			importedFileName = FilenameUtils.removeExtension(uploadedFile.getOriginalFilename());
			uploadedFile.transferTo(new File(GTFS_HISTORY_DIR_NAME + "\\" + uploadedFile.getOriginalFilename()));
			fillDatabase(GTFS_HISTORY_DIR_NAME + "\\" + uploadedFile.getOriginalFilename());
		} catch (IllegalStateException e) {
			logger.error("Errore nel caricamento del feed");
			e.printStackTrace();
		} catch (IOException e) {
			logger.error("Errore nel caricamento del feed");
			e.printStackTrace();
		}
		
		return "redirect:GTFS";
	}

	private void fillDatabase(String uploadedFile) {
		try {
			ZipFile zipFile = new ZipFile(uploadedFile);
			
		    Enumeration<? extends ZipEntry> entries = zipFile.entries();
	
		    while(entries.hasMoreElements()) {
		        ZipEntry entry = entries.nextElement();
		        InputStream stream = zipFile.getInputStream(entry);
		        BufferedReader br = new BufferedReader(new InputStreamReader(stream));
		        String line = br.readLine();
		        String[] header = line.split(",");
		        if (entry.getName().equals("agency.txt")) {
		        	while ((line = br.readLine()) != null) {
		        		String[] elements = line.split(",");
		        		Agency agency = new Agency();
		        		for (int i=0; i<header.length && i<elements.length; i++) {
		        			if (!elements[i].isEmpty() && !elements[i].trim().equals("")) {
		        				//logger.info("---> " + elements[i]);
			        			if (header[i].equals("agency_id")) {
			        				agency.setGtfsId(elements[i]);
			        			} else if (header[i].equals("agency_name")) {
			        				agency.setName(elements[i]);
			        			} else if (header[i].equals("agency_url")) {
			        				agency.setUrl(elements[i]);
			        			} else if (header[i].equals("agency_timezone")) {
			        				agency.setTimezone(elements[i]);
			        			} else if (header[i].equals("agency_lang")) {
			        				agency.setLanguage(elements[i]);
			        			} else if (header[i].equals("agency_phone")) {
			        				agency.setPhone(elements[i]);
			        			} else if (header[i].equals("agency_fare_url")) {
			        				agency.setFareUrl(elements[i]);
			        			}
		        			}
		        		}
		        		agencyDAO.addAgency(agency);
		        	}
		        	logger.info(entry.getName() + " letto.");
		        } else if (entry.getName().equals("calendar.txt")) {
		        	while ((line = br.readLine()) != null) {
		        		String[] elements = line.split(",");
		        		Calendar calendar = new Calendar();
		        		for (int i=0; i<header.length && i<elements.length; i++) {
		        			if (!elements[i].isEmpty() && !elements[i].trim().equals("")) {
		        				//logger.info("---> " + elements[i]);
			        			if (header[i].equals("service_id")) {
			        				calendar.setGtfsId(elements[i]);
			        			} else if (header[i].equals("monday")) {
			        				calendar.setMonday(parseBoolean(elements[i]));
			        			} else if (header[i].equals("tuesday")) {
			        				calendar.setTuesday(parseBoolean(elements[i]));
			        			} else if (header[i].equals("wednesday")) {
			        				calendar.setWednesday(parseBoolean(elements[i]));
			        			} else if (header[i].equals("thursday")) {
			        				calendar.setThursday(parseBoolean(elements[i]));
			        			} else if (header[i].equals("friday")) {
			        				calendar.setFriday(parseBoolean(elements[i]));
			        			} else if (header[i].equals("saturday")) {
			        				calendar.setSaturday(parseBoolean(elements[i]));
			        			} else if (header[i].equals("sunday")) {
			        				calendar.setSunday(parseBoolean(elements[i]));
			        			} else if (header[i].equals("start_date")) {
			        				calendar.setStartDate(parseDate(elements[i]));
			        			} else if (header[i].equals("end_date")) {
			        				calendar.setEndDate(parseDate(elements[i]));
			        			}
		        			}
		        		}
		        		calendarDAO.addCalendar(calendar);
		        	}
		        	logger.info(entry.getName() + " letto.");
		        } else if (entry.getName().equals("calendar_dates.txt")) {
		        	while ((line = br.readLine()) != null) {
		        		String[] elements = line.split(",");
		        		CalendarDate calendarDate = new CalendarDate();
		        		Calendar calendar = null;
		        		for (int i=0; i<header.length && i<elements.length; i++) {
		        			if (!elements[i].isEmpty() && !elements[i].trim().equals("")) {
		        				//logger.info("---> " + elements[i]);
			        			if (header[i].equals("service_id")) {
			        				for (Calendar c: calendarDAO.getAllCalendars()) {
			        					if (c.getGtfsId().equals(elements[i])) {
			        						calendar = c;
			        					}
			        				}
			        			} else if (header[i].equals("date")) {
			        				calendarDate.setDate(parseDate(elements[i]));
			        			} else if (header[i].equals("exception_type")) {
			        				calendarDate.setExceptionType(Integer.parseInt(elements[i]));
			        			}
		        			}
		        		}
		        		calendar.addCalendarDate(calendarDate);
		        	}
		        	logger.info(entry.getName() + " letto.");
		        } else if (entry.getName().equals("fare_attributes.txt")) {
		        	while ((line = br.readLine()) != null) {
		        		String[] elements = line.split(",");
		        		FareAttribute fareAttribute = new FareAttribute();
		        		for (int i=0; i<header.length && i<elements.length; i++) {
		        			if (!elements[i].isEmpty() && !elements[i].trim().equals("")) {
		        				//logger.info("---> " + elements[i]);
			        			if (header[i].equals("fare_id")) {
			        				fareAttribute.setGtfsId(elements[i]);
			        			} else if (header[i].equals("price")) {
			        				fareAttribute.setPrice(Double.parseDouble(elements[i]));
			        			} else if (header[i].equals("currency_type")) {
			        				fareAttribute.setCurrencyType(elements[i]);
			        			} else if (header[i].equals("payment_method")) {
			        				fareAttribute.setPaymentMethod(Integer.parseInt(elements[i]));
			        			} else if (header[i].equals("transfers")) {
			        				fareAttribute.setTransfers(Integer.parseInt(elements[i]));
			        			} else if (header[i].equals("transfer_duration")) {
			        				fareAttribute.setTransferDuration(Integer.parseInt(elements[i]));
			        			}
		        			}
		        		}
		        		fareAttributeDAO.addFareAttribute(fareAttribute);
		        	}
		        	logger.info(entry.getName() + " letto.");
		        } else if (entry.getName().equals("fare_rules.txt")) {
		        	while ((line = br.readLine()) != null) {
		        		String[] elements = line.split(",");
		        		FareRule fareRule = new FareRule();
		        		FareAttribute fareAttribute = null;
		        		for (int i=0; i<header.length && i<elements.length; i++) {
		        			if (!elements[i].isEmpty() && !elements[i].trim().equals("")) {
		        				//logger.info("---> " + elements[i]);
			        			if (header[i].equals("fare_id")) {
			        				for (FareAttribute fa: fareAttributeDAO.getAllFareAttributes()) {
			        					if (fa.getGtfsId().equals(elements[i])) {
			        						fareAttribute = fa;
			        					}
			        				}
			        			} else if (header[i].equals("route_id")) {
			        				for (Route r: routeDAO.getAllRoutes()) {
			        					if (r.getGtfsId().equals(elements[i])) {
			        						r.addFareRule(fareRule);
			        					}
			        				}
			        			} else if (header[i].equals("origin_id")) {
			        				// TODO: fareRule.setOrigin(elements[i]);
			        			} else if (header[i].equals("destination_id")) {
			        				// TODO: fareRule.setDestination(elements[i]);
			        			} else if (header[i].equals("contains_id")) {
			        				// TODO: fareRule.setContains(elements[i]);
			        			}
		        			}
		        		}
		        		fareAttribute.addFareRule(fareRule);
		        	}
		        	logger.info(entry.getName() + " letto.");
		        } else if (entry.getName().equals("feed_info.txt")) {
		        	while ((line = br.readLine()) != null) {
		        		String[] elements = line.split(",");
		        		FeedInfo feedInfo = new FeedInfo();
		        		for (int i=0; i<header.length && i<elements.length; i++) {
		        			if (!elements[i].isEmpty() && !elements[i].trim().equals("")) {
		        				//logger.info("---> " + elements[i]);
		        				if (header[i].equals("feed_publisher_name")) {
		        					feedInfo.setPublisherName(elements[i]);
		        				} else if (header[i].equals("feed_publisher_url")) {
		        					feedInfo.setPublisherUrl(elements[i]);
		        				} else if (header[i].equals("feed_lang")) {
		        					feedInfo.setLanguage(elements[i]);
		        				} else if (header[i].equals("feed_start_date")) {
		        					feedInfo.setStartDate(parseDate(elements[i]));
		        				} else if (header[i].equals("feed_end_date")) {
		        					feedInfo.setEndDate(parseDate(elements[i]));
		        				} else if (header[i].equals("feed_version")) {
		        					feedInfo.setVersion(elements[i]);
		        				}
		        			}
		        		}
		        		feedInfo.setName(importedFileName);
		        		feedInfoDAO.addFeedInfo(feedInfo);
		        	}
		        	logger.info(entry.getName() + " letto.");
		        } else if (entry.getName().equals("stops.txt")) {
		        	while ((line = br.readLine()) != null) {
		        		String[] elements = line.split(",");
		        		Stop stop = new Stop();
		        		//logger.info("---> " + Arrays.toString(elements));
		        		for (int i=0; i<header.length && i<elements.length; i++) {
		        			if (!elements[i].isEmpty() && !elements[i].trim().equals("")) {
		        				//logger.info("---> " + elements[i]);
			        			if (header[i].equals("stop_id")) {
			        				stop.setGtfsId(elements[i]);
			        			} else if (header[i].equals("stop_code")) {
			        				stop.setCode(elements[i]);
			        			} else if (header[i].equals("stop_name")) {
			        				stop.setName(elements[i]);
			        			} else if (header[i].equals("stop_desc")) {
			        				stop.setDesc(elements[i]);
			        			} else if (header[i].equals("stop_lat")) {
			        				stop.setLat(Double.parseDouble(elements[i]));
			        			} else if (header[i].equals("stop_lon")) {
			        				stop.setLon(Double.parseDouble(elements[i]));
			        			} else if (header[i].equals("zone_id")) {
			        				// TODO: stop.setZone(elements[i]);
			        			} else if (header[i].equals("stop_url")) {
			        				stop.setUrl(elements[i]);
			        			} else if (header[i].equals("location_type")) {
			        				stop.setLocationType(Integer.parseInt(elements[i]));
			        			} else if (header[i].equals("parent_station")) {
			        				// TODO: stop.setParentStation(elements[i]);
			        			} else if (header[i].equals("stop_timezone")) {
			        				stop.setTimezone(elements[i]);
			        			} else if (header[i].equals("wheelchair_boarding")) {
			        				stop.setWheelchairBoarding(Integer.parseInt(elements[i]));
			        			}
		        			}
		        		}
		        		stopDAO.addStop(stop);
		        	}
		        	logger.info(entry.getName() + " letto.");
		        }
		    }
		} catch (IOException e) {
			logger.error("Errore nella lettura del feed");
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error("Errore nella conversione della data");
			e.printStackTrace();
		}
	}
	
	private Date parseDate(String date) throws ParseException {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		return new Date(dateFormat.parse(date).getTime());
	}
	
	private Boolean parseBoolean(String bool) throws ParseException {
		if (bool.equals("0"))
			return false;
		else
			return true;
	}
}
