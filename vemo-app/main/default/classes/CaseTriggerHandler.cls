/////////////////////////////////////////////////////////////////////////
// Class: CaseTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-02-14   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class CaseTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State cserol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution cserol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'CaseTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'CaseTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'CaseTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'CaseTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
		System.debug('CaseTriggerHandler.onBeforeInsert()');
       //Recast the trigger cseext variables into the appropriate shandlerect types
        List<Case> newCaseList = (List<Case>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newCaseList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
		System.debug('CaseTriggerHandler.onBeforeUpdate()');
        //Recast the trigger cseext variables into the appropriate shandlerect types
        List<Case> newCaseList = (List<Case>)tc.newList;
        List<Case> oldCaseList = (List<Case>)tc.oldList;
        Map<ID, Case> newCaseMap = (Map<ID, Case>)tc.newMap;
        Map<ID, Case> oldCaseMap = (Map<ID, Case>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldCaseMap, newCaseMap); 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
		System.debug('CaseTriggerHandler.onBeforeDelete()');
       //Recast the trigger cseext variables into the appropriate shandlerect types
        List<Case> oldCaseList = (List<Case>)tc.oldList;
        Map<ID, Case> oldCaseMap = (Map<ID, Case>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
		System.debug('CaseTriggerHandler.onAfterInsert()');
         //Recast the trigger cseext variables into the appropriate shandlerect types
        List<Case> newCaseList = (List<Case>)tc.newList;
        Map<ID, Case> newCaseMap = (Map<ID, Case>)tc.newMap;
        //This is where you should call your business logic

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
		System.debug('CaseTriggerHandler.onAfterUpdate()');
        //Recast the trigger cseext variables into the appropriate shandlerect types
        List<Case> newCaseList = (List<Case>)tc.newList;
        List<Case> oldCaseList = (List<Case>)tc.oldList;
        Map<ID, Case> newCaseMap = (Map<ID, Case>)tc.newMap;
        Map<ID, Case> oldCaseMap = (Map<ID, Case>)tc.oldMap;
        //This is where you should call your business logic

		manageAgreements(oldCaseMap, newCaseMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
		System.debug('CaseTriggerHandler.onAfterDelete()');
        //Recast the trigger cseext variables into the appropriate shandlerect types
        List<Case> oldCaseList = (List<Case>)tc.oldList;
        Map<ID, Case> oldCaseMap = (Map<ID, Case>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
		System.debug('CaseTriggerHandler.onAfterUndelete()');
        //Recast the trigger cseext variables into the appropriate shandlerect types
        List<Case> newCaseList = (List<Case>)tc.newList;
        Map<ID, Case> newCaseMap = (Map<ID, Case>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Case> newCaseList){
		System.debug('CaseTriggerHandler.setDefaultsOnInsert()');
        for(Case cse : newCaseList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Case> oldCaseMap, Map<ID, Case> newCaseMap){
		System.debug('CaseTriggerHandler.setDefaultsOnUpdate()'); 
        for(Case cse : newCaseMap.values()){
            if(cse.CertificationProcess__c == 'Certified' && oldCaseMap.get(cse.id).CertificationProcess__c != 'Certified'){
                cse.Status = 'School Certified';
            }
            if(cse.CertificationProcess__c == 'Cancelled' && oldCaseMap.get(cse.id).CertificationProcess__c != 'Cancelled'){
                cse.Status = 'School Cancelled';
            }
            if(cse.Status == 'School Certified' && !cse.CertificationChanges__c){
                cse.Status = 'Certified';
            }
            if(cse.Status == 'School Cancelled'){
                cse.Status = 'Cancelled';
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageAgreements
    /////////////////////////////////////////////////////////////////////////
    private void manageAgreements(Map<ID, Case> oldCaseMap, Map<ID, Case> newCaseMap){
        System.debug('CaseTriggerHandler.setPendingFields()'); 
        Map<ID, StudentProgram__c> agreementMap = new Map<ID, StudentProgram__c>();
        Map<ID, Account> studentMap = new Map<ID, Account>();
        for(Case cse : newCaseMap.values()){
            if(cse.Status == 'Certified' && oldCaseMap.get(cse.id).Status != 'Certified'){
                agreementMap.put(cse.Agreement__c, new StudentProgram__c(id = cse.Agreement__c,
                                                                         Status__c = 'Certified',
                                                                         GradeLevel__c = cse.CertifiedGradeLevel__c,
                                                                         SchoolProgramOfStudy__c = cse.CertifiedSchoolProgramOfStudy__c,
                                                                         EnrollmentStatus__c = cse.CertifiedEnrollmentStatus__c,
                                                                         ExpectedGraduationDate__c = cse.CertifiedExpectedGraduationDate__c,
                                                                         Residency__c = cse.CertifiedResidency__c,
                                                                         AllocatedAmount__c = cse.CertifiedAllocatedAmount__c,
                                                                         IncomeShare__c = cse.CertifiedIncomeShare__c,
                                                                         PaymentTerm__c = cse.CertifiedPaymentTerm__c,
                                                                         PaymentCap__c = cse.CertifiedPaymentCap__c));
                studentMap.put(cse.AccountId, new Account(id = cse.AccountId,
                                                          PrimarySchoolGradeLevel__pc = cse.CertifiedGradeLevel__c,
                                                          PrimarySchoolEnrollmentStatus__pc = cse.CertifiedEnrollmentStatus__c,
                                                          PrimarySchoolGraduationDate__pc = cse.CertifiedExpectedGraduationDate__c,
                                                          SchoolProgramOfStudy__pc = cse.CertifiedSchoolProgramOfStudy__c,
                                                          Residency__pc = cse.CertifiedResidency__c,
                                                          BypassApproval__c = true));
            }
            if(cse.Status == 'Cancelled' && oldCaseMap.get(cse.id).Status != 'Cancelled'){
                agreementMap.put(cse.Agreement__c, new StudentProgram__c(id = cse.Agreement__c,
                                                                         Status__c = 'Cancelled',
                                                                         CancellationReason__c = 'Ineligible',
                                                                         EligibleToReapply__c = cse.CertifiedEligibleToReapply__c));
            }
        }

        if(agreementMap.size()>0){
            Database.SaveResult[] srList = Database.update(agreementMap.values(), false);

            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated agreement. StudentProgram__c ID: ' + sr.getId());
                }
                else {
                    for(Case cse : newCaseMap.values()){
                        cse.addError(sr.getErrors()[0].getMessage());
                    }
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {

                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        //throw new CaseTriggerHandlerException('error'+sr);
                    }
                }
            }
        }
        if(studentMap.size()>0){
            update studentMap.values();
        }
    }
 /*   /////////////////////////////////////////////////////////////////////////
    //Method: manageShares
    /////////////////////////////////////////////////////////////////////////
    private void manageShares(Map<ID, Case> newCaseMap){
        System.debug('CaseTriggerHandler.manageShares()');
        List<AccountShare> acctShares = new List<AccountShare>();
        List<ID> schoolIDs = new List<ID>();
        for(Case cse : newCaseMap.values()){
            if(cse.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Case', 'Certification')){
                //share the school account with the portal users
                //not bulk safe!!
                List<User> schoolPortalUsers = [SELECT id from User where accountID = :cse.School__c];
                for (User usr : schoolPortalUsers){
                    acctShares.add(new AccountShare(AccountAccessLevel = 'Edit',
                                                      AccountID = cse.AccountID,
                                                      CaseAccessLevel = 'Edit',
            //                                        ContactAccessLevel = 'None',
                                                      OpportunityAccessLevel = 'None',
            //                                        RowCause = 'Apex',
                                                      UserOrGroupID = usr.id));

                }
            }
        }
        if(acctShares.size()>0){
            insert acctShares;
        }
    }
*/

    public class CaseTriggerHandlerException extends Exception {}
}