/////////////////////////////////////////////////////////////////////////
// Class: EmailService_TEST
// 
// Description: 
// 	Unit test for EmailService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-06-08   Jared Hagemann  Created                     
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class EmailService_TEST {

	static testMethod void testSendEmailWithAttachments(){
		
		Map<Id, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
		Map<Id, Contact> contactMap = TestDataFactory.createAndInsertContacts(1, schoolMap);
		contactMap.values().get(0).email = 'test@x.x';
		update contactMap.values();

		Map<Id, Attachment> attachmentMap = TestDataFactory.createAndInsertStudentAttachments(5);
		List<Id> attIds = new List<Id>();
		attIds.addAll(attachmentMap.keySet());
		EmailTemplate template = [select Id from EmailTemplate where Name = 'Communities: New Member Welcome Email'];
		List<String> emails = new List<String>();
		for(Integer i = 0; i < TestUtil.TEST_THROTTLE; i++){
			emails.add('email' + i + '@x.x');
		}
		Test.startTest();
		EmailService.sendEmailWithAttachments(emails, contactMap.values().get(0).Id, template.Id, attIds);
		Test.stopTest();
	}
	
}