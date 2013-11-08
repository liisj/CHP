package com.test;

class DatabaseStatements {

	static final String GET_ORDER_NON_SUMMARIZED = "SELECT "
			+ "o.id AS Order_ID, "
			+ "o.timestamp AS order_timestamp, " + "o.status AS order_status, "
			+ "o.facility_id AS facility_id, "
			+ "row_to_json((d.*,o.unit_number)::drug_ext)::text AS drug "
			+ "FROM orders o JOIN drugs d "
			+ "ON o.drug_id = d.id "
			+ "JOIN categories c "
			+ "ON c.id = d.category_id "
			+ "WHERE o.timestamp BETWEEN ? AND ? "
			+ "AND o.id = COALESCE(?,o.id) "
			+ "AND o.status = COALESCE(?,o.status) "
			+ "AND o.facility_id = COALESCE(?,o.facility_id) "
			+ "ORDER BY o.id ASC";
	

	static final String GET_ORDER_SUMMARIZED = "SELECT DISTINCT "
			+ "o.id AS Order_ID, "
			+ "o.timestamp AS order_timestamp, " + "o.status AS order_status, "
			+ "o.facility_id AS facility_id, "
			+ "sum(d.unit_price*o.unit_number) as total_costs "
			+ "FROM orders o JOIN drugs d "
			+ "ON o.drug_id = d.id "
			+ "JOIN categories c "
			+ "ON c.id = d.category_id "
			+ "WHERE o.timestamp BETWEEN ? AND ? "
			+ "AND o.id = COALESCE(?,o.id) "
			+ "AND o.status = COALESCE(?,o.status) "
			+ "AND o.facility_id = COALESCE(?,o.facility_id) "
			+ "GROUP BY o.id, o.timestamp, o.status, o.facility_id "
			+ "ORDER BY o.id ASC";
	
	
}
