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
	<link href="<c:url value='/resources/images/favicon.ico' />" rel="icon" type="image/x-icon">
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
	<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/languages.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/timezones.js' />"></script>
	<script type="text/javascript">
	// load the navigation bar
	$(function() {
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liAgenzie").addClass("active");
    	}); 
    });
	
	$(document).ready(function() {
		// edit agency form and alerts initially hidden
		$("#modificaAgenzia").hide();
		$(".alert").hide();
		
		// showAlertDuplicateAgency variable is set to true by AgencyController if the agency id is already present
		if ("${showAlertDuplicateAgency}") {
			$("#agency-already-inserted").show();
		}
	    
		// showForm variable is set to true from AgencyController if the submitted form for agency creation contains errors
		if (!"${showCreateForm}") {
			$("#creaAgenzia").hide();
		} else {
			$("#creaAgenzia").show();
		}
		
		// clicking on "Modifica agenzia" button, "Crea agenzia" button and div with active agency summary should be hidden, while the form to modify the agency should be shown
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
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaAgenziaButton").click(function() {
			$("#delete-agency").show();
		});
		$("#delete-agency-button").click(function() {
			window.location.href = "eliminaAgenzia";
		});
		
		// when an agency is selected, all navigation bar links are enabled
		$(".aSeleziona").click(function() {
			$("#navigationBar").find("li").find("a").removeClass("disabled");
		});
		
		// clicking on a row, the correspondent agency is selected
		$("#listaAgenzie").find("tbody").find("tr").click(function() {
			var agencyId = $(this).find(".hidden").html();
			window.location.href = "selezionaAgenzia?id=" + agencyId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaAgenziaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente un'agenzia." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaAgenziaForm").find("#name").popover({ container: 'body', trigger: 'focus', title:"Nome", content:"Il nome completo dell'agenzia. Google Maps mostrerà questo nome." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaAgenziaForm").find("#url").popover({ container: 'body', trigger: 'focus', title:"Sito web", content:"Il sito web dell'agenzia. L'url deve essere completa, includendo http:// o https://." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaAgenziaForm").find("#phone").popover({ container: 'body', trigger: 'focus', title:"Telefono", content:"Il numero di telefono dell'agenzia. Può contenere segni di punteggiatura per raggruppare le cifre del numero." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaAgenziaForm").find("#fareUrl").popover({ container: 'body', trigger: 'focus', title:"Sito web tariffe", content:"Il sito web che permette a un cliente di acquistare biglietti o altri strumenti tariffari per l'agenzia." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaAgenziaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente un'agenzia." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaAgenziaForm").find("#name").popover({ container: 'body', trigger: 'focus', title:"Nome", content:"Il nome completo dell'agenzia. Google Maps mostrerà questo nome." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaAgenziaForm").find("#url").popover({ container: 'body', trigger: 'focus', title:"Sito web", content:"Il sito web dell'agenzia. L'url deve essere completa, includendo http:// o https://." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaAgenziaForm").find("#phone").popover({ container: 'body', trigger: 'focus', title:"Telefono", content:"Il numero di telefono dell'agenzia. Può contenere segni di punteggiatura per raggruppare le cifre del numero." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaAgenziaForm").find("#fareUrl").popover({ container: 'body', trigger: 'focus', title:"Sito web tariffe", content:"Il sito web che permette a un cliente di acquistare biglietti o altri strumenti tariffari per l'agenzia." })
			.blur(function () { $(this).popover('hide'); });
		
		// Creation agency form validation
		$("#creaAgenziaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				name: {
					required: true
				},
				url: {
					required: true,
					url: true
				},
				fareUrl: {
					url: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				name: {
					required: "Il campo nome è obbligatorio"
				},
				url: {
					required: "Il campo url è obbligatorio",
					url: "Inserire un url corretta"
				},
				fareUrl: {
					url: "Inserire un url corretta"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit agency form validation
		$("#modificaAgenziaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				name: {
					required: true
				},
				url: {
					required: true,
					url: true
				},
				fareUrl: {
					url: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				name: {
					required: "Il campo nome è obbligatorio"
				},
				url: {
					required: "Il campo url è obbligatorio",
					url: "Inserire un url corretta"
				},
				fareUrl: {
					url: "Inserire un url corretta"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// fill timezones select using objects array in timezones.js
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
		
		// fill timezones select using objects array in languages.js
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
		
		// table initialization to have sortable columns
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Nome")
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
	
	<p>Cliccare su una riga della tabella per selezionare l'agenzia corrispondente.</p>
	
	<div class="row">
		<!-- Div with table containing agency list -->
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
										<a class="btn btn-default" href="linee">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="linee">
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
		
		<!-- Div with button to create agency and selected agency summary -->
		<div class="col-lg-6">
			<a id="creaAgenziaButton" class="btn btn-primary" href="creaAgenzia">Crea un'agenzia</a>
			
			<!-- Div with create agency form -->
			<div id="creaAgenzia">
				<form:form id="creaAgenziaForm" commandName="agency" method="post" role="form">
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
				    		<form:input path="name" class="form-control" id="name" placeholder="Inserisci il nome" maxlength="255" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="url" class="required">Sito web</label>
					    	<form:input path="url" class="form-control" id="url" type="url" placeholder="Inserisci il sito web" maxlength="255" />
				    		<form:errors path="url" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="timezone" class="required">Fuso orario</label>
							<form:select path="timezone" id="timezones" class="form-control"></form:select>
							<form:errors path="timezone" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="language">Lingua</label>
							<form:select path="language" id="languages" class="form-control"></form:select>
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
							<a class="btn btn-default" href="agenzie">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected agency summary -->
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
						<a id="modificaAgenziaButton" class="btn btn-primary" href="modificaAgenzia">Modifica</a>
						<button id="eliminaAgenziaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit agency form -->
			<div id="modificaAgenzia">
				<form:form id="modificaAgenziaForm" commandName="agency" method="post" role="form" action="modificaAgenzia">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${agenziaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name" class="required">Nome</label>
				    		<form:input path="name" class="form-control" id="name" value="${agenziaAttiva.name}" maxlength="255" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="url" class="required">Sito web</label>
				    		<form:input path="url" class="form-control" id="url" type="url" value="${agenziaAttiva.url}" maxlength="255" />
				    		<form:errors path="url" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="timezone" class="required">Fuso orario</label>
							<form:select path="timezone" id="timezonesEdit" class="form-control"></form:select>
							<form:errors path="timezone" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="language">Lingua</label>
							<form:select path="language" id="languagesEdit" class="form-control"></form:select>
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
							<a class="btn btn-default" href="agenzie">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	
	<!-- Alerts -->
	<div id="agency-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id dell'agenzia che hai inserito è già presente.
	</div>
	<div id="delete-agency" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare l'agenzia ${agenziaAttiva.name}?</p>
	    <button id="delete-agency-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
</body>
</html>