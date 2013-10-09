<%@ include file="/html/newportlet2/init.jsp" %>

<portlet:renderURL var="updateBookURL">
	<portlet:param name="jspPage" value="/html/newportlet2/update.jsp"/>
</portlet:renderURL>
<!-- 
<br/><a href="<%= updateBookURL %>">Add new Book &raquo;</a>
 -->

<!--  code from DMA, index.html -->
<!DOCTYPE HTML>
<html>
<head>
	<meta charset="utf-8">
    <link rel="shortcut icon" href="./favicon.ico"/>    
	<title>DMA App</title>
	
	<script>	// DMA code from index.html

	$(function() {
		$("button").button();
		$(".dialog-messages").hide();
		$('#modules').buttonset();
		$('#submodules').buttonset();
		$("#Order")
			.button( {
				icons: {
					primary: null,
					secondary: "ui-icon-triangle-1-s"
				}
			});
		$(".optBtn")
			.button( {
				label: "Incoming Package",
				icons: {
					primary: "ui-icon-cart"
				}
			});
		$("#clearBtn")
			.button( {
				label: "Clear",
				icons: {
					primary: "ui-icon-trash"
				}
			});
		$("#backBtn")
			.button( {
				label: "Back",
				icons: {
					primary: "ui-icon-circle-arrow-w"
				}
			});				
	});	
</script>
</head>

<body>



	<div id="main" class="container">
        <div id="header">
			<div class="floatWrap centerWrap">
				<h1><a id="logo" href="">DMA</a></h1>
				<a id="referenceUrl" href="file:///C|"></a>
			<div id="modules">
				<input type="radio" id="Inventory" name="radio0" checked="checked" /><label class="mods" for="Inventory">Inventory</label>
				<input type="radio" id="Order" name="radio0"/><label class="mods" for="Order">Order</label>
			</div>
			<div id="options">
				<button id= "backBtn"></button>
				<button id= "IncPack" class="optBtn"></button>				
			</div>
			<img src="<%= request.getContextPath()%>/css/custom-theme/images/loading-gif-animation.gif" alt="[loading...]" name="statusgif" width="24" height="20" id="statusgif">	
			<br /><br />
			<div id="submodules">
				<input type="radio" id="newOrder" name="radio1" checked="checked" /><label class="submods" for="newOrder">New Order</label>
				<input type="radio" id="viewOrder" name="radio1" /><label class="submods" for="viewOrder">View Order</label>
			</div>
			<div id="clear">
				<button id="clearBtn">Clear!</button>
			</div>				
			</div> <!-- / header -->
		</div>
		<div id="blueline"></div> 		
		<div id="info">
			<div id="sidecol">
				<!--/*content is filled in by JS/couchDB*/-->
			</div>
			<div id="inner-content">
				<!--/*content is filled in by JS*/-->
			</div>
		</div>
		<div id="footer">
		  Copyright Aglarbri 2011
		</div>
		<div class= "dialog-messages">
			<div id="notification-message" title="Important">
				<span class="ui-icon ui-icon-info" style="float:left; margin:0 7px 50px 0;"></span>
				[msg]
			</div>
			<div id="success-message" title="Success">
				<span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
				[msg]
			</div>			
			<div id="error-message" title="Error">
				<span class="ui-icon ui-icon-circle-alert" style="float:left; margin:0 7px 50px 0;"></span>
				[msg]
			</div>
			<div id="dialog-confirm" title="Clear?">
				<span class="ui-icon ui-icon-help" style="float:left; margin:0 7px 20px 0;"></span>
				This will clear all you changes. Are you sure?
			</div>			
		</div>
	</div>
</body>
</html>

<!--  end DMA code  -->
