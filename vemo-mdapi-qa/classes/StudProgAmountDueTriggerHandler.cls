/////////////////////////////////////////////////////////////////////////
// Class: StudProgAmountDueTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-04   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class StudProgAmountDueTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

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
            
        if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StudProgAmountDueTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'StudProgAmountDueTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('StudProgAmountDueTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<StudentProgramAmountDue__c> newStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.newList;
        //This is where you should call your business logic


    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StudProgAmountDueTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<StudentProgramAmountDue__c> newStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.newList;
        List<StudentProgramAmountDue__c> oldStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.oldList;
        Map<ID, StudentProgramAmountDue__c> newStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.newMap;
        Map<ID, StudentProgramAmountDue__c> oldStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.oldMap;
        //This is where you should call your business logic
 
        //setPendingFields(oldStudProgAmountDueMap, newStudProgAmountDueMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('StudProgAmountDueTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<StudentProgramAmountDue__c> oldStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.oldList;
        Map<ID, StudentProgramAmountDue__c> oldStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('StudProgAmountDueTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<StudentProgramAmountDue__c> newStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.newList;
        Map<ID, StudentProgramAmountDue__c> newStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.newMap;
        //This is where you should call your business logic
		setDefaultsOnInsert(newStudProgAmountDueList);
		manageAgreements(null, newStudProgAmountDueMap);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('StudProgAmountDueTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<StudentProgramAmountDue__c> newStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.newList;
        List<StudentProgramAmountDue__c> oldStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.oldList;
        Map<ID, StudentProgramAmountDue__c> newStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.newMap;
        Map<ID, StudentProgramAmountDue__c> oldStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.oldMap;
        //This is where you should call your business logic
		setDefaultsOnUpdate(oldStudProgAmountDueMap, newStudProgAmountDueMap);
		manageAgreements(oldStudProgAmountDueMap, newStudProgAmountDueMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('StudProgAmountDueTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<StudentProgramAmountDue__c> oldStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.oldList;
        Map<ID, StudentProgramAmountDue__c> oldStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.oldMap;
        //This is where you should call your business logic
		manageAgreements(oldStudProgAmountDueMap, null);
     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('StudProgAmountDueTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<StudentProgramAmountDue__c> newStudProgAmountDueList = (List<StudentProgramAmountDue__c>)tc.newList;
        Map<ID, StudentProgramAmountDue__c> newStudProgAmountDueMap = (Map<ID, StudentProgramAmountDue__c>)tc.newMap;
        //This is where you should call your business logic
		manageAgreements(null, newStudProgAmountDueMap);        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<StudentProgramAmountDue__c> newStudProgAmountDueList){
system.debug('StudProgAmountDueTriggerHandler.setDefaultsOnInsert()');
        for(StudentProgramAmountDue__c spad : newStudProgAmountDueList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, StudentProgramAmountDue__c> oldStudProgAmountDueMap, Map<ID, StudentProgramAmountDue__c> newStudProgAmountDueMap){
system.debug('StudProgAmountDueTriggerHandler.setDefaultsOnUpdate()'); 
        for(StudentProgramAmountDue__c spad : newStudProgAmountDueMap.values()){

        }
    }

    public static void manageAgreements(Map<ID, StudentProgramAmountDue__c> oldStudProgAmountDueMap, Map<ID, StudentProgramAmountDue__c> newStudProgAmountDueMap){
    	Map<ID, List<StudentProgramAmountDue__c>> amountDueByAgreement = new Map<ID, List<StudentProgramAmountDue__c>>();
    	Set<ID> agreementIDs = new Set<ID>();
    	List<StudentProgramAmountDue__c> amountDueToAssess = ((newStudProgAmountDueMap != null) ? newStudProgAmountDueMap.values() : oldStudProgAmountDueMap.values());
    	for(StudentProgramAmountDue__c spad : amountDueToAssess){
    		agreementIDs.add(spad.Agreement__c);
    	}

    	System.debug(agreementIDs);

    	//move to query layer?
    	List<StudentProgramAmountDue__c> allAmountDue = [SELECT id, Amount__c, Type__c, Agreement__c, ExcludeFromBalance__c
    												 FROM StudentProgramAmountDue__c
    												 WHERE Agreement__c IN :agreementIDs];
        System.debug('Number of StudentProgramAmountDue = ' + allAmountDue.size());
    	for(StudentProgramAmountDue__c spad : allAmountDue){
    		if(!amountDueByAgreement.containsKey(spad.Agreement__c)){
    			amountDueByAgreement.put(spad.Agreement__c, new List<StudentProgramAmountDue__c>());
    		}
    		amountDueByAgreement.get(spad.Agreement__c).add(spad);
    	}

    	List<StudentProgram__c> agreementsToUpdate = new List<StudentProgram__c>();
    	
    	for(ID agreementID : agreementIDs){
    		Decimal totalAmountDue = 0;
            Decimal totalReconciliationDue = 0;
            Decimal totalMonthlyAmountDue = 0;
    		if(amountDueByAgreement.containsKey(agreementID)){
	    		for(StudentProgramAmountDue__c spad : amountDueByAgreement.get(agreementID)){
	    			if(!spad.ExcludeFromBalance__c) totalAmountDue += spad.Amount__c;
                    if(spad.Type__c == 'Monthly Amount' && !spad.ExcludeFromBalance__c) totalMonthlyAmountDue += spad.Amount__c;
                    if(spad.Type__c == 'Reconciliation' && !spad.ExcludeFromBalance__c) totalReconciliationDue += spad.Amount__c;
	    		}    			
    		}

    		agreementsToUpdate.add(new StudentProgram__c(id = agreementID,
                                                            AmountDueToDate__c = totalAmountDue,
                                                            ReconciliationDueToDate__c = totalReconciliationDue,
                                                            MonthlyAmountDueToDate__c = totalMonthlyAmountDue));
    	}
    	if(agreementsToUpdate.size()>0){
    		update agreementsToUpdate;
    	}
    }


    public class StudProgAmountDueTriggerHandlerException extends Exception {}
}