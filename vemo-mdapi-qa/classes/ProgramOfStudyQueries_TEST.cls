@isTest
public with sharing class ProgramOfStudyQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetProgramOfStudyMap(){
    	Map<ID, ProgramOfStudy__c> testPOS = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Test.startTest();
    	Map<ID, ProgramOfStudy__c> resultPOS = ProgramOfStudyQueries.getProgramOfStudyMap();
    	System.assertEquals(testPOS.size(), resultPOS.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetProgramOfStudyMapWithPOSID(){
    	Map<ID, ProgramOfStudy__c> testPOS = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Test.startTest();
    	Map<ID, ProgramOfStudy__c> resultPOS = ProgramOfStudyQueries.getProgramOfStudyMapWithPOSID(testPOS.keySet());
    	System.assertEquals(testPOS.size(), resultPOS.size());
    	Test.stopTest();
    }
}