<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="it.torino._5t.entity.Trip" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Trasferimenti</title>
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
    		$("#liTrasferimenti").addClass("active");
    	});
    });
	
	function validateCreaTrasferimentoForm() {
		if (document.forms["creaTrasferimentoForm"]["fromStopId"].options[document.forms["creaTrasferimentoForm"]["fromStopId"].selectedIndex].value === document.forms["creaTrasferimentoForm"]["toStopId"].options[document.forms["creaTrasferimentoForm"]["toStopId"].selectedIndex].value) {
			$("#equal-stop").show();
			return false;
		}
		return true;
	}
    
	function validateModificaTrasferimentoForm() {
		if (document.forms["modificaTrasferimentoForm"]["fromStopId"].options[document.forms["modificaTrasferimentoForm"]["fromStopId"].selectedIndex].value === document.forms["modificaTrasferimentoForm"]["toStopId"].options[document.forms["modificaTrasferimentoForm"]["toStopId"].selectedIndex].value) {
			$("#equal-stop").show();
			return false;
		}
		return true;
	}
    
    $(document).ready(function() {
		// edit transfer form and alerts initially hidden
		$("#modificaTrasferimento").hide();
		$(".alert").hide();
		
		// showAlertDuplicateTransfer variable is set to true by TransferController if the transfer id is already present
		if ("${showAlertDuplicateTransfer}") {
			$("#transfer-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by TransferController if the the submitted form to create a transfer contains errors
		if (!"${showCreateForm}") {
			$("#creaTrasferimento").hide();
		} else {
			$("#creaTrasferimento").show();
		}
		
		// clicking on "Modifica trasferimento" button, "Crea trasferimento" button and div with active transfer summary should be hidden, while the form to modify the transfer should be shown
		$("#modificaTrasferimentoButton").click(function() {
			$("#creaTrasferimentoaButton").hide();
			$("#riassuntoTrasferimento").hide();
			$("#modificaTrasferimento").show();
		});
		if ("${showEditForm}") {
			$("#creaTrasferimentoButton").hide();
			$("#riassuntoTrasferimento").hide();
			$("#modificaTrasferimento").show();
		};
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaTrasferimentoButton").click(function() {
			$("#delete-transfer").show();
		});
		$("#delete-transfer-button").click(function() {
			window.location.href = "eliminaTrasferimento";
		});
		
		// clicking on a row, the correspondent transfer is selected
		$("#listaTrasferimenti").find("tbody").find("tr").click(function() {
			var transferId = $(this).find(".hidden").html();
			window.location.href = "selezionaTrasferimento?id=" + transferId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		$("#creaTrasferimentoForm").find("#transferType").on("change", function() {
			if ($(this).val() === "2") {
				$("#minTransferTimeDiv").show();
			} else {
				$("#minTransferTimeDiv").hide();
				$("#minTransferTimeDiv").find("#minTransferTime").val("");
			}
		});
		if ($("#modificaTrasferimentoForm").find("#transferType").val() === "2") {
			$("#minTransferTimeDivMod").show();
		}  else {
			$("#minTransferTimeDivMod").hide();
		}
		$("#modificaTrasferimentoForm").find("#transferType").on("change", function() {
			if ($(this).val() === "2") {
				$("#minTransferTimeDivMod").show();
			} else {
				$("#minTransferTimeDivMod").hide();
				$("#minTransferTimeDivMod").find("#minTransferTime").val("");
			}
		});
		
		// Popover
		$("#creaTrasferimentoForm").find("#fromStopId").popover({ container: 'body', trigger: 'focus', title:"Dalla fermata", content:"La fermata o stazione da cui comincia una connessione tra linee." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaTrasferimentoForm").find("#toStopId").popover({ container: 'body', trigger: 'focus', title:"Alla fermata", content:"La fermata o stazione in cui finisce una connessione tra linee." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaTrasferimentoForm").find("#transferType").popover({ container: 'body', trigger: 'focus', title:"Tipo di trasferimento", content:"Il tipo di connessione per la coppia di fermate specificate." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaTrasferimentoForm").find("#minTransferTime").popover({ container: 'body', trigger: 'focus', title:"Tempo minimo per il trasferimento", content:"Il tempo che deve essere disponibile in un itinerario per permettere un trasferimento tra linee in queste fermate, quando la connessione tra linee richiede del tempo tra arrivo e partenza. Il tempo specificato deve essere sufficiente per permettere a un passeggero di spostarsi tra le due fermate." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaTrasferimentoForm").find("#fromStopId").popover({ container: 'body', trigger: 'focus', title:"Dalla fermata", content:"La fermata o stazione da cui comincia una connessione tra linee." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaTrasferimentoForm").find("#toStopId").popover({ container: 'body', trigger: 'focus', title:"Alla fermata", content:"La fermata o stazione in cui finisce una connessione tra linee." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaTrasferimentoForm").find("#transferType").popover({ container: 'body', trigger: 'focus', title:"Tipo di trasferimento", content:"Il tipo di connessione per la coppia di fermate specificate." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaTrasferimentoForm").find("#minTransferTime").popover({ container: 'body', trigger: 'focus', title:"Tempo minimo per il trasferimento", content:"Il tempo che deve essere disponibile in un itinerario per permettere un trasferimento tra linee in queste fermate, quando la connessione tra linee richiede del tempo tra arrivo e partenza. Il tempo specificato deve essere sufficiente per permettere a un passeggero di spostarsi tra le due fermate." })
			.blur(function () { $(this).popover('hide'); });
			
		// Creation transfer form validation
		$("#creaTrasferimentoForm").validate({
			rules: {
				fromStopId: {
					required: true
				},
				toStopId: {
					required: true
				},
				transferType: {
					required: true
				},
				minTransferTime: {
					required: function(element) {
						return document.forms["creaTrasferimentoForm"]["transferType"].options[document.forms["creaTrasferimentoForm"]["transferType"].selectedIndex].value === "2";
					},
					number: true,
					min: 0
				}
			},
			messages: {
				fromStopId: {
					required: "Il campo fermata di partenza è obbligatorio"
				},
				toStopId: {
					required: "Il campo fermata di arrivo è obbligatorio"
				},
				transferType: {
					required: "Il campo tipo di trasferimento è obbligatorio"
				},
				minTransferTime: {
					required: "Il campo tempo minimo per il trasferimento è obbligatorio",
					number: "Il campo tempo minimo per il trasferimento deve essere un numero",
					min: "Il campo tempo minimo per il trasferimento deve essere maggiore di 0"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit transfer form validation
		$("#modificaTrasferimentoForm").validate({
			rules: {
				fromStopId: {
					required: true
				},
				toStopId: {
					required: true
				},
				transferType: {
					required: true
				},
				minTransferTime: {
					required: function(element) {
						return document.forms["modificaTrasferimentoForm"]["transferType"].options[document.forms["modificaTrasferimentoForm"]["transferType"].selectedIndex].value === "2";
					}
				}
			},
			messages: {
				fromStopId: {
					required: "Il campo fermata di partenza è obbligatorio"
				},
				toStopId: {
					required: "Il campo fermata di arrivo è obbligatorio"
				},
				transferType: {
					required: "Il campo tipo di trasferimento è obbligatorio"
				},
				minTransferTime: {
					required: "Il campo tempo minimo per il trasferimento è obbligatorio"
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
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessun trasferimento"
	    	}
	    });
	});
	</script>
</head>
<body>
	<!-- Navigation bar -->
	<nav id="navigationBar" class="navbar navbar-default" role="navigation"></nav>
	
	<ol class="breadcrumb">
		<li class="active">Trasferimenti</li>
	</ol>
	
	<p>Cliccare su una riga della tabella per selezionare il trasferimento corrispondente.</p>
	
	<div class="row">
		<!-- Div with table containing transfer list -->
		<div class="col-lg-8">
			<table id="listaTrasferimenti" class="table table-stransfered table-hover sortable">
				<thead>
					<tr>
						<th>Dalla fermata</th>
						<th>Alla fermata</th>
						<th>Tipo di trasferimento</th>
						<th>Tempo minimo per il trasferimento</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="trasferimento" items="${listaTrasferimenti}">
						<c:choose>
							<c:when test="${not empty trasferimentoAttivo}">
								<c:if test="${trasferimentoAttivo.id == trasferimento.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${trasferimento.fromStop.gtfsId}</td>
							<td>${trasferimento.toStop.gtfsId}</td>
							<td>
								<c:choose>
									<c:when test="${trasferimento.transferType == 0}">Raccomandato</c:when>
									<c:when test="${trasferimento.transferType == 1}">A tempo</c:when>
									<c:when test="${trasferimento.transferType == 2}">Con tempo minimo</c:when>
									<c:otherwise>Non possibile</c:otherwise>
								</c:choose>
							</td>
							<td>${trasferimento.minTransferTime}</td>
							<td class="hidden">${trasferimento.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create transfer and selected transfer summary -->
		<div class="col-lg-4">
			<a id="creaTrasferimentoButton" class="btn btn-primary" href="creaTrasferimento">Crea un trasferimento</a>
			
			<!-- Div with create transfer form -->
			<div id="creaTrasferimento">
				<form:form id="creaTrasferimentoForm" commandName="transfer" method="post" role="form" onsubmit="return validateCreaTrasferimentoForm()">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="fromStopId" class="required">Dalla fermata</label>
							<select name="fromStopId" class="form-control" required>
								<option value="">Seleziona la fermata di partenza</option>
								<c:forEach var="fermata" items="${listaFermate}">
									<option value="${fermata.id}">${fermata.gtfsId}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="toStopId" class="required">Alla fermata</label>
							<select name="toStopId" class="form-control" required>
								<option value="">Seleziona la fermata di arrivo</option>
								<c:forEach var="fermata" items="${listaFermate}">
									<option value="${fermata.id}">${fermata.gtfsId}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="transferType">Tipo di trasferimento</label>
							<form:select path="transferType" class="form-control">
								<form:option value="0" selected="true">Raccomandato</form:option>
								<form:option value="1">A tempo</form:option>
								<form:option value="2">Con tempo minimo</form:option>
								<form:option value="3">Non possibile</form:option>
							</form:select>
							<form:errors path="transferType" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row" id="minTransferTimeDiv" style="display:none;">
						<div class="form-group col-lg-8">
							<label for="minTransferTime">Tempo minimo per il trasferimento</label>
				    		<form:input path="minTransferTime" class="form-control" id="minTransferTime" type="number" min="0" placeholder="Inserisci il tempo minimo per il trasferimento" />
				    		<form:errors path="minTransferTime" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea trasferimento" />
							<a class="btn btn-default" href="trasferimenti">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected transfer summary -->
			<c:if test="${not empty trasferimentoAttivo}">
				<div id="riassuntoTrasferimento" class="riassunto">
					<div class="col-lg-8">
						<b>Dalla fermata:</b> ${trasferimentoAttivo.fromStop.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Alla fermata:</b> ${trasferimentoAttivo.toStop.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Tipo di trasferimento:</b>
						<c:choose>
							<c:when test="${trasferimentoAttivo.transferType == 0}">Punto di trasferimento raccomandato.</c:when>
							<c:when test="${trasferimentoAttivo.transferType == 1}">Punto di trasferimento a tempo tra le linee. E' previsto che il veicolo in partenza attenda quello in arrivo, con un tempo sufficiente per i passeggeri per il trasferimento tra le linee specificate.</c:when>
							<c:when test="${trasferimentoAttivo.transferType == 2}">Trasferimento con tempo minimo tra arrivo e partenza per assicurare una connessione. Il tempo richiesto per il trasferimento è specificato in "Tempo minimo per il trasferimento".</c:when>
							<c:otherwise>Trasferimenti non possibili tra le linee specificate.</c:otherwise>
						</c:choose>
					</div>
					<div class="col-lg-8">
						<b>Tempo minimo per il trasferimento:</b> ${trasferimentoAttivo.minTransferTime}
					</div>
					<div class="col-lg-12">
						<a id="modificaTrasferimentoButton" class="btn btn-primary" href="modificaTrasferimento">Modifica</a>
						<button id="eliminaTrasferimentoButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit transfer form -->
			<div id="modificaTrasferimento">
				<form:form id="modificaTrasferimentoForm" commandName="transfer" method="post" role="form" action="modificaTrasferimento" onsubmit="return validateModificaTrasferimentoForm()">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="fromStopId" class="required">Dalla fermata</label>
							<select name="fromStopId" class="form-control" required>
								<option value="">Seleziona la fermata di partenza</option>
								<c:forEach var="fermata" items="${listaFermate}">
									<c:choose>
										<c:when test="${trasferimentoAttivo.fromStop.id == fermata.id}">
											<option value="${fermata.id}" selected>${fermata.gtfsId}</option>
										</c:when>
										<c:otherwise>
											<option value="${fermata.id}">${fermata.gtfsId}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="toStopId" class="required">Alla fermata</label>
							<select name="toStopId" class="form-control" required>
								<option value="">Seleziona la fermata di arrivo</option>
								<c:forEach var="fermata" items="${listaFermate}">
									<c:choose>
										<c:when test="${trasferimentoAttivo.toStop.id == fermata.id}">
											<option value="${fermata.id}" selected>${fermata.gtfsId}</option>
										</c:when>
										<c:otherwise>
											<option value="${fermata.id}">${fermata.gtfsId}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="transferType" class="required">Tipo di trasferimento</label>
							<form:select path="transferType" class="form-control">
								<c:choose>
									<c:when test="${trasferimentoAttivo.transferType == 0}">
										<form:option value="0" selected="true">Raccomandato</form:option>
										<form:option value="1">A tempo</form:option>
										<form:option value="2">Con tempo minimo</form:option>
										<form:option value="3">Non possibile</form:option>
									</c:when>
									<c:when test="${trasferimentoAttivo.transferType == 1}">
										<form:option value="0">Raccomandato</form:option>
										<form:option value="1" selected="true">A tempo</form:option>
										<form:option value="2">Con tempo minimo</form:option>
										<form:option value="3">Non possibile</form:option>
									</c:when>
									<c:when test="${trasferimentoAttivo.transferType == 2}">
										<form:option value="0">Raccomandato</form:option>
										<form:option value="1">A tempo</form:option>
										<form:option value="2" selected="true">Con tempo minimo</form:option>
										<form:option value="3">Non possibile</form:option>
									</c:when>
									<c:otherwise>
										<form:option value="0">Raccomandato</form:option>
										<form:option value="1">A tempo</form:option>
										<form:option value="2">Con tempo minimo</form:option>
										<form:option value="3" selected="true">Non possibile</form:option>
									</c:otherwise>
								</c:choose>
							</form:select>
							<form:errors path="transferType" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row" id="minTransferTimeDivMod">
						<div class="form-group col-lg-8">
							<label for="minTransferTime" class="required">Tempo minimo per il trasferimento</label>
				    		<form:input path="minTransferTime" class="form-control" id="minTransferTime" type="number" min="0" value="${trasferimentoAttivo.minTransferTime}" />
				    		<form:errors path="minTransferTime" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica trasferimento" />
							<a class="btn btn-default" href="trasferimenti">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	
	<!-- Alerts -->
	<div id="delete-transfer" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare il trasferimento da ${trasferimentoAttivo.fromStop.name} a ${trasferimentoAttivo.toStop.name}?</p>
	    <button id="delete-transfer-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
	<div id="equal-stop" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> Selezionare due fermate diverse.
	</div>
</body>
</html>