/////////////////////////////////////////////////////////////////////////
// Class: PaymentMethodService_TEST
// 
// Description: 
//  Unit test for PaymentMethodService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-13   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class PaymentMethodService_TEST {
    
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetPaymentMethodWithPaymentMethodID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

    	Test.startTest();
    	List<PaymentMethodService.PaymentMethod> resultPymntMeth = PaymentMethodService.getPaymentMethodWithPaymentMethodID(testPaymentMethodMap.keySet());
    	System.assertEquals(testPaymentMethodMap.keySet().size(), resultPymntMeth.size());
    	Test.stopTest(); 
    }

    static testMethod void testGetPaymentMethodWithCustomerID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

    	Test.startTest();
    	List<PaymentMethodService.PaymentMethod> resultPymntMeth = PaymentMethodService.getPaymentMethodWithCustomerID(testStudentAccountMap.keySet());
    	System.assertEquals(testPaymentMethodMap.keySet().size(), resultPymntMeth.size());
    	Test.stopTest(); 
    }

    static testMethod void testCreatePaymentMethod(){
    	List<PaymentMethodService.PaymentMethod> paymentMethods = new List<PaymentMethodService.PaymentMethod>();
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		PaymentMethodService.PaymentMethod pymntMeth = new PaymentMethodService.PaymentMethod(true);
    		pymntMeth.customerID = testStudentAccountMap.values().get(i).Id;
    		paymentMethods.add(pymntMeth);
    	}
    	Test.startTest();
    	Set<ID> pymntMethIDs = PaymentMethodService.createPaymentMethod(paymentMethods);
    	System.assertEquals(paymentMethods.size(), PaymentMethodQueries.getPaymentMethodMap().size());
    	Test.stopTest();
    }

    static testMethod void testUpdatePaymentMethod(){
    	List<PaymentMethodService.PaymentMethod> paymentMethods = new List<PaymentMethodService.PaymentMethod>();
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		PaymentMethodService.PaymentMethod pymntMeth = new PaymentMethodService.PaymentMethod(true);
    		pymntMeth.customerID = testStudentAccountMap.values().get(i).Id;
    		paymentMethods.add(pymntMeth);
    	}
    	Set<ID> pymntMethIDs = PaymentMethodService.createPaymentMethod(paymentMethods);
    	List<PaymentMethodService.PaymentMethod> insertedPaymentMethods = PaymentMethodService.getPaymentMethodWithPaymentMethodID(pymntMethIDs);
    	for(PaymentMethodService.PaymentMethod pymntMeth : insertedPaymentMethods){
    		pymntMeth.bankAccountNumber = '4321';
    	}
    	Test.startTest();
    	Set<ID> updatedPymntMethIDs = PaymentMethodService.updatePaymentMethod(insertedPaymentMethods);
    	Test.stopTest();
    	Map<Id, PaymentMethod__c> updatedPymntMethMap = PaymentMethodQueries.getPaymentMethodMapWithPaymentMethodID(updatedPymntMethIDs);
    	for(PaymentMethod__c pymntMeth : updatedPymntMethMap.values()){
    		System.assertEquals('4321', pymntMeth.BankAccountNumber__c);
    	}
    }

    static testMethod void testDeletePaymentMethod(){
    	List<PaymentMethodService.PaymentMethod> paymentMethods = new List<PaymentMethodService.PaymentMethod>();
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		PaymentMethodService.PaymentMethod pymntMeth = new PaymentMethodService.PaymentMethod(true);
    		pymntMeth.customerID = testStudentAccountMap.values().get(i).Id;
    		paymentMethods.add(pymntMeth);
    	}
    	Set<ID> pymntMethIDs = PaymentMethodService.createPaymentMethod(paymentMethods);
    	System.assertEquals(paymentMethods.size(), PaymentMethodQueries.getPaymentMethodMap().size());

    	Test.startTest();
    	Integer del = PaymentMethodService.deletePaymentMethod(pymntMethIDs);
    	Test.stopTest();
    	System.assertEquals(pymntMethIDs.size(), del);
    	System.assertEquals(0, PaymentMethodQueries.getPaymentMethodMap().size());
    }
    

}