@isTest
public class ReconciliationService_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    @isTest public static void validateGetReconciliationMapWithStudentID(){
        Map<ID, Reconciliation__c> testReconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, Account> testStudents = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);     
        for(Integer i=0; i<TestUtil.TEST_THROTTLE; i++){
            testReconciliationMap.values().get(i).student__c = testStudents.values().get(i).ID;
        }
        update testReconciliationMap.values();
        Test.startTest();
        List<ReconciliationService.Reconciliation> reconciliations = ReconciliationService.getReconciliationMapWithStudentID(testStudents.keySet());
        System.assertEquals(testReconciliationMap.size(), reconciliations.size());
        Test.stopTest();
    }
    
    @isTest public static void validateGetReconciliationDetailMapWithReconciliationID(){
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, ReconciliationDetail__c> testReconciliationDetailMap = TestDataFactory.createAndInsertReconciliationDetail(TestUtil.TEST_THROTTLE,reconciliationMap );  
        Test.startTest();
        List<ReconciliationService.ReconciliationDetail> reconciliationDetails = ReconciliationService.getReconciliationDetailMapWithReconciliationID(reconciliationMap.keySet());
        System.assertEquals(testReconciliationDetailMap.size(), reconciliationDetails.size());
        Test.stopTest();
    }
    
    @isTest public static void validateGetRDetailMapWithRDetailID(){
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, ReconciliationDetail__c> testReconciliationDetailMap = TestDataFactory.createAndInsertReconciliationDetail(TestUtil.TEST_THROTTLE,reconciliationMap );  
        Test.startTest();
        List<ReconciliationService.ReconciliationDetail> reconciliationDetails = ReconciliationService.getRDetailMapWithRDetailID(testReconciliationDetailMap.keySet());
        System.assertEquals(testReconciliationDetailMap.size(), reconciliationDetails.size());
        Test.stopTest();
    }
    
    @isTest public static void validateCreateRDetails(){
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        List<ReconciliationService.ReconciliationDetail> reconciliationDetails = new List<ReconciliationService.ReconciliationDetail>();
        
        for(Reconciliation__c rc : reconciliationMap.values()){
            for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
                ReconciliationService.ReconciliationDetail rd = new ReconciliationService.ReconciliationDetail(true);
                rd.reconciliationID = rc.id;
                reconciliationDetails.add(rd);
            }
        }
        Test.startTest();
        Set<ID> rDetailIDs = ReconciliationService.createRDetails(reconciliationDetails);
        Test.stopTest();
    }
    
    @isTest public static void validateUpdateRDetails(){
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        List<ReconciliationService.ReconciliationDetail> reconciliationDetails = new List<ReconciliationService.ReconciliationDetail>();
        
        for(Reconciliation__c rc : reconciliationMap.values()){
            for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
                ReconciliationService.ReconciliationDetail rd = new ReconciliationService.ReconciliationDetail(true);
                rd.reconciliationID = rc.id;
                reconciliationDetails.add(rd);
            }
        }
        Set<ID> rDetailIDs = ReconciliationService.createRDetails(reconciliationDetails);
        Map<ID, ReconciliationDetail__c> reconciliationDetailMap = ReconciliationQueries.getRDetailMapWithRDetailID(rDetailIDs );
        List<ReconciliationService.ReconciliationDetail> updateReconciliations = ReconciliationService.getRDetailMapWithRDetailID(rDetailIDs);
        for(ReconciliationService.ReconciliationDetail rd : updateReconciliations){
            rd.employerStartDate = date.today().adddays(1);
        }
        Test.startTest();
        Set<ID> updatedIDs = ReconciliationService.updateRDetails(updateReconciliations);
        Test.stopTest();
    }
    
    @isTest public static void validateDeleteRDetails(){
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        List<ReconciliationService.ReconciliationDetail> reconciliationDetails = new List<ReconciliationService.ReconciliationDetail>();
        
        for(Reconciliation__c rc : reconciliationMap.values()){
            for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
                ReconciliationService.ReconciliationDetail rd = new ReconciliationService.ReconciliationDetail(true);
                rd.reconciliationID = rc.id;
                reconciliationDetails.add(rd);
            }
        }
        Set<ID> rDetailIDs = ReconciliationService.createRDetails(reconciliationDetails);
        Test.startTest();
        Integer deletedNum = ReconciliationService.deleteRDetails(rDetailIDs);
        Test.stopTest();
        System.assertEquals(deletedNum, rDetailIDs.size());
    }
}