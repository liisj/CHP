<%@ include file="/html/newportlet2/init.jsp" %>
 <portlet:actionURL name="getCategories" var="getCategories"
	windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
	<portlet:param name="ajaxAction" value="getData"></portlet:param>
</portlet:actionURL>

 <script type="text/javascript">
 function loadDrugCategories () {											//Retrieves from DMA server the category names and displays them in side bar
	console.log("drug categories new");
	var url = '<%=getCategories%>';
	$("#statusgif").show();
	
	var request = jQuery.getJSON(url);
	request.done(function(data){
		$("#statusgif").hide();
		drawSideCol("#sidecol",data,"drugCategories");
		$("#side_0").click();
	});
	request.fail(function(jqXHR, textStatus) {
 		//createDialog("notification","#error-message","ui-icon ui-icon-alert","Connection to the DMA server is unavailable. Please try again later");
		$("#statusgif").attr("src","/css/custom-theme/images/important.gif");
	});
}
</script>