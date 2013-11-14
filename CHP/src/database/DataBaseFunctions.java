package database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayDeque;

import org.apache.commons.dbcp.BasicDataSource;
import org.json.simple.JSONObject;

public class DataBaseFunctions {

	static final String URL = "jdbc:postgresql://localhost:5433/chpv1";
	static final String USER = "postgres";
	static final String PASSWORD = "postgres";
	
	static final String ADD_GUIDELINE = "INSERT INTO treatments (id,diagnosis,treatment) VALUES (default,(?)::ltree,?);";

	static final String ADD_KEYS = "INSERT INTO descriptions (key,description) VALUES ";
	
	
	private static BasicDataSource dataSourceWeb = null;

	public static Connection getWebConnection() {
		try {
			if (dataSourceWeb == null) {
				dataSourceWeb = new BasicDataSource();
				dataSourceWeb.setDriverClassName("org.postgresql.Driver");
				dataSourceWeb.setUrl(URL);
				dataSourceWeb.setUsername(USER);
				dataSourceWeb.setPassword(PASSWORD);
			}

			return dataSourceWeb.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
//	public static JSONArray nextSteps(Connection con, JSONObject parameters) {
//		String history = (String) parameters.get("history");
//		
//	}
	
	
	public static void addKeys(Connection con, JSONObject parameters) {
		ArrayDeque<String[]> vals = new ArrayDeque<>();
		for (Object keyO : parameters.keySet()) {
			String key = (String) keyO;
			if (!key.matches("[A-Za-z0-9_]*"))
				continue;
			String description = (String) parameters.get(keyO);
			String[] oneVal = {key,description};
			vals.add(oneVal);
		}
		
		int size = vals.size();
		
		if (size==0)
			return;
		
		StringBuilder sb = new StringBuilder(ADD_KEYS);
		for (int i = 0 ; i < size ; i++) {
			if (i>0)
				sb.append(",");
			sb.append("(?,?)");
		}
		
		try {
			PreparedStatement pstmt = con.prepareStatement(sb.toString());
			int p = 1;
			while (!vals.isEmpty()) {
				String[] val = vals.pop();
				pstmt.setString(p++, val[0]);
				pstmt.setString(p++, val[1]);
			}
			//TODO
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
	}
	
	
	public static void addNewGuideline(Connection con, JSONObject parameters) {
		String path = (String) parameters.get("path");
		String therapy = (String) parameters.get("therapy");
		
		try {
			PreparedStatement pstmt = con.prepareStatement(ADD_GUIDELINE);
			pstmt.setString(1, path);;
			pstmt.setString(2, therapy);
			//TODO
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	
}
