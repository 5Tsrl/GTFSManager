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
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css" />
	<link href="<c:url value='/resources/css/leaflet.label.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.markcluster.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/leaflet.geosearch.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script src="http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.label.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.markcluster.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.control.geosearch.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/leaflet.geosearch.provider.openstreetmap.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/timezones.js' />"></script>
	<script type="text/javascript">
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
		
		var markers = new L.MarkerClusterGroup();
		
		var lats = {};
		var lons = {};
		
		// for each stop of the agency (listaFermate) a marker is created, with a popup containing edit stop form
		<c:forEach var="fermata" items="${listaFermate}">
			$(function() {
				var popupContent = '<form:form id="modificaFermataForm" commandName="stop" method="post" role="form" action="modificaFermata?id=${fermata.id}">' +
										'<div class="row">' +
											'<div class="form-group col-lg-6">' +
												'<label for="lat" class="required">Latitudine</label>' +
												'<form:input path="lat" class="form-control" id="lat" value="${fermata.lat}" required="true" />' +
												'<form:errors path="lat" cssClass="error"></form:errors>' +
											'</div>' +
											'<div class="form-group col-lg-6">' +
												'<label for="lon" class="required">Longitudine</label>' +
												'<form:input path="lon" class="form-control" id="lon" value="${fermata.lon}" required="true" />' +
												'<form:errors path="lon" cssClass="error"></form:errors>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="gtfsId" class="required">Id</label>' +
												'<form:input path="gtfsId" class="form-control" id="gtfsId" value="${fermata.gtfsId}" maxlength="50" required="true" />' +
												'<form:errors path="gtfsId" cssClass="error"></form:errors>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="name" class="required">Nome</label>' +
												'<form:input path="name" class="form-control" id="name" value="${fermata.name}" maxlength="50" required="true" />' +
												'<form:errors path="name" cssClass="error"></form:errors>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="code">Codice</label>' +
												'<form:input path="code" class="form-control" id="code" value="${fermata.code}" maxlength="20" />' +
												'<form:errors path="code" cssClass="error"></form:errors>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="desc">Descrizione</label>' +
												'<form:input path="desc" class="form-control" id="desc" value="${fermata.desc}" maxlength="255" />' +
												'<form:errors path="desc" cssClass="error"></form:errors>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="zoneId">Zona</label>' +
												'<select name="zoneId" class="form-control" id="zoneId">' +
													'<option></option>';
				<c:forEach var="zone" items="${listaZone}">
					<c:choose>
						<c:when test="${zone.id == fermata.zone.id}">
								popupContent += '<option value="${zone.id}" selected="true">${zone.gtfsId}</option>';
						</c:when>
						<c:otherwise>
								popupContent += '<option value="${zone.id}">${zone.gtfsId}</option>';
						</c:otherwise>
					</c:choose>
				</c:forEach>
								popupContent += '</select>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="url">Sito web</label>' +
												'<form:input type="url" path="url" class="form-control" id="url" value="${fermata.url}" maxlength="255" />' +
												'<form:errors path="url" cssClass="error"></form:errors>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="locationType">Tipo</label>' +
												'<form:select path="locationType" class="form-control" id="locationType">';
				if ("${fermata.locationType}" == 0) {
					popupContent += '<form:option value="0" selected="true">Fermata</form:option>' +
									'<form:option value="1">Stazione</form:option>';
				} else {
					popupContent += '<form:option value="0">Fermata</form:option>' +
									'<form:option value="1" selected="true">Stazione</form:option>';
				}
								popupContent +=	'</form:select>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="parentStationId">Stazione padre</label>' +
												'<select name="parentStationId" class="form-control" id="parentStationId">' +
													'<option></option>';
				<c:forEach var="station" items="${listaStazioni}">
					if ("${station.id != fermata.id}" != "false") {
						<c:choose>
							<c:when test="${station.id == fermata.parentStation.id}">
										popupContent += '<option value="${station.id}" selected="true">${station.name}</option>';
							</c:when>
							<c:otherwise>
										popupContent += '<option value="${station.id}">${station.name}</option>';
							</c:otherwise>
						</c:choose>
					}
				</c:forEach>
								popupContent += '</select>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
// 												'<label for="timezone">Fuso orario</label>' +
// 												'<form:select path="timezone" class="form-control" id="timezonesEdit">';
// 				for (var i=0; i<timezones.length; i++) {
// 					var timezone;
// 				    if (timezone == timezones[i].key) {
// 						popupContent += '<form:option value="' + timezones[i].key + '" selected="true">' + timezones[i].value + '</form:option>';
// 				    } else {
// 						popupContent += '<form:option value="' + timezones[i].key + '">' + timezones[i].value + '</form:option>';
// 				    }
// 				}								
// 								popupContent +=	'</form:select>' +
												'<b>Fuso orario:</b> ${fermata.timezone}' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<label for="wheelchairBoarding">Accessibile ai disabili</label>' +
												'<form:select path="wheelchairBoarding" class="form-control">';
				if ("${fermata.wheelchairBoarding}" == 0) {
					popupContent += '<form:option value="0" selected="true">Informazione non disponibile</form:option>' +
									'<form:option value="1">Sì</form:option>' +
									'<form:option value="2">No</form:option>';
				} else if ("${fermata.wheelchairBoarding}" == 1) {
					popupContent += '<form:option value="0">Informazione non disponibile</form:option>' +
									'<form:option value="1" selected="true">Sì</form:option>' +
									'<form:option value="2">No</form:option>';
				} else {
					popupContent += '<form:option value="0">Informazione non disponibile</form:option>' +
									'<form:option value="1">Sì</form:option>' +
									'<form:option value="2" selected="true">No</form:option>';
				}
								popupContent +=	'</form:select>' +
												'<form:errors path="wheelchairBoarding" cssClass="error"></form:errors>' +
											'</div>' +
										'</div>' +
										'<div class="row">' +
											'<div class="form-group">' +
												'<input class="btn btn-success" type="submit" value="Modifica" />' +
											'</div>' +
										'</div>' +
									'</form:form>';
				var marker;
				if ("${fn:length(fermata.stopTimeRelatives)}" > 0 || "${fn:length(fermata.stops)}" > 0) {
					// if the stop has some trips associated or it is a station with some children stops, it is green and can't be deleted; a list of all trips associated and children stops is displayed
					popupContent +=	'<p>Non puoi eliminare questa fermata.<br>Le seguenti corse sono associate ad essa:</p><ul>';
					var tripsNotShown = 0;
					<c:forEach var="stopTimeRelative" items="${fermata.stopTimeRelatives}">
						if ("${i.index}" < 10)
							popupContent +=	'<li>${stopTimeRelative.tripPattern.route.gtfsId} - ${stopTimeRelative.tripPattern.gtfsId}</li>';
						else
							tripsNotShown++;
					</c:forEach>
					if (tripsNotShown > 0)
						popupContent +=	"<li>... altre " + tripsNotShown + " corse</li>";
					popupContent +=	'</ul>';
					popupContent +=	'<p>Le seguenti fermate sono all\'interno della stazione:</p><ul>';
					<c:forEach var="childStop" items="${fermata.stops}">
						popupContent +=	'<li>${childStop.name}</li>';
					</c:forEach>
					popupContent +=	'</ul>';
					
					var greenIcon = L.icon({
					    iconUrl: "<c:url value='/resources/images/green-marker.png' />",
					    iconSize: [25, 41],
				        iconAnchor: [12, 41],
				        popupAnchor: [1, -34]
					});
					marker = L.marker(["${fermata.lat}", "${fermata.lon}"], {draggable: true, icon: greenIcon})
						.bindPopup(popupContent, {minWidth: 300})
						.bindLabel("${fermata.name}");
				} else {
					// else it can be deleted, since it has no trips associated
					popupContent +=	'<a class="btn btn-danger active" href="eliminaFermata?id=${fermata.id}">Elimina</a>';
					
					marker = L.marker(["${fermata.lat}", "${fermata.lon}"], {draggable: true})
						.bindPopup(popupContent, {minWidth: 300})
						.bindLabel("${fermata.name}");
				}
				
				lats["${fermata.id}"] = "${fermata.lat}";
				lons["${fermata.id}"] = "${fermata.lon}";
				// if the marker is dragged, once it is released a popup to edit the stop with the updated coordinates should be opened
				marker.on("dragend", function() {
					this.update();
					console.log(lats);
					var newPopupContentLat = this.getPopup().getContent().replace('<input id="lat" name="lat" value="' + lats["${fermata.id}"] + '" class="form-control" required="true" type="text"', '<input id="lat" name="lat" value="' + this.getLatLng().lat + '" class="form-control" required="true" type="text"');
					var newPopupContentLatLon = newPopupContentLat.replace('<input id="lon" name="lon" value="' + lons["${fermata.id}"] + '" class="form-control" required="true" type="text"', '<input id="lon" name="lon" value="' + this.getLatLng().lng + '" class="form-control" required="true" type="text"');
					lats["${fermata.id}"] = this.getLatLng().lat;
					lons["${fermata.id}"] = this.getLatLng().lng;
					this.bindPopup(newPopupContentLatLon, {minWidth: 300}).openPopup();
				});
				
				markers.addLayer(marker);
				
				// Popover
// 				$("#modificaFermataForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una fermata o stazione. Più linee possono usare la stessa fermata." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#name").popover({ container: 'body', trigger: 'focus', title:"Nome", content:"Il nome della fermata o stazione. Usare un nome che le persone possano capire nella lingua locale e turistica." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#code").popover({ container: 'body', trigger: 'focus', title:"Codice", content:"Breve testo o numero che identifica univocamente la fermata per i passeggeri. I codici delle fermate sono spesso usati in sistemi informativi di transito basati sul telefono o stampati sulle paline per rendere più semplice ai passeggeri ottenere il calendario della fermata o informazioni di arrivo in tempo reale per una specifica fermata." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#desc").popover({ container: 'body', trigger: 'focus', title:"Descrizione", content:"La descrizione della fermata. Usare informazioni utili (non duplicare semplicemente il nome della fermata)." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#lat").popover({ container: 'body', trigger: 'focus', title:"Latitudine", content:"La latitudine della fermata o stazione." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#lon").popover({ container: 'body', trigger: 'focus', title:"Longitudine", content:"La longitudine della fermata o stazione." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#url").popover({ container: 'body', trigger: 'focus', title:"Sito web", content:"La pagine web di una specifica fermata (dovrebbe essere diversa dai campi url dell'agenzia e della linea). L'url deve essere completa, includendo http:// o https://." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#locationType").popover({ container: 'body', trigger: 'focus', title:"Tipo", content:"Il tipo indica se si tratta di una fermata o una stazione. Fermata: luogo in cui i passeggeri possono salire o scendere da un mezzo di trasporto. Stazione: struttura fisica o area che contiene una o più fermate." })
// 					.blur(function () { $(this).popover('hide'); });
// 				$("#modificaFermataForm").find("#wheelchairBoarding").popover({ container: 'body', trigger: 'focus', title:"Accessibile ai disabili", content:"Indica se la fermata o stazione è accessibile ai disabili." })
// 					.blur(function () { $(this).popover('hide'); });
			});
		</c:forEach>
		
		map.addLayer(markers);
		
		// right clicking on the map create a new marker, with a popup containing a creation stop form  
		map.on("contextmenu", function(e) {
			// add a marker in the given location, attach some popup content to it and open the popup
			var popupContent = '<form:form id="creaFermataForm" commandName="stop" method="post" role="form">' +
									'<div class="row">' +
									'<div class="form-group col-lg-6">' +
										'<label for="lat" class="required">Latitudine</label>' +
										'<form:input path="lat" class="form-control" id="lat" required="true" />' +
										'<form:errors path="lat" cssClass="error"></form:errors>' +
									'</div>' +
									'<div class="form-group col-lg-6">' +
										'<label for="lon" class="required">Longitudine</label>' +
										'<form:input path="lon" class="form-control" id="lon" required="true" />' +
										'<form:errors path="lon" cssClass="error"></form:errors>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="gtfsId" class="required">Id</label>' +
										'<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l\'id" maxlength="50" required="true" />' +
										'<form:errors path="gtfsId" cssClass="error"></form:errors>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="name" class="required">Nome</label>' +
										'<form:input path="name" class="form-control" id="name" placeholder="Inserisci il nome" maxlength="50" required="true" />' +
										'<form:errors path="name" cssClass="error"></form:errors>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="code">Codice</label>' +
										'<form:input path="code" class="form-control" id="code" placeholder="Inserisci il codice" maxlength="20" />' +
										'<form:errors path="code" cssClass="error"></form:errors>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="desc">Descrizione</label>' +
										'<form:textarea path="desc" class="form-control" id="desc" placeholder="Inserisci la descrizione" maxlength="255" rows="2" />' +
										'<form:errors path="desc" cssClass="error"></form:errors>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="zoneId">Zona</label>' +
										'<select name="zoneId" class="form-control" id="zoneId">' +
											'<option></option>';
			<c:forEach var="zone" items="${listaZone}">
							popupContent += '<option value="${zone.id}">${zone.gtfsId}</option>';
			</c:forEach>
						popupContent += '</select>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="url">Sito web</label>' +
										'<form:input type="url" path="url" class="form-control" id="url" placeholder="Inserisci il sito web" maxlength="255" />' +
										'<form:errors path="url" cssClass="error"></form:errors>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="locationType">Tipo</label>' +
										'<form:select path="locationType" class="form-control" id="locationType">' +
											'<form:option value="0" selected="true">Fermata</form:option>' +
											'<form:option value="1">Stazione</form:option>' +
										'</form:select>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="parentStationId">Stazione padre</label>' +
										'<select name="parentStationId" class="form-control" id="parentStationId">' +
											'<option></option>';
			<c:forEach var="station" items="${listaStazioni}">
							popupContent += '<option value="${station.id}">${station.name}</option>';
			</c:forEach>
						popupContent += '</select>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="timezone">Fuso orario</label>' +
										'<form:select path="timezone" class="form-control" id="timezones"></form:select>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<label for="wheelchairBoarding">Accessibile ai disabili</label>' +
										'<form:select path="wheelchairBoarding" class="form-control">' +
											'<form:option value="0" selected="true">Informazione non disponibile</form:option>' +
											'<form:option value="1">Sì</form:option>' +
											'<form:option value="2">No</form:option>' +
										'</form:select>' +
										'<form:errors path="wheelchairBoarding" cssClass="error"></form:errors>' +
									'</div>' +
								'</div>' +
								'<div class="row">' +
									'<div class="form-group">' +
										'<input class="btn btn-success" type="submit" value="Crea fermata" />' +
									'</div>' +
								'</div>' +
							'</form:form>';
			
			var marker = L.marker(e.latlng, {title: "${fermata.name}"}).addTo(map)
			    .bindPopup(popupContent, {minWidth: 300})
			    .openPopup();
			$("#lat").val(e.latlng.lat);
			$("#lon").val(e.latlng.lng);
			
			// if the stop creation popup is closed (so the form is not submitted), the marker is deleted
			marker.on('popupclose', function (e) {
	            if (!$("creaFermataForm").find("#name").val()) {
	            	map.removeLayer(marker);
	            }
	        });
			
			// fill timezones select using objects array in timezones.j
			var selTimezones = document.getElementById("timezones");
			for (var i=0; i<timezones.length; i++) {
				var opt = document.createElement('option');
			    opt.innerHTML = timezones[i].value;
			    opt.value = timezones[i].key;
			    if (timezones[i].key=="${agenziaAttiva.timezone}") {
			    	opt.selected = true;
			    }
			    selTimezones.appendChild(opt);
			}
			
			// Popover
			$("#creaFermataForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una fermata o stazione. Più linee possono usare la stessa fermata." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#name").popover({ container: 'body', trigger: 'focus', title:"Nome", content:"Il nome della fermata o stazione. Usare un nome che le persone possano capire nella lingua locale e turistica." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#code").popover({ container: 'body', trigger: 'focus', title:"Codice", content:"Breve testo o numero che identifica univocamente la fermata per i passeggeri. I codici delle fermate sono spesso usati in sistemi informativi di transito basati sul telefono o stampati sulle paline per rendere più semplice ai passeggeri ottenere il calendario della fermata o informazioni di arrivo in tempo reale per una specifica fermata." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#desc").popover({ container: 'body', trigger: 'focus', title:"Descrizione", content:"La descrizione della fermata. Usare informazioni utili (non duplicare semplicemente il nome della fermata)." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#lat").popover({ container: 'body', trigger: 'focus', title:"Latitudine", content:"La latitudine della fermata o stazione." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#lon").popover({ container: 'body', trigger: 'focus', title:"Longitudine", content:"La longitudine della fermata o stazione." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#url").popover({ container: 'body', trigger: 'focus', title:"Sito web", content:"La pagine web di una specifica fermata (dovrebbe essere diversa dai campi url dell'agenzia e della linea). L'url deve essere completa, includendo http:// o https://." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#locationType").popover({ container: 'body', trigger: 'focus', title:"Tipo", content:"Il tipo indica se si tratta di una fermata o una stazione. Fermata: luogo in cui i passeggeri possono salire o scendere da un mezzo di trasporto. Stazione: struttura fisica o area che contiene una o più fermate." })
				.blur(function () { $(this).popover('hide'); });
			$("#creaFermataForm").find("#wheelchairBoarding").popover({ container: 'body', trigger: 'focus', title:"Accessibile ai disabili", content:"Indica se la fermata o stazione è accessibile ai disabili." })
				.blur(function () { $(this).popover('hide'); });
		});
	});
	
	$(document).ready(function() {
		// alerts initially hidden
		$(".alert").hide();
		
		// showAlertDuplicateStop variable is set to true by StopController if the stop id is already present
		if ("${showAlertDuplicateStop}") {
			$("#stop-already-inserted").show();
		}
		
		// showAlertParentStation variable is set to true by StopController if trying to insert a station with a parent station
		if ("${showAlertParentStation}") {
			$("#parent-station").show();
		}
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
	});
    </script>
</head>
<body>
	<!-- Navigation bar -->
	<nav id="navigationBar" class="navbar navbar-default" role="navigation"></nav>
	
	<ol class="breadcrumb">
		<li><a href="agenzie">Agenzia: <b>${agenziaAttiva.gtfsId}</b></a></li>
		<li class="active">Fermate</li>
	</ol>
	
	<h3>Gestione fermate</h3>
	
	<p>Cliccare con il tasto destro sulla mappa per creare una nuova fermata o cliccare su un marker per modificarla.<br>
	Le fermate verdi sono associate ad almeno una corsa e non possono essere eliminate.</p>
	
	<div id="map" class="col-lg-8"></div>
	<div class="col-lg-4">
		<c:if test="${not empty lineaAttiva.gtfsId && not empty schemaCorsaAttivo.gtfsId}">
			<a class="btn btn-default" href="fermateSchemaCorsa">Assegna fermate allo schema corsa ${schemaCorsaAttivo.gtfsId}</a>
		</c:if>
	</div>
	
	<!-- Alerts -->
	<div id="stop-already-inserted" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id della fermata che hai inserito è già presente.
	</div>
	<div id="parent-station" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> Una stazione non può avere una stazione padre.
	</div>
</body>
</html>