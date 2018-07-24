@isTest
public with sharing class FeeTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	@isTest
	public static void testManageAccountsInsert(){
		TestUtil.setStandardConfiguration();
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<Id, Fee__c> testFeeMap = TestDataFactory.createAndInsertFee(10, testStudentAccountMap);
		Test.stopTest();
		Map<Id, Account> resultStudentMap = AccountQueries.getStudentMap(); 
		for(Account stud : resultStudentMap.values()){
			System.assertEquals(10000, stud.UnpaidFees__c);
		}
	}

	@isTest
	public static void testManageAccountsUpdate(){
		TestUtil.setStandardConfiguration();
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Fee__c> testFeeMap = TestDataFactory.createAndInsertFee(10, testStudentAccountMap);
		for(Fee__c fee : testFeeMap.values()){
			fee.Amount__c = 500;
		}
		Test.startTest();
		update testFeeMap.values();
		Test.stopTest();
		Map<Id, Account> resultStudentMap = AccountQueries.getStudentMap(); 
		for(Account stud : resultStudentMap.values()){
			System.assertEquals(5000, stud.UnpaidFees__c);
		}
	}

	@isTest
	public static void testManageAccountsDelete(){
		TestUtil.setStandardConfiguration();
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Fee__c> testFeeMap = TestDataFactory.createAndInsertFee(10, testStudentAccountMap);
		Test.startTest();
		delete testFeeMap.values();
		Test.stopTest();
		Map<Id, Account> resultStudentMap = AccountQueries.getStudentMap(); 
		for(Account stud : resultStudentMap.values()){
			System.assertEquals(0, stud.UnpaidFees__c);
		}
	}
}