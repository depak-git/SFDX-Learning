///////////////////////////////////////////////////////////////////////// git test 1 3 4
// Class: ContactQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public class ContactQueries {
/*	public static Map<ID, Contact> getContactMapByID(){
		return new Map<ID, Contact>([SELECT id,
										   FirstName,
										   MiddleName,
										   LastName,
										   MailingCity,
										   MailingCountry,
										   MailingPostalCode,
										   MailingState,
										   MailingStreet,
										   Phone,
										   Relationship__c,
										   PendingFirstName__c,
										   PendingMiddleName__c,
										   PendingLastName__c,
										   PendingBirthDate__c,
										   PendingDriversLicenseOrStateID__c,
										   PendingEmail__c,
										   RecordStatus__c,
										   PendingMailingStreet__c,
										   PendingMailingCity__c,
										   PendingMailingCountry__c,
										   PendingMailingCountryCode__c,
										   PendingMailingState__c,
										   PendingMailingStateCode__c,
										   PendingMailingPostalCode__c,
										   CommunityStatus__c
									 FROM Contact
									 LIMIT 50000]);
	}
	public static Map<ID, Contact> getStudentReferenceMapWithStudentID(Set<ID> studentIDs){
		return new Map<ID, Contact>([SELECT id,
										   FirstName,
										   MiddleName,
										   LastName,
										   MailingCity,
										   MailingCountry,
										   MailingPostalCode,
										   MailingState,
										   MailingStreet,
										   Phone,
										   Relationship__c,
										   PendingFirstName__c,
										   PendingMiddleName__c,
										   PendingLastName__c,
										   PendingBirthDate__c,
										   PendingDriversLicenseOrStateID__c,
										   PendingEmail__c,
										   RecordStatus__c,
										   PendingMailingStreet__c,
										   PendingMailingCity__c,
										   PendingMailingCountry__c,
										   PendingMailingCountryCode__c,
										   PendingMailingState__c,
										   PendingMailingStateCode__c,
										   PendingMailingPostalCode__c,
										   CommunityStatus__c
									 FROM Contact
									 WHERE Student__c IN :studentIDs
									 LIMIT 50000]);
	}

	public static Map<ID, Contact> getStudentReferenceMapWithReferenceID(Set<ID> referenceIDs){
		return new Map<ID, Contact>([SELECT id,
										   FirstName,
										   MiddleName,
										   LastName,
										   MailingCity,
										   MailingCountry,
										   MailingPostalCode,
										   MailingState,
										   MailingStreet,
										   Phone,
										   Relationship__c,
										   PendingFirstName__c,
										   PendingMiddleName__c,
										   PendingLastName__c,
										   PendingBirthDate__c,
										   PendingDriversLicenseOrStateID__c,
										   PendingEmail__c,
										   RecordStatus__c,
										   PendingMailingStreet__c,
										   PendingMailingCity__c,
										   PendingMailingCountry__c,
										   PendingMailingCountryCode__c,
										   PendingMailingState__c,
										   PendingMailingStateCode__c,
										   PendingMailingPostalCode__c,
										   CommunityStatus__c
									 FROM Contact where ID in :referenceIDs
									 LIMIT 50000]);
	}




	public static Map<String, Account> getStudentMapByAuthIDWithAuthID(Set<String> authIDs){
		Map<String, Account> acctMapByAuthID = new Map<String, Account>();
		String query = generateSOQLSelect('student');
		query += ' WHERE AuthSystemUserID__pc IN ' + DatabaseUtil.inSetStringBuilder(authIDs);
		query += ' and ' + generateRecordTypeStatement('Student');

		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		Map<ID, Account> retMap = new Map<ID, Account>((List<Account>)db.query(query));

		for(Account acct : retMap.values()){
			acctMapByAuthID.put(acct.AuthSystemUserID__pc, acct);
		}
		system.debug('acctMapByAuthID:'+acctMapByAuthID);
		return acctMapByAuthID;
	}

	public static Map<ID, Account> getStudentMap(){
		Map<ID, Account> acctMap = new Map<ID, Account>();
		String query = generateSOQLSelect('student');
		query += ' WHERE ' + generateRecordTypeStatement('Student');
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		acctMap = new Map<ID, Account>((List<Account>)db.query(query));
		return acctMap;		
	}*/
	public static Map<ID, Contact> getContactMapByID(){
		Map<ID, Contact> contMap = new Map<ID, Contact>();
		String query = generateSOQLSelect();		
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' WHERE AccountID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		contMap = new Map<ID, Contact>((List<Contact>)db.query(query));
		return contMap;		
		
	}
	public static Map<ID, Contact> getContactMapByIDWithContactID(Set<ID> contactIDs){
		Map<ID, Contact> contMap = new Map<ID, Contact>();
		String query = generateSOQLSelect();	
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(contactIDs);	
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' AND AccountID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		contMap = new Map<ID, Contact>((List<Contact>)db.query(query));
		return contMap;		
		
	}	
	public static Map<ID, Contact> getStudentReferenceMapWithStudentID(Set<ID> studentIDs){
		Map<ID, Contact> contMap = new Map<ID, Contact>();
		String query = generateSOQLSelect();		
		query += ' WHERE Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		query += ' and ' + generateRecordTypeStatement('Student Reference');
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		contMap = new Map<ID, Contact>((List<Contact>)db.query(query));
		return contMap;		
		
	}
	public static Map<ID, Contact> getStudentReferenceMapWithReferenceID(Set<ID> referenceIDs){
		Map<ID, Contact> contMap = new Map<ID, Contact>();
		String query = generateSOQLSelect();		
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(referenceIDs);
		query += ' and ' + generateRecordTypeStatement('Student Reference');
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += ' '+ generateLIMITStatement();
		system.debug('***query'+query);
		DatabaseUtil db = new DatabaseUtil();
		contMap = new Map<ID, Contact>((List<Contact>)db.query(query));
		return contMap;		
		
	}	

	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getContactFieldNames() + ' FROM Contact';
		return soql;
	}

	private static String getContactFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'AccountID, ';
		fieldNames += 'Student__c, ';		
		fieldNames += 'FirstName, ';
		fieldNames += 'MiddleName, ';
		fieldNames += 'LastName, ';
		fieldNames += 'MailingCity, ';
		fieldNames += 'MailingCountry, ';
		fieldNames += 'MailingPostalCode, ';
		fieldNames += 'MailingState, ';
		fieldNames += 'MailingStreet, ';
		fieldNames += 'Phone, ';
		fieldNames += 'Relationship__c ';
//		fieldNames += 'PendingFirstName__c, ';
//		fieldNames += 'PendingMiddleName__c, ';
//		fieldNames += 'PendingLastName__c, ';
//		fieldNames += 'PendingBirthDate__c, ';
//		fieldNames += 'PendingDriversLicenseOrStateID__c, ';
//		fieldNames += 'PendingEmail__c, ';
//		fieldNames += 'RecordStatus__c, ';
//		fieldNames += 'PendingMailingStreet__c, ';
//		fieldNames += 'PendingMailingCity__c, ';
//		fieldNames += 'PendingMailingCountry__c, ';
//		fieldNames += 'PendingMailingCountryCode__c, ';
//		fieldNames += 'PendingMailingState__c, ';
//		fieldNames += 'PendingMailingStateCode__c, ';
//		fieldNames += 'PendingMailingPostalCode__c, ';
//		fieldNames += 'CommunityStatus__c, ';
//		fieldNames += 'PendingResidency__c';	

		return fieldNames;
	}


	
	private static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}

	private static String generateRecordTypeStatement(String recordTypeLabel){
		ID recordTypeID = (String)GlobalUtil.getRecordTypeIDByLabelName('Contact', recordTypeLabel);
		return 'RecordTypeID = \''+ String.valueOf(recordTypeID) + '\'';
	}

}