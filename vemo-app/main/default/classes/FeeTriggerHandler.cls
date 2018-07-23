/////////////////////////////////////////////////////////////////////////
// Class: FeeTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-01   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class FeeTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State feerol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution feerol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'FeeTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'FeeTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'FeeTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'FeeTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('FeeTriggerHandler.onBeforeInsert()');
       //Recast the trigger feeext variables into the appropriate shandlerect types
        List<Fee__c> newFeeList = (List<Fee__c>)tc.newList;
        //This is where you should call your business logic


    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('FeeTriggerHandler.onBeforeUpdate()');
        //Recast the trigger feeext variables into the appropriate shandlerect types
        List<Fee__c> newFeeList = (List<Fee__c>)tc.newList;
        List<Fee__c> oldFeeList = (List<Fee__c>)tc.oldList;
        Map<ID, Fee__c> newFeeMap = (Map<ID, Fee__c>)tc.newMap;
        Map<ID, Fee__c> oldFeeMap = (Map<ID, Fee__c>)tc.oldMap;
        //This is where you should call your business logic
 

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('FeeTriggerHandler.onBeforeDelete()');
       //Recast the trigger feeext variables into the appropriate shandlerect types
        List<Fee__c> oldFeeList = (List<Fee__c>)tc.oldList;
        Map<ID, Fee__c> oldFeeMap = (Map<ID, Fee__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('FeeTriggerHandler.onAfterInsert()');
         //Recast the trigger feeext variables into the appropriate shandlerect types
        List<Fee__c> newFeeList = (List<Fee__c>)tc.newList;
        Map<ID, Fee__c> newFeeMap = (Map<ID, Fee__c>)tc.newMap;
        //This is where you should call your business logic
		setDefaultsOnInsert(newFeeList);
		manageAccounts(null, newFeeMap);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('FeeTriggerHandler.onAfterUpdate()');
        //Recast the trigger feeext variables into the appropriate shandlerect types
        List<Fee__c> newFeeList = (List<Fee__c>)tc.newList;
        List<Fee__c> oldFeeList = (List<Fee__c>)tc.oldList;
        Map<ID, Fee__c> newFeeMap = (Map<ID, Fee__c>)tc.newMap;
        Map<ID, Fee__c> oldFeeMap = (Map<ID, Fee__c>)tc.oldMap;
        //This is where you should call your business logic
		setDefaultsOnUpdate(oldFeeMap, newFeeMap);
		manageAccounts(oldFeeMap, newFeeMap);		

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('FeeTriggerHandler.onAfterDelete()');
        //Recast the trigger feeext variables into the appropriate shandlerect types
        List<Fee__c> oldFeeList = (List<Fee__c>)tc.oldList;
        Map<ID, Fee__c> oldFeeMap = (Map<ID, Fee__c>)tc.oldMap;
        //This is where you should call your business logic
		manageAccounts(oldFeeMap, null);
     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('FeeTriggerHandler.onAfterUndelete()');
        //Recast the trigger feeext variables into the appropriate shandlerect types
        List<Fee__c> newFeeList = (List<Fee__c>)tc.newList;
        Map<ID, Fee__c> newFeeMap = (Map<ID, Fee__c>)tc.newMap;
        //This is where you should call your business logic
		manageAccounts(null, newFeeMap);        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Fee__c> newFeeList){
system.debug('FeeTriggerHandler.setDefaultsOnInsert()');
        for(Fee__c fee : newFeeList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Fee__c> oldFeeMap, Map<ID, Fee__c> newFeeMap){
system.debug('FeeTriggerHandler.setDefaultsOnUpdate()'); 
        for(Fee__c fee : newFeeMap.values()){

        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: manageAccounts
    /////////////////////////////////////////////////////////////////////////
    private void manageAccounts(Map<ID, Fee__c> oldFeeMap, Map<ID, Fee__c> newFeeMap){
    	Map<ID, List<Fee__c>> feesByAccount = new Map<ID, List<Fee__c>>();
    	Set<ID> accountIDs = new Set<ID>();
    	List<Fee__c> feesToAssess = ((newFeeMap != null) ? newFeeMap.values() : oldFeeMap.values());
    	for(Fee__c fee : feesToAssess){
    		accountIDs.add(fee.Customer__c);
    	}

    	//move this to query layer?
    	List<Fee__c> allFees = [SELECT id, Amount__c, Customer__c, DateAssessed__c, DateCleared__c, Status__c, Type__c
    													FROM Fee__c
    													WHERE Customer__c IN :accountIDs];

    	for(Fee__c fee : allFees){
    		if(!feesByAccount.containsKey(fee.Customer__c)){
    			feesByAccount.put(fee.Customer__c, new List<Fee__c>());
    		}
    		feesByAccount.get(fee.Customer__c).add(fee);
    	}

    	List<Account> accountsToUpdate = new List<Account>();
    	//Loop through and summarize for each 

    	for(ID accountID : accountIDs){
    		Decimal totalUnpaidFees = 0;
            if(feesByAccount.containsKey(accountID)){
                for(Fee__c fee : feesByAccount.get(accountID)){
                    if(fee.Status__c == 'Unpaid') totalUnpaidFees += fee.Amount__c;
                }                
            }

    		accountsToUpdate.add(new Account(id = accountID, UnpaidFees__c = totalUnpaidFees));
    	}
    	if(accountsToUpdate.size()>0){
    		update accountsToUpdate;
    	}
    }
    public class FeeTriggerHandlerException extends Exception {}
}