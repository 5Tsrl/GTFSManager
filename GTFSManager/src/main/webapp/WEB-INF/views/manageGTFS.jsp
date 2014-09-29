<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Gestione GTFS</title>
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
	$(function() {
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liGestioneGTFS").addClass("active");
    		
    		// if no agency has been selected, links of the navigation bar are disabled
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
		// create GTFS form and alerts initially hidden
		$("#creaGTFS").hide();
		$(".alert").hide();
		
		$("#creaGTFSButton").click(function() {
			$("#creaGTFS").show();
		});
		
	    var GTFSTable = $('.sortable').DataTable({
	    	paging: false,
	    	"bInfo": false,
	    	"order": [[0, "desc"]],
	    	"aoColumnDefs": [{
	    		'bSortable': false,
                'aTargets': [ -2 ]
	    	}],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Non è ancora stato creato nessun file GTFS"
	    	}
	    });
	    
	    //if no row is selected, button for deleting GTFSs is disabled
		if (GTFSTable.rows('.selected').data().length == 0) {
			$('#eliminaGTFSButton').addClass("disabled");
		}
	 	
		// clicking on a row in the table, the row is selected
		$("#listaGTFS").find("tbody").find("tr").click(function() {
			$(this).toggleClass('selected');
			// if the number of selected rows is greater than 0, "Elimina GTFS" button is active, otherwise it is disabled
			if (GTFSTable.rows('.selected').data().length > 0) {
				$('#eliminaGTFSButton').removeClass("disabled");
			} else {
				$('#eliminaGTFSButton').addClass("disabled");
			}
		});
		
		// clicking on "Elimina associazioni" button, the array containing ids to be deleted is filled depending on the selected rows
		$('#eliminaGTFSButton').click(function(event) {
			$("#delete-gtfs").show();
		});
		$("#delete-gtfs-button").click(function() {
			var GTFSSelected = GTFSTable.rows('.selected').data().length;
			var url = "/_5t/eliminaGTFS?id=";
			$("#listaGTFS").find("tbody").find(".selected").each(function(index) {
				if (index == GTFSSelected - 1)
					url += $(this).find(".hidden").html();
				else
					url += $(this).find(".hidden").html() + ",";
			});
			window.location.href = url;
	    });
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaGTFSForm").find("#publisherName").popover({ container: 'body', trigger: 'focus', title:"Pubblicatore", content:"Il nome completo dell'organizzazione che pubblica il feed." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaGTFSForm").find("#publisherUrl").popover({ container: 'body', trigger: 'focus', title:"Sito web", content:"Il sito web dell'organizzazione che pubblica il feed." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaGTFSForm").find("#language").popover({ container: 'body', trigger: 'focus', title:"Lingua", content:"Il codice IETF BCP 47 della lingua usata in questo feed." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaGTFSForm").find("#startDate").popover({ container: 'body', trigger: 'focus', title:"Data inizio", content:"La data a partire da cui il feed è valido." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaGTFSForm").find("#endDate").popover({ container: 'body', trigger: 'focus', title:"Data fine", content:"La data fino a cui il feed è valido." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaGTFSForm").find("#version").popover({ container: 'body', trigger: 'focus', title:"Versione", content:"La versione del feed." })
			.blur(function () { $(this).popover('hide'); });
		
		// Creation feed form validation
		$("#creaGTFSForm").validate({
			rules: {
				publisherName: {
					required: true
				},
				publisherUrl: {
					required: true
				},
				language: {
					required: true
				}
			},
			messages: {
				publisherName: {
					required: "Il campo nome pubblicatore è obbligatorio"
				},
				publisherUrl: {
					required: "Il campo sito web pubblicatore è obbligatorio"
				},
				language: {
					required: "Il campo lingua pubblicatore è obbligatorio"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			},
			submitHandler: function(form) {
				var startDate = form.elements["startDate"].value;
				var endDate = form.elements["endDate"].value;
				if (startDate != "" && endDate != "" && startDate > endDate) {
					$("#wrong-dates").show();
					return false;
				} else {
					if (startDate == "")
						form.elements["startDate"].value = "1000-01-01";
					if (endDate == "")
						form.elements["endDate"].value = "1000-01-01";
					$("#progressbarModal").modal("show");
					form.submit();
				}
			}
		});
	});
    </script>
</head>
<body>
	<!-- Navigation bar -->
	<nav id="navigationBar" class="navbar navbar-default" role="navigation"></nav>
	
	<ol class="breadcrumb">
		<li class="active">Gestione GTFS</li>
	</ol>
	
	<div class="col-md-8">
		<table id="listaGTFS" class="table sortable">
			<thead>
				<tr>
					<th>GTFS</th>
					<th>Versione</th>
					<th>Da</th>
					<th>A</th>
					<th>Descrizione</th>
					<th class="hidden"></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="gtfs" items="${listaGTFS}">
					<tr>
						<td><a href="/_5t/scaricaGTFS?id=${gtfs.id}">${gtfs.name}</a></td>
						<td>${gtfs.version}</td>
						<td><fmt:formatDate type="date" dateStyle="short" timeStyle="short" value="${gtfs.startDate}" /></td>
						<td><fmt:formatDate type="date" dateStyle="short" timeStyle="short" value="${gtfs.endDate}" /></td>
						<td>${gtfs.description}</td>
						<td class="hidden">${gtfs.id}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	<div class="col-md-4">
		<div class="row">
			<button id="creaGTFSButton" class="btn btn-primary">Crea GTFS</button>
			<button id="eliminaGTFSButton" type="button" class="btn btn-danger">Elimina GTFS</button>
		</div>
		
		<div id="creaGTFS">
			<form:form id="creaGTFSForm" commandName="feedInfo" method="post" role="form" action="/_5t/creaGTFS">
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="publisherName" class="required">Pubblicato da</label>
			    		<form:input path="publisherName" class="form-control" id="publisherName" placeholder="Inserire il nome del pubblicatore" required="true" maxlength="50" />
			    		<form:errors path="publisherName" cssClass="error"></form:errors>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="publisherUrl" class="required">Sito web</label>
			    		<form:input path="publisherUrl" class="form-control" id="publisherUrl" placeholder="Inserire l'url del pubblicatore" required="true" maxlength="255" />
			    		<form:errors path="publisherUrl" cssClass="error"></form:errors>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="language" class="required">Lingua</label>
			    		<form:input path="language" class="form-control" id="language" placeholder="Inserire la lingua" required="true" maxlength="20" />
			    		<form:errors path="language" cssClass="error"></form:errors>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="startDate">Data inizio</label>
			    		<form:input path="startDate" class="form-control" id="startDate" type="date" />
			    		<form:errors path="startDate" cssClass="error"></form:errors>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="endDate">Data fine</label>
			    		<form:input path="endDate" class="form-control" id="endDate" type="date" />
			    		<form:errors path="endDate" cssClass="error"></form:errors>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="name">Nome</label>
						<jsp:useBean id="now" class="java.util.Date" />
						<fmt:formatDate pattern="yyyy-MM-dd HH.mm.ss" value="${now}" var="formattedNow" />
			    		<input class="form-control" id="name" value="${formattedNow}" disabled="true" />
			    		<form:hidden path="name" value="${formattedNow}" />
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="version">Versione</label>
			    		<form:input path="version" class="form-control" id="version" placeholder="Inserire la versione del feed" maxlength="50" />
			    		<form:errors path="version" cssClass="error"></form:errors>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<label for="description">Descrizione</label>
			    		<form:textarea path="description" class="form-control" id="description" maxlength="255" rows="2" />
			    		<form:errors path="description" cssClass="error"></form:errors>
					</div>
				</div>
				<div class="row">
					<div class="form-group col-lg-8">
						<input class="btn btn-success" type="submit" value="Crea GTFS" />
						<a class="btn btn-default" href="/_5t/GTFS">Annulla</a>
					</div>
				</div>
			</form:form>
		</div>
							
		<div class="row">
			<div id="progressbarModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="progressbarModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-md">
		   			<div class="modal-content">
						<div class="modal-header">
							<h3 id="progressbarModalLabel">Creazione GTFS in corso</h3>
						</div>
						<div class="modal-body">
							<div class="progress progress-striped active">
								<div class="progress-bar" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Alerts -->
	<div id="wrong-dates" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>La data di inizio non può essere successiva alla data di fine.</p>
	</div>
	<div id="delete-gtfs" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare i GTFS selezionati?</p>
	    <button id="delete-gtfs-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
</body>
</html>