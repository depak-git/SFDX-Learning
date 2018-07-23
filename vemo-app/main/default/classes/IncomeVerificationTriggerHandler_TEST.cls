/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-07   Jared Hagemann  Created                              
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class IncomeVerificationTriggerHandler_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testVerify(){
        TestUtil.setStandardConfiguration();
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
        Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
        IncomeVerification__c incVer = testIncVerMap.values().get(0);
        //incVer.Verified__c = true;
        incVer.status__c = 'Verified';
        incVer.IncomePerMonth__c = 1000;
        Test.startTest();
        update incVer;
        Account student = [select Id, DateIncomeVerified__pc, VerifiedAnnualIncome__pc from Account where Id =: incVer.Student__c];
        System.assertEquals(12000, student.VerifiedAnnualIncome__pc);
        System.assertEquals(System.today(), student.DateIncomeVerified__pc);

        IncomeVerification__c incVer2 = new IncomeVerification__c(IncomePerMonth__c = 2000,
                                                                        EmploymentHistory__c = incVer.EmploymentHistory__c,
                                                                        Student__c = student.Id,
                                                                        Status__c = 'Verified',
                                                                        DateVerified__c = System.today().addDays(2));


        insert incVer2;
        Account student2 = [select Id, DateIncomeVerified__pc, VerifiedAnnualIncome__pc from Account where Id =: incVer2.Student__c];       
        System.assertEquals(24000, student2.VerifiedAnnualIncome__pc);
        System.assertEquals(incVer2.DateVerified__c, student2.DateIncomeVerified__pc);
        Test.stopTest();
        
    }
}