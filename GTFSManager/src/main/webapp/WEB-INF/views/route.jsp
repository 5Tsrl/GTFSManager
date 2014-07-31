<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="it.torino._5t.entity.Route" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Linee</title>
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
		// form per modificare una linea inizialmente nascosto
		$("#modificaLinea").hide();
		
		// la variabile showForm è settata a true da RouteController se il form sottomesso per la creazione di una linea contiene degli errori
		if (!"${showCreateForm}") {
			$("#creaLinea").hide();
		} else {
			$("#creaLinea").show();
		}
		
		// cliccando sul pulsante "Modifica linea", il pulsante "Crea linea" e il div con il riassunto della linea attiva devono essere nascosti, mentre il form per modificare la linea deve essere visualizzato
		$("#modificaLineaButton").click(function() {
			$("#creaLineaButton").hide();
			$("#riassuntoLinea").hide();
			$("#modificaLinea").show();
		});
		if ("${showEditForm}") {
			$("#creaLineaButton").hide();
			$("#riassuntoLinea").hide();
			$("#modificaLinea").show();
		};
		
		// cliccando sul pulsante "Elimina", viene mostrata una finestra di dialogo che chiede la conferma dell'eliminazione
		$("#eliminaLineaButton").click(function() {
			if (confirm("Vuoi veramente eliminare la linea ${lineaAttiva.shortName}?"))
				window.location.href = "/_5t/eliminaLinea";
		});
		
		// cliccando su una riga, la linea corrispondente viene selezionata
		$("#listaLinee").find("tbody").find("tr").click(function() {
			var routeId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaLinea?id=" + routeId;
		});
		
		// inizializzazione tabella affinchè le colonne possano essere ordinabili
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Linea")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna linea"
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
		<li class="active">Linee</li>
	</ol>
	
	<% 
	HashMap<Integer, String> types = new HashMap<Integer, String>(); 
	types.put(0, "Tram");
	types.put(1, "Metropolitana");
	types.put(2, "Treno");
	types.put(3, "Bus");
	types.put(4, "Traghetto");
	types.put(5, "Funivia");
	types.put(6, "Funivia aerea");
	types.put(7, "Funicolare");
	%>
	
	<div class="row">
		<!-- Div con tabella contenente elenco linee -->
		<div class="col-lg-6">
			<table id="listaLinee" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Linea</th>
						<th>Nome</th>
						<th>Corse</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="linea" items="${listaLinee}">
						<c:choose>
							<c:when test="${not empty lineaAttiva}">
								<c:if test="${lineaAttiva.id == linea.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${linea.shortName}</td>
							<td>${linea.longName}</td>
							<td>
								${fn:length(linea.trips)}
								<c:choose>
									<c:when test="${lineaAttiva.id == linea.id}">
										<a class="btn btn-default" href="/_5t/corse">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="/_5t/corse">
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${fn:length(linea.trips) == 0}">Inserisci corse</c:when>
									<c:when test="${fn:length(linea.trips) > 0}">Visualizza/modifica corse</c:when>
								</c:choose>
								</a>
							</td>
							<td class="hidden">${linea.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div con pulsante per creare una linea e riassunto dati linea selezionata -->
		<div class="col-lg-6">
			<a id="creaLineaButton" class="btn btn-primary" href="/_5t/creaLinea">Crea una linea</a>
			
			<!-- Div con form per creazione linea -->
			<div id="creaLinea">
				<form:form commandName="route" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="shortName">Linea</label>
				    		<form:input path="shortName" class="form-control" id="shortName" placeholder="Inserisci la linea" maxlength="20" />
				    		<form:errors path="shortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="longName">Nome</label>
				    		<form:input path="longName" class="form-control" id="longName" placeholder="Inserisci il nome" maxlength="50" />
				    		<form:errors path="longName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="description">Descrizione</label>
				    		<form:textarea path="description" class="form-control" id="description" placeholder="Inserisci la descrizione" maxlength="255" rows="2" />
				    		<form:errors path="description" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="type">Modalità di trasporto</label>
							<form:select path="type">
								<%
								for (int i=0; i<=7; i++) {
									if (i == 3) {
								%>
										<form:option value="<%= i %>" selected="true"><%= types.get(i) %></form:option>
								<%
									} else { 
								%>
										<form:option value="<%= i %>"><%= types.get(i) %></form:option>
								<%
									}
								}
								%>
							</form:select>
							<form:errors path="type" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="url">Sito web</label>
				    		<form:input path="url" class="form-control" id="url" type="url" placeholder="Inserisci il sito web" maxlength="255" />
				    		<form:errors path="url" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-3">
							<label for="color">Colore linea</label>
				    		<form:input type="color" path="color" class="form-control" id="color" value="#FFFFFF" />
				    		<form:errors path="color" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-3">
							<label for="textColor">Colore testo</label>
				    		<form:input type="color" path="textColor" class="form-control" id="textColor" value="#000000" />
				    		<form:errors path="textColor" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea linea" />
							<a class="btn btn-default" href="/_5t/linee">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div con riassunto linea selezionata -->
			<c:if test="${not empty lineaAttiva}">
				<div id="riassuntoLinea" class="riassunto">
					<div class="col-lg-8">
						<b>Linea:</b> ${lineaAttiva.shortName}
					</div>
					<div class="col-lg-8">
						<b>Nome:</b> ${lineaAttiva.longName}
					</div>
					<div class="col-lg-8">
						<b>Descrizione:</b> ${lineaAttiva.description}
					</div>
					<div class="col-lg-8">
						<b>Modalità di trasporto:</b>
						<%
						Route route = (Route) session.getAttribute("lineaAttiva");
						out.write(types.get(route.getType()));
						%>
					</div>
					<div class="col-lg-8">
						<b>Sito web:</b> <a href="${lineaAttiva.url}">${lineaAttiva.url}</a>
					</div>
					<div class="col-lg-8">
						<b>Colore linea:</b> <p class="colored" style="background: ${lineaAttiva.color};"></p>
					</div>
					<div class="col-lg-8">
						<b>Colore testo:</b> <p class="colored" style="background: ${lineaAttiva.textColor};"></p>
					</div>
					<div class="col-lg-8">
						<b>Tariffe:</b>
						<c:forEach var="tariffa" items="${listaTariffe}" varStatus="i">
							<a href="/_5t/selezionaTariffa?id=${tariffa.fareAttribute.id}">${tariffa.fareAttribute.name}</a><c:if test="${!i.last}">,</c:if>
						</c:forEach>
					</div>
					<div class="col-lg-12">
						<a id="modificaLineaButton" class="btn btn-primary" href="/_5t/modificaLinea">Modifica</a>
						<button id="eliminaLineaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div con form per modifica linea -->
			<div id="modificaLinea">
				<form:form commandName="route" method="post" role="form" action="/_5t/modificaLinea">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="shortName">Linea</label>
				    		<form:input path="shortName" class="form-control" id="shortName" value="${lineaAttiva.shortName}" maxlength="20" />
				    		<form:errors path="shortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="longName">Nome</label>
				    		<form:input path="longName" class="form-control" id="longName" value="${lineaAttiva.longName}" maxlength="50" />
				    		<form:errors path="longName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="description">Descrizione</label>
				    		<form:input path="description" class="form-control" id="description" value="${lineaAttiva.description}" maxlength="255" />
				    		<form:errors path="description" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="type">Modalità di trasporto</label>
							<form:select path="type">
								<%
								Route route = (Route) session.getAttribute("lineaAttiva");
								if (route != null) {
									for (int i=0; i<=types.size(); i++) {
										if (i == route.getType()) {
								%>
										<form:option value="<%= i %>" selected="true"><%= types.get(i) %></form:option>
								<%
										} else { 
								%>
										<form:option value="<%= i %>"><%= types.get(i) %></form:option>
								<%
										}
									}
								}
								%>
							</form:select>
							<form:errors path="type" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="url">Sito web</label>
				    		<form:input path="url" class="form-control" id="url" type="url" value="${lineaAttiva.url}" maxlength="255" />
				    		<form:errors path="url" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-3">
							<label for="color">Colore linea</label>
				    		<form:input type="color" path="color" class="form-control" id="color" value="${lineaAttiva.color}" />
				    		<form:errors path="color" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-3">
							<label for="textColor">Colore testo</label>
				    		<form:input type="color" path="textColor" class="form-control" id="textColor" value="${lineaAttiva.textColor}" />
				    		<form:errors path="textColor" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica linea" />
							<a class="btn btn-default" href="/_5t/linee">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
</body>
</html>