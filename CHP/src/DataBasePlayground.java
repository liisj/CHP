import java.sql.*;
import java.util.Properties;

public class DataBasePlayground {
	// Suppress default constructor for noninstantiability
	private DataBasePlayground() {
		throw new AssertionError();
	}

	static final String URL = "jdbc:postgresql://localhost:5433/chpv1";
	static final String USER = "postgres";
	static final String PASSWORD = "postgres";

	static String statementSetOrders = "SELECT d.med_name, o.unit_number, d.unit, d.id"
			+ " FROM orders o, drugs d"
			+ " WHERE o.drug_id = d.id"
			+ " AND o.facility_id = ?" + " ORDER BY d.id ASC";

	static PreparedStatement statementPutOrder = null;

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

	public static void initPutOrders(Connection con) {
		try {
			statementPutOrder = con.prepareStatement("INSERT INTO orders "
					+ "(facility_id,drug_id,unit_number) VALUES (?,?,?)");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * @param orders
	 *            Orders saved as arrays like [facility_id,drug_id,unit_number]
	 */
	public static void putOrders(int[][] orders) {
		if (statementPutOrder == null) {
			System.err.println("Init the action, dude.. (initPutOrders)");
			return;
		}
		try {
			for (int[] order : orders) {
				statementPutOrder.setInt(1, order[0]);
				statementPutOrder.setInt(2, order[1]);
				statementPutOrder.setInt(3, order[2]);
				statementPutOrder.addBatch();
			}
			statementPutOrder.executeBatch();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void getOrders(Connection con, int facility_id) {
		PreparedStatement pstmt;
		try {
			pstmt = con.prepareStatement(statementSetOrders);
			pstmt.setInt(1, facility_id);
			ResultSet rs = pstmt.executeQuery();
			String med_name, unit;
			int unit_number, id;
			while (rs.next()) {
				med_name = rs.getString(1);
				unit_number = rs.getInt(2);
				unit = rs.getString(3);
				id = rs.getInt(4);
				System.out.println(id + ": " + med_name + " | " + unit_number
						+ "x " + unit);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		Connection con = DataBasePlayground.getConnection();
		DataBasePlayground.getOrders(con, 1);
		int[][] orders = {{1,2,1},{1,3,1},{1,1,1}};
//		DataBasePlayground.putOrders(orders); //should fail
//		DataBasePlayground.initPutOrders(con);
//		DataBasePlayground.putOrders(orders);
		try {
			con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
