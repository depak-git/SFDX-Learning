global class GenerateFinalDisclosureBatch implements Database.Batchable<sObject> {
	
	String query;
	
	global GenerateFinalDisclosureBatch() {
		query = 'SELECT id, CongaFinalDisclosureStatus__c, FinalDisclosureID__c, CongaFinalDisclosureID__c from StudentProgram__c where GenerateFinalDisclosure__c = true';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('GenerateFinalDisclosureBatch.start()');
		System.debug('session:'+UserInfo.getSessionId());
        System.debug('query:'+query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('GenerateFinalDisclosureBatch.execute()');
		System.debug('session:'+UserInfo.getSessionId());
        system.debug('scope before:'+scope);
		for(StudentProgram__c agreement : (List<StudentProgram__c>) scope){
			agreement.CongaFinalDisclosureStatus__c = 'Generate';
			agreement.FinalDisclosureID__c = '';
			agreement.CongaFinalDisclosureID__c = '';
		}
        system.debug('scope after:'+scope);
		Database.update(scope, false);
	}
	
	global void finish(Database.BatchableContext BC) {
		System.debug('GenerateFinalDisclosureBatch.finish()');
	}
	
}