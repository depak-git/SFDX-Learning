public class SandboxSetupMaskContacts implements Database.Batchable<sObject> {
	
	public String query = 'SELECT id, AuthSystemUserID__c, SSNTaxID__c, Birthdate, PrimarySchoolEmail__c, DriversLicenseOrStateID__c, Email, Phone, HomePhone, MobilePhone, OtherPhone,  MailingStreet, MailingCity, MailingState, MailingPostalCode, OtherStreet, OtherCity, OtherState, OtherPostalCode from Contact';
	public String sObj = 'Contact';

	public SandboxSetupMaskContacts() {
		
	}
	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		if(sObj == 'Contact'){
			query = 'SELECT id, AuthSystemUserID__c, SSNTaxID__c, Birthdate, PrimarySchoolEmail__c, DriversLicenseOrStateID__c, Email, Phone, HomePhone, MobilePhone, OtherPhone,  MailingStreet, MailingCity, MailingState, MailingPostalCode, OtherStreet, OtherCity, OtherState, OtherPostalCode from Contact';

		} else if(sObj == 'StudentProgram__c'){
			query = 'SELECT id, Birthdate__c, BirthdateCertification__c, BirthdatePostCertification__c, BirthdatePreCertification__c, BirthdateStudent__c, StudentEmail__c from StudentProgram__c';

		}
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
   		if(sObj == 'Contact'){

			for(Contact cont : (List<Contact>)(scope)){
				System.debug('cont:'+cont);
				if(String.isNotEmpty(cont.SSNTaxID__c)) cont.SSNTaxID__c = '123-45-6789';
				if(String.isNotEmpty(cont.MailingStreet)) cont.MailingStreet = '123 Main Street';
				if(String.isNotEmpty(cont.MailingPostalCode)) cont.MailingPostalCode = '98765-4321';
				if(String.isNotEmpty(cont.OtherStreet)) cont.OtherStreet = '12345 Secondary Street';
				if(String.isNotEmpty(cont.OtherPostalCode)) cont.OtherPostalCode = '11223';
				if(String.isNotEmpty(cont.Phone)) cont.Phone = '(555) 123-4567';
				if(String.isNotEmpty(cont.MobilePhone)) cont.MobilePhone = '(555) 123-4567';
				if(String.isNotEmpty(cont.OtherPhone)) cont.OtherPhone = '(555) 123-4567';
				if(String.isNotEmpty(cont.HomePhone)) cont.HomePhone = '(555) 123-4567';			
				if(String.isNotEmpty(cont.Email)) cont.Email = 'masked.email@vemo.com';
				if(String.isNotEmpty(cont.AuthSystemUserID__c)) cont.AuthSystemUserID__c = 'auth|'+cont.id;
				if(cont.Birthdate != null) cont.Birthdate = Date.newInstance(2000, 1, 1);
			}   			
   		} else if(sObj == 'StudentProgram__c'){
			for(StudentProgram__c agreement : (List<StudentProgram__c>) (scope)){
				System.debug('agreement:'+agreement);
				if(String.isNotEmpty(agreement.StudentEmail__c)) agreement.StudentEmail__c = 'masked.email@vemo.com';
				if(agreement.Birthdate__c != null) agreement.Birthdate__c = Date.newInstance(2000, 1, 1);
				if(agreement.BirthdateCertification__c != null) agreement.BirthdateCertification__c = Date.newInstance(2000, 1, 1);
				if(agreement.BirthdatePostCertification__c != null) agreement.BirthdatePostCertification__c = Date.newInstance(2000, 1, 1);
				if(agreement.BirthdatePreCertification__c != null) agreement.BirthdatePreCertification__c = Date.newInstance(2000, 1, 1);
				if(agreement.BirthdateStudent__c != null) agreement.BirthdateStudent__c = Date.newInstance(2000, 1, 1);
			}   			
   		}

		update scope;
	}
	
	public void finish(Database.BatchableContext BC) {
		
	}
	
}