@isTest
public with sharing class StewardshipACHBatchDtlTriggerHndlr_TEST {
	@TestSetup
	public static void testSetup(){
        TestUtil.createStandardTestConditions();
    }

	@isTest
	public static void testDML(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;
		StewardshipACHBatchDetail__c batchDtlToCreate = new StewardshipACHBatchDetail__c(StewardshipACHBatch__c = batchToCreate.id);
		insert batchDtlToCreate;
		update batchDtlToCreate;
		delete batchDtlToCreate;
		undelete batchDtlToCreate;
		
	}
}