/////////////////////////////////////////////////////////////////////////
// Class: ContractTermQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-04-25   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class ContractTermQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
	@isTest public static void validateGetContractTermMap() {
		Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Program__c> testProgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
		Map<Id, ContractTerm__c> testContractTermMap = TestDataFactory.createAndInsertContractTerms(TestUtil.TEST_THROTTLE, testProgMap);

		Test.startTest();
		Map<Id, ContractTerm__c> resultContractTermMap = ContractTermQueries.getContractTermMap();
		System.assertEquals(testContractTermMap.keySet().size(), resultContractTermMap.keySet().size());
		Test.stopTest();
	}

}