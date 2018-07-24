/////////////////////////////////////////////////////////////////////////
// Class: RefundTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-03-19   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class RefundTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State refundrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution refundrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'RefundTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'RefundTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'RefundTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'RefundTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('RefundTriggerHandler.onBeforeInsert()');
       //Recast the trigger refundext variables into the appropriate shandlerect types
        List<Refund__c> newRefundList = (List<Refund__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newRefundList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('RefundTriggerHandler.onBeforeUpdate()');
        //Recast the trigger refundext variables into the appropriate shandlerect types
        List<Refund__c> newRefundList = (List<Refund__c>)tc.newList;
        List<Refund__c> oldRefundList = (List<Refund__c>)tc.oldList;
        Map<ID, Refund__c> newRefundMap = (Map<ID, Refund__c>)tc.newMap;
        Map<ID, Refund__c> oldRefundMap = (Map<ID, Refund__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldRefundMap, newRefundMap);    
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('RefundTriggerHandler.onBeforeDelete()');
       //Recast the trigger refundext variables into the appropriate shandlerect types
        List<Refund__c> oldRefundList = (List<Refund__c>)tc.oldList;
        Map<ID, Refund__c> oldRefundMap = (Map<ID, Refund__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('RefundTriggerHandler.onAfterInsert()');
         //Recast the trigger refundext variables into the appropriate shandlerect types
        List<Refund__c> newRefundList = (List<Refund__c>)tc.newList;
        Map<ID, Refund__c> newRefundMap = (Map<ID, Refund__c>)tc.newMap;
        //This is where you should call your business logic
        manageAmountDue(null, newRefundMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('RefundTriggerHandler.onAfterUpdate()');
        //Recast the trigger refundext variables into the appropriate shandlerect types
        List<Refund__c> newRefundList = (List<Refund__c>)tc.newList;
        List<Refund__c> oldRefundList = (List<Refund__c>)tc.oldList;
        Map<ID, Refund__c> newRefundMap = (Map<ID, Refund__c>)tc.newMap;
        Map<ID, Refund__c> oldRefundMap = (Map<ID, Refund__c>)tc.oldMap;
        //This is where you should call your business logic
        manageAmountDue(oldRefundMap, newRefundMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('RefundTriggerHandler.onAfterDelete()');
        //Recast the trigger refundext variables into the appropriate shandlerect types
        List<Refund__c> oldRefundList = (List<Refund__c>)tc.oldList;
        Map<ID, Refund__c> oldRefundMap = (Map<ID, Refund__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('RefundTriggerHandler.onAfterUndelete()');
        //Recast the trigger refundext variables into the appropriate shandlerect types
        List<Refund__c> newRefundList = (List<Refund__c>)tc.newList;
        Map<ID, Refund__c> newRefundMap = (Map<ID, Refund__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Refund__c> newRefundList){
system.debug('RefundTriggerHandler.setDefaultsOnInsert()');

        for(Refund__c refund : newRefundList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Refund__c> oldRefundMap, Map<ID, Refund__c> newRefundMap){
system.debug('RefundTriggerHandler.setDefaultsOnUpdate()'); 
        for(Refund__c refund : newRefundMap.values()){

        }
    }


    /////////////////////////////////////////////////////////////////////////
    //Method: manageAmountDue
    /////////////////////////////////////////////////////////////////////////
    private void manageAmountDue(Map<ID, Refund__c> oldRefundMap, Map<ID, Refund__c> newRefundMap){
        Set<Id> refundIds = new Set<Id>();
        for(Refund__c refund : newRefundMap.values()){
        	if(String.isNotEmpty(refund.Agreement__c) && (refund.GenerateAmountDue__c == true && (oldRefundMap == null || oldRefundMap.get(refund.id).GenerateAmountDue__c != true))){
        		refundIDs.add(refund.id);
        	}
        }
        List<StudentProgramAmountDue__c> amountDueToAdd = new List<StudentProgramAmountDue__c>();
        for(ID theID : refundIDs){
        	Refund__c ref = newRefundMap.get(theID);
        	StudentProgramAmountDue__c amountDue = new StudentProgramAmountDue__c(Agreement__c = ref.Agreement__c,
        																		  Amount__c = ref.Amount__c,
        																		  AssessmentDateTime__c = DateTime.now(),
        																		  ExcludeFromBalance__c = false,
        																		  Refund__c = theID,
        																		  Type__c = 'Monthly Amount');
        	amountDueToAdd.add(amountDue);
        }

        if(amountDueToAdd.size()>0){
        	insert amountDueToAdd;
        }
    }

    public class RefundTriggerHandlerException extends Exception {}
}