/////////////////////////////////////////////////////////////////////////
// Class: IncomeBandQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-04-25   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class IncomeBandQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
	@isTest public static void validateGetIncomeBandMap() {
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, posMap);
    	Map<ID, IncomeBand__c> testBands = TestDataFactory.createAndInsertIncomeBands(2, testSPOSMap);
		Test.startTest();
		Map<Id, IncomeBand__c> resultIncomeBandMap = IncomeBandQueries.getIncomeBandMap();
		System.assertEquals(testBands.keySet().size(), resultIncomeBandMap.keySet().size());
		Test.stopTest();
	}

}