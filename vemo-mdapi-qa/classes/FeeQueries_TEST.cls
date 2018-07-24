/////////////////////////////////////////////////////////////////////////
// Class: FeeQueries_TEST
// 
// Description: 
//  Unit test for FeeQueries
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-24   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class FeeQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetFeeMap(){
    	Map<Id, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Fee__c> feeMap = TestDataFactory.createAndInsertFee(TestUtil.TEST_THROTTLE, studentMap);
    	Test.startTest();
    	Map<Id, Fee__c> resultFeeMap = FeeQueries.getFeeMap();
    	Test.stopTest();
    	System.assertEquals(feeMap.size(), resultFeeMap.size());
    }

    static testMethod void testGetFeeMapWithFeeId(){
    	Map<Id, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Fee__c> feeMap = TestDataFactory.createAndInsertFee(TestUtil.TEST_THROTTLE, studentMap);
    	Test.startTest();
    	Map<Id, Fee__c> resultFeeMap = FeeQueries.getFeeMapWithFeeId(feeMap.keySet());
    	Test.stopTest();
    	System.assertEquals(feeMap.size(), resultFeeMap.size());
    }

    static testMethod void testGetFeeMapWithCustomerId(){
    	Map<Id, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Fee__c> feeMap = TestDataFactory.createAndInsertFee(TestUtil.TEST_THROTTLE, studentMap);
    	Test.startTest();
    	Map<Id, Fee__c> resultFeeMap = FeeQueries.getFeeMapWithCustomerId(studentMap.keySet());
    	Test.stopTest();
    	System.assertEquals(feeMap.size(), resultFeeMap.size());
    }
}