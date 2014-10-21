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
	<link href="<c:url value='/resources/images/favicon.ico' />" rel="icon" type="image/x-icon">
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
    		$("#liCalendari").addClass("active");
    	}); 
    });
	
	function validateCreaEccezioneForm() {
		if (document.forms["creaEccezioneForm"]["date"].value < "${calendarioAttivo.startDate}" || document.forms["creaEccezioneForm"]["date"].value > "${calendarioAttivo.endDate}") {
			$("#wrong-exception-date").show();
			return false;
		}
		var d = new Date(document.forms["creaEccezioneForm"]["date"].value);
		var exceptionType = document.forms["creaEccezioneForm"]["exceptionType"].options[document.forms["creaEccezioneForm"]["exceptionType"].selectedIndex].value;
		switch (d.getDay()) {
		case 0:
			if ("${calendarioAttivo.sunday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.sunday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 1:
			if ("${calendarioAttivo.monday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.monday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 2:
			if ("${calendarioAttivo.tuesday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.tuesday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 3:
			if ("${calendarioAttivo.wednesday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.wednesday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 4:
			if ("${calendarioAttivo.thursday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.thursday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 5:
			if ("${calendarioAttivo.friday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.friday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 6:
			if ("${calendarioAttivo.saturday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.saturday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		default:
			break;
		}
		return true;
	}
	
	function validateModificaEccezioneForm() {
		if (document.forms["modificaEccezioneForm"]["date"].value < "${calendarioAttivo.startDate}" || document.forms["modificaEccezioneForm"]["date"].value > "${calendarioAttivo.endDate}") {
			$("#wrong-exception-date").show();
			return false;
		}
		var d = new Date(document.forms["modificaEccezioneForm"]["date"].value);
		var exceptionType = document.forms["modificaEccezioneForm"]["exceptionType"].options[document.forms["modificaEccezioneForm"]["exceptionType"].selectedIndex].value;
		switch (d.getDay()) {
		case 0:
			if ("${calendarioAttivo.sunday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.sunday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 1:
			if ("${calendarioAttivo.monday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.monday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 2:
			if ("${calendarioAttivo.tuesday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.tuesday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 3:
			if ("${calendarioAttivo.wednesday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.wednesday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 4:
			if ("${calendarioAttivo.thursday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.thursday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 5:
			if ("${calendarioAttivo.friday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.friday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		case 6:
			if ("${calendarioAttivo.saturday}" == "true" && exceptionType == 1) {
				$("#service-already-present").show();
				return false;
			} else if ("${calendarioAttivo.saturday}" == "false" && exceptionType == 2) {
				$("#service-already-not-present").show();
				return false;
			}
			break;
		default:
			break;
		}
		return true;
	}
	
	$(document).ready(function() {
		// edit calendar and calendar dates form and alerts initially hidden
		$("#modificaCalendario").hide();
		$("#modificaEccezione").hide();
		$(".alert").hide();
		
		// showAlertDuplicateCalendar variable is set to true by CalendarController if the calendar id is already present
		if ("${showAlertDuplicateCalendar}") {
			$("#calendar-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by CalendarController if the the submitted form to create a trip contains errors
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
		
		// showAlertWrongCalendarDates variable is set to true if start date is after end date
		if ("${showAlertWrongCalendarDates}") {
			$("#wrong-calendar-dates").show();
		}
		
		// showAlertWrongExceptionDate variable is set to true if date of the exception is wrong (not in the corresponding calendar range)
		if ("${showAlertWrongExceptionDate}") {
			$("#wrong-exception-date").show();
		}
		
		// clicking on "Modifica calendario" button, "Crea calendario" button and div with active calendar summary should be hidden, while the form to modify the calendar should be shown
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
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaCalendarioButton").click(function() {
			if ("${calendarioAttivo.trips.size()}" > 0)
				$("#calendar-not-deletable").show();
			else 
				$("#delete-calendar").show();
		});
		$("#delete-calendar-button").click(function() {
				window.location.href = "/_5t/eliminaCalendario";
		});
		$("#eliminaEccezioneButton").click(function() {
			$("#delete-calendar-date").show();
		});
		$("#delete-calendar-date-button").click(function() {
			window.location.href = "/_5t/eliminaEccezione";
		});
		
		// clicking on a row, the correspondent calendar is selected
		$("#listaCalendari").find("tbody").find("tr").click(function() {
			var serviceId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaCalendario?id=" + serviceId;
		});
		
		// clicking on a row, the correspondent calendar date is selected
		$("#listaEccezioni").find("tbody").find("tr").click(function() {
			var calendarDateId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaEccezione?id=" + calendarDateId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaCalendarioForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente un set di date in cui il servizio è disponibile per una o più linee." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCalendarioForm").find("#startDate").popover({ container: 'body', trigger: 'focus', title:"Data inizio", content:"La data di inizio del calendario." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaCalendarioForm").find("#endDate").popover({ container: 'body', trigger: 'focus', title:"Data fine", content:"La data di fine del calendario (questa data è iclusa nell'intervallo)." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaCalendarioForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente un set di date in cui il servizio è disponibile per una o più linee." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCalendarioForm").find("#startDate").popover({ container: 'body', trigger: 'focus', title:"Data inizio", content:"La data di inizio del calendario." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaCalendarioForm").find("#endDate").popover({ container: 'body', trigger: 'focus', title:"Data fine", content:"La data di fine del calendario (questa data è iclusa nell'intervallo)." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#creaEccezioneForm").find("#date").popover({ container: 'body', trigger: 'focus', title:"Data", content:"La data in cui la disponibilità del servizio è diversa dalla norma." })
		.blur(function () { $(this).popover('hide'); });
		$("#creaEccezioneForm").find("#exceptionType").popover({ container: 'body', trigger: 'focus', title:"Data", content:"Indica se il servizio è disponibile nella data specificata." })
		.blur(function () { $(this).popover('hide'); });
		
		$("#modificaEccezioneForm").find("#date").popover({ container: 'body', trigger: 'focus', title:"Data", content:"La data in cui la disponibilità del servizio è diversa dalla norma." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaEccezioneForm").find("#exceptionType").popover({ container: 'body', trigger: 'focus', title:"Data", content:"Indica se il servizio è disponibile nella data specificata." })
		.blur(function () { $(this).popover('hide'); });
		
		// Creation calendar form validation
		$("#creaCalendarioForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				startDate: {
					required: true
				},
				endDate: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				startDate: {
					required: "Il campo data inizio è obbligatorio"
				},
				endDate: {
					required: "Il campo data fine è obbligatorio"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit calendar form validation
		$("#modificaCalendarioForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				startDate: {
					required: true
				},
				endDate: {
					required: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				startDate: {
					required: "Il campo data inizio è obbligatorio"
				},
				endDate: {
					required: "Il campo data fine è obbligatorio"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Creation calendar date form validation
		$("#creaEccezioneForm").validate({
			rules: {
				date: {
					required: true
				},
				exceptionType: {
					required: true
				}
			},
			messages: {
				date: {
					required: "Il campo data è obbligatorio"
				},
				exceptionType: {
					required: "Il campo tipo di eccezione è obbligatorio"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit calendar date form validation
		$("#modificaEccezioneForm").validate({
			rules: {
				date: {
					required: true
				},
				exceptionType: {
					required: true
				}
			},
			messages: {
				date: {
					required: "Il campo data è obbligatorio"
				},
				exceptionType: {
					required: "Il campo tipo di eccezione è obbligatorio"
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
		$('#listaCalendari').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessun calendario"
	    	}
	    });
		$('#listaCorse').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna corsa è associata a questo calendario"
	    	}
	    });
		$('#listaEccezioni').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Data")
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
		<li><a href="/_5t/agenzie">Agenzia: <b>${agenziaAttiva.gtfsId}</b></a></li>
	</ol>
	
	<p>Cliccare su una riga della tabella per selezionare il calendario corrispondente.</p>
	
	<div class="row">
		<!-- Div with table containing calendar list -->
		<div class="col-lg-6">
			<table id="listaCalendari" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
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
							<td>${calendario.gtfsId}</td>
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
		
		<!-- Div with button to create calendar and selected calendar summary -->
		<div class="col-lg-6">
			<a id="creaCalendarioButton" class="btn btn-primary" href="/_5t/creaCalendario">Crea un calendario</a>
			
			<!-- Div with create calendar form -->
			<div id="creaCalendario">
				<form:form id="creaCalendarioForm" commandName="calendar" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l'id" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="startDate" class="required">Data inizio</label>
				    		<form:input path="startDate" class="form-control" id="startDate" type="date" required="required" />
				    		<form:errors path="startDate" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="endDate" class="required">Data fine</label>
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
			
			<!-- Div with selected calendar summary -->
			<c:if test="${not empty calendarioAttivo}">
				<div id="riassuntoCalendario" class="riassunto">
					<% Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo"); %>
					<div class="col-lg-8">
						<b>Id:</b> ${calendarioAttivo.gtfsId}
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
			
			<!-- Div with edit calendar form -->
			<div id="modificaCalendario">
				<form:form id="modificaCalendarioForm" commandName="calendar" method="post" role="form" action="/_5t/modificaCalendario">
					<% Calendar calendar = (Calendar) session.getAttribute("calendarioAttivo"); %>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${calendarioAttivo.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="startDate" class="required">Data inizio</label>
				    		<form:input path="startDate" class="form-control" id="startDate" type="date" required="required" value="${calendarioAttivo.startDate}" />
				    		<form:errors path="startDate" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="endDate" class="required">Data fine</label>
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
			<!-- div with table containing trips using the selected calendar -->
			<div class="col-lg-5">
				<h4>Corse associate al calendario ${calendarioAttivo.gtfsId}</h4>
				<table id="listaCorse" class="table table-striped table-hover sortable">
					<thead>
						<tr>
							<th>Id</th>
							<th>Ora inizio</th>
							<th>Ora fine</th>
							<th>Frequenza (min)</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="corsa" items="${listaCorse}">
							<tr>
								<c:choose>
									<c:when test="${corsa.singleTrip}">
										<td><a href="/_5t/selezionaCorsaSingola?id=${corsa.id}">${corsa.gtfsId}</a></td>
									</c:when>
									<c:otherwise>
										<td><a href="/_5t/selezionaCorsaAFrequenza?id=${corsa.id}">${corsa.gtfsId}</a></td>
									</c:otherwise>
								</c:choose>
								<td>${corsa.startTime}</td>
								<td>${corsa.endTime}</td>
								<td>${corsa.headwaySecs}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- div with table containing calendar dates associated to the selected calendar -->
			<div class="col-lg-4">
				<h4>Eccezioni associate al calendario ${calendarioAttivo.gtfsId}</h4>
				<p>Cliccare su una riga della tabella per selezionare l'eccezione corrispondente.</p>
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
			
			<!-- Div with button to create calendar date and selected calendar date summary -->
			<div class="col-lg-3">
				<a id="creaEccezioneButton" class="btn btn-primary" href="/_5t/creaEccezione">Crea un'eccezione</a>
			
				<!-- Div with create calendar date form -->
				<div id="creaEccezione">
					<form:form id="creaEccezioneForm" commandName="calendarDate" method="post" role="form" action="/_5t/creaEccezione" onsubmit="return validateCreaEccezioneForm()">
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="date" class="required">Data</label>
					    		<form:input path="date" class="form-control" id="date" type="date" required="required" />
					    		<form:errors path="date" cssClass="error"></form:errors>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="exceptionType" class="required">Tipo</label>
					    		<form:select path="exceptionType" class="form-control" required="true">
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
			
				<!-- Div with selected calendar date summary -->
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
				
				<!-- Div with edit calendar date form -->
				<div id="modificaEccezione">
					<form:form id="modificaEccezioneForm" commandName="calendarDate" method="post" role="form" action="/_5t/modificaEccezione" onsubmit="return validateModificaEccezioneForm()">
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="date" class="required">Data</label>
					    		<form:input path="date" class="form-control" id="date" type="date" required="required" value="${eccezioneAttiva.date}" />
					    		<form:errors path="date" cssClass="error"></form:errors>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="exceptionType" class="required">Tipo</label>
					    		<form:select path="exceptionType" class="form-control" required="true">
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
	
	<!-- Alerts -->
	<div id="calendar-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id del calendario che hai inserito è già presente.
	</div>
	<div id="delete-calendar" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare il calendario ${calendarioAttivo.gtfsId}?</p>
	    <button id="delete-calendar-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
	<div id="delete-calendar-date" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare l'eccezione ${eccezioneAttiva.date}?</p>
	    <button id="delete-calendar-date-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
	<div id="wrong-calendar-dates" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>La data di inizio non può essere successiva alla data di fine.</p>
	</div>
	<div id="wrong-exception-date" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>La data dell'eccezione inserita non è compresa tra le date del calendario corrispondente.</p>
	</div>
	<div id="calendar-not-deletable" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>Non puoi eliminare il calendario.<br>Devi prima modificare le corse associate ad esso.</p>
	</div>
	<div id="service-already-present" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p><strong>Attenzione!</strong> L'eccezione inserita è in un giorno in cui il servizio è già attivo.</p>
	</div>
	<div id="service-already-not-present" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p><strong>Attenzione!</strong> L'eccezione inserita è in un giorno in cui il servizio è già non attivo.</p>
	</div>
</body>
</html>