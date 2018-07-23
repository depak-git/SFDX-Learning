@isTest
public with sharing class RefundTriggerHandler_TEST {
	@isTest
	public static void testDML() {
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(1);		
		List<Refund__c> refundsToAdd = new List<Refund__c>();
		refundsToAdd.add(new Refund__c(Account__c = students.values()[0].id));
		insert refundsToAdd;
		update refundsToAdd;
		delete refundsToAdd;
		undelete refundsToAdd;
		
	}
}