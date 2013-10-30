<%@ include file="/html/newportlet2/init.jsp" %>
<%@ page import="org.json.simple.JSONObject" %>
<%
String obj = (String) request.getAttribute("subCategories");
%>
<html>
<body>
<div>
Made it!
<script type="text/javascript">
console.log('<%=obj%>')</script>
</div>
</body>
</html>