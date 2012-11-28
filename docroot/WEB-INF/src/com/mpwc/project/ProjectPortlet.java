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

package com.mpwc.project;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletSession;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.CalendarFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.mpwc.model.Project;
import com.mpwc.model.Worker;
import com.mpwc.service.ProjectLocalServiceUtil;
import com.mpwc.service.WorkerLocalServiceUtil;

/**
 * Portlet implementation class ProjectPortlet
 */
public class ProjectPortlet extends MVCPortlet {
 
	
	public void preAddProject(ActionRequest actionRequest, ActionResponse actionResponse)
	   	       throws IOException, PortletException{
		
		//create an empty project
		Project project = ProjectLocalServiceUtil.createProject(0);
		//pass it to the view (useBean to catch it)
		actionRequest.setAttribute("project", project);
        actionResponse.setRenderParameter("jspPage", "/jsp/add.jsp");
	}
	
	public void preListProjects(ActionRequest actionRequest, ActionResponse actionResponse)
	   	       throws IOException, PortletException{
		
		//create an empty project
		Project project = ProjectLocalServiceUtil.createProject(0);
		//pass it to the view (useBean to catch it)
		actionRequest.setAttribute("project", project);
		actionResponse.setRenderParameter("jspPage", "/jsp/view.jsp");
	}
	
	
	public void addProject(ActionRequest actionRequest, ActionResponse actionResponse)
	   	       throws IOException, PortletException{
	     	
	    	ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
	    	
	     	String name = actionRequest.getParameter("name");
	     	String type = actionRequest.getParameter("type");
	     	String descShort = actionRequest.getParameter("descshort");
	     	String descFull = actionRequest.getParameter("descfull");
	     	double cost = Double.valueOf(actionRequest.getParameter("costestimatedeuros"));
	     	long time = Long.parseLong(actionRequest.getParameter("timeestimatedhours"));
	     	boolean canSetTime = Boolean.valueOf(actionRequest.getParameter("cansetworkerhours"));
	     	String startDate = actionRequest.getParameter("startDate");
	     	String endDate = actionRequest.getParameter("endDate");
	     	startDate ="2000-01-01";
	     	endDate ="2000-01-02";
	     	String comments = actionRequest.getParameter("comments");
	     	long status = Long.parseLong(actionRequest.getParameter("status"));
	     	
	     	System.out.println("addProject adding:" +" - "+ name +" - "+ type +" - "+ descShort +" - "+ 
	     			descFull +" - "+ cost +" - "+ time +" - "+ canSetTime +" - "+ startDate +" - "+
	     			endDate +" - "+ comments +" - "+ status);
	     	
	     	Date now = new Date();
	     	
	     	if(		name != null && !name.isEmpty() &&
	     			type != null && !type.isEmpty() &&
	     			descShort != null && !descShort.isEmpty() &&
	     			descFull != null && !descFull.isEmpty() &&
	     			!Double.isNaN(cost) &&
	     			time > 0
	     			//canSetTime &&
	     			//startDate != null && !startDate.isEmpty() &&
	     			//endDate != null && !endDate.isEmpty() &&
	     			//comments != null && !comments.isEmpty()
	     		){
	     		
	 	    	Project p;
	 			try {
	 				long projectId = CounterLocalServiceUtil.increment(Project.class.getName());
	 				p = ProjectLocalServiceUtil.createProject(projectId);
	 				p.setName(name);
	 		    	p.setType(type);
	 		    	p.setDescShort(descShort);
	 		    	p.setDescFull(descFull);
	 		    	if( cost > 0 ){ p.setCostEstimatedEuros(cost); }
	 		    	if( time > 0 ){ p.setTimeEstimatedHours(time); }
	 		    	if( canSetTime ){ p.setCanSetWorkerHours(canSetTime); }
	 		    	if( status > 0 ){ p.setProjectStatusId(status); }

 		    		if (startDate == null || startDate.isEmpty()){
 		    			p.setStartDate(now);
 		    		}
 		    		else{
 		    			int sYear = ParamUtil.getInteger(actionRequest,"startDateYear");
 		    			int sMonth = ParamUtil.getInteger(actionRequest,"startDateMonth");
 		    			int sDay = ParamUtil.getInteger(actionRequest,"startDateDay");
 		    			Date sd = PortalUtil.getDate(sMonth, sDay, sYear);
 		    			p.setStartDate(sd);
 		    		}
					
 		    		if (endDate == null || endDate.isEmpty()){
 		    			p.setEndDate(now);
 		    		}
 		    		else{
 		    			int eYear = ParamUtil.getInteger(actionRequest,"endDateYear");
 		    			int eMonth = ParamUtil.getInteger(actionRequest,"endDateMonth");
 		    			int eDay = ParamUtil.getInteger(actionRequest,"endDateDay");
 		    			Date ed = PortalUtil.getDate(eMonth, eDay, eYear);
 		    			p.setEndDate(ed);
 		    		}
						
	 		    	
	 		        if( comments != null && !comments.isEmpty() ){ p.setComments(comments); }
	 		    	p.setCreateDate(now);
	 		    	
	 				p.setCompanyId(themeDisplay.getCompanyId());
	 				p.setGroupId(themeDisplay.getScopeGroupId());
	 		    	
	 		    	//ProjectLocalServiceUtil.addProject(p);
	 				ProjectLocalServiceUtil.add(p);
	 		    	
	 		    	System.out.println("addProject -" + "groupId:" + p.getGroupId() + "companyId:" + p.getCompanyId());
	 		    	
	 			} catch (SystemException e) {
	 				System.out.println("addProject exception:" + e.getMessage());
	 			} catch (PortalException e1) {
	 				System.out.println("addProject exception:" + e1.getMessage());
				}

	     	}

	     	// gracefully redirecting to the default portlet view
	     	String redirectURL = actionRequest.getParameter("redirectURL");
	     	actionResponse.sendRedirect(redirectURL);
	      	
	      }

	public void editProject(ActionRequest actionRequest, ActionResponse actionResponse)
	   	       throws IOException, PortletException{
	     	
	    	ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
	    	
	    	long projectId = Long.parseLong(actionRequest.getParameter("projectId"));
	     	String name = actionRequest.getParameter("name");
	     	String type = actionRequest.getParameter("type");
	     	String descShort = actionRequest.getParameter("descshort");
	     	String descFull = actionRequest.getParameter("descfull");
	     	double cost = Double.valueOf(actionRequest.getParameter("costestimatedeuros"));
	     	long time = Long.parseLong(actionRequest.getParameter("timeestimatedhours"));
	     	boolean canSetTime = Boolean.valueOf(actionRequest.getParameter("cansetworkerhours"));
	     	String startDate = actionRequest.getParameter("startDate");
	     	String endDate = actionRequest.getParameter("endDate");
	     	startDate ="2000-01-01";
	     	endDate ="2000-01-02";
	     	String comments = actionRequest.getParameter("comments");
	     	long status = Long.parseLong(actionRequest.getParameter("status"));
	     	
	     	System.out.println("editProject adding:" +" - "+ name +" - "+ type +" - "+ descShort +" - "+ 
	     			descFull +" - "+ cost +" - "+ time +" - "+ canSetTime +" - "+ startDate +" - "+
	     			endDate +" - "+ comments +" - "+ status);
	     	
	     	Date now = new Date();
	     	
	     	if(		name != null && !name.isEmpty() &&
	     			type != null && !type.isEmpty() &&
	     			descShort != null && !descShort.isEmpty() &&
	     			descFull != null && !descFull.isEmpty() &&
	     			!Double.isNaN(cost) &&
	     			time > 0
	     		){
	     		
	 	    	Project p;
	 			try {
	 				p = ProjectLocalServiceUtil.getProject(projectId);
	 				p.setName(name);
	 		    	p.setType(type);
	 		    	p.setDescShort(descShort);
	 		    	p.setDescFull(descFull);
	 		    	if( cost > 0 ){ p.setCostEstimatedEuros(cost); }
	 		    	if( time > 0 ){ p.setTimeEstimatedHours(time); }
	 		    	if( canSetTime ){ p.setCanSetWorkerHours(canSetTime); }
	 		    	if( status > 0 ){ p.setProjectStatusId(status); }

		    		if (startDate != null && !startDate.isEmpty()){
		    			int sYear = ParamUtil.getInteger(actionRequest,"startDateYear");
		    			int sMonth = ParamUtil.getInteger(actionRequest,"startDateMonth");
		    			int sDay = ParamUtil.getInteger(actionRequest,"startDateDay");
		    			Date sd = PortalUtil.getDate(sMonth, sDay, sYear);
		    			p.setStartDate(sd);
		    		}
					
		    		if (endDate != null || !endDate.isEmpty()){
		    			int eYear = ParamUtil.getInteger(actionRequest,"endDateYear");
		    			int eMonth = ParamUtil.getInteger(actionRequest,"endDateMonth");
		    			int eDay = ParamUtil.getInteger(actionRequest,"endDateDay");
		    			Date ed = PortalUtil.getDate(eMonth, eDay, eYear);
		    			p.setEndDate(ed);
		    		}
						
	 		    	
	 		        if( comments != null && !comments.isEmpty() ){ p.setComments(comments); }
	 		    	p.setCreateDate(now);
	 		    	
	 				p.setCompanyId(themeDisplay.getCompanyId());
	 				p.setGroupId(themeDisplay.getScopeGroupId());
	 		    	
	 		    	ProjectLocalServiceUtil.updateProject(p);
	 		    	
	 		    	System.out.println("editProject -" + "groupId:" + p.getGroupId() + "companyId:" + p.getCompanyId());
	 		    	
	 			} catch (SystemException e) {
	 				System.out.println("editProject exception:" + e.getMessage());
	 			} catch (PortalException e) {
	 				System.out.println("editProject exception:" + e.getMessage());
				}

	     	}

	     	// gracefully redirecting to the default portlet view
	     	String redirectURL = actionRequest.getParameter("redirectURL");
	     	actionResponse.sendRedirect(redirectURL);
	      	
	}
	
    public void getProjectsByFilters(ActionRequest actionRequest, ActionResponse actionResponse)
  	       throws IOException, PortletException{
	 	 try{
			//get params
 		 	String name = actionRequest.getParameter("ftrname");
 		 	String type = actionRequest.getParameter("ftrtype");	
 		 	String descShort = actionRequest.getParameter("ftrdescshort");
			String status = actionRequest.getParameter("ftrstatus");
			String costEstimatedEuros = actionRequest.getParameter("ftrcostestimatedeuros");
			String timeEstimatedHours = actionRequest.getParameter("ftrtimeestimatedhours");
			String canSetWorkerHours = actionRequest.getParameter("ftrcansetworkerhours");
			//start date
			int sYear = ParamUtil.getInteger(actionRequest,"startDateYear");
 			int sMonth = ParamUtil.getInteger(actionRequest,"startDateMonth");
 			int sDay = ParamUtil.getInteger(actionRequest,"startDateDay");
 			Date sd = PortalUtil.getDate(sMonth, sDay, sYear);
 			Calendar startDate = CalendarFactoryUtil.getCalendar();
 			startDate.setTime(sd);
 			//end date
 			int eYear = ParamUtil.getInteger(actionRequest,"endDateYear");
 			int eMonth = ParamUtil.getInteger(actionRequest,"endDateMonth");
 			int eDay = ParamUtil.getInteger(actionRequest,"endDateDay");
 			Date ed = PortalUtil.getDate(eMonth, eDay, eYear);
 			Calendar endDate = CalendarFactoryUtil.getCalendar();
 			endDate.setTime(ed);
			
			System.out.println("getProjectsByFilters params-> descShort:"+descShort+" - type:"+type+" - name:"+name+" - status:"+status+" - costEstimatedEuros:"+costEstimatedEuros+" - timeEstimatedEuros:"+timeEstimatedHours + " - canSetWorkerHours:"+canSetWorkerHours +" - startDate:"+sd.toString()+" - endDate"+ed.toString());
			
			//set session params
			actionRequest.getPortletSession().setAttribute("ftrName", name, PortletSession.PORTLET_SCOPE);
			actionRequest.getPortletSession().setAttribute("ftrType", type, PortletSession.PORTLET_SCOPE);
			actionRequest.getPortletSession().setAttribute("ftrDescShort", descShort, PortletSession.PORTLET_SCOPE);
			actionRequest.getPortletSession().setAttribute("ftrStatus", status, PortletSession.PORTLET_SCOPE);
			actionRequest.getPortletSession().setAttribute("ftrCostEstimatedEuros", costEstimatedEuros, PortletSession.PORTLET_SCOPE);
			actionRequest.getPortletSession().setAttribute("ftrTimeEstimatedHours", timeEstimatedHours, PortletSession.PORTLET_SCOPE);
			actionRequest.getPortletSession().setAttribute("ftrCanSetWorkerHours", canSetWorkerHours, PortletSession.PORTLET_SCOPE);			
			actionRequest.getPortletSession().setAttribute("ftrStartDate", sd, PortletSession.PORTLET_SCOPE);
			actionRequest.getPortletSession().setAttribute("ftrEndDate", ed, PortletSession.PORTLET_SCOPE);	
	 	 } catch (Exception e) {
		    System.out.println("Action getProjectsByFilters Error: " + e.getMessage() );
		 }
    }
	
    public void addProjectWorker(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException, SystemException{
    	try{
    		//get params
    		long projectId = Long.parseLong(actionRequest.getParameter("projectId"));
        	long workerId = Long.parseLong(actionRequest.getParameter("workerId"));
        	
        	System.out.println("addProjectWorker added worker "+workerId+" to project "+projectId);
        	//add worker to project
        	//Worker w = WorkerLocalServiceUtil.getWorker(workerId);
        	int res = ProjectLocalServiceUtil.addProjectWorker(projectId, workerId);
        	
        	System.out.println("addProjectWorker added worker "+workerId+" to project "+projectId+" - result:"+res);
        	
    	} catch (SystemException e1){
    		System.out.println("addProjectWorker exception1:"+e1.getMessage());
    		e1.printStackTrace();
    	} catch (Exception e2){
    		System.out.println("addProjectWorker exception2:"+e2.getMessage()+e2.getLocalizedMessage());
    		e2.printStackTrace();
    	}

    }
}
