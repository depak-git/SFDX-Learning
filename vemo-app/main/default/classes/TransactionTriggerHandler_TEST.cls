@isTest
public with sharing class TransactionTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	@isTest public static void validateDML(){
		TestUtil.setStandardConfiguration();
		Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);

		Test.startTest();
    	Map<ID, Transaction__c> txMap = TestDataFactory.createAndInsertTransactions(2, agreements,
    																				TransactionService.disbursementRecType);
    	update txMap.values();
    	delete txMap.values();
    	undelete txMap.values();
    	Test.stopTest();
	}


}