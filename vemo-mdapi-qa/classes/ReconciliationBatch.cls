public with sharing class ReconciliationBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
	public enum JobType {CREATE_AGREEMENTS, CREATE_ESIGN, RETRIEVE_SIGNED_AGREEMENTS, SEND_KICK_OFF, SEND_CONFIRMATION} 
	
	public String query {get;set;}
	public JobType job {get;set;}
	
	public ReconciliationBatch() {
		job = JobType.CREATE_AGREEMENTS;
	}
	public ReconciliationBatch(String query) {
		this.query = query;
		job = JobType.CREATE_AGREEMENTS;
	}	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('ReconciliationBatch.start()');
		if(job == JobType.CREATE_AGREEMENTS){
			if(String.isEmpty(this.query)){
				query = 'SELECT id from Reconciliation__c WHERE Status__c =  \'Eligible\' and AdobeSignStatus__c = \'None\'';
			}
		} else if (job == JobType.CREATE_ESIGN){
			if(String.isEmpty(this.query)){
				query = 'SELECT id from Reconciliation__c WHERE Status__c =  \'Eligible\' and AdobeSignStatus__c = \'Document Uploaded to Adobe\'';
			}
		} else if (job == JobType.RETRIEVE_SIGNED_AGREEMENTS){
			if(String.isEmpty(this.query)){
				query = 'SELECT id from Reconciliation__c WHERE AgreementSigned__c = true and AdobeSignStatus__c = \'Document Awaiting Signature\'';
			}
		} else if (job == JobType.SEND_KICK_OFF){
			if(String.isEmpty(this.query)){
				query = 'SELECT id from Reconciliation__c WHERE SendKickOffEmail__c = false and AdobeSignStatus__c = \'Document Awaiting Signature\'';
			}
		} else if (job == JobType.SEND_CONFIRMATION){
			if(String.isEmpty(this.query)){
				query = 'SELECT id from Reconciliation__c WHERE SendSubmissionConfirmation__c = false and Status__c = \'Documents Submitted\'';
			}
		}
		System.debug('job:'+job);
		System.debug('query:'+query);
		LogService.writeLogs();
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('ReconciliationBatch.execute()');
		Set<ID> scopeIDs = new Set<ID>();
		for(sObject sobj : scope){
			scopeIDs.add(sobj.id);
		}

        Map<ID, Reconciliation__c> reconMap = new Map<ID, Reconciliation__c>([SELECT id, Email__c, Status__c
                                                                              FROM Reconciliation__c
                                                                              where id = :scopeIDs]);
        
        List<Reconciliation__c> reconsToUpdate = new List<Reconciliation__c>();
		List<OutboundEmail__c> emailsToSend = new List<OutboundEmail__c>();
		if(job == JobType.CREATE_AGREEMENTS){
            for(Reconciliation__c recon : reconMap.values()){
                try{
                    ReconciliationService.generateESignDocument(recon.id);                    
                } catch (Exception e){

                }                
            }
        } else if(job == JobType.CREATE_ESIGN){  
            for(Reconciliation__c recon : reconMap.values()){
                try{
                    ReconciliationService.getEsignUrl(recon.id);         
                } catch (Exception e){

                }                
            }
        } else if(job == JobType.RETRIEVE_SIGNED_AGREEMENTS){  
            for(Reconciliation__c recon : reconMap.values()){
                try{
                    ReconciliationService.getSignedDocument(recon.id);
                    reconsToUpdate.add(new Reconciliation__c (id = recon.id,
                                                              AdobeSignStatus__c = 'Signed Document Attached'));
                } catch (Exception e){

                }                
            }
        } else if(job == JobType.SEND_KICK_OFF){
			EmailTemplate template = [select Id from EmailTemplate where DeveloperName = 'Recon_Kick_Off' limit 1];
            for(Reconciliation__c recon : reconMap.values()){
                try{
					emailsToSend.add(new OutboundEmail__c(WhatID__c = recon.id,
														  TemplateID__c = template.id,
														  SendviaSES__c = true,
														  ToAddresses__c = recon.Email__c));
                    reconsToUpdate.add(new Reconciliation__c(id = recon.id,
															 Status__c = 'Not Started',
															 SendKickOffEmail__c = true));
                } catch (Exception e){

                }                
            }
        } else if(job == JobType.SEND_CONFIRMATION){
			EmailTemplate template = [select Id from EmailTemplate where DeveloperName = 'Recon_Submission_Confirmation'];			
            for(Reconciliation__c recon : reconMap.values()){
                try{
					emailsToSend.add(new OutboundEmail__c(WhatID__c = recon.id,
														  TemplateID__c = template.id,
														  SendviaSES__c = true,
														  ToAddresses__c = recon.Email__c));
                    reconsToUpdate.add(new Reconciliation__c(id = recon.id,
															 SendSubmissionConfirmation__c = true));
                } catch (Exception e){

                }                
            }
        }   
        if(emailsToSend.size()>0){
            insert emailsToSend;
        }
        if(reconsToUpdate.size()>0){
            update reconsToUpdate;
        }
		
		LogService.writeLogs();	
	}
	
	public void finish(Database.BatchableContext BC) {
		System.debug('ReconciliationBatch.finish()');
		if(job == JobType.CREATE_AGREEMENTS){  
            ReconciliationBatch job = new ReconciliationBatch();
            job.Job = ReconciliationBatch.JobType.CREATE_ESIGN;
            Database.executeBatch(job, 1);
        } else if(job == JobType.CREATE_ESIGN){  
            ReconciliationBatch job = new ReconciliationBatch();
            job.Job = ReconciliationBatch.JobType.RETRIEVE_SIGNED_AGREEMENTS;
            Database.executeBatch(job, 1);
        } else if(job == JobType.RETRIEVE_SIGNED_AGREEMENTS){  
            ReconciliationBatch job = new ReconciliationBatch();
            job.Job = ReconciliationBatch.JobType.SEND_KICK_OFF;
            Database.executeBatch(job, 200);
        } else if(job == JobType.SEND_KICK_OFF){  
            ReconciliationBatch job = new ReconciliationBatch();
            job.Job = ReconciliationBatch.JobType.SEND_CONFIRMATION;
            Database.executeBatch(job, 200);
        } else if(job == JobType.SEND_CONFIRMATION){  
			OutboundEmailBatch job = new OutboundEmailBatch();
			Database.executeBatch(job, 1);
        }         
		LogService.writeLogs();
	}


	public class StudentAccountBatchException extends Exception {}
}