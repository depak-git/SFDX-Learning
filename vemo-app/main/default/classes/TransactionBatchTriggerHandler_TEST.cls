@isTest
public with sharing class TransactionBatchTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	@isTest public static void validateDML(){
		TestUtil.setStandardConfiguration();
		Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Program__c> otherPrograms = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> txMap = TestDataFactory.createAndInsertTransactions(2, agreements,
    																				TransactionService.disbursementRecType);
    	List<TransactionBatch__c> txBatchList = new List<TransactionBatch__c>();
    	txBatchList.add(new TransactionBatch__c(Program__c = programs.values()[0].id,
	    									   TransactionsFrom__c = Date.Today().addDays(-1),
	    									   TransactionsThrough__c = Date.Today().addDays(1),
	    									   TransactionBatchStatus__c = 'Created'));

    	Test.startTest();
    	insert(txBatchList);

    	txBatchList[0].TransactionBatchStatus__c = 'Select Transactions';
    	update txBatchList;
    	
    	txBatchList[0].UpdateTransactionDateTime__c = Datetime.now().addMinutes(1);
    	txBatchList[0].UpdateTransactionStatus__c = 'Cancelled';
    	txBatchList[0].UpdateConfirmed__c = 'Confirmed';
    	update txBatchList; 

    	txBatchList[0].TransactionBatchStatus__c = 'Release Transactions';
    	update txBatchList;

    	delete txBatchList;
    	undelete txBatchList;
    	Test.stopTest();
	}


}