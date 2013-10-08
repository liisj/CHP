package database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import org.apache.commons.dbcp.BasicDataSource;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class DataBaseFunctions {

	static final String URL = "jdbc:postgresql://localhost:5433/chpv1";
	static final String USER = "postgres";
	static final String PASSWORD = "postgres";

	static final String selectOrder = "SELECT " + "o.id," + "o.timestamp,"
			+ "o.unit_number," + "o.status," + "d.id," + "d.category,"
			+ "d.med_name," + "d.common_name," + "d.unit," + "d.unit_details,"
			+ "d.unit_price," + "f.id," + "f.name";
	static final String fromOrder = " FROM facilities f JOIN orders o ON f.id = o.facility_id "
			+ "JOIN drugs d ON o.drug_id = d.id ";

	static final String getCategoryName = "SELECT c.id,c.name FROM categories c";

	static final String addOrder = "INSERT INTO "
			+ "orders (id,facility_id,drug_id,unit_number,timestamp,status) "
			+ "VALUES (default,?,?,?,now(),?::order_status)";

	static final String updateInventory = "UPDATE inventories SET unit_number = ? + unit_number"
			+ "WHERE facility_id = ? AND drug_id = ?";

	private static BasicDataSource dataSourceWeb = null;

	/**
	 * Transforms the rows, received through the given ResultSet, into
	 * JSONObjects and returns them as a JSONArray
	 * 
	 * @param resultSet ResultSet to be transformed
	 * @return JSONArray containing JSONObjects
	 * @throws SQLException
	 */
	private static JSONArray resultSetToJSONArray(ResultSet resultSet)
			throws SQLException {
		ResultSetMetaData resultMeta = resultSet.getMetaData();

		int columnNumber = resultMeta.getColumnCount();
		String[] columnNames = new String[columnNumber];
		Integer[] columnTypes = new Integer[columnNumber];
		for (int columnIndex = 1; columnIndex <= columnNumber; columnIndex++) {
			columnNames[columnIndex - 1] = resultMeta
					.getColumnLabel(columnIndex);
			columnTypes[columnIndex - 1] = resultMeta
					.getColumnType(columnIndex);

		}

		JSONArray resultArray = new JSONArray();

		while (resultSet.next()) {
			JSONObject jsonRow = new JSONObject();
			for (int columnIndex = 1; columnIndex <= columnNumber; columnIndex++) {
				String columnName = columnNames[columnIndex - 1];
				System.out.println("");
				System.out.print(columnNames[columnIndex - 1] + ": ");
				switch (columnTypes[columnIndex - 1]) {
				case Types.INTEGER:
					jsonRow.put(columnName, resultSet.getInt(columnIndex));
					System.out.print(resultSet.getInt(columnIndex) + " ");
					break;
				case Types.TIMESTAMP:
					jsonRow.put(columnName, resultSet.getTimestamp(columnIndex));
					System.out.print(resultSet.getTimestamp(columnIndex) + " ");
					break;
				case Types.VARCHAR:
				case Types.CHAR:
					jsonRow.put(columnName, resultSet.getString(columnIndex));
					System.out.print(resultSet.getString(columnIndex) + " ");
					break;
				case Types.NUMERIC:
				case Types.DOUBLE:
					jsonRow.put(columnName, resultSet.getDouble(columnIndex));
					System.out.print(resultSet.getDouble(columnIndex) + " ");
					break;
				default:
					jsonRow.put(columnName, resultSet.getObject(columnIndex));
					System.out.print(resultSet.getObject(columnIndex) + " ");
					break;
				}
			}
			System.out.println("");
			System.out.println(jsonRow);
			resultArray.add(jsonRow);
		}
		return resultArray;

	}

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

	/**
	 * 
	 * @param con
	 *            Connection to be used
	 * @param parameters
	 *            JSON Object with the following parameters:<br>
	 *            order_id (int),<br>
	 *            order_unit_number (int),<br>
	 *            order_start (Timestamp: yyyy-[m]m-[d]d hh:mm:ss),<br>
	 *            order_end (Timestamp: yyyy-[m]m-[d]d hh:mm:ss),<br>
	 *            drug_id (int),<br>
	 *            drug_med_name (String),<br>
	 *            drug_common_name (String),<br>
	 *            drug_unit (String),<br>
	 *            drug_unit_details (String),<br>
	 *            drug_msdcode (int),<br>
	 *            facility_id (int),<br>
	 *            facility_name (String)
	 * @return
	 * @throws SQLException
	 */
	public static JSONArray search(Connection con, JSONObject parameters)
			throws SQLException {

		Integer order_id = (Integer) parameters.get("order_id");
		Integer order_unit_number = (Integer) parameters
				.get("order_unit_number");
		String order_start_String = (String) parameters.get("order_start");
		Timestamp order_start = order_start_String == null ? null
				: java.sql.Timestamp.valueOf(order_start_String);
		String order_end_String = (String) parameters.get("order_end");
		Timestamp order_end = order_end_String == null ? null
				: java.sql.Timestamp.valueOf(order_end_String);
		String order_status = (String) parameters.get("order_status");

		Integer drug_id = (Integer) parameters.get("drug_id");
		String drug_med_name = (String) parameters.get("drug_med_name");
		String drug_common_name = (String) parameters.get("drug_common_name");
		String drug_unit = (String) parameters.get("drug_unit");
		String drug_unit_details = (String) parameters.get("drug_unit_details");
		Integer drug_msdcode = (Integer) parameters.get("drug_msdcode");

		Integer facility_id = (Integer) parameters.get("facility_id");
		String facility_name = (String) parameters.get("facility_name");

		StringBuilder whereBuilder = new StringBuilder("");
		whereBuilder.append(selectOrder);
		whereBuilder.append(fromOrder);

		int c = 0;

		if (order_id != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("o.id = ?");
		}

		if (order_unit_number != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("o.unit_number = ?");
		}

		if (order_start != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("o.timestamp >= ?");
		}

		if (order_end != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("o.timestamp <= ?");
		}

		if (order_status != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("o.status = ?::order_status");
		}

		if (drug_id != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("d.id = ?");
		}

		if (drug_med_name != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder
					.append("(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))");
		}

		if (drug_common_name != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder
					.append("(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))");
		}

		if (drug_unit != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("d.unit LIKE ('%'||?||'%')");
		}

		if (drug_unit_details != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("d.unit_details LIKE ('%'||?||'%')");
		}

		if (drug_msdcode != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("d.msdcode = ?");
		}

		if (facility_id != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("f.id = ?");
		}

		if (facility_name != null) {
			whereBuilder.append((c++ > 0 ? " AND " : "WHERE "));
			whereBuilder.append("f.name LIKE ('%'||?||'%')");
		}

		PreparedStatement pstmt = con.prepareStatement(whereBuilder.toString());

		int p = 1;

		if (order_id != null)
			pstmt.setInt(p++, order_id);

		if (order_unit_number != null)
			pstmt.setInt(p++, order_unit_number);

		if (order_start != null)
			pstmt.setTimestamp(p++, order_start);

		if (order_end != null)
			pstmt.setTimestamp(p++, order_end);

		if (order_status != null)
			pstmt.setString(p++, order_status);

		if (drug_id != null)
			pstmt.setInt(p++, drug_id);

		if (drug_med_name != null) {
			pstmt.setString(p++, drug_med_name);
			pstmt.setString(p++, drug_med_name);
		}

		if (drug_common_name != null) {
			pstmt.setString(p++, drug_common_name);
			pstmt.setString(p++, drug_common_name);
		}

		if (drug_unit != null)
			pstmt.setString(p++, drug_unit);

		if (drug_unit_details != null)
			pstmt.setString(p++, drug_unit_details);

		if (drug_msdcode != null)
			pstmt.setInt(p++, drug_msdcode);

		if (facility_id != null)
			pstmt.setInt(p++, facility_id);

		if (facility_name != null)
			pstmt.setString(p++, facility_name);

		System.out.println(pstmt.toString());

		ResultSet rs = pstmt.executeQuery();

		JSONArray resultArray = resultSetToJSONArray(rs);

		return resultArray;

	}

	/**
	 * 
	 * @param con
	 *            Connection to be used
	 * @return JSONArray containing Categories, stored as JSONObjects
	 * @throws SQLException
	 */
	public static JSONArray getCategoryNames(Connection con)
			throws SQLException {
		ResultSet rs = con.createStatement().executeQuery(getCategoryName);
		return resultSetToJSONArray(rs);
	}

	/**
	 * 
	 * @param con
	 *            Connection to be used
	 * @param parameters
	 *            JSON Object with the following parameters:<br>
	 *            order_id (int),<br>
	 *            drug_id (int),<br>
	 *            facility_id (int),<br>
	 *            status (String),<br>
	 * @return true if operation succeeded, false otherwise
	 * @throws SQLException
	 */
	public static boolean addOrder(Connection con, JSONObject parameters)
			throws SQLException {
		if (parameters == null)
			return false;
		Integer facility_id = (Integer) parameters.get("facility_id");
		Integer drug_id = (Integer) parameters.get("drug_id");
		Integer unit_number = (Integer) parameters.get("unit_number");
		String status = (String) parameters.get("status");

		if (facility_id == null || drug_id == null || unit_number == null
				|| status == null)
			return false;

		PreparedStatement pstmt = con.prepareStatement(addOrder);

		pstmt.setInt(1, (Integer) parameters.get("facility_id"));
		pstmt.setInt(2, (Integer) parameters.get("drug_id"));
		pstmt.setInt(3, (Integer) parameters.get("unit_number"));
		pstmt.setString(4, (String) parameters.get("status"));

		pstmt.execute();

		return true;
	}

	/**
	 * 
	 * @param con
	 * @param parameters
	 * @return true if operation succeeded, false otherwise
	 * @throws SQLException
	 */
	public static boolean updateInventory(Connection con, JSONObject parameters)
			throws SQLException {
		if (parameters == null)
			return false;
		Integer facility_id = (Integer) parameters.get("facility_id");
		Integer drug_id = (Integer) parameters.get("drug_id");
		Integer difference = (Integer) parameters.get("difference");

		if (facility_id == null || drug_id == null || difference == null)
			return false;

		PreparedStatement pstmt = con.prepareStatement(updateInventory);

		pstmt.setInt(1, difference);
		pstmt.setInt(2, facility_id);
		pstmt.setInt(3, drug_id);

		pstmt.execute();

		return true;

	}

	public static void main(String[] args) {
		Connection con = getWebConnection();
		JSONObject input = new JSONObject();
		input.put("facility", "Peter");
		// input.put("drug_common_name", "Asp");
		JSONArray arr = null;
		try {
			arr = search(con, input);
			// arr = getCategoryNames(con);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
