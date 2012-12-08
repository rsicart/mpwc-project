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

long projectId = Long.valueOf( renderRequest.getParameter("projectId") );

//if defined, used to say to portlet action where to go after 
String redirectURL = renderRequest.getParameter("redirectURL");

//get timebox data
long tbId = Long.valueOf( renderRequest.getParameter("timeBoxId") );
TimeBox tb = TimeBoxLocalServiceUtil.getTimeBox(tbId);

%>

<h2 class="cooler-field"><b><%= res.getString("jspedittimebox.maintitle") %></b></h2>

<portlet:actionURL var="editTimeBoxURL" name="editTimeBox">
	<portlet:param name="redirectURL" value="<%= redirectURL %>" />
    <portlet:param name="jspPage" value="/jsp/show_timebox.jsp" />
    <portlet:param name="projectId" value="<%= Long.toString(projectId) %>" />
</portlet:actionURL>

<aui:form name="frm_edit_timebox" action="<%= editTimeBoxURL %>" method="post">
	
	<aui:input type="hidden" name="redirectURL" value="<%= redirectURL %>"/>
	<aui:input type="hidden" name="projectId" value="<%= projectId %>"/>
	<aui:input type="hidden" name="timeBoxId" value="<%= tbId %>"/>

	<aui:layout>
 		
 	<aui:column columnWidth="50" first="true">
 	
 		<aui:fieldset>

			<aui:input label='<%= res.getString("formlabel.minutes") %>' name="minutes" type="text" value="<%= tb.getMinutes() %>">
				<aui:validator name="required" />
				<aui:validator name="digits" />
			</aui:input>
			
			<aui:input label='<%= res.getString("formlabel.comments") %>' name="comments" type="textarea" value="<%= tb.getComments() %>" >
	     		<aui:validator name="custom" errorMessage="error-character-not-valid">
				    function(val, fieldNode, ruleValue) { var patt=/[a-zA-Z0-9 ,'-]{0,100}/g; return (patt.test(val) ) }
				</aui:validator>
			</aui:input>
			
			<% 
			Calendar dedicationDate = CalendarFactoryUtil.getCalendar();
			dedicationDate.setTime(tb.getDedicationDate());
			%>
			<aui:input label='<%= res.getString("formlabel.dedicationdate") %>' name="dedicationDate" model="<%= TimeBox.class %>" bean="<%= tb %>" value="<%= dedicationDate %>" />
			
		</aui:fieldset>
	
	</aui:column>
	
	<aui:column columnWidth="50" last="true">
	
		<aui:fieldset>
		
			
		</aui:fieldset>
		    
	</aui:column>
	
   </aui:layout>
   
   <aui:button type="submit" value="<%= res.getString("formlabel.actionadd") %>" />
   
   
	<portlet:actionURL name="deleteTimeBox" var="deleteURL">
		<portlet:param name="projectId" value="<%= Long.toString(projectId) %>" />
		<portlet:param name="timeBoxId" value="<%= Long.toString(tbId) %>" />
		<portlet:param name="redirectURL" value="<%= redirectURL.toString() %>" />
	</portlet:actionURL>
   <aui:button type="button" name="btn_delete" value="<%= res.getString("formlabel.actiondelete") %>" onClick="<%= deleteURL.toString() %>" />
   
</aui:form>


<portlet:renderURL var="listURL">
    <portlet:param name="mvcPath" value="/jsp/view.jsp" />
</portlet:renderURL>

<p><a href="<%= listURL %>">&larr; Back</a></p>