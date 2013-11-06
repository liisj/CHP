<%@ include file="/html/newportlet2/init.jsp" %>

<portlet:actionURL name="getDrugCategories" var="getDrugCategories"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="getDrugs" var="getDrugs"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="getOrderSummary" var="getOrderSummary"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="getSentOrderSummary" var="getSentOrderSummary"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="getOrderItems" var="getOrderItems"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="getSentOrderItems" var="getSentOrderItems"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="sendOrder" var="sendOrder"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="updateStock" var="updateStock"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="updateOrder" var="updateOrder"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="addNewDrug" var="addNewDrug"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>
<portlet:actionURL name="updateDrug" var="updateDrug"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>

<!--  code from DMA, index.html -->
<!DOCTYPE HTML>
<html>
<head>
        <meta charset="utf-8">
    <link rel="shortcut icon" href="./favicon.ico"/>    
        <title>DMA App</title>
        
<script type="text/javascript">
//DMA code, from script.js

$(document).ready(function(){
    sideEl = 1;
	mod = 0; // mod = 0 -> Inventory; mod = 1 -> New Order; mod = 2 -> View Order; mod = 3 -> Incoming package; mod = 4 -> Add to Inventory
	submod = 0;
	//dbUrl = "http://admin:123456@127.0.0.1:8080/dmaaglarbri";
	dbUrl = "http://admin:123456@" + location.host;
	dbName = "facility_kirehe";
	clientDoc = "client_v2";
	newOrder = new Array();
	rcvOrder = new orderObj();
	
	$("#Inventory").click(function(){										//Called when "Inventory" tab is selected
		mod = 0; sideEl = 1;
		loadDrugCategories();
		$("#submodules").hide();
		$("#clearBtn").hide();	
		$("#backBtn").hide();
		$(".optBtn")
			.show()
			.button( {
				label: "Incoming Package",
				icons: {
					primary: "ui-icon ui-icon-cart"
				}
			})
			.attr("id","IncPack");		
	});
	$("#Order").click(function(){											//Called when "Order" tab is selected
		$("#submodules").show();
		switch (submod){
			case 0:
				$("#newOrder").click();	
				break;
			case 1:
				$("#viewOrder").click();
				break;
		}
	});
	$("#newOrder").click(function(){										//Called when "New Order" tab is selected
		submod = 0; mod = 1; sideEl = 1;
		$("#clearBtn").show(); $("#sidecol").show(); $("#backBtn").hide();
		$(".optBtn")
			.show()
			.button( {
				label: "Order Summary",
				icons: {
					primary: "ui-icon ui-icon-circle-arrow-e"
				}
			})
			.attr("id","OrdSummary");
		loadDrugCategories();
	});
	$("#viewOrder").click(function(){										//Called when "View Order" tab is selected
		submod = 1;	mod = 2; sideEl = 1;
		$(".optBtn").hide();
		$("#clearBtn").hide();
		$("#backBtn").hide();
		loadOrders();
	});
	$("#clearBtn").click(function(){										//Called when the "Clear" button is pressed
		createDialog("confirmation","#dialog-confirm","ui-icon ui-icon-alert","This will clear all you changes. Are you sure?");	
	});
	
	$("#backBtn").click(function(){											//Called when the "Back" button is pressed
		$(this).hide();
		switch (mod){
			case 2:															//The user is placed in "New Order"
				$("#newOrder").click();
				break;
			case 3:															//The user is placed in "Incoming Package"
				$("#Inventory").click();
				break;
			case 4:															//The user is placed in "Add to Inventory"
				$("#commitAddToInv").attr("id","IncPack");
				$("#IncPack").click();
				break;
		}
	});
	
	$("#Inventory").click();
});

$(document).on("click","#IncPack",function(){								//Called when the "Incoming Package" button is pressed
	mod = 3; sideEl = 1;
	$("#clearBtn").show(); $("#backBtn").show();
	$(this)
		.button( {
			label: "Add to Inventory",
			icons: {
				primary: "ui-icon ui-icon-circle-arrow-s"
			}
		})
		.attr("id","addToInvSummary");
	loadOrders("2");
});

$(document).on("click","#addToInvSummary",function(){						//Called when the "Add to Inventory" button is pressed
	
	if (rcvOrder.drugsInfo.length > 0){
		mod = 4;		
		$("#clearBtn").hide();
		$(this)
			.button( {
				label: "Commit Changes",
				icons: {
					primary: "ui-icon ui-icon-circle-check"
				}
			})
			.attr("id","commitAddToInv");	
		showNewInvSummary();
	}else
		createDialog("notification","#notification-message","ui-icon ui-icon-info","Please select one or more drugs to Add to Inventory");	
});

$(document).on("click","#commitAddToInv",function(){						//Called when the "Commit Changes" button is pressed
	addToInventory();
});

$(document).on("click","#OrdSummary",function(){							//Called when the "Order Summary" button is pressed
	if (newOrder.length){
		mod = 2;
		$("#clearBtn").hide();
		$(this)
			.button( {
				label: "Send",
				icons: {
					primary: "ui-icon ui-icon-circle-check"
				}
			})
			.attr("id","SendOrder");						
		showOrderSummary();
	}else {
		console.log("nothing chosen");
		createDialog("notification","#notification-message","ui-icon ui-icon-info","Please choose at least one drug to order");
	}
});

$(document).on("click","#SendOrder",function(){								//Called when the "Send" button is pressed
	sendOrder();
});

$(document).on("click",".AddReduce", function(){							//Called when either the "+" or "-" sign is pressed on "Inventory"
	var drugIndex = parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1));
	var sG = $(this).attr("id").search("l");
	var curStock = getDrVal("#stock",drugIndex);
	if (!(curStock == 0 && sG == -1)){
		updateVal("current",drugIndex,parseInt(curStock) + sG + '');
	}
});

$(document).on("click",".sideBtn",function(){								//Called when any of the side bar elements is pressed
	sideEl = parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1));
	console.log("mod: " + mod);
	switch(mod){
	case 0:
		var cat_id = $("#side_"+ sideEl).attr("cat_id");
		showDrugs(cat_id);
		break;
	case 1:
		var cat_id = $("#side_"+ sideEl).attr("cat_id");
		showDrugs(cat_id);
		
		$("#SendOrder")
		.show()
			.button( {
				label: "Order Summary",
				icons: {
					primary: "ui-icon ui-icon-circle-arrow-e"
				}
			})
			.attr("id","OrdSummary");
		
		break;
	case 2:
		sideEl += 1;
		showOrderItems(sideEl);
		break;
	case 3:
		sideEl += 1;
		rcvOrder = new orderObj();
		showOrderItems(sideEl, "2");
		break;
	}
});

$(document).on("click","#sideAddBtn", function() {
	createDrugForm("add");	
});

$(document).on("click",".EditDrug", function() {
	createDrugForm("edit", $(this).attr("drugid"));
});

$(document).on("click","#addDrugBtn", function() {
	var catMenu = document.getElementById("catIn");
	var catIDs = catMenu.getAttribute("catIDs").split(",");
	var JSONobj = {};
	JSONobj["med_name"] = $("#drugNameIn").val();
	JSONobj["category_id"] = catIDs[catMenu.selectedIndex];
	JSONobj["unit"] = $("#unIssueIn").val();
	JSONobj["unit_details"] = $("#drugFormIn").val();
	JSONobj["unit_price"] = parseInt($("#priceIn").val());
	
	$("#statusgif").show();
	var sendData = $.ajax({url: '<%=addNewDrug%>', data: JSONobj});
	sendData.done(function (msg){
		console.log("data sent, success");
		createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your update has been successfully sent!");		
	});
	sendData.fail(function(error2){
		console.log("failure");
		console.log(error2);
		createDialog("notification","#error-message","ui-icon ui-icon-circle-check","An error occured while sending the update. Please try again");
	});	
	$("#statusgif").hide();
});

$(document).on("click","#updateDrugBtn", function() {
	var catMenu = document.getElementById("catIn");
	var catIDs = catMenu.getAttribute("catIDs").split(",");
	var JSONobj = {};
	JSONobj["id"] = $(this).attr("drugid");
	JSONobj["med_name"] = $("#drugNameIn").val();
	JSONobj["category_id"] = catIDs[catMenu.selectedIndex];
	JSONobj["unit"] = $("#unIssueIn").val();
	JSONobj["unit_details"] = $("#drugFormIn").val();
	JSONobj["unit_price"] = parseInt($("#priceIn").val());
	
	$("#statusgif").show();
	var sendData = $.ajax({url: '<%=updateDrug%>', data: JSONobj});
	sendData.done(function (msg){
		console.log("data sent, success");
		createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your update has been successfully sent!");		
	});
	sendData.fail(function(error2){
		console.log("failure");
		console.log(error2);
		createDialog("notification","#error-message","ui-icon ui-icon-circle-check","An error occured while sending the update. Please try again");
	});	
	$("#statusgif").hide();
});

$(document).on("click",".newOrdBtn",function(){							//Called when a checkbox for a drug in "New Order" is marked
	
	var button = $(this);
	var drugIndex = parseInt(button.attr("for").substr(button.attr("id").indexOf("_")+1));
	var amount = parseInt($("#amount_" + drugIndex).val());
	
	if (isNaN(amount)) {
		createDialog("notification","#notification-message","ui-icon ui-icon-info","Please insert the amount you would like to order");
	}
	else {
		var JSONobj = {"category": sideEl};
		var id = $("#check_" + drugIndex + drugIndex).attr("drugid");
		var orderDrug = new drugObj(id, amount);
		if (button.attr("aria-pressed")) {
			newOrder.push(orderDrug);
		}
		else
			newOrder.splice(getDrugIndex(orderDrug.drugid,newOrder),1);
	}
});

$(document).on("click",".IncPackChkbox",function(){							//Called when a checkbox for a drug in "Incoming Package" is marked
	var checkbox = $(this);
	var drugIndex = parseInt(checkbox.attr("id").substr(checkbox.attr("id").indexOf("_")+1));
	$("#statusgif").show();
	
	var params = {"order_status": "2", "facility_id" : "1", "summarize": "false"};
	var request = $.getJSON('<%=getOrderSummary%>', params);	
	request.done(function(data){
		$("#statusgif").hide();
		var orderid = data[sideEl-1].orderid;
		var drugid = data[sideEl-1].drugid;
		var orderDrug = new drugObj(drugid, parseInt($("#amount_" + drugIndex).val()));
		if ($("#check_" + drugIndex + drugIndex).attr("aria-pressed"))
			rcvOrder.drugsInfo.push(orderDrug);
		else
			rcvOrder.drugsInfo.splice(getDrugIndex(orderDrug.drugid,rcvOrder.drugsInfo),1);
	});		
});

$(document).on("click",".UpdateStock", function() {
	
	$("#statusgif").show();
	
	var drugIndex = ($(this).attr("id").substr($(this).attr("id").indexOf("_")+1));
	var add = parseInt($("#add_" + drugIndex).val());
	var reduce = parseInt($("#reduce_" + drugIndex).val());
	var diff = ( isNaN(add) ? 0 : add) - (isNaN(reduce) ? 0 : reduce);
	var updateInfo = {};
	updateInfo[$(this).attr("drugid")] = diff;
	updateInfo["facility_id"] = "1";
	
	var sendUpdate = $.ajax({url: '<%=updateStock%>', data: updateInfo});
	sendUpdate.done(function (msg){
		console.log("update sent, success");
		createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your update has been successfully sent!");		
	});
	sendUpdate.fail(function(error2){
		console.log("order failure");
		console.log(error2);
		createDialog("notification","#error-message","ui-icon ui-icon-circle-check","An error occured while sending the update. Please try again");
	});	
	$("#statusgif").hide();
});


/* <--------- Function calls ---------> */
 
 function createDrugForm(mode, drugid) {
	
	var tbody = $("#inner-content");
	tbody.html("");
	var cell = $("<div>");
	cell
		.addClass("col1")
		.appendTo(tbody);
	
	var title = $("<p>");
	title
		.attr("id","title")
		.addClass("Title")
		.appendTo(cell);
	
	createInputField("Drug name: ", "drugNameIn", "text", cell);
	createInputField("Common name: ", "commonNameIn", "text", cell);
	createInputField("Category: ", "catIn", "category", cell);
	createInputField("Unit of issue: ", "unIssueIn", "text", cell);
	createInputField("Drug form: ", "drugFormIn", "text", cell);
	createInputField("Price: ", "priceIn", "number", cell);
	
	var sendButton = $("<button>");	
	sendButton.appendTo(cell);
	

	if (mode == "add") {
		title.text("Add new drug");
		sendButton
			.attr("id", "addDrugBtn")
			.text("Add to database");
	}
	else if (mode == "edit") {
		
		title.text("Edit drug info");
		sendButton
			.attr("id","updateDrugBtn")
			.attr("drugid", drugid)
			.text("Update info in database");
		
		var JSONobj = {"drug_id": drugid, "facility_id": 1};
		var request = $.getJSON('<%=getDrugs%>', JSONobj);
		request.done(function(data) {
			console.log(data);
			$("#drugNameIn").val(data[0].med_name);
			$("#commonNameIn").val(data[0].common_name);
			
			var catMenu = document.getElementById("catIn");
			var catIDs = catMenu.getAttribute("catIDs").split(",");
			for (var i in catIDs) {
				if (catIDs[i] == data[0].category_id) {
					catMenu.selectedIndex = i;
				}
			}
			
			$("#unIssueIn").val(data[0].unit_details);
			$("#drugFormIn").val(data[0].unit);
			$("#priceIn").val(data[0].unit_price);
		});
	}
};

function createInputField(labelText, id, type, cell) {
	var row = $("<tr>");
	var left = $("<td>");
	var right = $("<td>");
	
	var label = $("<p>");
	label
		.text(labelText)
		.addClass("label")
		.appendTo(left);
	
	if (type == "category") {
		addCategoryDropdown(right, id);
	}
	
	else {
		var drugNameInput = $("<input>");
		drugNameInput
			.attr("type",type)
			.attr("id",id)
			.appendTo(right);
	}
	
	left.appendTo(row);
	right.appendTo(row);
	row.appendTo(cell);
}
 
 function addCategoryDropdown(cell, id) {
	 
	var url = '<%=getDrugCategories%>';
		$("#statusgif").show();
		
		var request = jQuery.getJSON(url);
		request.done(function(data){
			$("#statusgif").hide();
			var dropdown = $("<select>");
			dropdown
				.attr("id",id)
				.appendTo(cell);
			
			catIDs = "";
			for (var i in data) {
				var categoryOpt = $("<option>");
				categoryOpt
					.text(data[i].category_name)
					.appendTo(dropdown);
				catIDs += data[i].category_id + ",";
			}
			dropdown.attr("catIDs", catIDs);
		});
		request.fail(function(jqXHR, textStatus) {
	 		createDialog("notification","#error-message","ui-icon ui-icon-alert","Connection to the DMA server is unavailable. Please try again later");
			$("#statusgif").attr("src","/css/custom-theme/images/important.gif");
		});	
}
 
 function loadDrugCategories () {											//Retrieves from DMA server the category names and displays them in side bar
	
	var url = '<%=getDrugCategories%>';
	$("#statusgif").show();
	
	var request = jQuery.getJSON(url);
	request.done(function(data){
		$("#statusgif").hide();
		drawSideCol("#sidecol",data,"drugCategories");
		$("#side_0").click();
	});
	request.fail(function(jqXHR, textStatus) {
 		createDialog("notification","#error-message","ui-icon ui-icon-alert","Connection to the DMA server is unavailable. Please try again later");
		$("#statusgif").attr("src","/css/custom-theme/images/important.gif");
	});
}

function showDrugs(category){ 														//Retrieves drug information from DB and displays it to the user
	
	$("#statusgif").show();
	var url = '<%=getDrugs%>';
	
	var catJSON = {};
	
	if (category != null) {
		catJSON["category_id"] = category;
		catJSON["facility_id"] = 1;
	}
	var request = $.getJSON(url, catJSON);	
	request.done(function(data){
		$("#statusgif").hide();
		putTable("drugs_table",data.length,3);
		for (var i in data){
			
			var drugName = data[i].med_name;
			if (data[i].common_name.length != 0) {
				drugName += (" (" + data[i].common_name + ")"); 
			}
			
			$("#drugName_" + i).text(drugName);
			$("#update_" + i).attr("drugid",data[i].id);
			$("#edit_" + i).attr("drugid",data[i].id);
			$("#check_" + i + i).attr("drugid",data[i].id);
			putDrVal("#unIssue",i,data[i].unit);
			putDrVal("#drugForm",i,data[i].unit_details);
			putDrVal("#stock",i,data[i].unit_number);
			putDrVal("#price",i,data[i].unit_price);
						
			var drugIndex = getDrugIndex(data[i].id,newOrder);
			if (drugIndex >= 0){
				$("#check_" + i + i).attr("aria-pressed",true); $("#check_" + i + i).addClass("ui-state-active"); $("#check_" + i).attr("checked",true);
				$("#amount_" + i).attr("value",newOrder[drugIndex].amount);
			}
			else
				$("#amount_" + i).attr("value",data[i].suggested);
		}
		$(".col3").buttonset();		
	});
}

function loadOrders(status){												//Retrieves from DMA server the orders and displays them in side bar
	
	$("#statusgif").show();
	
	var params = {"facility_id": "1", "summarize": "false"};
	if (status != null) {
		params["order_status"] = status;
	}
	
	var request = $.getJSON('<%=getOrderSummary%>', params);
	request.done(function(data){
		if (data.length){
			var orderInfo = new Array(data.length);
			for (var i in data)
				orderInfo[i] = new ordSummaryObj(data[i].order_id,data[i].order_timestamp,
						data[i].drugs.length,data[i].order_status);
			$("#statusgif").hide();
			drawSideCol("#sidecol",orderInfo,"Orders");
			$("#side_0").click();
		}else{
			createDialog("notification","#notification-message","ui-icon ui-icon-info","There are no orders to show");	
			$("#Inventory").click();
		}
	});
	request.fail(function(msg){
		console.log("getOrderSummary request failed");
		console.log(msg);
	})
}

function showOrderItems(sideEl, status){											//Displays all of the items contained in the selected order
	
	$("#statusgif").show();
	
	var JSONobj = {};
	JSONobj["order_id"] = $("#side_" + parseInt(sideEl-1)).attr("orderid");
	JSONobj["summarize"] = "false";
	JSONobj["facility_id"] = "1";
	if (status != null) {
		JSONobj["order_status"] = status;
	}
	
	var request = $.getJSON('<%=getOrderSummary%>', JSONobj);
	request.done(function(data){
		$("#statusgif").hide();
		putTable("order",data.length,3);
		console.log(data[0]);
		for (var i in data[0].drugs){
			console.log("unit number: " + data[0].drugs[i].unit_number);
			$("#drugName_" + i).text(data[0].drugs[i].med_name);
			putDrVal("#unIssue",i,data[0].drugs[i].unit);
			putDrVal("#drugForm",i,data[0].drugs[i].unit_details);
			putDrVal("#price",i,data[0].drugs[i].unit_price);
			putDrVal("#reqLbl",i,data[0].drugs[i].unit_number);
			// TODO
			putDrVal("#sentQty",i,data[0].drugs[i].unit_number);
			$("#amount_" + i).val(data[0].drugs[i].unit_number);
			if (mod == 3)
				rcvOrder.orderid = data[sideEl-1].orderid;			
		}
	});
	request.fail(function(msg) {
		console.log("request failed");
		console.log(msg);
	});
}

function showOrderSummary() {												//Displays the user with the order summary
	$("#statusgif").show();
	
	var url = '<%=getDrugs%>';
	putTable("order",newOrder.length,3);
	
	for (var i in newOrder) {
	
		var JSONobj = {"drug_id": newOrder[i].drugid, "index": i, "facility_id": 1};
		var request = $.getJSON(url, JSONobj);
		request.done(function(data){
			$("#statusgif").hide();
			for (var j in data) {
				
				var drugName = data[j].med_name;
				if (data[j].common_name.length != 0) {
					drugName += ("(" + data[j].common_name + ")"); 
				}
				
				$("#drugName_" + data[j].index).text(drugName);
				putDrVal("#unIssue",data[j].index,data[j].unit);
				putDrVal("#drugForm",data[j].index,data[j].unit_details);
				putDrVal("#price",data[j].index,data[j].unit_price);
				putDrVal("#reqLbl",data[j].index,newOrder[parseInt(data[j].index)].amount);
				break;
			}
		});
	}
	
	mod = 1;
}

function putDrVal(id,index,newVal){					//displays the new value entered by the user
	var field = $(id + "_" + index);
	var curVal = getDrVal(id,index);
	field.text(field.text().replace(curVal,newVal));
}

function putTable (id, rows, columns){			//creats object tableObj and calls method to draw the table 
	table = new tableObj(id,rows,columns);
	table.drawText("#inner-content");
}

function drawTextTable(tbody){
	$(tbody).html("");
	for (var r = 0; r < this.rows; r++) {
		var checked = false;
		var trow = $("<div>");
			trow.addClass("trow");
		var cell = $("<div>");
		cell
			.addClass("col1")
			.appendTo(trow);
		
		var drugName = $("<p>");
		drugName
			.attr("id","drugName_" + r)
			.addClass("Drug_name")
			.text("[Drug name]")
			.appendTo(cell);
		
		var unIssue = $("<p>");
		unIssue
			.attr("id","unIssue_" + r)
			.text("Unit of Issue: []")
			.appendTo(cell);
		
		var drugForm = $("<p>");
		drugForm
			.attr("id","drugForm_" + r)
			.text("Drug Form: []")
			.appendTo(cell);
			
		var price = $("<p>");
		price
			.attr("id","price_" + r)
			.text("Price: []")
			.appendTo(cell);
			
		var cell2 = $("<div>");
		cell2
			.addClass("col2")
			.appendTo(trow);
		
		var currentStock = $("<div>"); 
		var addCell = $("<div>");
		var reduceCell = $("<div>");
			
		var stockLeft = $("<td>");
		var stockRight = $("<td>");
		
		var stock = $("<p>");
		stock
			.attr("id","stock_" + r)
			.addClass("stock")
			.text("Stock: []")
			.appendTo(currentStock);
		
		var addLeft = $("<td>");
		var addMiddle = $("<td>");
		var addRight = $("<td>");
		
		var addInput = $("<input>");
		addInput
			.attr("id","add_" + r)
			.addClass("AddReduceInput")
			.attr("type","number")
			.attr("min","0")
			.appendTo(addMiddle);
		
		var addLblLeft = $("<p>");
		addLblLeft.text("Add ")
		.attr("id","addLblLeft_" + r)
		.addClass("label")
		.appendTo(addLeft);
		
		var addLblRight = $("<p>");
		addLblRight.text("items to stock")
		.attr("id","addLblLeft_" + r)
		.addClass("label")
		.appendTo(addRight);
		
		addLeft.appendTo(addCell);
		addMiddle.appendTo(addCell);
		addRight.appendTo(addCell);
		
		var reduceLeft = $("<td>");
		var reduceMiddle = $("<td>");
		var reduceRight = $("<td>");
		
		var reduceInput = $("<input>");
		reduceInput
			.attr("id","reduce_" + r)
			.addClass("AddReduceInput")
			.attr("type","number")
			.attr("min","0")
			.appendTo(reduceMiddle);
		
		var reduceLblLeft = $("<p>");
		reduceLblLeft.text("Remove ")
		.attr("id","reduceLblLeft_" + r)
		.addClass("label")
		.appendTo(reduceLeft);
		
		var reduceLblRight = $("<p>");
		reduceLblRight.text("items from stock")
		.attr("id","reduceLblLeft_" + r)
		.addClass("label")
		.appendTo(reduceRight);
		
		reduceLeft.appendTo(reduceCell);
		reduceMiddle.appendTo(reduceCell);
		reduceRight.appendTo(reduceCell);
			
		var cell3 = $("<div>");
		cell3
			.addClass("col3")
			.appendTo(trow);
		
		var updateBtn = $("<button>");
		updateBtn
			.attr("id", "update_" + r)
			.addClass("UpdateStock")
			.text("Update stock");
		
		var editBtn = $("<button>");
		editBtn
			.attr("id", "edit_" + r)
			.addClass("EditDrug")
			.text("Edit drug info");

/*		var plusButton = $("<button>");
		plusButton
			.attr("id", "plus_" + r)
			.addClass("AddReduce")
			.button( {
					icons: {
						primary: "ui-icon-plusthick"
					},
					text: false
			})

		var minusButton = $("<button>");
		minusButton
			.attr("id", "minus_" + r)
			.addClass("AddReduce")
			.button( {
					icons: {
						primary: "ui-icon-minusthick"
					},
					text: false
			}) */
			
		
		
		switch(mod){
		case 0: //Inventory
			currentStock.appendTo(cell2);
			addCell.appendTo(cell2);
			reduceCell.appendTo(cell2);
			var updateDiv = $("<div>");
			var editDiv = $("<div>");
			updateBtn.appendTo(updateDiv);
			editBtn.appendTo(editDiv);
			updateDiv.appendTo(cell3);
			editDiv.appendTo(cell3);
			/*plusButton.appendTo(cell3);
			$("<br />").appendTo(cell3);
			minusButton.appendTo(cell3);*/	
			break;
		case 1: //New Order
			stockLeft.appendTo(cell2);
			stockRight.appendTo(cell2);
			var subrow_left = $("<td>");
			var subrow_right = $("<td>");
			subrow_left.appendTo(cell2);
			subrow_right.appendTo(cell2);	
			$("<p>").text("Request Qty: ")
			.attr("id","reqLbl_" + r)
			.addClass("ReqQLbl")
			.appendTo(subrow_left);
			var reqQuantity = $("<input>");
			reqQuantity
			.attr("id","amount_" + r)
			.addClass("reqInput")
			.attr("type","number")
			.attr("min","0");
			reqQuantity.appendTo(subrow_right);
			var checkbox = $("<input>");
			checkbox
				.attr("type","checkbox")
				.attr("id","check_" + r)
				.addClass("newOrdChkbox")
				.appendTo(cell3);
			var label = $("<label>");
			label
				.attr("for","check_" + r)
				.attr("id","check_"+ r + r)
				.addClass("newOrdBtn")
				.text("order")
				.appendTo(cell3);
			checkbox
				.button( {
					icons: {
						primary: "ui-icon-check"
					}
				});

			break;
		case 2:
			$("<p>").text("Requested Qty: []")
			.attr("id","reqLbl_" + r)
			.addClass("reqQlabel")
			.appendTo(cell2);
			break;	
		case 3:
			$("<p>").text("Sent Qty: []")
				.addClass("SentQLbl")
				.attr("id","sentQty_" + r)
				.appendTo(cell2);				
			var subrow_left = $("<td>");
			var subrow_right = $("<td>");
			subrow_left.appendTo(cell2);
			subrow_right.appendTo(cell2);
			$("<p>").text("Received Qty: ")
				.addClass("RcvQLbl")
				.appendTo(subrow_left);
			var RcvQty = $("<input>");
			RcvQty
				.attr("id","amount_" + r)
				.addClass("rcvInput")
				.attr("type","number")
				.attr("min","0")
			.appendTo(subrow_right);		
			var checkbox = $("<input>");
			checkbox
				.attr("type","checkbox")
				.attr("id","check_" + r)
				.addClass("IncPackChkbox")
				.appendTo(cell3);
			var label = $("<label>");
			label
				.attr("for","check_" + r)
				.attr("id","check_"+ r + r)
				.addClass("incOrdBtn")
				.appendTo(cell3);
			checkbox
				.button( {
					icons: {
						primary: "ui-icon-check"
					},
					text: false
				});

			break;
		case 4:			
			$("<p>").text("Received Qty: []")
				.addClass("RcvQLbl")
				.attr("id","rcvQty_" + r)
				.appendTo(cell2);
			var newStock = $("<p>");
			newStock
				.text("New Stock: []")
				.attr("id","newStock_" + r)
				.addClass("NewStock")
				.appendTo(cell2);
			break;	
		}
		trow.appendTo(tbody);
	}
}

function showNewInvSummary(){												//Displays a summary of the drugs that will be added to Inventory
	$("#statusgif").show();
	
	putTable("InvSummary",rcvOrder.drugsInfo.length,3);
	
	for (var i in rcvOrder.drugsInfo){
		var JSONobj = {"drug_id": rcvOrder.drugsInfo[i].drugid, "index": i, "facility_id": 1};
		var request = $.getJSON('<%=getDrugs%>', JSONobj);
		request.done(function(data){
			for (var j in data){
				var drugName = data[j].med_name;
				if (data[j].common_name.length != 0) {
					drugName += ("(" + data[j].common_name + ")"); 
				}
				$("#drugName_" + data[j].index).text(drugName);
				putDrVal("#unIssue",data[j].index,data[j].unit);
				putDrVal("#drugForm",data[j].index,data[j].unit_details);
				putDrVal("#price",data[j].index,data[j].unit_price);
				putDrVal("#rcvQty",data[j].index,rcvOrder.drugsInfo[data[j].index].amount);
				putDrVal("#newStock",data[j].index,parseInt(getDrVal("#rcvQty",data[j].index))+parseInt(data[j].unit_number));
				break;
			}
		});
	}
	$("#statusgif").hide();
}



function sendOrder(){														//Sends order information to the DMA server
	$("#statusgif").show();
	var JSONobj = {"drugs": JSON.stringify(newOrder)}
	console.log(JSONobj)
	var sendNewOrder = $.ajax({url: '<%=sendOrder%>', data: JSONobj});
	sendNewOrder.done(function (msg){
		$("#statusgif").hide();
		console.log("order sent, success");
		createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your order has been successfully sent!");
		newOrder = new Array();
		$("#newOrder").click();					
	});
	sendNewOrder.fail(function(error2){
		console.log("order failure");
		createDialog("notification","#error-message","ui-icon ui-icon-circle-check","An error occured while sending the order. Please try again");
		$("#newOrder").click();
	});
}

function updateVal(field,index,newVal){										//Updates a single value in database and displays the change to the user
	var dbViewUri = "_design/" + clientDoc + "/_view/by_cat";
	$("#statusgif").show();
	
	/* TODO
	var request = $.getJSON(dbUrl + "/" + dbName + "/" + dbViewUri,encodeURI("key=\"" + sideEl + "\""));	
	request.done(function(data){
		var drugJson = data.rows[index].value;
		switch(field){
		case "current":
		  drugJson.current = newVal;
		  break;		 
		}
		var drugJsonText = JSON.stringify(drugJson);
		var requestUpd = $.ajax({
			url: dbUrl + "/" + dbName + "/" + drugJson._id,
			type: "PUT",
			processData: false,
			data: drugJsonText,
			contentType: "application/json"
		});
		requestUpd.done(function (msg){
			$("#statusgif").hide();
			putDrVal("#stock",index,newVal);
		});
	}); */
}

function addToInventory(){													//Updates all inventory values which were changed at the "Incoming package" screen
	$("#statusgif").show();
	for (var i in rcvOrder.drugsInfo){
		var JSONobj = {};
		JSONobj["drugid"] = rcvOrder.drugsInfo[i].drugid;
		JSONobj["added"] = rcvOrder.drugsInfo[i].amount;
		var request = $.ajax({url: '<%=updateStock%>', data: JSONobj});
		request.done(function(msg) {
			$("#statusgif").hide();
			sendReport();
			changeOrderStatus("delivered");
			createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your changes have been updated and a report has been sent");	
			$("#Inventory").click();
		});
		request.fail(function(error) {
			createDialog("notification","#error-message","ui-icon ui-icon-alert","Something went wrong and your changes were not updated. Please try again");
			$("#Inventory").click();
			console.log("Adding to inventory failed");
		});
	}
}

function sendReport(){														//Sends a report of the received drugs
	var dbViewUri = "_design/" + clientDoc + "/_view/orders";
	/* TODO
	var getOrders = $.getJSON(dbUrl + "/" + dbName + "/" + dbViewUri);	
	getOrders.done(function(data){
		var orders = data.rows;
		dbViewUri = "_uuids";
		var getNewId = $.getJSON(dbUrl + "/" + dbViewUri);	
		getNewId.done(function(_uuids){
			var newId = _uuids.uuids[0];
			var report = orders[getOrderIndex(rcvOrder.orderid,orders)].value;
			var drugIndex;
			for (var i in report.items){
				drugIndex = getDrugIndex(report.items[i]._id,rcvOrder.drugsInfo);
				if (drugIndex>=0)
					report.items[i].amount = rcvOrder.drugsInfo[drugIndex].amount;
				else
					report.items[i].amount = 0;	
			}
			report.created_at = getDateFormat();
			report.status = "delivered";
			report.type = "report";
			var reportText = JSON.stringify(report);
			var putReport = $.ajax({
				url: dbUrl + "/" + dbName + "/" + newId,
				type: "PUT",
				processData: false,
				data: reportText,
				contentType: "application/json"
			});		
			putReport.fail(function (msg){
				//createDialog("notification","#error-message","ui-icon ui-icon-alert","The report was not delivered to the DMA server. Contact your administrator");
			});			
		});
	}); */
}

function changeOrderStatus(newStatus){										//Updates the status of an order
	
	var JSONobj = {"id": rcvOrder.orderid, "newStatus": newStatus};
	var changeStatus = $.ajax('<%=updateOrder%>', JSONobj);
	changeStatus.done(function(msg) {
		console.log("changeStatus done");
	});
	changeStatus.fail(function (msg){
		alert("Fail CoS:(\n" + msg);
	});
} 

function getOrderItems(Drugs){
	var orderItems = "\"items\":[";
	var drug = new orderItemObj();
	for (var i in newOrder){
		for (var j in Drugs){
			if (Drugs[j].id == newOrder[i].drugid){
				drug.drugid = toJsonField("_id", Drugs[j].id);
				drug.name = toJsonField("drugname", Drugs[j].value.drugname);
				drug.msdcode = toJsonField("msdcode", Drugs[j].value.msdcode);
				drug.unitofissue = toJsonField("unitofissue", Drugs[j].value.unitofissue);
				drug.drugform = toJsonField("drugform", Drugs[j].value.drugform);
				drug.price = toJsonField("price", Drugs[j].value.price);
				drug.amount = toJsonField("amount", newOrder[i].amount);
				if (i == newOrder.length - 1)
					orderItems = orderItems.concat(drug.mergeFields());
				else
					orderItems = orderItems.concat(drug.mergeFields(),",");
			};
		};
	}
	return orderItems.concat("]");
}

function getDrVal(id,index){						//returns the value stored in HTML and which corresponds to the user's value
	var field = $(id + "_" + index);
	return field.text().substr(field.text().indexOf(":")+2);
}

function getDrugIndex(_id,array){						//returns the index where the drug_id is located within the Order array
	for (var i in array){
		if (array[i].drugid == _id)
			return i;
	}
	return -1;
}

function getOrderIndex (orderid, array){
	for (var i in array){
		if (array[i].id == orderid)
			return i;
	}
	return -1;
}

function orderItemObj (_id,name,msdcode,unitofissue,drugform,price,amount){		//an Order object
	this.drugid = _id;
	this.name = name;
	this.msdcode = msdcode;
	this.unitofissue = unitofissue;
	this.drugform = drugform;
	this.price = price;
	this.amount = amount;
	this.mergeFields = mergeDrugFields;
}

function mergeDrugFields() {						//merges the fields into a Json-compliant format
	return "{" + this.drugid + "," + this.name + "," + this.msdcode + "," + this.unitofissue + "," + this.drugform + "," + this.price + "," + this.amount + "}"; 
}

function toJsonField (key,value){
	return "\"" + key + "\"" + ":" + "\"" + value + "\"";
}

function getDateFormat(){
	var d = new Date();
	var date = d.getDate();
	var month = d.getMonth() + 1;
	if (date < 10)
		date = "0" + date;
	if (month < 10)
		month = "0" + month;		
	return d.getFullYear() + "-" + month + "-" + date + "T" + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds()+ "." + d.getMilliseconds()+"Z";
}

function drugObj (drugid, amount) {
	this.drugid = drugid;
	this.amount = amount;
}

function orderObj (orderid) {
	this.orderid = orderid;
	this.drugsInfo = new Array();
}

function order (_id,author,created_at,facility,items,order_id,status,type){
	this._id = _id;
	this.author = author;
	this.created_at = created_at;
	this.facility = facility;
	this.items = items;				//already in string format
	this.order_id = order_id;
	this.status = status;
	this.type = type;
	this.mergeFields = mergeOrderFields;
}

function mergeOrderFields(){
	return "{" + this._id + "," + this.author + "," + this.created_at + "," + this.facility + "," + this.items + "," + this.order_id + "," + this.status + "," + this.type + "}"; 
}

function ordSummaryObj(orderid,date,items,status){
	this.orderid = orderid;
	this.date = date;
	this.items = items;
	this.status = status;
}

function tableObj(id, rows, columns){ /*table Object*/
	this.id = id;
	this.rows = rows;
	this.cols = columns;	
	this.drawText = drawTextTable;
}

function createDialog(type,dialog_id,icon,message){

	$(dialog_id).html("");
	$("<span>")
		.addClass(icon)
		.attr("style","float:left; margin:0 7px 50px 0;")
		.appendTo(dialog_id);
	$("<p>")
		.text(message)
		.attr("style","padding:0;")
		.appendTo(dialog_id);
	switch (type){
		case "notification":
			$(dialog_id).dialog({
				modal: true,
				buttons: {
					Ok: function() {
						$( this ).dialog( "close" );
					}
				}
			});			
			break;
		case "confirmation":
			$(dialog_id).dialog({
				resizable: false,
				height:160,
				width: 350,
				modal: true,
				buttons: {
					"Clear": function() {
						switch (mod){
							case 1:															//The user is placed in "New Order"
								newOrder = new Array();
								$(".newOrdBtn").attr("aria-pressed",false); $(".newOrdBtn").removeClass("ui-state-active"); $(".newOrdChkbox").attr("checked",false);
								break;
							case 3:															//The user is placed on "Incoming Package"
								rcvOrder = new orderObj();
								$(".incOrdBtn").attr("aria-pressed",false); $(".incOrdBtn").removeClass("ui-state-active"); $(".IncPackChkbox").attr("checked",false);
								break;
						}
						$( this ).dialog( "close" );
					},
					Cancel: function() {
						$( this ).dialog( "close" );
					}
				}
			});
			break;
	}
}

function drawSideCol (tbody,info,type){
	$(tbody).html("");
	

	if (type == "drugCategories") {
		var button = $("<input>");
		button
			.attr("id","sideAddBtn")
			.attr("type","radio")
			.attr("name","sideBtns");
		var label = $("<label>");
		label
		.attr("for","sideAddBtn")
		.attr("id","sideAddLbl")
		.text("ADD NEW DRUG");

		button.appendTo(tbody);
		label.appendTo(tbody);
	}
	
	for (var r = 0; r < info.length; r++){		
		var button = $("<input>");
		var label = $("<label>");
		button
			.attr("id","sideBtn_" + r)
			.attr("type","radio")
			.attr("name","sideBtns");
		switch (type){
		case "drugCategories":
			label
				.attr("for","sideBtn_" + r)
				.attr("id","side_" + r)
				.attr("cat_id",info[r].category_id)
				.addClass("sideBtn")
				.text(info[r].category_name);
			break;
		case "Orders":
			label
				.attr("for","sideBtn_" + r)
				.attr("id","side_" + r)
				.attr("orderid",info[r].orderid)
				.addClass("sideBtn")
				.text("Date: " + info[r].date +  " Items: " + info[r].items + " -Status: " + info[r].status);
			break;
		}
		button.appendTo(tbody);
		label.appendTo(tbody);
	}
	$('#sidecol').buttonset();
}
</script>
     








        <script>        // DMA code from index.html

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
                        <img src="<%= request.getContextPath()%>/css/images/loading-gif-animation.gif" alt="[loading...]" name="statusgif" width="24" height="20" id="statusgif">        
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
