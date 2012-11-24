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
 String permAddProject = "ADD_PROJECT";
 String permUpdateProject = "UPDATE_PROJECT";
 String permDeleteProject = "DELETE_PROJECT";
 
 Project ftrProject = ProjectLocalServiceUtil.createProject(0);
 
 //get search filters if necessary
 String ftrName = "";
 String ftrType = "";
 String ftrDescShort = "";
 String ftrStatus = "";
 Date ftrStartDate = new Date();
 Date ftrEndDate = new Date();
 Double ftrCostEstimatedEuros = 0.0;
 long ftrTimeEstimatedHours = 0;
 boolean ftrCanSetWorkerHours = false;
 
 
 Enumeration<String> sessionParams = request.getSession().getAttributeNames();
 while(sessionParams.hasMoreElements()){
	 String attributeName = (String) sessionParams.nextElement();
	 String decodedName = PortletSessionUtil.decodeAttributeName(attributeName);
	 if(decodedName.equals("ftrName") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrName = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrType") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrType = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrDescShort") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrDescShort = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrStatus") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrStatus = (String)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrStartDate") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrStartDate = (Date)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrEndDate") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrEndDate = (Date)session.getAttribute(attributeName);
	 }
	 if(decodedName.equals("ftrCostEstimatedEuros") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrCostEstimatedEuros = Double.valueOf( (String)session.getAttribute(attributeName) );
	 }
	 if(decodedName.equals("ftrTimeEstimatedHours") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrTimeEstimatedHours = Long.valueOf( (String) session.getAttribute(attributeName) );
	 }
	 if(decodedName.equals("ftrCanSetHoursWorkers") && PortletSessionUtil.decodeScope(attributeName)==PortletSession.PORTLET_SCOPE){
		 ftrCanSetWorkerHours = Boolean.valueOf( (String) session.getAttribute(attributeName) );
	 }
 }
 
 
 String error2 = "";
 try{
	 %>
	
	<portlet:actionURL var="preAddProjectURL" name="preAddProject">
		<portlet:param name="jspPage" value="/jsp/add.jsp"/>
	</portlet:actionURL>
	
	<portlet:actionURL var="filterURL" name="getProjectsByFilters">
	   <portlet:param name="mvcPath" value="/jsp/view.jsp" />
	</portlet:actionURL>
	
	<aui:form name="frm_list_projects" action="<%= filterURL %>" method="post">
	
		<aui:input type="hidden" name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>"/>
			
		<aui:layout>
		
		<aui:column columnWidth="20" first="true">
		
		<aui:fieldset>
		
			<aui:input label='<%= res.getString("formlabel.name") %>' id="ftrname" name="ftrname" type="text" value="<%= ftrName %>">
				<!-- Only allow alphabetical characters -->
	     		<aui:validator name="alpha" />
			</aui:input>
	
			<aui:input label='<%= res.getString("formlabel.projectdescshort") %>' id="ftrdescshort" name="ftrdescshort" type="text" value="<%= ftrDescShort %>" >
				<aui:validator name="custom" errorMessage="error-character-not-valid">
				    function(val, fieldNode, ruleValue) { var patt=/[a-zA-Z0-9 ,'-]{0,100}/g; return (patt.test(val) ) }
				</aui:validator>
			</aui:input>
			
			<aui:input label='<%= res.getString("formlabel.projectcostestimated") %>' id="ftrcostestimatedeuros" name="ftrcostestimatedeuros" type="text" value="<%= ftrCostEstimatedEuros %>" >
	     		<aui:validator name="number" />
			</aui:input>
			
			<aui:input label='<%= res.getString("formlabel.projecttimeestimated") %>' id="ftrtimeestimatedhours" name="ftrtimeestimatedhours" type="text" value="<%= ftrTimeEstimatedHours %>" >
	     		<aui:validator name="number" />
			</aui:input>
		    
		</aui:fieldset>
		
		</aui:column>
		
		<aui:column columnWidth="20">
		
		<aui:fieldset>
			
			<% 
			 //TODO: save selected option
			%>
			<aui:select label='<%= res.getString("formlabel.projecttype") %>' id="ftrtype" name="ftrtype">
				<aui:option value="-1">
					<liferay-ui:message key="please-choose" />
				</aui:option>
				<aui:option value="1">
					<liferay-ui:message key="form-option-type-project" />
				</aui:option>
				<aui:option value="2">
					<liferay-ui:message key="form-option-type-service" />
				</aui:option>
			</aui:select>
			
			<% 
			 //TODO: save selected option
			%>
		    <aui:select label='<%= res.getString("formlabel.status") %>' id="ftrstatus" name="ftrstatus">
				<aui:option value="-1">
					<liferay-ui:message key="please-choose" />
				</aui:option>
				<aui:option label='<%= res.getString("formlabel.option.active") %>' value="1"></aui:option>
				<aui:option label='<%= res.getString("formlabel.option.inactive") %>' value="2"></aui:option>
				<aui:option label='<%= res.getString("formlabel.option.bloqued") %>' value="3"></aui:option>
			</aui:select>
			
		</aui:fieldset>
		
		</aui:column>
		
		<aui:column columnWidth="30">
		<aui:fieldset>
		    <% 
			Calendar startDate = CalendarFactoryUtil.getCalendar();
		    if(ftrStartDate != null){
		    	startDate.setTime(ftrStartDate);
		    }
		    else{
				startDate.setTime(startDate.getTime());
		    }
		    System.out.println("view.jsp ftrStartDate:"+ftrStartDate+" - startDate:"+startDate.toString());
			%>
			<aui:input label='<%= res.getString("formlabel.startdate") %>' name="startDate" model="<%= Project.class %>" value="<%= startDate %>" />
			
			
			<% 
			Calendar endDate = CalendarFactoryUtil.getCalendar();
			if(ftrEndDate != null){
		    	endDate.setTime(ftrEndDate);
		    }
		    else{
				endDate.setTime(endDate.getTime());
		    }
			System.out.println("view.jsp ftrEndDate:"+ftrEndDate+" - endDate:"+endDate.toString());
			%>
			<aui:input label='<%= res.getString("formlabel.enddate") %>' name="endDate" model="<%= Project.class %>" value="<%= endDate %>" />
					
		</aui:fieldset>
		</aui:column>

		<aui:column columnWidth="30" last="true">
		<aui:fieldset>
		    
			
			
			<% 
			 //TODO: save selected option
			%>
		    <aui:select label='<%= res.getString("formlabel.projectcansethours") %>' id="ftrcansetworkerhours" name="ftrcansetworkerhours">
				<aui:option value="-1">
					<liferay-ui:message key="please-choose" />
				</aui:option>
				<aui:option value="0">
					<liferay-ui:message key="form-option-no" />
				</aui:option>
				<aui:option value="1">
					<liferay-ui:message key="form-option-yes" />
				</aui:option>
			</aui:select>
			
			<aui:button type="submit" id="btn_filter" value='<%= res.getString("formlabel.actionfilter") %>' />
					
		</aui:fieldset>
		</aui:column>
			
	</aui:layout>
	
	</aui:form>
	
	<aui:layout>
	
	<aui:column columnWidth="80" first="true">
	
	<!-- grid -->
	 
	<liferay-ui:search-container delta="5">
	
	<liferay-ui:search-container-results>
	<% 
		//List<Project> tempResults = ProjectLocalServiceUtil.getWorkersByFilters(ftrName, ftrType, ftrDescShort, ftrStartDate.toString(), ftrEndDate.toString(), ftrCostEstimated, ftrTimeEstimated, ftrCanSetWorkerHours, ftrStatus);
		List<Project> tempResults = ProjectLocalServiceUtil.getProjects(0, 100);
		results = ListUtil.subList(tempResults, searchContainer.getStart(),searchContainer.getEnd());
		total = tempResults.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
	 %>	
	 </liferay-ui:search-container-results>
	 
	 <liferay-ui:search-container-row className="com.mpwc.model.Project" keyProperty="projectId" modelVar="project">
	 	<liferay-ui:search-container-column-text name="Name" property="name" />
	 	<liferay-ui:search-container-column-text name="Type" property="type" />
	 	<liferay-ui:search-container-column-text name="Desc. Short" property="descShort" />
	 	<liferay-ui:search-container-column-text name="Start Date" property="startDate" />
	 	<liferay-ui:search-container-column-text name="End Date" property="endDate" />
	 	<liferay-ui:search-container-column-text name="Status" property="projectStatusId" />
	 	<liferay-ui:search-container-column-text name="Cost estimated (EUR)" property="costEstimatedEuros" />
	 	<liferay-ui:search-container-column-text name="Time estimated (Hours)" property="timeEstimatedHours" />
	 	<liferay-ui:search-container-column-text name="Time set?" property="canSetWorkerHours" />
	 	<liferay-ui:search-container-column-jsp path="/jsp/list_actions.jsp" align="right" />
	 </liferay-ui:search-container-row>
	 
	 <liferay-ui:search-iterator />
	 
	 </liferay-ui:search-container>
	 
	 <!-- end grid -->
 	
 	</aui:column>	
 	
 	</aui:layout>
 	
 	<aui:layout>	
 	
 	<aui:column columnWidth="20" last="true">
 	
 		<aui:form name="frm_add_project" action="<%= preAddProjectURL %>" method="post">
 	
	 	<aui:fieldset>
	 	
	 	<c:if test="<%= permissionChecker.hasPermission(groupId, namePortlet, primKeyPortlet, permAddProject) %>">
	 		<aui:button type="submit" id="btn_add" value='<%= res.getString("formlabel.actionadd") %>' inlineField="false" />
	 	</c:if> 	
	 	
	 	</aui:fieldset>
	 	
	 	</aui:form>	
 	
 	</aui:column>
 	
 	</aui:layout>	

	 <%
 } catch (Exception e2) {
		error2 = e2.getMessage();
		System.out.println("Error2 view.jsp: "+error2);
 }
%>
