package com.mpwc.project;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;

import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.exception.SystemException;
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
	
}
