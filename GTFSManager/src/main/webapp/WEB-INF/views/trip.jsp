<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="it.torino._5t.entity.Trip" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Corse</title>
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	// load the navigation bar
	$(function(){
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liAgenzie").addClass("active");
    	}); 
    });
	
	$(document).ready(function() {
		// form per modificare una corsa inizialmente nascosto
		$("#modificaCorsa").hide();
		
		// la variabile showForm è settata a true da TripController se il form sottomesso per la creazione di una corsa contiene degli errori
		if (!"${showCreateForm}") {
			$("#creaCorsa").hide();
		} else {
			$("#creaCorsa").show();
		}
		
		// cliccando sul pulsante "Modifica corsa", il pulsante "Crea corsa" e il div con il riassunto della corsa attiva devono essere nascosti, mentre il form per modificare la corsa deve essere visualizzato
		$("#modificaCorsaButton").click(function() {
			$("#creaCorsaButton").hide();
			$("#riassuntoCorsa").hide();
			$("#modificaCorsa").show();
		});
		if ("${showEditForm}") {
			$("#creaCorsaButton").hide();
			$("#riassuntoCorsa").hide();
			$("#modificaCorsa").show();
		};
		
		// cliccando sul pulsante "Elimina", viene mostrata una finestra di dialogo che chiede la conferma dell'eliminazione
		$("#eliminaCorsaButton").click(function() {
			if (confirm("Vuoi veramente eliminare la corsa ${corsaAttiva.tripShortName}?"))
				window.location.href = "/_5t/eliminaCorsa";
		});
		
		// cliccando su una riga, la corsa corrispondente viene selezionata
		$("#listaCorse").find("tbody").find("tr").click(function() {
			var tripId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaCorsa?id=" + tripId;
		});
		
		// inizializzazione tabella affinchè le colonne possano essere ordinabili
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna corsa"
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
		<li class="active">Corse</li>
	</ol>
	
	<% 
	HashMap<Integer, String> direction = new HashMap<Integer, String>(); 
	direction.put(0, "Andata");
	direction.put(1, "Ritorno");
	
	HashMap<Integer, String> wheelchairAccessible = new HashMap<Integer, String>(); 
	wheelchairAccessible.put(0, "Informazione non disponibile");
	wheelchairAccessible.put(1, "Sì");
	wheelchairAccessible.put(2, "No");
	
	HashMap<Integer, String> bikesAllowed = new HashMap<Integer, String>(); 
	bikesAllowed.put(0, "Informazione non disponibile");
	bikesAllowed.put(1, "Sì");
	bikesAllowed.put(2, "No");
	%>
	
	<div class="row">
		<!-- Div con tabella contenente elenco corse -->
		<div class="col-lg-8">
			<table id="listaCorse" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Nome</th>
						<th>Direzione</th>
						<th>Calendario</th>
						<th>Servizi</th>
						<th>Fermate</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="corsa" items="${listaCorse}">
						<c:choose>
							<c:when test="${not empty corsaAttiva}">
								<c:if test="${corsaAttiva.id == corsa.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${corsa.tripShortName}</td>
							<td>
								<c:choose>
									<c:when test="${corsa.directionId == 0}">Andata</c:when>
									<c:otherwise>Ritorno</c:otherwise>
								</c:choose>
							</td>
							<td><a href="/_5t/selezionaCalendario?id=${corsa.calendar.id}">${corsa.calendar.name}</a></td>
							<td>
								${fn:length(corsa.frequencies)}
								<c:choose>
									<c:when test="${corsaAttiva.id == corsa.id}">
										<a class="btn btn-default" href="/_5t/servizi">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="/_5t/servizi">
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${fn:length(corsa.frequencies) == 0}">Inserisci servizi</c:when>
									<c:when test="${fn:length(corsa.frequencies) > 0}">Visualizza/modifica servizi</c:when>
								</c:choose>
								</a>
							</td>
							<td>
								${fn:length(corsa.stopTimes)}
								<c:choose>
									<c:when test="${corsaAttiva.id == corsa.id && fn:length(corsa.stopTimes) == 0}">
										<a class="btn btn-default" href="/_5t/fermate">
									</c:when>
									<c:when test="${corsaAttiva.id == corsa.id && fn:length(corsa.stopTimes) > 0}">
										<a class="btn btn-default" href="/_5t/fermateCorse">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="/_5t/fermate">
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${fn:length(corsa.stopTimes) == 0}">Inserisci fermate</c:when>
									<c:when test="${fn:length(corsa.stopTimes) > 0}">Visualizza/modifica fermate</c:when>
								</c:choose>
								</a>
							</td>
							<td class="hidden">${corsa.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div con pulsante per creare una corsa e riassunto dati corsa selezionata -->
		<div class="col-lg-4">
			<a id="creaCorsaButton" class="btn btn-primary" href="/_5t/creaCorsa">Crea una corsa</a>
			
			<!-- Div con form per creazione corsa -->
			<div id="creaCorsa">
				<form:form commandName="trip" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName">Nome</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" placeholder="Inserisci il nome" maxlength="50" />
				    		<form:errors path="tripShortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripHeadsign">Display</label>
				    		<form:input path="tripHeadsign" class="form-control" id="tripHeadsign" placeholder="Inserisci la scritta per il display" maxlength="50" />
				    		<form:errors path="tripHeadsign" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="directionId">Direzione</label>
							<form:select path="directionId">
								<form:option value="0" selected="true"><%= direction.get(0) %></form:option>
								<form:option value="1"><%= direction.get(1) %></form:option>
							</form:select>
							<form:errors path="directionId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="serviceId">Calendario</label>
							<select name="serviceId" required>
								<option value="">Seleziona un calendario</option>
								<c:forEach var="calendario" items="${listaCalendari}">
									<option value="${calendario.id}">${calendario.name}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="wheelchairAccessible">Accessibile ai disabili</label>
							<form:select path="wheelchairAccessible">
								<form:option value="0" selected="true"><%= wheelchairAccessible.get(0) %></form:option>
								<form:option value="1"><%= wheelchairAccessible.get(1) %></form:option>
								<form:option value="2"><%= wheelchairAccessible.get(2) %></form:option>
							</form:select>
							<form:errors path="wheelchairAccessible" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="bikesAllowed">Bici permesse</label>
							<form:select path="bikesAllowed">
								<form:option value="0" selected="true"><%= bikesAllowed.get(0) %></form:option>
								<form:option value="1"><%= bikesAllowed.get(1) %></form:option>
								<form:option value="2"><%= bikesAllowed.get(2) %></form:option>
							</form:select>
							<form:errors path="bikesAllowed" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea corsa" />
							<a class="btn btn-default" href="/_5t/corse">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div con riassunto corsa selezionata -->
			<c:if test="${not empty corsaAttiva}">
				<div id="riassuntoCorsa" class="riassunto">
					<% Trip trip = (Trip) session.getAttribute("corsaAttiva"); %>
					<div class="col-lg-8">
						<b>Nome:</b> ${corsaAttiva.tripShortName}
					</div>
					<div class="col-lg-8">
						<b>Display:</b> ${corsaAttiva.tripHeadsign}
					</div>
					<div class="col-lg-8">
						<b>Direzione:</b>
						<% out.write(direction.get(trip.getDirectionId())); %>
					</div>
					<div class="col-lg-8">
						<b>Calendario:</b> ${corsaAttiva.calendar.name}
					</div>
					<div class="col-lg-8">
						<b>Accessibile ai disabili:</b>
						<% out.write(wheelchairAccessible.get(trip.getWheelchairAccessible())); %>
					</div>
					<div class="col-lg-8">
						<b>Bici permesse:</b>
						<% out.write(bikesAllowed.get(trip.getBikesAllowed())); %>
					</div>
					<div class="col-lg-12">
						<a id="modificaCorsaButton" class="btn btn-primary" href="/_5t/modificaCorsa">Modifica</a>
						<button id="eliminaCorsaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div con form per modifica corsa -->
			<div id="modificaCorsa">
				<form:form commandName="trip" method="post" role="form" action="/_5t/modificaCorsa">
					<% Trip trip = (Trip) session.getAttribute("corsaAttiva"); %>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName">Nome</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" value="${corsaAttiva.tripShortName}" maxlength="50" />
				    		<form:errors path="tripShortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripHeadsign">Display</label>
				    		<form:input path="tripHeadsign" class="form-control" id="tripHeadsign" value="${corsaAttiva.tripHeadsign}" maxlength="50" />
				    		<form:errors path="tripHeadsign" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="directionId">Direzione</label>
							<form:select path="directionId">
								<%
								if (trip != null) {
									for (int i=0; i<direction.size(); i++) {
										if (i == trip.getDirectionId()) {
								%>
										<form:option value="<%= i %>" selected="true"><%= direction.get(i) %></form:option>
								<%
										} else { 
								%>
										<form:option value="<%= i %>"><%= direction.get(i) %></form:option>
								<%
										}
									}
								}
								%>
							</form:select>
							<form:errors path="directionId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="serviceId">Calendario</label>
							<select name="serviceId" required>
								<option value="">Seleziona un calendario</option>
								<c:forEach var="calendario" items="${listaCalendari}">
									<c:choose>
										<c:when test="${corsaAttiva.calendar.id == calendario.id}">
											<option value="${calendario.id}" selected>${calendario.name}</option>
										</c:when>
										<c:otherwise>
											<option value="${calendario.id}">${calendario.name}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="wheelchairAccessible">Accessibile ai disabili</label>
							<form:select path="wheelchairAccessible">
								<%
								if (trip != null) {
									for (int i=0; i<wheelchairAccessible.size(); i++) {
										if (i == trip.getWheelchairAccessible()) {
								%>
										<form:option value="<%= i %>" selected="true"><%= wheelchairAccessible.get(i) %></form:option>
								<%
										} else { 
								%>
										<form:option value="<%= i %>"><%= wheelchairAccessible.get(i) %></form:option>
								<%
										}
									}
								}
								%>
							</form:select>
							<form:errors path="wheelchairAccessible" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="bikesAllowed">Bici permesse</label>
							<form:select path="bikesAllowed">
								<%
								if (trip != null) {
									for (int i=0; i<bikesAllowed.size(); i++) {
										if (i == trip.getBikesAllowed()) {
								%>
										<form:option value="<%= i %>" selected="true"><%= bikesAllowed.get(i) %></form:option>
								<%
										} else { 
								%>
										<form:option value="<%= i %>"><%= bikesAllowed.get(i) %></form:option>
								<%
										}
									}
								}
								%>
							</form:select>
							<form:errors path="bikesAllowed" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica corsa" />
							<a class="btn btn-default" href="/_5t/corse">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
</body>
</html>