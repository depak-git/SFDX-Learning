/////////////////////////////////////////////////////////////////////////
// Class: GenericDocumentTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-01-02   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class GenericDocumentTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

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
            
        if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'GenericDocumentTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'GenericDocumentTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('GenericDocumentTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<GenericDocument__c> newGenericDocumentList = (List<GenericDocument__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newGenericDocumentList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('GenericDocumentTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<GenericDocument__c> newGenericDocumentList = (List<GenericDocument__c>)tc.newList;
        List<GenericDocument__c> oldGenericDocumentList = (List<GenericDocument__c>)tc.oldList;
        Map<ID, GenericDocument__c> newGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.newMap;
        Map<ID, GenericDocument__c> oldGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldGenericDocumentMap, newGenericDocumentMap);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('GenericDocumentTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<GenericDocument__c> oldGenericDocumentList = (List<GenericDocument__c>)tc.oldList;
        Map<ID, GenericDocument__c> oldGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('GenericDocumentTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<GenericDocument__c> newGenericDocumentList = (List<GenericDocument__c>)tc.newList;
        Map<ID, GenericDocument__c> newGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.newMap;
        //This is where you should call your business logic

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('GenericDocumentTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<GenericDocument__c> newGenericDocumentList = (List<GenericDocument__c>)tc.newList;
        List<GenericDocument__c> oldGenericDocumentList = (List<GenericDocument__c>)tc.oldList;
        Map<ID, GenericDocument__c> newGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.newMap;
        Map<ID, GenericDocument__c> oldGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.oldMap;
        //This is where you should call your business logic

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('GenericDocumentTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<GenericDocument__c> oldGenericDocumentList = (List<GenericDocument__c>)tc.oldList;
        Map<ID, GenericDocument__c> oldGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('GenericDocumentTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<GenericDocument__c> newGenericDocumentList = (List<GenericDocument__c>)tc.newList;
        Map<ID, GenericDocument__c> newGenericDocumentMap = (Map<ID, GenericDocument__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<GenericDocument__c> newGenericDocumentList){
system.debug('GenericDocumentTriggerHandler.setDefaultsOnInsert()');

        for(GenericDocument__c gd : newGenericDocumentList){
        	gd.Status__c = 'Pending Upload';
            if(String.isNotBlank(gd.ParentID__c)) gd.ParentID__c = gd.ParentID__c.substring(0,15);
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, GenericDocument__c> oldGenericDocumentMap, Map<ID, GenericDocument__c> newGenericDocumentMap){
system.debug('GenericDocumentTriggerHandler.setDefaultsOnUpdate()'); 
        for(GenericDocument__c gd : newGenericDocumentMap.values()){
            if(String.isNotBlank(gd.ParentID__c)) gd.ParentID__c = gd.ParentID__c.substring(0,15);
        }
    }

    public class GenericDocumentTriggerHandlerException extends Exception {}
}