<%@page import="java.sql.Time"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Set"%>
<%@page import="it.torino._5t.entity.StopTimeRelative"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="it.torino._5t.entity.Trip"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="it.torino._5t.entity.TripPattern" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Schemi corse</title>
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
		// edit tripPattern form and alerts initially hidden
		$("#modificaSchemaCorsa").hide();
		$(".alert").hide();
		
		// showAlertDuplicateTripPattern variable is set to true by TripPatternController if the tripPattern id is already present
		if ("${showAlertDuplicateTripPattern}") {
			$("#tripPattern-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by TripPatternController if the the submitted form to create a tripPattern contains errors
		if (!"${showCreateForm}") {
			$("#creaSchemaCorsa").hide();
		} else {
			$("#creaSchemaCorsa").show();
		}
		
		// clicking on "Modifica schema corsa" button, "Crea schema corsa" button and div with active tripPattern summary should be hidden, while the form to modify the tripPattern should be shown
		$("#modificaSchemaCorsaButton").click(function() {
			$("#creaSchemaCorsaButton").hide();
			$("#riassuntoSchemaCorsa").hide();
			$("#modificaSchemaCorsa").show();
		});
		if ("${showEditForm}") {
			$("#creaSchemaCorsaButton").hide();
			$("#riassuntoSchemaCorsa").hide();
			$("#modificaSchemaCorsa").show();
		};
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaSchemaCorsaButton").click(function() {
			$("#delete-tripPattern").show();
		});
		$("#delete-tripPattern-button").click(function() {
			window.location.href = "/_5t/eliminaSchemaCorsa";
		});
		
		// clicking on a row, the correspondent tripPattern is selected
		$("#listaSchemiCorse").find("tbody").find("tr").click(function() {
			var tripPatternId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaSchemaCorsa?id=" + tripPatternId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaSchemaCorsaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaSchemaCorsaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaSchemaCorsaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo pu� essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaSchemaCorsaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaSchemaCorsaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una corsa." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaSchemaCorsaForm").find("#tripShortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome che compare sugli orari e sulle insegne per identificare la corsa ai passeggeri." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaSchemaCorsaForm").find("#tripHeadsign").popover({ container: 'body', trigger: 'focus', title:"Display", content:"Il testo che compare sul display per identificare la destinazione della corsa ai passeggeri. Usare questo campo per distinguere tra schemi di servizio diversi sulla stessa linea. Se il display cambia durante la corsa, questo campo pu� essere sovrascritto specificando dei valori per i display nelle fermate." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaSchemaCorsaForm").find("#directionId").popover({ container: 'body', trigger: 'focus', title:"Direzione", content:"La direzione di viaggio della corsa. Usare questo campo per distinguere tra corse con due direzioni sulla stessa linea." })
			.blur(function () { $(this).popover('hide'); });
		
		// Creation tripPattern form validation
		$("#creaSchemaCorsaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				tripShortName: {
					required: true
				},
				serviceId: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id � obbligatorio"
				},
				tripShortName: {
					required: "Il campo nome abbreviato � obbligatorio"
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
		
		// Edit tripPattern form validation
		$("#modificaSchemaCorsaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				tripShortName: {
					required: true
				},
				serviceId: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id � obbligatorio"
				},
				tripShortName: {
					required: "Il campo nome abbreviato � obbligatorio"
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
		
		// Duplicate tripPattern form validation
		$("#duplicaSchemaCorsaForm").validate({
			rules: {
				newGtfsId: {
					required: true
				}
			},
			messages: {
				newGtfsId: {
					required: "Il campo id � obbligatorio"
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
	    		"zeroRecords": "Nessuno schema corsa"
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
		<li><a href="/_5t/linee">Linea <b>${lineaAttiva.shortName}</b></a></li>
		<li class="active">Schemi corse</li>
	</ol>
	
	<% 
	HashMap<Integer, String> direction = new HashMap<Integer, String>(); 
	direction.put(0, "Andata");
	direction.put(1, "Ritorno");
	
	HashMap<Integer, String> wheelchairAccessible = new HashMap<Integer, String>(); 
	wheelchairAccessible.put(0, "Informazione non disponibile");
	wheelchairAccessible.put(1, "S�");
	wheelchairAccessible.put(2, "No");
	
	HashMap<Integer, String> bikesAllowed = new HashMap<Integer, String>(); 
	bikesAllowed.put(0, "Informazione non disponibile");
	bikesAllowed.put(1, "S�");
	bikesAllowed.put(2, "No");
	%>
	
	<p>Cliccare su una riga della tabella per selezionare lo schema corsa corrispondente</p>
	
	<div class="row">
		<!-- Div with table containing tripPattern list -->
		<div class="col-lg-8">
			<table id="listaSchemiCorse" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Nome abbreviato</th>
						<th>Direzione</th>
						<th>Calendario</th>
						<th>Fermate</th>
						<th>Corse singole</th>
						<th>Corse a frequenza</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="schemaCorsa" items="${listaSchemiCorse}">
						<%
						TripPattern tripPattern = (TripPattern) pageContext.getAttribute("schemaCorsa");
						List<Trip> singleTrips = new ArrayList<Trip>();
						List<Trip> frequencyTrips = new ArrayList<Trip>();
						for (Trip t: tripPattern.getTrips()) {
							if (t.isSingleTrip())
								singleTrips.add(t);
							else
								frequencyTrips.add(t);
						}
						%>
						<c:choose>
							<c:when test="${not empty schemaCorsaAttivo}">
								<c:if test="${schemaCorsaAttivo.id == schemaCorsa.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${schemaCorsa.gtfsId}</td>
							<td>${schemaCorsa.tripShortName}</td>
							<td>
								<c:choose>
									<c:when test="${schemaCorsa.directionId == 0}">Andata</c:when>
									<c:otherwise>Ritorno</c:otherwise>
								</c:choose>
							</td>
							<td><a href="/_5t/selezionaCalendario?id=${schemaCorsa.calendar.id}">${schemaCorsa.calendar.gtfsId}</a></td>
							<td>
								${fn:length(schemaCorsa.stopTimeRelatives)}
								<c:choose>
									<c:when test="${schemaCorsaAttivo.id == schemaCorsa.id}">
										<a class="btn btn-default" href="/_5t/fermateSchemaCorsa">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="/_5t/fermateSchemaCorsa">
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${fn:length(schemaCorsa.stopTimeRelatives) == 0}">Inserisci</c:when>
									<c:when test="${fn:length(schemaCorsa.stopTimeRelatives) > 0}">Visualizza/modifica</c:when>
								</c:choose>
								</a>
							</td>
							<td>
								<% out.print(singleTrips.size()); %>
								<c:choose>
								<c:when test="${fn:length(schemaCorsa.stopTimeRelatives) > 0}">
									<c:choose>
										<c:when test="${schemaCorsaAttivo.id == schemaCorsa.id}">
											<a class="btn btn-default" href="/_5t/corseSingole">
										</c:when>
										<c:otherwise>
											<a class="btn btn-default disabled" href="/_5t/corseSingole">
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<a class="btn btn-default disabled" href="/_5t/corseSingole">
								</c:otherwise>
								</c:choose>
								Inserisci/modifica</a>
							</td>
							<td>
								<% out.print(frequencyTrips.size()); %>
								<c:choose>
								<c:when test="${fn:length(schemaCorsa.stopTimeRelatives) > 0}">
									<c:choose>
										<c:when test="${schemaCorsaAttivo.id == schemaCorsa.id}">
											<a class="btn btn-default" href="/_5t/corseAFrequenza">
										</c:when>
										<c:otherwise>
											<a class="btn btn-default disabled" href="/_5t/corseAFrequenza">
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<a class="btn btn-default disabled" href="/_5t/corseAFrequenza">
								</c:otherwise>
								</c:choose>
								Inserisci/modifica</a>
							</td>
							<td class="hidden">${schemaCorsa.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create tripPattern and selected tripPattern summary -->
		<div class="col-lg-4">
			<a id="creaSchemaCorsaButton" class="btn btn-primary" href="/_5t/creaSchemaCorsa">Crea uno schema corsa</a>
			
			<!-- Div with create tripPattern form -->
			<div id="creaSchemaCorsa">
				<form:form id="creaSchemaCorsaForm" commandName="tripPattern" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l'id" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="tripShortName" class="required">Nome abbreviato</label>
				    		<form:input path="tripShortName" class="form-control" id="tripShortName" placeholder="Inserisci il nome abbreviato" maxlength="50" />
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
							<input class="btn btn-success" type="submit" value="Crea schema corsa" />
							<a class="btn btn-default" href="/_5t/schemiCorse">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected tripPattern summary -->
			<c:if test="${not empty schemaCorsaAttivo}">
				<div id="riassuntoSchemaCorsa" class="riassunto">
					<% TripPattern tripPattern = (TripPattern) session.getAttribute("schemaCorsaAttivo"); %>
					<div class="col-lg-8">
						<b>Id:</b> ${schemaCorsaAttivo.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Nome:</b> ${schemaCorsaAttivo.tripShortName}
					</div>
					<div class="col-lg-8">
						<b>Display:</b> ${schemaCorsaAttivo.tripHeadsign}
					</div>
					<div class="col-lg-8">
						<b>Direzione:</b>
						<% out.write(direction.get(tripPattern.getDirectionId())); %>
					</div>
					<div class="col-lg-8">
						<b>Calendario:</b> ${schemaCorsaAttivo.calendar.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Accessibile ai disabili:</b>
						<% out.write(wheelchairAccessible.get(tripPattern.getWheelchairAccessible())); %>
					</div>
					<div class="col-lg-8">
						<b>Bici permesse:</b>
						<% out.write(bikesAllowed.get(tripPattern.getBikesAllowed())); %>
					</div>
					<div class="col-lg-12">
						<a id="modificaSchemaCorsaButton" class="btn btn-primary" href="/_5t/modificaSchemaCorsa">Modifica</a>
						<button id="eliminaSchemaCorsaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
					<div class="col-lg-12">
						<form id="duplicaSchemaCorsaForm" class="form-inline" role="form" method="post" action="/_5t/duplicaSchemaCorsa">
							<div class="form-group">
								<label for="newGtfsId" class="required">Duplica con id</label>
					    		<input name="newGtfsId" class="form-control" id="newGtfsId" placeholder="Id nuovo schema corsa" maxlength="50" />
							</div>
							<input class="btn btn-info" type="submit" value="Duplica" />
						</form>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit tripPattern form -->
			<div id="modificaSchemaCorsa">
				<form:form id="modificaSchemaCorsaForm" commandName="tripPattern" method="post" role="form" action="/_5t/modificaSchemaCorsa">
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
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica corsa" />
							<a class="btn btn-default" href="/_5t/schemiCorse">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<c:if test="${not empty schemaCorsaAttivo && not empty schemaCorsaAttivo.stopTimeRelatives}">
				<div class="row col-lg-12">
					<table class="stopSequence">
						<thead>
							<tr>
								<th>N�</th>
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
						if (((TripPattern) session.getAttribute("schemaCorsaAttivo")) != null) {
							List<StopTimeRelative> stopTimeRelatives = new ArrayList<StopTimeRelative>((Set<StopTimeRelative>) request.getAttribute("listaFermateCorsa"));
							Collections.sort(stopTimeRelatives, new StopTimeRelativeComparator());
							SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
							Calendar cal = new GregorianCalendar();
							cal.setTime(new Time(0, 0, 0));
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
				            	%>
				              	<td><% out.write(dateFormat.format(new Time(cal.get(java.util.Calendar.HOUR_OF_DAY), cal.get(java.util.Calendar.MINUTE), 0))); %></td>
				            	<%
				            	toAdd.setTime(str.getRelativeDepartureTime());
				            	cal.add(java.util.Calendar.HOUR_OF_DAY, toAdd.get(java.util.Calendar.HOUR_OF_DAY));
								cal.add(java.util.Calendar.MINUTE, toAdd.get(java.util.Calendar.MINUTE));
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
	<div id="tripPattern-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id dello schema corsa che hai inserito � gi� presente.
	</div>
	<div id="delete-tripPattern" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare lo schema corsa ${schemaCorsaAttivo.gtfsId}?</p>
	    <button id="delete-tripPattern-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
</body>
</html>