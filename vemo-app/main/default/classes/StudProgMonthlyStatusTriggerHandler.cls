/////////////////////////////////////////////////////////////////////////
// Class: StudProgMonthlyStatusTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-26   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class StudProgMonthlyStatusTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State spmsrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution spmsrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StudProgMonthlyStatusTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'StudProgMonthlyStatusTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('StudProgMonthlyStatusTriggerHandler.onBeforeInsert()');
       //Recast the trigger spmsext variables into the appropriate shandlerect types
        List<StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.newList;
        //This is where you should call your business logic
		setDefaultsOnInsert(newStudProgMonthlyStatusList); 

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StudProgMonthlyStatusTriggerHandler.onBeforeUpdate()');
        //Recast the trigger spmsext variables into the appropriate shandlerect types
        List<StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.newList;
        List<StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.oldList;
        Map<ID, StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.newMap;
        Map<ID, StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.oldMap;
        //This is where you should call your business logic
		setDefaultsOnUpdate(oldStudProgMonthlyStatusMap, newStudProgMonthlyStatusMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('StudProgMonthlyStatusTriggerHandler.onBeforeDelete()');
       //Recast the trigger spmsext variables into the appropriate shandlerect types
        List<StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.oldList;
        Map<ID, StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('StudProgMonthlyStatusTriggerHandler.onAfterInsert()');
         //Recast the trigger spmsext variables into the appropriate shandlerect types
        List<StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.newList;
        Map<ID, StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.newMap;
        //This is where you should call your business logic

		manageAgreements(null, newStudProgMonthlyStatusMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StudProgMonthlyStatusTriggerHandler.onAfterUpdate()');
        //Recast the trigger spmsext variables into the appropriate shandlerect types
        List<StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.newList;
        List<StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.oldList;
        Map<ID, StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.newMap;
        Map<ID, StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.oldMap;
        //This is where you should call your business logic

		manageAgreements(oldStudProgMonthlyStatusMap, newStudProgMonthlyStatusMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('StudProgMonthlyStatusTriggerHandler.onAfterDelete()');
        //Recast the trigger spmsext variables into the appropriate shandlerect types
        List<StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.oldList;
        Map<ID, StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('StudProgMonthlyStatusTriggerHandler.onAfterUndelete()');
        //Recast the trigger spmsext variables into the appropriate shandlerect types
        List<StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusList = (List<StudentProgramMonthlyStatus__c>)tc.newList;
        Map<ID, StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusMap = (Map<ID, StudentProgramMonthlyStatus__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusList){
system.debug('StudProgMonthlyStatusTriggerHandler.setDefaultsOnInsert()');
        for(StudentProgramMonthlyStatus__c spms : newStudProgMonthlyStatusList){
            if(spms.Activity__c == 'Payment'){
                spms.CountAsPaymentTerm__c = true;
                spms.CountAsGrace__c = false;
                spms.CountAsDeferment__c = false;
            } 
            if(spms.Activity__c == 'Grace'){
                spms.CountAsPaymentTerm__c = false;
                spms.CountAsGrace__c = true;
                spms.CountAsDeferment__c = false;
            } 
            if(spms.Activity__c == 'Deferment'){
                spms.CountAsPaymentTerm__c = false;
                spms.CountAsGrace__c = false;
                spms.CountAsDeferment__c = true;
            }     
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusMap, Map<ID, StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusMap){
system.debug('StudProgMonthlyStatusTriggerHandler.setDefaultsOnUpdate()'); 
        for(StudentProgramMonthlyStatus__c spms : newStudProgMonthlyStatusMap.values()){
            if(spms.Activity__c == 'Payment' && oldStudProgMonthlyStatusMap.get(spms.id).Activity__c != 'Payment'){
                spms.CountAsPaymentTerm__c = true;
                spms.CountAsGrace__c = false;
                spms.CountAsDeferment__c = false;
            } 
            if(spms.Activity__c == 'Grace' && oldStudProgMonthlyStatusMap.get(spms.id).Activity__c != 'Grace'){
                spms.CountAsPaymentTerm__c = false;
                spms.CountAsGrace__c = true;
                spms.CountAsDeferment__c = false;
            } 
            if(spms.Activity__c == 'Deferment' && oldStudProgMonthlyStatusMap.get(spms.id).Activity__c != 'Deferment'){
                spms.CountAsPaymentTerm__c = false;
                spms.CountAsGrace__c = false;
                spms.CountAsDeferment__c = true;
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: manageAgreements
    /////////////////////////////////////////////////////////////////////////
    private void manageAgreements(Map<ID, StudentProgramMonthlyStatus__c> oldStudProgMonthlyStatusMap, Map<ID, StudentProgramMonthlyStatus__c> newStudProgMonthlyStatusMap){
    	Map<ID, List<StudentProgramMonthlyStatus__c>> spmsByAgreement = new Map<ID, List<StudentProgramMonthlyStatus__c>>();
    	Set<ID> agreementIDs = new Set<ID>();
    	for(StudentProgramMonthlyStatus__c spms : newStudProgMonthlyStatusMap.values()){
    		agreementIDs.add(spms.Agreement__c);
    	}

    	//move this to query layer?
    	List<StudentProgramMonthlyStatus__c> allSPMS = [SELECT id, Agreement__c, Activity__c, Month__c, Year__c, CountAsPaymentTerm__c, CountAsGrace__c, CountAsDeferment__c
    													FROM StudentProgramMonthlyStatus__c
    													WHERE Agreement__c IN :agreementIDs];

    	for(StudentProgramMonthlyStatus__c spms : allSPMS){
    		if(!spmsByAgreement.containsKey(spms.Agreement__c)){
    			spmsByAgreement.put(spms.Agreement__c, new List<StudentProgramMonthlyStatus__c>());
    		}
    		spmsByAgreement.get(spms.Agreement__c).add(spms);
    	}

    	List<StudentProgram__c> agreementsToUpdate = new List<StudentProgram__c>();
    	//Loop through and summarize for each 
    	for(ID agreementID : spmsByAgreement.keySet()){
    		Integer totalGrace = 0;
    		Integer totalDeferment = 0;
            Integer totalPayment = 0;
    		for(StudentProgramMonthlyStatus__c spms : spmsByAgreement.get(agreementID)){
    			if(spms.CountAsGrace__c == true) totalGrace += 1;
    			if(spms.CountAsDeferment__c == true) totalDeferment += 1;
                if(spms.CountAsPaymentTerm__c == true) totalPayment += 1;
    		}
    		agreementsToUpdate.add(new StudentProgram__c(id = agreementID,
    														GraceMonthsUsed__c = totalGrace,
    														DefermentMonthsUsed__c = totalDeferment,
                                                            PaymentTermAssessed__c = totalPayment));
    	}
    	if(agreementsToUpdate.size()>0){
    		update agreementsToUpdate;
    	}
    }
    public class StudProgMonthlyStatusTriggerHandlerException extends Exception {}
}