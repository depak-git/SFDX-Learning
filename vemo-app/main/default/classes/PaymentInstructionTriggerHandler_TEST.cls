/////////////////////////////////////////////////////////////////////////
// Class: PaymentInstructionTriggerHandler_TEST
// 
// Description: 
// 		Test class for PaymentInstructionTriggerHandler
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-17   Jared Hagemann  Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class PaymentInstructionTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(1);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);

    	//Add a few fees
    	//5 fees @ $1000 apiece
    	Map<ID, Fee__c> testFeeMap = TestDataFactory.createAndInsertFee(1, testStudentAccountMap);
    	
    	Map<Id, PaymentInstruction__c> paymenetInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    }

	@isTest public static void testManageAllocations(){
    	Map<ID, PaymentInstruction__c> paymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMap();
    	paymentInstructionMap.values().get(0).Allocate__c = true;
    	paymentInstructionMap.values().get(0).Amount__c = 500;
    	Test.startTest();
    	update paymentInstructionMap.values();
    	Test.stopTest();
    	List<Case> cases = [select Id from Case];
    	System.assertEquals(1, cases.size());
	}
}