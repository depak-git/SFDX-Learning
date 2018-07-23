/////////////////////////////////////////////////////////////////////////
// Class: ProgramEligibilityQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-04-23   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class ProgramEligibilityQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
	@isTest public static void validateGetProgramEligibilityMap() {
		Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Program__c> testProgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
		Map<Id, ProgramEligibility__c> testProgElgMap = TestDataFactory.createAndInsertProgramEligibility(TestUtil.TEST_THROTTLE, testProgMap);

		Test.startTest();
		Map<Id, ProgramEligibility__c> resultProgElgMap = ProgramEligibilityQueries.getProgramEligibilityMap();
		System.assertEquals(testProgElgMap.keySet().size(), resultProgElgMap.keySet().size());
		Test.stopTest();
	}

}