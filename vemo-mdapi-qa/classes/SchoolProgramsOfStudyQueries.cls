/////////////////////////////////////////////////////////////////////////
// Class: SchoolProgramsOfStudyQueries
// 
// Description: 
// 	
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-01-01   Greg Cook       Created                                 
/////////////////////////////////////////////////////////////////////////
public class SchoolProgramsOfStudyQueries {
	public static Map<Id, SchoolProgramsOfStudy__c> getSchoolProgramOfStudyMap(){
		Map<ID, SchoolProgramsOfStudy__c> sposMap = new Map<ID, SchoolProgramsOfStudy__c>();
		String query = generateSOQLSelect();
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' WHERE School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		sposMap = new Map<ID, SchoolProgramsOfStudy__c>((List<SchoolProgramsOfStudy__c>)db.query(query));
		return sposMap;
	}

	public static Map<Id, SchoolProgramsOfStudy__c> getSchoolProgramOfStudyMapWithSPOSID(Set<ID> studentProgramsOfStudyIDs){
		Map<ID, SchoolProgramsOfStudy__c> sposMap = new Map<ID, SchoolProgramsOfStudy__c>();
		String query = generateSOQLSelect();
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(studentProgramsOfStudyIDs);
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' and School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		sposMap = new Map<ID, SchoolProgramsOfStudy__c>((List<SchoolProgramsOfStudy__c>)db.query(query));
		return sposMap;
	}

	public static Map<Id, SchoolProgramsOfStudy__c> getSchoolProgramOfStudyMapWithPOSID(Set<ID> programOfStudyIDs){
		Map<ID, SchoolProgramsOfStudy__c> sposMap = new Map<ID, SchoolProgramsOfStudy__c>();
		String query = generateSOQLSelect();
		query += ' WHERE ProgramOfStudy__c IN ' + DatabaseUtil.inSetStringBuilder(programOfStudyIDs);
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' and School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		sposMap = new Map<ID, SchoolProgramsOfStudy__c>((List<SchoolProgramsOfStudy__c>)db.query(query));
		return sposMap;
	}

	public static Map<Id, SchoolProgramsOfStudy__c> getSchoolProgramOfStudyMapWithSchoolID(Set<ID> schoolIDs){
		Map<ID, SchoolProgramsOfStudy__c> sposMap = new Map<ID, SchoolProgramsOfStudy__c>();
		String query = generateSOQLSelect();
		query += ' WHERE School__c IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' and School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		sposMap = new Map<ID, SchoolProgramsOfStudy__c>((List<SchoolProgramsOfStudy__c>)db.query(query));
		return sposMap;
	}

	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getFieldNames() + ' FROM SchoolProgramsOfStudy__c';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Name, ';
		fieldNames += 'ProgramOfStudy__c, ';
		fieldNames += 'ProgramOfStudy__r.CIPCode__c, ';	
		fieldNames += 'ProgramOfStudy__r.CIPDefinition__c, ';				
		fieldNames += 'ProgramOfStudy__r.CIPFamily__c, ';	
		fieldNames += 'ProgramOfStudy__r.CIPTitle__c, ';	
		fieldNames += 'ProgramOfStudy__r.CrossReferences__c, ';
		fieldNames += 'ProgramOfStudy__r.Examples__c, ';
		//fieldNames += 'ProgramOfStudy__r.GUID__c, ';
		fieldNames += 'ProgramOfStudy__r.Description__c, ';
		fieldNames += 'Description__c, ';
		fieldNames += 'SchoolDescription__c, ';
		fieldNames += 'School__c';
		return fieldNames;
	}

	private static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}
}