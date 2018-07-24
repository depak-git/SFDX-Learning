/////////////////////////////////////////////////////////////////////////
// Class: CreditCheckTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-02-06   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class CreditCheckTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State acctrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    public static Boolean manageSchoolSecurityHasRun = false;

    /**************************Constructors**********************************************/
    
    /**************************Execution acctrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'CreditCheckTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'CreditCheckTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'CreditCheckTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'CreditCheckTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('CreditCheckTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<CreditCheck__c> newCreditCheckList = (List<CreditCheck__c>)tc.newList;
        //This is where you should call your business logic
		setDefaultsOnInsert(newCreditCheckList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('CreditCheckTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<CreditCheck__c> newCreditCheckList = (List<CreditCheck__c>)tc.newList;
        List<CreditCheck__c> oldCreditCheckList = (List<CreditCheck__c>)tc.oldList;
        Map<ID, CreditCheck__c> newCreditCheckMap = (Map<ID, CreditCheck__c>)tc.newMap;
        Map<ID, CreditCheck__c> oldCreditCheckMap = (Map<ID, CreditCheck__c>)tc.oldMap;
        //This is where you should call your business logic
		setDefaultsOnUpdate(oldCreditCheckMap, newCreditCheckMap); 

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('CreditCheckTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<CreditCheck__c> oldCreditCheckList = (List<CreditCheck__c>)tc.oldList;
        Map<ID, CreditCheck__c> oldCreditCheckMap = (Map<ID, CreditCheck__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('CreditCheckTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<CreditCheck__c> newCreditCheckList = (List<CreditCheck__c>)tc.newList;
        Map<ID, CreditCheck__c> newCreditCheckMap = (Map<ID, CreditCheck__c>)tc.newMap;
        //This is where you should call your business logic

        setAgreementFields(null, newCreditCheckMap);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('CreditCheckTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<CreditCheck__c> newCreditCheckList = (List<CreditCheck__c>)tc.newList;
        List<CreditCheck__c> oldCreditCheckList = (List<CreditCheck__c>)tc.oldList;
        Map<ID, CreditCheck__c> newCreditCheckMap = (Map<ID, CreditCheck__c>)tc.newMap;
        Map<ID, CreditCheck__c> oldCreditCheckMap = (Map<ID, CreditCheck__c>)tc.oldMap;
        //This is where you should call your business logic

        setAgreementFields(oldCreditCheckMap, newCreditCheckMap);

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('CreditCheckTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<CreditCheck__c> oldCreditCheckList = (List<CreditCheck__c>)tc.oldList;
        Map<ID, CreditCheck__c> oldCreditCheckMap = (Map<ID, CreditCheck__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('CreditCheckTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<CreditCheck__c> newCreditCheckList = (List<CreditCheck__c>)tc.newList;
        Map<ID, CreditCheck__c> newCreditCheckMap = (Map<ID, CreditCheck__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<CreditCheck__c> newCreditCheckList){
system.debug('CreditCheckTriggerHandler.setDefaultsOnInsert()');
        Set<ID> studentIDs = new Set<ID>();
        for(CreditCheck__c cc : newCreditCheckList){
            studentIDs.add(cc.Student__c);
        }
        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
        for(CreditCheck__c cc : newCreditCheckList){  //before trigger
            cc.SchoolSecurity__c = studentMap.get(cc.Student__c).SchoolSecurity__c;
        }   
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, CreditCheck__c> oldCreditCheckMap, Map<ID, CreditCheck__c> newCreditCheckMap){
system.debug('CreditCheckTriggerHandler.setDefaultsOnUpdate()'); 
        Set<ID> studentIDs = new Set<ID>();
        for(CreditCheck__c cc : newCreditCheckMap.values()){
            studentIDs.add(cc.Student__c);
        }
        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);        
        for(CreditCheck__c cc : newCreditCheckMap.values()){  //before trigger
            cc.SchoolSecurity__c = studentMap.get(cc.Student__c).SchoolSecurity__c;
        }   
    }

    //private void manageSchoolSecurity(Map<ID, CreditCheck__c> oldCreditCheckMap, Map<ID, CreditCheck__c> newCreditCheckMap){
    //    //if(!manageSchoolSecurityHasRun){
    //      //  manageSchoolSecurityHasRun = true;
    //        Set<ID> studentIDs = new Set<ID>();
    //        //List<CreditCheck__c> ccToUpdate = new List<CreditCheck__c>();
    //        for(CreditCheck__c cc : newCreditCheckMap.values()){
    //            studentIDsByCreditCheckID.put(cc.id, cc.Student__c);
    //        }
    //        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDsByCreditCheckID.values());
    //        for(CreditCheck__c cc : newCreditCheckMap.values()){  //before trigger
    //            cc.SchoolSecurity__c = studentMap.get(studentIDsByCreditCheckID.get(cc.id).SchoolSecurity__c)));
    //        }
    //        //if(ccToUpdate.size()>0){

    //        //}

    //   // } else {
    //     //   System.debug('manageSchoolSecurityHasRun is true');
    //    //}
    //}

    private void setAgreementFields(Map<ID, CreditCheck__c> oldCreditCheckMap, Map<ID, CreditCheck__c> newCreditCheckMap){
/*		System.debug('CreditCheckTriggerHandler.setAgreementFields()'); 
    	Set<ID> agreementIDs = new Set<ID>();
    	Map<ID, StudentProgram__c> agreementsToUpdate = new Map<ID, StudentProgram__c>();
    	for(CreditCheck__c cc: newCreditCheckMap.values()){
    		System.debug(cc);
    		if(oldCreditCheckMap == null){ //insert
    			if(cc.Status__c == 'Denied'){
    				agreementsToUpdate.put(cc.Agreement__c, new StudentProgram__c(id = cc.Agreement__c,
    																			  Status__c = 'Cancelled',
    																			  CancellationReason__c = 'Credit Denied',
    																			  EligibleToReapply__c = false));
				} else if(cc.Status__c == 'Under Review'){
    				agreementsToUpdate.put(cc.Agreement__c, new StudentProgram__c(id = cc.Agreement__c,
    																			  Status__c = 'Application Under Review'));    				
    			}
    		} else { //update
				if(cc.Status__c != oldCreditCheckMap.get(cc.id).Status__c){

					if(cc.Status__c == 'Denied'){
	    				agreementsToUpdate.put(cc.Agreement__c, new StudentProgram__c(id = cc.Agreement__c,
	    																			  Status__c = 'Cancelled',
	    																			  CancellationReason__c = 'Credit Denied',
	    																			  EligibleToReapply__c = false));
					} else if(cc.Status__c == 'Under Review'){
	    				agreementsToUpdate.put(cc.Agreement__c, new StudentProgram__c(id = cc.Agreement__c,
	    																			  Status__c = 'Application Under Review'));   					
					}
				}

    		}
    	}
    	System.debug(agreementsToUpdate);
    	if(agreementsToUpdate.size()>0){
    		update agreementsToUpdate.values();
    	}

*/
    }

    public class CreditCheckTriggerHandlerException extends Exception {}
}