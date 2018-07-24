public with sharing class IncomeBandQueries {

	public static Map<String, Object> filterCriteria = new Map<String, Object>();
	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}

	public static Map<ID, IncomeBand__c> getIncomeBandMap(){
		Map<ID, IncomeBand__c> peMap = new Map<ID, IncomeBand__c>();
		String query = generateSOQLSelect();
		query += ' WHERE EarningsGroup__c != null';
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' AND SchoolProgramOfStudy__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		peMap = new Map<ID, IncomeBand__c>((List<IncomeBand__c>)db.query(query));
		return peMap;		
	}

	public static Map<ID, IncomeBand__c> getIncomeBandMapWithSchoolProgramOfStudyIDs(Set<ID> schoolProgramOfStudyIDs){
		Map<ID, IncomeBand__c> peMap = new Map<ID, IncomeBand__c>();
		String query = generateSOQLSelect();
		query += ' WHERE SchoolProgramOfStudy__c IN ' + DatabaseUtil.inSetStringBuilder(schoolProgramOfStudyIDs);

		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' AND SchoolProgramOfStudy__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		peMap = new Map<ID, IncomeBand__c>((List<IncomeBand__c>)db.query(query));
		return peMap;		
	}

	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getFieldNames() + ' FROM IncomeBand__c';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Name, ';
		fieldNames += 'EarningsGroup__c, ';
		fieldNames += 'SchoolProgramOfStudy__c, ';
		fieldNames += 'SchoolProgramOfStudy__r.Description__c, ';
		fieldNames += 'SchoolProgramOfStudy__r.ProgramOfStudy__c, ';
		fieldNames += 'SchoolProgramOfStudy__r.School__c ';

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