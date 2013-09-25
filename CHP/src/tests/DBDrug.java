package tests;

public class DBDrug {
	int id;
	int msdcode;
	String med_name;
	String common_name;
	String unit;
	String unit_details;
	String unit_price;
	
	public DBDrug(int id, int msdcode, String med_name, String common_name,
			String unit, String unit_details, String unit_price) {
		super();
		this.id = id;
		this.msdcode = msdcode;
		this.med_name = med_name;
		this.common_name = common_name;
		this.unit = unit;
		this.unit_details = unit_details;
		this.unit_price = unit_price;
	}
	
}
