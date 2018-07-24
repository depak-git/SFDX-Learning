@isTest
public with sharing class OutboundEmailTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
	@isTest
	public static void validateDML(){
		TestUtil.setStandardConfiguration();
		List<OutboundEmail__c> emails = new List<OutboundEmail__c>();
		emails.add(new OutboundEmail__c());
		insert emails;
		update emails;
		delete emails;
		undelete emails;	
	}
}