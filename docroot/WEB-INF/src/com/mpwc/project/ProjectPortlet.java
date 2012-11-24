package com.mpwc.project;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletSession;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.CalendarFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.mpwc.model.Project;
import com.mpwc.service.ProjectLocalServiceUtil;

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
	 		    	
	 		    	ProjectLocalServiceUtil.addProject(p);
	 		    	
	 		    	System.out.println("addProject -" + "groupId:" + p.getGroupId() + "companyId:" + p.getCompanyId());
	 		    	
	 			} catch (SystemException e) {
	 				System.out.println("addProject exception:" + e.getMessage());
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
	
}
