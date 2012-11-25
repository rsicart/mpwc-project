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
%>

<p><b><%= res.getString("jspedit.maintitle") %></b></p>

<%
	long projectId = Long.valueOf( renderRequest.getParameter("projectId") );

	Project p = ProjectLocalServiceUtil.getProject(projectId);
	
	System.out.println("edit.jsp projectId"+projectId+" - p projectId"+p.getProjectId());

%>

<portlet:actionURL var="editProjectURL" name="editProject">
    <portlet:param name="mvcPath" value="/jsp/view.jsp" />
    <portlet:param name="projectId" value="<%= String.valueOf( p.getProjectId() ) %>" />
</portlet:actionURL>

<aui:form action="<%= editProjectURL %>" method="post">
	
	<aui:input type="hidden" name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>"/>

	<aui:layout>
 		
 	<aui:column columnWidth="50" first="true">
 	
 		<aui:fieldset>

			<aui:input label='<%= res.getString("formlabel.projectname") %>' name="name" type="text" value="<%= p.getName() %>">
				<aui:validator name="required" />
				<aui:validator name="custom" errorMessage="error-character-not-valid">
				    function(val, fieldNode, ruleValue) { var patt=/[a-zA-Z0-9 ,'-]{1,100}/g; return (patt.test(val) ) }
				</aui:validator>
			</aui:input>
	
			<aui:input label='<%= res.getString("formlabel.projectdescshort") %>' name="descshort" type="text" value="<%= p.getDescShort() %>" >
				<aui:validator name="required" />
				<aui:validator name="custom" errorMessage="error-character-not-valid">
				    function(val, fieldNode, ruleValue) { var patt=/[a-zA-Z0-9 ,'-]{1,100}/g; return (patt.test(val) ) }
				</aui:validator>
			</aui:input>
			
	   		<aui:input label='<%= res.getString("formlabel.projectdescfull") %>' type="textarea" name="descfull" value="<%= p.getDescFull() %>" >
				<!-- Only allow alphanumeric format -->
	     		<aui:validator name="custom" errorMessage="error-character-not-valid">
				    function(val, fieldNode, ruleValue) { var patt=/[a-zA-Z0-9 ,'-]{0,100}/g; return (patt.test(val) ) }
				</aui:validator>
			</aui:input>
			
			<% 
			Calendar startDate = CalendarFactoryUtil.getCalendar();
			startDate.setTime(p.getStartDate());
			%>
			<aui:input label='<%= res.getString("formlabel.startdate") %>' name="startDate" model="<%= Project.class %>" bean="<%= p %>" value="<%= startDate %>" />
			
			<% 
			Calendar endDate = CalendarFactoryUtil.getCalendar();
			endDate.setTime(p.getEndDate());
			%>
			<aui:input label='<%= res.getString("formlabel.enddate") %>' name="endDate" model="<%= Project.class %>" bean="<%= p %>" value="<%= endDate %>" />
			
			<aui:input label='<%= res.getString("formlabel.comments") %>' name="comments" type="text" value="<%= p.getComments() %>" >
	     		<aui:validator name="custom" errorMessage="error-character-not-valid">
				    function(val, fieldNode, ruleValue) { var patt=/[a-zA-Z0-9 ,'-]{0,100}/g; return (patt.test(val) ) }
				</aui:validator>
			</aui:input>
			
		</aui:fieldset>
	
	</aui:column>
	
	<aui:column columnWidth="50" last="true">
	
		<aui:fieldset>
		
			<aui:select label='<%= res.getString("formlabel.projecttype") %>' name="type">
				<%
					boolean selTypeProject = false, selTypeService = false;
					if(p.getType() != null){
						if(p.getType().equals("project")){
							selTypeProject = true;
						} else if( p.getType().equals("service") ){
							selTypeService = true;
						}
					}
				%>
				<aui:option value="-1">
					<liferay-ui:message key="please-choose" />
				</aui:option>
				<aui:option value="project" selected="<%= selTypeProject %>">
					<liferay-ui:message key="form-option-type-project" />
				</aui:option>
				<aui:option value="service" selected="<%= selTypeService %>">
					<liferay-ui:message key="form-option-type-service" />
				</aui:option>
			</aui:select>
			
			<aui:select label='<%= res.getString("formlabel.status") %>' name="status">
				<aui:option value="-1">
					<liferay-ui:message key="please-choose" />
				</aui:option>
				<aui:option label='<%= res.getString("formlabel.option.active") %>' value="1"></aui:option>
				<aui:option label='<%= res.getString("formlabel.option.inactive") %>' value="2"></aui:option>
				<aui:option label='<%= res.getString("formlabel.option.bloqued") %>' value="3"></aui:option>
			</aui:select>
			
			<aui:input label='<%= res.getString("formlabel.projectcostestimated") %>' name="costestimatedeuros" type="text" value="<%= p.getCostEstimatedEuros() %>" >
				<!-- Only allow numeric format -->
	     		<aui:validator name="number" />
			</aui:input>
			
			<aui:input label='<%= res.getString("formlabel.projecttimeestimated") %>' name="timeestimatedhours" type="text" value="<%= p.getTimeEstimatedHours() %>" >
				<!-- Only allow numeric format -->
	     		<aui:validator name="number" />
			</aui:input>
			
		    <aui:select label='<%= res.getString("formlabel.projectcansethours") %>' name="cansetworkerhours">
		    	
				<aui:option value="-1" >
					<liferay-ui:message key="please-choose" />
				</aui:option>
				<aui:option value="false" >
					<liferay-ui:message key="form-option-no" />
				</aui:option>
				<aui:option value="true" >
					<liferay-ui:message key="form-option-yes" />
				</aui:option>
			</aui:select>
			
		</aui:fieldset>
		    
	</aui:column>
	
   </aui:layout>

   <aui:button type="submit" />
</aui:form>


<portlet:renderURL var="listURL">
    <portlet:param name="mvcPath" value="/jsp/view.jsp" />
</portlet:renderURL>

<p><a href="<%= listURL %>">&larr; Back</a></p>