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
	<link href="<c:url value='/resources/css/bootstrap-multiselect.css' />" type="text/css" rel="stylesheet">
	<link rel="stylesheet" href="//cdn.datatables.net/1.10.0/css/jquery.dataTables.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="//cdn.datatables.net/1.10.0/js/jquery.dataTables.js"></script>
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
		// form per modificare una tariffa inizialmente nascosto
		$("#modificaTariffa").hide();
		$("#creaRegolaLinea").hide();
		
		// la variabile showForm è settata a true da TripController se il form sottomesso per la creazione di una tariffa contiene degli errori
		if (!"${showCreateForm}") {
			$("#creaTariffa").hide();
		} else {
			$("#creaTariffa").show();
		}
		
		// quando clicco sul pulsante per creare un'associazione con una linea, il rispettivo form viene mostrato
		$("#creaRegolaLineaButton").click(function() {
			$("#creaRegolaLinea").show();
		});
		
		// cliccando sul pulsante "Modifica tariffa", il pulsante "Crea tariffa" e il div con il riassunto della tariffa attiva devono essere nascosti, mentre il form per modificare la tariffa deve essere visualizzato
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
		
		// cliccando sul pulsante "Elimina", viene mostrata una finestra di dialogo che chiede la conferma dell'eliminazione
		$("#eliminaTariffaButton").click(function() {
			if (confirm("Vuoi veramente eliminare la tariffa ${tariffaAttiva.name}?"))
				window.location.href = "/_5t/eliminaTariffa";
		});
		
		// cliccando su una riga, la tariffa corrispondente viene selezionata
		$("#listaTariffe").find("tbody").find("tr").click(function() {
			var fareAttributeId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaTariffa?id=" + fareAttributeId;
		});
		
		// controllo al submit del form per la creazione di un'associazione con le linee che ne sia stata selezionata almeno una
		$("#creaRegolaLinea").find("form").submit(function(event) {
			if ($(this).find("select :selected").length == 0) {
				alert("Devi selezionare almeno una linea da associare alla tariffa");
				event.preventDefault();
			}
		});
		
		// riempe il select delle currencies usando l'array di oggetti in currencies.js
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
		
		// inizializzazione multiselect
		$('.multiselect').multiselect({
		       nonSelectedText: 'Nessuna linea selezionata',
		       includeSelectAllOption: true,
		       selectAllText: 'Seleziona tutto',
		       enableCaseInsensitiveFiltering: true,
		       filterBehavior: 'text',
		       filterPlaceholder: 'Cerca'
	     });
		
		// inizializzazione tabella affinchè le colonne possano essere ordinabili
		$('#listaTariffe').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna tariffa"
	    	}
	    });
		var listaRegoleTable = $('#listaRegole').DataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// l'ordinamento di default è sulla prima colonna ("Nome")
	    	"order": [[0, "asc"]],
	    	"language": {
	    		"search": "Cerca:",
	    		"zeroRecords": "Nessuna linea"
	    	}
	    });
		
		// se non c'è nessuna riga selezionata nella tabella delle associazioni con le linee, il pulsante per eliminare le associazioni è disabilitato
		if (listaRegoleTable.rows('.selected').data().length == 0) {
			$('#eliminaRegolaLineaButton').addClass("disabled");
		}
		
		// se clicco su una riga nella tabella delle associazioni con le linee, la riga viene selezionata
		$("#listaRegole").find("tbody").find("tr").click(function() {
			$(this).toggleClass('selected');
			// se il numero di righe selezionate è maggiore di zero il pulsante "Elimina associazioni" è attivo, atrimenti è disabilitato
			if (listaRegoleTable.rows('.selected').data().length > 0) {
				$('#eliminaRegolaLineaButton').removeClass("disabled");
			} else {
				$('#eliminaRegolaLineaButton').addClass("disabled");
			}
		});
		
		// quando clicco sul pulsante "Elimina associazioni", riempio l'array con gli id da eliminare a seconda delle righe selezionate
		$('#eliminaRegolaLineaButton').click(function(event) {
			var routeSelected = listaRegoleTable.rows('.selected').data().length;
			if (routeSelected == 0) {
				alert("Non hai selezionato nessuna linea");
				event.preventDefault();
			} else {
				if (confirm("Vuoi veramente eliminare le associazioni selezionate?")) {
					var url = "/_5t/eliminaRegolaLinea?id=";
					$("#listaRegole").find("tbody").find(".selected").each(function(index) {
						if (index == routeSelected - 1)
							url += $(this).find(".hidden").html();
						else
							url += $(this).find(".hidden").html() + ",";
					});
					window.location.href = url;
				}
			}
	    });
		
		// quando clicco sul pulsante "Seleziona tutte le linee", seleziono tutte le associazioni e abilito il pulsante "Elimina associazioni"
		$('#selezionaTutteLeLineeButton').click(function() {
			$("#listaRegole").find("tbody").find("tr").addClass("selected");
			$('#eliminaRegolaLineaButton').removeClass("disabled");
		});
		
		// quando clicco sul pulsante "Deseleziona tutte le linee", deseleziono tutte le associazioni e disabilito il pulsante "Elimina associazioni"
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
		<!-- Div con tabella contenente elenco tariffe -->
		<div class="col-lg-6">
			<table id="listaTariffe" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Nome</th>
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
							<td>${tariffa.name}</td>
							<td>${tariffa.price} ${tariffa.currencyType}</td>
							<td class="hidden">${tariffa.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div con pulsante per creare una tariffa e riassunto dati tariffa selezionata -->
		<div class="col-lg-6">
			<a id="creaTariffaButton" class="btn btn-primary" href="/_5t/creaTariffa">Crea una tariffa</a>
			
			<!-- Div con form per creazione tariffa -->
			<div id="creaTariffa">
				<form:form commandName="fareAttribute" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name">Nome</label>
				    		<form:input path="name" class="form-control" id="name" placeholder="Inserisci il nome" maxlength="50" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="price">Prezzo</label>
				    		<form:input path="price" class="form-control" id="price" type="number" step="0.01" min="0" />
				    		<form:errors path="price" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="currencyType">Valuta</label>
							<form:select path="currencyType" id="currencies"></form:select>
							<form:errors path="currencyType" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="paymentMethod">Metodo di pagamento</label>
							<form:select path="paymentMethod">
								<form:option value="0">A bordo</form:option>
								<form:option value="1" selected="selected">Prima di salire a bordo</form:option>
							</form:select>
							<form:errors path="paymentMethod" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="transfers">Numero di trasferimenti</label>
							<form:select path="transfers">
								<form:option value="0">Nessun trasferimento permesso</form:option>
								<form:option value="1" selected="selected">1</form:option>
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
			
			<!-- Div con riassunto tariffa selezionata -->
			<c:if test="${not empty tariffaAttiva}">
				<div id="riassuntoTariffa" class="riassunto">
					<div class="col-lg-8">
						<b>Nome:</b> ${tariffaAttiva.name}
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
			
			<!-- Div con form per modifica tariffa -->
			<div id="modificaTariffa">
				<form:form commandName="fareAttribute" method="post" role="form" action="/_5t/modificaTariffa">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="name">Nome</label>
				    		<form:input path="name" class="form-control" id="name" value="${tariffaAttiva.name}" maxlength="50" />
				    		<form:errors path="name" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="price">Prezzo</label>
				    		<form:input path="price" class="form-control" id="price" type="number" step="0.01" min="0" value="${tariffaAttiva.price}" />
				    		<form:errors path="price" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="currencyType">Valuta</label>
							<form:select path="currencyType" id="currenciesEdit"></form:select>
							<form:errors path="currencyType" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="paymentMethod">Metodo di pagamento</label>
							<form:select path="paymentMethod">
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
							<label for="transfers">Numero di trasferimenti</label>
							<form:select path="transfers">
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
			<!-- div con tabella contenente le linee che utilizzano la tariffa selezionata -->
			<div class="col-lg-6">
				<h4>Linee associate alla tariffa ${tariffaAttiva.name}</h4>
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
			
			<!-- Div con pulsante per creare una regola (associazione tariffa-linea) e riassunto dati regola selezionata -->
			<div class="col-lg-6">
<!-- 				<a id="creaRegolaLineaButton" class="btn btn-primary" href="/_5t/creaRegolaLinea">Associa linee</a> -->
				<button id="creaRegolaLineaButton" class="btn btn-primary">Associa linee</button>
				
				<!-- Div con form per creazione tariffa -->
				<div id="creaRegolaLinea">
					<form method="post" role="form" action="/_5t/creaRegolaLinea">
						<div class="row">
							<div class="form-group col-lg-8">
								<label for="routeId">Calendario</label>
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
</body>
</html>