/////////////////////////////////////////////////////////////////////////
// Class: CaseQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public class CaseQueries {
	public static Map<String, Object> filterCriteria = new Map<String, Object>();
	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}
	public static Map<ID, Case> getCaseMapByID(){
		Map<ID, Case> caseMap = new Map<ID, Case>();
		String query = generateSOQLSelect();
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' WHERE AccountID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		caseMap = new Map<ID, Case>((List<Case>)db.query(query));
		return caseMap;	
	}

	public static Map<ID, Case> getCaseMapWithCaseID(Set<ID> caseIDs){
		Map<ID, Case> caseMap = new Map<ID, Case>();
		String query = generateSOQLSelect();
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(caseIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and AccountID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		caseMap = new Map<ID, Case>((List<Case>)db.query(query));
		return caseMap;	
	}

	public static Map<ID, Case> getCaseMapWithStudentID(Set<ID> studentIDs){
		Map<ID, Case> caseMap = new Map<ID, Case>();
		String query = generateSOQLSelect();
		query += ' WHERE AccountID IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and AccountID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		caseMap = new Map<ID, Case>((List<Case>)db.query(query));
		return caseMap;	
	}

	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getFieldNames() + ' FROM Case ';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Type, ';
		fieldNames += 'Status, ';
		fieldNames += 'Reason, ';
		fieldNames += 'AccountID, ';
		fieldNames += 'Description, ';
		fieldNames += 'Subject, ';
		fieldNames += 'OwnerID ';
		return fieldNames;
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
}