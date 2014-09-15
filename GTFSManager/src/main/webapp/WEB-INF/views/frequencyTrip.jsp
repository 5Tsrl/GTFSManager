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
	<title>GTFS Manager - Corse a frequenza</title>
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link href="<c:url value='/resources/css/timeline.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
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
    		$("#liAgenzie").addClass("active");
    	}); 
    });
	
	$(document).ready(function() {
		// edit tripPattern form and alerts initially hidden
		$("#modificaCorsaAFrequenza").hide();
		$(".alert").hide();
		
		// showAlertDuplicateTripPattern variable is set to true by TripPatternController if the tripPattern id is already present
		if ("${showAlertDuplicateTrip}") {
			$("#trip-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by TripPatternController if the the submitted form to create a tripPattern contains errors
		if (!"${showCreateForm}") {
			$("#creaCorsaAFrequenza").hide();
		} else {
			$("#creaCorsaAFrequenza").show();
		}
		
		// clicking on "Modifica schema corsa" button, "Crea schema corsa" button and div with active tripPattern summary should be hidden, while the form to modify the tripPattern should be shown
		$("#modificaCorsaAFrequenzaButton").click(function() {
			$("#creaCorsaAFrequenzaButton").hide();
			$("#riassuntoCorsaAFrequenza").hide();
			$("#modificaCorsaAFrequenza").show();
		});
		if ("${showEditForm}") {
			$("#creaCorsaAFrequenzaButton").hide();
			$("#riassuntoCorsaAFrequenza").hide();
			$("#modificaCorsaAFrequenza").show();
		};
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaCorsaAFrequenzaButton").click(function() {
			$("#delete-trip").show();
		});
		$("#delete-trip-button").click(function() {
			window.location.href = "/_5t/eliminaCorsaAFrequenza";
		});
		
		// clicking on a row, the correspondent trip is selected
		$("#listaCorseAFrequenza").find("tbody").find("tr").click(function() {
			var tripId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaCorsaAFrequenza?id=" + tripId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaCorsaAFrequenzaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#start").popover({ container: 'body', trigger: 'focus', title:"Ora inizio", content:"L'ora di inizio del servizio con la frequenza specificata." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#end").popover({ container: 'body', trigger: 'focus', title:"Ora fine", content:"L'ora di fine del servizio con la frequenza specificata." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#headwaySecs").popover({ container: 'body', trigger: 'focus', title:"Frequenza", content:"Il tempo tra le partenze dalla stessa fermata (capolinea) per questa corsa a frequenza." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#exactTimes").popover({ container: 'body', trigger: 'focus', title:"Tempi esatti", content:"Determina se le corse a frequenza dovrebbero essere esattamente schedulate in base alle informazioni del capolinea specificato." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo può essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaAFrequenzaForm").find("#blockId").popover({ container: 'body', trigger: 'focus', title:"Id blocco", content:"Il blocco a cui appartiene la corsa. Un blocco consiste di due o più corse in sequenza fatte usando lo stesso veicolo, dove un passeggero può passare da una corsa alla successiva rimanendo sul veicolo." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaCorsaAFrequenzaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#start").popover({ container: 'body', trigger: 'focus', title:"Ora inizio", content:"L'ora di inizio del servizio con la frequenza specificata." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#end").popover({ container: 'body', trigger: 'focus', title:"Ora fine", content:"L'ora di fine del servizio con la frequenza specificata." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#headwaySecs").popover({ container: 'body', trigger: 'focus', title:"Frequenza", content:"Il tempo tra le partenze dalla stessa fermata (capolinea) per questa corsa a frequenza." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#exactTimes").popover({ container: 'body', trigger: 'focus', title:"Tempi esatti", content:"Determina se le corse a frequenza dovrebbero essere esattamente schedulate in base alle informazioni del capolinea specificato." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo può essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaAFrequenzaForm").find("#blockId").popover({ container: 'body', trigger: 'focus', title:"Id blocco", content:"Il blocco a cui appartiene la corsa. Un blocco consiste di due o più corse in sequenza fatte usando lo stesso veicolo, dove un passeggero può passare da una corsa alla successiva rimanendo sul veicolo." })
		.blur(function () { $(this).popover('hide'); });
		
		// Creation tripPattern form validation
		$("#creaCorsaAFrequenzaForm").validate({
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
				},
				end: {
					required: true
				},
				headwaySecs: {
					required: true,
					number: true,
					min: 1
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
					required: "Inserire l'ora di inizio"
				},
				end: {
					required: "Inserire l'ora di fine"
				},
				headwaySecs: {
					required: "Il campo frequenza è obbligatorio",
					number: "Il campo frequenza deve essere un numero",
					min: "Inserire una frequenza di almeno un minuto"
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
		$("#modificaCorsaAFrequenzaForm").validate({
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
				},
				end: {
					required: true
				},
				headwaySecs: {
					required: true,
					number: true,
					min: 1
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
					required: "Inserire l'ora di inizio"
				},
				end: {
					required: "Inserire l'ora di fine"
				},
				headwaySecs: {
					required: "Il campo frequenza è obbligatorio",
					number: "Il campo frequenza deve essere un numero",
					min: "Inserire una frequenza di almeno un minuto"
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
	    	// default sorting on the first column ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna corsa singola"
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
		<li><a href="/_5t/schemiCorse">Schema corsa ${schemaCorsaAttivo.gtfsId}</a></li>
		<li class="active">Corse a frequenza</li>
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
			<table id="listaCorseAFrequenza" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Nome abbreviato</th>
						<th>Direzione</th>
						<th>Calendario</th>
						<th>Ora inizio</th>
						<th>Ora fine</th>
						<th>Frequenza (min)</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="corsaAFrequenza" items="${listaCorseAFrequenza}">
						<c:choose>
							<c:when test="${not empty corsaAFrequenzaAttiva}">
								<c:if test="${corsaAFrequenzaAttiva.id == corsaAFrequenza.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${corsaAFrequenza.gtfsId}</td>
							<td>${corsaAFrequenza.tripShortName}</td>
							<td>
								<c:choose>
									<c:when test="${corsaAFrequenza.directionId == 0}">Andata</c:when>
									<c:otherwise>Ritorno</c:otherwise>
								</c:choose>
							</td>
							<td><a href="/_5t/selezionaCalendario?id=${corsaAFrequenza.calendar.id}">${corsaAFrequenza.calendar.gtfsId}</a></td>
							<td>${corsaAFrequenza.startTime}</td>
							<td>${corsaAFrequenza.endTime}</td>
							<td>${corsaAFrequenza.headwaySecs}</td>
							<td class="hidden">${corsaAFrequenza.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create tripPattern and selected tripPattern summary -->
		<div class="col-lg-4">
			<a id="creaCorsaAFrequenzaButton" class="btn btn-primary" href="/_5t/creaCorsaAFrequenza">Crea una corsa a frequenza</a>
			
			<!-- Div with create tripPattern form -->
			<div id="creaCorsaAFrequenza">
				<form:form id="creaCorsaAFrequenzaForm" commandName="trip" method="post" role="form">
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
							<label for="start" class="required">Ora inizio</label>
				    		<input name="start" class="form-control" id="start" type="time" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="end" class="required">Ora fine</label>
				    		<input name="end" class="form-control" id="end" type="time" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="headwaySecs" class="required">Frequenza (min)</label>
				    		<form:input path="headwaySecs" class="form-control" id="headwaySecs" type="number" min="1" required="required" />
				    		<form:errors path="headwaySecs" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="exactTimes">Corsa programmata esattamente</label>
				    		<form:select path="exactTimes" class="form-control">
								<form:option value="0" selected="true">No</form:option>
								<form:option value="1">Sì</form:option>
							</form:select>
							<form:errors path="exactTimes" cssClass="error"></form:errors>
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
					<form:input path="singleTrip" type="hidden" value="false" />
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea corsa a frequenza" />
							<a class="btn btn-default" href="/_5t/corseAFrequenza">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected tripPattern summary -->
			<c:if test="${not empty corsaAFrequenzaAttiva}">
				<div id="riassuntoCorsaAFrequenza" class="riassunto">
					<% Trip trip = (Trip) session.getAttribute("corsaAFrequenzaAttiva"); %>
					<div class="col-lg-12">
						<b>Id:</b> ${corsaAFrequenzaAttiva.gtfsId}
					</div>
					<div class="col-lg-12">
						<b>Ora inizio:</b> ${corsaAFrequenzaAttiva.startTime}
					</div>
					<div class="col-lg-12">
						<b>Ora fine:</b> ${corsaAFrequenzaAttiva.endTime}
					</div>
					<div class="col-lg-12">
						<b>Frequenza (min):</b> ${corsaAFrequenzaAttiva.headwaySecs}
					</div>
					<div class="col-lg-12">
						<b>Corsa programmata esattamente:</b> 
						<c:choose>
							<c:when test="${corsaAFrequenzaAttiva.exactTimes == 0}">No</c:when>
							<c:otherwise>Sì</c:otherwise>
						</c:choose>
					</div>
					<div class="col-lg-12">
						<b>Nome:</b> ${corsaAFrequenzaAttiva.tripShortName}
					</div>
					<div class="col-lg-12">
						<b>Display:</b> ${corsaAFrequenzaAttiva.tripHeadsign}
					</div>
					<div class="col-lg-12">
						<b>Direzione:</b>
						<% out.write(direction.get(trip.getDirectionId())); %>
					</div>
					<div class="col-lg-12">
						<b>Id blocco:</b> ${corsaAFrequenzaAttiva.blockId}
					</div>
					<div class="col-lg-12">
						<b>Calendario:</b> ${corsaAFrequenzaAttiva.calendar.gtfsId}
					</div>
					<div class="col-lg-12">
						<b>Accessibile ai disabili:</b>
						<% out.write(wheelchairAccessible.get(trip.getWheelchairAccessible())); %>
					</div>
					<div class="col-lg-12">
						<b>Bici permesse:</b>
						<% out.write(bikesAllowed.get(trip.getBikesAllowed())); %>
					</div>
					<div class="col-lg-12">
						<%
						SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
						Calendar start = new GregorianCalendar();
						start.setTime(trip.getStartTime());
						Calendar end = new GregorianCalendar();
						end.setTime(trip.getEndTime());
						%>
						<b>Ore partenza corse:</b>
							<%
							if (start.after(end)) {
								Calendar endDay = new GregorianCalendar();
								endDay.setTime(new Time(23, 59, 59));
								while (start.compareTo(endDay) <= 0) {
									out.write(dateFormat.format(new Time(start.get(java.util.Calendar.HOUR_OF_DAY), start.get(java.util.Calendar.MINUTE), 0)) + "  ");
									start.add(java.util.Calendar.HOUR_OF_DAY, trip.getHeadwaySecs() / 60);
									start.add(java.util.Calendar.MINUTE, trip.getHeadwaySecs() % 60);
								}
								Calendar startDay = new GregorianCalendar();
								startDay.setTime(new Time(start.get(java.util.Calendar.HOUR_OF_DAY), start.get(java.util.Calendar.MINUTE), 0));
								while (startDay.compareTo(end) <= 0) {
									out.write(dateFormat.format(new Time(startDay.get(java.util.Calendar.HOUR_OF_DAY), startDay.get(java.util.Calendar.MINUTE), 0)) + "  ");
									startDay.add(java.util.Calendar.HOUR_OF_DAY, trip.getHeadwaySecs() / 60);
									startDay.add(java.util.Calendar.MINUTE, trip.getHeadwaySecs() % 60);
								}
							} else {
								while (start.before(end)) {
									out.write(dateFormat.format(new Time(start.get(java.util.Calendar.HOUR_OF_DAY), start.get(java.util.Calendar.MINUTE), 0)) + "  ");
									start.add(java.util.Calendar.HOUR_OF_DAY, trip.getHeadwaySecs() / 60);
									start.add(java.util.Calendar.MINUTE, trip.getHeadwaySecs() % 60);
								}
							}
							%>
					</div>
					<div class="col-lg-12">
						<a id="modificaCorsaAFrequenzaButton" class="btn btn-primary" href="/_5t/modificaCorsaAFrequenza">Modifica</a>
						<button id="eliminaCorsaAFrequenzaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
<!-- 					<div class="col-lg-12"> -->
<%-- 						<form id="duplicaCorsaAFrequenzaForm" class="form-inline" role="form" method="post" action="/_5t/duplicaCorsaAFrequenza"> --%>
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
			<div id="modificaCorsaAFrequenza">
				<form:form id="modificaCorsaAFrequenzaForm" commandName="trip" method="post" role="form" action="/_5t/modificaCorsaAFrequenza">
					<% Trip trip = (Trip) session.getAttribute("corsaAFrequenzaAttiva"); %>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${corsaAFrequenzaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="start" class="required">Ora inizio</label>
				    		<input name="start" class="form-control" id="start" type="time" required="required" value="${corsaAFrequenzaAttiva.startTime}" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="end" class="required">Ora fine</label>
				    		<input name="end" class="form-control" id="end" type="time" required="required" value="${corsaAFrequenzaAttiva.endTime}" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="headwaySecs" class="required">Frequenza</label>
				    		<form:input path="headwaySecs" class="form-control" id="headwaySecs" type="number" min="1" required="required" value="${corsaAFrequenzaAttiva.headwaySecs}" />
				    		<form:errors path="headwaySecs" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="exactTimes">Corsa programmata esattamente</label>
				    		<form:select path="exactTimes" class="form-control">
				    			<c:choose>
				    				<c:when test="${corsaAFrequenzaAttiva.exactTimes == 0}">
										<form:option value="0" selected="true">No</form:option>
										<form:option value="1">Sì</form:option>
				    				</c:when>
				    				<c:otherwise>
										<form:option value="0">No</form:option>
										<form:option value="1" selected="true">Sì</form:option>
				    				</c:otherwise>
				    			</c:choose>
							</form:select>
							<form:errors path="exactTimes" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName" class="required">Nome abbreviato</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" value="${corsaAFrequenzaAttiva.tripShortName}" maxlength="50" />
				    		<form:errors path="tripShortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripHeadsign">Display</label>
				    		<form:input path="tripHeadsign" class="form-control" id="tripHeadsign" value="${corsaAFrequenzaAttiva.tripHeadsign}" maxlength="50" />
				    		<form:errors path="tripHeadsign" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="blockId">Id blocco</label>
				    		<form:input path="blockId" class="form-control" id="blockId" value="${corsaAFrequenzaAttiva.blockId}" maxlength="50" />
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
										<c:when test="${corsaAFrequenzaAttiva.calendar.id == calendario.id}">
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
					<form:input path="singleTrip" type="hidden" value="false" />
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica corsa" />
							<a class="btn btn-default" href="/_5t/corseAFrequenza">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
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
	</div>
	
	<!-- Alerts -->
	<div id="trip-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id della corsa che hai inserito è già presente.
	</div>
	<div id="delete-trip" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare la corsa ${corsaAFrequenzaAttiva.gtfsId}?</p>
	    <button id="delete-trip-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
</body>
</html>