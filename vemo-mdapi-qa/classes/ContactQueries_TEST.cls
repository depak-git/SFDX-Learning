/////////////////////////////////////////////////////////////////////////
// Class: ContactQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class ContactQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<ID, Account> acctMap = TestDataFactory.createAndInsertSchoolProspectAccounts(TestUtil.TEST_THROTTLE);
        TestDataFactory.createAndInsertContacts(TestUtil.TEST_THROTTLE, acctMap);
    }
	@isTest public static void validateGetContactMapByID() {
		//jared
		Map<ID, Contact> contactMap = ContactQueries.getContactMapByID();
		system.assertEquals(contactMap.size(), TestUtil.TEST_THROTTLE * TestUtil.TEST_THROTTLE);
	}
}