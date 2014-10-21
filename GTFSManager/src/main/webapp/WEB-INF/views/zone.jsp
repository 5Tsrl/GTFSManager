<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Zone</title>
	<link href="<c:url value='/resources/images/favicon.ico' />" rel="icon" type="image/x-icon">
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
	<link href="<c:url value='/resources/css/bootstrap-multiselect.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
	<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	// load the navigation bar
	$(function(){
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liZone").addClass("active");
    	});
    });
	
	$(document).ready(function() {
		// edit zone form and alerts initially hidden
		$("#modificaZona").hide();
		$(".alert").hide();
		
		// showAlertDuplicateZone variable is set to true by ZoneController if the zone id is already present
		if ("${showAlertDuplicateZone}") {
			$("#zone-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by ZoneController if the the submitted form to create a zone contains errors
		if (!"${showCreateForm}") {
			$("#creaZona").hide();
		} else {
			$("#creaZona").show();
		}
		
		// clicking on "Modifica zona" button, "Crea zona" button and div with active zone summary should be hidden, while the form to modify the zone should be shown
		$("#modificaZonaButton").click(function() {
			$("#creaZonaButton").hide();
			$("#riassuntoZona").hide();
			$("#modificaZona").show();
		});
		if ("${showEditForm}") {
			$("#creaZonaButton").hide();
			$("#riassuntoZona").hide();
			$("#modificaZona").show();
		};
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaZonaButton").click(function() {
			if ("${zonaAttiva.stops.size()}" > 0 || "${zonaAttiva.originFareRules.size()}" > 0 || "${zonaAttiva.destinationFareRules.size()}" > 0)
				$("#zone-not-deletable").show();
			else 
				$("#delete-zone").show();
		});
		$("#delete-zone-button").click(function() {
			window.location.href = "/_5t/eliminaZona";
		});
		
		// clicking on a row, the correspondent zone is selected
		$("#listaZone").find("tbody").find("tr").click(function() {
			var zoneId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaZona?id=" + zoneId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Creation zone form validation
		$("#creaZonaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				name: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				name: {
					required: "Il campo nome è obbligatorio"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit zone form validation
		$("#modificaZonaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				name: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				name: {
					required: "Il campo nome è obbligatorio"
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
		$('#listaZone').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna zona"
	    	}
	    });
		$('#listaFermate').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Id")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna fermata è presente in questa zona"
	    	}
	    });
		$('#listaTariffeOrigine').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Id")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna tariffa ha come origine questa zona"
	    	}
	    });
		$('#listaTariffeDestinazione').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Id")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna tariffa ha come destinazione questa zona"
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
	</ol>
	
	<p>Cliccare su una riga della tabella per selezionare la zona corrispondente.</p>
	
	<div class="row">
		<!-- Div with table containing zone list -->
		<div class="col-lg-6">
			<table id="listaZone" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Nome</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="zona" items="${listaZone}">
						<c:choose>
							<c:when test="${not empty zonaAttiva}">
								<c:if test="${zonaAttiva.id == zona.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${zona.gtfsId}</td>
							<td>${zona.name}</td>
							<td class="hidden">${zona.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create zone and selected zone summary -->
		<div class="col-lg-6">
			<a id="creaZonaButton" class="btn btn-primary" href="/_5t/creaZona">Crea una zona</a>
			
			<!-- Div with create zone form -->
			<div id="creaZona">
				<form:form id="creaZonaForm" commandName="zone" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l'id" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name" class="required">Nome</label>
				    		<form:input path="name" class="form-control" id="name" placeholder="Inserisci il nome" maxlength="50" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea zona" />
							<a class="btn btn-default" href="/_5t/zone">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected zone summary -->
			<c:if test="${not empty zonaAttiva}">
				<div id="riassuntoZona" class="riassunto">
					<div class="col-lg-8">
						<b>Id:</b> ${zonaAttiva.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Nome:</b> ${zonaAttiva.name}
					</div>
					<div class="col-lg-12">
						<a id="modificaZonaButton" class="btn btn-primary" href="/_5t/modificaZona">Modifica</a>
						<button id="eliminaZonaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit zone form -->
			<div id="modificaZona">
				<form:form id="modificaZonaForm" commandName="zone" method="post" role="form" action="/_5t/modificaZona">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${zonaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name" class="required">Nome</label>
				    		<form:input path="name" class="form-control" id="name" value="${zonaAttiva.name}" maxlength="50" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica zona" />
							<a class="btn btn-default" href="/_5t/zone">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	
	<hr>
	
	<div class="row">
		<c:if test="${not empty zonaAttiva}">
			<!-- div with table containing stops in the selected zone -->
			<div class="col-lg-4">
				<h4>Fermate nella zona ${zonaAttiva.gtfsId}</h4>
				<table id="listaFermate" class="table table-striped table-hover sortable">
					<thead>
						<tr>
							<th>Id</th>
							<th>Nome</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="fermata" items="${listaFermate}">
							<tr>
								<td>${fermata.gtfsId}</td>
								<td>${fermata.name}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- div with table containing fare rules with origin zone in the selected zone -->
			<div class="col-lg-4">
				<h4>Tariffe con origine nella zona ${zonaAttiva.gtfsId}</h4>
				<table id="listaTariffeOrigine" class="table table-striped table-hover sortable">
					<thead>
						<tr>
							<th>Tariffa</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="tariffa" items="${listaTariffeOrigine}">
							<tr>
								<td><a href="/_5t/selezionaTariffa?id=${tariffa.id}">${tariffa.gtfsId}</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- div with table containing fare rules with destination zone in the selected zone -->
			<div class="col-lg-4">
				<h4>Tariffe con destinazione nella zona ${zonaAttiva.gtfsId}</h4>
				<table id="listaTariffeDestinazione" class="table table-striped table-hover sortable">
					<thead>
						<tr>
							<th>Tariffa</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="tariffa" items="${listaTariffeDestinazione}">
							<tr>
								<td><a href="/_5t/selezionaTariffa?id=${tariffa.id}">${tariffa.gtfsId}</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</c:if>
	</div>
	
	<!-- Alerts -->
	<div id="zone-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id della zona che hai inserito è già presente.
	</div>
	<div id="delete-zone" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare la zona ${zonaAttiva.name}?</p>
	    <button id="delete-zone-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
	<div id="zone-not-deletable" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>Non puoi eliminare la zona.<br>Devi prima modificare le fermate in essa presenti o le tariffe con origine e/o destinazione da questa zona.</p>
	</div>
</body>
</html>