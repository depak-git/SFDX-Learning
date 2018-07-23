/////////////////////////////////////////////////////////////////////////
// Class: PaymentAllocationTriggerHandler_TEST
// 
// Description: 
// 		Test class for PaymentAllocationTriggerHandler
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-10   Jared Hagemann  Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class PaymentAllocationTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studProgramMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, PaymentMethod__c> paymentMethods = TestDataFactory.createAndInsertPaymentMethod(1, students);
    	Map<ID, PaymentInstruction__c> paymentInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(TestUtil.TEST_THROTTLE, students, paymentMethods);
    }
	//to do jared - this is just a dummy method to get past test levels
	@isTest
	public static void testManageAgreementsInsert(){
		TestUtil.setStandardConfiguration();
		Map<Id, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMap();
		Map<ID, PaymentInstruction__c> paymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMap();
    	Test.startTest();
    		Map<Id, PaymentAllocation__c> paymentAllocationMap = TestDataFactory.createAndInsertPaymentAllocation(5, paymentInstructionMap, studProgramMap);
    	Test.stopTest();
    	Map<Id, StudentProgram__c> studProgramResultMap = StudentProgramQueries.getStudentProgramMap();
    	for(StudentProgram__c sp : studProgramResultMap.values()){
    		System.assertEquals(5000, sp.PaidToDate__c);
    	} 		
	}

	@isTest
	public static void testManageAgreementsUpdate(){
		TestUtil.setStandardConfiguration();
		Map<Id, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMap();
		Map<ID, PaymentInstruction__c> paymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMap();
		Map<Id, PaymentAllocation__c> paymentAllocationMap = TestDataFactory.createAndInsertPaymentAllocation(5, paymentInstructionMap, studProgramMap);
		for(PaymentAllocation__c pa : paymentAllocationMap.values()){
			pa.AmountAllocated__c = 500;
		}
    	Test.startTest();
    		update paymentAllocationMap.values();
    	Test.stopTest();
    	Map<Id, StudentProgram__c> studProgramResultMap = StudentProgramQueries.getStudentProgramMap();
    	for(StudentProgram__c sp : studProgramResultMap.values()){
    		System.assertEquals(2500, sp.PaidToDate__c);
    	} 		
	}

	@isTest
	public static void testManageAgreementsDelete(){
		TestUtil.setStandardConfiguration();
		Map<Id, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMap();
		Map<ID, PaymentInstruction__c> paymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMap();
		Map<Id, PaymentAllocation__c> paymentAllocationMap = TestDataFactory.createAndInsertPaymentAllocation(5, paymentInstructionMap, studProgramMap);
    	Test.startTest();
    		delete paymentAllocationMap.values();
    	Test.stopTest();
    	Map<Id, StudentProgram__c> studProgramResultMap = StudentProgramQueries.getStudentProgramMap();
    	for(StudentProgram__c sp : studProgramResultMap.values()){
    		System.assertEquals(0, sp.PaidToDate__c);
    	} 	
	}
}