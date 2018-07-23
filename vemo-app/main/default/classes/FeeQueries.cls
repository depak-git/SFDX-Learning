/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann	Created 
/////////////////////////////////////////////////////////////////////////
public class FeeQueries {
	public static Map<String, Object> filterCriteria = new Map<String, Object>();

	public static Map<ID, Fee__c> getFeeMap(){
		Map<ID, Fee__c> feeMap = new Map<ID, Fee__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Id != null';
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Customer__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		feeMap = new Map<ID, Fee__c>((List<Fee__c>)db.query(query));
		return feeMap;		
	}

	public static Map<ID, Fee__c> getFeeMapWithFeeId(Set<Id> feeIds){
		Map<ID, Fee__c> feeMap = new Map<ID, Fee__c>();
		String query = generateSOQLSelect();
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(feeIds);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Customer__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		feeMap = new Map<ID, Fee__c>((List<Fee__c>)db.query(query));
		return feeMap;		
	}

	public static Map<ID, Fee__c> getFeeMapWithCustomerId(Set<Id> customerIds){
		Map<ID, Fee__c> feeMap = new Map<ID, Fee__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Customer__c IN ' + DatabaseUtil.inSetStringBuilder(customerIds);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Customer__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		feeMap = new Map<ID, Fee__c>((List<Fee__c>)db.query(query));
		return feeMap;		
	}

	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}

	private static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}
	
	private static String buildFilterString(){
		String filterStr = '';
		if(filterCriteria.size()>0){
			for(String filter : filterCriteria.keyset()){
				filterStr += ' and ' +filter+'=\''+String.valueOf(filterCriteria.get(filter) + 	'\' ');
			}			
		}
		return filterStr;
	}

	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getIncomeVerificationFieldNames() + ' FROM Fee__c ';
		return soql;
	}

	private static String getIncomeVerificationFieldNames(){
		String fieldNames;
		fieldNames = 'Id, ';
		fieldNames += 'Amount__c, ';
		fieldNames += 'Customer__c, ';
		fieldNames += 'DateAssessed__c , ';
		fieldNames += 'DateCleared__c, ';
		fieldNames += 'Status__c, ';
		fieldNames += 'Type__c ';
		return fieldNames;
	}
}