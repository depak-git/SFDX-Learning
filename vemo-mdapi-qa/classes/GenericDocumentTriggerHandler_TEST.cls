@isTest
public with sharing class GenericDocumentTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    @isTest private static void testDML(){
    	Map<ID, GenericDocument__c> docMap = TestDataFactory.createAndInsertGenericDocument(10);
    	update docMap.values();
    	delete docMap.values();
    	undelete docMap.values();
    }
}