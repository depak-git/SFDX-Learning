@isTest
public class TransactionQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetTransactionMap(){

    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);
    	Test.startTest();
    	Map<ID, Transaction__c> disbursement = TransactionQueries.getTransactionMap(TransactionService.disbursementRecType);
    	System.assertEquals(testDisbursement.size(), disbursement.size());
    }

    @isTest public static void validateGetTransactionMapWithDisbursementID(){

    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);
    	Test.startTest();
    	Map<ID, Transaction__c> disbursement = TransactionQueries.getTransactionMapWithTransactionID(testDisbursement.keySet(), TransactionService.disbursementRecType);
    	System.assertEquals(testDisbursement.size(), disbursement.size());
    }

    @isTest public static void validateGetTransactionMapWithStudentID(){

    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);    	
    	Test.startTest();
    	Map<ID, Transaction__c> disbursement = TransactionQueries.getTransactionMapWithStudentID(students.keySet(), TransactionService.disbursementRecType);
    	System.assertEquals(testDisbursement.size(), disbursement.size());
    }

    @isTest public static void validateGetTransactionMapWithAgreementID(){

    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);    	
    	Test.startTest();
    	Map<ID, Transaction__c> disbursement = TransactionQueries.getTransactionMapWithAgreementID(agreements.keySet(), TransactionService.disbursementRecType);
    	System.assertEquals(testDisbursement.size(), disbursement.size());
    }
}