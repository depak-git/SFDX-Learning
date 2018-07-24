/////////////////////////////////////////////////////////////////////////
// Class: PaymentInstructionQueries_TEST
// 
// Description: 
//  Unit test for PaymentInstructionQueries
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-18   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class PaymentInstructionQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetPaymentInstructionMap(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    	Test.startTest();
        Map<Id, PaymentInstruction__c> resultPaymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMap();
    	System.assertEquals(testPaymentInsturctionMap.size(), resultPaymentInstructionMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetPaymentInstructionMapWithPaymentInstructionID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    	Test.startTest();
        Map<Id, PaymentInstruction__c> resultPaymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentInstructionID(testPaymentInsturctionMap.keySet());
    	System.assertEquals(testPaymentInsturctionMap.size(), resultPaymentInstructionMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetPaymentInstructionMapWithPaymentStudentID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    	Test.startTest();
        Map<Id, PaymentInstruction__c> resultPaymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentStudentID(testStudentAccountMap.keySet());
    	System.assertEquals(testPaymentInsturctionMap.size(), resultPaymentInstructionMap.keySet().size());
    	Test.stopTest();
    }
}