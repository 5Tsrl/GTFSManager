<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Servizi</title>
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
		// form per modificare un servizio inizialmente nascosto
		$("#modificaServizio").hide();
		
		// la variabile showForm è settata a true da FrequencyController se il form sottomesso per la creazione di un servizio contiene degli errori
		if (!"${showCreateForm}") {
			$("#creaServizio").hide();
		} else {
			$("#creaServizio").show();
		}
		
		// la variabile showAlertWrongTimes è settata a true se l'ora di inizio inserita nel servizio è successiva all'ora di fine 
		if ("${showAlertWrongTimes}") {
			alert("L'ora di inizio non può essere successiva all'ora di fine");
		}
		
		// cliccando sul pulsante "Modifica servizio", il pulsante "Crea servizio" e il div con il riassunto del servizio attivo devono essere nascosti, mentre il form per modificare il servizio deve essere visualizzato
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
		
		// cliccando sul pulsante "Elimina", viene mostrata una finestra di dialogo che chiede la conferma dell'eliminazione
		$("#eliminaServizioButton").click(function() {
			if (confirm("Vuoi veramente eliminare il servizio dalle ${servizioAttivo.startTime} alle ${servizioAttivo.endTime}?"))
				window.location.href = "/_5t/eliminaServizio";
		});
		
		// cliccando su una riga, il servizio corrispondente viene selezionato
		$("#listaServizi").find("tbody").find("tr").click(function() {
			var tripId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaServizio?id=" + tripId;
		});
		
		// inizializzazione tabella affinchè le colonne possano essere ordinabili
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Ora inizio")
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
		<li><a href="/_5t/agenzie">Agenzia ${agenziaAttiva.gtfsId}</a></li>
		<li><a href="/_5t/linee">Linea ${lineaAttiva.shortName}</a></li>
		<li><a href="/_5t/corse">Corsa ${corsaAttiva.tripShortName}</a></li>
		<li class="active">Servizi</li>
	</ol>
	
	<div class="row">
		<!-- Div con tabella contenente elenco servizi -->
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
		
		<!-- Div con pulsante per creare un servizio e riassunto dati servizio selezionata -->
		<div class="col-lg-6">
			<a id="creaServizioButton" class="btn btn-primary" href="/_5t/creaServizio">Crea un servizio</a>
			
			<!-- Div con form per creazione corsa -->
			<div id="creaServizio">
				<form:form commandName="frequency" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="start">Ora inizio</label>
				    		<input name="start" class="form-control" id="start" type="time" required="required" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="end">Ora fine</label>
				    		<input name="end" class="form-control" id="end" type="time" required="required" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="headwaySecs">Frequenza (min)</label>
				    		<form:input path="headwaySecs" class="form-control" id="headwaySecs" type="number" min="1" required="required" />
				    		<form:errors path="headwaySecs" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="exactTimes">Corsa programmata esattamente</label>
				    		<form:select path="exactTimes">
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
			
			<!-- Div con riassunto corsa selezionata -->
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
			
			<!-- Div con form per modifica servizio -->
			<div id="modificaServizio">
				<form:form commandName="frequency" method="post" role="form" action="/_5t/modificaServizio">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="start">Ora inizio</label>
				    		<input name="start" class="form-control" id="start" type="time" required="required" value="${servizioAttivo.startTime}" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="end">Ora fine</label>
				    		<input name="end" class="form-control" id="end" type="time" required="required" value="${servizioAttivo.endTime}" />
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="headwaySecs">Frequenza</label>
				    		<form:input path="headwaySecs" class="form-control" id="headwaySecs" type="number" min="1" required="required" value="${servizioAttivo.headwaySecs}" />
				    		<form:errors path="headwaySecs" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="exactTimes">Corsa programmata esattamente</label>
				    		<form:select path="exactTimes">
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
</body>
</html>