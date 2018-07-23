@isTest
public class VemoAPIDisbursementResource_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    static testMethod void testHandleGetV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);

        Map<String, String> disParams = new Map<String, String>();
        disParams.put('disbursementID', (String)testDisbursement.values().get(0).Id);
        VemoAPI.APIInfo disApiInfo = TestUtil.initializeAPI('v1', 'GET', disParams, null);
        
        Map<String, String> schoolParams = new Map<String, String>();
        schoolParams.put('schoolID', (String)schools.values().get(0).Id);
        VemoAPI.APIInfo schoolApiInfo = TestUtil.initializeAPI('v1', 'GET', schoolParams, null);

        Test.startTest();
        VemoAPI.ResultResponse stdResult = (VemoAPI.ResultResponse)VemoAPIDisbursementResource.handleAPI(disApiInfo);
        System.assertEquals(1, stdResult.numberOfResults);
        
        VemoAPI.ResultResponse schResult = (VemoAPI.ResultResponse)VemoAPIDisbursementResource.handleAPI(schoolApiInfo);
        //System.assertEquals(1, schResult.numberOfResults);
        
        Test.stopTest();
    }
    
    static testMethod void testHandlePostV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);

        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'testStudent_'+'abc');

        List<VemoAPIDisbursementResource.DisbursementResourceInputV1> disResList = new List<VemoAPIDisbursementResource.DisbursementResourceInputV1>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            VemoAPIDisbursementResource.DisbursementResourceInputV1 disRes = new VemoAPIDisbursementResource.DisbursementResourceInputV1(true);
            disRes.studentID = students.values().get(i).ID;
            disRes.agreementID = agreements.values().get(i).ID;
            disResList.add(disRes);
        }
        String body = JSON.serialize(disResList);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIDisbursementResource.handleAPI(apiInfo);
        System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
        Test.stopTest();
    }
    
    static testMethod void validateHandlePutV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);

        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'testStudent_'+'abc');

        List<VemoAPIDisbursementResource.DisbursementResourceInputV1> disResList = new List<VemoAPIDisbursementResource.DisbursementResourceInputV1>();
        VemoAPIDisbursementResource.DisbursementResourceInputV1 disRes = new VemoAPIDisbursementResource.DisbursementResourceInputV1();
        disRes.disbursementID = testDisbursement.values().get(0).ID;
        disRes.amount = 5000;
        disResList.add(disRes);

        String body = JSON.serialize(disResList);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIDisbursementResource.handleAPI(apiInfo);
        System.assertEquals(1, result.numberOfResults);
        Test.stopTest();
    }

    static testMethod void testHandleDeleteV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);

        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'testStudent_'+'abc');
        params.put('disbursementID', (String)testDisbursement.values().get(0).Id);     
           
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIDisbursementResource.handleAPI(apiInfo);
        System.assertEquals(1, result.numberOfResults);
        System.assertEquals((TestUtil.TEST_THROTTLE *TestUtil.TEST_THROTTLE) - 1, TransactionQueries.getTransactionMap(TransactionService.disbursementRecType).size(), 'One Student should be deleted');
        Test.stopTest();
    }
}