<%@page import="java.sql.Time"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="it.torino._5t.entity.StopTime"%>
<%@page import="java.util.Comparator"%>
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
		// edit trip form and alerts initially hidden
		$("#modificaCorsa").hide();
		$(".alert").hide();
		
		// showAlertDuplicateTrip variable is set to true by TripController if the trip id is already present
		if ("${showAlertDuplicateTrip}") {
			$("#trip-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by TripController if the the submitted form to create a trip contains errors
		if (!"${showCreateForm}") {
			$("#creaCorsa").hide();
		} else {
			$("#creaCorsa").show();
		}
		
		// clicking on "Modifica corsa" button, "Crea corsa" button and div with active trip summary should be hidden, while the form to modify the trip should be shown
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
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaCorsaButton").click(function() {
			$("#delete-trip").show();
		});
		$("#delete-trip-button").click(function() {
			window.location.href = "/_5t/eliminaCorsa";
		});
		
		// clicking on a row, the correspondent trip is selected
		$("#listaCorse").find("tbody").find("tr").click(function() {
			var tripId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaCorsa?id=" + tripId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaCorsaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo può essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCorsaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaCorsaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo può essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCorsaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		
		// Creation trip form validation
		$("#creaCorsaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				serviceId: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				serviceId: {
					required: "Selezionare un calendario"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit trip form validation
		$("#modificaCorsaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				serviceId: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				serviceId: {
					required: "Selezionare un calendario"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Duplicate trip form validation
		$("#duplicaCorsaForm").validate({
			rules: {
				newGtfsId: {
					required: true
				}
			},
			messages: {
				newGtfsId: {
					required: "Il campo id è obbligatorio"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// table initialization to have sortable columns
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Nome")
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
		<li><a href="/_5t/agenzie">Agenzia <b>${agenziaAttiva.gtfsId}</b></a></li>
		<li><a href="/_5t/linee">Linea <b>${lineaAttiva.gtfsId}</b></a></li>
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
		<!-- Div with table containing trip list -->
		<div class="col-lg-8">
			<table id="listaCorse" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Nome abbreviato</th>
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
							<td>${corsa.gtfsId}</td>
							<td>${corsa.tripShortName}</td>
							<td>
								<c:choose>
									<c:when test="${corsa.directionId == 0}">Andata</c:when>
									<c:otherwise>Ritorno</c:otherwise>
								</c:choose>
							</td>
							<td><a href="/_5t/selezionaCalendario?id=${corsa.calendar.id}">${corsa.calendar.gtfsId}</a></td>
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
									<c:when test="${corsaAttiva.id == corsa.id}">
										<a class="btn btn-default" href="/_5t/fermateCorse">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="/_5t/fermateCorse">
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
		
		<!-- Div with button to create trip and selected trip summary -->
		<div class="col-lg-4">
			<a id="creaCorsaButton" class="btn btn-primary" href="/_5t/creaCorsa">Crea una corsa</a>
			
			<!-- Div with create trip form -->
			<div id="creaCorsa">
				<form:form id="creaCorsaForm" commandName="trip" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l'id" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName">Nome abbreviato</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" placeholder="Inserisci il nome abbreviato" maxlength="255" />
				    		<form:errors path="tripShortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripHeadsign">Display</label>
				    		<form:input path="tripHeadsign" class="form-control" id="tripHeadsign" placeholder="Inserisci la scritta per il display" maxlength="255" />
				    		<form:errors path="tripHeadsign" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="directionId">Direzione</label>
							<form:select path="directionId" class="form-control">
								<form:option value="0" selected="true"><%= direction.get(0) %></form:option>
								<form:option value="1"><%= direction.get(1) %></form:option>
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
									<option value="${calendario.id}">${calendario.gtfsId}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="wheelchairAccessible">Accessibile ai disabili</label>
							<form:select path="wheelchairAccessible" class="form-control">
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
							<form:select path="bikesAllowed" class="form-control">
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
			
			<!-- Div with selected trip summary -->
			<c:if test="${not empty corsaAttiva}">
				<div id="riassuntoCorsa" class="riassunto">
					<% Trip trip = (Trip) session.getAttribute("corsaAttiva"); %>
					<div class="col-lg-8">
						<b>Id:</b> ${corsaAttiva.gtfsId}
					</div>
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
						<b>Calendario:</b> ${corsaAttiva.calendar.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Accessibile ai disabili:</b>
						<% 
						if (trip.getWheelchairAccessible() != null) {
							out.write(wheelchairAccessible.get(trip.getWheelchairAccessible())); 
						}
						%>
					</div>
					<div class="col-lg-8">
						<b>Bici permesse:</b>
						<% 
						if (trip.getBikesAllowed() != null) {
							out.write(bikesAllowed.get(trip.getBikesAllowed()));
						}
						%>
					</div>
					<div class="col-lg-12">
						<a id="modificaCorsaButton" class="btn btn-primary" href="/_5t/modificaCorsa">Modifica</a>
						<button id="eliminaCorsaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
					<div class="col-lg-12">
						<form id="duplicaCorsaForm" class="form-inline" role="form" method="post" action="/_5t/duplicaCorsa">
							<div class="form-group">
								<label for="newGtfsId" class="required">Duplica con id</label>
					    		<input name="newGtfsId" class="form-control" id="newGtfsId" placeholder="Id nuova corsa" maxlength="50" />
							</div>
							<input class="btn btn-info" type="submit" value="Duplica" />
						</form>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit trip form -->
			<div id="modificaCorsa">
				<form:form id="modificaCorsaForm" commandName="trip" method="post" role="form" action="/_5t/modificaCorsa">
					<% Trip trip = (Trip) session.getAttribute("corsaAttiva"); %>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${corsaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName">Nome abbreviato</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" value="${corsaAttiva.tripShortName}" maxlength="255" />
				    		<form:errors path="tripShortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripHeadsign">Display</label>
				    		<form:input path="tripHeadsign" class="form-control" id="tripHeadsign" value="${corsaAttiva.tripHeadsign}" maxlength="255" />
				    		<form:errors path="tripHeadsign" cssClass="error"></form:errors>
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
										<c:when test="${corsaAttiva.calendar.id == calendario.id}">
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
									if (trip.getWheelchairAccessible() != null) {
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
									} else {
								%>
										<form:option value="0" selected="true"><%= wheelchairAccessible.get(0) %></form:option>
										<form:option value="1"><%= wheelchairAccessible.get(1) %></form:option>
										<form:option value="2"><%= wheelchairAccessible.get(2) %></form:option>
								<%
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
									if (trip.getBikesAllowed() != null) {
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
									} else {
								%>
										<form:option value="0" selected="true"><%= bikesAllowed.get(0) %></form:option>
								<form:option value="1"><%= bikesAllowed.get(1) %></form:option>
								<form:option value="2"><%= bikesAllowed.get(2) %></form:option>
								<%	
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
			
			<c:if test="${not empty corsaAttiva && not empty corsaAttiva.stopTimes}">
				<div class="row col-lg-12">
					<table class="stopSequence">
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
						if (((Trip) session.getAttribute("corsaAttiva")) != null) {
							List<StopTime> stopTimes = new ArrayList<StopTime>((Set<StopTime>) request.getAttribute("listaFermateCorsa"));
							Collections.sort(stopTimes, new StopTimeComparator());
							SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
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
				              	<td><% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), 0))); %></td>
				            	<%
				            	if (st.getDepartureTime() != null)
				            		cal.setTime(st.getDepartureTime());
				            	%>
				              	<td><% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), 0))); %></td>
							</tr>
							<% 
								}
							}
							%>
						</tbody>
				    </table>
				</div>
			</c:if>
		</div>
	</div>
	
	<!-- Alerts -->
	<div id="trip-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id della corsa che hai inserito è già presente.
	</div>
	<div id="delete-trip" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare la corsa ${corsaAttiva.gtfsId}?</p>
	    <button id="delete-trip-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
</body>
</html>