/////////////////////////////////////////////////////////////////////////
// Class: PaymentAllocationTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-04   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class PaymentAllocationTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

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
        mainHasRun = true;
            
        if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'PaymentAllocationTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'PaymentAllocationTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('PaymentAllocationTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentAllocation__c> newPaymentAllocationList = (List<PaymentAllocation__c>)tc.newList;
        //This is where you should call your business logic


    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('PaymentAllocationTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentAllocation__c> newPaymentAllocationList = (List<PaymentAllocation__c>)tc.newList;
        List<PaymentAllocation__c> oldPaymentAllocationList = (List<PaymentAllocation__c>)tc.oldList;
        Map<ID, PaymentAllocation__c> newPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.newMap;
        Map<ID, PaymentAllocation__c> oldPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.oldMap;
        //This is where you should call your business logic
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('PaymentAllocationTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentAllocation__c> oldPaymentAllocationList = (List<PaymentAllocation__c>)tc.oldList;
        Map<ID, PaymentAllocation__c> oldPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('PaymentAllocationTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentAllocation__c> newPaymentAllocationList = (List<PaymentAllocation__c>)tc.newList;
        Map<ID, PaymentAllocation__c> newPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.newMap;
        //This is where you should call your business logic
		setDefaultsOnInsert(newPaymentAllocationList);
		manageAgreements(null, newPaymentAllocationMap);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('PaymentAllocationTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentAllocation__c> newPaymentAllocationList = (List<PaymentAllocation__c>)tc.newList;
        List<PaymentAllocation__c> oldPaymentAllocationList = (List<PaymentAllocation__c>)tc.oldList;
        Map<ID, PaymentAllocation__c> newPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.newMap;
        Map<ID, PaymentAllocation__c> oldPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.oldMap;
        //This is where you should call your business logic
		setDefaultsOnUpdate(oldPaymentAllocationMap, newPaymentAllocationMap);
		manageAgreements(oldPaymentAllocationMap, newPaymentAllocationMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('PaymentAllocationTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentAllocation__c> oldPaymentAllocationList = (List<PaymentAllocation__c>)tc.oldList;
        Map<ID, PaymentAllocation__c> oldPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.oldMap;
        //This is where you should call your business logic
		manageAgreements(oldPaymentAllocationMap, null);
     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('PaymentAllocationTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentAllocation__c> newPaymentAllocationList = (List<PaymentAllocation__c>)tc.newList;
        Map<ID, PaymentAllocation__c> newPaymentAllocationMap = (Map<ID, PaymentAllocation__c>)tc.newMap;
        //This is where you should call your business logic
		manageAgreements(null, newPaymentAllocationMap);        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<PaymentAllocation__c> newPaymentAllocationList){
system.debug('PaymentAllocationTriggerHandler.setDefaultsOnInsert()');
        for(PaymentAllocation__c alloc : newPaymentAllocationList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, PaymentAllocation__c> oldPaymentAllocationMap, Map<ID, PaymentAllocation__c> newPaymentAllocationMap){
system.debug('PaymentAllocationTriggerHandler.setDefaultsOnUpdate()'); 
        for(PaymentAllocation__c alloc : newPaymentAllocationMap.values()){

        }
    }

    public static void manageAgreements(Map<ID, PaymentAllocation__c> oldPaymentAllocationMap, Map<ID, PaymentAllocation__c> newPaymentAllocationMap){
        System.debug('PaymentAllocationTriggerHandler.manageAgreements()');
    	Map<ID, List<PaymentAllocation__c>> allocationsByAgreement = new Map<ID, List<PaymentAllocation__c>>();
    	Set<ID> agreementIDs = new Set<ID>();
    	List<PaymentAllocation__c> allocationsToAssess = ((newPaymentAllocationMap != null) ? newPaymentAllocationMap.values() : oldPaymentAllocationMap.values());
    	for(PaymentAllocation__c alloc : allocationsToAssess){
            if(alloc.Agreement__c != null) agreementIDs.add(alloc.Agreement__c);
    	}

    	System.debug(agreementIDs);
        
        List<StudentProgram__c> agreementsToUpdate = new List<StudentProgram__c>();
        if(agreementIDs.size()>0){
            System.debug('really?');
            //move to query layer?
            List<PaymentAllocation__c> allAllocations = [SELECT id, AmountAllocated__c, Agreement__c, AllocationType__c
                                                         FROM PaymentAllocation__c
                                                         WHERE Agreement__c IN :agreementIDs];
            for(PaymentAllocation__c alloc : allAllocations){
                if(!allocationsByAgreement.containsKey(alloc.Agreement__c)){
                    allocationsByAgreement.put(alloc.Agreement__c, new List<PaymentAllocation__c>());
                }
                allocationsByAgreement.get(alloc.Agreement__c).add(alloc);
            }
            System.debug('allocationsByAgreement:'+allocationsByAgreement);


            
            for(ID agreementID : agreementIDs){
                Decimal totalPayments = 0;
                Decimal totalReconciliationPayments = 0;
                Decimal totalMonthlyAmountPayments = 0;
                if(allocationsByAgreement.containsKey(agreementID)){
                    for(PaymentAllocation__c alloc : allocationsByAgreement.get(agreementID)){
                        totalPayments += alloc.AmountAllocated__c;
                        if(alloc.AllocationType__c == 'Reconciliation') totalReconciliationPayments += alloc.AmountAllocated__c;
                        if(alloc.AllocationType__c == 'Monthly Amount') totalMonthlyAmountPayments += alloc.AmountAllocated__c;
                    }               
                }

                agreementsToUpdate.add(new StudentProgram__c(id = agreementID,
                                                                PaidToDate__c = totalPayments,
                                                                ReconciliationPaidToDate__c = totalReconciliationPayments,
                                                                MonthlyAmountPaidToDate__c = totalMonthlyAmountPayments));
            }            
        }

    	if(agreementsToUpdate.size()>0){
    		update agreementsToUpdate;
    	}
    }


    public class PaymentAllocationTriggerHandlerException extends Exception {}
}