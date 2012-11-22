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

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>

<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="javax.portlet.PortletPreferences" %>
<%@ page import="com.mpwc.model.Worker" %>
<%@ page import="com.mpwc.service.WorkerLocalServiceUtil" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Locale" %>

<portlet:defineObjects />

<% 
Locale locale = request.getLocale();
String language = locale.getLanguage();
String country = locale.getCountry();

ResourceBundle res = ResourceBundle.getBundle("content.Language-ext", new Locale(language, country));
%>

<p><b><%= res.getString("jspedit.maintitle") %></b></p>

<%
	long workerId = Long.valueOf( renderRequest.getParameter("workerId") );

	Worker w = WorkerLocalServiceUtil.getWorker(workerId);

%>

<portlet:actionURL var="editWorkerURL" name="editWorker">
    <portlet:param name="mvcPath" value="/jsp/list.jsp" />
    <portlet:param name="workerId" value="<%= String.valueOf( w.getWorkerId() ) %>" />
</portlet:actionURL>

<aui:form action="<%= editWorkerURL %>" method="post">
	
	<aui:input type="hidden" name="redirectURL" value="<%= renderResponse.createRenderURL().toString() %>"/>

	<aui:layout>
 		
 	<aui:column columnWidth="25" first="true">
 	
 		<aui:fieldset>
 		
		<aui:input label='<%= res.getString("formlabel.name") %>' name="name" type="text" value="<%= w.getName() %>" >
			<aui:validator name="required" />
			<!-- Only allow alphabetical characters -->
     		<aui:validator name="alpha" />
		</aui:input>
	    <aui:input label='<%= res.getString("formlabel.surname") %>' name="surname" type="text" value="<%= w.getSurname() %>" >
			<aui:validator name="required" />
			<!-- Only allow alphabetical characters -->
     		<aui:validator name="alpha" />
		</aui:input>
		<aui:input label='<%= res.getString("formlabel.phone") %>' name="phone" type="text" value="<%= w.getPhone() %>" >
			<!-- Only allow numbers -->
     		<aui:validator name="digits" />
		</aui:input>
		
		<aui:input type="textarea" name="comments" value="<%= w.getComments() %>" >
			<!-- Only allow alphabetical characters -->
     		<aui:validator name="alphanum" />
		</aui:input>
		
		</aui:fieldset>
	
	</aui:column>
	
	<aui:column columnWidth="25" first="true">
	
		<aui:fieldset>
		
	    <aui:input label='<%= res.getString("formlabel.nif") %>' name="nif" type="text" value="<%= w.getNif() %>" >
			<aui:validator name="required" />
			<!-- Only allow alphabetical characters -->
     		<aui:validator name="alphanum" />
		</aui:input>
	    <aui:input label='<%= res.getString("formlabel.email") %>' name="email" type="text" value="<%= w.getEmail() %>" >
			<aui:validator name="required" />
			<!-- Only allow email format -->
     		<aui:validator name="email" />
		</aui:input>  
		
		<aui:select label='<%= res.getString("formlabel.status") %>' name="status">
			<aui:option label='<%= res.getString("formlabel.option.active") %>' value="1"></aui:option>
			<aui:option label='<%= res.getString("formlabel.option.inactive") %>' value="2"></aui:option>
			<aui:option label='<%= res.getString("formlabel.option.bloqued") %>' value="3"></aui:option>
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