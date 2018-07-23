@isTest
public class VemoAPIDisbursementRefundResource_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    static testMethod void testHandleGetV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursementRefund = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRefundRecType);

        Map<String, String> disParams = new Map<String, String>();
        disParams.put('disbursementRefundID', (String)testDisbursementRefund.values().get(0).Id);
        VemoAPI.APIInfo disApiInfo = TestUtil.initializeAPI('v1', 'GET', disParams, null);
        
        Map<String, String> agreeParams = new Map<String, String>();
        agreeParams.put('agreementID', (String)agreements.values().get(0).Id);
        VemoAPI.APIInfo agreeApiInfo = TestUtil.initializeAPI('v1', 'GET', agreeParams, null);

        Test.startTest();
        VemoAPI.ResultResponse stdResult = (VemoAPI.ResultResponse)VemoAPIDisbursementRefundResource.handleAPI(disApiInfo);
        System.assertEquals(1, stdResult.numberOfResults);
        
        VemoAPI.ResultResponse agreeResult = (VemoAPI.ResultResponse)VemoAPIDisbursementRefundResource.handleAPI(agreeApiInfo);
        Test.stopTest();
    }
    
    static testMethod void testHandlePostV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);

        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'testStudent_'+'abc');

        List<VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1> disResList = new List<VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1 disRes = new VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1(true);
            disRes.studentID = students.values().get(i).ID;
            disRes.agreementID = agreements.values().get(i).ID;
            disResList.add(disRes);
        }
        String body = JSON.serialize(disResList);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIDisbursementRefundResource.handleAPI(apiInfo);
        System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
        Test.stopTest();
    }
    
    static testMethod void validateHandlePutV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursementRefund = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRefundRecType);

        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'testStudent_'+'abc');

        List<VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1> disResList = new List<VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1>();
        VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1 disRes = new VemoAPIDisbursementRefundResource.DisbursementRefundResourceInputV1();
        disRes.disbursementRefundID = testDisbursementRefund.values().get(0).ID;
        disRes.amount = 5000;
        disResList.add(disRes);

        String body = JSON.serialize(disResList);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIDisbursementRefundResource.handleAPI(apiInfo);
        System.assertEquals(1, result.numberOfResults);
        Test.stopTest();
    }

    static testMethod void testHandleDeleteV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursementRefund = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRefundRecType);

        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'testStudent_'+'abc');
        params.put('disbursementRefundID', (String)testDisbursementRefund.values().get(0).Id);     
           
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIDisbursementRefundResource.handleAPI(apiInfo);
        System.assertEquals(1, result.numberOfResults);
        System.assertEquals((TestUtil.TEST_THROTTLE *TestUtil.TEST_THROTTLE) - 1, TransactionQueries.getTransactionMap(TransactionService.disbursementRefundRecType).size(), 'One Student should be deleted');
        Test.stopTest();
    }
}