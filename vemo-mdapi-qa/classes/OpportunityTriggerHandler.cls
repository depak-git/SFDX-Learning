/////////////////////////////////////////////////////////////////////////
// Class: OpportunityTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class OpportunityTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

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
            
        if(tc.handler == 'OpportunityTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.TriggerContext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'OpportunityTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'OpportunityTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'OpportunityTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.TriggerContext tc){
system.debug('OpportunityTriggerHandler.onBeforeInsert()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Opportunity> newOpportunityList = (List<Opportunity>)tc.newList;
        //This is where you should call your business logic


    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.TriggerContext tc){
system.debug('OpportunityTriggerHandler.onBeforeUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Opportunity> newOpportunityList = (List<Opportunity>)tc.newList;
        List<Opportunity> oldOpportunityList = (List<Opportunity>)tc.oldList;
        Map<ID, Opportunity> newOpportunityMap = (Map<ID, Opportunity>)tc.newMap;
        Map<ID, Opportunity> oldOpportunityMap = (Map<ID, Opportunity>)tc.oldMap;
        //This is where you should call your business logic
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.TriggerContext tc){
system.debug('OpportunityTriggerHandler.onBeforeDelete()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Opportunity> oldOpportunityList = (List<Opportunity>)tc.oldList;
        Map<ID, Opportunity> oldOpportunityMap = (Map<ID, Opportunity>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.TriggerContext tc){
system.debug('OpportunityTriggerHandler.onAfterInsert()');
         //Recast the trigger context variables into the appropriate shandlerect types
        List<Opportunity> newOpportunityList = (List<Opportunity>)tc.newList;
        Map<ID, Opportunity> newOpportunityMap = (Map<ID, Opportunity>)tc.newMap;
        //This is where you should call your business logic
		setDefaultsOnInsert(newOpportunityList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.TriggerContext tc){
system.debug('OpportunityTriggerHandler.onAfterUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Opportunity> newOpportunityList = (List<Opportunity>)tc.newList;
        List<Opportunity> oldOpportunityList = (List<Opportunity>)tc.oldList;
        Map<ID, Opportunity> newOpportunityMap = (Map<ID, Opportunity>)tc.newMap;
        Map<ID, Opportunity> oldOpportunityMap = (Map<ID, Opportunity>)tc.oldMap;
        //This is where you should call your business logic
		setDefaultsOnUpdate(oldOpportunityMap, newOpportunityMap);

		createCaseForClosedWon(oldOpportunityMap, newOpportunityMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.TriggerContext tc){
system.debug('OpportunityTriggerHandler.onAfterDelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Opportunity> oldOpportunityList = (List<Opportunity>)tc.oldList;
        Map<ID, Opportunity> oldOpportunityMap = (Map<ID, Opportunity>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.TriggerContext tc){
system.debug('OpportunityTriggerHandler.onAfterUndelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Opportunity> newOpportunityList = (List<Opportunity>)tc.newList;
        Map<ID, Opportunity> newOpportunityMap = (Map<ID, Opportunity>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Opportunity> newOpportunityList){
system.debug('OpportunityTriggerHandler.setDefaultsOnInsert()');
        for(Opportunity opp : newOpportunityList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> newOpportunityMap){
system.debug('OpportunityTriggerHandler.setDefaultsOnUpdate()'); 
        for(Opportunity opp : newOpportunityMap.values()){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createOriginationCaseForClosedWon
    /////////////////////////////////////////////////////////////////////////
    private void createCaseForClosedWon(Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> newOpportunityMap){
system.debug('OpportunityTriggerHandler.setDefaultsOnUpdate()');
		List<Case> casesToCreate = new List<Case>(); 
        for(Opportunity opp : newOpportunityMap.values()){
        	if((opp.StageName == 'Closed Won') && (oldOpportunityMap.get(opp.id).StageName != opp.StageName)){
        		casesToCreate.add(new Case(Type='Onboarding',
        								   Origin='Opportunity',
        								   Priority='Medium',
        								   Status='New',
        								   Subject='Onboard New Account',
        								   //ContactID='',
        								   AccountId=opp.AccountId,
        								   OwnerId=GlobalUtil.getQueueId(GlobalSettings.getSettings().closedWonCaseQueue),
        								   Description='Opportunity Closed Won Automatic Onboarding',
        								   RecordTypeID=GlobalUtil.getRecordTypeIDByLabelName('Case', 'Origination'),
        								   Reason='Reason'));
        	}
        }
        if(casesToCreate.size()>0){
        	insert casesToCreate;
        }
    }    
    public class OpportunityTriggerHandlerException extends Exception {}
}