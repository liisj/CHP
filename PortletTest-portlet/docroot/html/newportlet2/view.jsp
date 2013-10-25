<%@ include file="/html/newportlet2/init.jsp" %>

<portlet:renderURL var="DMAurl">
        <portlet:param name="jspPage" value="/html/newportlet2/DMA.jsp"/>
</portlet:renderURL>
<portlet:renderURL var="trainingURL">
        <portlet:param name="jspPage" value="/html/newportlet2/training.jsp"/>
</portlet:renderURL>

<div class="buttonLink"> 
<br/><a href="<%= DMAurl %>">Drug Management Application</a>
</div>
<p/>
<div class="buttonLink">
<br/><a href="<%= trainingURL %>">On-the-job training</a>
</div>

<!--<aui:form action="<%= DMAurl %>">
    <input type="submit" value="DMA">
</aui:form>-->
