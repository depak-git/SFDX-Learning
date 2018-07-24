/////////////////////////////////////////////////////////////////////////
// Class: StudProgAmountDueQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION----------------------------- 
// 2016-12-23	Greg Cook 		Created
/////////////////////////////////////////////////////////////////////////
public class StudProgAmountDueQueries {
	public static Map<ID, StudentProgramAmountDue__c> getAmountDueMap(){
		Map<ID, StudentProgramAmountDue__c> studPrgMap = new Map<ID, StudentProgramAmountDue__c>();
		String query = generateSOQLSelect();
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' WHERE Agreement__r.Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Agreement__r.Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgramAmountDue__c>((List<StudentProgramAmountDue__c>)db.query(query));
		return studPrgMap;	
	}

	public static Map<ID, StudentProgramAmountDue__c> getAmountDueMapWithAgreementID(Set<ID> agreementIDs){
		Map<ID, StudentProgramAmountDue__c> studPrgMap = new Map<ID, StudentProgramAmountDue__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Agreement__c IN ' + DatabaseUtil.inSetStringBuilder(agreementIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Agreement__r.Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Agreement__r.Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgramAmountDue__c>((List<StudentProgramAmountDue__c>)db.query(query));
		return studPrgMap;	
	}

	public static Map<ID, StudentProgramAmountDue__c> getAmountDueMapWithStudentID(Set<ID> studentIDs){
		Map<ID, StudentProgramAmountDue__c> studPrgMap = new Map<ID, StudentProgramAmountDue__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Agreement__r.Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Agreement__r.Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Agreement__r.Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgramAmountDue__c>((List<StudentProgramAmountDue__c>)db.query(query));
		return studPrgMap;
	}


	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getfieldNames() + ' FROM StudentProgramAmountDue__c';
		system.debug(soql);
		return soql;
	}

	private static String getfieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
//		fieldNames += 'CreatedBy, ';
		fieldNames += 'Name, ';
		fieldNames += 'Agreement__c, ';
		fieldNames += 'Agreement__r.Student__c, ';
		fieldNames += 'Agreement__r.Program__c, ';
		
		fieldNames += 'Amount__c, ';
		fieldNames += 'RemainingAllocation__c, ';
		fieldNames += 'AssessmentDateTime__c, ';
		fieldNames += 'ExcludeFromBalance__c, ';
		fieldNames += 'Refund__c, ';
		fieldNames += 'StudentProgramMonthlyStatus__c, ';
		fieldNames += 'Type__c ';
		return fieldNames;
	}
	
	private static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}
}