/////////////////////////////////////////////////////////////////////////
// Class: ProgramTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-09   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class ProgramTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State Control Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;

    /**************************Constructors**********************************************/
    
    /**************************Execution Control - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.TriggerContext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'ProgramTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.TriggerContext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'ProgramTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'ProgramTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'ProgramTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.TriggerContext tc){
system.debug('ProgramTriggerHandler.onBeforeInsert()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Program__c> newProgramList = (List<Program__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newProgramList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.TriggerContext tc){
system.debug('ProgramTriggerHandler.onBeforeUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Program__c> newProgramList = (List<Program__c>)tc.newList;
        List<Program__c> oldProgramList = (List<Program__c>)tc.oldList;
        Map<ID, Program__c> newProgramMap = (Map<ID, Program__c>)tc.newMap;
        Map<ID, Program__c> oldProgramMap = (Map<ID, Program__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldProgramMap, newProgramMap); 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.TriggerContext tc){
system.debug('ProgramTriggerHandler.onBeforeDelete()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Program__c> oldProgramList = (List<Program__c>)tc.oldList;
        Map<ID, Program__c> oldProgramMap = (Map<ID, Program__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.TriggerContext tc){
system.debug('ProgramTriggerHandler.onAfterInsert()');
         //Recast the trigger context variables into the appropriate shandlerect types
        List<Program__c> newProgramList = (List<Program__c>)tc.newList;
        Map<ID, Program__c> newProgramMap = (Map<ID, Program__c>)tc.newMap;
        //This is where you should call your business logic

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.TriggerContext tc){
system.debug('ProgramTriggerHandler.onAfterUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Program__c> newProgramList = (List<Program__c>)tc.newList;
        List<Program__c> oldProgramList = (List<Program__c>)tc.oldList;
        Map<ID, Program__c> newProgramMap = (Map<ID, Program__c>)tc.newMap;
        Map<ID, Program__c> oldProgramMap = (Map<ID, Program__c>)tc.oldMap;
        //This is where you should call your business logic

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.TriggerContext tc){
system.debug('ProgramTriggerHandler.onAfterDelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Program__c> oldProgramList = (List<Program__c>)tc.oldList;
        Map<ID, Program__c> oldProgramMap = (Map<ID, Program__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.TriggerContext tc){
system.debug('ProgramTriggerHandler.onAfterUndelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Program__c> newProgramList = (List<Program__c>)tc.newList;
        Map<ID, Program__c> newProgramMap = (Map<ID, Program__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Program__c> newProgramList){
system.debug('ProgramTriggerHandler.setDefaultsOnInsert()');
        for(Program__c program: newProgramList){
        	if(program.AgeOfMajorityRequired__c) program.AgeOfMajorityCollected__c = true;
        	if(program.SchoolProgramOfStudyRequired__c) program.SchoolProgramOfStudyCollected__c = true;
        	if(program.GradeLevelRequired__c) program.GradeLevelCollected__c = true;
        	if(program.EnrollmentStatusRequired__c) program.EnrollmentStatusCollected__c = true;
        	if(program.ResidencyRequired__c) program.ResidencyCollected__c = true;
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Program__c> oldProgramMap, Map<ID, Program__c> newProgramMap){
system.debug('ProgramTriggerHandler.setDefaultsOnUpdate()'); 
        for(Program__c program: newProgramMap.values()){
        	if(program.AgeOfMajorityRequired__c) program.AgeOfMajorityCollected__c = true;
        	if(program.SchoolProgramOfStudyRequired__c) program.SchoolProgramOfStudyCollected__c = true;
        	if(program.GradeLevelRequired__c) program.GradeLevelCollected__c = true;
        	if(program.EnrollmentStatusRequired__c) program.EnrollmentStatusCollected__c = true;
        	if(program.ResidencyRequired__c) program.ResidencyCollected__c = true;
        }
    }

    public class ProgramTriggerHandlerException extends Exception {}
}