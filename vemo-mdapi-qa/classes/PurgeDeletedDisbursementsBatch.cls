public with sharing class PurgeDeletedDisbursementsBatch implements Database.Batchable<sObject> {
        
    String query = 'SELECT id from Transaction__c where Deleted__c = true';

    public PurgeDeletedDisbursementsBatch() {
        
    }

    public PurgeDeletedDisbursementsBatch(String query){
    	if(String.isNotEmpty(query)) this.query = query;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('PurgeDeletedDisbursementsBatch.start()');
        System.debug('query:'+query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('PurgeDeletedDisbursementsBatch.execute()');
        delete scope;
    }
    
    public void finish(Database.BatchableContext BC) {
        System.debug('PurgeDeletedDisbursementsBatch.finish()');        
    }
    
}