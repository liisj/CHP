package database;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DBOrderSearch {
	
	String facility_name;
	DBDrug drug;
	Date start;
	Date end;
	
	
	

	public DBOrderSearch(String facility_name, DBDrug drug, Date start, Date end) {
		super();
		this.facility_name = facility_name;
		this.drug = drug;
		this.start = start;
		this.end = end;
	}




	public PreparedStatement giveSearchStatement(Connection con) throws SQLException {
		String select = "SELECT o.id,f.name,d.med_name,o.date ";
		String from = "FROM facilities f JOIN orders o ON f.id = o.facility_id "
				+ "JOIN drugs d ON o.drug_id = d.id ";
		String wh = "";
		
		int c = 0;
		
		if (facility_name!=null) {
			wh += (c++>0?" AND ":"WHERE ");
			wh += "f.name LIKE ('%'||?||'%')";
		}
		
		boolean[] use_dates = {true,true};
		if (start != null || end != null) {
			wh += (c++>0?" AND ":"WHERE ");
			if (start==null) {
				wh += "o.date <= ?";
				use_dates[0]=false;
			}
			else if (end==null) {
				wh += "o.date >= ?";
				use_dates[1]=false;
			}
			else
				wh += "o.date BETWEEN ? AND ?";
		}
		else {
			use_dates[0]=false;
			use_dates[1]=false;
		}
		
		if (drug != null) {
			if (drug.med_name!=null)
				wh += (c>0?" AND ":"WHERE ") + "(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))";
			if (drug.common_name!=null)
				wh += (c>0?" AND ":"WHERE ") + "(d.med_name LIKE ('%'||?||'%') OR d.common_name LIKE ('%'||?||'%'))";
			if (drug.msdcode>-1)
				wh += (c>0?" AND ":"WHERE ") + "d.msdcode = ?";
			if (drug.unit!=null)
				wh += (c>0?" AND ":"WHERE ") + "d.unit LIKE ('%'||?||'%')";
			if (drug.unit_details!=null)
				wh += (c>0?" AND ":"WHERE ") + "d.unit_details LIKE ('%'||?||'%')";
		}
		
		System.out.println(select+from+wh);
		PreparedStatement pstmt2 = con.prepareStatement(select+from+wh);
		
		int p = 1;
		if (facility_name!=null)
			pstmt2.setString(p++, facility_name);
		if (use_dates[0])
			pstmt2.setDate(p++, start);
		if (use_dates[1])
			pstmt2.setDate(p++, end);
		if (drug != null) {
			if (drug.med_name!=null) {
				pstmt2.setString(p++, drug.med_name);
				pstmt2.setString(p++, drug.med_name);
			}
			if (drug.common_name!=null) {
				pstmt2.setString(p++, drug.common_name);
				pstmt2.setString(p++, drug.common_name);
			}
			if (drug.msdcode>-1)
				pstmt2.setInt(p++, drug.msdcode);
			if (drug.unit!=null)
				pstmt2.setString(p++, drug.unit);
			if (drug.unit_details!=null)
				pstmt2.setString(p++, drug.unit_details);
		}

		
		
		return pstmt2;
	}
	
}
