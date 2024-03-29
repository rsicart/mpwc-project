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
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.CalendarFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.mpwc.NoSuchWorkerException;
import com.mpwc.model.Project;
import com.mpwc.model.TimeBox;
import com.mpwc.model.Worker;
import com.mpwc.service.ProjectLocalServiceUtil;
import com.mpwc.service.TimeBoxLocalServiceUtil;
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
	    	
	     	String name = ParamUtil.getString(actionRequest, "name", "");
	     	
	     	//default type: project
	     	String type = ParamUtil.getString(actionRequest, "type", "project");
	     	if(type.equals("")){ type = "project"; }
	     	
	     	String descShort = ParamUtil.getString(actionRequest, "descshort", "");
	     	String descFull = ParamUtil.getString(actionRequest, "descfull", "");
	     	double cost = ParamUtil.getDouble(actionRequest, "costestimatedeuros", 0);
	     	long time = ParamUtil.getLong(actionRequest, "timeestimatedhours", 0);    	
	     	boolean canSetTime = ParamUtil.getBoolean(actionRequest, "cansetworkerhours", false);
	     	String startDate = ParamUtil.getString(actionRequest, "startDate", "");
	     	String endDate = ParamUtil.getString(actionRequest, "endDate", "");
	     	
	     	String comments = ParamUtil.getString(actionRequest, "comments", "");
	     	
	     	//default active, if we get null or -1 (please choose... select option)
	     	long status = ParamUtil.getLong(actionRequest, "status", 1);
	     	if(status < 0){ status = 1; }
	     	
	     	System.out.println("addProject adding:" +" - "+ name +" - "+ type +" - "+ descShort +" - "+ 
	     			descFull +" - "+ cost +" - "+ time +" - "+ canSetTime +" - "+ startDate +" - "+
	     			endDate +" - "+ comments +" - "+ status);
	     	
	     	Date now = new Date();
	     	
	     	if(		name != null && !name.isEmpty() &&
	     			type != null && !type.isEmpty() &&
	     			descShort != null &&
	     			descFull != null &&
	     			!Double.isNaN(cost) &&
	     			time >= 0
	     		){
	     		
	 	    	Project p;
	 			try {
	 				long projectId = CounterLocalServiceUtil.increment(Project.class.getName());
	 				p = ProjectLocalServiceUtil.createProject(projectId);
	 				p.setName(name);
	 		    	p.setType(type);
	 		    	p.setDescShort(descShort);
	 		    	p.setDescFull(descFull);
	 		    	if( cost >= 0 ){ p.setCostEstimatedEuros(cost); }
	 		    	if( time >= 0 ){ p.setTimeEstimatedHours(time); }
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
	 		    	
	 			} catch (Exception e) {
	 				System.out.println("addProject exception:" + e.getMessage());
				}

	     	}

	     	// gracefully redirecting to the default portlet view
	     	String redirectURL = actionRequest.getParameter("redirectURL");
	     	actionResponse.sendRedirect(redirectURL);
	      	
	      }

	public void editProject(ActionRequest actionRequest, ActionResponse actionResponse)
	   	       throws IOException, PortletException{
	     	
	    	ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
	    	
	    	long projectId = ParamUtil.getLong(actionRequest, "projectId", 0);
	     	String name = ParamUtil.getString(actionRequest, "name", "");
	     	String type = ParamUtil.getString(actionRequest, "type", "");
	     	String descShort = ParamUtil.getString(actionRequest, "descshort", "");
	     	String descFull = ParamUtil.getString(actionRequest, "descfull", "");
	     	double cost = ParamUtil.getDouble(actionRequest, "costestimatedeuros", 0);
	     	long time = ParamUtil.getLong(actionRequest, "timeestimatedhours", 0);
	     	boolean canSetTime = ParamUtil.getBoolean(actionRequest, "cansetworkerhours", false);
	     	String startDate = ParamUtil.getString(actionRequest, "startDate", "");
	     	String endDate = ParamUtil.getString(actionRequest, "endDate", "");
	     	startDate ="2000-01-01";
	     	endDate ="2000-01-02";
	     	String comments = ParamUtil.getString(actionRequest, "comments", "");
	     	long status = ParamUtil.getLong(actionRequest, "status", 0);
	     	
	     	System.out.println("editProject adding:" +" - "+ name +" - "+ type +" - "+ descShort +" - "+ 
	     			descFull +" - "+ cost +" - "+ time +" - "+ canSetTime +" - "+ startDate +" - "+
	     			endDate +" - "+ comments +" - "+ status);
	     	
	     	Date now = new Date();
	     	
	     	if(		name != null && !name.isEmpty() &&
	     			type != null && !type.isEmpty() &&
	     			descShort != null &&
	     			descFull != null &&
	     			!Double.isNaN(cost) &&
	     			projectId > 0
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
	 		    	
	 			} catch (Exception e) {
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
 		 	String name = ParamUtil.getString(actionRequest, "ftrname", "");
 		 	String type = ParamUtil.getString(actionRequest, "ftrtype", "");	
 		 	String descShort = ParamUtil.getString(actionRequest, "ftrdescshort", "");
			String status = ParamUtil.getString(actionRequest, "ftrstatus", "");
			String costEstimatedEuros = ParamUtil.getString(actionRequest, "ftrcostestimatedeuros", "");
			String timeEstimatedHours = ParamUtil.getString(actionRequest, "ftrtimeestimatedhours", "");
			String canSetWorkerHours = ParamUtil.getString(actionRequest, "ftrcansetworkerhours", "");
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
    		long projectId = ParamUtil.getLong(actionRequest, "projectId", 0);
        	long workerId = ParamUtil.getLong(actionRequest, "workerId", 0);
        	
        	if(projectId > 0 && workerId > 0){
	        	//add worker to project
        		//Bug LPS-29668 in liferay portal, dont uncomment until 6.2 (or 6.1.1 GA2 patched)
        		long res = ProjectLocalServiceUtil.addWorker(projectId, workerId);
	        	//int res = ProjectLocalServiceUtil.addProjectWorker(projectId, workerId);
	        	System.out.println("addProjectWorker added worker "+workerId+" to project "+projectId+" - result:"+res);
        	} else {
        		System.out.println("addProjectWorker worker "+workerId+" exists in project "+projectId);
        	}
        	
        	//go to edit page
        	actionResponse.setRenderParameter("projectId", String.valueOf(projectId));
        	actionResponse.setRenderParameter("jspPage", "/jsp/edit.jsp");
        	
    	} catch (Exception e){
    		System.out.println("addProjectWorker exception2:"+e.getMessage());
    	}

    }
    
    public void delProjectWorker(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException, SystemException{
    	try{
    		//get params
    		long projectId = ParamUtil.getLong(actionRequest, "projectId", 0);
        	long workerId = ParamUtil.getLong(actionRequest, "workerId", 0);
        	
        	if(projectId > 0 && workerId > 0){
	        	////delete worker from project
	    		////Bug LPS-29668 in liferay portal, dont uncomment until 6.2 (or 6.1.1 GA2 patched)
	        	////ProjectLocalServiceUtil.removeWorker(projectId, workerId);
        		long res =ProjectLocalServiceUtil.removeWorker(projectId, workerId);
	    		//int res = ProjectLocalServiceUtil.delProjectWorker(projectId, workerId);
	        	System.out.println("delProjectWorker deleted worker "+workerId+" from project "+projectId+" - result:"+res);
        	}
        	//go to edit page
        	actionResponse.setRenderParameter("projectId", String.valueOf(projectId));
        	actionResponse.setRenderParameter("jspPage", "/jsp/edit.jsp");
    	}	
    	catch (Exception e){
    		System.out.println("delProjectWorker exception2:"+e.getMessage());
    		e.printStackTrace();
    	}

    }
    
    
    public void deleteProject(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException, SystemException{
    	try{
    		//get params
    		long projectId = ParamUtil.getLong(actionRequest, "projectId", 0);
        	
        	if(projectId > 0){
	        	ProjectLocalServiceUtil.deleteProject(projectId);
	        	System.out.println("deleteProject project "+projectId);
        	}
        	
        	//go to view page
        	actionResponse.setRenderParameter("jspPage", "/jsp/view.jsp");
        	
    	} catch (Exception e){
    		System.out.println("deleteProject exception2:"+e.getMessage());
    	}

    }
    
    //setProjectManager
    public void setProjectManager(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException, SystemException{
    	try{
    		//get params
    		long projectId = ParamUtil.getLong(actionRequest, "projectId", 0);
    		long workerId = ParamUtil.getLong(actionRequest, "workerId", 0);
        	
        	if(projectId > 0 && workerId > 0){
	        	Project p = ProjectLocalServiceUtil.getProject(projectId);
	        	p.setWorkerId(workerId);
	        	System.out.println("setProjectManager project "+projectId);
	        	ProjectLocalServiceUtil.updateProject(p);
        	}
        	
        	//go to edit page
        	actionResponse.setRenderParameter("projectId", String.valueOf(projectId));
        	actionResponse.setRenderParameter("jspPage", "/jsp/edit.jsp");
        	
    	} catch (Exception e){
    		System.out.println("deleteProject exception2:"+e.getMessage());
    	}

    }
    
	public void preAddTimeBox(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException{
		String projectId = ParamUtil.getString(actionRequest, "projectId");
		//create an empty project
		TimeBox timeBox = TimeBoxLocalServiceUtil.createTimeBox(0);
		//pass it to the view (useBean to catch it)
		actionRequest.setAttribute("timeBox", timeBox);
		actionResponse.setRenderParameter("projectId", projectId);
		actionResponse.setRenderParameter("jspPage", "/jsp/add_timebox.jsp");
	}
	
	
	public void addTimeBox(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException{
	     	
    	ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
    	
    	long projectId = ParamUtil.getLong(actionRequest, "projectId", 0);
    	long minutes = ParamUtil.getLong(actionRequest, "minutes", 0);
     	String comments = ParamUtil.getString(actionRequest, "comments", "");
     	
		int dYear = ParamUtil.getInteger(actionRequest,"dedicationDateYear");
		int dMonth = ParamUtil.getInteger(actionRequest,"dedicationDateMonth");
		int dDay = ParamUtil.getInteger(actionRequest,"dedicationDateDay");
		Date dd = PortalUtil.getDate(dMonth, dDay, dYear);
     	
     	//get user data
     	long userId = themeDisplay.getUserId();
     	long groupId = themeDisplay.getLayout().getGroupId();
     	Worker worker;
     	long workerId = 0;
		try {
			worker = WorkerLocalServiceUtil.findByG_U_First(groupId, userId, null);
			workerId = worker.getWorkerId();
		} catch (NoSuchWorkerException e1) {
			System.out.println("addTimeBox exception: no existe el trabajador.");
		} catch (SystemException e1) {
			System.out.println("addTimeBox exception");
		}
     	
     	System.out.println("addTimeBox adding:" +" - "+ projectId +" - "+ workerId +" - "+ minutes +" - "+ dd.getTime() + " - "+comments );
     	
     	Date now = new Date();
     	
     	if(	projectId > 0 && workerId > 0 && minutes > 0 && dd != null ){
     		
 	    	TimeBox tb;
 			try {
 				//long timeBoxId = CounterLocalServiceUtil.increment(TimeBox.class.getName());
 				long timeBoxId = 0; //id is added inside add method
 				tb = TimeBoxLocalServiceUtil.createTimeBox(timeBoxId);
 				
 				tb.setProjectId(projectId);
 				tb.setWorkerId(workerId);
 				tb.setMinutes(minutes);
	    		tb.setDedicationDate(dd);					
 		    	
 		        if( comments != null && comments.length() > 0 ){ tb.setComments(comments); }
 		    	
 		        tb.setCreateDate(now); 		    	
 				tb.setCompanyId(themeDisplay.getCompanyId());
 				tb.setGroupId(themeDisplay.getScopeGroupId());
 		    	
 				TimeBoxLocalServiceUtil.add(tb);
 		    	
 		    	System.out.println("addTimeBox -" + "groupId:" + tb.getGroupId() + "companyId:" + tb.getCompanyId()+ " - comments:"+tb.getComments());
 		    	
 			} catch (Exception e) {
 				System.out.println("addTimeBox exception:" + e.getMessage());
			}

     	}

     	// gracefully redirecting to the default portlet view
     	String redirectURL = actionRequest.getParameter("redirectURL");
     	actionResponse.sendRedirect(redirectURL);
	}
	
	
	public void editTimeBox(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException{
     	
    	ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
    	
    	long timeBoxId = ParamUtil.getLong(actionRequest, "timeBoxId", 0);
    	long projectId = ParamUtil.getLong(actionRequest, "projectId", 0);
    	long minutes = ParamUtil.getLong(actionRequest, "minutes", 0);
     	String comments = ParamUtil.getString(actionRequest, "comments", "");
     	
		int dYear = ParamUtil.getInteger(actionRequest,"dedicationDateYear");
		int dMonth = ParamUtil.getInteger(actionRequest,"dedicationDateMonth");
		int dDay = ParamUtil.getInteger(actionRequest,"dedicationDateDay");
		Date dd = PortalUtil.getDate(dMonth, dDay, dYear);
     	
     	System.out.println("editTimeBox editing:" +" - "+ projectId +" - "+ minutes +" - "+ dd.getTime() + " - "+comments );
     	
     	Date now = new Date();
     	
     	if(	projectId > 0 && timeBoxId > 0 && minutes > 0 && dd != null ){
     		
 	    	TimeBox tb;
 			try {
 				//get timebox
 				tb = TimeBoxLocalServiceUtil.getTimeBox(timeBoxId);
 				//set new data
 				tb.setMinutes(minutes);
	    		tb.setDedicationDate(dd);					
 		    	
 		        if( comments != null && comments.length() > 0 ){ tb.setComments(comments); }
 		    	
 		        //set last modification date
 		        tb.setModifiedDate(now); 		    	
 		    	
 		        //save changes
 				TimeBoxLocalServiceUtil.updateTimeBox(tb);
 		    	
 		    	System.out.println("editTimeBox -" + "groupId:" + tb.getGroupId() + "companyId:" + tb.getCompanyId()+ " - comments:"+tb.getComments());
 		    	
 			} catch (Exception e) {
 				System.out.println("editTimeBox exception:" + e.getMessage());
			}

     	}

     	// gracefully redirecting to the default portlet view
     	String redirectURL = actionRequest.getParameter("redirectURL");
     	actionResponse.sendRedirect(redirectURL);
	}
	
	
	public void deleteTimeBox(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException{
		long result = -1;
		long timeBoxId = ParamUtil.getLong(actionRequest, "timeBoxId", 0);
		System.out.println("deleteTimeBox portlet: delete ->"+timeBoxId);
		try{
			result = TimeBoxLocalServiceUtil.delete(timeBoxId);
		} catch(Exception e){
			result = -1;
			System.out.println("deleteTimeBox exception:"+e.getMessage());
		}
		
     	// gracefully redirecting to the default portlet view
     	String redirectURL = actionRequest.getParameter("redirectURL");
     	actionResponse.sendRedirect(redirectURL);
	}
	
}
