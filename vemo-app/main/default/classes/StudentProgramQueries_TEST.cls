/////////////////////////////////////////////////////////////////////////
// Class: StudentProgramQueries_TEST
// 
// Description: 
//      Test class for StudentProgramQueries
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-24   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class StudentProgramQueries_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);
        Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);
    }
    @isTest public static void validateGetStudentProgramMap(){
        /*
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);
        Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);
        */
        Test.startTest();
        Map<Id, StudentProgram__c> resultStudentPrgMap = StudentProgramQueries.getStudentProgramMap();
        //System.assertEquals(studentPrgMap.keySet().size(), resultStudentPrgMap.keySet().size());
        Test.stopTest();
    }

    @isTest public static void validateGetStudentProgramMapWithAgreementID(){
        /*
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);
        Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);
        */
        Map<Id, StudentProgram__c> studentPrgMap = StudentProgramQueries.getStudentProgramMap();
        Set<ID> agreementIDs = new Set<ID>();
        for(StudentProgram__c studPrg : studentPrgMap.values()){
            agreementIDs.add(studPrg.ID);
        }
        Test.startTest();
        Map<Id, StudentProgram__c> resultStudentPrgMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
        System.assertEquals(studentPrgMap.keySet().size(), resultStudentPrgMap.keySet().size());
        Test.stopTest();
    }

    @isTest public static void validateGetStudentProgramMapWithStudentID(){
        /*
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);
        Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);
        */
        Map<Id, StudentProgram__c> studentPrgMap = StudentProgramQueries.getStudentProgramMap();
        Set<ID> studentIDs = new Set<ID>();
        for(StudentProgram__c studPrg : studentPrgMap.values()){
            studentIDs.add(studPrg.Student__c);
        }
        Test.startTest();
        Map<Id, StudentProgram__c> resultStudentPrgMap = StudentProgramQueries.getStudentProgramMapWithStudentID(studentIDs);
        System.assertEquals(studentPrgMap.keySet().size(), resultStudentPrgMap.keySet().size());
        Test.stopTest();
    }

    @isTest public static void validateGetStudentProgramMapWithSchoolID(){
        /*
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);
        Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);
        */
        Map<Id, StudentProgram__c> studentPrgMap = StudentProgramQueries.getStudentProgramMap();
        Set<ID> schoolIDs = new Set<ID>();
        for(StudentProgram__c studPrg : studentPrgMap.values()){
            schoolIDs.add(studPrg.Program__r.School__c);
        }
        Test.startTest();
        Map<Id, StudentProgram__c> resultStudentPrgMap = StudentProgramQueries.getStudentProgramMapWithSchoolID(schoolIDs);
        System.assertEquals(studentPrgMap.keySet().size(), resultStudentPrgMap.keySet().size());
        Test.stopTest();
    }
}