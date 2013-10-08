package tests;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import database.DataBaseFunctions;
import database.objects.DBDrug;

public class ButtonListener implements ActionListener {

	public String ifEmptyNull(String a) {
		if (a.equals("")) return null;
		return a;
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		String facText = ifEmptyNull(DBTestGUI.facField.getText());
		String date1Text = ifEmptyNull(DBTestGUI.orderField1.getText());
		String date2Text = ifEmptyNull(DBTestGUI.orderField2.getText());
		String medName = ifEmptyNull(DBTestGUI.medNameField.getText());
		String comName = ifEmptyNull(DBTestGUI.commonNameField.getText());
		String msdcode = ifEmptyNull(DBTestGUI.msdCodeField.getText());
		String unit = ifEmptyNull(DBTestGUI.unitField.getText());
		String unitDetails = ifEmptyNull(DBTestGUI.unitDetailsField.getText());
		
		JSONObject input = new JSONObject();
		input.put("facility_name", facText);
		input.put("order_start", date1Text);
		input.put("order_end", date2Text);
		input.put("drug_med_name", medName);
		input.put("drug_common_name", comName);
		input.put("drug_msdcode", msdcode);
		input.put("drug_unit", unit);
		input.put("drug_unit_details", unitDetails);
		
		
		try {
			Connection con = DataBaseFunctions.getWebConnection();
			JSONArray bla = DataBaseFunctions.search(con,input);
			Object[][] hm = new Object[bla.size()][];

			
			
			TableModel model = DBTestGUI.table.getModel();
			DefaultTableModel a = (DefaultTableModel) model;
			a.setRowCount(0);
			a.setColumnIdentifiers(((JSONObject)bla.get(0)).keySet().toArray());
			for (int i = 1 ; i<hm.length ; i++) {
				a.addRow(((JSONObject)bla.get(i)).values().toArray());
			}
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		
		
		
		
	}
}
