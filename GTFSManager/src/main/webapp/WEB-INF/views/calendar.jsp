<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="it.torino._5t.entity.Calendar" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Calendari</title>
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
    		$("#liCalendari").addClass("active");
    	}); 
    });
	
	$(document).ready(function() {
		// form per modificare un calendario inizialmente nascosto
		$("#modificaCalendario").hide();
		$("#modificaEccezione").hide();
		
		// la variabile showForm è settata a true da CalendarController se il form sottomesso per la creazione di un calendario contiene degli errori
		if (!"${showCreateForm}") {
			$("#creaCalendario").hide();
		} else {
			$("#creaCalendario").show();
		}
		if (!"${showCreateCalendarDateForm}") {
			$("#creaEccezione").hide();
		} else {
			$("#creaEccezione").show();
		}
		
		// la variabile showAlertWrongCalendarDates è settata a true se la data di inizio inserita nel calendario è successiva alla data di fine 
		if ("${showAlertWrongCalendarDates}") {
			alert("La data di inizio non può essere successiva alla data di fine");
		}
		
		// la variabile showAlertWrongExceptionDate è settata a true se la data inserita nell'eccezione è errata (non nel range del calendario corrispondente) 
		if ("${showAlertWrongExceptionDate}") {
			alert("La data dell'eccezione inserita non è compresa tra le date del calendario corrispondente");
		}
		
		// cliccando sul pulsante "Modifica calendario", il pulsante "Crea calendario" e il div con il riassunto del calendario attivo devono essere nascosti, mentre il form per modificare il calendario deve essere visualizzato
		$("#modificaCalendarioButton").click(function() {
			$("#creaCalendarioButton").hide();
			$("#riassuntoCalendario").hide();
			$("#modificaCalendario").show();
		});
		if ("${showEditForm}") {
			$("#creaCalendarioButton").hide();
			$("#riassuntoCalendario").hide();
			$("#modificaCalendario").show();
		};
		$("#modificaEccezioneButton").click(function() {
			$("#creaEccezioneButton").hide();
			$("#riassuntoEccezione").hide();
			$("#modificaEccezione").show();
		});
		if ("${showEditCalendarDateForm}") {
			$("#creaEccezioneButton").hide();
			$("#riassuntoEccezione").hide();
			$("#modificaEccezione").show();
		};
		
		// cliccando sul pulsante "Elimina", viene mostrata una finestra di dialogo che chiede la conferma dell'eliminazione
		$("#eliminaCalendarioButton").click(function() {
			if ("${calendarioAttivo.trips.size()}" > 0)
				alert("Non puoi eliminare il calendario.\nDevi prima modificare le corse associate ad esso.")
			else if (confirm("Vuoi veramente eliminare il calendario ${calendarioAttivo.name}?"))
				window.location.href = "/_5t/eliminaCalendario";
		});
		$("#eliminaEccezioneButton").click(function() {
			if (confirm("Vuoi veramente eliminare l'eccezione ${eccezioneAttiva.date}?"))
				window.location.href = "/_5t/eliminaEccezione";
		});
		
		// cliccando su una riga, il calendario corrispondente viene selezionato
		$("#listaCalendari").find("tbody").find("tr").click(function() {
			var serviceId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaCalendario?id=" + serviceId;
		});
		
		// cliccando su una riga, l'eccezione corrispondente viene selezionata
		$("#listaEccezioni").find("tbody").find("tr").click(function() {
			var calendarDateId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaEccezione?id=" + calendarDateId;
		});
		
		// inizializzazione tabella affinchè le colonne possano essere ordinabili
		$('#listaCalendari').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessun calendario"
	    	}
	    });
		$('#listaCorse').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna corsa è associata a questo calendario"
	    	}
	    });
		$('#listaEccezioni').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Data")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna eccezione è associata a questo calendario"
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
	</ol>
	
	<div class="row">
		<!-- Div con tabella contenente elenco calendari -->
		<div class="col-lg-6">
			<table id="listaCalendari" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Nome</th>
						<th>Data inizio</th>
						<th>Data fine</th>
						<th>Giorni</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="calendario" items="${listaCalendari}">
						<c:choose>
							<c:when test="${not empty calendarioAttivo}">
								<c:if test="${calendarioAttivo.id == calendario.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${calendario.name}</td>
							<td><fmt:formatDate pattern="dd/MM/yyyy" value="${calendario.startDate}" /></td>
							<td><fmt:formatDate pattern="dd/MM/yyyy" value="${calendario.endDate}" /></td>
							<td>
								<c:if test="${calendario.monday}">Lun</c:if>
								<c:if test="${calendario.tuesday}">Mar</c:if>
								<c:if test="${calendario.wednesday}">Mer</c:if>
								<c:if test="${calendario.thursday}">Gio</c:if>
								<c:if test="${calendario.friday}">Ven</c:if>
								<c:if test="${calendario.saturday}">Sab</c:if>
								<c:if test="${calendario.sunday}">Dom</c:if>
							</td>
							<td class="hidden">${calendario.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div con pulsante per creare un calendario e riassunto dati calendario selezionato -->
		<div class="col-lg-6">
			<a id="creaCalendarioButton" class="btn btn-primary" href="/_5t/creaCalendario">Crea un calendario</a>
			
			<!-- Div con form per creazione calendario -->
			<div id="creaCalendario">
				<form:form commandName="calendar" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name">Nome</label>
				    		<form:input path="name" class="form-control" id="name" placeholder="Inserisci il nome" maxlength="50" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="startDate">Data inizio</label>
				    		<form:input path="startDate" class="form-control" id="startDate" type="date" required="required" />
				    		<form:errors path="startDate" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="endDate">Data fine</label>
				    		<form:input path="endDate" class="form-control" id="endDate" type="date" required="required" />
				    		<form:errors path="endDate" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group">
							<label>Giorni </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="monday" />Lun
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="tuesday" />Mar
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="wednesday" />Mer
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="thursday" />Gio
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="friday" />Ven
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="saturday" />Sab
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="sunday" />Dom
						    </label>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea calendario" />
							<a class="btn btn-default" href="/_5t/calendari">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div con riassunto calendario selezionato -->
			<c:if test="${not empty calendarioAttivo}">
				<div id="riassuntoCalendario" class="riassunto">
					<% Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo"); %>
					<div class="col-lg-8">
						<b>Nome:</b> ${calendarioAttivo.name}
					</div>
					<div class="col-lg-8">
						<b>Data inizio:</b> <fmt:formatDate pattern="dd/MM/yyyy" value="${calendarioAttivo.startDate}" />
					</div>
					<div class="col-lg-8">
						<b>Data fine:</b> <fmt:formatDate pattern="dd/MM/yyyy" value="${calendarioAttivo.endDate}" />
					</div>
					<div class="col-lg-8">
						<b>Giorni:</b>
						<c:if test="${calendarioAttivo.monday}">Lun</c:if>
						<c:if test="${calendarioAttivo.tuesday}">Mar</c:if>
						<c:if test="${calendarioAttivo.wednesday}">Mer</c:if>
						<c:if test="${calendarioAttivo.thursday}">Gio</c:if>
						<c:if test="${calendarioAttivo.friday}">Ven</c:if>
						<c:if test="${calendarioAttivo.saturday}">Sab</c:if>
						<c:if test="${calendarioAttivo.sunday}">Dom</c:if>
					</div>
					<div class="col-lg-12">
						<a id="modificaCalendarioButton" class="btn btn-primary" href="/_5t/modificaCalendario">Modifica</a>
						<button id="eliminaCalendarioButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div con form per modifica calendario -->
			<div id="modificaCalendario">
				<form:form commandName="calendar" method="post" role="form" action="/_5t/modificaCalendario">
					<% Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo"); %>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name">Nome</label>
				    		<form:input path="name" class="form-control" id="name" value="${calendarioAttivo.name}" maxlength="50" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="startDate">Data inizio</label>
				    		<form:input path="startDate" class="form-control" id="startDate" type="date" required="required" value="${calendarioAttivo.startDate}" />
				    		<form:errors path="startDate" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="endDate">Data fine</label>
				    		<form:input path="endDate" class="form-control" id="endDate" type="date" required="required" value="${calendarioAttivo.endDate}" />
				    		<form:errors path="endDate" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group" id="daysCheckbox">
							<label>Giorni </label>
						  	<label class="checkbox-inline">
					  			<form:checkbox path="monday" />Lun
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="tuesday" />Mar
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="wednesday" />Mer
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="thursday" />Gio
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="friday" />Ven
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="saturday" />Sab
						    </label>
						  	<label class="checkbox-inline">
						    	<form:checkbox path="sunday" />Dom
						    </label>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica calendario" />
							<a class="btn btn-default" href="/_5t/calendari">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	
	<hr>
	
	<div class="row">
		<c:if test="${not empty calendarioAttivo}">
			<!-- div con tabella contenente le corse che utilizzano il calendario selezionato -->
			<div class="col-lg-5">
				<h4>Corse associate al calendario ${calendarioAttivo.name}</h4>
				<table id="listaCorse" class="table table-striped table-hover sortable">
					<thead>
						<tr>
							<th>Nome</th>
							<th>Display</th>
							<th>Direzione</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="corsa" items="${listaCorse}">
							<tr>
								<td><a href="/_5t/selezionaCorsa?id=${corsa.id}">${corsa.tripShortName}</a></td>
								<td>${corsa.tripHeadsign}</td>
								<td>
									<c:choose>
										<c:when test="${corsa.directionId == 0}">Andata</c:when>
										<c:otherwise>Ritorno</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- div con tabella contenente le eccezioni associate al calendario selezionato -->
			<div class="col-lg-4">
				<h4>Eccezioni associate al calendario ${calendarioAttivo.name}</h4>
				<table id="listaEccezioni" class="table table-striped table-hover sortable">
					<thead>
						<tr>
							<th>Data</th>
							<th>Tipo</th>
							<th class="hidden"></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="eccezione" items="${listaEccezioni}">
							<c:choose>
								<c:when test="${not empty eccezioneAttiva}">
									<c:if test="${eccezioneAttiva.id == eccezione.id}">
										<tr class="success">
									</c:if>
								</c:when>
								<c:otherwise>
									<tr>
								</c:otherwise>
							</c:choose>
								<td><fmt:formatDate pattern="dd/MM/yyyy" value="${eccezione.date}" /></td>
								<td>
									<c:choose>
										<c:when test="${eccezione.exceptionType == 1}">Servizio aggiunto</c:when>
										<c:otherwise>Servizio cancellato</c:otherwise>
									</c:choose>
								</td>
								<td class="hidden">${eccezione.id}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- div con tabella contenente le eccezioni associate al calendario selezionato -->
			<div class="col-lg-3">
				<a id="creaEccezioneButton" class="btn btn-primary" href="/_5t/creaEccezione">Crea un'eccezione</a>
			
				<!-- Div con form per creazione eccezione -->
				<div id="creaEccezione">
					<form:form commandName="calendarDate" method="post" role="form" action="/_5t/creaEccezione">
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="date">Data</label>
					    		<form:input path="date" class="form-control" id="date" type="date" required="required" />
					    		<form:errors path="date" cssClass="error"></form:errors>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="exceptionType">Tipo</label>
					    		<form:select path="exceptionType" required="true">
					    			<form:option value="">Seleziona il tipo</form:option>
					    			<form:option value="1">Servizio aggiunto</form:option>
					    			<form:option value="2">Servizio cancellato</form:option>
					    		</form:select>
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<input class="btn btn-success" type="submit" value="Crea eccezione" />
								<a class="btn btn-default" href="/_5t/calendari">Annulla</a>
							</div>
						</div>
					</form:form>
				</div>
				
				<hr>
			
				<!-- Div con riassunto calendario selezionato -->
				<c:if test="${not empty eccezioneAttiva}">
					<div id="riassuntoEccezione" class="riassunto">
						<div>
							<b>Data:</b> <fmt:formatDate pattern="dd/MM/yyyy" value="${eccezioneAttiva.date}" />
						</div>
						<div>
							<b>Tipo:</b>
							<c:choose>
								<c:when test="${eccezioneAttiva.exceptionType == 1}">Servizio aggiunto</c:when>
								<c:otherwise>Serzivio cancellato</c:otherwise>
							</c:choose>
						</div>
						<div>
							<a id="modificaEccezioneButton" class="btn btn-primary" href="/_5t/modificaEccezione">Modifica</a>
							<button id="eliminaEccezioneButton" type="button" class="btn btn-danger">Elimina</button>
						</div>
					</div>
				</c:if>
				
				<!-- Div con form per modifica eccezione -->
				<div id="modificaEccezione">
					<form:form commandName="calendarDate" method="post" role="form" action="/_5t/modificaEccezione">
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="date">Data</label>
					    		<form:input path="date" class="form-control" id="date" type="date" required="required" value="${eccezioneAttiva.date}" />
					    		<form:errors path="date" cssClass="error"></form:errors>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="exceptionType">Tipo</label>
					    		<form:select path="exceptionType" required="true">
					    			<form:option value="">Seleziona il tipo</form:option>
					    			<c:choose>
					    				<c:when test="${eccezioneAttiva.exceptionType == 1}">
							    			<form:option value="1" selected="true">Servizio aggiunto</form:option>
							    			<form:option value="2">Servizio cancellato</form:option>
					    				</c:when>
					    				<c:otherwise>
					    					<form:option value="1">Servizio aggiunto</form:option>
							    			<form:option value="2" selected="true">Servizio cancellato</form:option>
					    				</c:otherwise>
					    			</c:choose>
					    		</form:select>
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<input class="btn btn-success" type="submit" value="Modifica eccezione" />
								<a class="btn btn-default" href="/_5t/calendari">Annulla</a>
							</div>
						</div>
					</form:form>
				</div>
			</div>
		</c:if>
	</div>
</body>
</html>