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
	
	//TODO
	@ProcessAction(name = "getCategories")
	public void getCategories(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		JSONObject parameters = new JSONObject(request.getParameterMap());
		JSONArray list = DataBaseFunctions.getCategories(DataBaseFunctions.getWebConnection());
		
		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, list.toJSONString());
		
	}
	
	//TODO
	@ProcessAction(name = "getDrugs")
	public void getDrugs(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {

		JSONObject parameters = new JSONObject(request.getParameterMap());
		JSONArray list = DataBaseFunctions.getDrugs(DataBaseFunctions.getWebConnection(),parameters);
		
		
		
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
	
	//TODO
	@ProcessAction(name = "updateStock")
	public void updateStock(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		
		String added = request.getParameter("added");
		String reduced = request.getParameter("reduced");
		String drugid = request.getParameter("drugid");
		
		
		//TODO
		System.out.println(drugid);
		
		if (added != null && !(added.equals("NaN"))) {
			System.out.println("Added: " + added);
		}
		
		if (reduced != null && !(reduced.equals("NaN"))) {
			System.out.println("Reduced: " + reduced);
		}
		
	}
	
	//TODO
	@ProcessAction(name = "updateOrder")
	public void updateOrder(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {


		JSONObject parameters = new JSONObject(request.getParameterMap());
		boolean result = DataBaseFunctions.updateOrderStatus(DataBaseFunctions.getWebConnection(),parameters);
		

		HttpServletResponse httpResponse = PortalUtil.getHttpServletResponse(response);
		httpResponse.setContentType("text/x-json;charset=UTF-8");
		ServletResponseUtil.write(httpResponse, result?"1":"0");
		
	}
	
	@ProcessAction(name = "addNewDrug")
	public void addNewDrug(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		//TODO
		String newName = request.getParameter("name");
		System.out.println(newName);
	}
	
	@ProcessAction(name = "updateDrug")
	public void updateDrug(ActionRequest request, ActionResponse response)
			throws PortletException, IOException {
		//TODO
		String id = request.getParameter("id");
		System.out.println(id);
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
