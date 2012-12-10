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

//bean create
TimeBox tbBean = TimeBoxLocalServiceUtil.createTimeBox(0);

//get project data
long projectId = Long.valueOf( renderRequest.getParameter("projectId") );
Project p = ProjectLocalServiceUtil.getProject(projectId);

//searchContainer iteratorURL
PortletURL iteratorURL = renderResponse.createRenderURL();
iteratorURL.setParameter("jspPage", "/jsp/show_timebox.jsp");
iteratorURL.setParameter("projectId", Long.toString(projectId));

%>

<h1><%= res.getString("jspshowtimebox.maintitle") %></h1>

<%
	
	System.out.println("show_timebox.jsp projectId"+projectId+" - p projectId"+p.getProjectId());

%>

	<aui:layout>

	<h2 class="cooler-label"><%= p.getName() %></h2>

	<aui:column columnWidth="75">	
		
		<!-- project timebox grid -->
		 
		<liferay-ui:search-container iteratorURL="<%= iteratorURL %>"  curParam="timeboxCurParam" delta="10" emptyResultsMessage="jspshowtimebox-message-notimebox">
		
		<liferay-ui:search-container-results>
		<% 
		results = null;
		total = -1;
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
		
		try{
			System.out.println("search1:"+ searchContainer.getCurParam()+" - "+searchContainer.getIteratorURL());
			
			List<TimeBox> tbResults = TimeBoxLocalServiceUtil.findByProjectWorker(p.getProjectId(), me.getWorkerId());
			//List<Worker> tempResults = ProjectLocalServiceUtil.getProjectWorkers(p.getProjectId());
			results = ListUtil.subList(tbResults, searchContainer.getStart(),searchContainer.getEnd());
			total = tbResults.size();
			pageContext.setAttribute("results", results);
			pageContext.setAttribute("total",total);
			System.out.println("show_timebox.jsp total 1: "+total);
		} catch(Exception e){
			System.out.println("show_timebox.jsp exception 1: "+e.getMessage());
		}
		 %>	
		 </liferay-ui:search-container-results>
		 
		 <liferay-ui:search-container-row className="com.mpwc.model.TimeBox" keyProperty="timeboxId" modelVar="timeBox">
		 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.dedicationdate") %>' property="dedicationDate" />
		 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.minutes") %>' property="minutes" />
		 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.comments") %>' property="comments" />
		 	<liferay-ui:search-container-column-jsp path="/jsp/list_actions_timebox.jsp" align="right" />
		 </liferay-ui:search-container-row>
		 
		 <liferay-ui:search-iterator />
		 
		 </liferay-ui:search-container>
		 
		 <!-- end project timebox grid -->
	
	</aui:column>
	
	
	<aui:column>
	
		<p class="cooler-label"><%= res.getString("formlabel.totaltimebox") %></p>
		<%
			long totalMin = TimeBoxLocalServiceUtil.totalizeTimeboxByProjectWorker(p.getProjectId(), me.getWorkerId());
		%>
		<p class="cooler-field"><%= totalMin %></p>
		
		
		<p class="cooler-label"><b><%= res.getString("jspaddtimebox.maintitle") %></b></p>
			
		<% 
			PortletURL rUrl = renderResponse.createRenderURL();
			rUrl.setParameter("jspPage", "/jsp/show_timebox.jsp");
			rUrl.setParameter("projectId", Long.toString(p.getProjectId()));
			//System.out.println("redirecURL:"+rUrl); 
		%>
		<portlet:actionURL var="addTimeBoxURL" name="addTimeBox">
			<portlet:param name="redirectURL" value="<%= rUrl.toString() %>" />
		</portlet:actionURL>
		
		
		
		<aui:form name="frm_add_timebox" action="<%= addTimeBoxURL %>" method="post">
			
			<aui:input type="hidden" name="redirectURL" value="<%= rUrl.toString() %>"/>
			<aui:input type="hidden" name="projectId" value="<%= projectId %>"/>
		 	
		 		<aui:fieldset>
		
					<aui:input label='<%= res.getString("formlabel.minutes") %>' name="minutes" type="text" value="">
						<aui:validator name="required" />
						<aui:validator name="digits" />
					</aui:input>
					
					<aui:input label='<%= res.getString("formlabel.comments") %>' name="comments" type="textarea" value="" >
			     		<aui:validator name="custom" errorMessage="error-character-not-valid">
						    function(val, fieldNode, ruleValue) { var patt=/[a-zA-Z0-9 ,'-]{0,100}/g; return (patt.test(val) ) }
						</aui:validator>
					</aui:input>
					
					<% 
					Calendar dedicationDate = CalendarFactoryUtil.getCalendar();
					dedicationDate.setTime(dedicationDate.getTime());
					%>
					<aui:input label='<%= res.getString("formlabel.dedicationdate") %>' name="dedicationDate" model="<%= TimeBox.class %>" bean="<%= tbBean %>" value="<%= dedicationDate %>" />
					
					<aui:button type="submit" value='<%= res.getString("formlabel.actionadd") %>' />
					
				</aui:fieldset>	   
		   
		</aui:form>
	
	</aui:column>				
 	
 	</aui:layout>
 	
<% 
System.out.println("MpwcManager? "+request.isUserInRole("MpwcManager")+" MpwcUser?"+request.isUserInRole("MpwcUser"));

//ONLY admins

if(request.isUserInRole("MpwcManager")){
%>
	<aui:layout>
	
	<aui:column  first="true">
	
	<h2 class="cooler-label"><%= res.getString("jspedit.project.workerlist") %></h2>
	
	<!-- workers grid -->
		 
	<liferay-ui:search-container iteratorURL="<%= iteratorURL %>"  curParam="workerCurParam" delta="20" emptyResultsMessage="jspedit-message-noworkers">
	
	<liferay-ui:search-container-results>
	<% 
	try{
		System.out.println("search2:"+ searchContainer.getCurParam()+" - "+searchContainer.getIteratorURL());
		
		//List<Worker> workerResults = WorkerLocalServiceUtil.getWorkersByFilters(null, null, null, null, null, null);
		List<Worker> workerResults = ProjectLocalServiceUtil.getProjectWorkers(p.getProjectId());
		results = ListUtil.subList(workerResults, searchContainer.getStart(),searchContainer.getEnd());
		total = workerResults.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
		System.out.println("show_timebox.jsp total 2: "+total);
	} catch(Exception e){
		System.out.println("show_timebox.jsp exception 2: "+e.getMessage());
	}
	 %>	
	 </liferay-ui:search-container-results>
	 
	 <liferay-ui:search-container-row className="com.mpwc.model.Worker" keyProperty="workerId" modelVar="worker">
	 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.name") %>' property="name" />
	 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.surname") %>' property="surname" />
	 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.nif") %>' property="nif" />
	 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.email") %>' property="email" />
	 	<liferay-ui:search-container-column-text name='<%= res.getString("formlabel.minutes") %>'>
	 	<%
	 	long totalMin = 0;
	 	try{
			totalMin = TimeBoxLocalServiceUtil.totalizeTimeboxByProjectWorker(p.getProjectId(), worker.getWorkerId());
			System.out.println("show_timebox.jsp row prooject id:"+p.getProjectId()+"-worker:"+worker.getWorkerId());
	 	} catch(Exception e){
	 		totalMin = -1;
	 		System.out.println("show_timebox.jsp col min:"+e.getMessage());
	 	}
		%>
		<%= totalMin %>
	 	</liferay-ui:search-container-column-text>
	 </liferay-ui:search-container-row>
	 
	 <liferay-ui:search-iterator />
	 
	 </liferay-ui:search-container>
	 
	 <!-- end workers grid -->
 	
 	</aui:column>		
 	
 	</aui:layout>
<%
}
%>	


   <aui:button-row>  	
   	<portlet:renderURL var="listURL">
    	<portlet:param name="mvcPath" value="/jsp/view.jsp" />
	</portlet:renderURL>
	<aui:button type="cancel" onClick="<%= listURL.toString() %>" />
   </aui:button-row>