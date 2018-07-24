/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-06   Jared Hagemann  Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class IncomeVerificationTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {
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
            
        if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'IncomeVerificationTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'IncomeVerificationTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
    System.debug('IncomeVerificationTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<IncomeVerification__c> newIncomeVerificationList = (List<IncomeVerification__c>)tc.newList;
        //This is where you should call your business logic
    setDefaultsOnInsert(newIncomeVerificationList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
    System.debug('IncomeVerificationTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<IncomeVerification__c> newIncomeVerificationList = (List<IncomeVerification__c>)tc.newList;
        List<IncomeVerification__c> oldIncomeVerificationList = (List<IncomeVerification__c>)tc.oldList;
        Map<ID, IncomeVerification__c> newIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.newMap;
        Map<ID, IncomeVerification__c> oldIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.oldMap;
        //This is where you should call your business logic
        
    setDefaultsOnUpdate(oldIncomeVerificationMap, newIncomeVerificationMap); 

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
    System.debug('IncomeVerificationTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<IncomeVerification__c> oldIncomeVerificationList = (List<IncomeVerification__c>)tc.oldList;
        Map<ID, IncomeVerification__c> oldIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
    System.debug('IncomeVerificationTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<IncomeVerification__c> newIncomeVerificationList = (List<IncomeVerification__c>)tc.newList;
        Map<ID, IncomeVerification__c> newIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.newMap;
        Map<ID, IncomeVerification__c> oldIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.oldMap;
        //This is where you should call your business logic
        verify(oldIncomeVerificationMap, newIncomeVerificationMap);
        
        Set<ID> studentIDs = new Set<ID>();
        for(IncomeVerification__c inc : newIncomeVerificationMap.values()){
            studentIDs.add(inc.Student__c);
        }
        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);  
             
        List<Case> casesToAdd = new List<Case>();
        for(IncomeVerification__c inc : newIncomeVerificationMap.values()){
            //if(!inc.Verified__c){
            if(inc.status__c != 'Verified'){
                        casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                                                ContactID = studentMap.get(inc.Student__c).PersonContactID,
                                                Subject = 'Unverified Income Created',
                                                Status = 'New',
                                                Priority = 'Medium',
                                                Reason = 'Other',
                                                OwnerId=GlobalUtil.getQueueId('Servicing'),
                                                Type = 'Other',                                     
                                                Origin = 'Other'));
            }
        }
        if(casesToAdd.size()>0) insert casesToAdd;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
    System.debug('IncomeVerificationTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<IncomeVerification__c> newIncomeVerificationList = (List<IncomeVerification__c>)tc.newList;
        List<IncomeVerification__c> oldIncomeVerificationList = (List<IncomeVerification__c>)tc.oldList;
        Map<ID, IncomeVerification__c> newIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.newMap;
        Map<ID, IncomeVerification__c> oldIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.oldMap;
        //This is where you should call your business logic
        verify(oldIncomeVerificationMap, newIncomeVerificationMap);

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
    System.debug('IncomeVerificationTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<IncomeVerification__c> oldIncomeVerificationList = (List<IncomeVerification__c>)tc.oldList;
        Map<ID, IncomeVerification__c> oldIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
    System.debug('IncomeVerificationTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<IncomeVerification__c> newIncomeVerificationList = (List<IncomeVerification__c>)tc.newList;
        Map<ID, IncomeVerification__c> newIncomeVerificationMap = (Map<ID, IncomeVerification__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<IncomeVerification__c> newIncomeVerificationList){
    System.debug('IncomeVerificationTriggerHandler.setDefaultsOnInsert()');
        for(IncomeVerification__c cc : newIncomeVerificationList){
            //setting the verified checkbox based on Status picklist
            if(cc.status__c == 'Verified') cc.Verified__c = true;
            else cc.Verified__c = false;
            
            if(cc.status__c == 'Verified' && cc.DateVerified__c == null){
                cc.DateVerified__c = System.today();
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, IncomeVerification__c> oldIncomeVerificationMap, Map<ID, IncomeVerification__c> newIncomeVerificationMap){
    System.debug('IncomeVerificationTriggerHandler.setDefaultsOnUpdate()'); 
        for(IncomeVerification__c cc : newIncomeVerificationMap.values()){
            //setting the verified checkbox based on Status picklist
            if(cc.status__c == 'Verified') cc.Verified__c = true;
            else cc.Verified__c = false;
            
            if(cc.status__c == 'Verified' && cc.DateVerified__c == null && oldIncomeVerificationMap.get(cc.id).status__c != 'Verified'){
                cc.DateVerified__c = System.today();
            }
        }
    }

    private void verify(Map<Id, IncomeVerification__c> oldIncomeVerificationMap, Map<Id, IncomeVerification__c> newIncomeVerificationMap){
      Set<Id> studentIds = new Set<Id>();
      Map<Id, IncomeVerification__c> newStudentRecentVerMap = new Map<Id, IncomeVerification__c>();
      for(IncomeVerification__c incVer : newIncomeVerificationMap.values()){
        if(incVer.status__c == 'Verified' && (Trigger.isInsert || (!Trigger.isInsert && oldIncomeVerificationMap.get(incVer.Id).status__c != 'Verified'))){

                if(incVer.DateVerified__c == null){
            //incVer.DateVerified__c = System.today();
          }
          newStudentRecentVerMap.put(incVer.Student__c, incVer);
        }
      }
      if(!newStudentRecentVerMap.keySet().isEmpty()){
        AggregateResult[] groupedResults = [SELECT Student__c, Max(DateVerified__c)
                          FROM IncomeVerification__c 
                          WHERE Student__c IN: newStudentRecentVerMap.keySet() AND Id NOT IN: newIncomeVerificationMap.keySet() AND DateVerified__c != null AND status__c = 'Verified'
                          GROUP BY Student__c];

      List<Account> studentsToUpdate = new List<Account>();                    
        for(AggregateResult ar : groupedResults){
          //check if verified income is most recent, if so update student record
          Id studId = (Id)ar.get('Student__c');
          Date verDate = (Date)ar.get('expr0');
          System.debug('**********studId = ' + studId);
          System.debug('**********verDate = ' + verDate);
          System.debug('newStudentRecentVerMap.get(studId) = ' + newStudentRecentVerMap.get(studId));
          if(newStudentRecentVerMap.get(studId).DateVerified__c > verDate){
            Account accnt = new Account();
            accnt.Id = studId;
            accnt.DateIncomeVerified__pc = newStudentRecentVerMap.get(studId).DateVerified__c;
            accnt.VerifiedAnnualIncome__pc = newStudentRecentVerMap.get(studId).IncomePerYear__c;
            studentsToUpdate.add(accnt);            
          }
          newStudentRecentVerMap.remove(studId);          
        }
        //first income verified for student
        for(Id studId : newStudentRecentVerMap.keySet()){
          Account accnt = new Account();
          accnt.Id = studId;
          accnt.DateIncomeVerified__pc = newStudentRecentVerMap.get(studId).DateVerified__c;
          accnt.VerifiedAnnualIncome__pc = newStudentRecentVerMap.get(studId).IncomePerYear__c;
          studentsToUpdate.add(accnt);  
        }
        if(!studentsToUpdate.isEmpty()){
          System.debug('Number of students to update = ' + studentsToUpdate.size());
          update studentsToUpdate;
        }
      }
    }


    public class CreditCheckTriggerHandlerException extends Exception {}
}