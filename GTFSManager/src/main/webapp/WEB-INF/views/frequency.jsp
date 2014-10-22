<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Servizi</title>
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
	
	// create frequency form validation 
	function validateCreaServizioForm() {
		if (document.forms["creaServizioForm"]["sameDay"].checked) {
			// if start and end time are in the same day check if start time > end time
			var arrivalTime = document.forms["creaServizioForm"]["start"].value;
			var departureTime = document.forms["creaServizioForm"]["end"].value;
			if (arrivalTime > departureTime) {
				$("#wrong-times").show();
				return false;
			}
		}
		
		return true;
	};
	
	// edit frequency form validation 
	function validateModificaServizioForm() {
		if (document.forms["modificaServizioForm"]["sameDay"].checked) {
			// if start and end time are in the same day check if start time > end time
			var arrivalTime = document.forms["modificaServizioForm"]["start"].value;
			var departureTime = document.forms["modificaServizioForm"]["end"].value;
			if (arrivalTime > departureTime) {
				$("#wrong-times").show();
				return false;
			}
		}
		
		return true;
	};
	
	$(document).ready(function() {
		// edit frequency form and alerts initially hidden
		$("#modificaServizio").hide();
		$(".alert").hide();
		
		// showCreateForm variable is set to true by FrequencyController if the the submitted form to create a trip contains errors
		if (!"${showCreateForm}") {
			$("#creaServizio").hide();
		} else {
			$("#creaServizio").show();
		}
		
		// clicking on "Modifica servizio" button, "Crea servizio" button and div with active trip summary should be hidden, while the form to modify the trip should be shown
		$("#modificaServizioButton").click(function() {
			$("#creaServizioButton").hide();
			$("#riassuntoServizio").hide();
			$("#modificaServizio").show();
		});
		if ("${showEditForm}") {
			$("#creaServizioButton").hide();
			$("#riassuntoServizio").hide();
			$("#modificaServizio").show();
		};
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaServizioButton").click(function() {
			$("#delete-frequency").show();
		});
		$("#delete-frequency-button").click(function() {
			window.location.href = "/_5t/eliminaServizio";
		});
		
		// clicking on a row, the correspondent frequency is selected
		$("#listaServizi").find("tbody").find("tr").click(function() {
			var tripId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaServizio?id=" + tripId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaServizioForm").find("#start").popover({ container: 'body', trigger: 'focus', title:"Ora inizio", content:"L'ora in cui inizia il servizio con la frequenza specificata." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaServizioForm").find("#end").popover({ container: 'body', trigger: 'focus', title:"Ora fine", content:"L'ora in cui il servizio cambia a una frequenza diversa (o finisce) alla prima fermata nella corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaServizioForm").find("#headwaySecs").popover({ container: 'body', trigger: 'focus', title:"Frequenza", content:"Il tempo tra le partenze dalla stessa fermata per questo tipo di corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaServizioForm").find("#exactTimes").popover({ container: 'body', trigger: 'focus', title:"Tempi esatti", content:"Determina se le corse basate sulla frequenza debbano essere esattamente schedulate in base alle informazioni specificate." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaServizioForm").find("#start").popover({ container: 'body', trigger: 'focus', title:"Ora inizio", content:"L'ora in cui inizia il servizio con la frequenza specificata." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaServizioForm").find("#end").popover({ container: 'body', trigger: 'focus', title:"Ora fine", content:"L'ora in cui il servizio cambia a una frequenza diversa (o finisce) alla prima fermata nella corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaServizioForm").find("#headwaySecs").popover({ container: 'body', trigger: 'focus', title:"Frequenza", content:"Il tempo tra le partenze dalla stessa fermata per questo tipo di corsa." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaServizioForm").find("#exactTimes").popover({ container: 'body', trigger: 'focus', title:"Tempi esatti", content:"Determina se le corse basate sulla frequenza debbano essere esattamente schedulate in base alle informazioni specificate." })
			.blur(function () { $(this).popover('hide'); });
		
		// Creation frequency form validation
		$("#creaServizioForm").validate({
			rules: {
				start: {
					required: true
				},
				end: {
					required: true
				},
				headwaySecs: {
					required: true,
					min: 1
				}
			},
			messages: {
				start: {
					required: "Il campo ora di inizio è obbligatorio"
				},
				end: {
					required: "Il campo ora di fine è obbligatorio"
				},
				headwaySecs: {
					required: "Il campo frequenza è obbligatorio",
					min: "Inserire una frequenza maggiore o uguale a 1 minuto"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit frequency form validation
		$("#modificaServizioForm").validate({
			rules: {
				start: {
					required: true
				},
				end: {
					required: true
				},
				headwaySecs: {
					required: true,
					min: 1
				}
			},
			messages: {
				start: {
					required: "Il campo ora di inizio è obbligatorio"
				},
				end: {
					required: "Il campo ora di fine è obbligatorio"
				},
				headwaySecs: {
					required: "Il campo frequenza è obbligatorio",
					min: "Inserire una frequenza maggiore o uguale a 1 minuto"
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
	    	// default sorting on the first column ("Ora inizio")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessun servizio"
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
		<li class="active">Servizi</li>
	</ol>
	
	<div class="row">
		<!-- Div with table containing frequency list -->
		<div class="col-lg-6">
			<table id="listaServizi" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Ora inizio</th>
						<th>Ora fine</th>
						<th>Frequenza (min)</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="servizio" items="${listaServizi}">
						<c:choose>
							<c:when test="${not empty servizioAttivo}">
								<c:if test="${servizioAttivo.id == servizio.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${servizio.startTime}</td>
							<td>${servizio.endTime}</td>
							<td>${servizio.headwaySecs}</td>
							<td class="hidden">${servizio.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create frequency and selected frequency summary -->
		<div class="col-lg-6">
			<a id="creaServizioButton" class="btn btn-primary" href="/_5t/creaServizio">Crea un servizio</a>
			
			<!-- Div with create frequency form -->
			<div id="creaServizio">
				<form:form name="creaServizioForm" id="creaServizioForm" commandName="frequency" method="post" role="form" onsubmit="return validateCreaServizioForm()">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="start" class="required">Ora inizio</label>
				    		<input name="start" class="form-control" id="start" type="time" required="required" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="end" class="required">Ora fine</label>
				    		<input name="end" class="form-control" id="end" type="time" required="required" />
						</div>
					</div>
					<div class="checkbox">
						<label>
			    			<input type="checkbox" name="sameDay" id="sameDay" checked>Ora inizio e fine nello stesso giorno
						</label>
						<p class="help-block">Deselezionare solo se l'ora di fine è nel giorno successivo all'ora di inizio.</p>
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
							<input class="btn btn-success" type="submit" value="Crea servizio" />
							<a class="btn btn-default" href="/_5t/servizi">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected frequency summary -->
			<c:if test="${not empty servizioAttivo}">
				<div id="riassuntoServizio" class="riassunto">
					<div class="col-lg-8">
						<b>Ora inizio:</b> ${servizioAttivo.startTime}
					</div>
					<div class="col-lg-8">
						<b>Ora fine:</b> ${servizioAttivo.endTime}
					</div>
					<div class="col-lg-8">
						<b>Frequenza (min):</b> ${servizioAttivo.headwaySecs}
					</div>
					<div class="col-lg-8">
						<b>Corsa programmata esattamente:</b> 
						<c:choose>
							<c:when test="${servizioAttivo.exactTimes == 0}">No</c:when>
							<c:otherwise>Sì</c:otherwise>
						</c:choose>
					</div>
					<div class="col-lg-12">
						<a id="modificaServizioButton" class="btn btn-primary" href="/_5t/modificaServizio">Modifica</a>
						<button id="eliminaServizioButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit frequency form -->
			<div id="modificaServizio">
				<form:form name="modificaServizioForm" id="modificaServizioForm" commandName="frequency" method="post" role="form" action="/_5t/modificaServizio" onsubmit="return validateModificaServizioForm()">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="start" class="required">Ora inizio</label>
				    		<input name="start" class="form-control" id="start" type="time" required="required" value="${servizioAttivo.startTime}" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="end" class="required">Ora fine</label>
				    		<input name="end" class="form-control" id="end" type="time" required="required" value="${servizioAttivo.endTime}" />
						</div>
					</div>
					<div class="checkbox">
						<label>
			    			<input type="checkbox" name="sameDay" id="sameDay" checked>Ora inizio e fine nello stesso giorno
						</label>
						<p class="help-block">Deselezionare solo se l'ora di fine è nel giorno successivo all'ora di inizio.</p>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="headwaySecs" class="required">Frequenza</label>
				    		<form:input path="headwaySecs" class="form-control" id="headwaySecs" type="number" min="1" required="required" value="${servizioAttivo.headwaySecs}" />
				    		<form:errors path="headwaySecs" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="exactTimes">Corsa programmata esattamente</label>
				    		<form:select path="exactTimes" class="form-control">
				    			<c:choose>
				    				<c:when test="${servizioAttivo.exactTimes == 0}">
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
							<input class="btn btn-success" type="submit" value="Modifica servizio" />
							<a class="btn btn-default" href="/_5t/servizi">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	
	<!-- Alerts -->
	<div id="delete-frequency" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare il servizio dalle ${servizioAttivo.startTime} alle ${servizioAttivo.endTime}?</p>
	    <button id="delete-frequency-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
	<div id="wrong-times" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>L'ora di inizio non può essere successiva all'ora di fine se sono nello stesso giorno.</p>
	</div>
</body>
</html>