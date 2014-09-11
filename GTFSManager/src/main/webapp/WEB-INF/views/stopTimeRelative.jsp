<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="it.torino._5t.entity.StopTimeRelative"%>
<%@page import="java.sql.Time"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Fermate</title>
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
	<link href="<c:url value='/resources/css/leaflet.label.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.markcluster.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.geosearch.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/timeline.css' />" type="text/css" rel="stylesheet">
	<link href="https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.css" type="text/css" rel="stylesheet">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script src="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.label.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.markcluster.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.control.geosearch.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.geosearch.provider.openstreetmap.js' />"></script>
	<script type="text/javascript" src="https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.js"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.encoded-polyline.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/timezones.js' />"></script>
	<script type="text/javascript">
	// edit trip-stop association form validation 
	function validateModificaFermataCorsaForm() {
		// check if stop number > max between all stop numbers
		var stopSequence = document.forms["modificaFermataCorsaForm"]["stopSequence"].value;
		var stopSequences = [];
		<c:forEach var="fermataCorsa" items="${listaFermateCorsa}">
			stopSequences.push("${fermataCorsa.stopSequence}");
		</c:forEach>
		if (stopSequence > Math.max.apply(null, stopSequences)) {
			$("#wrong-stop-sequence-p").text("Il numero della fermata deve essere compreso tra 1 e " + Math.max.apply(null, stopSequences));
			$("#wrong-stop-sequence").show();
			return false;
		}
		
		return true;
	};
	
	// load the navigation bar
	$(function() {
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liFermate").addClass("active");
    	}); 
    });
	
	$(function() {
		// create a map in the "map" div, set the view to a given place and zoom
		var map;
		if ("${lat}" != "" && "${lon}" != "") {
			if ("${zoom}" != "")
				map = L.map('map').setView(["${lat}", "${lon}"], "${zoom}");
			else
				map = L.map('map').setView(["${lat}", "${lon}"], 16);
		} else {
			map = L.map('map').setView([45.0781, 7.6761], 13);
		}

		// add an OpenStreetMap tile layer
		L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
		    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
		}).addTo(map);
		
		// add address searching plugin
		new L.Control.GeoSearch({
		    provider: new L.GeoSearch.Provider.OpenStreetMap(),
		    searchLabel: "Cerca un indirizzo...",
	        notFoundMessage: "L'indirizzo cercato non può essere trovato.",
		    showMarker: false
		}).addTo(map);
		
		// Initialise the FeatureGroup to store editable layers
		var drawnItems = new L.FeatureGroup();
		map.addLayer(drawnItems);

		// Initialise the draw control and pass it the FeatureGroup of editable layers
		var drawControl = new L.Control.Draw({
			draw : {
		        polygon : false,
		        polyline : false,
		        rectangle : false,
		        circle : false,
		        marker: false
		    },
		    edit: {
		        featureGroup: drawnItems,
		        remove: false
		    }
		});
		map.addControl(drawControl);
		
		var markers = new L.MarkerClusterGroup();
		
		// per ogni fermata dell'agenzia non associata alla corsa attiva (listaFermate) creo un marker, con un popup contenente il form per l'associazione con la corsa
		<c:forEach var="fermata" items="${listaFermate}">
			var popupContent = '<form:form name="creaFermataCorsaForm" commandName="stopTimeRelative" method="post" role="form">' +
									"<b>Fermata: </b> ${fermata.name}" +
									'<input name="stopId" type="hidden" value="${fermata.id}" />' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="arrival" class="required">Ora arrivo</label>' +
											'<input type="time" name="arrival" class="form-control" id="arrivalTime" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="departure" class="required">Ora partenza</label>' +
											'<input type="time" name="departure" class="form-control" id="departureTime" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-8">' +
											'<label for="stopHeadsign">Display</label>' +
											'<form:input path="stopHeadsign" class="form-control" id="stopHeadsign" maxlength="50" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="pickupType">Raccolta passeggeri</label>' +
											'<form:select path="pickupType" class="form-control">' +
												'<form:option value="0" selected="true">Regolarmente programmata</form:option>' +
												'<form:option value="1">Non disponibile</form:option>' +
												'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
												'<form:option value="3">Coordinarsi con l\'autista</form:option>' +
											'</form:select>' +
											'<form:errors path="pickupType" cssClass="error"></form:errors>' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="dropOffType">Rilascio passeggeri</label>' +
											'<form:select path="dropOffType" class="form-control">' +
												'<form:option value="0" selected="true">Regolarmente programmato</form:option>' +
												'<form:option value="1">Non disponibile</form:option>' +
												'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
												'<form:option value="3">Coordinarsi con l\'autista</form:option>' +
											'</form:select>' +
											'<form:errors path="dropOffType" cssClass="error"></form:errors>' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<input class="btn btn-success" type="submit" value="Aggiungi fermata alla corsa" />' +
										'</div>' +
									'</div>' +
								'</form:form>';
			
			var marker = L.marker(["${fermata.lat}", "${fermata.lon}"])
				.bindPopup(popupContent, {minWidth: 300})
				.bindLabel("${fermata.name}");
			
			markers.addLayer(marker);
		</c:forEach>
		
		var fermateCorsaCoordinates = new Array();
		
		// per ogni fermata associata alla corsa attiva (listaFermateCorsa) creo un marker, con un popup contenente il form per la modifica dell'associazione con la corsa
		<c:forEach var="fermataCorsa" items="${listaFermateCorsa}">
			var popupContent = '<form:form name="modificaFermataCorsaForm" commandName="stopTimeRelative" method="post" role="form" action="/_5t/modificaFermataCorsa" onsubmit="return validateModificaFermataCorsaForm()">' +
									"<b>Fermata: </b> ${fermataCorsa.stop.name}" +
									'<input name="stopTimeId" type="hidden" value="${fermataCorsa.id}" />' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="stopSequence" class="required">Numero fermata</label>' +
											'<form:input type="number" path="stopSequence" class="form-control" id="stopSequence" value="${fermataCorsa.stopSequence}" min="1" />' +
											'<form:errors path="stopSequence" cssClass="error"></form:errors>' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="arrival" class="required">Ora arrivo</label>' +
											'<input type="time" name="arrival" class="form-control" id="arrivalTime" value="${fermataCorsa.relativeArrivalTime}" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="departure" class="required">Ora partenza</label>' +
											'<input type="time" name="departure" class="form-control" id="departureTime" value="${fermataCorsa.relativeDepartureTime}" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-8">' +
											'<label for="stopHeadsign">Display</label>' +
											'<form:input path="stopHeadsign" class="form-control" id="stopHeadsign" value="${fermataCorsa.stopHeadsign}" maxlength="50" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="pickupType">Raccolta passeggeri</label>' +
											'<form:select path="pickupType" class="form-control">';
			if ("${fermataCorsa.pickupType}" == 0) {
				popupContent += '<form:option value="0" selected="true">Regolarmente programmata</form:option>' +
								'<form:option value="1">Non disponibile</form:option>' +
								'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3">Coordinarsi con l\'autista</form:option>';
			} else if ("${fermataCorsa.pickupType}" == 1) {
				popupContent += '<form:option value="0">Regolarmente programmata</form:option>' +
								'<form:option value="1" selected="true">Non disponibile</form:option>' +
								'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3">Coordinarsi con l\'autista</form:option>';
			} else if ("${fermataCorsa.pickupType}" == 2) {
				popupContent += '<form:option value="0">Regolarmente programmata</form:option>' +
								'<form:option value="1">Non disponibile</form:option>' +
								'<form:option value="2" selected="true">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3">Coordinarsi con l\'autista</form:option>';
			} else {
				popupContent += '<form:option value="0">Regolarmente programmata</form:option>' +
								'<form:option value="1">Non disponibile</form:option>' +
								'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3" selected="true">Coordinarsi con l\'autista</form:option>';
			}
							popupContent +=	'</form:select>' +
											'<form:errors path="pickupType" cssClass="error"></form:errors>' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="dropOffType">Rilascio passeggeri</label>' +
											'<form:select path="dropOffType" class="form-control">';
			if ("${fermataCorsa.dropOffType}" == 0) {
				popupContent += '<form:option value="0" selected="true">Regolarmente programmato</form:option>' +
								'<form:option value="1">Non disponibile</form:option>' +
								'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3">Coordinarsi con l\'autista</form:option>';
			} else if ("${fermataCorsa.dropOffType}" == 1) {
				popupContent += '<form:option value="0">Regolarmente programmato</form:option>' +
								'<form:option value="1" selected="true">Non disponibile</form:option>' +
								'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3">Coordinarsi con l\'autista</form:option>';
			} else if ("${fermataCorsa.dropOffType}" == 2) {
				popupContent += '<form:option value="0">Regolarmente programmato</form:option>' +
								'<form:option value="1">Non disponibile</form:option>' +
								'<form:option value="2" selected="true">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3">Coordinarsi con l\'autista</form:option>';
			} else {
				popupContent += '<form:option value="0">Regolarmente programmato</form:option>' +
								'<form:option value="1">Non disponibile</form:option>' +
								'<form:option value="2">Organizzabile tramite telefonata all\'agenzia</form:option>' +
								'<form:option value="3" selected="true">Coordinarsi con l\'autista</form:option>';
			}
							popupContent +=	'</form:select>' +
											'<form:errors path="dropOffType" cssClass="error"></form:errors>' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<input class="btn btn-success" type="submit" value="Aggiorna" />' +
										'</div>' +
									'</div>' +
								'</form:form>' +
								'<a class="btn btn-danger active" href="/_5t/eliminaFermataCorsa?id=${fermataCorsa.id}">Rimuovi dalla corsa</a>';
		
			var greenIcon = L.icon({
			    iconUrl: "<c:url value='/resources/images/green-marker.png' />",
			    iconSize: [25, 41],
		        iconAnchor: [12, 41],
		        popupAnchor: [1, -34]
			});
		    
			var marker = L.marker(["${fermataCorsa.stop.lat}", "${fermataCorsa.stop.lon}"], {icon: greenIcon})
				.bindPopup(popupContent, {minWidth: 300})
				.bindLabel("${fermataCorsa.stopSequence} ${fermataCorsa.stop.name}");
			
			markers.addLayer(marker);
			
			fermateCorsaCoordinates["${fermataCorsa.stopSequence}"] = new Array("${fermataCorsa.stop.lat}", "${fermataCorsa.stop.lon}");
			
		</c:forEach>
		
		map.addLayer(markers);
		
		if ("${not empty shapeAttivo}") {
			drawnItems.addLayer(L.Polyline.fromEncoded("${shapeAttivo.encodedPolyline}"));
			
			$("#encodedPolyline").val("${shapeAttivo.encodedPolyline}");
		}
		
		// le fermate appartenenti alla corsa vengono unite in una polyline
		$("#unisciFermateButton").click(function() {
			var polyline = new L.Polyline([]);
			for (var i=1; i<fermateCorsaCoordinates.length; i++) {
				polyline.addLatLng(L.latLng(fermateCorsaCoordinates[i][0], fermateCorsaCoordinates[i][1]));
			}

			drawnItems.clearLayers();
			
			drawnItems.addLayer(polyline);
			
			$("#encodedPolyline").val(polyline.encodePath());
		});
		
		map.on('draw:edited', function (e) {
			var layers = e.layers;
		    layers.eachLayer(function (layer) {
				$("#encodedPolyline").val(layer.encodePath());
		    });
			
		});
	});
	
	$(document).ready(function () {
		// alerts initially hidden
		$(".alert").hide();
		
		// la variabile showAlertWrongTimes è settata a true se l'ora di arrivo inserita nella fermata è successiva all'ora di partenza 
		/*if ("${showAlertWrongTimes}") {
			alert("L'ora di arrivo non può essere successiva all'ora di partenza");
		}*/
		
		// non si può salvare uno shape se non è ancora stato creato
		$("#creaShapeForm").submit(function(e) {
			if (!$("#encodedPolyline").val()) {
				$("#no-shape-to-save").alert();
				e.preventDefault();
			}
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
	});
    </script>
</head>
<body>
	<!-- Navigation bar -->
	<nav id="navigationBar" class="navbar navbar-default" role="navigation"></nav>
	
	<ol class="breadcrumb">
		<li><a href="/_5t/agenzie">Agenzia ${agenziaAttiva.gtfsId}</a></li>
		<li><a href="/_5t/linee">Linea ${lineaAttiva.shortName}</a></li>
		<li><a href="/_5t/schemiCorse">Schema corsa ${schemaCorsaAttivo.gtfsId}</a></li>
		<li class="active">Fermate</li>
	</ol>
	
	<h3>Assegnazione fermate alla corsa ${corsaAttiva.tripShortName}</h3>
	
	<p>Cliccare su una fermata per aggiungerla alla corsa. Le fermate verdi appartengono alla corsa.<br>
	"Unisci fermate" unisce le fermate che appartengono alla corsa con segmenti. Lo shape può essere modificato cliccando sul pulsante "Edit layers" sotto lo zoom. Una volta modificato deve essere salvato cliccando su "Salva shape".</p>
	
	<div id="map" class="col-lg-8"></div>
	<div class="col-lg-4">
		<button id="unisciFermateButton" class="btn btn-primary">Unisci fermate</button>
		<form:form id="creaShapeForm" commandName="shape" role="form" method="post" action="/_5t/creaShape">
			<div class="row">
				<div class="form-group">
					<form:hidden path="encodedPolyline" id="encodedPolyline" />
					<c:choose>
						<c:when test="${empty shapeAttivo}">
							<!-- non è ancora stato associato nessuno shape alla corsa -->
							<input type="hidden" name="shapeId" value="-1" />
						</c:when>
						<c:otherwise>
							<!-- c'è già uno shape associato alla corsa -->
							<input type="hidden" name="shapeId" value="${shapeAttivo.id}" />
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<div class="row col-lg-12">
				<div class="form-group">
					<input class="btn btn-success" type="submit" value="Salva shape" />
				</div>
			</div>
		</form:form>
		<br><br><br><br><br><br>
		<div class="row col-lg-12">
			<a type="button" class="btn btn-default" href="/_5t/fermate">Aggiungi altre fermate all'agenzia</a>
		</div>
		<br><br><br>
		<div class="row col-lg-12">
			<ul class="timeline">
				<%
				class StopTimeRelativeComparator implements Comparator<StopTimeRelative> {

					@Override
					public int compare(StopTimeRelative o1, StopTimeRelative o2) {
						return o1.getStopSequence().compareTo(o2.getStopSequence());
					}
					
				}
				List<StopTimeRelative> stopTimeRelatives = new ArrayList<StopTimeRelative>((Set<StopTimeRelative>) request.getAttribute("listaFermateCorsa"));
				Collections.sort(stopTimeRelatives, new StopTimeRelativeComparator());
				SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
				Calendar cal = new GregorianCalendar();
				cal.setTime(new Time(0, 0, 0));
				for (StopTimeRelative str: stopTimeRelatives) {
				%>
			        <li class="timeline-inverted">
				        <div class="timeline-badge"></div>
				        <div class="timeline-panel">
			            	<div class="timeline-heading">
			              		<h4 class="timeline-title"><% out.write(str.getStop().getName()); %></h4>
			            	</div>
				            <div class="timeline-body">
				            	<%
				            	Calendar toAdd = new GregorianCalendar();
				            	toAdd.setTime(str.getRelativeArrivalTime());
				            	cal.add(java.util.Calendar.HOUR_OF_DAY, toAdd.get(java.util.Calendar.HOUR_OF_DAY));
								cal.add(java.util.Calendar.MINUTE, toAdd.get(java.util.Calendar.MINUTE));
				            	%>
				              	<p>Arrivo: <% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), 0))); %></p>
				            	<%
				            	toAdd.setTime(str.getRelativeDepartureTime());
				            	cal.add(java.util.Calendar.HOUR_OF_DAY, toAdd.get(java.util.Calendar.HOUR_OF_DAY));
								cal.add(java.util.Calendar.MINUTE, toAdd.get(java.util.Calendar.MINUTE));
				            	%>
				              	<p>Partenza: <% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), 0))); %></p>
				            </div>
			          	</div>
			        </li>
				<% } %>
		    </ul>
		</div>
	</div>
	
	<!-- Alerts -->
	<div id="wrong-times" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>L'ora di arrivo non può essere successiva all'ora di partenza se sono nello stesso giorno.</p>
	</div>
	<div id="wrong-stop-sequence" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p id="wrong-stop-sequence-p"></p>
	</div>
	<div id="no-shape-to-save" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>Devi creare uno shape prima di poterlo salvare.</p>
	</div>
</body>
</html>