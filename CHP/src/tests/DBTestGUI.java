package tests;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;

public class DBTestGUI {
	
	
	static JTextField facField;
	static JTextField orderField1;
	static JTextField unitField;
	static JTextField msdCodeField;
	static JTextField commonNameField;
	static JTextField medNameField;
	static JTextField orderField2;
	static JTextField unitDetailsField;
	static JTable table;

	static void createWindow() {
		JFrame frame = new JFrame("Simple GUI");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		JPanel editPanel = new JPanel();
		BorderLayout borderL = new BorderLayout();
		frame.setLayout(borderL);
		editPanel.setLayout(new GridLayout(4,4));
		
		
		
		JLabel labelFac = new JLabel("Facility:");
		JLabel orderLabel1 = new JLabel("Order Date between");
		JLabel orderLabel2 = new JLabel("and");
		JLabel medNameLabel = new JLabel("med_name");
		JLabel commonNameLabel = new JLabel("common_name");
		JLabel msdCodeLabel = new JLabel("msdcode");
		JLabel unitLabel = new JLabel("Unit");
		JLabel unitDetailsLabel = new JLabel("Unit Details");

		facField = new JTextField("");
		orderField1 = new JTextField("");
		orderField2 = new JTextField("");
		medNameField = new JTextField("");
		commonNameField = new JTextField("");
		msdCodeField = new JTextField("");
		unitField = new JTextField("");
		unitDetailsField = new JTextField("");
		
		Object[][] rowValues = new Object[10][4];
		String[] columnNames = {
		        "Order id", "Facility", "Drug", "Date"
		    };
		table = new JTable(rowValues,columnNames);
		table.setModel(new DefaultTableModel());
		DefaultTableModel model = ((DefaultTableModel) table.getModel());
		model.addColumn("Order id");
		model.addColumn("Facility");
		model.addColumn("Drug");
		model.addColumn("Date");
		JScrollPane scrollPane = new JScrollPane(table);
		table.setFillsViewportHeight(true); 
//		scrollPane.setSize(200, 400);
		
		editPanel.add(orderLabel1);
		editPanel.add(orderField1);
		editPanel.add(orderLabel2);
		editPanel.add(orderField2);//4
		editPanel.add(labelFac);
		editPanel.add(facField);
		editPanel.add(msdCodeLabel);
		editPanel.add(msdCodeField);
		editPanel.add(medNameLabel);
		editPanel.add(medNameField);//8
		editPanel.add(commonNameLabel);
		editPanel.add(commonNameField);
		editPanel.add(unitLabel);
		editPanel.add(unitField);//12
		editPanel.add(unitDetailsLabel);
		editPanel.add(unitDetailsField);
		
		
		JButton button = new JButton();
		button.addActionListener(new ButtonListener());
		button.setText("CLICK");
		
		
		frame.getContentPane().add(editPanel,BorderLayout.NORTH);
		frame.getContentPane().add(scrollPane,BorderLayout.CENTER);
		frame.getContentPane().add(button,BorderLayout.SOUTH);
		frame.pack();
		frame.setSize(new Dimension(400, 500));
		frame.setVisible(true);
		
		
		
	}
	
	public static void main(String[] args) {
		createWindow();
	}
	
}
