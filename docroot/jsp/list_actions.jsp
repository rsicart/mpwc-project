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
Project p = (Project) row.getObject();
long groupId = themeDisplay.getLayout().getGroupId();
String name = Project.class.getName();
String primKey = String.valueOf(p.getPrimaryKey());

System.out.println("Permiso addTimebox:"+PortletPermissionUtil.contains(permissionChecker, portletDisplay.getId(), "ADD_TIMEBOX")+" - MpwcUser? "+request.isUserInRole("MpwcUser")+ " - portletId: "+portletDisplay.getId());
%>

<liferay-ui:icon-menu>

	<portlet:renderURL var="showURL">
		<portlet:param name="jspPage" value="/jsp/show.jsp" />
		<portlet:param name="projectId" value="<%=primKey %>" />
	</portlet:renderURL>
	
	<liferay-ui:icon image="edit" message="formlabel.actionshow" url="<%= showURL.toString() %>" />

<c:if test="<%= permissionChecker.hasPermission(groupId, name, primKey, ActionKeys.UPDATE) %>">
	<portlet:renderURL var="editURL">
		<portlet:param name="jspPage" value="/jsp/edit.jsp" />
		<portlet:param name="projectId" value="<%=primKey %>" />
	</portlet:renderURL>
	
	<liferay-ui:icon image="edit" message="formlabel.actionedit" url="<%= editURL.toString() %>" />
</c:if>

<c:if test="<%= permissionChecker.hasPermission(groupId, name, primKey, ActionKeys.DELETE) %>">
	<portlet:actionURL name="deleteProject" var="deleteURL">
		<portlet:param name="projectId" value="<%=primKey %>" />
		<portlet:param name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>" />
	</portlet:actionURL>
	
	<liferay-ui:icon-delete url="<%= deleteURL.toString() %>" message="formlabel.actiondelete" />
</c:if>

<% 
//show only if workers can add timebox to project
if(p.getCanSetWorkerHours() == true){
%>
	<c:if test='<%= PortletPermissionUtil.contains(permissionChecker, portletDisplay.getId(), "ADD_TIMEBOX") %>'>
	
		<portlet:actionURL var="addTimeBoxURL" name="preAddTimeBox">
			<portlet:param name="jspPage" value="/jsp/add_timebox.jsp" />
			<portlet:param name="projectId" value="<%=primKey %>" />
		</portlet:actionURL>
		
		<liferay-ui:icon image="add" message="formlabel.actionaddtimebox" url="<%= addTimeBoxURL.toString() %>" />	
	</c:if>
	
	<c:if test='<%= PortletPermissionUtil.contains(permissionChecker, portletDisplay.getId(), "VIEW_TIMEBOX") %>'>
		<portlet:renderURL var="showTimeBoxURL">
			<portlet:param name="jspPage" value="/jsp/show_timebox.jsp" />
			<portlet:param name="projectId" value="<%=primKey %>" />
		</portlet:renderURL>
		
		<liferay-ui:icon image="view" message="formlabel.actionshowtimebox" url="<%= showTimeBoxURL.toString() %>" />
	</c:if>
<% } %>
</liferay-ui:icon-menu>