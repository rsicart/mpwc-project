<!--  
/*

Copyright (c) 2012 Roger Sicart. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    (1) Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer. 

    (2) Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.  
    
    (3)The name of the author may not be used to
    endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
 
 */

/*
 * @author R.Sicart
 */
-->

<%@include file="/jsp/init.jsp"%>

<%
ResultRow row = (ResultRow) request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
Worker w = (Worker) row.getObject();
long groupId = themeDisplay.getLayout().getGroupId();
String name = Worker.class.getName();
String primKey = String.valueOf(w.getPrimaryKey());

//portlet permissions
String namePortlet = portletDisplay.getId(); //default value
String primKeyPortlet = "projectportlet"; //portlet name

//portlet actions available (see resource-actions/default.xml)
String permAddWorker = "ADD_WORKER_PROJECT";
String permDelWorker = "DELETE_WORKER_PROJECT";

String projectId = renderRequest.getParameter("projectId");

System.out.println("list_actions_edit.jsp:"+projectId);
%>

<c:if test='<%= PortletPermissionUtil.contains(permissionChecker, portletDisplay.getId(), "ADD_WORKER_PROJECT") %>'>

<liferay-ui:icon-menu>

	<portlet:actionURL var="addProjectWorkerURL" name="addProjectWorker">
		<portlet:param name="jspPage" value="/jsp/edit.jsp" />
		<portlet:param name="projectId" value="<%=projectId %>" />
		<portlet:param name="workerId" value="<%=primKey %>" />
	</portlet:actionURL>
	
	<liferay-ui:icon image="add" message="formlabel.actionadd" url="<%= addProjectWorkerURL.toString() %>" />

</liferay-ui:icon-menu>

</c:if>