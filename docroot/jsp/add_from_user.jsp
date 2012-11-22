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

Role mpwcUserRole = RoleLocalServiceUtil.getDefaultGroupRole(themeDisplay.getScopeGroupId());
//mpwcUserRole = RoleLocalServiceUtil.getRole(themeDisplay.getCompanyId(), "MpwcUser");
mpwcUserRole = RoleLocalServiceUtil.getRole(themeDisplay.getCompanyId(), "User");
long roleId = mpwcUserRole.getRoleId();
%>

<p><b><%= res.getString("jspadd.maintitle") %></b></p>

<portlet:renderURL var="addWorkerURL">
    <portlet:param name="mvcPath" value="/jsp/add.jsp" />
</portlet:renderURL>

<aui:layout>

	<aui:column columnWidth="80" first="true">
	
	<!-- grid -->
	 
	<liferay-ui:search-container delta="10">
	
	<liferay-ui:search-container-results>
	<% 
		List<User> tempResults = UserLocalServiceUtil.getRoleUsers(roleId);
		results = ListUtil.subList(tempResults, searchContainer.getStart(),searchContainer.getEnd());
		total = tempResults.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total",total);
	 %>	
	 </liferay-ui:search-container-results>
	 
	 <liferay-ui:search-container-row className="com.liferay.portal.model.User" keyProperty="userId" modelVar="user">
	 	<liferay-ui:search-container-column-text name="Name" property="firstName" />
	 	<liferay-ui:search-container-column-text name="Surname" property="lastName" />
	 	<liferay-ui:search-container-column-text name="Email" property="emailAddress" />
	 	<liferay-ui:search-container-column-jsp path="/jsp/add_actions.jsp" align="right" />
	 </liferay-ui:search-container-row>
	 
	 <liferay-ui:search-iterator />
	 
	 </liferay-ui:search-container>
	 
	 <!-- end grid -->
		
	</aui:column>	

</aui:layout>


<portlet:renderURL var="listURL">
    <portlet:param name="mvcPath" value="/jsp/view.jsp" />
</portlet:renderURL>

<p><a href="<%= listURL %>">&larr; Back</a></p>