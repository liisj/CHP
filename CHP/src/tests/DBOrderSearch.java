package tests;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import database.objects.DBDrug;

public class DBOrderSearch {

	String facility_name;
	DBDrug drug;
	Timestamp start;
	Timestamp end;

	static final String selectOrder = "SELECT o.id,f.name,d.common_name,d.unit,d.med_name,o.timestamp ";
	static final String fromOrder = "FROM facilities f JOIN orders o ON f.id = o.facility_id "
			+ "JOIN drugs d ON o.drug_id = d.id ";

	public DBOrderSearch(String facility_name, DBDrug drug, Timestamp start2,
			Timestamp end2) {
		super();
		this.facility_name = facility_name;
		this.drug = drug;
		this.start = start2;
		this.end = end2;
	}


}
