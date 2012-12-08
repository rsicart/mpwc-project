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

<%@page import="com.mpwc.service.ProjectStatusLocalServiceUtil"%>
<%@include file="/jsp/init.jsp" %>

<% 
locale = request.getLocale();
String language = locale.getLanguage();
String country = locale.getCountry();

ResourceBundle res = ResourceBundle.getBundle("content.Language-ext", new Locale(language, country));

long groupId = themeDisplay.getLayout().getGroupId();
long userId = themeDisplay.getUserId();

//portlet permissions
String namePortlet = portletDisplay.getId(); //default value
String primKeyPortlet = "projectportlet"; //portlet name

//portlet actions available (see resource-actions/default.xml)
String permAddTimebox = "ADD_TIMEBOX";

Worker me = WorkerLocalServiceUtil.findByG_U_First(groupId, userId, null);

%>

<h1><%= res.getString("jspshowtimebox.maintitle") %></h1>

<%
	//get project data
	long projectId = Long.valueOf( renderRequest.getParameter("projectId") );
	Project p = ProjectLocalServiceUtil.getProject(projectId);
	
	System.out.println("show_timebox.jsp projectId"+projectId+" - p projectId"+p.getProjectId());

%>

	<aui:layout>

<% 
	//get my projects
	List<Project> projectList = WorkerLocalServiceUtil.getProjects(me.getWorkerId());
	
	//Begin My projects List
	for(Project myProject: projectList){
%>
	<aui:column>
	
	<h2><%= myProject.getName() %></h2>
	
	<!-- project timebox grid -->
	 
	<liferay-ui:search-container delta="5" emptyResultsMessage="jspshowtimebox-message-notimebox">
	
	<liferay-ui:search-container-results>
	<% 
	try{
		List<TimeBox> tempResults = TimeBoxLocalServiceUtil.findByProjectWorker(myProject.getProjectId(), me.getWorkerId());
		//List<Worker> tempResults = ProjectLocalServiceUtil.getProjectWorkers(p.getProjectId());
		results = ListUtil.subList(tempResults, searchContainer.getStart(),searchContainer.getEnd());
		total = tempResults.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
		System.out.println("show_timebox.jsp total: "+total);
	} catch(Exception e){
		System.out.println("show_timebox.jsp exception 1: "+e.getMessage());
	}
	 %>	
	 </liferay-ui:search-container-results>
	 
	 <liferay-ui:search-container-row className="com.mpwc.model.TimeBox" keyProperty="timeboxId" modelVar="timeBox">
	 	<liferay-ui:search-container-column-text name="Date" property="dedicationDate" />
	 	<liferay-ui:search-container-column-text name="Minutes" property="minutes" />
	 	<liferay-ui:search-container-column-text name="Comments" property="comments" />
	 </liferay-ui:search-container-row>
	 
	 <liferay-ui:search-iterator />
	 
	 </liferay-ui:search-container>
	 
	 <!-- end project timebox grid -->
	
	</aui:column>			
<%
	//END My projects List
}
%>		
 	
 	</aui:layout>
 	
<% 
System.out.println("MpwcManager? "+request.isUserInRole("MpwcManager")+" MpwcUser?"+request.isUserInRole("MpwcUser"));

//ONLY admins

if(request.isUserInRole("MpwcManager")){
%>
	<aui:layout>
	
	<aui:column  first="true">
	
	<h2><%= res.getString("jspedit.project.workerlist") %></h2>
	
	<!-- workers grid -->
	 
	<liferay-ui:search-container delta="5" emptyResultsMessage="jspedit-message-noworkers">
	
	<liferay-ui:search-container-results>
	<% 
	try{
		List<Worker> workerResults = WorkerLocalServiceUtil.getWorkersByFilters(null, null, null, null, null, null);
		//List<Worker> tempResults = ProjectLocalServiceUtil.getProjectWorkers(p.getProjectId());
		results = ListUtil.subList(workerResults, searchContainer.getStart(),searchContainer.getEnd());
		total = workerResults.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
		System.out.println("show_timebox.jsp total: "+total);
	} catch(Exception e){
		System.out.println("show_timebox.jsp exception 2: "+e.getMessage());
	}
	 %>	
	 </liferay-ui:search-container-results>
	 
	 <liferay-ui:search-container-row className="com.mpwc.model.Worker" keyProperty="workerId" modelVar="worker">
	 	<liferay-ui:search-container-column-text name="Name" property="name" />
	 	<liferay-ui:search-container-column-text name="Surame" property="surname" />
	 	<liferay-ui:search-container-column-text name="Nif" property="nif" />
	 	<liferay-ui:search-container-column-text name="Email" property="email" />
	 </liferay-ui:search-container-row>
	 
	 <liferay-ui:search-iterator />
	 
	 </liferay-ui:search-container>
	 
	 <!-- end workers grid -->
 	
 	</aui:column>		
 	
 	</aui:layout>
<%
}
%>	


<portlet:renderURL var="listURL">
    <portlet:param name="mvcPath" value="/jsp/view.jsp" />
</portlet:renderURL>

<p><a href="<%= listURL %>">&larr; Back</a></p>