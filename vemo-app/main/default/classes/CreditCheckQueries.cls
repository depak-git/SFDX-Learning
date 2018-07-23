public class CreditCheckQueries {
	public static Map<ID, CreditCheck__c> getCreditCheckMap(){
		Map<ID, CreditCheck__c> ccMap = new Map<ID, CreditCheck__c>();
		String query = generateSOQLSelect();
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' WHERE Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		ccMap = new Map<ID, CreditCheck__c>((List<CreditCheck__c>)db.query(query));
		return ccMap;		
	}

	public static Map<ID, CreditCheck__c> getCreditCheckMapWithCreditCheckID(Set<ID> creditCheckIDs){
		Map<ID, CreditCheck__c> ccMap = new Map<ID, CreditCheck__c>();
		String query = generateSOQLSelect();
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(creditCheckIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		ccMap = new Map<ID, CreditCheck__c>((List<CreditCheck__c>)db.query(query));
		return ccMap;
	}

	public static Map<ID, CreditCheck__c> getCreditCheckMapWithStudentID(Set<ID> studentIDs){
		Map<ID, CreditCheck__c> ccMap = new Map<ID, CreditCheck__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		ccMap = new Map<ID, CreditCheck__c>((List<CreditCheck__c>)db.query(query));
		return ccMap;
	}

	public static Map<ID, CreditCheck__c> getCreditCheckMapWithAgreementID(Set<ID> agreementIDs){
		Map<ID, CreditCheck__c> ccMap = new Map<ID, CreditCheck__c>();
		Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
		Set<ID> ccIDs = new Set<ID>();
		for(StudentProgram__c agreement : agreementMap.values()){
			if(String.isNotEmpty(agreement.CreditCheck__c))	ccIDs.add(agreement.CreditCheck__c);
		}
		ccMap = getCreditCheckMapWithCreditCheckID(ccIDs);
		/*
		String query = generateSOQLSelect();
		query += ' WHERE Agreement__c IN ' + DatabaseUtil.inSetStringBuilder(agreementIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		ccMap = new Map<ID, CreditCheck__c>((List<CreditCheck__c>)db.query(query));*/
		return ccMap;
	}

	public static Map<ID, CreditCheck__c> getCreditCheckMapByAgreementIDWithAgreementID(Set<ID> agreementIDs){
		Map<ID, CreditCheck__c> ccMap = new Map<ID, CreditCheck__c>();
		Map<ID, CreditCheck__c> ccByAgreementID = new Map<ID, CreditCheck__c>();
		Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
		Set<ID> ccIDs = new Set<ID>();
		for(StudentProgram__c agreement : agreementMap.values()){
			if(String.isNotEmpty(agreement.CreditCheck__c))	ccIDs.add(agreement.CreditCheck__c);
		}
		System.debug('ccIDs:'+ccIDs);
		ccMap = getCreditCheckMapWithCreditCheckID(ccIDs);
		for(StudentProgram__c agree : agreementMap.values()){
			System.debug('ccMap:'+ccMap);
			System.debug('agreementMap:'+agreementMap);
			if(ccMap.containsKey(agreementMap.get(agree.id).CreditCheck__c)){
				ccByAgreementID.put(agree.id, ccMap.get(agreementMap.get(agree.id).CreditCheck__c));				
			}
		}

		/*
		String query = generateSOQLSelect();
		query += ' WHERE Agreement__c IN ' + DatabaseUtil.inSetStringBuilder(agreementIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		ccMap = new Map<ID, CreditCheck__c>((List<CreditCheck__c>)db.query(query));*/
		return ccByAgreementID;
	}


	private static String generateSOQLSelect(){
		String soql;		
		soql = 'SELECT ' + getFieldNames() + ' FROM CreditCheck__c';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Student__c, ';
		fieldNames += 'Student__r.GUID__c, ';
//		fieldNames += 'Agreement__c, ';
//		fieldNames += 'Agreement__r.GUID__c, ';
		fieldNames += 'ConsentIPAddress__c, ';
		fieldNames += 'ConsentDateTimeStamp__c, ';
		fieldNames += 'JSONPayload__c, ';
		fieldNames += 'Status__c, ';
		fieldNames += 'CreditCheckDeniedReason__c, ';
		fieldNames += 'CreditCheckDeniedReasonText__c, ';
		fieldNames += 'GUID__c';

		return fieldNames;
	}

	private static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}
}