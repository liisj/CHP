package com.test;

import java.io.IOException;
import java.util.Enumeration;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletPreferences;
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
	

	// DMA functions
	
	/**
	 * 
	 * @param request Ignored
	 * @param response Will contain a JSONArray, containing JSONObjects like:<br>
	 * category_id (int)<br>
	 * category_name (String)
	 * @throws PortletException
	 * @throws IOException
	 */
	@ProcessAction(name = "getDrugCategories")
	public void getDrugCategories(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		JSONObject parameters = new JSONObject(request.getParameterMap());
		JSONArray list = DataBaseFunctions.getCategories(DataBaseFunctions.getWebConnection());
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	/**
	 * 
	 * @param request
	 * 				Possible parameters:<br>
	 * 				drug_id (int),<br>
	 * 				category_id (int)
	 * 				index (int)
	 * @param response
	 * @throws PortletException
	 * @throws IOException
	 */
	@ProcessAction(name = "getDrugs")
	public void getDrugs(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		JSONObject parameters = new JSONObject(request.getParameterMap());
		JSONArray list = DataBaseFunctions.getDrugs(DataBaseFunctions.getWebConnection(),parameters);
		
		if (parameters.get("index") != null) {
			
			for (int i = 0; i < list.size(); i++) {
				((JSONObject) (list.get(i))).put("index", parameters.get("index"));
			}
		}
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
	
		
	}

	/**
	 * 
	 * @param request
	 *            Possible parameters:<br>
	 *            order_id (int),<br>
	 *            order_start (String/Timestamp: yyyy-[m]m-[d]d hh:mm:ss),<br>
	 *            order_end (String/Timestamp: yyyy-[m]m-[d]d hh:mm:ss),<br>
	 *            order_status (String, one of: 'initiated','sent','delivered','canceled'<br>
	 *            facility_id (int),<br>
	 *            facility_name (String), <br>
	 *            summarized (Boolean)
	 * @param response
	 * @throws PortletException
	 * @throws IOException
	 */
	@ProcessAction(name = "getOrderSummary")
	public void getOrderSummary(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		JSONArray list = DataBaseFunctions.getOrderSummary(DataBaseFunctions.getWebConnection(),parameters);
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}

	/**
	 * 
	 * @deprecated Replaced by {@link #getOrderSummary()}. Add "sent" as order_status to achieve same functionality.
	 */
	@Deprecated
	@ProcessAction(name = "getSentOrderSummary")
	public void getSentOrderSummary(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		parameters.put("order_status", "sent");
		JSONArray list = DataBaseFunctions.getOrderSummary(DataBaseFunctions.getWebConnection(),parameters);
		
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	/**
	 * 
	 * @deprecated Replaced by {@link #getOrderSummary()}. Add "order_id" and "summarize = false" as parameters to achieve same functionality.
	 */
	@Deprecated
	@ProcessAction(name = "getOrderItems")
	public void getOrderItems(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		parameters.put("summarize", "false");
		JSONArray list = DataBaseFunctions.getOrderSummary(DataBaseFunctions.getWebConnection(),parameters);
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}

	/**
	 * 
	 * @deprecated Replaced by {@link #getOrderSummary()}. Add "order_status : sent", "order_id" and "summarize : false" as parameters to achieve same functionality.
	 */
	@Deprecated
	@ProcessAction(name = "getSentOrderItems")
	public void getSentOrderItems(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		parameters.put("order_status", "sent");
		parameters.put("summarize", "false");
		JSONArray list = DataBaseFunctions.getOrderSummary(DataBaseFunctions.getWebConnection(),parameters);
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	
	/**
	 * 
	 * @param request
	 *            Parameters:<br>
	 *            facility_id : (int),<br>
	 * <br>
	 *            Additionally Key-Value-Pairs in the form of (drug_id (int) :
	 *            difference (int)) will have to be added
	 * @param response
	 *            1 if query successful, 0 otherwise
	 * @throws PortletException
	 * @throws IOException
	 */
	@ProcessAction(name = "updateStock")
	public void updateStock(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		boolean result = DataBaseFunctions.updateInventory(DataBaseFunctions.getWebConnection(),parameters);
		

		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, result?"1":"0");
		
		
	}
	
	/**
	 * 
	 * @param request
	 *            Parameters:<br>
	 *            order_id (int),<br>
	 *            status (String),<br>
	 * @param response
	 *            1 if query successful, 0 otherwise
	 * @throws PortletException
	 * @throws IOException
	 */
	@ProcessAction(name = "updateOrder")
	public void updateOrder(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {


		JSONObject parameters = new JSONObject(request.getParameterMap());
		boolean result = DataBaseFunctions.updateOrderStatus(DataBaseFunctions.getWebConnection(),parameters);
		

		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, result?"1":"0");
		
	}
	
	/**
	 * 
	 * @param request
	 *            Parameters:<br>
	 *            Mandatory:<br>
	 *            msdcode (int),<br>
	 *            category_id (int),<br>
	 *            med_name (String),<br>
	 *            unit_price (Double)<br>
	 *            Optional:<br>
	 *            common_name (String),<br>
	 *            unit (String),<br>
	 *            unit_details (String)
	 * @param response
	 * @throws PortletException
	 * @throws IOException
	 */
	@ProcessAction(name = "addNewDrug")
	public void addNewDrug(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		boolean result = DataBaseFunctions.addDrug(DataBaseFunctions.getWebConnection(),parameters);
		

		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, result?"1":"0");
		
	}
	
	/**
	 * 
	 * @param request
	 *            Parameters:<br>
	 *            Mandatory:<br>
	 *            id (int)<br>
	 *            Optional:<br>
	 *            msdcode (int),<br>
	 *            category_id (int),<br>
	 *            med_name (String),<br>
	 *            common_name (String),<br>
	 *            unit (String),<br>
	 *            unit_details (String),<br>
	 *            unit_price (Double)<br>
	 * @param response
	 * @throws PortletException
	 * @throws IOException
	 */
	@ProcessAction(name = "updateDrug")
	public void updateDrug(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		boolean result = DataBaseFunctions.updateDrug(DataBaseFunctions.getWebConnection(),parameters);
		

		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, result?"1":"0");
	}

	
	// On-the-job training functions
	
	public void search(ActionRequest actionRequest,
			ActionResponse actionResponse)
			throws IOException, PortletException {
	
		System.out.println("searching...");
	}
	
	@ProcessAction(name = "getTopCategories")
	public void getTopCategories(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		JSONArray list = new JSONArray();
        JSONObject cat1 = new JSONObject();
        JSONObject cat2 = new JSONObject();
        JSONObject cat3 = new JSONObject();
        JSONObject cat4 = new JSONObject();
        JSONObject cat5 = new JSONObject();
        cat1.put("id", 10);
        cat1.put("name", "Children");
        cat2.put("id", 20);
        cat2.put("name", "Pregnant women");
        cat3.put("id", 30);
        cat3.put("name", "Elderly");
        cat4.put("id", 40);
        cat4.put("name", "Infections");
        cat5.put("id", 50);
        cat5.put("name", "Mental health");
        list.add(cat1);
        list.add(cat2);
        list.add(cat3);
        list.add(cat4);
        list.add(cat5);
		
		 HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
         httpResponse.setContentType("text/x-json;charset=UTF-8");
         ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	@ProcessAction(name = "getSubCategories")
	public void getSubCategories(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		String catId = request.getParameter("category_id");
		System.out.println("getSubCategories reached");
		System.out.println("catID in getSubCategories: " + catId);
		
		JSONArray list = new JSONArray();
        JSONObject cat1 = new JSONObject();
        JSONObject cat2 = new JSONObject();
        JSONObject cat3 = new JSONObject();
        JSONObject cat4 = new JSONObject();
        JSONObject cat5 = new JSONObject();
        cat1.put("id", 10);
        cat1.put("name", "Clinical disorders");
        cat2.put("id", 20);
        cat2.put("name", "Relationships");
        cat3.put("id", 30);
        cat3.put("name", "Medical and Developmental Disorders");
        cat4.put("id", 40);
        cat4.put("name", "Psychosocial Stressors");
        cat5.put("id", 50);
        cat5.put("name", "Emotional and Social Functioning");
        list.add(cat1);
        list.add(cat2);
        list.add(cat3);
        list.add(cat4);
        list.add(cat5);
		
        //response.setRenderParameter("jspPage","/html/newportlet2/subCategories.jsp");
        request.setAttribute("subCategories",list.toJSONString());
		
	}
	
/*	public void doView(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {
			    super.doView(renderRequest, renderResponse);
			} */
	
	@Override
    public void processAction(
            ActionRequest actionRequest, ActionResponse actionResponse)
        throws IOException, PortletException {
		
		System.out.println("processAction reached");	
		
        PortletPreferences prefs = actionRequest.getPreferences();
        Map<String,String[]> paramMap = actionRequest.getParameterMap();
        Enumeration<String> attrNames = actionRequest.getAttributeNames();
        
        for (String key : paramMap.keySet()) {
        	System.out.println("Key: " + key + ", Value: " + paramMap.get(key)[0]);
        }
        
        while (attrNames.hasMoreElements()) {
        	String attrName = attrNames.nextElement();
        	System.out.println("Attribute key: " + attrName + ", Attribute value: " + actionRequest.getAttribute(attrName));
        }

        String catId = actionRequest.getParameter("category_id");
        
        System.out.println("catId: " + catId);

        if (catId != null) {
            prefs.setValue("category_id", catId);
            prefs.store();
        }
        
        String jspPage = actionRequest.getParameter("jspPage");
        if (jspPage != null) {
        	actionResponse.setRenderParameter("jspPage", jspPage);
        }

        super.processAction(actionRequest, actionResponse);
    }

}

