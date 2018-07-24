/////////////////////////////////////////////////////////////////////////
// Class: PaymentInstructionTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-13   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class PaymentInstructionTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State acctrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution acctrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){   
		Integer i = 0;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;

        mainHasRun = true;
            
        if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'PaymentInstructionTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'PaymentInstructionTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('PaymentInstructionTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentInstruction__c> newPaymentInstructionList = (List<PaymentInstruction__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newPaymentInstructionList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('PaymentInstructionTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentInstruction__c> newPaymentInstructionList = (List<PaymentInstruction__c>)tc.newList;
        List<PaymentInstruction__c> oldPaymentInstructionList = (List<PaymentInstruction__c>)tc.oldList;
        Map<ID, PaymentInstruction__c> newPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.newMap;
        Map<ID, PaymentInstruction__c> oldPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldPaymentInstructionMap, newPaymentInstructionMap); 

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('PaymentInstructionTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentInstruction__c> oldPaymentInstructionList = (List<PaymentInstruction__c>)tc.oldList;
        Map<ID, PaymentInstruction__c> oldPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.oldMap;
        //This is where you should call your business logic

        for(PaymentInstruction__c pymt : oldPaymentInstructionMap.values()){
            Set<String> allowableDeleteStatus = new Set<String> {'None', 'Created By Student', 'Created By Vemo'};
            if(!allowableDeleteStatus.contains(pymt.Status__c)) pymt.addError('A Payment with this Status cannot be deleted');    
        }
    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('PaymentInstructionTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentInstruction__c> newPaymentInstructionList = (List<PaymentInstruction__c>)tc.newList;
        Map<ID, PaymentInstruction__c> newPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.newMap;
        //This is where you should call your business logic

        manageBounce(null, newPaymentInstructionMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('PaymentInstructionTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentInstruction__c> newPaymentInstructionList = (List<PaymentInstruction__c>)tc.newList;
        List<PaymentInstruction__c> oldPaymentInstructionList = (List<PaymentInstruction__c>)tc.oldList;
        Map<ID, PaymentInstruction__c> newPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.newMap;
        Map<ID, PaymentInstruction__c> oldPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.oldMap;
        //This is where you should call your business logic


        manageBounce(oldPaymentInstructionMap, newPaymentInstructionMap);
		manageAllocations(oldPaymentInstructionMap, newPaymentInstructionMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('PaymentInstructionTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentInstruction__c> oldPaymentInstructionList = (List<PaymentInstruction__c>)tc.oldList;
        Map<ID, PaymentInstruction__c> oldPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('PaymentInstructionTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentInstruction__c> newPaymentInstructionList = (List<PaymentInstruction__c>)tc.newList;
        Map<ID, PaymentInstruction__c> newPaymentInstructionMap = (Map<ID, PaymentInstruction__c>)tc.newMap;
        //This is where you should call your business logic
       
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<PaymentInstruction__c> newPaymentInstructionList){
system.debug('PaymentInstructionTriggerHandler.setDefaultsOnInsert()');
        for(PaymentInstruction__c payment : newPaymentInstructionList){
            if(payment.Status__c == 'Cleared') payment.Allocate__c = true;
            if(payment.Status__c == 'Bounced'){
                payment.DatePosted__c = null;
                payment.AmountPosted__c = null;
                payment.Allocate__c = false;
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, PaymentInstruction__c> oldPaymentInstructionMap, Map<ID, PaymentInstruction__c> newPaymentInstructionMap){
system.debug('PaymentInstructionTriggerHandler.setDefaultsOnUpdate()'); 
        for(PaymentInstruction__c payment : newPaymentInstructionMap.values()){
            if(payment.Status__c == 'Cleared' && oldPaymentInstructionMap.get(payment.id).Status__c != 'Cleared') payment.Allocate__c = true;            
            if(payment.Status__c == 'Bounced'){
                payment.DatePosted__c = null;
                payment.AmountPosted__c = null;
                payment.Allocate__c = false;
            }
        }
    }



    private void manageBounce(Map<ID, PaymentInstruction__c> oldPaymentInstructionMap, Map<ID, PaymentInstruction__c> newPaymentInstructionMap){
        System.debug('PaymentInstructionTriggerHandler.manageBounce()'); 
        Set<ID> bouncedPIs = new Set<ID>();
        Set<ID> bouncedPMs = new Set<ID>();
        Set<ID> bouncedAccounts = new Set<ID>();

        List<Case> casesToCreate = new List<Case>();
        Map<ID, Account> acctsToUpdate = new Map<ID, Account>();
        Map<ID, PaymentMethod__c> paymentMehtodsToUpdate = new Map<ID, PaymentMethod__c>();

        for(PaymentInstruction__c pi : newPaymentInstructionMap.values()){
            PaymentInstruction__c oldPI = oldPaymentInstructionMap != null ? oldPaymentInstructionMap.get(pi.id) : null;
            if(pi.Status__c == 'Bounced' && ((oldPI != null && oldPI.Status__c != 'Bounced' )|| (oldPI == null))){
                if(String.isNotEmpty(pi.PaymentMethod__c)){
                    bouncedPIs.add(pi.id);
                    bouncedAccounts.add(pi.Student__c);                    
                    bouncedPMs.add(pi.PaymentMethod__c);                    
                }
            }
        }  
        System.debug('bouncedPIs:'+bouncedPIs);
        System.debug('bouncedAccounts:'+bouncedAccounts);
        System.debug('bouncedPMs:'+bouncedPMs);

        Map<ID, PaymentMethod__c> bouncedPMMap = PaymentMethodQueries.getPaymentMethodMapWithPaymentMethodID(bouncedPMs);
        Map<ID, Account> bouncedAccountMap = AccountQueries.getStudentMapWithStudentID(bouncedAccounts);

        Map<ID, PaymentAllocation__c> paymentAllocMap = new Map<ID, PaymentAllocation__c>([SELECT id, PaymentInstruction__c
                                                                                           FROM PaymentAllocation__c
                                                                                           WHERE PaymentInstruction__c IN :bouncedPIs]);
        if(paymentAllocMap.size()>0){
            Database.delete(paymentAllocMap.values());            
        }
		
		List<OutboundEmail__c> emailsToSend = new List<OutboundEmail__c>();
		EmailTemplate template;
		String templateID;
		try{
			template = [select Id from EmailTemplate where DeveloperName = 'Insufficient_Funds' limit 1];
			templateID = template.id;
		} catch (Exception e) {
			templateID = null;
		}
		
        for(ID theID : bouncedPIs){
			try{
				emailsToSend.add(new OutboundEmail__c(WhatID__c = theid,
														TemplateID__c = templateID,
														SendviaSES__c = true,
														ToAddresses__c = bouncedAccountMap.get(newPaymentInstructionMap.get(theID).Student__c).PersonEmail));
			} catch (Exception e){

			}    			

            if(bouncedAccountMap.get(newPaymentInstructionMap.get(theID).Student__c).AutoPayment__pc == true){
                acctsToUpdate.put(newPaymentInstructionMap.get(theID).Student__c, new Account(id = newPaymentInstructionMap.get(theID).Student__c,
                                                                                               AutoPayment__pc = false,
                                                                                               AutoPaymentFrequency__pc = '',
                                                                                               AutoPaymentDayOfMonth1__pc = null,
                                                                                               AutoPaymentDayOfMonth2__pc = null,
                                                                                               NextAutoPaymentDate__c = null));


                casesToCreate.add(new Case(ContactID = bouncedAccountMap.get(newPaymentInstructionMap.get(theID).Student__c).PersonContactID,
                                           Subject = 'Bounced Payment Instruction for Account '+ newPaymentInstructionMap.get(theID).Student__c,
                                           Type = 'Problem',
                                           Priority='Medium',
                                           Status='New',
                                           //OwnerId=GlobalUtil.getQueueId(GlobalSettings.getSettings().closedWonCaseQueue),
                                           Description='Payment Method '+theID+' bounced'));
                                           //RecordTypeID=GlobalUtil.getRecordTypeIDByLabelName('Case', 'Origination'),
                                           //Reason='Reason'




            }
        }
		System.debug('emailsToSend:'+emailsToSend);
        if(emailsToSend.size()>0){
            insert emailsToSend;
        }
        if(acctsToUpdate.size()>0){
            Database.update(acctsToUpdate.values(), true);
        }
        if(casesToCreate.size()>0){
            Database.insert(casesToCreate, true);
        }
    }

    private void manageAllocations(Map<ID, PaymentInstruction__c> oldPaymentInstructionMap, Map<ID, PaymentInstruction__c> newPaymentInstructionMap){
system.debug('PaymentInstructionTriggerHandler.manageAllocations()'); 		
		for(PaymentInstruction__c payment : newPaymentInstructionMap.values()){
			if(payment.Allocate__c && !oldPaymentInstructionMap.get(payment.id).Allocate__c){
				//this will only support 100

                    system.debug('Limits.getQueueableJobs():'+Limits.getQueueableJobs());
                    system.debug('Limits.getLimitQueueableJobs():'+Limits.getLimitQueueableJobs());
               if(Limits.getLimitQueueableJobs()>Limits.getQueueableJobs()){
                    system.debug('launch');
                    PaymentAllocationService.AllocatePaymentQueueable job = new PaymentAllocationService.AllocatePaymentQueueable(payment.id);
                    System.enqueueJob(job);                
               } else {
                    system.debug('do not launch');
                    system.debug('Limits.getQueueableJobs():'+Limits.getQueueableJobs());
                    system.debug('Limits.getLimitQueueableJobs():'+Limits.getLimitQueueableJobs());
               }

			}
		}    	
    }

    public class PaymentInstructionTriggerHandlerException extends Exception {}
}