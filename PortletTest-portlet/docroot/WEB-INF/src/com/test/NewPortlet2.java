package com.test;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.ProcessAction;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.liferay.portal.kernel.servlet.ServletResponseUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * Portlet implementation class NewPortlet2
 */
public class NewPortlet2 extends MVCPortlet {
 
	public void updateBook(ActionRequest actionRequest,
			ActionResponse actionResponse)
			throws IOException, PortletException {
			String bookTitle = ParamUtil.getString(actionRequest, "bookTitle");
			String author = ParamUtil.getString(actionRequest, "author");
			System.out.println("Your inputs ==> " + bookTitle + ", " + author);
			}
	
	@ProcessAction(name = "getCategories")
	public void getCategories(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
				
		JSONArray list = new JSONArray();
		list.add("Antifungals");
		list.add("Probiotics");
		list.add("Viral vaccines");
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	@ProcessAction(name = "getDrugs")
	public void getDrugs(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONArray list = new JSONArray();
		
		String idParameter = request.getParameter("id");
		String index = request.getParameter("index");
		String category = request.getParameter("category");
		
		if (idParameter != null) {
			JSONObject obj=new JSONObject();
			obj.put("drugname","Superdophilus");
			obj.put("unitofissue","20 tablets");
			obj.put("drugform", "tablets");
			obj.put("current", Integer.parseInt(idParameter)*10);
			obj.put("price", Integer.parseInt(idParameter)*100);
			obj.put("suggested", Integer.parseInt(idParameter)*10+1);
			obj.put("id", idParameter);
			obj.put("index", index);
			list.add(obj);
		}
		else if (category != null) {
			switch (category) {
			
			case "1":
			
				JSONObject obj1=new JSONObject();
				obj1.put("drugname","Lamisil");
				obj1.put("unitofissue","100 tablets");
				obj1.put("drugform", "tablet");
				obj1.put("current", 10);
				obj1.put("price", 100);
				obj1.put("suggested", 11);
				obj1.put("id", 1);
				list.add(obj1);
				
				JSONObject obj2=new JSONObject();
				obj2.put("drugname","Ancobon");
				obj2.put("unitofissue","200 tablets");
				obj2.put("drugform", "tablet");
				obj2.put("current", 30);
				obj2.put("price", 200);
				obj2.put("suggested", 1000);
				obj2.put("id", 2);
				list.add(obj2);
				
				JSONObject obj3=new JSONObject();
				obj3.put("drugname","Grisactin Ultra");
				obj3.put("unitofissue","500 tablets");
				obj3.put("drugform", "tablet");
				obj3.put("current", 30);
				obj3.put("price", 200);
				obj3.put("suggested", 1000);
				obj3.put("id", 3);
				list.add(obj3);
				
				break;
				
			case "2":
				
				JSONObject obj4=new JSONObject();
				obj4.put("drugname","Bacid");
				obj4.put("unitofissue","100 tablets");
				obj4.put("drugform", "tablet");
				obj4.put("current", 10);
				obj4.put("price", 100);
				obj4.put("suggested", 11);
				obj4.put("id", 4);
				list.add(obj4);
				
				JSONObject obj5=new JSONObject();
				obj5.put("drugname","Florastor");
				obj5.put("unitofissue","200 tablets");
				obj5.put("drugform", "tablet");
				obj5.put("current", 30);
				obj5.put("price", 200);
				obj5.put("suggested", 1000);
				obj5.put("id", 5);
				list.add(obj5);
				
				JSONObject obj6=new JSONObject();
				obj6.put("drugname","Superdophilus");
				obj6.put("unitofissue","500 tablets");
				obj6.put("drugform", "tablet");
				obj6.put("current", 30);
				obj6.put("price", 200);
				obj6.put("suggested", 1000);
				obj6.put("id", 6);
				list.add(obj6);
				
				break;
			
		case "3":
			
			JSONObject obj7=new JSONObject();
			obj7.put("drugname","Afluria");
			obj7.put("unitofissue","100 vials");
			obj7.put("drugform", "vial");
			obj7.put("current", 10);
			obj7.put("price", 100);
			obj7.put("suggested", 11);
			obj7.put("id", 4);
			list.add(obj7);
			
			JSONObject obj8=new JSONObject();
			obj8.put("drugname","Gardasil");
			obj8.put("unitofissue","200 vials");
			obj8.put("drugform", "vial");
			obj8.put("current", 30);
			obj8.put("price", 200);
			obj8.put("suggested", 1000);
			obj8.put("id", 5);
			list.add(obj8);
			
			JSONObject obj9=new JSONObject();
			obj9.put("drugname","Varivax");
			obj9.put("unitofissue","500 vials");
			obj9.put("drugform", "vial");
			obj9.put("current", 30);
			obj9.put("price", 200);
			obj9.put("suggested", 1000);
			obj9.put("id", 6);
			list.add(obj9);
			
			break;
		}
		}
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	@ProcessAction(name = "getOrderSummary")
	public void getOrderSummary(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		JSONArray list = new JSONArray();
		for (int i=0; i<3; i++) {
			JSONObject obj=new JSONObject();
			obj.put("date","0"+(i+1)+"/05/2013");
			obj.put("items",3);
			obj.put("status", "ordered");
			list.add(obj);
		}
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	@ProcessAction(name = "getSentOrderSummary")
	public void getSentOrderSummary(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		JSONArray list = new JSONArray();
		for (int i=0; i<3; i++) {
			JSONObject obj=new JSONObject();
			obj.put("date","0"+(i+2)+"/05/2013");
			obj.put("items","3");
			obj.put("status", "arrived");
			list.add(obj);
		}
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	@ProcessAction(name = "getOrderItems")
	public void getOrderItems(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		String idParameter = request.getParameter("id");
		JSONArray list = new JSONArray();

		JSONObject obj7=new JSONObject();
		obj7.put("drugname","Afluria");
		obj7.put("unitofissue","100 vials");
		obj7.put("drugform", "vial");
		obj7.put("current", 10);
		obj7.put("price", 100);
		obj7.put("suggested", 11);
		obj7.put("amount", 200);
		obj7.put("id", 4);
		list.add(obj7);
		
		JSONObject obj8=new JSONObject();
		obj8.put("drugname","Gardasil");
		obj8.put("unitofissue","200 vials");
		obj8.put("drugform", "vial");
		obj8.put("current", 30);
		obj8.put("price", 200);
		obj8.put("suggested", 1000);
		obj8.put("amount", 200);
		obj8.put("id", 5);
		list.add(obj8);
		
		JSONObject obj9=new JSONObject();
		obj9.put("drugname","Varivax");
		obj9.put("unitofissue","500 vials");
		obj9.put("drugform", "vial");
		obj9.put("current", 30);
		obj9.put("price", 200);
		obj9.put("suggested", 1000);
		obj9.put("amount", 200);
		obj9.put("id", 6);
		list.add(obj9);
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	@ProcessAction(name = "getSentOrderItems")
	public void getSentOrderItems(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		JSONArray list = new JSONArray();
		String idParameter = request.getParameter("id");
				
		JSONObject obj7=new JSONObject();
		obj7.put("drugname","Afluria");
		obj7.put("unitofissue","100 vials");
		obj7.put("drugform", "vial");
		obj7.put("current", 10);
		obj7.put("price", 100);
		obj7.put("suggested", 11);
		obj7.put("amount", 200);
		obj7.put("id", 4);
		list.add(obj7);
		
		JSONObject obj8=new JSONObject();
		obj8.put("drugname","Gardasil");
		obj8.put("unitofissue","200 vials");
		obj8.put("drugform", "vial");
		obj8.put("current", 30);
		obj8.put("price", 200);
		obj8.put("suggested", 1000);
		obj8.put("amount", 200);
		obj8.put("id", 5);
		list.add(obj8);
		
		JSONObject obj9=new JSONObject();
		obj9.put("drugname","Varivax");
		obj9.put("unitofissue","500 vials");
		obj9.put("drugform", "vial");
		obj9.put("current", 30);
		obj9.put("price", 200);
		obj9.put("suggested", 1000);
		obj9.put("amount", 200);
		obj9.put("id", 6);
		list.add(obj9);
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	@ProcessAction(name = "sendOrder")
	public void sendOrder(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		System.out.println("Created at: " + request.getParameter("created_at"));
		
	}
	
	@ProcessAction(name = "updateStock")
	public void updateStock(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		String added = request.getParameter("added");
		String reduced = request.getParameter("reduced");
		
		if (!(added.equals("NaN"))) {
			System.out.println("Added: " + added);
		}
		
		if (!(reduced.equals("NaN"))) {
			System.out.println("Reduced: " + reduced);
		}
		
	}
	
	
	/*public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) {
		
		resourceResponse.setContentType("text/javascript");
		
		JSONObject jsonObject = JSONFactoryUtil.createJSONObject();
		jsonObject.put("retVal1", "Returing First value from server");
		
		try {
			PrintWriter writer;
			writer = resourceResponse.getWriter();
			writer.write(jsonObject.toString());
			System.out.println(jsonObject.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/
}
