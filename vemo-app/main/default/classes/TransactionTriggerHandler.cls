/////////////////////////////////////////////////////////////////////////
// Class: TransactionTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-29   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class TransactionTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State Control Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    public static Boolean manageTransactionsHasRun = false;

    /**************************Constructors**********************************************/
    
    /**************************Execution Control - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.TriggerContext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'TransactionTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.TriggerContext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'TransactionTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'TransactionTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'TransactionTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionTriggerHandler.onBeforeInsert()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Transaction__c> newTransactionList = (List<Transaction__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newTransactionList);
        validateProgramRules(newTransactionList);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionTriggerHandler.onBeforeUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Transaction__c> newTransactionList = (List<Transaction__c>)tc.newList;
        List<Transaction__c> oldTransactionList = (List<Transaction__c>)tc.oldList;
        Map<ID, Transaction__c> newTransactionMap = (Map<ID, Transaction__c>)tc.newMap;
        Map<ID, Transaction__c> oldTransactionMap = (Map<ID, Transaction__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldTransactionMap, newTransactionMap); 
        validateProgramRules(newTransactionList);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionTriggerHandler.onBeforeDelete()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Transaction__c> oldTransactionList = (List<Transaction__c>)tc.oldList;
        Map<ID, Transaction__c> oldTransactionMap = (Map<ID, Transaction__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionTriggerHandler.onAfterInsert()');
         //Recast the trigger context variables into the appropriate shandlerect types
        List<Transaction__c> newTransactionList = (List<Transaction__c>)tc.newList;
        Map<ID, Transaction__c> newTransactionMap = (Map<ID, Transaction__c>)tc.newMap;
        //This is where you should call your business logic
 		manageAgreements(null, newTransactionMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionTriggerHandler.onAfterUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Transaction__c> newTransactionList = (List<Transaction__c>)tc.newList;
        List<Transaction__c> oldTransactionList = (List<Transaction__c>)tc.oldList;
        Map<ID, Transaction__c> newTransactionMap = (Map<ID, Transaction__c>)tc.newMap;
        Map<ID, Transaction__c> oldTransactionMap = (Map<ID, Transaction__c>)tc.oldMap;
        //This is where you should call your business logic
 		manageAgreements(oldTransactionMap, newTransactionMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionTriggerHandler.onAfterDelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Transaction__c> oldTransactionList = (List<Transaction__c>)tc.oldList;
        Map<ID, Transaction__c> oldTransactionMap = (Map<ID, Transaction__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionTriggerHandler.onAfterUndelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Transaction__c> newTransactionList = (List<Transaction__c>)tc.newList;
        Map<ID, Transaction__c> newTransactionMap = (Map<ID, Transaction__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Transaction__c> newTransactionList){
		System.debug('TransactionTriggerHandler.setDefaultsOnInsert()');
        Set<ID> studentIDs = new Set<ID>();
        Set<ID> agreementIDs = new Set<ID>();
        for(Transaction__c tx: newTransactionList){
            agreementIDs.add(tx.Agreement__c);
            studentIDs.add(tx.Student__c);

        }
        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
        Map<ID, StudentProgram__c> studentProgramMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
        for(Transaction__c tx: newTransactionList){
            if(tx.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRecType)){
                if(String.isBlank(tx.NotificationEmail__c)) tx.NotificationEmail__c = studentMap.get(tx.Student__c).PersonEmail;
                if(String.isBlank(tx.SchoolSecurity__c)) tx.SchoolSecurity__c = studentProgramMap.get(tx.Agreement__c).Program__r.School__r.SchoolSecurity__c;
            }
            studentIDs.add(tx.Student__c);
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Transaction__c> oldTransactionMap, Map<ID, Transaction__c> newTransactionMap){
		System.debug('TransactionTriggerHandler.setDefaultsOnUpdate()'); 
        Set<ID> studentIDs = new Set<ID>();
        Set<ID> agreementIDs = new Set<ID>();        
        for(Transaction__c tx: newTransactionMap.values()){
            agreementIDs.add(tx.Agreement__c);
            studentIDs.add(tx.Student__c);

        }
        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
        Map<ID, StudentProgram__c> studentProgramMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
        for(Transaction__c tx: newTransactionMap.values()){
            if(tx.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRecType)){
                if(String.isBlank(tx.NotificationEmail__c)) tx.NotificationEmail__c = studentMap.get(tx.Student__c).PersonEmail;
                if(String.isBlank(tx.SchoolSecurity__c)) tx.SchoolSecurity__c = studentProgramMap.get(tx.Agreement__c).Program__r.School__r.SchoolSecurity__c;
            }
            studentIDs.add(tx.Student__c);
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: validateProgramRules
    /////////////////////////////////////////////////////////////////////////
    private void validateProgramRules(List<Transaction__c> newTransactionList){
        Set<ID> programIDs = new Set<ID>();
        for(Transaction__c disb : newTransactionList){
            programIDs.add(disb.ProgramID__c);
        }
        Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(programIds);

        for(Transaction__c disb : newTransactionList){
            //Validate Program Rules for this Disbursement Record
            if(programMap.containsKey(disb.ProgramID__c)){
                if(String.isNotEmpty(disb.SpecialDisbursementType__c)){
                    try{
                        if(!programMap.get(disb.ProgramID__c).AllowedSpecialDisbursementTypes__c.contains(disb.SpecialDisbursementType__c)){
                            disb.addError('This Special Disbursement Type is not allowed by this program');
                        }
                    } catch (Exception e) {
                        disb.addError('This Special Disbursement Type is not allowed by this program');                        
                    }

                }
            }
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageAgreements
    /////////////////////////////////////////////////////////////////////////
    private void manageAgreements(Map<ID, Transaction__c> oldTransactionMap, Map<ID, Transaction__c> newTransactionMap){
        System.debug('TransactionTriggerHandler.manageAgreements()'); 
        Map<ID, StudentProgram__c> agreementsToUpdate = new Map<ID, StudentProgram__c>();
        Set<ID> agreementIDs = new Set<ID>();
        for(Transaction__c tx:newTransactionMap.values()){
            if(String.isNotEmpty(tx.Agreement__c)) agreementIDs.add(tx.Agreement__c);
        }
        //Get Disbursements by Agreement
        Map<ID, List<Transaction__c>> disbursementsByAgreement = TransactionQueries.getTransactionMapByAgreementWithAgreementID(agreementIDs, TransactionService.disbursementRecType);
/*        for(Transaction__c tx : newTransactionMap.values()){
            if(tx.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRecType)){
                if(String.isNotEmpty(tx.Agreement__c)){
                    if(!disbursementsByAgreement.containsKey(tx.Agreement__c)){
                        disbursementsByAgreement.put(tx.Agreement__c, new List<Transaction__c>());
                    }
                    disbursementsByAgreement.get(tx.Agreement__c).add(tx);
                }
            }
        }*/
//        System.debug(disbursementsByAgreement);
        for(ID studProgID : disbursementsByAgreement.keySet()){
//            System.debug(disbursementsByAgreement.get(studProgID));
//            Boolean partiallyFunded = false;
//            Boolean notFullyFunded = false;

/*            for(Transaction__c tx : disbursementsByAgreement.get(studProgID)){
                System.debug('tx:'+tx);
                if(tx.Status__c == 'Complete' && tx.Confirmed__c){
                    partiallyFunded = true;
                } else {
                    notFullyFunded = true;
                }
                ifDay
            }
            if(!notFullyFunded){
                agreementsToUpdate.put(studProgID, new StudentProgram__c(id = studProgID,
                                                                         Status__c = 'Fully Funded'));
            } else if(partiallyFunded){   
                agreementsToUpdate.put(studProgID, new StudentProgram__c(id = studProgID,
                                                                         Status__c = 'Partially Funded'));
            }
            System.debug('partiallyFunded:'+partiallyFunded);
            System.debug('notFullyFunded:'+notFullyFunded);*/

            if(disbursementsByAgreement.containsKey(studProgID)){
                //Find the earliest disbursement date in the list of disgbursements
                Date earliestDate;
                for(Transaction__c disb : disbursementsByAgreement.get(studProgID)){
                    if(disb.TransactionDate__c < earliestDate || earliestDate == null) earliestDate = disb.TransactionDate__c;
                }
                //Set the Day Prior to First Disbursement
                agreementsToUpdate.put(studProgID, new StudentProgram__c(id= studProgID,
                                                                          DayPriorToFirstDisbursement__c = earliestDate.addDays(-1)));
            }    
        } 
             
        if(agreementsToUpdate.size()>0){
            update agreementsToUpdate.values();
        }
    }

    public class TransactionTriggerHandlerException extends Exception {}
}