public with sharing class PaymentAllocationBatch implements Database.Batchable<sObject> {
	
	String query = 'SELECT id from PaymentInstruction__c where FullyAllocated__c = false';
	Boolean proofMode = true;
	
	public PaymentAllocationBatch() {
		
	}

	public PaymentAllocationBatch(String query, Boolean proofMode){
		this.query = query;
		this.proofMode = proofMode;
	}

	public Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('PaymentAllocationBatch.start()');
		System.debug('query:'+query);
		System.debug('proofMode:'+proofMode);
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('PaymentAllocationBatch.execute()');
		List<PaymentInstruction__c> payments = (List<PaymentInstruction__c>) scope;
		for(PaymentInstruction__c payment : payments){
			PaymentAllocationService.allocatePaymentV2(payment.id, proofMode);
			return; //can only handle 1 allocation at a time
		}
	}
	
	public void finish(Database.BatchableContext BC) {
		System.debug('PaymentAllocationBatch.finish()');		
	}
	
}