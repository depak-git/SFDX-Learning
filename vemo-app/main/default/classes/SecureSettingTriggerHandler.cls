/////////////////////////////////////////////////////////////////////////
// Class: SecureSettingTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-12-28   Greg Cook  Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class SecureSettingTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {
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
            
        if(tc.handler == 'SecureSettingTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'SecureSettingTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'SecureSettingTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'SecureSettingTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<SecureSetting__c> newSecureSettingList = (List<SecureSetting__c>)tc.newList;
        //This is where you should call your business logic
		setDefaultsOnInsert(newSecureSettingList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<SecureSetting__c> newSecureSettingList = (List<SecureSetting__c>)tc.newList;
        List<SecureSetting__c> oldSecureSettingList = (List<SecureSetting__c>)tc.oldList;
        Map<ID, SecureSetting__c> newSecureSettingMap = (Map<ID, SecureSetting__c>)tc.newMap;
        Map<ID, SecureSetting__c> oldSecureSettingMap = (Map<ID, SecureSetting__c>)tc.oldMap;
        //This is where you should call your business logic
        
		setDefaultsOnUpdate(oldSecureSettingMap, newSecureSettingMap); 

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<SecureSetting__c> oldSecureSettingList = (List<SecureSetting__c>)tc.oldList;
        Map<ID, SecureSetting__c> oldSecureSettingMap = (Map<ID, SecureSetting__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<SecureSetting__c> newSecureSettingList = (List<SecureSetting__c>)tc.newList;
        Map<ID, SecureSetting__c> newSecureSettingMap = (Map<ID, SecureSetting__c>)tc.newMap;
        //This is where you should call your business logic
        manageEncrypt(null, newSecureSettingMap);
     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<SecureSetting__c> newSecureSettingList = (List<SecureSetting__c>)tc.newList;
        List<SecureSetting__c> oldSecureSettingList = (List<SecureSetting__c>)tc.oldList;
        Map<ID, SecureSetting__c> newSecureSettingMap = (Map<ID, SecureSetting__c>)tc.newMap;
        Map<ID, SecureSetting__c> oldSecureSettingMap = (Map<ID, SecureSetting__c>)tc.oldMap;
        //This is where you should call your business logic
        manageEncrypt(oldSecureSettingMap, newSecureSettingMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<SecureSetting__c> oldSecureSettingList = (List<SecureSetting__c>)tc.oldList;
        Map<ID, SecureSetting__c> oldSecureSettingMap = (Map<ID, SecureSetting__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<SecureSetting__c> newSecureSettingList = (List<SecureSetting__c>)tc.newList;
        Map<ID, SecureSetting__c> newSecureSettingMap = (Map<ID, SecureSetting__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<SecureSetting__c> newSecureSettingList){

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, SecureSetting__c> oldSecureSettingMap, Map<ID, SecureSetting__c> newSecureSettingMap){

    }

    private static void manageEncrypt(Map<ID, SecureSetting__c> oldSecureSettingMap, Map<ID, SecureSetting__c> newSecureSettingMap){
    	List<Attachment> encryptedDataToCreate = new List<Attachment>();
        List<SecureSetting__c> settingsToUpdate = new List<SecureSetting__c>();
        for(SecureSetting__c ss : newSecureSettingMap.values()){
            System.debug(ss);
    		if(ss.Encrypt__c){
                encryptedDataToCreate.add(new Attachment(ParentID = ss.id,
                                                         Body = SecureSettings.encrypt(ss.Value__c),
                                                         Name = 'encrypted-'+DateTime.now()));
                settingsToUpdate.add(new SecureSetting__c(id = ss.id,
                                                          Encrypt__c = false,
                                                          Value__c = ''));
    		}
    	}
        if(settingsToUpdate.size()>0){
            update settingsToUpdate;
        }
        if(encryptedDataToCreate.size()>0){
            insert encryptedDataToCreate;
        }
    }


    public class SecureSettingTriggerHandlerException extends Exception {}
}