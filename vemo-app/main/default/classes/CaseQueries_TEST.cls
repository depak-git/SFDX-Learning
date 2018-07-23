/////////////////////////////////////////////////////////////////////////
// Class: CaseQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class CaseQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	@isTest public static void validateGetCaseMapByID() {
		Map<ID, Case> testCaseMap = TestDataFactory.createAndInsertCases(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<ID, Case> caseMap = CaseQueries.getCaseMapByID();
		system.assertEquals(testCaseMap.size(), caseMap.size());
		Test.stopTest();
	}

	@isTest public static void validateGetCaseMapWithCaseID() {
		Map<ID, Case> testCaseMap = TestDataFactory.createAndInsertCases(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<ID, Case> caseMap = CaseQueries.getCaseMapWithCaseID(testCaseMap.keySet());
		system.assertEquals(testCaseMap.size(), caseMap.size());
		Test.stopTest();
	}

	@isTest public static void validateGetCaseMapWithStudentID() {
		Map<ID, Case> testCaseMap = TestDataFactory.createAndInsertCases(TestUtil.TEST_THROTTLE);
		Map<ID, Account> testStudents = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);		
		for(Integer i=0; i<TestUtil.TEST_THROTTLE; i++){
			testCaseMap.values().get(i).AccountID = testStudents.values().get(i).ID;
		}
		update testCaseMap.values();
		Test.startTest();
		Map<ID, Case> caseMap = CaseQueries.getCaseMapWithStudentID(testStudents.keySet());
		system.assertEquals(testCaseMap.size(), caseMap.size());
		Test.stopTest();
	}
}