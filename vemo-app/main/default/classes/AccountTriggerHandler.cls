/////////////////////////////////////////////////////////////////////////
// Class: AccountTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class AccountTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State acctrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    public static Boolean manageStatementsHasRun = false;
    public static Boolean manageSchoolSecurityHasRun = false;
//    public static Boolean manageCasesHasRun = false;
//    public static Boolean manageAccountSharesHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution acctrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'AccountTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'AccountTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'AccountTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'AccountTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
system.debug('AccountTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<Account> newAccountList = (List<Account>)tc.newList;
        //This is where you should call your business logic


    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
system.debug('AccountTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<Account> newAccountList = (List<Account>)tc.newList;
        List<Account> oldAccountList = (List<Account>)tc.oldList;
        Map<ID, Account> newAccountMap = (Map<ID, Account>)tc.newMap;
        Map<ID, Account> oldAccountMap = (Map<ID, Account>)tc.oldMap;
        //This is where you should call your business logic
        summarizeIncomeShare(oldAccountMap, newAccountMap);
        //setPendingFields(oldAccountMap, newAccountMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
system.debug('AccountTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<Account> oldAccountList = (List<Account>)tc.oldList;
        Map<ID, Account> oldAccountMap = (Map<ID, Account>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
system.debug('AccountTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<Account> newAccountList = (List<Account>)tc.newList;
        Map<ID, Account> newAccountMap = (Map<ID, Account>)tc.newMap;
        //This is where you should call your business logic
        setDefaultsOnInsert(newAccountList);
        manageSchoolSecurity(null, newAccountMap);
//        manageAccountShares(null, newAccountMap);
        manageStewardship(null, newAccountMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
system.debug('AccountTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<Account> newAccountList = (List<Account>)tc.newList;
        List<Account> oldAccountList = (List<Account>)tc.oldList;
        Map<ID, Account> newAccountMap = (Map<ID, Account>)tc.newMap;
        Map<ID, Account> oldAccountMap = (Map<ID, Account>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldAccountMap, newAccountMap);
        shutOffRecurrance(oldAccountMap, newAccountMap);
        manageStatements(oldAccountMap,newAccountMap);
        manageSchoolSecurity(oldAccountMap, newAccountMap);
//        manageCases(oldAccountMap, newAccountMap);
//        manageAccountShares(oldAccountMap, newAccountMap);
        manageStewardship(oldAccountMap, newAccountMap);
        manageAccountEmail(oldAccountMap, newAccountMap);

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
system.debug('AccountTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<Account> oldAccountList = (List<Account>)tc.oldList;
        Map<ID, Account> oldAccountMap = (Map<ID, Account>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
system.debug('AccountTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<Account> newAccountList = (List<Account>)tc.newList;
        Map<ID, Account> newAccountMap = (Map<ID, Account>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Account> newAccountList){
system.debug('AccountTriggerHandler.setDefaultsOnInsert()');

        for(Account acct : newAccountList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
system.debug('AccountTriggerHandler.setDefaultsOnUpdate()'); 
        for(Account acct : newAccountMap.values()){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageStewardship
    /////////////////////////////////////////////////////////////////////////
    private void manageStewardship(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        Set<Id> paymentAcctIds = new Set<Id>();
        Set<Id> disbursementAcctIds = new Set<Id>();
        for(Account acct : newAccountMap.values()){
            if((oldAccountMap == null && acct.StewardshipProcess__c == 'Create Payment DonorGUID') ||
               (acct.StewardshipProcess__c == 'Create Payment DonorGUID' && acct.StewardshipProcess__c != oldAccountMap.get(acct.id).StewardshipProcess__c)){
                paymentAcctIds.add(acct.Id);
            }
            if((oldAccountMap == null && acct.StewardshipProcess__c == 'Create Disbursement DonorGUID') ||
               (acct.StewardshipProcess__c == 'Create Disbursement DonorGUID' && acct.StewardshipProcess__c != oldAccountMap.get(acct.id).StewardshipProcess__c)){
                disbursementAcctIds.add(acct.Id);
            }
            if((oldAccountMap == null && acct.StewardshipProcess__c == 'Create Both Disbursement & Payment DonorGUID') ||
               (acct.StewardshipProcess__c == 'Create Both Disbursement & Payment DonorGUID' && acct.StewardshipProcess__c != oldAccountMap.get(acct.id).StewardshipProcess__c)){
                paymentAcctIds.add(acct.Id);
                disbursementAcctIds.add(acct.Id);
            }
        }


        for(ID theID : paymentAcctIds){
            StewardshipTechService.CreateDonorRequest input = new StewardshipTechService.CreateDonorRequest();
            input.DonorID = theID;
            input.LastName = newAccountMap.get(theID).LastName;
            input.Street1 = newAccountMap.get(theID).PersonMailingStreet;
            input.City = newAccountMap.get(theID).PersonMailingCity;
            input.StateCode = newAccountMap.get(theID).PersonMailingStateCode;
            input.PostalCode = newAccountMap.get(theID).PersonMailingPostalCode;
            
            StewardshipTechService.CreateDonorQueueable job = new StewardshipTechService.CreateDonorQueueable();
            job.input = input;
            job.acctType = StewardshipTechService.AccountType.PAYMENT;
            System.enqueueJob(job);

        }

        for(ID theID : disbursementAcctIds){
            StewardshipTechService.CreateDonorRequest input = new StewardshipTechService.CreateDonorRequest();
            input.DonorID = theID;
            input.LastName = newAccountMap.get(theID).LastName;
            input.Street1 = newAccountMap.get(theID).PersonMailingStreet;
            input.City = newAccountMap.get(theID).PersonMailingCity;
            input.StateCode = newAccountMap.get(theID).PersonMailingStateCode;
            input.PostalCode = newAccountMap.get(theID).PersonMailingPostalCode;
            
            StewardshipTechService.CreateDonorQueueable job = new StewardshipTechService.CreateDonorQueueable();
            job.input = input;
            job.acctType = StewardshipTechService.AccountType.DISBURSEMENT;
            System.enqueueJob(job);

        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: shutOffRecurrance
    /////////////////////////////////////////////////////////////////////////
    private void shutOffRecurrance(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        Set<Id> acctIds = new Set<Id>();
        for(Account acct : newAccountMap.values()){
            if(!acct.AutoPayment__pc && oldAccountMap.get(acct.Id).AutoPayment__pc){
                acctIds.add(acct.Id);
            }
        }
        Map<Id, PaymentMethod__c> paymentMethodsMap = PaymentMethodQueries.getPaymentMethodMapWithCustomerID(acctIds);
        for(PaymentMethod__c pm : paymentMethodsMap.values()){
            pm.UseForRecurring__c = false;
        }
        update paymentMethodsMap.values();
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: summarizeIncomeShare
    /////////////////////////////////////////////////////////////////////////
    private void summarizeIncomeShare(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        Set<ID> studentIDs = new Set<ID>();
        for(Account acct : newAccountMap.values()){
            if(acct.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student') && acct.RecalculateCumulativeIncomeShare__pc){
                studentIDs.add(acct.id);
            }
        }
        Map<ID, StudentProgram__c> studentProgramMap = StudentProgramQueries.getStudentProgramMapWithStudentID(studentIDs);
        Map<ID, List<StudentProgram__c>> studentProgramsByStudentID = new Map<ID, List<StudentProgram__c>>();
        for(StudentProgram__c agreement : studentProgramMap.values()){
            if(!studentProgramsByStudentID.containsKey(agreement.Student__c)){
                studentProgramsByStudentID.put(agreement.Student__c, new List<StudentProgram__c>());
            }
            studentProgramsByStudentID.get(agreement.Student__c).add(agreement);
        }

        for(ID theID : studentIDs){
            Double cumulativeIncomeShare = 0;
            Double cumulativeIncomeShareCap;
            if(studentProgramsByStudentID.containsKey(theID)){
                for(StudentProgram__c agreement : studentProgramsByStudentID.get(theID)){
                    //Set<String> nonCalqStatus = new Set<String>{'Invited','Application Incomplete','Application Under Review', 'Cancelled', 'Contract Satisfied', 'Forgiven', 'Default'};
                    if(!StudentProgramTriggerHandler.cumulativeIncomeStatusExclusions.contains(agreement.Status__c) ){
                        cumulativeIncomeShare += (agreement.IncomeSharePostCertification__c == null ? 0 : agreement.IncomeSharePostCertification__c);
                        System.debug('cumulativeIncomeShareCap:'+cumulativeIncomeShareCap);
                        System.debug('agreement.Program__r.CumulativeIncomeShareCap__c:'+agreement.Program__r.CumulativeIncomeShareCap__c);
                        if(cumulativeIncomeShareCap == null || agreement.Program__r.CumulativeIncomeShareCap__c < cumulativeIncomeShareCap ){

                            cumulativeIncomeShareCap = agreement.Program__r.CumulativeIncomeShareCap__c;
                        }
                    }
                }
            }
            newAccountMap.get(theID).CumulativeIncomeShare__pc = cumulativeIncomeShare; //called in before trigger - shouldn't require update of object
            newAccountMap.get(theID).CumulativeIncomeShareCap__pc = cumulativeIncomeShareCap;
            newAccountMap.get(theID).RecalculateCumulativeIncomeShare__pc = false;
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageStatements
    /////////////////////////////////////////////////////////////////////////
    private static void manageStatements(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        Set<ID> studentIDs = new Set<ID>();
        Boolean runJob = false;
        if(!manageStatementsHasRun){
            manageStatementsHasRun = true;
            for(Account acct : newAccountMap.values()){
                if(acct.GenerateBill__pc && !oldAccountMap.get(acct.Id).GenerateBill__pc){
                    studentIDs.add(acct.Id);
                    runJob = true;
                }
            }        
            if(runJob){
                StatementService.GenerateBillQueueable job = new StatementService.GenerateBillQueueable(studentIDs);
                System.enqueueJob(job);                   
            }
         
        } else {
            System.debug('manageStatementsHasRun = true');
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageStatements
    /////////////////////////////////////////////////////////////////////////
    private static void manageSchoolSecurity(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        Set<ID> schoolIDs = new Set<ID>();
        if(!manageSchoolSecurityHasRun){
            manageSchoolSecurityHasRun = true;
            for(Account acct : newAccountMap.values()){
                if(String.isNotEmpty(acct.PrimarySchool__pc)){
                    schoolIDs.add(acct.PrimarySchool__pc);                    
                }

            }
            Map<ID, Account> schoolMap = AccountQueries.getSchoolMapWithSchoolID(schoolIDs);
            Map<ID, Account> acctsToUpdate = new Map<ID, Account>();
            for(Account acct : newAccountMap.values()){
                if(acct.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student') && String.isBlank(acct.SchoolSecurity__c)){
                    if(schoolMap.containsKey(acct.PrimarySchool__pc)){
                        acctsToUpdate.put(acct.id, new Account(id = acct.id, SchoolSecurity__c = schoolMap.get(acct.PrimarySchool__pc).SchoolSecurity__c));
                    }
                }
            }        
            if(acctsToUpdate.size()>0){
                update acctsToUpdate.values();
            }           
        } else {
            System.debug('manageSchoolSecurityHasRun = true');
        }

    }
    private static void manageAccountEmail(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        
        Map<id, Account> idNAccountMap = new Map<id, Account>();
        List<StudentProgram__c> agreementListtoUpdate = new List<StudentProgram__c>();
        List<Transaction__c> disburseListtoUpdate = new List<Transaction__c>();
        List<Bill__c> billListtoUpdate  = new List<Bill__c>();
        
        for(Account acct : newAccountMap.values()){
            if(acct.personEmail != oldAccountMap.get(acct.id).personEmail){
                idNAccountMap.put(acct.id,acct);    
            }
        }
        
        if(idNAccountMap != null && idNAccountMap.size()>0){
            Map<ID, StudentProgram__c> studentProgramMap = StudentProgramQueries.getStudentProgramMapWithStudentID(idNAccountMap.keyset());
            
            for(StudentProgram__c agreement : studentProgramMap.values()){
                if(agreement.student__c != null && idNAccountMap.get(agreement.student__c) != null && idNAccountMap.get(agreement.student__c).personEmail != null){
                    agreement.StudentEmail__c = idNAccountMap.get(agreement.student__c).personEmail;   
                    agreementListtoUpdate.add(agreement);
                }
            }
            
            if(agreementListtoUpdate != null && agreementListtoUpdate.size()>0)
                upsert agreementListtoUpdate;
                
            for(Transaction__c tr : [select id,student__c from Transaction__c where Student__c IN: idNAccountMap.keyset()]){
                if(idNAccountMap.get(tr.student__c).personEmail != null){
                    tr.NotificationEmail__c = idNAccountMap.get(tr.student__c).personEmail;
                    disburseListtoUpdate.add(tr);
                }
            }
            
            if(disburseListtoUpdate  != null && disburseListtoUpdate.size()>0)
                upsert disburseListtoUpdate;
                
            for(Bill__c bill : [select id,student__c from Bill__c where Student__c IN: idNAccountMap.keyset()]){
                if(idNAccountMap.get(bill.student__c).personEmail != null){
                    bill.Email__c = idNAccountMap.get(bill.student__c).personEmail;
                    billListtoUpdate.add(bill);
                }
            }
            
            if(billListtoUpdate != null && billListtoUpdate.size()>0)
                upsert billListtoUpdate;
        }
    }

/*    /////////////////////////////////////////////////////////////////////////
    //Method: manageCases
    /////////////////////////////////////////////////////////////////////////
    private void manageCases(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        System.debug('AccountTriggerHandler.manageCases()'); 
        List<Case> casesToAdd = new List<Case>();
        if(!manageCasesHasRun){
            System.debug('manageCasesHasRun is false');
            for(Account acct : newAccountMap.values()){
                if(acct.RecordStatus__pc == 'Pending Approval' && oldAccountMap.get(acct.id).RecordStatus__pc != 'Pending Approval'){
                    casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                                            ContactID = acct.PersonContactID,
                                            Subject = acct.FirstName + ' ' + acct.LastName + ' ' + ' Account Requires Approval',
                                            Status = 'Account Change Requires Approval',
                                            Priority = 'Medium',
                                            Reason = 'Other',
                                            OwnerId=GlobalUtil.getQueueId('Servicing'),
                                            Type = 'Restricted Data Change',                                    
                                            Origin = 'Other'));

                }

            }
            if(casesToAdd.size()>0){
                insert casesToAdd;
            }
            manageCasesHasRun = true;
        }
    }*/

/*    /////////////////////////////////////////////////////////////////////////
    //Method: setPendingFields
    /////////////////////////////////////////////////////////////////////////
    private void setPendingFields(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
system.debug('AccountTriggerHandler.setPendingFields()'); 
        for(Account acct : newAccountMap.values()){
            if(acct.RecordStatus__pc == 'Approved' && oldAccountMap.get(acct.id).RecordStatus__pc != 'Approved'){
                if(!String.isEmpty(acct.PendingFirstName__pc)){
                    acct.FirstName = acct.PendingFirstName__pc;
                    acct.PendingFirstName__pc = '';
                } 
                if(!String.isEmpty(acct.PendingLastName__pc)){
                    acct.LastName = acct.PendingLastName__pc;
                    acct.PendingLastName__pc = '';
                } 
                if(!String.isEmpty(acct.PendingMiddleName__pc)){
                    acct.MiddleName = acct.PendingMiddleName__pc;
                    acct.PendingMiddleName__pc = '';
                } 
                if((acct.PendingBirthdate__pc != null)){
                    acct.PersonBirthdate = acct.PendingBirthdate__pc;
                    acct.PendingBirthdate__pc = null;  
                } 
/*                if(!String.isEmpty(acct.PendingMailingStreet__pc)){
                    acct.PersonMailingStreet = acct.PendingMailingStreet__pc;
                    acct.PendingMailingStreet__pc = '';
                } 
                if(!String.isEmpty(acct.PendingMailingCity__pc)){
                    acct.PersonMailingCity = acct.PendingMailingCity__pc;
                    acct.PendingMailingCity__pc = '';
                } 
                if(!String.isEmpty(acct.PendingMailingStateCode__pc)){
                    acct.PersonMailingState = acct.PendingMailingStateCode__pc; 
                    acct.PendingMailingStateCode__pc = '';
                } 
                if(!String.isEmpty(acct.PendingMailingState__pc)){
                    acct.PersonMailingState = acct.PendingMailingState__pc; 
                    acct.PendingMailingState__pc = '';
                }  
                if(!String.isEmpty(acct.PendingMailingPostalCode__pc)){
                    acct.PersonMailingPostalCode = acct.PendingMailingPostalCode__pc;
                    acct.PendingMailingPostalCode__pc = '';
                }                                                                 
                if(!String.isEmpty(acct.PendingMailingCountry__pc)){
                    acct.PersonMailingCountry = acct.PendingMailingCountry__pc;
                    acct.PendingMailingCountry__pc = '';
                } 
                if(!String.isEmpty(acct.PendingEmail__pc)){
                    acct.PersonEmail = acct.PendingEmail__pc;
                    acct.PendingEmail__pc = '';
                } 
                if(!String.isEmpty(acct.PendingDriversLicenseOrStateID__pc)){
                    acct.DriversLicenseOrStateID__pc = acct.PendingDriversLicenseOrStateID__pc;
                    acct.PendingDriversLicenseOrStateID__pc = ''; 
                }  */      /*        
                if(!String.isEmpty(acct.PendingResidency__pc)){
                    acct.Residency__pc = acct.PendingResidency__pc;
                    acct.PendingResidency__pc = '';  
                } 

            } else {
system.debug('***acct:'+acct);
                if(!acct.BypassApproval__c){


                    if(oldAccountMap.get(acct.id).LastName != '~pendingAccountCreate'){
                        if(acct.FirstName != oldAccountMap.get(acct.id).FirstName && String.isNotEmpty(oldAccountMap.get(acct.id).FirstName)){
                            acct.PendingFirstName__pc = acct.FirstName;
                            acct.FirstName = oldAccountMap.get(acct.id).FirstName;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.LastName != oldAccountMap.get(acct.id).LastName && String.isNotEmpty(oldAccountMap.get(acct.id).LastName)){
                            acct.PendingLastName__pc = acct.LastName;
                            acct.LastName = oldAccountMap.get(acct.id).LastName;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.MiddleName != oldAccountMap.get(acct.id).MiddleName && String.isNotEmpty(oldAccountMap.get(acct.id).MiddleName)){
                            acct.PendingMiddleName__pc = acct.MiddleName;
                            acct.MiddleName = oldAccountMap.get(acct.id).MiddleName;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonBirthdate != oldAccountMap.get(acct.id).PersonBirthdate && oldAccountMap.get(acct.id).PersonBirthdate != null){
                            acct.PendingBirthdate__pc = acct.PersonBirthdate;
                            acct.PersonBirthdate = oldAccountMap.get(acct.id).PersonBirthdate;
                            acct.RecordStatus__pc = 'Pending Approval';
                        } 
    /*                    if(acct.PersonMailingStreet != oldAccountMap.get(acct.id).PersonMailingStreet){
                            acct.PendingMailingStreet__pc = acct.PersonMailingStreet;
                            acct.PersonMailingStreet = oldAccountMap.get(acct.id).PersonMailingStreet;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonMailingCity != oldAccountMap.get(acct.id).PersonMailingCity){
                            acct.PendingMailingCity__pc = acct.PersonMailingCity;
                            acct.PersonMailingCity = oldAccountMap.get(acct.id).PersonMailingCity;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonMailingStateCode != oldAccountMap.get(acct.id).PersonMailingStateCode){
                            acct.PendingMailingStateCode__pc = acct.PersonMailingStateCode;
                            acct.PendingMailingState__pc = GlobalUtil.getStateLabelByValue(acct.PersonMailingStateCode);
                            acct.PersonMailingStateCode = oldAccountMap.get(acct.id).PersonMailingStateCode;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonMailingState != oldAccountMap.get(acct.id).PersonMailingState){
                            acct.PendingMailingState__pc = acct.PersonMailingState;
                            acct.PersonMailingState = oldAccountMap.get(acct.id).PersonMailingState;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonMailingPostalCode != oldAccountMap.get(acct.id).PersonMailingPostalCode){
                            acct.PendingMailingPostalCode__pc = acct.PersonMailingPostalCode;
                            acct.PersonMailingPostalCode = oldAccountMap.get(acct.id).PersonMailingPostalCode;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonMailingCountryCode != oldAccountMap.get(acct.id).PersonMailingCountryCode){
                            acct.PendingMailingCountryCode__pc = acct.PersonMailingCountryCode;
                            acct.PendingMailingCountry__pc = GlobalUtil.getStateLabelByValue(acct.PersonMailingCountryCode);
                            acct.PersonMailingCountryCode = oldAccountMap.get(acct.id).PersonMailingCountryCode;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonMailingCountry != oldAccountMap.get(acct.id).PersonMailingCountry){
                            acct.PendingMailingCountry__pc = acct.PersonMailingCountry;
                            acct.PersonMailingCountry = oldAccountMap.get(acct.id).PersonMailingCountry;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.PersonEmail != oldAccountMap.get(acct.id).PersonEmail){
                            acct.PendingEmail__pc = acct.PersonEmail;
                            acct.PersonEmail = oldAccountMap.get(acct.id).PersonEmail;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }
                        if(acct.DriversLicenseOrStateID__pc != oldAccountMap.get(acct.id).DriversLicenseOrStateID__pc){
                            acct.PendingDriversLicenseOrStateID__pc = acct.DriversLicenseOrStateID__pc;
                            acct.DriversLicenseOrStateID__pc = oldAccountMap.get(acct.id).DriversLicenseOrStateID__pc;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }*/ /*
                        if(acct.Residency__pc != oldAccountMap.get(acct.id).Residency__pc && String.isNotEmpty(oldAccountMap.get(acct.id).Residency__pc)){
                            acct.PendingResidency__pc = acct.Residency__pc;
                            acct.Residency__pc = oldAccountMap.get(acct.id).Residency__pc;
                            acct.RecordStatus__pc = 'Pending Approval';
                        }  
                    }
                }   
            }
            acct.BypassApproval__c = false;
        }
    }
/*
    public static void manageAccountShares(Map<ID, Account> oldAccountMap, Map<ID, Account> newAccountMap){
        System.debug('AccountTriggerHandler.manageAccountShares()');
        if(manageAccountSharesHasRun!=true){
            System.debug('manageAccountSharesHasRun is false');
            Map<ID,ID> schoolToAddByStudentID = new Map<ID,ID>();
            Map<ID,ID> schoolToRemoveByStudentID = new Map<ID,ID>();
            Set<ID> schoolIDs = new Set<ID>();
            Set<ID> studentIDsNeedingRecalc = new Set<ID>();
            for(Account acct : newAccountMap.values()){
                if(acct.RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student')){
                    //Manage shares for student - they should be shared with the school and old schools should be removed
                    if(acct.PrimarySchool__pc != oldAccountMap.get(acct.id).PrimarySchool__pc){
                        schoolToAddByStudentID.put(acct.id, acct.PrimarySchool__c);
                        schoolToRemoveByStudentID.put(acct.id, oldAccountMap.get(acct.id).PrimarySchool__pc);
                        schoolIDs.add(acct.PrimarySchool__pc);
                        studentIDsNeedingRecalc.add(acct);
                    }
                }

            }

            List<User> portalUsers = [SELECT id from User where AccountID = :schoolIDs];
            Map<ID, List<User>> portalUsersBySchoolID = new Map<ID, List<User>>();
            for(User usr : portalUsers){
                if(!portalUsersBySchoolID.containsKey(usr.AccountID)){
                    portalUsersBySchoolID.put(usr.AccountID, new List<User>());
                }
                portalUsersBySchoolID.get(usr.AccountID).add(usr);
            }

            List<AccountShare> sharesToDelete = new List<AccountShare>();
            List<AccountShare> sharesToAdd = new List<AccountShare>();

            for(ID acctID : studentIDsNeedingRecalc){
                //remove all old shares for the Account

                //add new shares for the Account
            }

            manageAccountSharesHasRun = true;
        }
    }*/

    public class AccountTriggerHandlerException extends Exception {}
}