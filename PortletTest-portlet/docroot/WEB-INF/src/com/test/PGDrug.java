package com.test;

import java.sql.SQLException;

import org.json.simple.JSONObject;
import org.postgresql.util.PGobject;

public class PGDrug extends PGobject{
	/**
	 * 
	 */
	private static final long serialVersionUID = 921226464532233056L;
    private String val;
    

    @Override
    public String toString() {
    	return val;
    }
    
    @Override
    public String getValue() {
    	return val;
    };

    @Override
    public void setValue(String value) throws SQLException {
    	val = value;
    };
    
	@SuppressWarnings("unchecked")
	public JSONObject toJSONObject() {
		JSONObject result = new JSONObject();
		
		int i = 0;
		String valCopy = val.substring(1, val.length()-1);
		String[] args = valCopy.split(",");
		
		result.put("id", args[i++]);
		result.put("msdcode", args[i++]);
		result.put("category_id", args[i++]);
		result.put("med_name", args[i++]);
		result.put("common_name", args[i++]);
		result.put("unit", args[i++]);
		result.put("unit_details", args[i++]);
		result.put("unit_price", args[i++]);
		result.put("category_name", args[i++]);
		result.put("unit_number", args[i++]);
		
		
		
		return result;
		
	}

}
