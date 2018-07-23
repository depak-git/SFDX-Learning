/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationQueries_TEST
// 
// Description: 
//  Unit test for IncomeVerificationQueries
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-24   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class IncomeVerificationQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetIncomeVerificationMap(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
    	Test.startTest();
    	Map<Id, IncomeVerification__c> resultIncVerMap = IncomeVerificationQueries.getIncomeVerificationMap();
    	System.assertEquals(testIncVerMap.keySet().size(), resultIncVerMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetIncomeVerificationMapWithIncomeVerificationId(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
    	Test.startTest();
    	Map<Id, IncomeVerification__c> resultIncVerMap = IncomeVerificationQueries.getIncomeVerificationMapWithIncomeVerificationId(testIncVerMap.keySet());
    	System.assertEquals(testIncVerMap.keySet().size(), resultIncVerMap.keySet().size());
    	Test.stopTest();
    }

    static testMethod void testGetIncomeVerificationMapWithStudentId(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
    	Test.startTest();
    	Map<Id, IncomeVerification__c> resultIncVerMap = IncomeVerificationQueries.getIncomeVerificationMapWithStudentId(testStudentAccountMap.keySet());
    	System.assertEquals(testIncVerMap.keySet().size(), resultIncVerMap.keySet().size());
    	Test.stopTest();
    }
}