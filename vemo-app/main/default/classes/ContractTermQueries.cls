public with sharing class ContractTermQueries {
//SELECT ID, Name, AgeOfMajority__c, Residency__c, EnrollmentStatus__c, GradeLevel__c, SchoolProgramOfStudy__c, Campus__c, Program__c, State__c FROM ProgramEligibility__c where AgeOfMajority__c < 19 and Residency__c includes ('US Citizen') and EnrollmentStatus__c includes ('Full Time') and GradeLevel__c includes ('Freshman') and SchoolProgramOfStudy__c = 'a0o7A000000xVuJQAU' and Campus__c Like '%West%' and Program__c = 'a0n7A0000012a6nQAA' and State__c includes ('AL')

	public static Map<String, Object> filterCriteria = new Map<String, Object>();
	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}

	public static Map<ID, ContractTerm__c> getContractTermMap(){
		Map<ID, ContractTerm__c> peMap = new Map<ID, ContractTerm__c>();
		String query = generateSOQLSelect();
		query += ' WHERE MaximumFundingAmount__c >= 0';
//		if(DatabaseUtil.filterBySchoolID){
//			ID schoolID = DatabaseUtil.schoolID;
//			query += ' AND Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
//		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		peMap = new Map<ID, ContractTerm__c>((List<ContractTerm__c>)db.query(query));
		return peMap;		
	}
/*
	public static Map<ID, Boolean> evaluateEligibility(ID programID, Set<ID> studentIDs){
		//Takes a list of students and returns of map of eligibility for those students
		Map<ID, Boolean> returnMap = new Map<ID, Boolean>();

		Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
		List<ProgramEligibility__c> eligibility = new List<ProgramEligibility__c>();
		for(Account stud : studentMap.values()){
			//must query each student - NOT BULK SAFE
			eligibility.clear();
			String query = generateSOQLSelect();
			query += ' WHERE AgeOfMajority__c <= ' + stud.Age__pc;
			query += ' and Residency__c includes (\'' + stud.Residency__pc + '\')';
			query += ' and EnrollmentStatus__c includes (\'' + stud.PrimarySchoolEnrollmentStatus__pc + '\')';
			query += ' and GradeLevel__c includes (\'' + stud.PrimarySchoolGradeLevel__pc + '\')';
			if(stud.SchoolProgramOfStudy__pc != null){
				query += ' and SchoolProgramOfStudy__c = \'' + stud.SchoolProgramOfStudy__pc + '\'';				
			} else {
				query += ' and SchoolProgramOfStudy__c = null';					
			}
			query += ' and Program__c = \''+programID+ '\'';
			query += ' and State__c includes (\'' + stud.PersonMailingStateCode + '\')';
//			query += ' and Campus__c like \'%' + 'West' + '%\'';
			query += ' '+generateLIMITStatement();
			DatabaseUtil db = new DatabaseUtil();
			eligibility = (List<ProgramEligibility__c>)db.query(query);
			if (eligibility.size()>0){
				returnMap.put(stud.id, true);
			} else returnMap.put(stud.id, false);
		}

		return returnMap;
	}*/

	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getFieldNames() + ' FROM ContractTerm__c';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Name, ';
		fieldNames += 'Program__c, ';
		fieldNames += 'EarningsGroup__c, ';
		fieldNames += 'GradeLevel__c, ';
		fieldNames += 'IncomeShare__c, ';
		fieldNames += 'MinimumFundingAmount__c, ';
		fieldNames += 'MaximumFundingAmount__c, ';
		fieldNames += 'PaymentTerm__c, ';
		fieldNames += 'AdjustmentMethod__c, ';
		fieldNames += 'PaymentCapFactor__c ';
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