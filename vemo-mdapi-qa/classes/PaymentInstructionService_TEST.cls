/////////////////////////////////////////////////////////////////////////
// Class: PaymentInstructionService_TEST
// 
// Description: 
//  Unit test for PaymentInstructionService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-18   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class PaymentInstructionService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetPaymentInstructionWithPaymentInstructionID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    	Test.startTest();
        List<PaymentInstructionService.PaymentInstruction> resultPaymentInstructionMap = PaymentInstructionService.getPaymentInstructionWithPaymentInstructionID(testPaymentInsturctionMap.keySet());
    	System.assertEquals(testPaymentInsturctionMap.size(), resultPaymentInstructionMap.size());
    	Test.stopTest();
    }

    static testMethod void testGetPaymentInstructionWithStudentID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    	Test.startTest();
        List<PaymentInstructionService.PaymentInstruction> resultPaymentInstructionMap = PaymentInstructionService.getPaymentInstructionWithStudentID(testStudentAccountMap.keySet());
    	System.assertEquals(testPaymentInsturctionMap.size(), resultPaymentInstructionMap.size());
    	Test.stopTest();
    }

    static testMethod void testCreatePaymentInstruction(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	List<PaymentInstructionService.PaymentInstruction> pymntInstructions = new List<PaymentInstructionService.PaymentInstruction>();
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		PaymentInstructionService.PaymentInstruction pymntIns = new PaymentInstructionService.PaymentInstruction(true);
    		pymntIns.studentID = testStudentAccountMap.values().get(i).Id;
    		pymntIns.paymentMethodID = testPaymentMethodMap.values().get(i).Id;
    		pymntInstructions.add(pymntIns);
    	}
    	Test.startTest();
    	Set<ID> pymntInsIDs = PaymentInstructionService.createPaymentInstruction(pymntInstructions);
    	System.assertEquals(pymntInstructions.size(), PaymentInstructionQueries.getPaymentInstructionMap().size());
    	Test.stopTest();
    }

    static testMethod void testUpdatePaymentInstruction(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    	List<PaymentInstructionService.PaymentInstruction> pymntInstructions = new List<PaymentInstructionService.PaymentInstruction>();
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		PaymentInstructionService.PaymentInstruction pymntIns = new PaymentInstructionService.PaymentInstruction(true);
    		pymntIns.paymentInstructionID = testPaymentInstructionMap.values().get(i).Id;
    		//pymntIns.student = testStudentAccountMap.values().get(i).Id;
    		pymntIns.paymentMethodID = testPaymentMethodMap.values().get(i).Id;
    		pymntInstructions.add(pymntIns);
    	}
    	Test.startTest();
    	Set<ID> pymntInsIDs = PaymentInstructionService.updatePaymentInstruction(pymntInstructions);
    	System.assertEquals(pymntInstructions.size(), PaymentInstructionQueries.getPaymentInstructionMap().size());
    	Test.stopTest();
    }

    static testMethod void testDeletePaymentInstruction(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);

    	Test.startTest();
    	Integer del = PaymentInstructionService.deletePaymentInstruction(testPaymentInstructionMap.keySet());
    	Test.stopTest();
    	System.assertEquals(testPaymentInstructionMap.size(), del);
    	System.assertEquals(0, PaymentInstructionQueries.getPaymentInstructionMap().size());
    }
}