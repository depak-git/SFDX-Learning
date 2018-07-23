/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationQueries_TEST
// 
// Description: 
//  Unit test for IncomeVerificationQueries
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class PaymentMethodQueries_TEST {
    
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetPaymentMethodMap(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

    	Test.startTest();
        Map<Id, PaymentMethod__c> resultPymntMthdMap = PaymentMethodQueries.getPaymentMethodMap();
    	System.assertEquals(testPaymentMethodMap.keySet().size(), resultPymntMthdMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetPaymentMethodMapWithPaymentMethodID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

    	Test.startTest();
        Map<Id, PaymentMethod__c> resultPymntMthdMap = PaymentMethodQueries.getPaymentMethodMapWithPaymentMethodID(testPaymentMethodMap.keySet());
    	System.assertEquals(testPaymentMethodMap.keySet().size(), resultPymntMthdMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetPaymentMethodMapWithStudentID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

    	Test.startTest();
        Map<Id, PaymentMethod__c> resultPymntMthdMap = PaymentMethodQueries.getPaymentMethodMapWithCustomerID(testStudentAccountMap.keySet());
    	System.assertEquals(testPaymentMethodMap.keySet().size(), resultPymntMthdMap.keySet().size());
    	Test.stopTest();
    }
    
}