/////////////////////////////////////////////////////////////////////////
// Class: AccountTriggerHandler_TEST
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2015-07-06   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
private class AccountTriggerHandler_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateProspectCreate
    /////////////////////////////////////////////////////////////////////////   
    @isTest
    static void validateProspectCreate() {  
        TestUtil.setStandardConfiguration();

        Map<ID, Account> acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),0,'No Account Records Should Exist');
        
        Test.startTest();
        Map<ID, Account> acctMap = TestDataFactory.createAndInsertSchoolProspectAccounts(TestUtil.TEST_THROTTLE);
        Test.stopTest();

        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');
        
    }    
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateAccountUpdate
    /////////////////////////////////////////////////////////////////////////   
    @isTest
    static void validateProspectUpdate() {  
        TestUtil.setStandardConfiguration();

        Map<ID, Account> acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),0,'No Account Records Should Exist');
        

        Map<ID, Account> acctMap = TestDataFactory.createAndInsertSchoolProspectAccounts(TestUtil.TEST_THROTTLE);
        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');

        for(Account acct : acctMap.values()){
            acct.AccountNumber = 'update';
        }
        Test.startTest();
        update acctMap.values();
        Test.stopTest();

        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');
    }   
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateAccountDelete
    /////////////////////////////////////////////////////////////////////////   
    @isTest
    static void validateProspectDelete() {  
        TestUtil.setStandardConfiguration();

        Map<ID, Account> acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),0,'No Account Records Should Exist');
        

        Map<ID, Account> acctMap = TestDataFactory.createAndInsertSchoolProspectAccounts(TestUtil.TEST_THROTTLE);
        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');

        Test.startTest();
        delete acctMap.values();
        Test.stopTest();

        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),0,'No Account Records Should Exist');
    } 
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateAccountUndelete
    /////////////////////////////////////////////////////////////////////////   
    @isTest
    static void validateProspectUndelete() {    
        TestUtil.setStandardConfiguration();

        Map<ID, Account> acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),0,'No Account Records Should Exist');
        

        Map<ID, Account> acctMap = TestDataFactory.createAndInsertSchoolProspectAccounts(TestUtil.TEST_THROTTLE);
        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');

        delete acctMap.values();
        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),0,'No Account Records Should Exist');     

        Test.startTest();
        undelete acctMap.values();
        Test.stopTest();

        acctToValidate = AccountQueries.getSchoolMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');


    }

    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateStudentUpdate
    /////////////////////////////////////////////////////////////////////////   
    @isTest
    static void validateStudentUpdate() {   
        TestUtil.setStandardConfiguration();

        Map<ID, Account> acctToValidate = AccountQueries.getStudentMap();
        system.assertEquals(acctToValidate.size(),0,'No Account Records Should Exist');
        

        Map<ID, Account> acctMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        acctToValidate = AccountQueries.getStudentMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');

        for(Account acct : acctMap.values()){
            acct.FirstName = 'first name update';
            acct.LastName = 'Last name update';
            acct.MiddleName = 'middle name update';
            acct.PersonBirthdate = Date.today();
            acct.Residency__pc = 'US Citizen';
            acct.personEmail = 'testing@test.com';
        }
        Test.startTest();
        update acctMap.values();

        for(Account acct : acctMap.values()){
            acct.personEmail = 'testing1@test.com';
            acct.RecordStatus__pc = 'Approved';
        }
        update acctMap.values();
        for(Account acct : acctMap.values()){
            acct.FirstName = 'first name update2';
            acct.LastName = 'Last name update2';
            acct.MiddleName = 'middle name update2';
            acct.PersonBirthdate = Date.today().addDays(1);
            acct.Residency__pc = 'Permanent Resident';
        }
        update acctMap.values();
        for(Account acct : acctMap.values()){
            acct.RecordStatus__pc = 'Approved';
        }       
        Test.stopTest();

        acctToValidate = AccountQueries.getStudentMap();
        system.assertEquals(acctToValidate.size(),TestUtil.TEST_THROTTLE,'Account Records Should Exist');
    }   

    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateShutOffRecurrance
    /////////////////////////////////////////////////////////////////////////   
    @isTest
    static void validateShutOffRecurrance() {       
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(2);
        Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(TestUtil.TEST_THROTTLE, testStudentAccountMap);
        for(Account acnt : testStudentAccountMap.values()){
            acnt.AutoPayment__pc = true;
        }
        for(PaymentMethod__c pm : testPaymentMethodMap.values()){
            pm.UseForRecurring__c = true;
        }
        update testStudentAccountMap.values();
        update testPaymentMethodMap.values();
        for(Account acnt : testStudentAccountMap.values()){
            acnt.AutoPayment__pc = false;
        }
        update testStudentAccountMap.values();
        Map<ID, PaymentMethod__c> resultPaymentMethodMap = PaymentMethodQueries.getPaymentMethodMap();
        for(PaymentMethod__c pm : resultPaymentMethodMap.values()){
            System.assert(!pm.UseForRecurring__c);
        }
    }
}