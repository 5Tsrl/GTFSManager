<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Agenzie</title>
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/languages.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/timezones.js' />"></script>
	<script type="text/javascript">
	// load the navigation bar
	$(function() {
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liAgenzie").addClass("active");
    		
			// se non è stata selezionata nessuna agenzia, i link della navigation bar vengono disattivati
			if (!"${agenziaAttiva}") {
				$("#navigationBar").find("li").each(function () {
					if ($(this).attr("id") != "liAgenzie" && $(this).attr("id") != "liGestioneGTFS") {
						$(this).find("a").each(function() {
						    $(this).addClass("disabled");
						});
					}
				});
			}
    	}); 
    });
	
	$(document).ready(function() {
		// form per modificare un'agenzia inizialmente nascosto
		$("#modificaAgenzia").hide();
		
		// la variabile showAlertDuplicateAgency è settata a true da AgencyController se l'id dell'agenzia è già presente
		if ("${showAlertDuplicateAgency}") {
			alert("L'id dell'agenzia che hai inserito è già presente");
		}
		// la variabile showForm è settata a true da AgencyController se il form sottomesso per la creazione di un'agenzia contiene degli errori
		if (!"${showCreateForm}") {
			$("#creaAgenzia").hide();
		} else {
			$("#creaAgenzia").show();
		}
		
		// cliccando sul pulsante "Modifica agenzia", il pulsante "Crea agenzia" e il div con il riassunto dell'agenzia attiva devono essere nascosti, mentre il form per modificare l'agenzia deve essere visualizzato
		$("#modificaAgenziaButton").click(function() {
			$("#creaAgenziaButton").hide();
			$("#riassuntoAgenzia").hide();
			$("#modificaAgenzia").show();
		});
		if ("${showEditForm}") {
			$("#creaAgenziaButton").hide();
			$("#riassuntoAgenzia").hide();
			$("#modificaAgenzia").show();
		};
		
		// cliccando sul pulsante "Elimina", viene mostrata una finestra di dialogo che chiede la conferma dell'eliminazione
		$("#eliminaAgenziaButton").click(function() {
			if (confirm("Vuoi veramente eliminare l'agenzia ${agenziaAttiva.name}?"))
				window.location.href = "/_5t/eliminaAgenzia";
		});
		
		// quando viene selezionata un'agenzia, abilito tutti i link della navigation bar
		$(".aSeleziona").click(function() {
			$("#navigationBar").find("li").find("a").removeClass("disabled");
		});
		
		// cliccando su una riga, l'agenzia corrispondente viene selezionata
		$("#listaAgenzie").find("tbody").find("tr").click(function() {
			var agencyId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaAgenzia?id=" + agencyId;
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
		var selTimezonesEdit = document.getElementById("timezonesEdit");
		for (var i=0; i<timezones.length; i++) {
			var opt = document.createElement('option');
		    opt.innerHTML = timezones[i].value;
		    opt.value = timezones[i].key;
		    if ("${agenziaAttiva.timezone}" == timezones[i].key) {
		    	opt.selected = true;
		    }
		    selTimezonesEdit.appendChild(opt);
		}
		
		// riempe il select delle lingue usando l'array di oggetti in languages.js
		var selLanguages = document.getElementById("languages");
		for (var i=0; i<languages.length; i++) {
			var opt = document.createElement('option');
		    opt.innerHTML = languages[i].name;
		    opt.value = languages[i].key;
		    if (languages[i].key=="it") {
		    	opt.selected = true;
		    }
		    selLanguages.appendChild(opt);
		}
		var selLanguagesEdit = document.getElementById("languagesEdit");
		for (var i=0; i<languages.length; i++) {
			var opt = document.createElement('option');
		    opt.innerHTML = languages[i].name;
		    opt.value = languages[i].key;
		    if ("${agenziaAttiva.language}" == languages[i].key) {
		    	opt.selected = true;
		    }
		    selLanguagesEdit.appendChild(opt);
		}
		
		// inizializzazione tabella affinchè le colonne possano essere ordinabili
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna agenzia"
	    	}
	    });
	});
	</script>
</head>
<body>
	<!-- Navigation bar -->
	<nav id="navigationBar" class="navbar navbar-default" role="navigation"></nav>
	
	<ol class="breadcrumb">
		<li class="active">Agenzie</li>
	</ol>
	
	<div class="row">
		<!-- Div con tabella contenente elenco agenzie -->
		<div class="col-lg-6">
			<table id="listaAgenzie" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Nome</th>
						<th>Linee</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="agenzia" items="${listaAgenzie}">
						<c:choose>
							<c:when test="${not empty agenziaAttiva}">
								<c:if test="${agenziaAttiva.id == agenzia.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${agenzia.gtfsId}</td>
							<td>${agenzia.name}</td>
							<td>
								${fn:length(agenzia.routes)}
								<c:choose>
									<c:when test="${agenziaAttiva.id == agenzia.id}">
										<a class="btn btn-default" href="/_5t/linee">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="/_5t/linee">
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${fn:length(agenzia.routes) == 0}">Inserisci linee</c:when>
									<c:when test="${fn:length(agenzia.routes) > 0}">Visualizza/modifica linee</c:when>
								</c:choose>
								</a>
							</td>
							<td class="hidden">${agenzia.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div con pulsante per creare un'agenzia e riassunto dati agenzia selezionata -->
		<div class="col-lg-6">
			<a id="creaAgenziaButton" class="btn btn-primary" href="/_5t/creaAgenzia">Crea un'agenzia</a>
			
			<!-- Div con form per creazione agenzia -->
			<div id="creaAgenzia">
				<form:form commandName="agency" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l'id" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name">Nome</label>
				    		<form:input path="name" class="form-control" id="name" placeholder="Inserisci il nome" maxlength="255" />
				    		<form:errors path="name" cssClass="error"></form:errors>
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
						<div class="form-group col-lg-8">
							<label for="timezone">Fuso orario</label>
							<form:select path="timezone" id="timezones" class="col-lg-12"></form:select>
							<form:errors path="timezone" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="language">Lingua</label>
							<form:select path="language" id="languages" class="col-lg-12"></form:select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="phone">Telefono</label>
				    		<form:input path="phone" class="form-control" id="phone" placeholder="Inserisci il numero di telefono" maxlength="20" />
				    		<form:errors path="phone" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="fareUrl">Sito web tariffe</label>
				    		<form:input path="fareUrl" class="form-control" id="fareUrl" type="url" placeholder="Inserisci il sito web delle tariffe" maxlength="255" />
				    		<form:errors path="fareUrl" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea agenzia" />
							<a class="btn btn-default" href="/_5t/agenzie">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div con riassunto agenzia selezionata -->
			<c:if test="${not empty agenziaAttiva}">
				<div id="riassuntoAgenzia" class="riassunto">
					<div class="col-lg-8">
						<b>Id:</b> ${agenziaAttiva.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Nome:</b> ${agenziaAttiva.name}
					</div>
					<div class="col-lg-8">
						<b>Sito web:</b> <a href="${agenziaAttiva.url}">${agenziaAttiva.url}</a>
					</div>
					<div class="col-lg-8">
						<b>Fuso orario:</b> ${agenziaAttiva.timezone}
					</div>
					<div class="col-lg-8">
						<b>Lingua:</b> ${agenziaAttiva.language}
					</div>
					<div class="col-lg-8">
						<b>Telefono:</b> ${agenziaAttiva.phone}
					</div>
					<div class="col-lg-8">
						<b>Sito web tariffe:</b> <a href="${agenziaAttiva.fareUrl}">${agenziaAttiva.fareUrl}</a>
					</div>
					<div class="col-lg-12">
						<a id="modificaAgenziaButton" class="btn btn-primary" href="/_5t/modificaAgenzia">Modifica</a>
						<button id="eliminaAgenziaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div con form per modifica agenzia -->
			<div id="modificaAgenzia">
				<form:form commandName="agency" method="post" role="form" action="/_5t/modificaAgenzia">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${agenziaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name">Nome</label>
				    		<form:input path="name" class="form-control" id="name" value="${agenziaAttiva.name}" maxlength="255" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="url">Sito web</label>
				    		<form:input path="url" class="form-control" id="url" type="url" value="${agenziaAttiva.url}" maxlength="255" />
				    		<form:errors path="url" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="timezone">Fuso orario</label>
							<form:select path="timezone" id="timezonesEdit" class="col-lg-12"></form:select>
							<form:errors path="timezone" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="language">Lingua</label>
							<form:select path="language" id="languagesEdit" class="col-lg-12"></form:select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="phone">Telefono</label>
				    		<form:input path="phone" class="form-control" id="phone" value="${agenziaAttiva.phone}" maxlength="20" />
				    		<form:errors path="phone" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="fareUrl">Sito web tariffe</label>
				    		<form:input path="fareUrl" class="form-control" id="fareUrl" type="url" value="${agenziaAttiva.fareUrl}" maxlength="255" />
				    		<form:errors path="fareUrl" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica agenzia" />
							<a class="btn btn-default" href="/_5t/agenzie">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
</body>
</html>