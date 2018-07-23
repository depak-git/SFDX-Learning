@isTest
public with sharing class AnnualStatementCTRL_TEST {

    @isTest static void getAccount_Test(){
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(1);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(2, students, programs);
        System.assertEquals(1, studentPrgMap.size());
        AnnualStatementCTRL controllerClass = new AnnualStatementCTRL();
        controllerClass.studentId = students.values()[0].Id;
        controllerClass.getAccount();
    }

    @isTest static void getAccount_TestWithNonStudentAccountId(){
        Map<Id, Account> accountMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        System.assertEquals(1, accountMap.size());
        AnnualStatementCTRL controllerClass = new AnnualStatementCTRL();
        controllerClass.studentId = accountMap.values()[0].Id;
        controllerClass.getAccount();
    }


    @isTest static void getStudentProgramsWithAmountDueList_Test(){
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(1);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(2, students, programs);
        Map<ID, StudentProgramMonthlyStatus__c> studProgMonthlyStatusMap = TestDataFactory.createAndInsertStudentProgramMonthlyStatus(
                12, studentPrgMap
        );
        Map<ID, StudentProgramAmountDue__c> studProgAmountDueMap = TestDataFactory.createAndInsertStudentProgramAmountDue(
                studentPrgMap,
                studProgMonthlyStatusMap
        );
        System.assertEquals(1, studentPrgMap.size());
        AnnualStatementCTRL controllerClass = new AnnualStatementCTRL();
        controllerClass.studentId = students.values()[0].Id;
        controllerClass.getstudentprograms();
        //controllerClass.getStudentProgramsWithAmountDueList();
    }

}