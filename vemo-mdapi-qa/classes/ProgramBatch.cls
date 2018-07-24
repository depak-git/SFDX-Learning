public class ProgramBatch implements Database.Batchable<sObject>, Database.ALlowsCallouts {
	public enum JobType {DISB_CONF_NOTIFICATION} 
	
	public String query {get;set;}
	public JobType job {get;set;}
	
	public ProgramBatch() {
		job = JobType.DISB_CONF_NOTIFICATION;
	}
	public ProgramBatch(String query) {
		this.query = query;
		job = JobType.DISB_CONF_NOTIFICATION;
	}	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('ProgramBatch.start()');
		if(job == JobType.DISB_CONF_NOTIFICATION){
			if(String.isEmpty(this.query)){
				String dateToday = String.valueOf(Date.today());
				query = 'SELECT id from Program__c where DisbursementConfRequiredNotification__c = true and AutomaticallyConfirmTransactions__c = false';
				//query = 'SELECT id, Date__c, Amount__c, Status__c from PaymentInstruction__c WHERE Status__c = \'None\' and Date__c <='+dateToday + ' ORDER BY Date__c ASC';
			}
		}
		System.debug('job:'+job);
		System.debug('query:'+query);
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('ProgramBatch.execute()');
		Set<ID> scopeIDs = new Set<ID>();
		for(sObject sobj : scope){
			scopeIDs.add(sobj.id);
		}

		if(job == JobType.DISB_CONF_NOTIFICATION){
			Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(scopeIDs);
			//Look for any disbursements waiting for confirmation
			Map<ID, Transaction__c> disbursementMap = new Map<ID, Transaction__c>([SELECT id,
																						  Agreement__c,
																						  Agreement__r.Program__c,
																						  Agreement__r.Student__c,
																						  Agreement__r.Student__r.PersonContactID,
																						  Agreement__r.Status__c
																				   FROM Transaction__c
																				   WHERE Agreement__r.Program__c = :programMap.keySet()
																				    and TransactionDate__c <= :Date.today()
																				    and (Status__c = 'Scheduled'
																				    	or (Status__c = 'Complete' and Confirmed__c = false))]);
			Map<ID, List<Transaction__c>> validDisbursementsByProgramID = new Map<ID, List<Transaction__c>>();
			for(Transaction__c tx : disbursementMap.values()){
				Set<String> validStatus = new Set<String>{'Certified', 'Partially Funded'};
				if(validStatus.contains(tx.Agreement__r.Status__c)){
					if(!validDisbursementsByProgramID.containsKey(tx.Agreement__r.Program__c)){
						validDisbursementsByProgramID.put(tx.Agreement__r.Program__c, new List<Transaction__c>());
					}
					validDisbursementsByProgramID.get(tx.Agreement__r.Program__c).add(tx);					
				}
			}
			System.debug('validDisbursementsByProgramID:'+validDisbursementsByProgramID);
			List<OutboundEmailService.OutboundEmail> outboundEmails = new List<OutboundEmailService.OutboundEmail>();
			for(ID theID : validDisbursementsByProgramID.keySet()){
				OutboundEmailService.OutboundEmail email = new OutboundEmailService.OutboundEmail();

                email.toAddresses = programMap.get(theID).SchoolEmailNotification2__c;
                //email.templateID = '00X7A000000EJ98';
                email.templateDevName = 'AllSchoolsAwaitingDisbursementConfirmation';
                email.whatID = theID;//validDisbursementsByProgramID.get(theID)[0].id;
                email.targetObjectId = validDisbursementsByProgramID.get(theID)[0].Agreement__r.Student__r.PersonContactID;
                email.sendImmediate = true;

				outboundEmails.add(email);


			}
			OutboundEmailService.createOutboundEmailV1(outboundEmails);			
		}
	}
	
	public void finish(Database.BatchableContext BC) {
		System.debug('ProgramBatch.finish()');		
	}
}