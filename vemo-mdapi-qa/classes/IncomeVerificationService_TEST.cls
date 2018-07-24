/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationService_TEST
// 
// Description: 
// 	Unit test for IncomeVerificationService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-12   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
@isTest
public class IncomeVerificationService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetIncomeVerificationWithIncomeVerificationID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
    	Test.startTest();
    	List<IncomeVerificationService.IncomeVerification> resultIncVerList = IncomeVerificationService.getIncomeVerificationWithIncomeVerificationID(testIncVerMap.keySet());
    	System.assertEquals(testIncVerMap.keySet().size(), resultIncVerList.size());
    	Test.stopTest();
    }

    static testMethod void testGetIncomeVerificationWithStudentId(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
    	Test.startTest();
    	List<IncomeVerificationService.IncomeVerification> resultIncVerList = IncomeVerificationService.getIncomeVerificationWithStudentId(testStudentAccountMap.keySet());
    	System.assertEquals(testIncVerMap.keySet().size(), resultIncVerList.size());
    	Test.stopTest();
    }

    static testMethod void testCreateIncomeVerification(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        //Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        List<IncomeVerificationService.IncomeVerification> incVerList = new List<IncomeVerificationService.IncomeVerification>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            IncomeVerificationService.IncomeVerification incVer = new IncomeVerificationService.IncomeVerification(true);
            incVer.studentID = testStudentAccountMap.values().get(i).Id;
            incVerList.add(incVer);
        }
        Test.startTest();
        Set<ID> incVerIDs = IncomeVerificationService.createIncomeVerification(incVerList);
        System.assertEquals(incVerList.size(), IncomeVerificationQueries.getIncomeVerificationMap().size());
        Test.stopTest();
    }

    static testMethod void testUpdateIncomeVerification(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
        List<IncomeVerificationService.IncomeVerification> incVerList = new List<IncomeVerificationService.IncomeVerification>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            IncomeVerificationService.IncomeVerification incVer = new IncomeVerificationService.IncomeVerification(true);
            incVer.incomeVerificationID = testIncVerMap.values().get(i).Id;
            incVer.incomePerMonth = 1000;
            incVerList.add(incVer);
        }
        Test.startTest();
        Set<ID> incVerIDs = IncomeVerificationService.updateIncomeVerification(incVerList);        
        System.assertEquals(TestUtil.TEST_THROTTLE, incVerIDs.size());
        Test.stopTest();
        for(IncomeVerification__c incVer : IncomeVerificationQueries.getIncomeVerificationMap().values()){
            System.assertEquals(1000, incVer.IncomePerMonth__c);
        }
    }

    static testMethod void testDeleteIncomeVerification(){
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
        Test.startTest();
        Integer deleted = IncomeVerificationService.deleteIncomeVerificationy(testIncVerMap.keySet());        
        Test.stopTest();
        System.assertEquals(testIncVerMap.keySet().size(), deleted);
        System.assertEquals(0, IncomeVerificationQueries.getIncomeVerificationMap().size());
    }
}