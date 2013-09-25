package tests;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import database.objects.DBDrug;

public class DBOrderSearch {

	String facility_name;
	DBDrug drug;
	Timestamp start;
	Timestamp end;

	public DBOrderSearch(String facility_name, DBDrug drug, Timestamp start2, Timestamp end2) {
		super();
		this.facility_name = facility_name;
		this.drug = drug;
		this.start = start2;
		this.end = end2;
	}

	public PreparedStatement giveSearchStatement(Connection con)
			throws SQLException {
		String select = "SELECT o.id,f.name,d.med_name,o.timestamp ";
		String from = "FROM facilities f JOIN orders o ON f.id = o.facility_id "
				+ "JOIN drugs d ON o.drug_id = d.id ";
		String wh = "";

		int c = 0;

		if (facility_name != null) {
			wh += (c++ > 0 ? " AND " : "WHERE ");
			wh += "f.name LIKE ('%'||?||'%')";
		}

		if (start != null)
			wh += (c++ > 0 ? " AND " : "WHERE ") + "o.timestamp >= ?";
		if (end != null)
			wh += (c++ > 0 ? " AND " : "WHERE ") + "o.timestamp <= ?";

		if (drug != null) {
			if (drug.med_name != null)
				wh += (c > 0 ? " AND " : "WHERE ")
						+ "(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))";
			if (drug.common_name != null)
				wh += (c > 0 ? " AND " : "WHERE ")
						+ "(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))";
			if (drug.msdcode > -1)
				wh += (c > 0 ? " AND " : "WHERE ") + "d.msdcode = ?";
			if (drug.unit != null)
				wh += (c > 0 ? " AND " : "WHERE ")
						+ "d.unit LIKE ('%'||?||'%')";
			if (drug.unit_details != null)
				wh += (c > 0 ? " AND " : "WHERE ")
						+ "d.unit_details LIKE ('%'||?||'%')";
		}

		PreparedStatement pstmt2 = con.prepareStatement(select + from + wh);

		int p = 1;
		if (facility_name != null)
			pstmt2.setString(p++, facility_name);
		if (start!=null)
			pstmt2.setTimestamp(p++, start);
		if (end!=null)
			pstmt2.setTimestamp(p++, end);
		if (drug != null) {
			if (drug.med_name != null) {
				pstmt2.setString(p++, drug.med_name);
				pstmt2.setString(p++, drug.med_name);
			}
			if (drug.common_name != null) {
				pstmt2.setString(p++, drug.common_name);
				pstmt2.setString(p++, drug.common_name);
			}
			if (drug.msdcode > -1)
				pstmt2.setInt(p++, drug.msdcode);
			if (drug.unit != null)
				pstmt2.setString(p++, drug.unit);
			if (drug.unit_details != null)
				pstmt2.setString(p++, drug.unit_details);
		}

		System.out.println(pstmt2.toString());

		return pstmt2;
	}

}
