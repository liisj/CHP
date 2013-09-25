package tests;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;

import database.DataBasePlayground;

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
		
		
		DBDrug drug = new DBDrug(-1, msdcode==null?-1:Integer.valueOf(msdcode), medName, 
				comName, unit, unitDetails, null);
		
		Date start = date1Text==null?null:java.sql.Date.valueOf(date1Text);
		Date end = date2Text==null?null:java.sql.Date.valueOf(date2Text);
		
		DBOrderSearch dbos = new DBOrderSearch(facText,drug,start,end);
		try {
			PreparedStatement ps = dbos.giveSearchStatement(DataBasePlayground.getConnection());
			ResultSet rs = ps.executeQuery();
			TableModel model = DBTestGUI.table.getModel();
			DefaultTableModel a = (DefaultTableModel) model;
			a.setRowCount(0);
			while (rs.next()) {
				int order_id = rs.getInt(1);
				String facility = rs.getString(2);
				String drugName = rs.getString(3);
				Date date = rs.getDate(4);
				
				a.addRow(new Object[]{order_id,facility,drugName,date});
			}
			
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	}
}
