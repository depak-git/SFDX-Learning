@isTest
public class VemoAPILedgerResource_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<Id, StudentProgram__c> studProgramMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);
        Map<Id, Transaction__c> transactions = TestDataFactory.createAndInsertTransactions(TestUtil.TEST_THROTTLE,studProgramMap, TransactionService.disbursementRecType);
        //Map<Id, Transaction__c> transactions1 = TestDataFactory.createAndInsertTransactions(TestUtil.TEST_THROTTLE,studProgramMap, 'FEE');
      
        Map<String, String> ledgerParams = new Map<String, String>();
        
        ledgerParams.put('customerID', (String)schools.values().get(0).id);
        VemoAPI.APIInfo ledgerApiInfo = TestUtil.initializeAPI('v1', 'GET', ledgerParams, null);
        
        Test.startTest();
        
        VemoAPI.ResultResponse ledgerResult = (VemoAPI.ResultResponse)VemoAPILedgerResource.handleAPI(ledgerApiInfo);
        //System.assertEquals(1, ledgerResult.numberOfResults);
        
        Test.stopTest();
    }
}