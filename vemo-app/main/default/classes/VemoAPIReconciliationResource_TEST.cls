@isTest
public class VemoAPIReconciliationResource_TEST {
  @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    static testMethod void testHandleGetV1(){
        Map<ID, Reconciliation__c> testReconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, Account> testStudents = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);     
        for(Integer i=0; i<TestUtil.TEST_THROTTLE; i++){
            testReconciliationMap.values().get(i).student__c = testStudents.values().get(i).ID;
        }
        update testReconciliationMap.values();

        Map<String, String> reconciliationParams = new Map<String, String>();
        reconciliationParams.put('studentID', (String)testStudents.values().get(0).Id);
        reconciliationParams.put('VEMO_AUTH', 'ABC');
        VemoAPI.APIInfo reconciliationApiInfo = TestUtil.initializeAPI('v1', 'GET', reconciliationParams, null);


        Test.startTest();
        VemoAPI.ResultResponse reconciliationResult = (VemoAPI.ResultResponse)VemoAPIReconciliationResource.handleAPI(reconciliationApiInfo);
        System.assertEquals(1, reconciliationResult.numberOfResults);
        Test.stopTest();
    }
    
    static testMethod void testHandlePostV1(){
        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'ABC');
        
        Map<ID, Reconciliation__c> testReconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        List<VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1> rDetailResList = new List<VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1>();
        
        for(Reconciliation__c rc : testReconciliationMap.values()){
            for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
                VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1 rDetailRes = new VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1(true);
                rDetailRes.reconciliationID = rc.id;
                rDetailResList.add(rDetailRes);
            }
        } 

        String body = JSON.serialize(rDetailResList);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIReconciliationResource.handleAPI(apiInfo);
        Test.stopTest();
    }
    
    static testMethod void testHandlePutV1(){
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, ReconciliationDetail__c> testReconciliationDetailMap = TestDataFactory.createAndInsertReconciliationDetail(TestUtil.TEST_THROTTLE,reconciliationMap ); 
        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'ABC');

        List<VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1> rDetailResList = new List<VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1>();
        VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1 rDetailRes = new VemoAPIReconciliationResource.VemoReconciliationDetailResourceInputV1(true);
        rDetailRes.reconciliationDetailID = testReconciliationDetailMap.values().get(0).ID;
        rDetailResList.add(rDetailRes);

        String body = JSON.serialize(rDetailResList);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIReconciliationResource.handleAPI(apiInfo);
        //System.assertEquals(1, result.numberOfResults);
        Test.stopTest();
    }
    
    static testMethod void testHandleDeleteV1(){
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, ReconciliationDetail__c> testReconciliationDetailMap = TestDataFactory.createAndInsertReconciliationDetail(TestUtil.TEST_THROTTLE,reconciliationMap ); 

        Map<String, String> params = new Map<String, String>();
        params.put('VEMO_AUTH', 'testStudent_'+'abc');
        params.put('reconciliationDetailID', testReconciliationDetailMap.values().get(0).ID);

        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIReconciliationResource.handleAPI(apiInfo);
        System.assertEquals(1, result.numberOfResults);
        Test.stopTest();
    }

}