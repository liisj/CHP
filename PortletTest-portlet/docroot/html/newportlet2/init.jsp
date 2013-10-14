<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="javax.portlet.ActionRequest"%>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>

<portlet:defineObjects />

<portlet:actionURL name="getCategories" var="getCategories"
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
		loadOrders('<%=getOrderSummary%>');
	});
	$("#clearBtn").click(function(){										//Called when the "Clear" button is pressed
		////createDialog("confirmation","#dialog-confirm","ui-icon ui-icon-alert","This will clear all you changes. Are you sure?");	
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
	loadOrders('<%=getSentOrderSummary%>');
});

$(document).on("click","#addToInvSummary",function(){						//Called when the "Add to Inventory" button is pressed
	if (rcvOrder.drugsInfo.length){
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
	}//else
		////createDialog("notification","#notification-message","ui-icon ui-icon-info","Please select one or more drugs to Add to Inventory");	
});

$(document).on("click","#commitAddToInv",function(){						//Called when the "Commit Changes" button is pressed
	addToInventory();
})

$(document).on("click","#OrdSummary",function(){							//Called when the "Order Summary" button is pressed
	if (newOrder.length){
		mod = 2;
		$("#clearBtn").hide(); $("#backBtn").show();
		$(this)
			.button( {
				label: "Send",
				icons: {
					primary: "ui-icon ui-icon-circle-check"
				}
			})
			.attr("id","SendOrder");						
		showOrderSummary();
	}else console.log("nothing chosen");
		////createDialog("notification","#notification-message","ui-icon ui-icon-info","Please choose at least one drug to order");	
});

$(document).on("click","#SendOrder",function(){								//Called when the "Send" button is pressed
	sendOrder();
});

$(document).on("click",".AddReduce", function(){							//Called when either the "+" or "-" sign is pressed on "Inventory"
	var drugIndex = parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1));
	console.log("drugIndex: " + drugIndex);
	var sG = $(this).attr("id").search("l");
	console.log("sG: " + sG);
	var curStock = getDrVal("#stock",drugIndex);
	console.log("curStock: " + curStock);
	if (!(curStock == 0 && sG == -1)){
		updateVal("current",drugIndex,parseInt(curStock) + sG + '');
	}
});

$(document).on("click",".sideBtn",function(){								//Called when any of the side bar elements is pressed
	sideEl = parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1)) + 1;
	console.log("sideEl: " + sideEl);
	switch(mod){
	case 0:
		showDrugs(sideEl);
		break;
	case 1:
		showDrugs(sideEl);
		break;
	case 2:
		showOrderItems('<%=getOrderItems%>');
		break;
	case 3:
		rcvOrder = new orderObj();
		showOrderItems('<%=getSentOrderItems%>');
		break;
	}
});

$(document).on("click",".newOrdBtn",function(){							//Called when a checkbox for a drug in "New Order" is marked
	var button = $(this);
	var drugIndex = parseInt(button.attr("for").substr(button.attr("id").indexOf("_")+1));
	$("#statusgif").show();
	
	var JSONobj = {"category": sideEl};
	var request = $.getJSON('<%=getDrugs%>', JSONobj);	
	request.done(function(data){
		$("#statusgif").hide();
		var id = data[drugIndex].id;
		var orderDrug = new drugObj(id, parseInt($("#amount_" + drugIndex).attr("value")));
		if (button.attr("aria-pressed")) {
			newOrder.push(orderDrug);
		}
		else
			newOrder.splice(getDrugIndex(orderDrug.drugid,newOrder),1);
	});	
});

$(document).on("click",".IncPackChkbox",function(){							//Called when a checkbox for a drug in "Incoming Package" is marked
	var checkbox = $(this);
	var drugIndex = parseInt(checkbox.attr("id").substr(checkbox.attr("id").indexOf("_")+1));
	$("#statusgif").show();
	var dbViewUri = "_design/" + clientDoc + "/_view/getSentOrdersItems";
	var request = $.getJSON(dbUrl + "/" + dbName + "/" + dbViewUri);	
	request.done(function(data){
		$("#statusgif").hide();
		var orderid = data.rows[sideEl-1].id;
		var drugid = data.rows[sideEl-1].value[drugIndex]._id;
		var orderDrug = new drugObj(drugid, parseInt($("#amount_" + drugIndex).attr("value")));
		if (checkbox.attr("checked"))
			rcvOrder.drugsInfo.push(orderDrug);
		else
			rcvOrder.drugsInfo.splice(getDrugIndex(orderDrug.drugid,rcvOrder.drugsInfo),1);
	});		
});

$(document).on("click",".UpdateStock", function() {
	
	$("#statusgif").show();
	
	var drugIndex = ($(this).attr("id").substr($(this).attr("id").indexOf("_")+1));
	var addAmount = parseInt($("#add_" + drugIndex).val());
	var reduceAmount = parseInt($("#reduce_" + drugIndex).val());
	
	var updateInfo = {};
	updateInfo["added"] = addAmount;
	updateInfo["reduced"] = reduceAmount;
	
	var sendUpdate = $.ajax('<%=updateStock%>', updateInfo);
	sendUpdate.done(function (msg){
		$("#statusgif").hide();
		console.log("update sent, success");
		////createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your update has been successfully sent!");		
	});
	sendUpdate.fail(function(error2){
		console.log("order failure");
		console.log(error2);
		////createDialog("notification","#error-message","ui-icon ui-icon-circle-check","An error occured while sending the update. Please try again");
	});	
});


/* <--------- Function calls ---------> */
 
 function loadDrugCategories () {											//Retrieves from DMA server the category names and displays them in side bar
	
	var url = '<%=getCategories%>';
	$("#statusgif").show();
	
	var request = jQuery.getJSON(url);
	request.done(function(data){
		var drugCat = new Array(data.length);
		for (var i in data)
			drugCat[i] = data[i];
		$("#statusgif").hide();
		drawSideCol("#sidecol",drugCat,"drugCategories");
		$("#side_0").click();
	});
	request.fail(function(jqXHR, textStatus) {
 		//createDialog("notification","#error-message","ui-icon ui-icon-alert","Connection to the DMA server is unavailable. Please try again later");
		$("#statusgif").attr("src","/css/custom-theme/images/important.gif");
	});
}

function showDrugs(category){ 														//Retrieves drug information from DB and displays it to the user
	
	$("#statusgif").show();
	var url = '<%=getDrugs%>';
	
	var catJSON;
	
	if (category != null) {
		catJSON = {"category": category};
	}
	var request = $.getJSON(url, catJSON);	
	request.done(function(data){
		$("#statusgif").hide();
		putTable("drugs_table",data.length,3);
		for (var i in data){
			$("#drugName_" + i).text(data[i].drugname);
			putDrVal("#unIssue",i,data[i].unitofissue);
			putDrVal("#drugForm",i,data[i].drugform);
			putDrVal("#stock",i,data[i].current);
			putDrVal("#price",i,data[i].price);
						
			var drugIndex = getDrugIndex(data[i].id,newOrder);
			if (drugIndex >= 0){
				$("#check_" + i + i).attr("aria-pressed",true); $("#check_" + i + i).addClass("ui-state-active"); $("#check_" + i).attr("checked",true);
				$("#amount_" + i).attr("value",newOrder[drugIndex].amount);
			}
			else
				$("#amount_" + i).attr("value",data[i].suggested);
		}
		
	});
}

function loadOrders(url){												//Retrieves from DMA server the orders and displays them in side bar
	
	$("#statusgif").show();
	var request = $.getJSON(url);
	request.done(function(data){
		if (data.length){
			var orderInfo = new Array(data.length);
			for (var i in data)
				orderInfo[i] = new ordSummaryObj(data[i].date,data[i].items,data[i].status);
			$("#statusgif").hide();
			drawSideCol("#sidecol",orderInfo,"Orders");
			$("#side_0").click();
		}else{
			//createDialog("notification","#notification-message","ui-icon ui-icon-info","There are no orders to show");	
			$("#Inventory").click();
		}
	});
}

function showOrderItems(url){											//Displays all of the items contained in the selected order
	$("#statusgif").show();
	
	
	
	var JSONobj = {"id": sideEl-1};
	var request = $.getJSON(url, JSONobj);
	request.done(function(data){
		$("#statusgif").hide();
		putTable("order",data.length,3);
		for (var i in data){
			$("#drugName_" + i).text(data[i].drugname);
			putDrVal("#unIssue",i,data[i].unitofissue);
			putDrVal("#drugForm",i,data[i].drugform);
			putDrVal("#price",i,data[i].price);
			putDrVal("#reqLbl",i,data[i].amount);
			putDrVal("#sentQty",i,data[i].amount);
			$("#amount_" + i).attr("value",data[i].amount);
			if (mod == 3)
				rcvOrder.orderid = data[sideEl-1].id;			
		}
	});
}

function showOrderSummary() {												//Displays the user with the order summary
	$("#statusgif").show();
	
	var url = '<%=getDrugs%>';
	console.log("new order: ");
	console.log(newOrder);
	putTable("order",newOrder.length,3);
	
	for (var i in newOrder) {
	
		var JSONobj = {"id": newOrder[i].drugid, "index": i};
		var request = $.getJSON(url, JSONobj);
		console.log("data for " + i);
		request.done(function(data){
			console.log(data);
			for (var j in data) {
				$("#drugName_" + data[j].index).text(data[j].drugname);
				putDrVal("#unIssue",data[j].index,data[j].unitofissue);
				putDrVal("#drugForm",data[j].index,data[j].drugform);
				putDrVal("#price",data[j].index,data[j].price);
				putDrVal("#reqLbl",data[j].index,newOrder[data[j].index].amount);
				break;
				$("#statusgif").hide();
			}
		});
	}
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
		.addClass("AddReduceTxt")
		.appendTo(addLeft);
		
		var addLblRight = $("<p>");
		addLblRight.text("items to stock")
		.attr("id","addLblLeft_" + r)
		.addClass("AddReduceTxt")
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
		.addClass("AddReduceTxt")
		.appendTo(reduceLeft);
		
		var reduceLblRight = $("<p>");
		reduceLblRight.text("items from stock")
		.attr("id","reduceLblLeft_" + r)
		.addClass("AddReduceTxt")
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
			updateBtn.appendTo(cell3);
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
				})
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
				})
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
	var dbViewUri = "_design/" + clientDoc + "/_view/getDrugs";
	/* TODO
	var request = $.getJSON(dbUrl + "/" + dbName + "/" + dbViewUri);
	request.done(function(data){
		putTable("InvSummary",rcvOrder.drugsInfo.length,3);
		for (var i in rcvOrder.drugsInfo){
			for (var j in data.rows){
				if (data.rows[j].id == rcvOrder.drugsInfo[i].drugid){
					$("#drugName_" + i).text(data.rows[j].value.drugname);
					putDrVal("#unIssue",i,data.rows[j].value.unitofissue);
					putDrVal("#drugForm",i,data.rows[j].value.drugform);
					putDrVal("#price",i,data.rows[j].value.price);
					putDrVal("#rcvQty",i,rcvOrder.drugsInfo[i].amount);
					putDrVal("#newStock",i,parseInt(getDrVal("#rcvQty",i))+parseInt(data.rows[j].value.current));
					break;
				}
			}
		}
		$("#statusgif").hide();
	});	*/
}



function sendOrder(){														//Sends order information to the DMA server
	$("#statusgif").show();
		console.log("sending order");
	
		var getDrugs = $.getJSON('<%=getDrugs%>');
		getDrugs.done(function(data){
			var orderToSend = {};
			orderToSend["author"] = "author";
			orderToSend["created_at"] = getDateFormat();
			orderToSend["facility"] = "facility";
			orderToSend["items"] = getOrderItems(data.rows);		
			orderToSend["status"] = "submitted";
			orderToSend["type"] = "order";
			
			var sendNewOrder = $.ajax('<%=sendOrder%>', orderToSend);
			sendNewOrder.done(function (msg){
				$("#statusgif").hide();
				console.log("order sent, success");
				////createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your order has been successfully sent!");
				newOrder = new Array();
				$("#newOrder").click();					
			});
			sendNewOrder.fail(function(error2){
				console.log("order failure");
				console.log(error2);
				////createDialog("notification","#error-message","ui-icon ui-icon-circle-check","An error occured while sending the order. Please try again");
				$("#newOrder").click();
			});			
		});
		getDrugs.fail(function(error2){
			console.log("getDrugs failed");
			////createDialog("notification","#error-message","ui-icon ui-icon-circle-check","An error occured while sending the order. Please try again");
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
	var dbViewUri = "_design/" + clientDoc + "/_view/getDrugs";
	/* TODO
	var request = $.getJSON(dbUrl + "/" + dbName + "/" + dbViewUri);	
	request.done(function(data){
		var drugs = "{\"docs\": [";
		var drugJson;
		for (var i in rcvOrder.drugsInfo){
			for (var j in data.rows){
				if (data.rows[j].id == rcvOrder.drugsInfo[i].drugid){
					drugJson = data.rows[j].value;
					drugJson.current = parseInt(drugJson.current) + parseInt(rcvOrder.drugsInfo[i].amount) + '';
					drugs = drugs.concat(JSON.stringify(drugJson))
				}
			}
		}
		drugs = drugs.replace(/}{/g,"},{");
		drugs = drugs.concat("]}");
		var updateDrugsDB = $.ajax({
			url: dbUrl + "/" + dbName + "/" + "_bulk_docs",
			type: "POST",
			processData: false,
			data: drugs	,
			contentType: "application/json"
		});
		updateDrugsDB.done(function (msg){
			$("#statusgif").hide();
			sendReport();
			changeOrderStatus("delivered");
			//createDialog("notification","#success-message","ui-icon ui-icon-circle-check","Your changes have been updated and a report has been sent");	
			$("#Inventory").click();
		});
		updateDrugsDB.fail(function (msg){
			//createDialog("notification","#error-message","ui-icon ui-icon-alert","Something went wrong and your changes were not updated. Please try again");
			$("#Inventory").click();
		});
	});	*/
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
	var dbViewUri = "_design/" + clientDoc + "/_view/orders";
	/* TODO
	var getOrders = $.getJSON(dbUrl + "/" + dbName + "/" + dbViewUri);	
	getOrders.done(function(data){
		var orders = data.rows;
		var order = orders[getOrderIndex(rcvOrder.orderid,orders)].value;
		var orderid = order._id;
		order.status = newStatus;
		var orderText = JSON.stringify(order);
		var changeStatus = $.ajax({
			url: dbUrl + "/" + dbName + "/" + orderid,
			type: "PUT",
			processData: false,
			data: orderText,
			contentType: "application/json"
		});		
		changeStatus.fail(function (msg){
			alert("Fail CoS:(\n" + msg);
		});
	}); */
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

function ordSummaryObj(date,items,status){
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
	for (var r = 0; r < info.length; r++){		
		var button = $("<input>");
		button
			.attr("id","sideBtn_" + r)
			.attr("type","radio")
			.attr("name","sideBtns");
		switch (type){
		case "drugCategories":		
			var label = $("<label>");
			label
				.attr("for","sideBtn_" + r)
				.attr("id","side_" + r)
				.addClass("sideBtn")
				.text(info[r]);
			break;
		case "Orders":
			var label = $("<label>");
			label
				.attr("for","sideBtn_" + r)
				.attr("id","side_" + r)
				.addClass("sideBtn")
				.text("Date: " + info[r].date +  " Items: " + info[r].items + " -Status: " + info[r].status);
			break;
		}
		button.appendTo(tbody);
		label.appendTo(tbody);
		$('#sidecol').buttonset();
	}
}
</script>