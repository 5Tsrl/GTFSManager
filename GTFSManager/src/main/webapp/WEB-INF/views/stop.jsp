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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
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
		var map
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
		
		// per ogni fermata dell'agenzia (listaFermate) creo un marker, con un popup contenente il form per la modifica della fermata
		<c:forEach var="fermata" items="${listaFermate}">
			var popupContent = '<form:form id="form${fermata.id}" commandName="stop" method="post" role="form" action="modificaFermata?id=${fermata.id}">' +
									'<div class="row">' +
										'<div class="form-group col-lg-6">' +
											'<label for="lat">Latitudine</label>' +
											'<form:input path="lat" class="form-control" id="lat" value="${fermata.lat}" />' +
											'<form:errors path="lat" cssClass="error"></form:errors>' +
										'</div>' +
										'<div class="form-group col-lg-6">' +
											'<label for="lon">Longitudine</label>' +
											'<form:input path="lon" class="form-control" id="lon" value="${fermata.lon}" />' +
											'<form:errors path="lon" cssClass="error"></form:errors>' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="name">Nome</label>' +
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
// 									'<div class="row">' +
// 										'<div class="form-group">' +
// 											'<label for="timezone">Fuso orario</label>' +
// 											'<form:select path="timezone" class="form-control" id="timezonesEdit">';
// 			for (var i=0; i<timezones.length; i++) {
// 			    if ("${fermata.timezone}" == timezones[i].key) {
// 					popupContent += '<form:option value="' + timezones[i].key + '" selected="true">' + timezones[i].value + '</form:option>';
// 			    } else {
// 					popupContent += '<form:option value="' + timezones[i].key + '">' + timezones[i].value + '</form:option>';
// 			    }
// 			}								
// 							popupContent +=	'</form:select>' +
// 										'</div>' +
// 									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<b>Fuso orario: </b>"${fermata.timezone}"' +
										'</div>' +
									'</div>' +
									'<div class="row">' +
										'<div class="form-group">' +
											'<label for="wheelchairBoarding">Accessibile ai disabili</label>' +
											'<form:select path="wheelchairBoarding">';
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
								'</form:form>' +
								'<a class="btn btn-danger active" href="/_5t/eliminaFermata?id=${fermata.id}">Elimina</a>';
			
			var marker = L.marker(["${fermata.lat}", "${fermata.lon}"], {draggable: true})
				.bindPopup(popupContent, {minWidth: 300})
				.bindLabel("${fermata.name}");
			
			lats["${fermata.id}"] = "${fermata.lat}";
			lons["${fermata.id}"] = "${fermata.lon}";
			// se il marker viene draggato, una volta rilasciato deve aprirsi il popup per la modifica della fermata con le coordinate aggiornate
			marker.on("dragend", function() {
				this.update();
				console.log(lats);
				var newPopupContentLat = this.getPopup().getContent().replace('<input id="lat" name="lat" value="' + lats["${fermata.id}"] + '" class="form-control" type="text"', '<input id="lat" name="lat" value="' + this.getLatLng().lat + '" class="form-control" type="text"');
				var newPopupContentLatLon = newPopupContentLat.replace('<input id="lon" name="lon" value="' + lons["${fermata.id}"] + '" class="form-control" type="text"', '<input id="lon" name="lon" value="' + this.getLatLng().lng + '" class="form-control" type="text"');
				lats["${fermata.id}"] = this.getLatLng().lat;
				lons["${fermata.id}"] = this.getLatLng().lng;
				this.bindPopup(newPopupContentLatLon, {minWidth: 300}).openPopup();
			});
			
			markers.addLayer(marker);
		</c:forEach>
		
		map.addLayer(markers);
		
		// quando clicco con il tasto destro sulla mappa viene creato un nuovo marker, con un popup contenente un form per la creazione della fermata
		map.on("contextmenu", function(e) {
			// add a marker in the given location, attach some popup content to it and open the popup
			var marker = L.marker(e.latlng, {title: "${fermata.name}"}).addTo(map)
			    .bindPopup('<form:form id="creaFermataForm" commandName="stop" method="post" role="form">' +
			    				'<div class="row">' +
			    					'<div class="form-group col-lg-6">' +
			    						'<label for="lat">Latitudine</label>' +
			    						'<form:input path="lat" class="form-control" id="lat" />' +
			    						'<form:errors path="lat" cssClass="error"></form:errors>' +
			    					'</div>' +
			    					'<div class="form-group col-lg-6">' +
			    						'<label for="lon">Longitudine</label>' +
			    						'<form:input path="lon" class="form-control" id="lon" />' +
			    						'<form:errors path="lon" cssClass="error"></form:errors>' +
			    					'</div>' +
			    				'</div>' +
			    				'<div class="row">' +
			    					'<div class="form-group">' +
			    						'<label for="name">Nome</label>' +
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
			    						'<label for="timezone">Fuso orario</label>' +
			    						'<form:select path="timezone" class="form-control" id="timezones"></form:select>' +
			    					'</div>' +
			    				'</div>' +
			    				'<div class="row">' +
									'<div class="form-group">' +
										'<label for="wheelchairBoarding">Accessibile ai disabili</label>' +
										'<form:select path="wheelchairBoarding">' +
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
			    			'</form:form>',
			    		{minWidth: 300})
			    .openPopup();
			$("#lat").val(e.latlng.lat);
			$("#lon").val(e.latlng.lng);
			
			// se il popup per la creazione della fermata viene chiuso (e quindi il form non sottomesso), il marker viene eliminato
			marker.on('popupclose', function (e) {
	            if (!$("creaFermataForm").find("#name").val()) {
	            	map.removeLayer(marker);
	            }
	        });
			
			// riempe il select delle timezones usando l'array di oggetti in timezones.js
			var selTimezones = document.getElementById("timezones");
			for (var i=0; i<timezones.length; i++) {
				var opt = document.createElement('option');
			    opt.innerHTML = timezones[i].value;
			    opt.value = timezones[i].key;
			    if (timezones[i].key=="Europe/Rome") {
			    	opt.selected = true;
			    }
			    selTimezones.appendChild(opt);
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
		<c:if test="${not empty lineaAttiva.shortName && not empty corsaAttiva.tripShortName}">
			<li><a href="/_5t/linee">Linea ${lineaAttiva.shortName}</a></li>
			<li><a href="/_5t/corse">Corsa ${corsaAttiva.tripShortName}</a></li>
		</c:if>
		<li class="active">Fermate</li>
	</ol>
	
	<h3>Gestione fermate</h3>
	
	<p>Cliccare con il tasto destro sulla mappa per creare una nuova fermata o cliccare su un marker per modificarla</p>
	
	<div id="map" class="col-lg-8"></div>
	<div class="col-lg-4">
		<c:if test="${not empty lineaAttiva.shortName && not empty corsaAttiva.tripShortName}">
			<a class="btn btn-default" href="/_5t/fermateCorse">Assegna fermate alla corsa ${corsaAttiva.tripShortName}</a>
		</c:if>
	</div>
</body>
</html>