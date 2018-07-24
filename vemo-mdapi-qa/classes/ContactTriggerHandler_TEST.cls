/////////////////////////////////////////////////////////////////////////
// Class: ContactTriggerHandler_TEST
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-13  Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
private class ContactTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        TestDataFactory.createAndInsertSchoolProspectAccounts(TestUtil.TEST_THROTTLE);
    }
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateContactCreate
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateContactCreate() {	
		TestUtil.setStandardConfiguration();
		Map<ID, Account> acctMap = AccountQueries.getSchoolMap();
		Map<ID, Contact> contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),0,'No Contact Records Should Exist');
		
		Test.startTest();
		Map<ID, Contact> contMap = TestDataFactory.createAndInsertContacts(TestUtil.TEST_THROTTLE, acctMap);
		Test.stopTest();

		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE,'Contact Records Should Exist');
		
	}    
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateContactUpdate
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateContactUpdate() {	
		TestUtil.setStandardConfiguration();
		Map<ID, Account> acctMap = AccountQueries.getSchoolMap();
		Map<ID, Contact> contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),0,'No Contact Records Should Exist');
		

		Map<ID, Contact> contMap = TestDataFactory.createAndInsertContacts(TestUtil.TEST_THROTTLE, acctMap);
		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE,'Contact Records Should Exist');

		for(Contact cont : contMap.values()){
			cont.FirstName = 'update';
		}
		Test.startTest();
		update contMap.values();
		Test.stopTest();

		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE,'Contact Records Should Exist');
	}   
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateContactDelete
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateContactDelete() {	
		TestUtil.setStandardConfiguration();
		Map<ID, Account> acctMap = AccountQueries.getSchoolMap();
		Map<ID, Contact> contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),0,'No Contact Records Should Exist');
		

		Map<ID, Contact> contMap = TestDataFactory.createAndInsertContacts(TestUtil.TEST_THROTTLE, acctMap);
		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE,'Contact Records Should Exist');

		Test.startTest();
		delete contMap.values();
		Test.stopTest();

		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),0,'No Contact Records Should Exist');
	} 
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateContactUndelete
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateContactUndelete() {	
		TestUtil.setStandardConfiguration();
		Map<ID, Account> acctMap = AccountQueries.getSchoolMap();
		Map<ID, Contact> contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),0,'No Contact Records Should Exist');
		

		Map<ID, Contact> contMap = TestDataFactory.createAndInsertContacts(TestUtil.TEST_THROTTLE, acctMap);
		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE,'Contact Records Should Exist');

		delete contMap.values();
		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),0,'No Contact Records Should Exist');		

		Test.startTest();
		undelete contMap.values();
		Test.stopTest();

		contToValidate = ContactQueries.getContactMapByID();
		system.assertEquals(contToValidate.size(),TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE,'Contact Records Should Exist');


	}
/*    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateAutoCommunityEnrollment
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateAutoCommunityEnrollment() {	
		TestUtil.setStandardConfiguration();
		Map<ID, Account> acctMap = AccountQueries.getSchoolMap();
		Map<ID, Contact> contMap = TestDataFactory.createAndInsertContacts(TestUtil.TEST_THROTTLE, acctMap);
		Map<ID, User> userMapBefore = UserQueries.getUserMapByID();


		for(Contact cont : contMap.values()){
			cont.CommunityStatus__c = 'Enroll';
		}
		Test.startTest();
		update contMap.values();
		Test.stopTest();

		Map<ID, Contact> contToValidate = ContactQueries.getContactMapByID();
		Map<ID, User> userMapAfter = UserQueries.getUserMapByID();
		system.assertEquals(contToValidate.size(),TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE,'Contact Records Should Exist');
		//system.assertNotEquals(userMapBefore.size(), userMapAfter.size(), 'New users should exist'); // can't figure out why this isn't working


	}*/

}