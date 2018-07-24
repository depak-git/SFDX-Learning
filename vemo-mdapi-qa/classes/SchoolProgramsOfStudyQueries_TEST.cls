@isTest
public with sharing class SchoolProgramsOfStudyQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetSchoolProgramOfStudyMap(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, posMap);
    	Test.startTest();
    	Map<ID, SchoolProgramsOfStudy__c> resultSPOSMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMap();
    	System.assertEquals(testSPOSMap.size(), resultSPOSMap.size());
    	Test.stopTest();
    }

    @isTest public static void getSchoolProgramOfStudyMapWithSPOSID(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, posMap);
    	Test.startTest();
    	Map<ID, SchoolProgramsOfStudy__c> resultSPOSMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSPOSID(testSPOSMap.keySet());
    	System.assertEquals(testSPOSMap.size(), resultSPOSMap.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetSchoolProgramOfStudyMapWithPOSID(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, posMap);
    	Test.startTest();
    	Map<ID, SchoolProgramsOfStudy__c> resultSPOSMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithPOSID(posMap.keySet());
    	System.assertEquals(testSPOSMap.size(), resultSPOSMap.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetSchoolProgramOfStudyMapWithSchoolID(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, posMap);
    	Test.startTest();
    	Map<ID, SchoolProgramsOfStudy__c> resultSPOSMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(schools.keySet());
    	System.assertEquals(testSPOSMap.size(), resultSPOSMap.size());
    	Test.stopTest();
    }
}