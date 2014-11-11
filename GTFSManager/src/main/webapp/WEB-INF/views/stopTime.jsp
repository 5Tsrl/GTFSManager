<%@page import="java.sql.Time"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="it.torino._5t.entity.StopTime"%>
<%@page import="java.util.Comparator"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Fermate</title>
	<link href="<c:url value='/resources/images/favicon.ico' />" rel="icon" type="image/x-icon">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
	<link href="<c:url value='/resources/css/leaflet.label.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.markcluster.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.geosearch.css' />" type="text/css" rel="stylesheet">
	<link href="https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.css" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
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
	// create trip-stop association form validation 
	function validateCreaFermataCorsaForm() {
		if (document.forms["creaFermataCorsaForm"]["sameDay"].checked) {
			// if arrival and departure time are in the same day check if arrival time > departure time
			var arrivalTime = document.forms["creaFermataCorsaForm"]["arrival"].value;
			var departureTime = document.forms["creaFermataCorsaForm"]["departure"].value;
			if (arrivalTime > departureTime) {
				$("#wrong-times").show();
				return false;
			}
		}
		
		return true;
	};
	
	// edit trip-stop association form validation 
	function validateModificaFermataCorsaForm() {
		if (document.forms["modificaFermataCorsaForm"]["sameDay"].checked) {
			// if arrival and departure time are in the same day check if arrival time > departure time
			var arrivalTime = document.forms["modificaFermataCorsaForm"]["arrival"].value;
			var departureTime = document.forms["modificaFermataCorsaForm"]["departure"].value;
			if (arrivalTime > departureTime) {
				$("#wrong-times").show();
				return false;
			}
		}
		
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
		
		// per ogni fermata dell'agenzia non associata alla corsa attiva (listaFermateNonAssociate) creo un marker, con un popup contenente il form per l'associazione con la corsa
		<c:forEach var="fermata" items="${listaFermateNonAssociate}">
			var popupContent = '<form:form name="creaFermataCorsaForm" commandName="stopTime" method="post" role="form" onsubmit="return validateCreaFermataCorsaForm()">' +
									"<b>Fermata: </b> ${fermata.gtfsId}" +
									'<input name="stopId" type="hidden" value="${fermata.id}" />' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="arrival" class="required">Ora arrivo</label>' +
											'<input type="time" name="arrival" class="form-control" id="arrivalTime" required="true" step="1" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="departure" class="required">Ora partenza</label>' +
											'<input type="time" name="departure" class="form-control" id="departureTime" required="true" step="1" />' +
										'</div>' +
									'</div>' +
									'<div class="checkbox">' +
										'<label>' +
							    			'<input type="checkbox" name="sameDay" id="sameDay" checked>Ora partenza e arrivo nello stesso giorno' +
										'</label>' +
										'<p class="help-block">Deselezionare solo se l\'ora di arrivo è nel giorno successivo all\'ora di partenza.</p>' + 
									'</div>' +
									'<div class="checkbox">' +
										'<label>' +
							    			'<form:checkbox path="continueFromPreviousDay" id="continueFromPreviousDay" />Ora partenza e arrivo continuano dal giorno precedente' +
										'</label>' +
										'<p class="help-block">Selezionare solo se gli orari di arrivo e partenza continuano dal giorno precedente (una delle precedenti fermate ha orari del giorno precedente es. 23:58, mentre questa ha orari nel giorno successivo es. 00:02).</p>' + 
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
				.bindLabel("${fermata.gtfsId}");
			
			markers.addLayer(marker);
		</c:forEach>
		
		var fermateCorsaCoordinates = new Array();
		
		// per ogni fermata associata alla corsa attiva (listaFermateCorsa) creo un marker, con un popup contenente il form per la modifica dell'associazione con la corsa
		<c:forEach var="fermataCorsa" items="${listaFermateCorsa}">
			var popupContent = '<form:form name="modificaFermataCorsaForm" commandName="stopTime" method="post" role="form" action="/_5t/modificaFermataCorsa" onsubmit="return validateModificaFermataCorsaForm()">' +
									"<b>Fermata: </b> ${fermataCorsa.stop.gtfsId}" +
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
											'<input type="time" name="arrival" class="form-control" id="arrivalTime" value="${fermataCorsa.arrivalTime}" required="true" step="1" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="departure" class="required">Ora partenza</label>' +
											'<input type="time" name="departure" class="form-control" id="departureTime" value="${fermataCorsa.departureTime}" required="true" step="1" />' +
										'</div>' +
									'</div>' +
									'<div class="checkbox">' +
										'<label>' +
							    			'<input type="checkbox" name="sameDay" id="sameDay" checked>Ora partenza e arrivo nello stesso giorno' +
										'</label>' +
										'<p class="help-block">Deselezionare solo se l\'ora di arrivo è nel giorno successivo all\'ora di partenza.</p>' + 
									'</div>' +
									'<div class="checkbox">' +
										'<label>';
			<c:choose>
				<c:when test="${not fermataCorsa.continueFromPreviousDay}">
						popupContent += '<form:checkbox path="continueFromPreviousDay" id="continueFromPreviousDay" />Ora partenza e arrivo continuano dal giorno precedente';
				</c:when>
				<c:otherwise>
						popupContent += '<form:checkbox path="continueFromPreviousDay" id="continueFromPreviousDay" checked="true" />Ora partenza e arrivo continuano dal giorno precedente';
				</c:otherwise>
			</c:choose>							
							popupContent += '</label>' +
										'<p class="help-block">Selezionare solo se gli orari di arrivo e partenza continuano dal giorno precedente (una delle precedenti fermate ha orari del giorno precedente es. 23:58, mentre questa ha orari nel giorno successivo es. 00:02).</p>' + 
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
				.bindLabel("${fermataCorsa.stopSequence} ${fermataCorsa.stop.gtfsId}");
			
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
			
			$("#encodedPolyline").val(polyline.encodePath().replace(/\\/g, "\\\\"));
			$("#creaShapeForm").submit();
		});
		
		$("#calcolaPercorsoOTPButton").click(function() {
			var polyline = new L.Polyline([]);
			// for each couple of stops
			for (var i=2; i<fermateCorsaCoordinates.length; i++) {
				// call to the otp web service to calculate trip
				$.ajax({
					url: "http://www.5t.torino.it/otpws/routers/default/plan?fromPlace=" + fermateCorsaCoordinates[i-1][0]+ "%2C" + fermateCorsaCoordinates[i-1][1] + "&toPlace=" + fermateCorsaCoordinates[i][0]+ "%2C" + fermateCorsaCoordinates[i][1]+ "&mode=CAR",
					//url: "http://www.5t.torino.it/otp/ws/routers/default/plan?fromPlace=" + fermateCorsaCoordinates[i-1][0]+ "%2C" + fermateCorsaCoordinates[i-1][1] + "&toPlace=" + fermateCorsaCoordinates[i][0]+ "%2C" + fermateCorsaCoordinates[i][1]+ "&mode=CAR",
					//url: "http://oltrepo:8080/otp/routers/default/plan?fromPlace=" + fermateCorsaCoordinates[i-1][0]+ "%2C" + fermateCorsaCoordinates[i-1][1] + "&toPlace=" + fermateCorsaCoordinates[i][0]+ "%2C" + fermateCorsaCoordinates[i][1]+ "&mode=CAR",
					dataType: "json",
					async: false
				}).done(function(data) {
					//console.log("Points: " + data.plan.itineraries[0].legs[0].legGeometry.points);
					// the returned data is a JSON object, in points there is the encoded polyline
					var latLngs = L.Polyline.fromEncoded(data.plan.itineraries[0].legs[0].legGeometry.points).getLatLngs();
					// each point in the encoded polyline is added to an array of points, that at the end will contain all points from the first to the last stop
					for (var j=0; j<latLngs.length; j++) {
						polyline.addLatLng(latLngs[j]);
					}
				});
			}
			console.log("Shape: " + polyline.encodePath());
			drawnItems.clearLayers();
			drawnItems.addLayer(polyline);
			// the encoded polyline is saved into the database, after escaping backslashes
			$("#encodedPolyline").val(polyline.encodePath().replace(/\\/g, "\\\\"));
			$("#creaShapeForm").submit();
		});
		
		map.on('draw:edited', function (e) {
			var layers = e.layers;
		    layers.eachLayer(function (layer) {
				$("#encodedPolyline").val(layer.encodePath().replace(/\\/g, "\\\\"));
				$("#creaShapeForm").submit();
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
		
		$('#stopTimeTable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	"bSort": false,
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna fermata associata"
	    	}
	    });
	});
    </script>
</head>
<body>
	<!-- Navigation bar -->
	<nav id="navigationBar" class="navbar navbar-default" role="navigation"></nav>
	
	<ol class="breadcrumb">
		<li><a href="/_5t/agenzie">Agenzia: <b>${agenziaAttiva.gtfsId}</b></a></li>
		<li><a href="/_5t/linee">Linea: <b>${lineaAttiva.gtfsId}</b></a></li>
		<li><a href="/_5t/corse">Corsa: <b>${corsaAttiva.gtfsId}</b></a></li>
		<li class="active">Fermate</li>
	</ol>
	
	<h3>Assegnazione fermate alla corsa ${corsaAttiva.gtfsId}</h3>
	
	<p>Cliccare su una fermata per aggiungerla alla corsa. Le fermate verdi appartengono alla corsa.<br>
	"Unisci fermate" unisce le fermate che appartengono alla corsa con segmenti. Lo shape può essere modificato cliccando sul pulsante "Edit layers" sotto lo zoom.</p>
	
	<div id="map" class="col-lg-8"></div>
	<div class="col-lg-4">
		<button id="unisciFermateButton" class="btn btn-primary">Unisci fermate</button>
		<button id="calcolaPercorsoOTPButton" class="btn btn-primary">Calcola percorso con OTP</button>
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
		</form:form>
		
		<div class="row col-lg-12">
			<a type="button" class="btn btn-default" href="/_5t/fermate">Aggiungi altre fermate all'agenzia</a>
		</div>
		<br><br><br>
		<c:if test="${not empty listaFermateCorsa}">
			<div class="row col-lg-12">
				<table id="stopTimeTable" class="table table-striped">
					<thead>
						<tr>
							<th>N°</th>
							<th>Fermata</th>
							<th>Arrivo</th>
							<th>Partenza</th>
						</tr>
					</thead>
					<tbody>
						<%
						class StopTimeComparator implements Comparator<StopTime> {
		
							@Override
							public int compare(StopTime o1, StopTime o2) {
								return o1.getStopSequence().compareTo(o2.getStopSequence());
							}
							
						}
						List<StopTime> stopTimes = new ArrayList<StopTime>((Set<StopTime>) request.getAttribute("listaFermateCorsa"));
						Collections.sort(stopTimes, new StopTimeComparator());
						SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
						Calendar cal = new GregorianCalendar();
						cal.setTime(new Time(0, 0, 0));
						int i = 1;
						for (StopTime st: stopTimes) {
						%>
						<tr>
							<td><%= i++ %></td>
							<td><% out.write(st.getStop().getName()); %></td>
			            	<%
			            	if (st.getArrivalTime() != null)
			            		cal.setTime(st.getArrivalTime());
			            	%>
			              	<td><% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), cal.get(java.util.Calendar.SECOND)))); %></td>
			            	<%
			            	if (st.getDepartureTime() != null)
			            		cal.setTime(st.getDepartureTime());
			            	%>
			              	<td><% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), cal.get(java.util.Calendar.SECOND)))); %></td>
						</tr>
						<% } %>
					</tbody>
			    </table>
			</div>
		</c:if>
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