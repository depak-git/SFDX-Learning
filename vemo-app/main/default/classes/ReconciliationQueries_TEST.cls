@isTest
public with sharing class ReconciliationQueries_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetReconciliationMapWithStudentID() {
        Map<ID, Reconciliation__c> testReconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, Account> testStudents = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);     
        for(Integer i=0; i<TestUtil.TEST_THROTTLE; i++){
            testReconciliationMap.values().get(i).student__c = testStudents.values().get(i).ID;
        }
        update testReconciliationMap.values();
        Test.startTest();
        Map<ID, Reconciliation__c> reconciliationMap = ReconciliationQueries.getReconciliationMapWithStudentID(testStudents.keySet());
        system.assertEquals(testReconciliationMap.size(), reconciliationMap.size());
        Test.stopTest();
    }
    @isTest public static void validateGetReconciliationMapWithReconciliationID() {
        Map<ID, Reconciliation__c> testReconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Test.startTest();
        Map<ID, Reconciliation__c> reconciliationMap = ReconciliationQueries.getReconciliationMapWithReconciliationID(testReconciliationMap.keySet());
        system.assertEquals(testReconciliationMap.size(), reconciliationMap.size());
        Test.stopTest();
    }

    @isTest public static void validateGetReconciliationDetailMapWithReconciliationID() {
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, ReconciliationDetail__c> testReconciliationDetailMap = TestDataFactory.createAndInsertReconciliationDetail(TestUtil.TEST_THROTTLE,reconciliationMap );     
        Test.startTest();
        Map<ID, ReconciliationDetail__c> reconciliationDetailMap = ReconciliationQueries.getReconciliationDetailMapWithReconciliationID(reconciliationMap.keyset());
        system.assertEquals(testReconciliationDetailMap.size(), reconciliationDetailMap.size());
        Test.stopTest();
    }
    
    @isTest public static void validateGetRDetailMapWithRDetailID() {
        Map<ID, Reconciliation__c> reconciliationMap = TestDataFactory.createAndInsertReconciliation(TestUtil.TEST_THROTTLE);
        Map<ID, ReconciliationDetail__c> testReconciliationDetailMap = TestDataFactory.createAndInsertReconciliationDetail(TestUtil.TEST_THROTTLE,reconciliationMap );     
        Test.startTest();
        Map<ID, ReconciliationDetail__c> reconciliationDetailMap = ReconciliationQueries.getRDetailMapWithRDetailID(testReconciliationDetailMap.keyset());
        system.assertEquals(testReconciliationDetailMap.size(), reconciliationDetailMap.size());
        Test.stopTest();
    }
}