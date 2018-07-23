/////////////////////////////////////////////////////////////////////////
// Class: StewardshipACHBatchDtlTriggerHndlr
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class StewardshipACHBatchDtlTriggerHndlr implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State batchDetailrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
//    public static Boolean manageCasesHasRun = false;
//    public static Boolean manageStewardshipACHBatchDetailSharesHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution batchDetailrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StewardshipACHBatchDtlTriggerHndlr' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'StewardshipACHBatchDtlTriggerHndlr'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchDtlTriggerHndlr.onBeforeInsert()');
       //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newStewardshipACHBatchDetailList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchDtlTriggerHndlr.onBeforeUpdate()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.newList;
        List<StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.oldList;
        Map<ID, StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.newMap;
        Map<ID, StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldStewardshipACHBatchDetailMap, newStewardshipACHBatchDetailMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchDtlTriggerHndlr.onBeforeDelete()');
       //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.oldList;
        Map<ID, StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchDtlTriggerHndlr.onAfterInsert()');
         //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.newList;
        Map<ID, StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.newMap;
        //This is where you should call your business logic

        manageStewardship(null, newStewardshipACHBatchDetailMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchDtlTriggerHndlr.onAfterUpdate()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.newList;
        List<StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.oldList;
        Map<ID, StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.newMap;
        Map<ID, StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.oldMap;
        //This is where you should call your business logic

        manageStewardship(oldStewardshipACHBatchDetailMap, newStewardshipACHBatchDetailMap);
        managePayments(oldStewardshipACHBatchDetailMap, newStewardshipACHBatchDetailMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchDtlTriggerHndlr.onAfterDelete()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.oldList;
        Map<ID, StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('StewardshipACHBatchDtlTriggerHndlr.onAfterUndelete()');
        //Recast the trigger batchDetailext variables into the appropriate shandlerect types
        List<StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailList = (List<StewardshipACHBatchDetail__c>)tc.newList;
        Map<ID, StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailMap = (Map<ID, StewardshipACHBatchDetail__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailList){
system.debug('StewardshipACHBatchDtlTriggerHndlr.setDefaultsOnInsert()');

        for(StewardshipACHBatchDetail__c batchDetail : newStewardshipACHBatchDetailList){
            if(batchDetail.Amount__c == null || batchDetail.Amount__c == 0) batchDetail.Amount__c = batchDetail.AmountFormula__c;
            
          //temp  if(String.isEmpty(batchDetail.BatchGUID__c)) batchDetail.BatchGUID__c = batchDetail.BatchGUIDFormula__c;

            if(batchDetail.BankAccount__c == 'Payments'){
                if(String.isEmpty(batchDetail.DonorGUID__c)) batchDetail.DonorGUID__c = batchDetail.PaymentDonorGUIDFormula__c;
                if(String.isEmpty(batchDetail.AccountGUID__c)) batchDetail.AccountGUID__c = batchDetail.PaymentAccountGUIDFormula__c;                
            }
            if(batchDetail.BankAccount__c == 'Disbursement'){
                if(String.isEmpty(batchDetail.DonorGUID__c)) batchDetail.DonorGUID__c = batchDetail.DisbursementDonorGUIDFormula__c;
                if(String.isEmpty(batchDetail.AccountGUID__c)) batchDetail.AccountGUID__c = batchDetail.DisbursementAccountGUIDFormula__c;                
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailMap, Map<ID, StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailMap){
system.debug('StewardshipACHBatchDtlTriggerHndlr.setDefaultsOnUpdate()'); 
        for(StewardshipACHBatchDetail__c batchDetail : newStewardshipACHBatchDetailMap.values()){
            if(batchDetail.Amount__c == null || batchDetail.Amount__c == 0) batchDetail.Amount__c = batchDetail.AmountFormula__c;
            if(batchDetail.Status__c == 'Cancelled' && oldStewardshipACHBatchDetailMap.get(batchDetail.id).Status__c != 'Cancelled'){
                batchDetail.StewardshipProcess__c = 'CancelTransaction';
            }

            if(batchDetail.BankAccount__c == 'Payments'){
                if(String.isEmpty(batchDetail.DonorGUID__c)) batchDetail.DonorGUID__c = batchDetail.PaymentDonorGUIDFormula__c;
                if(String.isEmpty(batchDetail.AccountGUID__c)) batchDetail.AccountGUID__c = batchDetail.PaymentAccountGUIDFormula__c;                
            }
            if(batchDetail.BankAccount__c == 'Disbursement'){
                if(String.isEmpty(batchDetail.DonorGUID__c)) batchDetail.DonorGUID__c = batchDetail.DisbursementDonorGUIDFormula__c;
                if(String.isEmpty(batchDetail.AccountGUID__c)) batchDetail.AccountGUID__c = batchDetail.DisbursementAccountGUIDFormula__c;                
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: managePayments
    /////////////////////////////////////////////////////////////////////////
    private void managePayments(Map<ID, StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailMap, Map<ID, StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailMap){
        System.debug('StewardshipACHBatchDtlTriggerHndlr.managePayments()'); 

        Set<ID> paymentIDs = new Set<ID>();
        for(StewardshipACHBatchDetail__c batchDetail : newStewardshipACHBatchDetailMap.values()){
            if(String.isNotEmpty(batchDetail.PaymentInstruction__c)){
                paymentIDs.add(batchDetail.PaymentInstruction__c);
            }
        }        
        Map<ID, PaymentInstruction__c> paymentsToUpdate = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentInstructionID(paymentIDs);//new Map<ID, PaymentInstruction__c>([Select id, Date__c from PaymentInstruction__c where ID in: paymentIDs]);
        for(StewardshipACHBatchDetail__c batchDetail : newStewardshipACHBatchDetailMap.values()){
            if(String.isNotEmpty(batchDetail.PaymentInstruction__c)){
                PaymentInstruction__c payment = paymentsToUpdate.get(batchDetail.PaymentInstruction__c);
                System.debug('payment:'+payment);
                Date postedDate;
                Date createdDate = Date.newInstance(payment.CreatedDate.year(), payment.CreatedDate.month(), payment.CreatedDate.day());
                System.debug('payment.Date__c:'+payment.Date__c);
                System.debug('createdDate:'+createdDate);
                if(payment.Date__c < createdDate){
                    postedDate = createdDate;
                } else {
                    postedDate = payment.Date__c;
                }
                System.debug('postedDate:'+postedDate);
                if(batchDetail.TransactionStatus__c == 'C' && oldStewardshipACHBatchDetailMap.get(batchDetail.id).TransactionStatus__c != 'C'){
                    paymentsToUpdate.put(batchDetail.PaymentInstruction__c, new PaymentInstruction__c(id = batchDetail.PaymentInstruction__c,
                                                                    DatePosted__c = postedDate,//paymentsToUpdate.get(batchDetail.PaymentInstruction__c).Date__c,
                                                                    AmountPosted__c = batchDetail.TransactionAmount__c,
                                                                   Status__c = 'Cleared'));
                }
                if(batchDetail.TransactionStatus__c == 'B' && oldStewardshipACHBatchDetailMap.get(batchDetail.id).TransactionStatus__c != 'B'){
                    paymentsToUpdate.put(batchDetail.PaymentInstruction__c, new PaymentInstruction__c(id = batchDetail.PaymentInstruction__c,
                                                                   Status__c = 'Bounced'));
                }
                if(batchDetail.TransactionStatus__c == 'P' && oldStewardshipACHBatchDetailMap.get(batchDetail.id).TransactionStatus__c != 'P'){
                    paymentsToUpdate.put(batchDetail.PaymentInstruction__c, new PaymentInstruction__c(id = batchDetail.PaymentInstruction__c,
                                                                   Status__c = 'Processing'));
                }
                if(batchDetail.Status__c == 'Cancelled' && oldStewardshipACHBatchDetailMap.get(batchDetail.id).Status__c != 'Cancelled'){
                    paymentsToUpdate.put(batchDetail.PaymentInstruction__c, new PaymentInstruction__c(id = batchDetail.PaymentInstruction__c,
                                                                   Status__c = 'Cancelled'));
                }
                if(batchDetail.Status__c == 'Batch Cancelled' && oldStewardshipACHBatchDetailMap.get(batchDetail.id).Status__c != 'Batch Cancelled'){
                    paymentsToUpdate.put(batchDetail.PaymentInstruction__c, new PaymentInstruction__c(id = batchDetail.PaymentInstruction__c,
                                                                   Status__c = 'Cancelled'));
                }
                if(batchDetail.Status__c == 'Approved' && oldStewardshipACHBatchDetailMap.get(batchDetail.id).Status__c != 'Approved'){
                    paymentsToUpdate.put(batchDetail.PaymentInstruction__c, new PaymentInstruction__c(id = batchDetail.PaymentInstruction__c,
                                                                   Status__c = 'Processing'));
                }
            }
        }
        if(paymentsToUpdate.size()>0){
            update paymentsToUpdate.values();
        }
    }


    /////////////////////////////////////////////////////////////////////////
    //Method: manageStewardship
    /////////////////////////////////////////////////////////////////////////
    private void manageStewardship(Map<ID, StewardshipACHBatchDetail__c> oldStewardshipACHBatchDetailMap, Map<ID, StewardshipACHBatchDetail__c> newStewardshipACHBatchDetailMap){
system.debug('StewardshipACHBatchDtlTriggerHndlr.manageStewardship()'); 
        Set<Id> paymentDetailIds = new Set<Id>();
        Set<Id> creditDetailIds = new Set<ID>();
        Set<ID> cancelTxIDs = new Set<ID>();
        for(StewardshipACHBatchDetail__c batchDetail : newStewardshipACHBatchDetailMap.values()){
            if((oldStewardshipACHBatchDetailMap == null && batchDetail.StewardshipProcess__c == 'CreateTransaction') ||
               (batchDetail.StewardshipProcess__c == 'CreateTransaction' && batchDetail.StewardshipProcess__c != oldStewardshipACHBatchDetailMap.get(batchDetail.id).StewardshipProcess__c)){
                if(batchDetail.ScheduledDate__c == null) batchDetail.addError('Scheduled Date is required for Payment transactions');
                if(batchDetail.TransactionType__c != 'Payment (Incoming Money)') batchDetail.addError('Not a payment');
                if(batchDetail.BatchType__c != 'Payment (Incoming Money)') batchDetail.addError('Not a payment batch');
                 if(String.isEmpty(batchDetail.Memo__c)) batchDetail.addError('Requires Memo');
                paymentDetailIds.add(batchDetail.Id);
            }

            if((oldStewardshipACHBatchDetailMap == null && batchDetail.StewardshipProcess__c == 'CreateCreditTransaction') ||
               (batchDetail.StewardshipProcess__c == 'CreateCreditTransaction' && batchDetail.StewardshipProcess__c != oldStewardshipACHBatchDetailMap.get(batchDetail.id).StewardshipProcess__c)){
                if(batchDetail.TransactionType__c != 'Credit (Outgoing Money)') batchDetail.addError('Not a credit');
                if(batchDetail.BatchType__c != 'Credit (Outgoing Money)') batchDetail.addError('Not a credit batch');
                if(String.isEmpty(batchDetail.CompanyEntryDescription__c)) batchDetail.addError('Requires CompanyEntryDescription');
                if(String.isEmpty(batchDetail.Memo__c)) batchDetail.addError('Requires Memo');
                creditDetailIds.add(batchDetail.Id);
            }

            if((oldStewardshipACHBatchDetailMap == null && batchDetail.StewardshipProcess__c == 'CancelTransaction') ||
               (batchDetail.StewardshipProcess__c == 'CancelTransaction' && batchDetail.StewardshipProcess__c != oldStewardshipACHBatchDetailMap.get(batchDetail.id).StewardshipProcess__c)){
                if(String.isEmpty(batchDetail.AccountScheduleGUID__c)) batchDetail.addError('Requires AccountScheduleGUID');
                cancelTxIds.add(batchDetail.Id);
            }
        }


        for(ID theID : paymentDetailIds){
            StewardshipTechService.CreateTransactionRequest input = new StewardshipTechService.CreateTransactionRequest();
            //input.DonorGUID = '117FDE89-F3DD-47AC-806A-C19185F11AB6';
            //input.AccountGUID = '5A8811D0-65DD-48EA-817C-D0799B70485D';
            input.DonorGUID = newStewardshipACHBatchDetailMap.get(theID).DonorGUID__c;
            input.AccountGUID = newStewardshipACHBatchDetailMap.get(theID).AccountGUID__c;
            input.Amount1 = newStewardshipACHBatchDetailMap.get(theID).Amount__c;
            input.Memo1 = newStewardshipACHBatchDetailMap.get(theID).Memo__c;

            input.RecurringType = String.valueOf(newStewardshipACHBatchDetailMap.get(theID).RecurringType__c).left(1);
            input.ScheduledDate = newStewardshipACHBatchDetailMap.get(theID).ScheduledDate__c;
//            input.BatchGUID = newStewardshipACHBatchDetailMap.get(theID).BatchGUID__c;
            
            StewardshipTechService.CreateTransactionQueueable job = new StewardshipTechService.CreateTransactionQueueable();
            job.input = input;
            job.stewardshipBatchDetailID = theID;
            job.acctType = StewardshipTechService.AccountType.PAYMENT;
            System.enqueueJob(job);

        }

        for(ID theID : creditDetailIds){
            StewardshipTechService.CreateCreditTransactionRequest input = new StewardshipTechService.CreateCreditTransactionRequest();
            //input.DonorGUID = '117FDE89-F3DD-47AC-806A-C19185F11AB6';
            //input.AccountGUID = '5A8811D0-65DD-48EA-817C-D0799B70485D';
            input.DonorGUID = newStewardshipACHBatchDetailMap.get(theID).DonorGUID__c;
            input.AccountGUID = newStewardshipACHBatchDetailMap.get(theID).AccountGUID__c;
            input.Amount = newStewardshipACHBatchDetailMap.get(theID).Amount__c;
            input.Memo = newStewardshipACHBatchDetailMap.get(theID).Memo__c;
            input.CompanyEntryDescription = newStewardshipACHBatchDetailMap.get(theID).CompanyEntryDescription__c;


//            input.BatchGUID = newStewardshipACHBatchDetailMap.get(theID).BatchGUID__c;
            
            StewardshipTechService.CreateCreditTransactionQueueable job = new StewardshipTechService.CreateCreditTransactionQueueable();
            job.input = input;
            job.stewardshipBatchDetailID = theID;
            job.acctType = StewardshipTechService.AccountType.DISBURSEMENT;
            System.enqueueJob(job);

        }

        for(ID theID : cancelTxIds){
            StewardshipTechService.CancelTransactionRequest input = new StewardshipTechService.CancelTransactionRequest();

            input.DonorGUID = newStewardshipACHBatchDetailMap.get(theID).DonorGUID__c;
            input.AccountScheduleGUID = newStewardshipACHBatchDetailMap.get(theID).AccountScheduleGUID__c;
            
            StewardshipTechService.CancelTransactionQueueable job = new StewardshipTechService.CancelTransactionQueueable();
            job.input = input;
            job.stewardshipBatchDetailID = theID;
            job.acctType = StewardshipTechService.AccountType.PAYMENT;
            System.enqueueJob(job);

        }

    }

    public class StewardshipACHBatchDtlTriggerHndlrException extends Exception {}
}