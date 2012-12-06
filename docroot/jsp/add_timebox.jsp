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

<jsp:useBean id="timeBox" type="com.mpwc.model.TimeBox" scope="request" />

<%
locale = request.getLocale();
String language = locale.getLanguage();
String country = locale.getCountry();

ResourceBundle res = ResourceBundle.getBundle("content.Language-ext", new Locale(language, country));

long projectId = Long.valueOf( renderRequest.getParameter("projectId") );
%>

<p><b><%= res.getString("jspaddtimebox.maintitle") %></b></p>

<portlet:actionURL var="addTimeBoxURL" name="addTimeBox">
	<portlet:param name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>" />
    <portlet:param name="jspPage" value="/jsp/view.jsp" />
</portlet:actionURL>

<% System.out.println("redirecURL:"+renderResponse.createRenderURL().toString()); %>

<aui:form name="frm_add_timebox" action="<%= addTimeBoxURL %>" method="post">
	
	<aui:input type="hidden" name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>"/>
	<aui:input type="hidden" name="projectId" value="<%= projectId %>"/>

	<aui:layout>
 		
 	<aui:column columnWidth="50" first="true">
 	
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
			<aui:input label='<%= res.getString("formlabel.dedicationdate") %>' name="dedicationDate" model="<%= TimeBox.class %>" bean="<%= timeBox %>" value="<%= dedicationDate %>" />
			
		</aui:fieldset>
	
	</aui:column>
	
	<aui:column columnWidth="50" last="true">
	
		<aui:fieldset>
		
			
		</aui:fieldset>
		    
	</aui:column>
	
   </aui:layout>
   
   <aui:button type="submit" />
</aui:form>


<portlet:renderURL var="listURL">
    <portlet:param name="mvcPath" value="/jsp/view.jsp" />
</portlet:renderURL>

<p><a href="<%= listURL %>">&larr; Back</a></p>