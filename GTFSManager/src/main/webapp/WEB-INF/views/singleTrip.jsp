<%@page import="java.sql.Time"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="it.torino._5t.entity.StopTimeRelative"%>
<%@page import="java.util.Comparator"%>
<%@page import="it.torino._5t.entity.Trip"%>
<%@page import="it.torino._5t.entity.TripPattern"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Corse singole</title>
	<link href="<c:url value='/resources/images/favicon.ico' />" rel="icon" type="image/x-icon">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
	<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	// load the navigation bar
	$(function(){
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liCorse").addClass("active");
    	});
    });
	
	$(document).ready(function() {
		// edit tripPattern form and alerts initially hidden
		$("#modificaCorsaSingola").hide();
		$(".alert").hide();
		
		// showAlertDuplicateTripPattern variable is set to true by TripPatternController if the tripPattern id is already present
		if ("${showAlertDuplicateTrip}") {
			$("#trip-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by TripPatternController if the the submitted form to create a tripPattern contains errors
		if (!"${showCreateForm}") {
			$("#creaCorsaSingola").hide();
		} else {
			$("#creaCorsaSingola").show();
		}
		
		// clicking on "Modifica schema corsa" button, "Crea schema corsa" button and div with active tripPattern summary should be hidden, while the form to modify the tripPattern should be shown
		$("#modificaCorsaSingolaButton").click(function() {
			$("#creaCorsaSingolaButton").hide();
			$("#riassuntoCorsaSingola").hide();
			$("#modificaCorsaSingola").show();
		});
		if ("${showEditForm}") {
			$("#creaCorsaSingolaButton").hide();
			$("#riassuntoCorsaSingola").hide();
			$("#modificaCorsaSingola").show();
		};
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaCorsaSingolaButton").click(function() {
			$("#delete-trip").show();
		});
		$("#delete-trip-button").click(function() {
			window.location.href = "/_5t/eliminaCorsaSingola";
		});
		
		// clicking on a row, the correspondent trip is selected
		$("#listaCorseSingole").find("tbody").find("tr").click(function() {
			var tripId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaCorsaSingola?id=" + tripId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaCorsaSingolaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaSingolaForm").find("#start").popover({ container: 'body', trigger: 'focus', title:"Ora partenza", content:"L'ora di partenza della corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaSingolaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaSingolaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo può essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaSingolaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaSingolaForm").find("#blockId").popover({ container: 'body', trigger: 'focus', title:"Id blocco", content:"Il blocco a cui appartiene la corsa. Un blocco consiste di due o più corse in sequenza fatte usando lo stesso veicolo, dove un passeggero può passare da una corsa alla successiva rimanendo sul veicolo." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaCorsaSingolaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaSingolaForm").find("#start").popover({ container: 'body', trigger: 'focus', title:"Ora partenza", content:"L'ora di partenza della corsa." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaSingolaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaSingolaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo può essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaSingolaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaSingolaForm").find("#blockId").popover({ container: 'body', trigger: 'focus', title:"Id blocco", content:"Il blocco a cui appartiene la corsa. Un blocco consiste di due o più corse in sequenza fatte usando lo stesso veicolo, dove un passeggero può passare da una corsa alla successiva rimanendo sul veicolo." })
		.blur(function () { $(this).popover('hide'); });
		
		// Creation tripPattern form validation
		$("#creaCorsaSingolaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				tripShortName: {
					required: true
				},
				serviceId: {
					required: true
				},
				start: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				tripShortName: {
					required: "Il campo nome abbreviato è obbligatorio"
				},
				serviceId: {
					required: "Selezionare un calendario"
				},
				start: {
					required: "Inserire l'ora di partenza"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit tripPattern form validation
		$("#modificaCorsaSingolaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				tripShortName: {
					required: true
				},
				serviceId: {
					required: true
				},
				start: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				tripShortName: {
					required: "Il campo nome abbreviato è obbligatorio"
				},
				serviceId: {
					required: "Selezionare un calendario"
				},
				start: {
					required: "Inserire l'ora di partenza"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the fifth column ("Ora partenza")
	    	"order": [[4, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna corsa singola"
	    	}
	    });
		$('#stopTimeTable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	"bSort": false,
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuno fermata associata"
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
		<li><a href="/_5t/linee">Linea: <b>${lineaAttiva.shortName}</b></a></li>
		<li><a href="/_5t/schemiCorse">Schema corsa: <b>${schemaCorsaAttivo.gtfsId}</b></a></li>
		<li class="active">Corse singole</li>
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
		<!-- Div with table containing tripPattern list -->
		<div class="col-lg-8">
			<table id="listaCorseSingole" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Nome abbreviato</th>
						<th>Direzione</th>
						<th>Calendario</th>
						<th>Ora partenza</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="corsaSingola" items="${listaCorseSingole}">
						<c:choose>
							<c:when test="${not empty corsaSingolaAttiva}">
								<c:if test="${corsaSingolaAttiva.id == corsaSingola.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${corsaSingola.gtfsId}</td>
							<td>${corsaSingola.tripShortName}</td>
							<td>
								<c:choose>
									<c:when test="${corsaSingola.directionId == 0}">Andata</c:when>
									<c:otherwise>Ritorno</c:otherwise>
								</c:choose>
							</td>
							<td><a href="/_5t/selezionaCalendario?id=${corsaSingola.calendar.id}">${corsaSingola.calendar.gtfsId}</a></td>
							<td>${corsaSingola.startTime}</td>
							<td class="hidden">${corsaSingola.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create tripPattern and selected tripPattern summary -->
		<div class="col-lg-4">
			<a id="creaCorsaSingolaButton" class="btn btn-primary" href="/_5t/creaCorsaSingola">Crea una corsa singola</a>
			
			<!-- Div with create tripPattern form -->
			<div id="creaCorsaSingola">
				<form:form id="creaCorsaSingolaForm" commandName="trip" method="post" role="form">
					<% TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo"); %>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${schemaCorsaAttivo.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="start" class="required">Ora partenza</label>
				    		<input name="start" class="form-control" id="start" type="time" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName" class="required">Nome abbreviato</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" value="${schemaCorsaAttivo.tripShortName}" maxlength="50" />
				    		<form:errors path="tripShortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripHeadsign">Display</label>
				    		<form:input path="tripHeadsign" class="form-control" id="tripHeadsign" value="${schemaCorsaAttivo.tripHeadsign}" maxlength="50" />
				    		<form:errors path="tripHeadsign" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="blockId">Id blocco</label>
				    		<form:input path="blockId" class="form-control" id="blockId" placeholder="Inserire l'id del blocco" maxlength="50" />
				    		<form:errors path="blockId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="directionId">Direzione</label>
							<form:select path="directionId" class="form-control">
								<%
								if (tripPattern != null) {
									for (int i=0; i<direction.size(); i++) {
										if (i == tripPattern.getDirectionId()) {
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
							<label for="serviceId" class="required">Calendario</label>
							<select name="serviceId" class="form-control" required>
								<option value="">Seleziona un calendario</option>
								<c:forEach var="calendario" items="${listaCalendari}">
									<c:choose>
										<c:when test="${schemaCorsaAttivo.calendar.id == calendario.id}">
											<option value="${calendario.id}" selected>${calendario.gtfsId}</option>
										</c:when>
										<c:otherwise>
											<option value="${calendario.id}">${calendario.gtfsId}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="wheelchairAccessible">Accessibile ai disabili</label>
							<form:select path="wheelchairAccessible" class="form-control">
								<%
								if (tripPattern != null) {
									for (int i=0; i<wheelchairAccessible.size(); i++) {
										if (i == tripPattern.getWheelchairAccessible()) {
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
							<form:select path="bikesAllowed" class="form-control">
								<%
								if (tripPattern != null) {
									for (int i=0; i<bikesAllowed.size(); i++) {
										if (i == tripPattern.getBikesAllowed()) {
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
					<form:input path="singleTrip" type="hidden" value="true" />
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea corsa singola" />
							<a class="btn btn-default" href="/_5t/corseSingole">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected tripPattern summary -->
			<c:if test="${not empty corsaSingolaAttiva}">
				<div id="riassuntoCorsaSingola" class="riassunto">
					<% Trip trip = (Trip) session.getAttribute("corsaSingolaAttiva"); %>
					<div class="col-lg-8">
						<b>Id:</b> ${corsaSingolaAttiva.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Ora partenza:</b> ${corsaSingolaAttiva.startTime}
					</div>
					<div class="col-lg-8">
						<b>Nome:</b> ${corsaSingolaAttiva.tripShortName}
					</div>
					<div class="col-lg-8">
						<b>Display:</b> ${corsaSingolaAttiva.tripHeadsign}
					</div>
					<div class="col-lg-8">
						<b>Direzione:</b>
						<% out.write(direction.get(trip.getDirectionId())); %>
					</div>
					<div class="col-lg-8">
						<b>Id blocco:</b> ${corsaSingolaAttiva.blockId}
					</div>
					<div class="col-lg-8">
						<b>Calendario:</b> ${corsaSingolaAttiva.calendar.gtfsId}
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
						<a id="modificaCorsaSingolaButton" class="btn btn-primary" href="/_5t/modificaCorsaSingola">Modifica</a>
						<button id="eliminaCorsaSingolaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
<!-- 					<div class="col-lg-12"> -->
<%-- 						<form id="duplicaCorsaSingolaForm" class="form-inline" role="form" method="post" action="/_5t/duplicaCorsaSingola"> --%>
<!-- 							<div class="form-group"> -->
<!-- 								<label for="newGtfsId" class="required">Duplica con id</label> -->
<!-- 					    		<input name="newGtfsId" class="form-control" id="newGtfsId" placeholder="Id nuova corsa" maxlength="50" /> -->
<!-- 							</div> -->
<!-- 							<input class="btn btn-info" type="submit" value="Duplica" /> -->
<%-- 						</form> --%>
<!-- 					</div> -->
				</div>
			</c:if>
			
			<!-- Div with edit tripPattern form -->
			<div id="modificaCorsaSingola">
				<form:form id="modificaCorsaSingolaForm" commandName="trip" method="post" role="form" action="/_5t/modificaCorsaSingola">
					<% Trip trip = (Trip) session.getAttribute("corsaSingolaAttiva"); %>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${corsaSingolaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="start" class="required">Ora partenza</label>
				    		<input name="start" class="form-control" id="start" type="time" value="${corsaSingolaAttiva.startTime}" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName" class="required">Nome abbreviato</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" value="${corsaSingolaAttiva.tripShortName}" maxlength="50" />
				    		<form:errors path="tripShortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripHeadsign">Display</label>
				    		<form:input path="tripHeadsign" class="form-control" id="tripHeadsign" value="${corsaSingolaAttiva.tripHeadsign}" maxlength="50" />
				    		<form:errors path="tripHeadsign" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="blockId">Id blocco</label>
				    		<form:input path="blockId" class="form-control" id="blockId" value="${corsaSingolaAttiva.blockId}" maxlength="50" />
				    		<form:errors path="blockId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="directionId">Direzione</label>
							<form:select path="directionId" class="form-control">
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
							<label for="serviceId" class="required">Calendario</label>
							<select name="serviceId" class="form-control" required>
								<option value="">Seleziona un calendario</option>
								<c:forEach var="calendario" items="${listaCalendari}">
									<c:choose>
										<c:when test="${corsaSingolaAttiva.calendar.id == calendario.id}">
											<option value="${calendario.id}" selected>${calendario.gtfsId}</option>
										</c:when>
										<c:otherwise>
											<option value="${calendario.id}">${calendario.gtfsId}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="wheelchairAccessible">Accessibile ai disabili</label>
							<form:select path="wheelchairAccessible" class="form-control">
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
							<form:select path="bikesAllowed" class="form-control">
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
					<form:input path="singleTrip" type="hidden" value="true" />
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica corsa" />
							<a class="btn btn-default" href="/_5t/corseSingole">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<div class="row col-lg-12">
				<hr>
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
					class StopTimeRelativeComparator implements Comparator<StopTimeRelative> {
	
						@Override
						public int compare(StopTimeRelative o1, StopTimeRelative o2) {
							return o1.getStopSequence().compareTo(o2.getStopSequence());
						}
						
					}
					Trip trip = (Trip) session.getAttribute("corsaSingolaAttiva");
					List<StopTimeRelative> stopTimeRelatives = new ArrayList<StopTimeRelative>((Set<StopTimeRelative>) request.getAttribute("listaFermateCorsa"));
					Collections.sort(stopTimeRelatives, new StopTimeRelativeComparator());
					SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
					Calendar cal = new GregorianCalendar();
					cal.setTime(trip.getStartTime());
					int i = 1;
					for (StopTimeRelative str: stopTimeRelatives) {
					%>
					<tr>
						<td><%= i++ %></td>
						<td><% out.write(str.getStop().getName()); %></td>
		            	<%
		            	Calendar toAdd = new GregorianCalendar();
		            	toAdd.setTime(str.getRelativeArrivalTime());
		            	cal.add(java.util.Calendar.HOUR_OF_DAY, toAdd.get(java.util.Calendar.HOUR_OF_DAY));
						cal.add(java.util.Calendar.MINUTE, toAdd.get(java.util.Calendar.MINUTE));
		            	cal.add(java.util.Calendar.SECOND, toAdd.get(java.util.Calendar.SECOND));
		            	%>
		              	<td><% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), cal.get(java.util.Calendar.SECOND)))); %></td>
		            	<%
		            	toAdd.setTime(str.getRelativeDepartureTime());
		            	cal.add(java.util.Calendar.HOUR_OF_DAY, toAdd.get(java.util.Calendar.HOUR_OF_DAY));
						cal.add(java.util.Calendar.MINUTE, toAdd.get(java.util.Calendar.MINUTE));
						cal.add(java.util.Calendar.SECOND, toAdd.get(java.util.Calendar.SECOND));
		            	%>
		              	<td><% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), cal.get(java.util.Calendar.SECOND)))); %></td>
					</tr>
					<% } %>
				</tbody>
		    </table>
		</div>
	</div>
	
	<!-- Alerts -->
	<div id="trip-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id della corsa che hai inserito è già presente.
	</div>
	<div id="delete-trip" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare la corsa ${corsaSingolaAttiva.gtfsId}?</p>
	    <button id="delete-trip-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
</body>
</html>