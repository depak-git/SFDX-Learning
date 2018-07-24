/////////////////////////////////////////////////////////////////////////
// Class: StatementService_TEST
// 
// Description: 
// 		Test class for StatementService
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-10   Jared Hagemann  Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class StatementService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	static testMethod void testGetCurrentStatementV1ByStudentWithStudentID(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studProgramMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	for(StudentProgram__c sp : studProgramMap.values()){
    		sp.NextPaymentDue__c = 1000;
    	}
    	update studProgramMap.values();
    	
    	Test.startTest();
    	Map<ID, StatementService.StatementV1> statements =  StatementService.getCurrentStatementV1ByStudentWithStudentID(students.keySet());
    	Test.stopTest();
    	System.assertEquals(students.size(), statements.size());
    	for(StatementService.StatementV1 statement : statements.values()){
    		System.assertEquals(TestUtil.TEST_THROTTLE, statement.agreements.size());
    	}
	}

	static testMethod void testStatementV1(){
		Test.startTest();
		StatementService.StatementV1 statements = new StatementService.StatementV1(true);
		Test.stopTest();
		System.assert(true);

	}

	static testMethod void testCreateBillsFromStatements(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studProgramMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, StatementService.StatementV1> statements =  StatementService.getCurrentStatementV1ByStudentWithStudentID(students.keySet());
    	Test.startTest();
    		StatementService.createBillsFromStatements(statements.values());
    	Test.stopTest();
    	List<Bill__c> bills = [select Id from Bill__c];
    	System.assertEquals(statements.size(), bills.size());
	}
}