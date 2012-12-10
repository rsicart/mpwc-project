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
//portlet permissions
String namePortlet = portletDisplay.getId(); //default value
String primKeyPortlet = "projectportlet"; //portlet name

//portlet actions available (see resource-actions/default.xml)
String permAddWorker = "ADD_WORKER_PROJECT";

%>

<h1><%= res.getString("jspshow.maintitle") %></h1>

<%
	long projectId = Long.valueOf( renderRequest.getParameter("projectId") );

	Project p = ProjectLocalServiceUtil.getProject(projectId);
	
	System.out.println("show.jsp projectId"+projectId+" - p projectId"+p.getProjectId());

%>

	<aui:layout>
 		
 	<aui:column columnWidth="50" first="true">
 	


		<p class="cooler-label"><%= res.getString("formlabel.projectname") %></p><p class="cooler-field"><%= p.getName() %></p>

		<p class="cooler-label"><%= res.getString("formlabel.projectdescshort") %></p><p class="cooler-field"><%= p.getDescShort() %></p>
		
   		<p class="cooler-label"><%= res.getString("formlabel.projectdescfull") %></p><p class="cooler-field"><%= p.getDescFull() %></p>

		<p class="cooler-label"><%= res.getString("formlabel.startdate") %></p><p class="cooler-field"><%= p.getStartDate() %></p>
		
		<p class="cooler-label"><%= res.getString("formlabel.enddate") %></p><p class="cooler-field"><%= p.getEndDate() %></p>
		
		<p class="cooler-label"><%= res.getString("formlabel.comments") %></p><p class="cooler-field"><%= p.getComments() %></p>
		
		<p class="cooler-label"><%= res.getString("formlabel.totaltimebox") %></p><p class="cooler-field"><%= ProjectLocalServiceUtil.totalizeTimeBoxs(p.getProjectId()) %></p>

	</aui:column>
	
	<aui:column columnWidth="50" last="true">
	
		<p class="cooler-label"><%= res.getString("formlabel.projecttype") %></p><p class="cooler-field"><%=p.getType() %></p>
		
		<% 
		ProjectStatus ps = ProjectStatusLocalServiceUtil.getProjectStatus(p.getProjectStatusId());
		String descStatus = "";
		System.out.println("locale:"+locale.toString());
		if(locale.equals("es-ES")){ descStatus = ps.getDesc_es_ES(); }
		else if(locale.equals("ca-ES")){ descStatus = ps.getDesc_ca_ES(); }
		else { descStatus = ps.getDesc_en_US(); }
		%>
		<p class="cooler-label"><%= res.getString("formlabel.status") %></p><p class="cooler-field"><%= descStatus %></p>
		
		<p class="cooler-label"><%= res.getString("formlabel.projectcostestimated") %></p><p class="cooler-field"><%= p.getCostEstimatedEuros() %></p>
		
		<p class="cooler-label"><%= res.getString("formlabel.projecttimeestimated") %></p><p class="cooler-field"><%= p.getTimeEstimatedHours() %></p>
		
	    <p class="cooler-label"><%= res.getString("formlabel.projectcansethours") %></p><p class="cooler-field"><%=p.getCanSetWorkerHours() %></p>
		
		<% 
		String pmName = res.getString("formlabel.noprojectmanager");
		try{
			if(p.getWorkerId()>0){
				Worker w = WorkerLocalServiceUtil.getWorker(p.getWorkerId());
				pmName = w.getSurname()+", "+w.getName();
			}

		} catch(Exception e){
			System.out.println("edit.jsp: can't read project manager");
		}
		%>
		<p class="cooler-label"><%= res.getString("formlabel.projectmanager") %></p>
		<p class="cooler-field"><strong><%= pmName %></strong></p>
			
		    
	</aui:column>
	
   </aui:layout>
   
   
	<aui:layout>
	
	<aui:column  first="true">
	
	<h2><%= res.getString("jspedit.project.workerlist") %></h2>
	<!-- project workers grid -->
	 
	<liferay-ui:search-container delta="5" emptyResultsMessage="jspedit-message-noworkers">
	
	<liferay-ui:search-container-results>
	<% 
	try{
		List<Worker> tempResults = ProjectLocalServiceUtil.getWorkers(p.getProjectId());
		//List<Worker> tempResults = ProjectLocalServiceUtil.getProjectWorkers(p.getProjectId());
		results = ListUtil.subList(tempResults, searchContainer.getStart(),searchContainer.getEnd());
		total = tempResults.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
		System.out.println("edit.jsp total: "+total);
	} catch(Exception e){
		System.out.println("edit.jsp exception: "+e.getMessage());
	}
	 %>	
	 </liferay-ui:search-container-results>
	 
	 <liferay-ui:search-container-row className="com.mpwc.model.Worker" keyProperty="workerId" modelVar="worker">
	 	<liferay-ui:search-container-column-text name="Name" property="name" />
	 	<liferay-ui:search-container-column-text name="Surame" property="surname" />
	 	<liferay-ui:search-container-column-text name="Email" property="email" />
	 </liferay-ui:search-container-row>
	 
	 <liferay-ui:search-iterator />
	 
	 </liferay-ui:search-container>
	 
	 <!-- end project workers grid -->
 	
 	</aui:column>		
 	
 	</aui:layout>	

   <aui:button-row>  	
   	<portlet:renderURL var="listURL">
    	<portlet:param name="mvcPath" value="/jsp/view.jsp" />
	</portlet:renderURL>
	<aui:button type="cancel" onClick="<%= listURL.toString() %>" />
   </aui:button-row>