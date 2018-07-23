/////////////////////////////////////////////////////////////////////////
// Class: StewardshipACHBatchTriggerHndlr
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class StewardshipACHBatchTriggerHndlr implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State batchDetailrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
//    public static Boolean manageCasesHasRun = false;
//    public static Boolean manageStewardshipACHBatchSharesHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution batchDetailrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StewardshipACHBatchTriggerHndlr' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'StewardshipACHBatchTriggerHndlr'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchTriggerHndlr.onBeforeInsert()');
       //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatch__c> newStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newStewardshipACHBatchList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchTriggerHndlr.onBeforeUpdate()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatch__c> newStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.newList;
        List<StewardshipACHBatch__c> oldStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.oldList;
        Map<ID, StewardshipACHBatch__c> newStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.newMap;
        Map<ID, StewardshipACHBatch__c> oldStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldStewardshipACHBatchMap, newStewardshipACHBatchMap);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchTriggerHndlr.onBeforeDelete()');
       //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatch__c> oldStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.oldList;
        Map<ID, StewardshipACHBatch__c> oldStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchTriggerHndlr.onAfterInsert()');
         //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatch__c> newStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.newList;
        Map<ID, StewardshipACHBatch__c> newStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.newMap;
        //This is where you should call your business logic

        manageStewardship(null, newStewardshipACHBatchMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchTriggerHndlr.onAfterUpdate()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatch__c> newStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.newList;
        List<StewardshipACHBatch__c> oldStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.oldList;
        Map<ID, StewardshipACHBatch__c> newStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.newMap;
        Map<ID, StewardshipACHBatch__c> oldStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.oldMap;
        //This is where you should call your business logic

        manageBatchDetails(oldStewardshipACHBatchMap, newStewardshipACHBatchMap);
        manageStewardship(oldStewardshipACHBatchMap, newStewardshipACHBatchMap);

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchTriggerHndlr.onAfterDelete()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatch__c> oldStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.oldList;
        Map<ID, StewardshipACHBatch__c> oldStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchTriggerHndlr.onAfterUndelete()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatch__c> newStewardshipACHBatchList = (List<StewardshipACHBatch__c>)tc.newList;
        Map<ID, StewardshipACHBatch__c> newStewardshipACHBatchMap = (Map<ID, StewardshipACHBatch__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<StewardshipACHBatch__c> newStewardshipACHBatchList){
system.debug('StewardshipACHBatchTriggerHndlr.setDefaultsOnInsert()');

        for(StewardshipACHBatch__c btch : newStewardshipACHBatchList){
            if(btch.Status__c == 'Approved') btch.StewardshipProcess__c = 'PaymentBatchApprove';
            if(btch.Status__c == 'Cancelled') btch.StewardshipProcess__c = 'PaymentBatchCancel';
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, StewardshipACHBatch__c> oldStewardshipACHBatchMap, Map<ID, StewardshipACHBatch__c> newStewardshipACHBatchMap){
system.debug('StewardshipACHBatchTriggerHndlr.setDefaultsOnUpdate()'); 
        for(StewardshipACHBatch__c btch : newStewardshipACHBatchMap.values()){
            if(btch.Status__c == 'Approved' && oldStewardshipACHBatchMap.get(btch.id).Status__c != 'Approved') btch.StewardshipProcess__c = 'PaymentBatchApprove';
            if(btch.Status__c == 'Cancelled' && oldStewardshipACHBatchMap.get(btch.id).Status__c != 'Cancelled') btch.StewardshipProcess__c = 'PaymentBatchCancel';
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageStewardship
    /////////////////////////////////////////////////////////////////////////
    private void manageBatchDetails(Map<ID, StewardshipACHBatch__c> oldStewardshipACHBatchMap, Map<ID, StewardshipACHBatch__c> newStewardshipACHBatchMap){
system.debug('StewardshipACHBatchTriggerHndlr.manageBatchDetails()'); 
        Set<ID> cancelledBatchIDs = new Set<ID>();
        Set<ID> qcdBatchIDs = new Set<ID>();
        Set<ID> batchIDsToApprove = new Set<ID>();
        Set<ID> batchIDsToCancel = new Set<ID>();
        Set<ID> approvedBatchIDs = new Set<ID>();
        Set<ID> batchIDs = new Set<ID>();
        for(StewardshipACHBatch__c btch : newStewardshipACHBatchMap.values()){
            if(btch.Status__c == 'Cancelled' && oldStewardshipACHBatchMap.get(btch.id).Status__c != 'Cancelled'){
                batchIDsToCancel.add(btch.id);
                batchIDs.add(btch.id);
            }
            if(btch.Status__c == 'Approved' && oldStewardshipACHBatchMap.get(btch.id).Status__c != 'Approved'){
                batchIDsToApprove.add(btch.id);
                batchIDs.add(btch.id);
            }
            if(btch.Status__c == 'QC\'d' && oldStewardshipACHBatchMap.get(btch.id).Status__c != 'QC\'d'){
                qcdBatchIDs.add(btch.id);
                batchIDs.add(btch.id);
            }
            if(btch.StewardshipStatus__c == 'Approved' && oldStewardshipACHBatchMap.get(btch.id).StewardshipStatus__c != 'Approved'){
                approvedBatchIDs.add(btch.id);
                batchIDs.add(btch.id);
            }
            if(btch.StewardshipStatus__c == 'Cancelled' && oldStewardshipACHBatchMap.get(btch.id).StewardshipStatus__c != 'Cancelled'){
                cancelledBatchIDs.add(btch.id);
                batchIDs.add(btch.id);
            }
        }
        for(List<StewardshipACHBatchDetail__c> details : [SELECT id, Status__c, StewardshipACHBatch__c
                                                          FROM StewardshipACHBatchDetail__c
                                                          WHERE StewardshipACHBatch__c IN :batchIDs]){
            for(StewardshipACHBatchDetail__c batchDetail : details){
                if(batchIDsToCancel.contains(batchDetail.StewardshipACHBatch__c)){
                    batchDetail.Status__c = 'Transmitting';                    
                }
                if(batchIDsToApprove.contains(batchDetail.StewardshipACHBatch__c)){
                    batchDetail.Status__c = 'Transmitting';                    
                }
                if(qcdBatchIDs.contains(batchDetail.StewardshipACHBatch__c)){
                    batchDetail.Status__c = 'QC\'d';                    
                }
                if(approvedBatchIDs.contains(batchDetail.StewardshipACHBatch__c)){
                    batchDetail.Status__c = 'Approved';                    
                }
                if(cancelledBatchIDs.contains(batchDetail.StewardshipACHBatch__c)){
                    batchDetail.Status__c = 'Batch Cancelled';                     
                }
            }
            update details;
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageStewardship
    /////////////////////////////////////////////////////////////////////////
    private void manageStewardship(Map<ID, StewardshipACHBatch__c> oldStewardshipACHBatchMap, Map<ID, StewardshipACHBatch__c> newStewardshipACHBatchMap){
system.debug('StewardshipACHBatchTriggerHndlr.manageStewardship()'); 
        Set<Id> paymentBatchesToOpen = new Set<Id>();
        Set<Id> batchesToCancel = new Set<Id>();
        Set<Id> batchesToApprove = new Set<Id>();
        Set<Id> batchesToSelect = new Set<Id>();
        Set<Id> creditBatchesToOpen = new Set<Id>();

        for(StewardshipACHBatch__c btch : newStewardshipACHBatchMap.values()){

            if((oldStewardshipACHBatchMap == null && btch.StewardshipProcess__c == 'PaymentBatchOpen') ||
               (btch.StewardshipProcess__c == 'PaymentBatchOpen' && btch.StewardshipProcess__c != oldStewardshipACHBatchMap.get(btch.id).StewardshipProcess__c)){
                paymentBatchesToOpen.add(btch.Id);
            }
            if((oldStewardshipACHBatchMap == null && btch.StewardshipProcess__c == 'PaymentBatchCancel') ||
               (btch.StewardshipProcess__c == 'PaymentBatchCancel' && btch.StewardshipProcess__c != oldStewardshipACHBatchMap.get(btch.id).StewardshipProcess__c)){
                batchesToCancel.add(btch.Id);
            }
            if((oldStewardshipACHBatchMap == null && btch.StewardshipProcess__c == 'PaymentBatchApprove') ||
               (btch.StewardshipProcess__c == 'PaymentBatchApprove' && btch.StewardshipProcess__c != oldStewardshipACHBatchMap.get(btch.id).StewardshipProcess__c)){
                if(btch.ApprovalPassword__c != 'approve'){
                    btch.addError('Approval Password Not Supplied or Incorrect');
                } else {
                    batchesToApprove.add(btch.Id);                    
                }

            }
            if((oldStewardshipACHBatchMap == null && btch.StewardshipProcess__c == 'PaymentBatchSelect') ||
               (btch.StewardshipProcess__c == 'PaymentBatchSelect' && btch.StewardshipProcess__c != oldStewardshipACHBatchMap.get(btch.id).StewardshipProcess__c)){
                batchesToSelect.add(btch.Id);
            }                


            if((oldStewardshipACHBatchMap == null && btch.StewardshipProcess__c == 'CreditBatchOpen') ||
               (btch.StewardshipProcess__c == 'CreditBatchOpen' && btch.StewardshipProcess__c != oldStewardshipACHBatchMap.get(btch.id).StewardshipProcess__c)){
                if(btch.ScheduledDate__c == null){
                    btch.addError('A Scheduled Date is required for Credit Batches');
                }
                if(btch.BatchType__c != 'Credit (Outgoing Money)'){
                    btch.addError('Not a Credit Batch');
                }
                creditBatchesToOpen.add(btch.Id);
            }
 


        }


        for(ID theID : paymentBatchesToOpen){

            
            StewardshipTechService.PaymentBatchOpenQueueable job = new StewardshipTechService.PaymentBatchOpenQueueable();
            job.stewardshipBatchID = theID;
            job.acctType = (newStewardshipACHBatchMap.get(theID).BankAccount__c == 'Payments' ? StewardshipTechService.AccountType.PAYMENT : StewardshipTechService.AccountType.DISBURSEMENT);
            System.enqueueJob(job);

        }

        for(ID theID : batchesToCancel){

            StewardshipTechService.PaymentBatchCancelRequest input = new StewardshipTechService.PaymentBatchCancelRequest();
            input.BatchGUID = newStewardshipACHBatchMap.get(theID).BatchGUID__c;
            StewardshipTechService.PaymentBatchCancelQueueable job = new StewardshipTechService.PaymentBatchCancelQueueable();
            job.stewardshipBatchID = theID;
            job.input = input;
            job.acctType = (newStewardshipACHBatchMap.get(theID).BankAccount__c == 'Payments' ? StewardshipTechService.AccountType.PAYMENT : StewardshipTechService.AccountType.DISBURSEMENT);

            System.enqueueJob(job);

        }

        for(ID theID : batchesToApprove){

            StewardshipTechService.PaymentBatchApproveRequest input = new StewardshipTechService.PaymentBatchApproveRequest();
            input.BatchGUID = newStewardshipACHBatchMap.get(theID).BatchGUID__c;            
            StewardshipTechService.PaymentBatchApproveQueueable job = new StewardshipTechService.PaymentBatchApproveQueueable();
            job.stewardshipBatchID = theID;
            job.input = input;
            job.acctType = (newStewardshipACHBatchMap.get(theID).BankAccount__c == 'Payments' ? StewardshipTechService.AccountType.PAYMENT : StewardshipTechService.AccountType.DISBURSEMENT);

            System.enqueueJob(job);

        }
        
        for(ID theID : batchesToSelect){

            StewardshipTechService.PaymentBatchSelectRequest input = new StewardshipTechService.PaymentBatchSelectRequest();
            input.BatchGUID = newStewardshipACHBatchMap.get(theID).BatchGUID__c;            
            StewardshipTechService.PaymentBatchSelectQueueable job = new StewardshipTechService.PaymentBatchSelectQueueable();
            job.stewardshipBatchID = theID;
            job.input = input;
            job.acctType = (newStewardshipACHBatchMap.get(theID).BankAccount__c == 'Payments' ? StewardshipTechService.AccountType.PAYMENT : StewardshipTechService.AccountType.DISBURSEMENT);

            System.enqueueJob(job);

        }

        for(ID theID : creditBatchesToOpen){

            StewardshipTechService.CreditBatchOpenRequest input = new StewardshipTechService.CreditBatchOpenRequest();
            input.ScheduledDate = newStewardshipACHBatchMap.get(theID).ScheduledDate__c;            
            StewardshipTechService.CreditBatchOpenQueueable job = new StewardshipTechService.CreditBatchOpenQueueable();
            job.stewardshipBatchID = theID;
            job.input = input;
            job.acctType = (newStewardshipACHBatchMap.get(theID).BankAccount__c == 'Payments' ? StewardshipTechService.AccountType.PAYMENT : StewardshipTechService.AccountType.DISBURSEMENT);

            System.enqueueJob(job);

        }
    }

    public class StewardshipACHBatchTriggerHandlerException extends Exception {}
}