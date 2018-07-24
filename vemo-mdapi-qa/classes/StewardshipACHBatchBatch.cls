public with sharing class StewardshipACHBatchBatch implements Database.Batchable<sObject>, Database.ALlowsCallouts{
	public enum JobType {QUERY_APPROVED_OPEN} 
	
	public String query {get;set;}
	public JobType job {get;set;}
	
	public StewardshipACHBatchBatch() {
		job = JobType.QUERY_APPROVED_OPEN;
	}
	public StewardshipACHBatchBatch(String query) {
		this.query = query;
		job = JobType.QUERY_APPROVED_OPEN;
	}	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('StewardshipACHBatchBatch.start()');
		if(job == JobType.QUERY_APPROVED_OPEN){
			if(String.isEmpty(this.query)){
				String dateWindow = String.valueOf(Date.today().addDays(-7));
				query = 'SELECT id from StewardshipACHBatch__c WHERE Status__c = \'Approved\'' + ' and (OpenBatchDetails__c > 0 or ScheduledDate__c > '+dateWindow+')';
			}
		} 
		System.debug('job:'+job);
		System.debug('query:'+query);
		LogService.writeLogs();
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('StewardshipACHBatchBatch.execute()');
		Set<ID> scopeIDs = new Set<ID>();
		for(sObject sobj : scope){
			scopeIDs.add(sobj.id);
		}

		if(job == JobType.QUERY_APPROVED_OPEN){
			Map<ID, StewardshipACHBatch__c> batchMap = new Map<ID, StewardshipACHBatch__c>([SELECT id,
																								   BankAccount__c,
																								   BatchGUID__c,
																								   BatchSelectResponse__c,
																								   BatchType__c,
																								   LastSelectedDateTime__c,
																								   OpenBatchDetails__c,
																								   ScheduledDate__c,
																								   Status__c,
																								   StewardshipProcess__c,
																								   StewardshipStatus__c
																	FROM StewardshipACHBatch__c
																	WHERE id = :scopeIDs
																	FOR UPDATE]);
			System.debug('batchMap:'+batchMap);
			queryApprovedOpen(batchMap);
			LogService.writeLogs();
		}
		
		LogService.writeLogs();	
	}
	
	public void finish(Database.BatchableContext BC) {
		System.debug('StewardshipACHBatchBatch.finish()');		
		LogService.writeLogs();
	}
	
	private static void queryApprovedOpen(Map<ID, StewardshipACHBatch__c> batchMap){
		System.debug('StewardshipACHBatchBatch.queryApprovedOpen()');
		for(StewardshipACHBatch__c batchRecord : batchMap.values()){
			batchRecord.StewardshipProcess__c = '';
		}
		update batchMap.values();
		for(StewardshipACHBatch__c batchRecord : batchMap.values()){
			batchRecord.StewardshipProcess__c = 'PaymentBatchSelect';
		}
		update batchMap.values();
		LogService.writeLogs();
	}
}