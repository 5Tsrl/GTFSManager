<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>GTFS Manager - Tariffe</title>
	<link href="<c:url value='/resources/css/style.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
	<link href="<c:url value='/resources/css/bootstrap-multiselect.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
	<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.0/jquery.validate.min.js"></script>
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script src="<c:url value='/resources/js/bootstrap-multiselect.js' />"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/currencies.js' />"></script>
	<script type="text/javascript">
	// load the navigation bar
	$(function(){
    	$("#navigationBar").load("<c:url value='/resources/html/navbar.html' />", function() {
    		$("#liTariffe").addClass("active");
    	}); 
    });
    
    $(document).ready(function() {
    	// edit fare form, create fare rule form and alerts initially hidden
		$("#modificaTariffa").hide();
		$("#creaRegolaLinea").hide();
		$(".alert").hide();
		
		// showAlertDuplicateFare variable is set to true by FareController if the fare id is already present
		if ("${showAlertDuplicateFare}") {
			$("#fare-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by FareController if the the submitted form to create a fare contains errors
		if (!"${showCreateForm}") {
			$("#creaTariffa").hide();
		} else {
			$("#creaTariffa").show();
		}
		
		// clicking on button to create a route association, the correspondent form is shown
		$("#creaRegolaLineaButton").click(function() {
			$("#creaRegolaLinea").show();
		});
		
		// clicking on "Modifica tariffa" button, "Crea tariffa" button and div with active fare summary should be hidden, while the form to modify the fare should be shown
		$("#modificaTariffaButton").click(function() {
			$("#creaTariffaButton").hide();
			$("#riassuntoTariffa").hide();
			$("#modificaTariffa").show();
		});
		if ("${showEditForm}") {
			$("#creaTariffaButton").hide();
			$("#riassuntoTariffa").hide();
			$("#modificaTariffa").show();
		};
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaTariffaButton").click(function() {
			$("#delete-fare").show();
		});
		$("#delete-fare-button").click(function() {
			window.location.href = "/_5t/eliminaTariffa";
		});
		
		// clicking on a row, the correspondent fare is selected
		$("#listaTariffe").find("tbody").find("tr").click(function() {
			var fareAttributeId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaTariffa?id=" + fareAttributeId;
		});
		
		// check at form submit for creation of a route association that at least one route has been selected
		$("#creaRegolaLinea").find("form").submit(function(event) {
			if ($(this).find("select :selected").length == 0) {
				$("#no-routes-selected").show();
				event.preventDefault();
			}
		});
		
		// fill timezones select using objects array in currencies.js
		var selCurrencies = document.getElementById("currencies");
		for (var i=0; i<currencies.length; i++) {
			var opt = document.createElement('option');
		    opt.innerHTML = currencies[i].name;
		    opt.value = currencies[i].key;
		    if (currencies[i].key=="EUR") {
		    	opt.selected = true;
		    }
		    selCurrencies.appendChild(opt);
		}
		var selCurrenciesEdit = document.getElementById("currenciesEdit");
		for (var i=0; i<currencies.length; i++) {
			var opt = document.createElement('option');
		    opt.innerHTML = currencies[i].name;
		    opt.value = currencies[i].key;
		    if ("${tariffaAttiva.currencyType}" == currencies[i].key) {
		    	opt.selected = true;
		    }
		    selCurrenciesEdit.appendChild(opt);
		}
		
		// multiselect initialization
		$('.multiselect').multiselect({
		       nonSelectedText: 'Nessuna linea selezionata',
		       includeSelectAllOption: true,
		       selectAllText: 'Seleziona tutto',
		       enableCaseInsensitiveFiltering: true,
		       filterBehavior: 'text',
		       filterPlaceholder: 'Cerca'
	     });
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaTariffaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una classe tariffaria." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaTariffaForm").find("#price").popover({ container: 'body', trigger: 'focus', title:"Prezzo", content:"Il prezzo." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaTariffaForm").find("#paymentMethod").popover({ container: 'body', trigger: 'focus', title:"Metodo di pagamento", content:"Il metodo di pagamento indica quando la tariffa deve essere pagata." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaTariffaForm").find("#transfers").popover({ container: 'body', trigger: 'focus', title:"Numero di trasferimenti", content:"Il numero di trasferimenti permessi per questa tariffa." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaTariffaForm").find("#transferDuration").popover({ container: 'body', trigger: 'focus', title:"Durata del trasferimento", content:"La durata del trasferimento indica entro quanto tempo il trasferimento scade. Quando è usato con \"Nessun trasferimento permesso\", questo campo indica per quanto tempo un biglietto è valido per una tariffa in cui non sono permessi trasferimenti. A meno che questo campo non sia usato per indicare la validità di un biglietto, dovrebbe essere lasciato vuoto quando nessun trasferimento è permesso." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaTariffaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una classe tariffaria." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaTariffaForm").find("#price").popover({ container: 'body', trigger: 'focus', title:"Prezzo", content:"Il prezzo." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaTariffaForm").find("#paymentMethod").popover({ container: 'body', trigger: 'focus', title:"Metodo di pagamento", content:"Il metodo di pagamento indica quando la tariffa deve essere pagata." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaTariffaForm").find("#transfers").popover({ container: 'body', trigger: 'focus', title:"Numero di trasferimenti", content:"Il numero di trasferimenti permessi per questa tariffa." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaTariffaForm").find("#transferDuration").popover({ container: 'body', trigger: 'focus', title:"Durata del trasferimento", content:"La durata del trasferimento indica entro quanto tempo il trasferimento scade. Quando è usato con \"Nessun trasferimento permesso\", questo campo indica per quanto tempo un biglietto è valido per una tariffa in cui non sono permessi trasferimenti. A meno che questo campo non sia usato per indicare la validità di un biglietto, dovrebbe essere lasciato vuoto quando nessun trasferimento è permesso." })
			.blur(function () { $(this).popover('hide'); });
		
		// Creation trip form validation
		$("#creaTariffaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				price: {
					required: true,
					number: true,
					min: 0
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				price: {
					required: "Il campo prezzo è obbligatorio",
					number: "Inserire un numero",
					min: "Il prezzo deve essere maggiore di 0"
				}
			},
			highlight: function(label) {
				$(label).closest('.form-group').removeClass('has-success').addClass('has-error');
			},
			success: function(label) {
				$(label).closest('.form-group').removeClass('has-error').addClass('has-success');
			}
		});
		
		// Edit trip form validation
		$("#modificaTariffaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				price: {
					required: true,
					number: true,
					min: 0
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				price: {
					required: "Il campo prezzo è obbligatorio",
					number: "Inserire un numero",
					min: "Il prezzo deve essere maggiore di 0"
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
		$('#listaTariffe').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna tariffa"
	    	}
	    });
		var listaRegoleTable = $('#listaRegole').DataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna linea"
	    	}
	    });
		
		// if no row is selected in route association table, delete button for associations is disabled
		if (listaRegoleTable.rows('.selected').data().length == 0) {
			$('#eliminaRegolaLineaButton').addClass("disabled");
		}
		
		// clicking on a row in route association table, the row is selected
		$("#listaRegole").find("tbody").find("tr").click(function() {
			$(this).toggleClass('selected');
			// if the number of selected rows is greater than 0, "Elimina associazioni" button is active, otherwise it is disabled
			if (listaRegoleTable.rows('.selected').data().length > 0) {
				$('#eliminaRegolaLineaButton').removeClass("disabled");
			} else {
				$('#eliminaRegolaLineaButton').addClass("disabled");
			}
		});
		
		// clicking on "Elimina associazioni" button, the array containing ids to be deleted is filled depending on the selected rows
		$('#eliminaRegolaLineaButton').click(function(event) {
			$("#delete-fare-rule").show();
		});
		$("#delete-fare-rule-button").click(function() {
			var routeSelected = listaRegoleTable.rows('.selected').data().length;
			var url = "/_5t/eliminaRegolaLinea?id=";
			$("#listaRegole").find("tbody").find(".selected").each(function(index) {
				if (index == routeSelected - 1)
					url += $(this).find(".hidden").html();
				else
					url += $(this).find(".hidden").html() + ",";
			});
			window.location.href = url;
	    });
		
		// clicking on "Seleziona tutte le linee" button, all the associations are selected and "Elimina associazioni" button is enabled
		$('#selezionaTutteLeLineeButton').click(function() {
			$("#listaRegole").find("tbody").find("tr").addClass("selected");
			$('#eliminaRegolaLineaButton').removeClass("disabled");
		});
		
		// clicking on "Deseleziona tutte le linee" button, all the associations are deselected and "Elimina associazioni" button is disabled
		$('#deselezionaTutteLeLineeButton').click(function() {
			$("#listaRegole").find("tbody").find("tr").removeClass("selected");
			$('#eliminaRegolaLineaButton').addClass("disabled");
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
		<!-- Div with table containing fare list -->
		<div class="col-lg-6">
			<table id="listaTariffe" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Prezzo</th>
						<th class="hidden"></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="tariffa" items="${listaTariffe}">
						<c:choose>
							<c:when test="${not empty tariffaAttiva}">
								<c:if test="${tariffaAttiva.id == tariffa.id}">
									<tr class="success">
								</c:if>
							</c:when>
							<c:otherwise>
								<tr>
							</c:otherwise>
						</c:choose>
							<td>${tariffa.gtfsId}</td>
							<td>${tariffa.price} ${tariffa.currencyType}</td>
							<td class="hidden">${tariffa.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create fare and selected fare summary -->
		<div class="col-lg-6">
			<a id="creaTariffaButton" class="btn btn-primary" href="/_5t/creaTariffa">Crea una tariffa</a>
			
			<!-- Div with create fare form -->
			<div id="creaTariffa">
				<form:form id="creaTariffaForm" commandName="fareAttribute" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l'id" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="price" class="required">Prezzo</label>
				    		<form:input path="price" class="form-control" id="price" type="number" step="0.01" min="0" />
				    		<form:errors path="price" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="currencyType" class="required">Valuta</label>
							<form:select path="currencyType" id="currencies" class="form-control"></form:select>
							<form:errors path="currencyType" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="paymentMethod" class="required">Metodo di pagamento</label>
							<form:select path="paymentMethod" class="form-control">
								<form:option value="0">A bordo</form:option>
								<form:option value="1" selected="selected">Prima di salire a bordo</form:option>
							</form:select>
							<form:errors path="paymentMethod" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="transfers" class="required">Numero di trasferimenti</label>
							<form:select path="transfers" class="form-control">
								<form:option value="0" selected="selected">Nessun trasferimento permesso</form:option>
								<form:option value="1">1</form:option>
								<form:option value="2">2</form:option>
								<form:option value="">Illimitati</form:option>
							</form:select>
							<form:errors path="transfers" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="transferDuration">Durata del trasferimento (min)</label>
				    		<form:input path="transferDuration" class="form-control" id="transferDuration" type="number" value=" " min="1" />
				    		<form:errors path="transferDuration" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Crea tariffa" />
							<a class="btn btn-default" href="/_5t/tariffe">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
			
			<hr>
			
			<!-- Div with selected fare summary -->
			<c:if test="${not empty tariffaAttiva}">
				<div id="riassuntoTariffa" class="riassunto">
					<div class="col-lg-8">
						<b>Id:</b> ${tariffaAttiva.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Prezzo:</b> ${tariffaAttiva.price} ${tariffaAttiva.currencyType}
					</div>
					<div class="col-lg-8">
						<b>Metodo di pagamento:</b>
						<c:choose>
							<c:when test="${tariffaAttiva.paymentMethod == 0}">A bordo</c:when>
							<c:otherwise>Prima di salire a bordo</c:otherwise>
						</c:choose>
					</div>
					<div class="col-lg-8">
						<b>Numero di trasferimenti:</b>
						<c:choose>
							<c:when test="${tariffaAttiva.transfers == 0}">Nessun trasferimento permesso</c:when>
							<c:when test="${tariffaAttiva.transfers == 1}">1</c:when>
							<c:when test="${tariffaAttiva.transfers == 2}">2</c:when>
							<c:otherwise>Illimitati</c:otherwise>
						</c:choose>
					</div>
					<div class="col-lg-8">
						<b>Durata del trasferimento (min):</b> ${tariffaAttiva.transferDuration}
					</div>
					<div class="col-lg-12">
						<a id="modificaTariffaButton" class="btn btn-primary" href="/_5t/modificaTariffa">Modifica</a>
						<button id="eliminaTariffaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit fare form -->
			<div id="modificaTariffa">
				<form:form id="modificaTariffaForm" commandName="fareAttribute" method="post" role="form" action="/_5t/modificaTariffa">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${tariffaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="price" class="required">Prezzo</label>
				    		<form:input path="price" class="form-control" id="price" type="number" step="0.01" min="0" value="${tariffaAttiva.price}" />
				    		<form:errors path="price" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="currencyType" class="required">Valuta</label>
							<form:select path="currencyType" id="currenciesEdit" class="form-control"></form:select>
							<form:errors path="currencyType" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="paymentMethod" class="required">Metodo di pagamento</label>
							<form:select path="paymentMethod" class="form-control">
								<c:choose>
									<c:when test="${tariffaAttiva.paymentMethod == 0}">
										<form:option value="0" selected="selected">A bordo</form:option>
										<form:option value="1">Prima di salire a bordo</form:option>
									</c:when>
									<c:otherwise>
										<form:option value="0">A bordo</form:option>
										<form:option value="1" selected="selected">Prima di salire a bordo</form:option>
									</c:otherwise>
								</c:choose>
							</form:select>
							<form:errors path="paymentMethod" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="transfers" class="required">Numero di trasferimenti</label>
							<form:select path="transfers" class="form-control">
								<c:choose>
									<c:when test="${tariffaAttiva.transfers == 0}">
										<form:option value="0" selected="selected">Nessun trasferimento permesso</form:option>
										<form:option value="1">1</form:option>
										<form:option value="2">2</form:option>
										<form:option value="">Illimitati</form:option>
									</c:when>
									<c:when test="${tariffaAttiva.transfers == 1}">
										<form:option value="0">Nessun trasferimento permesso</form:option>
										<form:option value="1" selected="selected">1</form:option>
										<form:option value="2">2</form:option>
										<form:option value="">Illimitati</form:option>
									</c:when>
									<c:when test="${tariffaAttiva.transfers == 2}">
										<form:option value="0">Nessun trasferimento permesso</form:option>
										<form:option value="1">1</form:option>
										<form:option value="2" selected="selected">2</form:option>
										<form:option value="">Illimitati</form:option>
									</c:when>
									<c:otherwise>
										<form:option value="0">Nessun trasferimento permesso</form:option>
										<form:option value="1">1</form:option>
										<form:option value="2">2</form:option>
										<form:option value="" selected="selected">Illimitati</form:option>
									</c:otherwise>
								</c:choose>
							</form:select>
							<form:errors path="transfers" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="transferDuration">Durata del trasferimento (min)</label>
				    		<form:input path="transferDuration" class="form-control" id="transferDuration" type="number" value="${tariffaAttiva.transferDuration}" min="1" />
				    		<form:errors path="transferDuration" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<input class="btn btn-success" type="submit" value="Modifica tariffa" />
							<a class="btn btn-default" href="/_5t/tariffe">Annulla</a>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	
	
	<hr>
	
	<div class="row">
		<c:if test="${not empty tariffaAttiva}">
			<!-- div with table containing routes using the selected fare -->
			<div class="col-lg-6">
				<h4>Linee associate alla tariffa ${tariffaAttiva.gtfsId}</h4>
				<table id="listaRegole" class="table sortable">
					<thead>
						<tr>
							<th>Linea</th>
							<th>Nome</th>
							<th class="hidden"></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="regola" items="${listaRegole}">
							<c:if test="${not empty regola.route}">
								<c:choose>
									<c:when test="${not empty regolaLineaAttiva}">
										<c:if test="${regolaLineaAttiva.id == regola.id}">
											<tr class="success">
										</c:if>
									</c:when>
									<c:otherwise>
										<tr>
									</c:otherwise>
								</c:choose>
									<td><a href="/_5t/selezionaLinea?id=${regola.route.id}">${regola.route.shortName}</a></td>
									<td>${regola.route.longName}</td>
									<td class="hidden">${regola.id}</td>
								</tr>
							</c:if>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- Div with button to create a fare rule (association fare-route) and selected rule summary -->
			<div class="col-lg-6">
				<button id="creaRegolaLineaButton" class="btn btn-primary">Associa linee</button>
				
				<!-- Div with create fare rule form -->
				<div id="creaRegolaLinea">
					<form method="post" role="form" action="/_5t/creaRegolaLinea">
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="routeId" class="required">Linee</label>
								<select name="routeId" class="multiselect" multiple="multiple">
									<c:forEach var="linea" items="${listaLinee}">
										<option value="${linea.id}">${linea.shortName}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="row">
							<div class="form-group col-lg-8">
								<input class="btn btn-success" type="submit" value="Associa linee" />
								<a class="btn btn-default" href="/_5t/tariffe">Annulla</a>
							</div>
						</div>
					</form>
				</div>
				
				<hr>
				
				<div>
					<button id="selezionaTutteLeLineeButton" type="button" class="btn btn-default">Seleziona tutte le linee</button>
					<button id="deselezionaTutteLeLineeButton" type="button" class="btn btn-default">Deseleziona tutte le linee</button>
					<button id="eliminaRegolaLineaButton" type="button" class="btn btn-danger">Elimina associazioni</button>
				</div>
			</div>
		</c:if>
	</div>
	
	<!-- Alerts -->
	<div id="fare-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id della tariffa che hai inserito è già presente.
	</div>
	<div id="delete-fare" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare la tariffa ${tariifaAttiva.name}?</p>
	    <button id="delete-fare-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
	<div id="delete-fare-rule" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare le associazioni selezionate?</p>
	    <button id="delete-fare-rule-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
	<div id="no-routes-selected" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <p>Devi selezionare almeno una linea da associare alla tariffa</p>
	</div>
</body>
</html>