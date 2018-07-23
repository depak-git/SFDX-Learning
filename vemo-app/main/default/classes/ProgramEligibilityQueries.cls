public class ProgramEligibilityQueries {
//SELECT ID, Name, AgeOfMajority__c, Residency__c, EnrollmentStatus__c, GradeLevel__c, SchoolProgramOfStudy__c, Campus__c, Program__c, State__c FROM ProgramEligibility__c where AgeOfMajority__c < 19 and Residency__c includes ('US Citizen') and EnrollmentStatus__c includes ('Full Time') and GradeLevel__c includes ('Freshman') and SchoolProgramOfStudy__c = 'a0o7A000000xVuJQAU' and Campus__c Like '%West%' and Program__c = 'a0n7A0000012a6nQAA' and State__c includes ('AL')

	public static Map<String, Object> filterCriteria = new Map<String, Object>();
	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}

/*	public static Map<String, Account> getStudentMapByAuthIDWithAuthID(Set<String> authIDs){
		Map<String, Account> acctMapByAuthID = new Map<String, Account>();
		String query = generateSOQLSelect('student');
		query += ' WHERE AuthSystemUserID__pc IN ' + DatabaseUtil.inSetStringBuilder(authIDs);
		query += ' and ' + generateRecordTypeStatement('Student');

		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		Map<ID, Account> retMap = new Map<ID, Account>((List<Account>)db.query(query));

		for(Account acct : retMap.values()){
			acctMapByAuthID.put(acct.AuthSystemUserID__pc, acct);
		}
		system.debug('acctMapByAuthID:'+acctMapByAuthID);
		return acctMapByAuthID;
	}*/

	public static Map<ID, ProgramEligibility__c> getProgramEligibilityMap(){
		Map<ID, ProgramEligibility__c> peMap = new Map<ID, ProgramEligibility__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Program__c != null';
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' AND Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		peMap = new Map<ID, ProgramEligibility__c>((List<ProgramEligibility__c>)db.query(query));
		return peMap;		
	}


	public static Boolean evaluateEligibilityWithCriteria(ID programID, String residency,
												 String enrollmentStatus, String gradeLevel,
												 ID schoolProgramOfStudyID, String state, Integer studentAge){
		
		//Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
		Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(new Set<ID>{programID});
		Program__c program = programMap.values()[0];

		String residencyParam = '';
		String enrollmentStatusParam  = '';
		String gradeLevelParam = '';
		
		List<ProgramEligibility__c> eligibility = new List<ProgramEligibility__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Program__c = \''+programID+ '\'';
		if(program.ResidencyRequired__c){	
			if(residency == null) return false;		
			query += ' and Residency__c includes (\'' + residency + '\')';
		}
		if(program.EnrollmentStatusRequired__c){
			if(enrollmentStatus == null) return false;
			query += ' and EnrollmentStatus__c includes (\'' + enrollmentStatus + '\')';
		}
		if(program.GradeLevelRequired__c){
			if(gradeLevel == null) return false;
			query += ' and GradeLevel__c includes (\'' + gradeLevel + '\')';
		}

		if(program.SchoolProgramOfStudyRequired__c){
			if(schoolProgramOfStudyID == null) return false;
			query += ' and SchoolProgramOfStudy__c = \'' + schoolProgramOfStudyID + '\'';				
		}
		query += ' '+generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		eligibility = (List<ProgramEligibility__c>)db.query(query);

		if (eligibility.size()>0){
			if(program.AgeOfMajorityRequired__c){
				if(studentAge == null || state == null) return false;
				if(determineAgeOfMajority(state) > studentAge) {
					return false;
				} else{
					return true;							
				}			
			} else {
				return true;					
			}

		} else return false;

		return false;
	}

	public static Map<ID, Boolean> evaluateEligibility(ID programID, Set<ID> studentIDs){
		//Takes a list of students and returns of map of eligibility for those students
		Map<ID, Boolean> returnMap = new Map<ID, Boolean>();

		Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
		Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(new Set<ID>{programID});
		Program__c program = programMap.values()[0];

		List<ProgramEligibility__c> eligibility = new List<ProgramEligibility__c>();
		for(Account stud : studentMap.values()){
			//must query each student - NOT BULK SAFE
			eligibility.clear();
			String query = generateSOQLSelect();
			query += ' WHERE Program__c = \''+programID+ '\'';

			if(program.ResidencyRequired__c){			
				query += ' and Residency__c includes (\'' + stud.Residency__pc + '\')';
			}
			if(program.EnrollmentStatusRequired__c){
				query += ' and EnrollmentStatus__c includes (\'' + stud.PrimarySchoolEnrollmentStatus__pc + '\')';
			}
			if(program.GradeLevelRequired__c){
				query += ' and GradeLevel__c includes (\'' + stud.PrimarySchoolGradeLevel__pc + '\')';
			}

			if(program.SchoolProgramOfStudyRequired__c){
				if(stud.SchoolProgramOfStudy__pc != null){
					query += ' and SchoolProgramOfStudy__c = \'' + stud.SchoolProgramOfStudy__pc + '\'';				
				} else {
					query += ' and SchoolProgramOfStudy__c = null';					
				}				
			}



//			query += ' and Campus__c like \'%' + 'West' + '%\'';
			query += ' '+generateLIMITStatement();
			DatabaseUtil db = new DatabaseUtil();
			eligibility = (List<ProgramEligibility__c>)db.query(query);
			if (eligibility.size()>0){
				if(program.AgeOfMajorityRequired__c){
					if(determineAgeOfMajority(stud.PersonMailingStateCode) > stud.Age__pc) {
						returnMap.put(stud.id, false);
					} else{
						returnMap.put(stud.id, true);							
					}			
				} else {
					returnMap.put(stud.id, true);					
				}

			} else returnMap.put(stud.id, false);
		}

		return returnMap;
	}

/*	public static Integer determineAgeOfMajority(Account student){
		if(student.PersonMailingStateCode == 'CO' || student.PersonMailingStateCode == 'MS' || student.PersonMailingStateCode == 'PR'){
			return 21;
		}
		if(student.PersonMailingStateCode == 'AL' || student.PersonMailingStateCode == 'NE'){
			return 19;
		}
		return 18;
	}*/

	public static Integer determineAgeOfMajority(String stateOfResidency){
		// if(stateOfResidency == 'CO' || stateOfResidency == 'MS' || stateOfResidency == 'PR'){
		// 	return 21;
		// }
		// if(stateOfResidency == 'AL' || stateOfResidency == 'NE'){
		// 	return 19;
		// }
		if(stateOfResidency == 'AL') return 19;
		// if(stateOfResidency == 'PR') return 21;
		// if(stateOfResidency == 'AL') return 19;
		// if(stateOfResidency == 'AL') return 19;

		return 18;
	}
/*	
	public static Map<ID, Account> getStudentMapWithPersonEmails(Set<String> personEmails){
		Map<ID, Account> acctMap = new Map<ID, Account>();
		String query = generateSOQLSelect('student');
		query += ' WHERE ' + generateRecordTypeStatement('Student');
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' and PersonEmail IN ' + DatabaseUtil.inSetStringBuilder(personEmails)+ ' ';
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		acctMap = new Map<ID, Account>((List<Account>)db.query(query));
		return acctMap;		
	}

	public static Map<ID, Account> getStudentMapWithStudentID(Set<ID> studentIDs){
		Map<ID, Account> acctMap = new Map<ID, Account>();
		String query = generateSOQLSelect('student');		
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		query += ' and ' + generateRecordTypeStatement('Student');
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		acctMap = new Map<ID, Account>((List<Account>)db.query(query));
		return acctMap;		
		
	}	

	///////////////////////////////////////////////////////////////////////////////////////////
	// School Queries
	///////////////////////////////////////////////////////////////////////////////////////////
	public static Map<ID, Account> getSchoolMap(){
		Map<ID, Account> schlMap = new Map<ID, Account>();
		String query = generateSOQLSelect('school');		
		query += ' WHERE ' + generateRecordTypeStatement('School - Available Prospect');
		query += 'or ' + generateRecordTypeStatement('School - Customer');
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		schlMap = new Map<ID, Account>((List<Account>)db.query(query));
		return schlMap;		
	}

	public static Map<ID, Account> getSchoolMapWithSchoolID(Set<ID> schoolIDs){
		Map<ID, Account> schlMap = new Map<ID, Account>();
		String query = generateSOQLSelect('school');	
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);			
		query += ' and ';
		query += '(' + generateRecordTypeStatement('School - Available Prospect');

		query += ' or ' + generateRecordTypeStatement('School - Customer') + ') ';
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		schlMap = new Map<ID, Account>((List<Account>)db.query(query));
		return schlMap;			
	}	

	public static Map<ID, Account> getSchoolMapWithSchoolName(Set<String> schoolNames){
		Map<ID, Account> schlMap = new Map<ID, Account>();
		String query = generateSOQLSelect('school');	
		query += ' WHERE Name IN ' + DatabaseUtil.inSetStringBuilder(schoolNames);	
		query += ' and ';
		query += '(' + generateRecordTypeStatement('School - Available Prospect');

		query += ' or ' + generateRecordTypeStatement('School - Customer') + ') ';
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		schlMap = new Map<ID, Account>((List<Account>)db.query(query));
		return schlMap;		
	}

	public static Map<ID, Account> getSchoolMapWithEntryPoint(Set<String> entryPoints){
		Map<ID, Account> schlMap = new Map<ID, Account>();
		String query = generateSOQLSelect('school');	
		query += ' WHERE EntryPoint__c IN ' + DatabaseUtil.inSetStringBuilder(entryPoints);	
		query += ' and ';
		query += '(' + generateRecordTypeStatement('School - Available Prospect');

		query += ' or ' + generateRecordTypeStatement('School - Customer') + ') ';
		if(DatabaseUtil.filterBySchoolID){
			ID schoolID = DatabaseUtil.schoolID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
		}
		query += buildFilterString();
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		schlMap = new Map<ID, Account>((List<Account>)db.query(query));
		return schlMap;		
	}
*/
	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getFieldNames() + ' FROM ProgramEligibility__c';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Name, ';
		fieldNames += 'Residency__c, ';
		fieldNames += 'EnrollmentStatus__c, ';
		fieldNames += 'GradeLevel__c, ';
		fieldNames += 'SchoolProgramOfStudy__c, ';
		fieldNames += 'Campus__c, ';
		fieldNames += 'Program__c ';
		return fieldNames;
	}
/*
	private static String getSchoolFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'GUID__c, ';
		fieldNames += 'Name, ';
		fieldNames += 'BillingStreet, ';
		fieldNames += 'BillingCity, ';
		fieldNames += 'BillingCountry, ';
		fieldNames += 'BillingCountryCode, ';
		fieldNames += 'BillingPostalCode, ';
		fieldNames += 'BillingState, ';
		fieldNames += 'BillingStateCode, ';
		fieldNames += 'VemoAccountNumber__c, ';
		fieldNames += 'EntryPoint__c, ';
		fieldNames += 'WebsiteStatus__c, ';
		fieldNames += 'WebStyle__c, ';
		fieldNames += 'DisplayName__c, ';
		fieldNames += 'SchoolLogoURL__c, ';
		fieldNames += 'TitleBlock__c, ';
		fieldNames += 'DescriptionBlock__c, ';
		fieldNames += 'DetailBlock__c ';

		return fieldNames;
	}
	*/
	private static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}
/*
	private static String generateRecordTypeStatement(String recordTypeLabel){
		ID recordTypeID = (String)GlobalUtil.getRecordTypeIDByLabelName('Account', recordTypeLabel);
		return 'RecordTypeID = \''+ String.valueOf(recordTypeID) + '\'';
	}
*/
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