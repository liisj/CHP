package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Properties;

import database.objects.DBDrug;

public class DataBaseFunctions {

	static final String URL = "jdbc:postgresql://localhost:5433/chpv1";
	static final String USER = "postgres";
	static final String PASSWORD = "postgres";

	static final String selectOrder = "SELECT o.id,f.name,d.common_name,d.unit,d.med_name,o.timestamp ";
	static final String fromOrder = "FROM facilities f JOIN orders o ON f.id = o.facility_id "
			+ "JOIN drugs d ON o.drug_id = d.id ";

	public static Connection getConnection() {
		try {
			Class.forName("org.postgresql.Driver");
			Properties props = new Properties();
			props.setProperty("user", USER);
			props.setProperty("password", PASSWORD);
			Connection conn = DriverManager.getConnection(URL, props);
			return conn;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static Object[][] search(Connection con, String facility_name, DBDrug drug,
			Timestamp start, Timestamp end) throws SQLException {


		StringBuilder whereBuilder = new StringBuilder("");

		whereBuilder.append(selectOrder);
		whereBuilder.append(fromOrder);

		int c = 0;

		if (facility_name != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("f.name LIKE ('%'||?||'%')");
		}

		if (start != null)
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE ")
					+ "o.timestamp >= ?");
		if (end != null)
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE ")
					+ "o.timestamp <= ?");

		if (drug != null) {
			if (drug.med_name != null)
				whereBuilder
						.append((c > 0 ? " AND " : "WHERE ")
								+ "(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))");
			if (drug.common_name != null)
				whereBuilder
						.append((c > 0 ? " AND " : "WHERE ")
								+ "(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))");
			if (drug.msdcode > -1)
				whereBuilder.append((c > 0 ? " AND " : "WHERE ")
						+ "d.msdcode = ?");
			if (drug.unit != null)
				whereBuilder.append((c > 0 ? " AND " : "WHERE ")
						+ "d.unit LIKE ('%'||?||'%')");
			if (drug.unit_details != null)
				whereBuilder.append((c > 0 ? " AND " : "WHERE ")
						+ "d.unit_details LIKE ('%'||?||'%')");
		}

		PreparedStatement pstmt = con
				.prepareStatement(whereBuilder.toString());
		

		int p = 1;
		if (facility_name != null)
			pstmt.setString(p++, facility_name);
		if (start != null)
			pstmt.setTimestamp(p++, start);
		if (end != null)
			pstmt.setTimestamp(p++, end);
		if (drug != null) {
			if (drug.med_name != null) {
				pstmt.setString(p++, drug.med_name);
				pstmt.setString(p++, drug.med_name);
			}
			if (drug.common_name != null) {
				pstmt.setString(p++, drug.common_name);
				pstmt.setString(p++, drug.common_name);
			}
			if (drug.msdcode > -1)
				pstmt.setInt(p++, drug.msdcode);
			if (drug.unit != null)
				pstmt.setString(p++, drug.unit);
			if (drug.unit_details != null)
				pstmt.setString(p++, drug.unit_details);
		}

		System.out.println(pstmt.toString());
		
		
		
		
		ResultSet rs = pstmt.executeQuery();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		
		ArrayList<Object[]> rows = new ArrayList<>();
		String[] columns = new String[rsmd.getColumnCount()];
		rows.add(columns);
		
		for (int i = 0; i < columns.length; i++) {
			columns[i] = rsmd.getColumnName(i+1);
		}

		while (rs.next()) {
			Object[] oneRow = new Object[columns.length];
			for (int i = 0; i < columns.length; i++) {
				oneRow[i] = rs.getObject(i+1);
			}
			rows.add(oneRow);
		}
		Object[][] ret = new Object[rows.size()][columns.length];
		for (int i = 0 ; i < ret.length ; i++)
			ret[i] = rows.get(i);
			
		return ret;
		
	}

}
