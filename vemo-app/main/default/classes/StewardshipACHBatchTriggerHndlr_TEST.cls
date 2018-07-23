@isTest
public with sharing class StewardshipACHBatchTriggerHndlr_TEST {
	@TestSetup
	public static void testSetup(){
        TestUtil.createStandardTestConditions();
    }

	@isTest
	public static void testDML(){

		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;
		update batchToCreate;
		delete batchToCreate;
		undelete batchToCreate;
		
	}
}