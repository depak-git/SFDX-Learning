/////////////////////////////////////////////////////////////////////////
// Class: EmploymentHistoryQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann	Created 
/////////////////////////////////////////////////////////////////////////
public class EmploymentHistoryQueries {
	public static Map<String, Object> filterCriteria = new Map<String, Object>();
	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}

	public static Map<ID, EmploymentHistory__c> getEmploymentHistoryMap(){
		Map<ID, EmploymentHistory__c> empHisMap = new Map<ID, EmploymentHistory__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Id != null';
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		empHisMap = new Map<ID, EmploymentHistory__c>((List<EmploymentHistory__c>)db.query(query));
		return empHisMap;		
	}

	public static Map<ID, EmploymentHistory__c> getEmploymentHistoryMapWithStudentId(Set<ID> studentIds){
		Map<ID, EmploymentHistory__c> empHisMap = new Map<ID, EmploymentHistory__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIds);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		empHisMap = new Map<ID, EmploymentHistory__c>((List<EmploymentHistory__c>)db.query(query));
		return empHisMap;
	}

	public static Map<ID, EmploymentHistory__c> getEmploymentHistoryMapWithEmploymentHistoryId(Set<ID> empHisIDs){
		Map<ID, EmploymentHistory__c> empHisMap = new Map<ID, EmploymentHistory__c>();
		String query = generateSOQLSelect();
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(empHisIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		empHisMap = new Map<ID, EmploymentHistory__c>((List<EmploymentHistory__c>)db.query(query));
		return empHisMap;
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
		soql = 'SELECT ' + getEmploymentHistoryFieldNames() + ' FROM EmploymentHistory__c ';
		return soql;
	}

	private static String getEmploymentHistoryFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Category__c, ';
		fieldNames += 'Employer__c, ';
		fieldNames += 'EmploymentEndDate__c, ';
		fieldNames += 'EmploymentStartDate__c, ';
		fieldNames += 'Student__c, ';
		fieldNames += 'Type__c, ';
		fieldNames += 'Verified__c ';
		return fieldNames;
	}
}