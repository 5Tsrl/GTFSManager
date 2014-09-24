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
    		$("#liLinee").addClass("active");
    	});
    });
	
	$(document).ready(function() {
		// edit route form and alerts initially hidden
		$("#modificaLinea").hide();
		$(".alert").hide();
		
		// showAlertDuplicateRoute variable is set to true by RouteController if the route id is already present
		if ("${showAlertDuplicateRoute}") {
			$("#route-already-inserted").show();
		}
		
		// showCreateForm variable is set to true by RouteController if the the submitted form to create a route contains errors
		if (!"${showCreateForm}") {
			$("#creaLinea").hide();
		} else {
			$("#creaLinea").show();
		}
		
		// clicking on "Modifica linea" button, "Crea linea" button and div with active route summary should be hidden, while the form to modify the route should be shown
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
		
		// clicking on "Elimina" button, a dialog window with the delete confirmation is shown
		$("#eliminaLineaButton").click(function() {
			$("#delete-route").show();
		});
		$("#delete-route-button").click(function() {
			window.location.href = "/_5t/eliminaLinea";
		});
		
		// clicking on a row, the correspondent route is selected
		$("#listaLinee").find("tbody").find("tr").click(function() {
			var routeId = $(this).find(".hidden").html();
			window.location.href = "/_5t/selezionaLinea?id=" + routeId;
		});
		
		// when alert are closed, they are hidden
		$('.close').click(function() {
			$(this).parent().hide();
		});
		$('.annulla').click(function() {
			$(this).parent().hide();
		});
		
		// Popover
		$("#creaLineaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaLineaForm").find("#shortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome abbreviato della linea. Solitamente è un identificatore breve, astratto, come \"32\", \"100X\" o \"Verde\", che i passeggeri usano per identificare la linea, ma che non dà nessuna informazione su quali luoghi la linea serve." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaLineaForm").find("#longName").popover({ container: 'body', trigger: 'focus', title:"Nome completo", content:"Il nome completo della linea. Questo nome è di solito più descrittivo di quello abbreviato e spesso include la destinazione della linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaLineaForm").find("#description").popover({ container: 'body', trigger: 'focus', title:"Descrizione", content:"La descrizione della linea. Dovrebbero essere inserite informazioni utili, non duplicando semplicemente il nome della linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaLineaForm").find("#type").popover({ container: 'body', trigger: 'focus', title:"Modalità di trasporto", content:"La modalità di trasporto usata sulla linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaLineaForm").find("#url").popover({ container: 'body', trigger: 'focus', title:"Sito web", content:"La pagina web di una specifica linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaLineaForm").find("#color").popover({ container: 'body', trigger: 'focus', title:"Colore linea", content:"Il colore della linea (quello di default è bianco)." })
			.blur(function () { $(this).popover('hide'); });
		$("#creaLineaForm").find("#textColor").popover({ container: 'body', trigger: 'focus', title:"Colore testo", content:"Il colore del testo avente come sfondo il colore della linea (quello di default è nero)." })
			.blur(function () { $(this).popover('hide'); });
		
		$("#modificaLineaForm").find("#gtfsId").popover({ container: 'body', trigger: 'focus', title:"Id", content:"L'id identifica univocamente una linea." })
		.blur(function () { $(this).popover('hide'); });
		$("#modificaLineaForm").find("#shortName").popover({ container: 'body', trigger: 'focus', title:"Nome abbreviato", content:"Il nome abbreviato della linea. Solitamente è un identificatore breve, astratto, come \"32\", \"100X\" o \"Verde\", che i passeggeri usano per identificare la linea, ma che non dà nessuna informazione su quali luoghi la linea serve." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaLineaForm").find("#longName").popover({ container: 'body', trigger: 'focus', title:"Nome completo", content:"Il nome completo della linea. Questo nome è di solito più descrittivo di quello abbreviato e spesso include la destinazione della linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaLineaForm").find("#description").popover({ container: 'body', trigger: 'focus', title:"Descrizione", content:"La descrizione della linea. Dovrebbero essere inserite informazioni utili, non duplicando semplicemente il nome della linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaLineaForm").find("#type").popover({ container: 'body', trigger: 'focus', title:"Modalità di trasporto", content:"La modalità di trasporto usata sulla linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaLineaForm").find("#url").popover({ container: 'body', trigger: 'focus', title:"Sito web", content:"La pagina web di una specifica linea." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaLineaForm").find("#color").popover({ container: 'body', trigger: 'focus', title:"Colore linea", content:"Il colore della linea (quello di default è bianco)." })
			.blur(function () { $(this).popover('hide'); });
		$("#modificaLineaForm").find("#textColor").popover({ container: 'body', trigger: 'focus', title:"Colore testo", content:"Il colore del testo avente come sfondo il colore della linea (quello di default è nero)." })
			.blur(function () { $(this).popover('hide'); });
		
		// Creation route form validation
		$("#creaLineaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				shortName: {
					required: true
				},
				longName: {
					required: true
				},
				url: {
					url: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				shortName: {
					required: "Il campo nome abbreviato è obbligatorio"
				},
				longName: {
					required: "Il campo nome completo è obbligatorio"
				},
				url: {
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
		
		// Edit route form validation
		$("#modificaLineaForm").validate({
			rules: {
				gtfsId: {
					required: true
				},
				shortName: {
					required: true
				},
				longName: {
					required: true
				},
				url: {
					url: true
				}
			},
			messages: {
				gtfsId: {
					required: "Il campo id è obbligatorio"
				},
				shortName: {
					required: "Il campo nome abbreviato è obbligatorio"
				},
				longName: {
					required: "Il campo nome completo è obbligatorio"
				},
				url: {
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
		
		// table initialization to have sortable columns
		$('.sortable').dataTable({
	    	paging: false,
	    	"bInfo": false,
	    	// default sorting on the first column ("Linea")
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
		<li><a href="/_5t/agenzie">Agenzia <b>${agenziaAttiva.gtfsId}</b></a></li>
		<li class="active">Linee</li>
	</ol>
	
	<p>Cliccare su una riga della tabella per selezionare la linea corrispondente.</p>
	
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
		<!-- Div with table containing route list -->
		<div class="col-lg-6">
			<table id="listaLinee" class="table table-striped table-hover sortable">
				<thead>
					<tr>
						<th>Id</th>
						<th>Nome abbreviato</th>
						<th>Nome completo</th>
						<th>Schemi corse</th>
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
							<td>${linea.gtfsId}</td>
							<td>${linea.shortName}</td>
							<td>${linea.longName}</td>
							<td>
								${fn:length(linea.tripPatterns)}
								<c:choose>
									<c:when test="${lineaAttiva.id == linea.id}">
										<a class="btn btn-default" href="/_5t/schemiCorse">
									</c:when>
									<c:otherwise>
										<a class="btn btn-default disabled" href="/_5t/schemiCorse">
									</c:otherwise>
								</c:choose>
								<c:choose>
									<c:when test="${fn:length(linea.tripPatterns) == 0}">Inserisci schemi corse</c:when>
									<c:when test="${fn:length(linea.tripPatterns) > 0}">Visualizza/modifica schemi corse</c:when>
								</c:choose>
								</a>
							</td>
							<td class="hidden">${linea.id}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Div with button to create route and selected route summary -->
		<div class="col-lg-6">
			<a id="creaLineaButton" class="btn btn-primary" href="/_5t/creaLinea">Crea una linea</a>
			
			<!-- Div with create route form -->
			<div id="creaLinea">
				<form:form id="creaLineaForm" commandName="route" method="post" role="form">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" placeholder="Inserisci l'id" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="shortName" class="required">Nome abbreviato</label>
				    		<form:input path="shortName" class="form-control" id="shortName" placeholder="Inserisci il nome abbreviato" maxlength="50" />
				    		<form:errors path="shortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="longName" class="required">Nome completo</label>
				    		<form:input path="longName" class="form-control" id="longName" placeholder="Inserisci il nome completo" maxlength="255" />
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
							<form:select path="type" class="form-control">
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
			
			<!-- Div with selected route summary -->
			<c:if test="${not empty lineaAttiva}">
				<div id="riassuntoLinea" class="riassunto">
					<div class="col-lg-8">
						<b>Id:</b> ${lineaAttiva.gtfsId}
					</div>
					<div class="col-lg-8">
						<b>Nome abbreviato:</b> ${lineaAttiva.shortName}
					</div>
					<div class="col-lg-8">
						<b>Nome completo:</b> ${lineaAttiva.longName}
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
							<a href="/_5t/selezionaTariffa?id=${tariffa.fareAttribute.id}">${tariffa.fareAttribute.gtfsId}</a><c:if test="${!i.last}">,</c:if>
						</c:forEach>
					</div>
					<div class="col-lg-12">
						<a id="modificaLineaButton" class="btn btn-primary" href="/_5t/modificaLinea">Modifica</a>
						<button id="eliminaLineaButton" type="button" class="btn btn-danger">Elimina</button>
					</div>
				</div>
			</c:if>
			
			<!-- Div with edit route form -->
			<div id="modificaLinea">
				<form:form id="modificaLineaForm" commandName="route" method="post" role="form" action="/_5t/modificaLinea">
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="gtfsId" class="required">Id</label>
				    		<form:input path="gtfsId" class="form-control" id="gtfsId" value="${lineaAttiva.gtfsId}" maxlength="50" />
				    		<form:errors path="gtfsId" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="shortName" class="required">Nome abbreviato</label>
				    		<form:input path="shortName" class="form-control" id="shortName" value="${lineaAttiva.shortName}" maxlength="50" />
				    		<form:errors path="shortName" cssClass="error"></form:errors>
						</div>
					</div>
					<div class="row">
						<div class="form-group col-lg-8">
							<label for="longName" class="required">Nome completo</label>
				    		<form:input path="longName" class="form-control" id="longName" value="${lineaAttiva.longName}" maxlength="255" />
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
							<form:select path="type" class="form-control">
								<%
								Route route = (Route) session.getAttribute("lineaAttiva");
								if (route != null) {
									for (int i=0; i<types.size(); i++) {
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
	
	<!-- Alerts -->
	<div id="route-already-inserted" class="alert alert-warning">
	    <button type="button" class="close">&times;</button>
	    <strong>Attenzione!</strong> L'id della linea che hai inserito è già presente.
	</div>
	<div id="delete-route" class="alert alert-danger">
	    <button type="button" class="close">&times;</button>
	    <p>Vuoi veramente eliminare la linea ${lineaAttiva.shortName}?</p>
	    <button id="delete-route-button" type="button" class="btn btn-danger">Elimina</button>
	    <button type="button" class="btn btn-default annulla">Annulla</button>
	</div>
</body>
</html>