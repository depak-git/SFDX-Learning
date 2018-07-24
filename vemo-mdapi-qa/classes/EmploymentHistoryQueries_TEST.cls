/////////////////////////////////////////////////////////////////////////
// Class: EmploymentHistoryQueries_TEST
// 
// Description: 
//  Unit test for EmploymentHistoryQueries
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class EmploymentHistoryQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetEmploymentHistoryMap(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Test.startTest();
    	Map<Id, EmploymentHistory__c> resultEmpHisMap = EmploymentHistoryQueries.getEmploymentHistoryMap();
    	System.assertEquals(testEmpHisMap.keySet().size(), resultEmpHisMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetEmploymentHistoryMapWithEmploymentHistoryId(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Test.startTest();
    	Map<Id, EmploymentHistory__c> resultEmpHisMap = EmploymentHistoryQueries.getEmploymentHistoryMapWithEmploymentHistoryId(testEmpHisMap.keySet());
    	System.assertEquals(testEmpHisMap.keySet().size(), resultEmpHisMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetEmploymentHistoryMapWithStudentId(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        Test.startTest();
        Map<Id, EmploymentHistory__c> resultEmpHisMap = EmploymentHistoryQueries.getEmploymentHistoryMapWithStudentId(testStudentAccountMap.keySet());
        System.assertEquals(testEmpHisMap.keySet().size(), resultEmpHisMap.keySet().size());
        Test.stopTest();
    }
}