/////////////////////////////////////////////////////////////////////////
// Class: FeeService_TEST
// 
// Description: 
// 	Unit test for FeeService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-24   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
@isTest
public class FeeService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetFeeWithFeeID(){
    	Map<Id, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Fee__c> feeMap = TestDataFactory.createAndInsertFee(TestUtil.TEST_THROTTLE, studentMap);
    	Test.startTest();
    	List<FeeService.Fee> resultFeeList = FeeService.getFeeWithFeeID(feeMap.keySet());
    	Test.stopTest();
    	System.assertEquals(feeMap.size(), resultFeeList.size());
    }

    static testMethod void testGetFeeWithCustomerID(){
    	Map<Id, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Fee__c> feeMap = TestDataFactory.createAndInsertFee(TestUtil.TEST_THROTTLE, studentMap);
    	Test.startTest();
    	List<FeeService.Fee> resultFeeList = FeeService.getFeeWithCustomerID(studentMap.keySet());
    	Test.stopTest();
    	System.assertEquals(feeMap.size(), resultFeeList.size());
    }
}