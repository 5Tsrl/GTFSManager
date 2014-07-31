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
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
	<link href="<c:url value='/resources/css/leaflet.label.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.markcluster.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.geosearch.css' />" type="text/css" rel="stylesheet">
	<link href="https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.css" type="text/css" rel="stylesheet">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
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
	// validazione del form per la modifica di un'associazione di una corsa a una fermata
	function validateModificaFermataCorsaForm() {
		// controllo se ora arrivo > ora partenza
		var arrivalTime = document.forms["modificaFermataCorsaForm"]["arrival"].value;
		var departureTime = document.forms["modificaFermataCorsaForm"]["departure"].value;
		if (arrivalTime > departureTime) {
			alert("L'ora di arrivo non può essere successiva all'ora di partenza");
			return false;
		}
		
		// controllo se numero fermata > del massimo tra tutti i numeri di fermata
		var stopSequence = document.forms["modificaFermataCorsaForm"]["stopSequence"].value;
		var stopSequences = [];
		<c:forEach var="fermataCorsa" items="${listaFermateCorsa}">
			stopSequences.push("${fermataCorsa.stopSequence}");
		</c:forEach>
		if (stopSequence > Math.max.apply(null, stopSequences)) {
			alert("Il numero della fermata deve essere compreso tra 1 e " + Math.max.apply(null, stopSequences));
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
			var popupContent = '<form:form commandName="stopTime" method="post" role="form">' +
									"<b>Fermata: </b> ${fermata.name}" +
									'<input name="stopId" type="hidden" value="${fermata.id}" />' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="arrival">Ora arrivo</label>' +
											'<input type="time" name="arrival" class="form-control" id="arrivalTime" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="departure">Ora partenza</label>' +
											'<input type="time" name="departure" class="form-control" id="departureTime" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="stopHeadsign">Display</label>' +
											'<form:input path="stopHeadsign" class="form-control" id="stopHeadsign" maxlength="50" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="pickupType">Raccolta passeggeri</label>' +
											'<form:select path="pickupType">' +
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
											'<form:select path="dropOffType">' +
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
			var popupContent = '<form:form name="modificaFermataCorsaForm" commandName="stopTime" method="post" role="form" action="/_5t/modificaFermataCorsa" onsubmit="return validateModificaFermataCorsaForm()">' +
									"<b>Fermata: </b> ${fermataCorsa.stop.name}" +
									'<input name="stopTimeId" type="hidden" value="${fermataCorsa.id}" />' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="stopSequence">Numero fermata</label>' +
											'<form:input type="number" path="stopSequence" class="form-control" id="stopSequence" value="${fermataCorsa.stopSequence}" min="1" />' +
											'<form:errors path="stopSequence" cssClass="error"></form:errors>' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="arrival">Ora arrivo</label>' +
											'<input type="time" name="arrival" class="form-control" id="arrivalTime" value="${fermataCorsa.arrivalTime}" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="departure">Ora partenza</label>' +
											'<input type="time" name="departure" class="form-control" id="departureTime" value="${fermataCorsa.departureTime}" required="true" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="stopHeadsign">Display</label>' +
											'<form:input path="stopHeadsign" class="form-control" id="stopHeadsign" value="${fermataCorsa.stopHeadsign}" maxlength="50" />' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="pickupType">Raccolta passeggeri</label>' +
											'<form:select path="pickupType">';
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
											'<label for="dropOffType">Raccolta passeggeri</label>' +
											'<form:select path="dropOffType">';
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
		// la variabile showAlertWrongTimes è settata a true se l'ora di arrivo inserita nella fermata è successiva all'ora di partenza 
		if ("${showAlertWrongTimes}") {
			alert("L'ora di arrivo non può essere successiva all'ora di partenza");
		}
		
		// non si può salvare uno shape se non è ancora stato creato
		$("#creaShapeForm").submit(function(e) {
			if (!$("#encodedPolyline").val()) {
				alert("Devi creare uno shape prima di poterlo salvare");
				e.preventDefault();
			}
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
		<li><a href="/_5t/corse">Corsa ${corsaAttiva.tripShortName}</a></li>
		<li class="active">Fermate</li>
	</ol>
	
	<h3>Assegnazione fermate alla corsa ${corsaAttiva.tripShortName}</h3>
	
	<p>Cliccare su una fermata per aggiungerla alla corsa</p>
	
	<div id="map" class="col-lg-8"></div>
	<div class="col-lg-4">
		<button id="unisciFermateButton" class="btn btn-default">Unisci fermate</button>
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
	</div>
</body>
</html>