/////////////////////////////////////////////////////////////////////////
// Class: EmploymentHistoryService_TEST
// 
// Description: 
// 	Test class for EmploymentHistoryService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
@isTest
public class EmploymentHistoryService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetEmploymentHistoryWithEmployentHistoryID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Test.startTest();
    	List<EmploymentHistoryService.EmploymentHistory> resultEmpHisList = EmploymentHistoryService.getEmploymentHistoryWithEmployentHistoryID(testEmpHisMap.keySet());
    	System.assertEquals(testEmpHisMap.keySet().size(), resultEmpHisList.size());
    	Test.stopTest();
    }

    static testMethod void testGetEmploymentHistoryWithStudentID(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        Test.startTest();
        List<EmploymentHistoryService.EmploymentHistory> resultEmpHisList = EmploymentHistoryService.getEmploymentHistoryWithStudentID(testStudentAccountMap.keySet());
        System.assertEquals(testEmpHisMap.keySet().size(), resultEmpHisList.size());
        Test.stopTest();
    }

    static testMethod void testCreateEmploymentHistory(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        //Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        List<EmploymentHistoryService.EmploymentHistory> empHisList = new List<EmploymentHistoryService.EmploymentHistory>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            EmploymentHistoryService.EmploymentHistory empHis = new EmploymentHistoryService.EmploymentHistory(true);
            empHis.studentID = testStudentAccountMap.values().get(i).Id;
            empHisList.add(empHis);
        }
        Test.startTest();
        Set<ID> empHisIDs = EmploymentHistoryService.createEmploymentHistory(empHisList);
        System.assertEquals(empHisList.size(), EmploymentHistoryQueries.getEmploymentHistoryMap().size());
        Test.stopTest();
    }

    static testMethod void testUpdateEmploymentHistory(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        List<EmploymentHistoryService.EmploymentHistory> empHisList = new List<EmploymentHistoryService.EmploymentHistory>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            EmploymentHistoryService.EmploymentHistory empHis = new EmploymentHistoryService.EmploymentHistory(true);
            empHis.employmentHistoryID = testEmpHisMap.values().get(i).Id;
            empHis.verified = false;
            empHisList.add(empHis);
        }
        Test.startTest();
        Set<ID> empHisIDs = EmploymentHistoryService.updateEmploymentHistory(empHisList);        
        Test.stopTest();
        System.assertEquals(TestUtil.TEST_THROTTLE, empHisList.size());
        for(EmploymentHistory__c empHis : EmploymentHistoryQueries.getEmploymentHistoryMap().values()){
            System.assert(!empHis.Verified__c);
        }
    }

    static testMethod void testDeleteEmploymentHistory(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        Test.startTest();
        Integer deleted = EmploymentHistoryService.deleteEmploymentHistory(testEmpHisMap.keySet());        
        Test.stopTest();
        System.assertEquals(testEmpHisMap.keySet().size(), deleted);
        System.assertEquals(0, EmploymentHistoryQueries.getEmploymentHistoryMap().size());
    }

}