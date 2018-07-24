/////////////////////////////////////////////////////////////////////////
// Class: StudentProgramTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-29   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class StudentProgramTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/
    public static Map<ID, List<Transaction__c>> disbursementsByAgreement;
    public static Set<String> cumulativeIncomeStatusExclusions = new Set<String>{'Invited','Draft','Application Incomplete','Application Under Review', 'Cancelled', 'Contract Satisfied', 'Forgiven', 'Default'};
    public static Map<ID, Account> studentAccountMap;
    public static Map<ID, Program__c> programMap;

    /**************************State Control Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    public static Boolean finalDisclosureHasRun = false;
    public static Boolean signedAgreementHasRun = false; 
    public static Boolean retrieveSignedDocHasRun = false;
    public static Boolean adobeEsignHasRun = false;
    public static Boolean manageCasesHasRun = false;  
    public static Boolean manageSchedulesHasRun = false; 
    public static Boolean manageTransactionsHasRun = false;
    public static Boolean disclosureCalculationsHasRun = false;
    public static Boolean copyCreditCheckInfoHasRun = false;

    /**************************Constructors**********************************************/
    
    /**************************Execution Control - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.TriggerContext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'StudentProgramTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.TriggerContext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'StudentProgramTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'StudentProgramTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'StudentProgramTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.TriggerContext tc){
system.debug('StudentProgramTriggerHandler.onBeforeInsert()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<StudentProgram__c> newStudentProgramList = (List<StudentProgram__c>)tc.newList;
        //This is where you should call your business logic

        getStudentAccountMap(newStudentProgramList);
        getProgramMap(newStudentProgramList);
        setDefaultsOnInsert(newStudentProgramList);
        copyProgramInfo(newStudentProgramList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.TriggerContext tc){
system.debug('StudentProgramTriggerHandler.onBeforeUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<StudentProgram__c> newStudentProgramList = (List<StudentProgram__c>)tc.newList;
        List<StudentProgram__c> oldStudentProgramList = (List<StudentProgram__c>)tc.oldList;
        Map<ID, StudentProgram__c> newStudentProgramMap = (Map<ID, StudentProgram__c>)tc.newMap;
        Map<ID, StudentProgram__c> oldStudentProgramMap = (Map<ID, StudentProgram__c>)tc.oldMap;
        //This is where you should call your business logic
        
        getStudentAccountMap(newStudentProgramList);
        getProgramMap(newStudentProgramList);
        setDefaultsOnUpdate(oldStudentProgramMap, newStudentProgramMap); 
        manageRTCDates(oldStudentProgramMap, newStudentProgramMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.TriggerContext tc){
system.debug('StudentProgramTriggerHandler.onBeforeDelete()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<StudentProgram__c> oldStudentProgramList = (List<StudentProgram__c>)tc.oldList;
        Map<ID, StudentProgram__c> oldStudentProgramMap = (Map<ID, StudentProgram__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.TriggerContext tc){
system.debug('StudentProgramTriggerHandler.onAfterInsert()');
         //Recast the trigger context variables into the appropriate shandlerect types
        List<StudentProgram__c> newStudentProgramList = (List<StudentProgram__c>)tc.newList;
        Map<ID, StudentProgram__c> newStudentProgramMap = (Map<ID, StudentProgram__c>)tc.newMap;
        //This is where you should call your business logic
       
        getStudentAccountMap(newStudentProgramList);
        getProgramMap(newStudentProgramList);
        manageAudit(null, newStudentProgramMap);


        copyStudentInfo(null, newStudentProgramMap);        
        copyCreditCheckInfo(null, newStudentProgramMap);        
        disclosureCalculations(null, newStudentProgramMap);
        recalculateCumulativeIncomeShare(null, newStudentProgramMap);    
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.TriggerContext tc){
system.debug('StudentProgramTriggerHandler.onAfterUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<StudentProgram__c> newStudentProgramList = (List<StudentProgram__c>)tc.newList;
        List<StudentProgram__c> oldStudentProgramList = (List<StudentProgram__c>)tc.oldList;
        Map<ID, StudentProgram__c> newStudentProgramMap = (Map<ID, StudentProgram__c>)tc.newMap;
        Map<ID, StudentProgram__c> oldStudentProgramMap = (Map<ID, StudentProgram__c>)tc.oldMap;
        //This is where you should call your business logic
        getStudentAccountMap(newStudentProgramList);
        getProgramMap(newStudentProgramList);

        if(disbursementsByAgreement == null){
            disbursementsByAgreement = TransactionQueries.getTransactionMapByAgreementWithAgreementID(newStudentProgramMap.keyset(), TransactionService.disbursementRecType);
            System.debug('disbursementsByAgreement:'+disbursementsByAgreement);                
        }

        manageAudit(oldStudentProgramMap, newStudentProgramMap);
        copyStudentInfo(oldStudentProgramMap, newStudentProgramMap);

        manageDocuments(oldStudentProgramMap, newStudentProgramMap);
        manageCases(oldStudentProgramMap, newStudentProgramMap);
        manageSchedules(oldStudentProgramMap, newStudentProgramMap);
        manageTransactions(oldStudentProgramMap, newStudentProgramMap);
        copyCreditCheckInfo(oldStudentProgramMap, newStudentProgramMap);
        disclosureCalculations(oldStudentProgramMap, newStudentProgramMap);
        recalculateCumulativeIncomeShare(oldStudentProgramMap, newStudentProgramMap);         
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.TriggerContext tc){
system.debug('StudentProgramTriggerHandler.onAfterDelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<StudentProgram__c> oldStudentProgramList = (List<StudentProgram__c>)tc.oldList;
        Map<ID, StudentProgram__c> oldStudentProgramMap = (Map<ID, StudentProgram__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.TriggerContext tc){
system.debug('StudentProgramTriggerHandler.onAfterUndelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<StudentProgram__c> newStudentProgramList = (List<StudentProgram__c>)tc.newList;
        Map<ID, StudentProgram__c> newStudentProgramMap = (Map<ID, StudentProgram__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<StudentProgram__c> newStudentProgramList){
system.debug('StudentProgramTriggerHandler.setDefaultsOnInsert()');
        for(StudentProgram__c agreement: newStudentProgramList){
            if(!agreement.BypassAutomation__c){
                agreement.ApplicationStartDate__c = Datetime.now();
                agreement.CurrentStatusDate__c = Datetime.now();
                if(agreement.Status__c == 'Certified') agreement.CertificationDate__c = Datetime.now();
                if(agreement.Status__c == 'Application Complete') agreement.SubmittedDate__c = Datetime.now();
                if(agreement.Status__c == 'Application Complete' && agreement.PreCertified__c) agreement.Status__c = 'Certified';
                if(agreement.Status__c == 'Application Complete' && !agreement.ScheduleCreated__c) agreement.GenerateDisbursementSchedule__c = true;                
            }
        }
    }





    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
system.debug('StudentProgramTriggerHandler.setDefaultsOnUpdate()'); 
        for(StudentProgram__c agreement: newStudentProgramMap.values()){
            if(!agreement.BypassAutomation__c){
 

                if(!agreement.PreCertified__c){
                    //Student Initiated
                    studentInitiatedWorkflow(oldStudentProgramMap.get(agreement.id), agreement);


                } else if (agreement.PreCertified__c) {
                    //School Initiated
                    schoolInitiatedWorkflow(oldStudentProgramMap.get(agreement.id), agreement);                    
                }
                universalWorkflow(oldStudentProgramMap.get(agreement.id), agreement);
            }

            Decimal amountDueToDate = (agreement.AmountDueToDate__c == null ? 0 : agreement.AmountDueToDate__c);
            Decimal paidToDate = (agreement.PaidToDate__c == null ? 0 : agreement.PaidToDate__c);
            Decimal reconciliationDueToDate = (agreement.ReconciliationDueToDate__c == null ? 0 : agreement.ReconciliationDueToDate__c);
            Decimal reconciliationPaidToDate = (agreement.ReconciliationPaidToDate__c == null ? 0 : agreement.ReconciliationPaidToDate__c);
            Decimal monthlyAmountDueToDate = (agreement.MonthlyAmountDueToDate__c == null ? 0 : agreement.MonthlyAmountDueToDate__c);
            Decimal monthlyAmountPaidToDate = (agreement.MonthlyAmountPaidToDate__c == null ? 0 : agreement.MonthlyAmountPaidToDate__c);
            agreement.NextPaymentDue__c = amountDueToDate - paidToDate;
            agreement.ReconciliationDue__c = reconciliationDueToDate - reconciliationPaidToDate;
            agreement.MonthlyAMountDue__c = monthlyAmountDueToDate - monthlyAmountPaidToDate;
        }
    }

    private void universalWorkflow(StudentProgram__c oldAgreement, StudentProgram__c agreement){
        System.debug('StudentProgramTriggerHandler.universalWorkflow()');
        if(agreement.CreditCheckProcess__c != oldAgreement.CreditCheckProcess__c){
            if(agreement.CreditCheckProcess__c == 'Credit Denied'){
                agreement.Status__c = 'Cancelled';
                agreement.CancellationReason__c = 'Credit Denied';
            } else if(agreement.CreditCheckProcess__c == 'Credit Approved'){
                agreement.Status__c = 'Application Incomplete';
                agreement.SendApplicationReviewApproved__c = true;
            } else if(agreement.CreditCheckProcess__c == 'In Progress'){
                agreement.SendApplicationUnderReview__c = true;                    
            }
        }
        if(agreement.Status__c != oldAgreement.Status__c){
            agreement.CurrentStatusDate__c = Datetime.now();
            if(agreement.Status__c == 'Certified') agreement.CertificationDate__c = Datetime.now();
            if(agreement.Status__c == 'Application Complete') agreement.SubmittedDate__c = Datetime.now();
            if(agreement.Status__c == 'Fully Funded') agreement.SendFullyFunded__c = true;    
        }

        if(agreement.CongaFinalDisclosureStatus__c != oldAgreement.CongaFinalDisclosureStatus__c && agreement.CongaFinalDisclosureStatus__c == 'Generated'){
            agreement.SendApplicationCertified__c = true;
        } 

        if(agreement.GenerateAgreement__c && oldAgreement.GenerateAgreement__c != true){
            agreement.CongaUnsignedAgreementStatus__c = 'Generate';
            agreement.CopyStudentInfo__c = true;
        } 

        allwaysCopyStudentFieldsToPostCert(oldAgreement, agreement);           
        /*if(agreement.GenerateFinalDisclosure__c && oldAgreement.GenerateAgreement__c != true){
            agreement.CongaFinalDisclosureStatus__c = 'Generate';
        }  */

    }

    private void studentInitiatedWorkflow(StudentProgram__c oldAgreement, StudentProgram__c agreement){
        if(agreement.Status__c != oldAgreement.Status__c){

            if(agreement.Status__c == 'Application Complete'){
                agreement.SendApplicationComplete__c = true;
                if(!agreement.ScheduleCreated__c){
                    agreement.GenerateDisbursementSchedule__c = true;
                    agreement.SetRTCDates__c = true;//set initially here - it should be cleared out when the schdule is created
                }
                //Copy Student Fields to Certification and Post Certification Fields
                copyStudentFieldsToCertPostCert(agreement);
                agreement.CertificationDraftStatus__c = 'None';


            }
            if(agreement.Status__c == 'Certified'){
                //agreement.SendApplicationCertified__c = true;
                agreement.SetRTCDates__c = true;
                agreement.GenerateFinalDisclosure__c = true;
                copyCertificationFieldsToPostCert(agreement);
            }
            if(agreement.Status__c == 'Cancelled' &&
               agreement.CancellationReason__c == 'Ineligible' &&
               agreement.EligibleToReapply__c != true){
                agreement.SendApplicationDeniedNoReapply__c = true;
            }
            if(agreement.Status__c == 'Cancelled' &&
               agreement.CancellationReason__c == 'Ineligible' &&
               agreement.EligibleToReapply__c == true){
                agreement.SendApplicationDeniedReapply__c = true;
            }
            if(agreement.Status__c == 'Cancelled' &&
               agreement.CancellationReason__c == 'Credit Denied'){
                agreement.SendCreditDenied__c = true;
            }

            if((agreement.Status__c == 'Cancelled') && (agreement.CancellationReason__c == 'Not Certified')){
                agreement.SendNotCertified__c = true;
            }
        }

    }
    private void schoolInitiatedWorkflow(StudentProgram__c oldAgreement, StudentProgram__c agreement){
        List<OutboundEmailService.OutboundEmail> emailsToSend = new List<OutboundEmailService.OutboundEmail>();
        
        //do not run automation if agreement is marked deleted
        if(agreement.Deleted__c != true){
            if((agreement.PreCertified__c != oldAgreement.PreCertified__c) && (agreement.PreCertified__c == true)){
                agreement.SendSchoolInitPreCertifiedInvite__c = true;
                agreement.Status__c = 'Invited';
            }      
        
            if(agreement.Status__c != oldAgreement.Status__c){
                if(agreement.Status__c == 'Application Complete'){
                    agreement.Status__c = 'Certified';
                    agreement.SendApplicationCompleteSchoolInit__c = true;
                    agreement.SetRTCDates__c = true;
                    agreement.GenerateFinalDisclosure__c = true;
                    //agreement.SendApplicationCertified__c = true;
    
                    //Send Student Signed Notification to School if Necessary
                    if(programMap.get(agreement.Program__c).StudentSignedISANotification__c && String.isNotBlank(programMap.get(agreement.Program__c).SchoolEmailNotification1__c)){
                        OutboundEmailService.OutboundEmail email = new OutboundEmailService.OutboundEmail();
                        email.toAddresses = programMap.get(agreement.Program__c).SchoolEmailNotification1__c;
                        //email.templateID = '00X7A000000EJ98';
                        email.templateDevName = 'AllSchoolsSchoolNotifiedOfISASignature';
                        email.whatID = agreement.id;
                        email.targetObjectId = studentAccountMap.get(agreement.Student__c).PersonContactID;
                        email.sendImmediate = true;
                        emailsToSend.add(email);                    
                    }
    
    
    
                    copyStudentFieldsToPostCert(agreement);
                } 
                if(agreement.Status__c == 'Cancelled'){
                    if(agreement.CancellationReason__c == 'Not Certified') agreement.Deleted__c = true;
                }
            }
            System.debug('emailsToSend:'+emailsToSend);
            OutboundEmailService.createOutboundEmailV1(emailsToSend);
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: allwaysCopyStudentFieldsToPostCert
    /////////////////////////////////////////////////////////////////////////
    private void copyStudentFieldsToPostCert(StudentProgram__c a){
        a.BirthdatePostCertification__c = a.BirthdateStudent__c;

        a.EnrollmentStatusPostCertification__c = a.EnrollmentStatusStudent__c;
        
        a.FundingAmountPostCertification__c = a.FundingAmountStudent__c;                  
          
        a.GradeLevelPostCertification__c = a.GradeLevelStudent__c;

        a.IncomeSharePostCertification__c = a.IncomeShareStudent__c;

        a.MajorPostCertification__c = a.MajorStudent__c;
        
        a.PaymentCapPostCertification__c = a.PaymentCapStudent__c;

        a.PaymentTermPostCertification__c = a.PaymentTermStudent__c;

        a.ResidencyPostCertification__c = a.ResidencyStudent__c;

        a.StateOfResidencePostCertification__c = a.StateOfResidenceStudent__c;
        
        a.RemainingTerm__c = a.PaymentTermStudent__c;   
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: allwaysCopyStudentFieldsToPostCert
    /////////////////////////////////////////////////////////////////////////
    private void allwaysCopyStudentFieldsToPostCert(StudentProgram__c oldAgreement, StudentProgram__c newAgreement){

        if(newAgreement.FundingAmountStudent__c != oldAgreement.FundingAmountStudent__c) newAgreement.FundingAmountPostCertification__c = newAgreement.FundingAmountStudent__c;                  

        if(newAgreement.IncomeShareStudent__c != oldAgreement.IncomeShareStudent__c) newAgreement.IncomeSharePostCertification__c = newAgreement.IncomeShareStudent__c;
        
        if(newAgreement.PaymentCapStudent__c != oldAgreement.PaymentCapStudent__c) newAgreement.PaymentCapPostCertification__c = newAgreement.PaymentCapStudent__c;

        if(newAgreement.PaymentTermStudent__c != oldAgreement.PaymentTermStudent__c) newAgreement.PaymentTermPostCertification__c = newAgreement.PaymentTermStudent__c;

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: copyCertificationFieldsToPostCert
    /////////////////////////////////////////////////////////////////////////
    private void copyCertificationFieldsToPostCert(StudentProgram__c a){
        a.BirthdatePostCertification__c = a.BirthdateCertification__c;

        a.EnrollmentStatusPostCertification__c = a.EnrollmentStatusCertification__c;
        
        a.FundingAmountPostCertification__c = a.FundingAmountCertification__c;                  
          
        a.GradeLevelPostCertification__c = a.GradeLevelCertification__c;

        a.IncomeSharePostCertification__c = a.IncomeShareCertification__c;

        a.MajorPostCertification__c = a.MajorCertification__c;
        
        a.PaymentCapPostCertification__c = a.PaymentCapCertification__c;

        a.PaymentTermPostCertification__c = a.PaymentTermCertification__c;

        a.ResidencyPostCertification__c = a.ResidencyCertification__c;

        a.StateOfResidencePostCertification__c = a.StateOfResidenceCertification__c;
        
        a.RemainingTerm__c = a.PaymentTermCertification__c;        

    }

    /////////////////////////////////////////////////////////////////////////
    //Method: copyStudentFieldsToCertPostCert
    /////////////////////////////////////////////////////////////////////////
    private void copyStudentFieldsToCertPostCert(StudentProgram__c a){
        a.BirthdateCertification__c = a.BirthdateStudent__c;
        a.BirthdatePostCertification__c = a.BirthdateStudent__c;

        a.EnrollmentStatusCertification__c = a.EnrollmentStatusStudent__c;
        a.EnrollmentStatusPostCertification__c = a.EnrollmentStatusStudent__c;
        
        a.FundingAmountCertification__c = a.FundingAmountStudent__c;
        a.FundingAmountPostCertification__c = a.FundingAmountStudent__c;                  

        a.GradeLevelCertification__c = a.GradeLevelStudent__c;               
        a.GradeLevelPostCertification__c = a.GradeLevelStudent__c;

        a.IncomeShareCertification__c = a.IncomeShareStudent__c;    
        a.IncomeSharePostCertification__c = a.IncomeShareStudent__c;

        a.MajorCertification__c = a.MajorStudent__c;
        a.MajorPostCertification__c = a.MajorStudent__c;
        
        a.PaymentCapCertification__c = a.PaymentCapStudent__c;
        a.PaymentCapPostCertification__c = a.PaymentCapStudent__c;

        a.PaymentTermCertification__c = a.PaymentTermStudent__c;
        a.PaymentTermPostCertification__c = a.PaymentTermStudent__c;

        a.ResidencyCertification__c = a.ResidencyStudent__c;
        a.ResidencyPostCertification__c = a.ResidencyStudent__c;

        a.StateOfResidenceCertification__c = a.StateOfResidenceStudent__c;
        a.StateOfResidencePostCertification__c = a.StateOfResidenceStudent__c;
        
        a.RemainingTerm__c = a.PaymentTermStudent__c;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: recalculateCumulativeIncomeShare
    /////////////////////////////////////////////////////////////////////////
    private void recalculateCumulativeIncomeShare(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
system.debug('StudentProgramTriggerHandler.recalculateCumulativeIncomeShare()'); 
        Set<ID> acctIDsToRecalc = new Set<ID>();
        List<Account> acctsToRecalc = new List<Account>();
        for(StudentProgram__c agreement: newStudentProgramMap.values()){
            if(!agreement.BypassAutomation__c){
                Boolean recalc = false;
                if(!cumulativeIncomeStatusExclusions.contains(agreement.Status__c)) recalc = true;
                if(oldStudentProgramMap == null){
                    recalc = true;
                } else {
                    if(agreement.Status__c != oldStudentProgramMap.get(agreement.id).Status__c) recalc = true;
                    if(agreement.IncomeSharePostCertification__c != oldStudentProgramMap.get(agreement.id).IncomeSharePostCertification__c) recalc = true;                    
                }

                if(recalc) {
                    Boolean changed = acctIDsTORecalc.add(agreement.Student__c); //avoid duplicate accounts
                    if(changed) acctsToRecalc.add(new Account(id = agreement.Student__c, RecalculateCumulativeIncomeShare__pc = true));
                }
            }
        }

        if(acctsToRecalc.size()>0){
            update acctsToRecalc;
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageTransactions
    /////////////////////////////////////////////////////////////////////////
    private void manageTransactions(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
        System.debug('StudentProgramTriggerHandler.manageCertification()'); 
        if(!manageTransactionsHasRun){
            System.debug('manageTransactionsHasRun is false');            
            
            if(disbursementsByAgreement == null){
                disbursementsByAgreement = TransactionQueries.getTransactionMapByAgreementWithAgreementID(newStudentProgramMap.keyset(), TransactionService.disbursementRecType);
                System.debug('disbursementsByAgreement:'+disbursementsByAgreement);                
            }
            Map<ID, Transaction__c> txToUpdate = new Map<ID, Transaction__c>();

            for(StudentProgram__c agreement: newStudentProgramMap.values()){
                if(!agreement.BypassAutomation__c){
                    System.debug('agreement:'+agreement);

                    //RRTC should have just run.  

                    if(((agreement.Status__c == 'Certified' && oldStudentProgramMap.get(agreement.id).Status__c != 'Certified') && (!agreement.PreCertified__c)) ||
                        ((agreement.Status__c == 'Certified' && oldStudentProgramMap.get(agreement.id).Status__c != 'Certified') && (agreement.PreCertified__c))){
/* moving to schedule creation for Student Initiated*/
                        if(disbursementsByAgreement.containsKey(agreement.id)){
                            List<Transaction__c> agreementDisbursements = disbursementsByAgreement.get(agreement.id);
                            Decimal fundingAmount = (agreement.FundingAmountCertification__c > 0 ? agreement.FundingAmountCertification__c : 0);
                            if(agreement.PreCertified__c){
                                fundingAmount = (agreement.FundingAmountStudent__c > 0 ? agreement.FundingAmountStudent__c : 0);
                                //Calculate the actual amounts from the percentages
                                /*
                                Calculation logic
                                Disbursement amounts should be in whole dollars. If a %age of a funding amount will result in an amount with cents (fractions of a dollar), adjust amounts of the disbursements so that each disbursement is in a whole dollar amount AND set of disbursements still adds up to the overall funding amount. Rounding rules on resulting disbursement amounts should be adjusted such that earlier disbursements are rounded up and later disbursements are rounded down.

                                EXAMPLE IMPLEMENTATION
                                Perform calculation for each disbursement... Total Funding Amount * Disbursement %
                                Round down results
                                Add $1 to as many disbursement amounts as needed until sum of disbursement amounts = Total Funding Amount... loop from earliest disbursement to latest disbursement
                                EXAMPLE
                                Initial disbursement schedule
                                9/25/2017 - 10%
                                11/25/2017 - 40%
                                2/15/2018 - 35%
                                5/20/2018 - 15%
                                Funding amount = $10234
                                Resulting disbursement schedule
                                9/25/2017 - $1024
                                11/25/2017 - $4094
                                2/15/2018 - $3581
                                5/20/2018 - $1535 */
                                
                                //Add up the lines
                                Decimal totalDisbursement = 0;
                                Decimal remainingFunding = agreement.FundingAmountStudent__c;
                                System.debug('remainingFunding before loop:'+remainingFunding);

                                //Determine if the disbursements have already been created - if so use them instead
                                if(agreement.FundingMaximumPreCertification__c != agreement.FundingMinimumPreCertification__c){
                                    for(Transaction__c tx : agreementDisbursements){
                                        if(tx.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRecType)){
                                            //if this record is being certified move the value from scheduled amount into actual amount
                                            System.debug('tx:'+tx);
                                            if(tx.DisbursementPercentage__c != null){
                                                totalDisbursement += tx.DisbursementPercentage__c;
                                            } else {
                                                tx.DisbursementPercentage__c = 0;
                                            }

                                            tx.Amount__c = ((tx.DisbursementPercentage__c * fundingAmount)/100).round(System.RoundingMode.DOWN);

    //                                        tx.Amount__c = tx.ScheduledAmount__c.round(System.RoundingMode.DOWN);
                                            remainingFunding -= tx.Amount__c;
                                            System.debug('remainingFunding in loop:'+remainingFunding);
                                            /*txToUpdate.put(tx.id, new Transaction__c(id = tx.id,
                                                                                     Amount__c = tx.ScheduledAmount__c));   */                     
                                        }

                                    }
                                    Boolean keepLooping = true;
                                    System.debug('remainingFunding after loop:'+remainingFunding);
                                    while(keepLooping){
                                        for(Integer i = 0; i<agreementDisbursements.size(); i++){
                                            system.debug('agreementDisbursements.size():'+agreementDisbursements.size());
                                            if(remainingFunding>0 && keepLooping){
                                                agreementDisbursements[i].Amount__c += 1;
                                                remainingFunding -= 1;
                                                //System.debug('remainingFunding1:'+remainingFunding);                                            
                                            } else {
                                                keepLooping = false;
                                            }

                                        }                                    
                                    }                                    
                                }

                            }
                            //List<Transaction__c> agreementDisbursements = disbursementsByAgreement.get(agreement.id);
                            Decimal totalDisbursementDollars = 0;
                            for(Transaction__c tx : agreementDisbursements){
                                //Make sure the Dates are not before the RTC date
                                System.debug('tx.TransactionDate__c:'+tx.TransactionDate__c);
                                SYstem.debug('agreement.RightToCancelDate__c'+agreement.RightToCancelDate__c);
                                if(agreement.RightToCancelDate__c != null){
                                    System.debug('in loop');
                                    if(tx.TransactionDate__c <= agreement.RightToCancelDate__c){
                                        tx.TransactionDate__c = agreement.RightToCancelDate__c.addDays(1);
    //                                    txToUpdate.put(tx.id, new Transaction__c(id = tx.id,  Amount__c = tx.Amount__c, TransactionDate__c = tx.TransactionDate__c));                                 
                                    }
                                }
                                txToUpdate.put(tx.id, new Transaction__c(id = tx.id,  Amount__c = tx.Amount__c, TransactionDate__c = tx.TransactionDate__c));                                 

                                
                                totalDisbursementDollars += tx.Amount__c;
                            }

                            //if(totalDisbursementDollars!= agreement.FundingAmountCertification__c){
                            if(totalDisbursementDollars!= fundingAmount){    
                                agreement.addError('The Scheduled Disbursements do not equal to the total $ amount of the funding');
                            }
                        }
                    }
                }
            }
            if(txToUpdate.size()>0){
                System.debug('txToUpdate:'+txToUpdate);
                update txToUpdate.values();
            }
            manageTransactionsHasRun = true;
        }
    }


    /////////////////////////////////////////////////////////////////////////
    //Method: manageSchedules
    /////////////////////////////////////////////////////////////////////////
    private void manageSchedules(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
        System.debug('StudentProgramTriggerHandler.manageSchedules()'); 

        if(!manageSchedulesHasRun){
            System.debug('manageSchedulesHasRun is false');
            Set<ID> studentIDs = new Set<ID>();
            Set<ID> programIDs = new Set<ID>();
            List<Transaction__c> txToCreate = new List<Transaction__c>();
            Map<ID, List<Transaction__c>> txToCreateByAgreement = new Map<ID, List<Transaction__c>>();

            for(StudentProgram__c agreement : newStudentProgramMap.values()){
                programIDs.add(agreement.Program__c);
            }
            Map<ID, StudentProgram__c> agreementsToUpdate = new Map<ID, StudentProgram__c>();

        //moving to static programMap variable
        //Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(programIDs);
        
            Map<ID, List<TransactionSchedule__c>> schedulesByProgramID = TransactionScheduleQueries.getTransactionSchedulesByProgramIDWithProgramID(programIDs);
            System.debug('schedulesByProgramID:'+schedulesByProgramID);

            for(StudentProgram__c agreement: newStudentProgramMap.values()){
                if(!agreement.BypassAutomation__c){
                    System.debug('agreement:'+agreement);

                    if(!txToCreateByAgreement.containsKey(agreement.id)){
                        txToCreateByAgreement.put(agreement.id, new List<Transaction__c>());
                    }
                    //Currently the schedule is only created when the application goes to Application Complete
                    System.debug('1');
                    if(agreement.GenerateDisbursementSchedule__c && !oldStudentProgramMap.get(agreement.id).GenerateDisbursementSchedule__c && !agreement.ScheduleCreated__c){
                        System.debug('2');
                        System.debug('generate schedule');
                        if(schedulesByProgramID.containsKey(agreement.Program__c)){
                            for(TransactionSchedule__c txSch : schedulesByProgramID.get(agreement.Program__c)){
                                Date dt =  Date.newInstance(txSch.ScheduledDate__c.year(), txSch.ScheduledDate__c.month(), txSch.ScheduledDate__c.day());
                                Transaction__c initialTx = new Transaction__c(Agreement__c = agreement.id,
                                                                              RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRecType),
                                                                              DisbursementPercentage__c = txSch.FundingAmount__c,
                                                                              TransactionDate__c = dt,
                                                                              RelatedSchedule__c = txSch.id,
                                                                              Status__c = 'Scheduled',
                                                                              Student__c = agreement.Student__c);

                                txToCreateByAgreement.get(agreement.id).add(initialTx);
                                System.debug('initialTx:'+initialTx);

                            }

                            //Adjust the amounts of the distributions accordingly
                            //Calculate the actual amounts from the percentages
    /*
                            Calculation logic
                            Disbursement amounts should be in whole dollars. If a %age of a funding amount will result in an amount with cents (fractions of a dollar), adjust amounts of the disbursements so that each disbursement is in a whole dollar amount AND set of disbursements still adds up to the overall funding amount. Rounding rules on resulting disbursement amounts should be adjusted such that earlier disbursements are rounded up and later disbursements are rounded down.

                            EXAMPLE IMPLEMENTATION
                            Perform calculation for each disbursement... Total Funding Amount * Disbursement %
                            Round down results
                            Add $1 to as many disbursement amounts as needed until sum of disbursement amounts = Total Funding Amount... loop from earliest disbursement to latest disbursement
                            EXAMPLE
                            Initial disbursement schedule
                            9/25/2017 - 10%
                            11/25/2017 - 40%
                            2/15/2018 - 35%
                            5/20/2018 - 15%
                            Funding amount = $10234
                            Resulting disbursement schedule
                            9/25/2017 - $1024
                            11/25/2017 - $4094
                            2/15/2018 - $3581
                            5/20/2018 - $1535 */
                            
                            List<Transaction__c> agreementDisbursements = txToCreateByAgreement.get(agreement.id);
                            //only validate student initiated during schedule creation
                            if(!agreement.PreCertified__c){
                                //Add up the lines
                                Decimal totalDisbursement = 0;
                                Decimal remainingFunding = agreement.FundingAmountCertification__c;
                                System.debug('remainingFunding before loop:'+remainingFunding);

                                for(Transaction__c tx : agreementDisbursements){
                                    if(tx.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRecType)){
                                        System.debug('tx:'+tx);
                                        if(tx.DisbursementPercentage__c != null) totalDisbursement += tx.DisbursementPercentage__c;
                                        System.debug('tx.DisbursementPErcentage:'+tx.DisbursementPercentage__c);
                                        System.debug('agreement.FundingAmountCertification__c:'+agreement.FundingAmountCertification__c);
                                        tx.Amount__c = ((tx.DisbursementPercentage__c * agreement.FundingAmountCertification__c)/100).round(System.RoundingMode.DOWN);
                                        System.debug('tx.Amount__c:'+tx.Amount__c);
                                        //tx.Amount__c = tx.ScheduledAmount__c.round(System.RoundingMode.DOWN);
                                        remainingFunding -= tx.Amount__c;
                                        System.debug('remainingFunding in loop:'+remainingFunding);               
                                    }

                                }
                                Boolean keepLooping = true;
                                System.debug('remainingFunding after loop:'+remainingFunding);
                                while(keepLooping){
                                    for(Integer i = 0; i<agreementDisbursements.size(); i++){
                                        if(remainingFunding>0 && keepLooping){
                                            agreementDisbursements[i].Amount__c += 1;
                                            remainingFunding -= 1;
                                            System.debug('remainingFunding:'+remainingFunding);                                            
                                        } else {
                                            keepLooping = false;
                                        }
                                    }                                    
                                }

                                Decimal totalDisbursementDollars = 0;
                                ///////////////////////////
                                ///Commenting out this logic to implement the equal shift in Dibsursement Date with the 
                                ///earlist disbursement date falls before the right to cancel date
                                ////////////////////////////
                                /*
                                for(Transaction__c tx : agreementDisbursements){
                                    //Make sure the Dates are not before the RTC date
                                    System.debug('tx.TransactionDate__c:'+tx.TransactionDate__c);
                                    System.debug('agreement.RightToCancelDate__c'+agreement.RightToCancelDate__c);
                                    if(agreement.RightToCancelDate__c != null){
                                        System.debug('in loop');
                                        if(tx.TransactionDate__c <= agreement.RightToCancelDate__c){
                                            tx.TransactionDate__c = agreement.RightToCancelDate__c.addDays(1);
                                        }
                                    }

                                    //txToCreate.add(tx);//.put(tx.id, new Transaction__c(id = tx.id,  Amount__c = tx.Amount__c, TransactionDate__c = tx.TransactionDate__c)); 
                                    totalDisbursementDollars += tx.Amount__c;
                                }
                                */
                                
                                //find the earlist disbursement date
                                Date earlistTxDate = null;
                                for(Transaction__c tx : agreementDisbursements){
                                    if(earlistTxDate == null || tx.TransactionDate__c < earlistTxDate) earlistTxDate = tx.TransactionDate__c;                                           
                                    System.debug('tx.TransactionDate__c:'+tx.TransactionDate__c);
                                    System.debug('earlistTxDate:'+earlistTxDate);

                                    totalDisbursementDollars += tx.Amount__c;
                                }
                                
                                //shift dates equally if the earlist transaction is before rightToCancelDate
                                if(agreement.RightToCancelDate__c != null && earlistTxDate < agreement.RightToCancelDate__c){
                                    Integer shiftDays = earlistTxDate.daysBetween(agreement.RightToCancelDate__c); 
                                    shiftDays += 1; // earlist date should be after the rightToCancelDate
                                    for(Transaction__c tx : agreementDisbursements){
                                        tx.TransactionDate__c = tx.TransactionDate__c.addDays(shiftDays);
                                        while(GlobalUtil.isWeekendDay(tx.TransactionDate__c)){
                                            tx.TransactionDate__c = tx.TransactionDate__c.addDays(1);
                                        }    
                                    }                
                                }

                                if ((totalDisbursement != 100) /*&& (totalDisbursement != 0)*/){
                                    //let zero go in case they are all blank
                                    agreement.addError('The Scheduled Disbursements do not equate to 100% of the total funding amount');
                                }
                                if(totalDisbursementDollars!= agreement.FundingAmountCertification__c){
                                    agreement.addError('The Scheduled Disbursements do not equal to the total $ amount of the funding');
                                }                        

                            }
                            for(Transaction__c tx : agreementDisbursements){
                                txToCreate.add(tx);//.put(tx.id, new Transaction__c(id = tx.id,  Amount__c = tx.Amount__c, TransactionDate__c = tx.TransactionDate__c)); 

                            }

                        }
                        agreementsToUpdate.put(agreement.id, new StudentProgram__c(id = agreement.id,
                                                                                    ScheduleCreated__c = true,
                                                                                    SetRTCDates__c = false)); 
                    }
                   

                }

            }
            if(txToCreate.size()>0){
                System.debug('txToCreate:'+txToCreate);
                insert txToCreate;
            }       
            if(agreementsToUpdate.size()>0){
                System.debug('agreementsToUpdate:'+agreementsToUpdate);
                update agreementsToUpdate.values();
            }     
            manageSchedulesHasRun = true;
        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: manageCases
    /////////////////////////////////////////////////////////////////////////
    private void manageCases(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
        System.debug('StudentProgramTriggerHandler.manageCases()'); 
        List<Case> casesToAdd = new List<Case>();
        Set<ID> studentIDs = new Set<ID>();
        Set<ID> programIDs = new Set<ID>();
        for(StudentProgram__c agreement : newStudentProgramMap.values()){
            studentIDs.add(agreement.Student__c);
            programIDs.add(agreement.Program__c);
        }
        System.debug('studentIDs:'+studentIDs);
        
        //moving to static studentAccountMap
        // Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
        //moving to static programMap variable
        //Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(programIDs);
        


        for(StudentProgram__c agreement: newStudentProgramMap.values()){
            if(!agreement.BypassAutomation__c){
                system.debug('agreement:'+agreement);
                if(!manageCasesHasRun){
                    system.debug('manageCasesHasRun is false');
                    if(agreement.Status__c == 'Application Complete' && oldStudentProgramMap.get(agreement.id).Status__c != 'Application Complete'){
/*disabled as per the 6/23 backlog item
                        //Create Certification Case
                        casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_CERTIFICATION),
                                                ContactID = studentMap.get(agreement.Student__c).PersonContactID,
                                                Subject = studentMap.get(agreement.Student__c).FirstName + ' ' + studentMap.get(agreement.Student__c).LastName + ' ' + ' Awaiting Certification',
                                                Status = 'Requesting Certification',
                                                Priority = 'Medium',
                                                Reason = 'Other',
                                                OwnerId=GlobalUtil.getQueueId('Certification'),
                                                Type = 'Certification',

                                                ApplicationEnrollmentStatus__c = agreement.EnrollmentStatus__c,
                                                CertifiedEnrollmentStatus__c = agreement.EnrollmentStatus__c,
                                                ApplicationExpectedGraduationDate__c = agreement.ExpectedGraduationDate__c,
                                                CertifiedExpectedGraduationDate__c = agreement.ExpectedGraduationDate__c,
                                                ApplicationGradeLevel__c = agreement.GradeLevel__c,
                                                CertifiedGradeLevel__c = agreement.GradeLevel__c,
                                                ApplicationSchoolProgramOfStudy__c = agreement.SchoolProgramOfStudy__c,
                                                CertifiedSchoolProgramOfStudy__c = agreement.SchoolProgramOfStudy__c,
                                                ApplicationResidency__c = agreement.Residency__c,
                                                CertifiedResidency__c = agreement.Residency__c,

                                                ApplicationRequestedAmount__c = agreement.RequestedAmount__c,
                                                CertifiedAllocatedAmount__c = agreement.RequestedAmount__c, //Copy Over Requested Amount
                                                ApplicationIncomeShare__c = agreement.IncomeShare__c,
                                                CertifiedIncomeShare__c = agreement.IncomeShare__c,
                                                ApplicationPaymentCap__c = agreement.PaymentCap__c,
                                                CertifiedPaymentCap__c = agreement.PaymentCap__c,
                                                ApplicationPaymentTerm__c = agreement.PaymentTerm__c,
                                                CertifiedPaymentTerm__c = agreement.PaymentTerm__c,

                                                Agreement__c = agreement.id,
                                                School__c = programMap.get(agreement.Program__c).School__c,                                       
                                                Origin = 'Other'));*/

                    }
                    if(agreement.Status__c == 'Cancelled' &&
                       agreement.CancellationReason__c == 'Customer Withdrawn' &&
                       oldStudentProgramMap.get(agreement.id).Status__c != 'Application Incomplete'){

                        //Create Case
                        casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                                                ContactID = studentAccountMap.get(agreement.Student__c).PersonContactID,
                                                Subject = studentAccountMap.get(agreement.Student__c).FirstName + ' ' + studentAccountMap.get(agreement.Student__c).LastName + ' ' + ' Cancelled Contract',
                                                Status = 'Cancelled Contract',
                                                Priority = 'Medium',
                                                Reason = 'Other',
                                                OwnerId=GlobalUtil.getQueueId('Servicing'),
                                                Type = 'Cancellation',

                                                Agreement__c = agreement.id,
                                                School__c = programMap.get(agreement.Program__c).School__c,                                       
                                                Origin = 'Other'));

                    }
                    Boolean createCreditAppealCase = false;
                    if(agreement.Status__c == 'Application Under Review' && 
                        oldStudentProgramMap.get(agreement.id).Status__c != 'Application Under Review' &&
                        agreement.CreditCheckProcess__c == 'In Progress'){
                        createCreditAppealCase = true;
                    } else if(agreement.CreditCheckProcess__c == 'In Progress' && 
                        oldStudentProgramMap.get(agreement.id).CreditCheckProcess__c != 'In Progress' &&
                        agreement.Status__c == 'Application Under Review'){
                        createCreditAppealCase = true;
                    }

                    if(createCreditAppealCase){
                            //Create Case
                            casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                                                    ContactID = studentAccountMap.get(agreement.Student__c).PersonContactID,
                                                    Subject = studentAccountMap.get(agreement.Student__c).FirstName + ' ' + studentAccountMap.get(agreement.Student__c).LastName + ' ' + ' Credit Appeal',
                                                    Status = 'Credit Appeal',
                                                    Priority = 'Medium',
                                                    Reason = 'Other',
                                                    OwnerId=GlobalUtil.getQueueId('Servicing'),
                                                    Type = 'Credit Appeal',

                                                    Agreement__c = agreement.id,
                                                    School__c = programMap.get(agreement.Program__c).School__c,                                       
                                                    Origin = 'Other'));

                    }

                    if(agreement.Status__c == 'Application Under Review' &&
                       agreement.RegistrationExceptionProcess__c == 'In Progress' &&
                       (oldStudentProgramMap.get(agreement.id).Status__c != 'Application Under Review' ||
                        oldStudentProgramMap.get(agreement.id).RegistrationExceptionProcess__c != 'In Progress')){
                        //Create Case
                        casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                                                ContactID = studentAccountMap.get(agreement.Student__c).PersonContactID,
                                                Subject = studentAccountMap.get(agreement.Student__c).FirstName + ' ' + studentAccountMap.get(agreement.Student__c).LastName + ' ' + ' Registration Exception',
                                                Status = 'New',
                                                Priority = 'Medium',
                                                Reason = 'Eligibility',
                                                OwnerId=GlobalUtil.getQueueId('Origination'),
                                                Type = 'Problem',

                                                Agreement__c = agreement.id,
                                                School__c = programMap.get(agreement.Program__c).School__c,                                       
                                                Origin = 'Web'));
                    }
                    
                    if(agreement.LastDateOfAttendance__c != null && oldStudentProgramMap.get(agreement.id).LastDateOfAttendance__c == null){
                        casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                                                ContactID = studentAccountMap.get(agreement.Student__c).PersonContactID,
                                                Subject = 'Last Date of Attendance entered for Vemo Contract #: ' + agreement.VemoContractNumber__c,
                                                Status = 'New',
                                                Priority = 'Medium',
                                                Reason = 'Last Date of Attendance Entered',
                                                OwnerId=GlobalUtil.getQueueId('Servicing'),
                                                Type = 'Other',

                                                Agreement__c = agreement.id,
                                                School__c = programMap.get(agreement.Program__c).School__c,                                       
                                                Origin = 'Other'));    
                    }

                    manageCasesHasRun = true;                
                }
            }

        }
        System.debug('casesToAdd:'+casesToAdd);
        if(casesToAdd.size()>0){
            insert casesToAdd;
        }
        
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: manageDocuments
    /////////////////////////////////////////////////////////////////////////
    private void manageDocuments(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
system.debug('StudentProgramTriggerHandler.manageDocuments()'); 


            for(StudentProgram__c agreement: newStudentProgramMap.values()){
                if(!agreement.BypassAutomation__c){
                    system.debug('agreement:'+agreement);
                    if(!signedAgreementHasRun){
                        system.debug('signedAgreementHasRun is false');
                        if(agreement.CongaUnsignedAgreementStatus__c == 'Generate' && oldStudentProgramMap.get(agreement.id).CongaUnsignedAgreementStatus__c != 'Generate'){
                            LogService.critical('BEGIN - Backend Generate Unsigned Document:'+agreement.id, String.valueOf(agreement.id));
                            AgreementService.GenerateUnsignedAgreementQueueable doc = new AgreementService.GenerateUnsignedAgreementQueueable();
                            doc.agreementID = agreement.id;
                            doc.generateEsign = false;
                            doc.sessionID = UserInfo.getSessionId();
                            system.debug('enqueueJob for GenerateUnsignedAgreementQueueable');
                            system.enqueueJob(doc);
                            signedAgreementHasRun = true;
                        }
                    }
                    if(!finalDisclosureHasRun){
                        system.debug('finalDisclosureHasRun is false');
                        if(agreement.CongaFinalDisclosureStatus__c == 'Generate' && oldStudentProgramMap.get(agreement.id).CongaFinalDisclosureStatus__c != 'Generate'){
                            List<Attachment> existingFinalDisclosures = [Select id, Name, CreatedDate from Attachment where Name Like :AgreementService.finalDisclosureFileName(agreement.id)+'%'];
                            system.debug('existingFinalDisclosures:'+existingFinalDisclosures);
                            for(Attachment attach : existingFinalDisclosures){
                                attach.name = 'previous-'+String.valueOf(attach.CreatedDate)+'-'+attach.name;
                            }
                            if(existingFinalDisclosures.size()>0){
                                system.debug(existingFinalDisclosures);
                                update existingFinalDisclosures;    
                            } 


                            AgreementService.GenerateFinalDisclosureQueueable doc = new AgreementService.GenerateFinalDisclosureQueueable();
                            doc.agreementID = agreement.id;
                            doc.sessionID = UserInfo.getSessionId();
                            system.debug('enqueueJob for GenerateFinalDisclosureQueueable');
                            system.enqueueJob(doc);
                            finalDisclosureHasRun = true;
                        }
                    }
                    if(!adobeEsignHasRun) {
                        system.debug('adobeEsignHasRun is false');
                        if(agreement.AdobeSignStatus__c == 'Begin Signing Process' && oldStudentProgramMap.get(agreement.id).AdobeSignStatus__c != 'Begin Signing Process'){
                            LogService.critical('BEGIN - Backend Generate Adobe Esign: '+agreement.ID,String.valueOf(agreement.id));
                            AgreementService.GenerateESignDocQueueable sign = new AgreementService.GenerateESignDocQueueable();
                            sign.agreementID = agreement.id;
                            system.debug('enqueueJob for GenerateESignDocQueueable');
                            system.enqueueJob(sign);
                            adobeEsignHasRun = true;
                        }
                    }
                    if(!retrieveSignedDocHasRun) {
                        system.debug('retrieveSignedDocHasRun is false');
                        if(agreement.AgreementSigned__c == true && oldStudentProgramMap.get(agreement.id).AgreementSigned__c != true){
                            AgreementService.RetrieveSignedDocumentQueuable ret = new AgreementService.RetrieveSignedDocumentQueuable();
                            ret.agreementID = agreement.id;
                            system.debug('enqueueJob for RetrieveSignedDocumentQueuable');
                            system.enqueueJob(ret);
                            retrieveSignedDocHasRun = true;
                        }
                    }
                }

            }
        
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: getStudentAccountMap
    /////////////////////////////////////////////////////////////////////////
    private Map<ID, Account> getStudentAccountMap(List<StudentProgram__c> agreements){
        System.debug('StudentProgramTriggerHandler.getStudentAccountByAgreement()'); 
        if(studentAccountMap == null){
            Set<ID> studentIDs = new Set<ID>();
            for(StudentProgram__c agreement : agreements){
                studentIDs.add(agreement.Student__c);
            }
            studentAccountMap = AccountQueries.getStudentMapWithStudentID(studentIDs);            
        }
        return studentAccountMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: getProgramMap
    /////////////////////////////////////////////////////////////////////////
    private Map<ID, Program__c> getProgramMap(List<StudentProgram__c> agreements){
        System.debug('StudentProgramTriggerHandler.getProgramMap()'); 
        if(programMap == null){
            Set<ID> programIDs = new Set<ID>();
            for(StudentProgram__c agreement : agreements){
                programIDs.add(agreement.Program__c);
            }
            programMap = ProgramQueries.getProgramMapWithProgramID(programIDs);            
        }
        return programMap;
    }    
    /////////////////////////////////////////////////////////////////////////
    //Method: copyStudentInfo
    /////////////////////////////////////////////////////////////////////////
    private void copyStudentInfo(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
        System.debug('StudentProgramTriggerHandler.copyStudentInfo()'); 
        Set<ID> studentIDs = new Set<ID>();
        Map<ID, StudentProgram__c> agreementsNeedingStudentData = new Map<ID, StudentProgram__c>();
        for(StudentProgram__c agreement: newStudentProgramMap.values()){
            if(!agreement.BypassAutomation__c){
                if(oldStudentProgramMap != null){
                    if(agreement.CopyStudentInfo__c == true && oldStudentProgramMap.get(agreement.id).CopyStudentInfo__c != true && String.isNotEmpty(agreement.Student__c)){
                        studentIDs.add(agreement.Student__c);
                        agreementsNeedingStudentData.put(agreement.id, new StudentProgram__c(id = agreement.id, Student__c = agreement.Student__c));
                    }                
                } else if(agreement.CopyStudentInfo__c == true && String.isNotEmpty(agreement.Student__c)){
                        studentIDs.add(agreement.Student__c);
                        agreementsNeedingStudentData.put(agreement.id, new StudentProgram__c(id = agreement.id, Student__c = agreement.Student__c));
                }
            }


        }
        if(studentIDs.size()>0){
            //moving to static studentAccountMap
            //Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);

            for(StudentProgram__c agreement : agreementsNeedingStudentData.values()){
                if(studentAccountMap.containsKey(agreement.Student__c)){
                    agreement.GradeLevel__c = studentAccountMap.get(agreement.Student__c).PrimarySchoolGradeLevel__pc;
                    agreement.StudentEmail__c = studentAccountMap.get(agreement.Student__c).PersonEmail;
                    agreement.SchoolProgramOfStudy__c = studentAccountMap.get(agreement.Student__c).SchoolProgramOfStudy__pc;
                    agreement.Residency__c = studentAccountMap.get(agreement.Student__c).Residency__pc;
                    agreement.EnrollmentStatus__c = studentAccountMap.get(agreement.Student__c).PrimarySchoolEnrollmentStatus__pc;
                    agreement.ExpectedGraduationDate__c = studentAccountMap.get(agreement.Student__c).PrimarySchoolGraduationDate__pc;
                    if(agreement.AssessmentDayOfMonth__c == null){
                        agreement.AssessmentDayOfMonth__c = studentAccountMap.get(agreement.Student__c).AssessmentDayOfMonth__c;                        
                    }

                    agreement.CopyStudentInfo__c = false;                
                }
            }
            update agreementsNeedingStudentData.values();
        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: copyCreditCheckInfo
    /////////////////////////////////////////////////////////////////////////
    private void copyCreditCheckInfo(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
system.debug('StudentProgramTriggerHandler.copyCreditCheckInfo()'); 
        if(!copyCreditCheckInfoHasRun){
            system.debug('copyCreditCheckInfoHasRun is false');
            Map<ID, CreditCheck__c> ccByAgreementID = CreditCheckQueries.getCreditCheckMapByAgreementIDWithAgreementID(newStudentProgramMap.keySet());
            Map<ID, StudentProgram__c> agreementsNeedingCCData = new Map<ID, StudentProgram__c>();

            for(StudentProgram__c agreement: newStudentProgramMap.values()){
                if(!agreement.BypassAutomation__c){
                    if(agreement.CreditCheck__c != null){
                        agreementsNeedingCCData.put(agreement.ID, new StudentProgram__c(id = agreement.ID, 
                                                                                        CreditCheckDeniedReasonText__c = ccByAgreementID.get(agreement.id).CreditCheckDeniedReasonText__c));
                    }else{
                        agreementsNeedingCCData.put(agreement.ID, new StudentProgram__c(id = agreement.ID, 
                                                                                        CreditCheckDeniedReasonText__c = ''));
                    }
                }
            }

            copyCreditCheckInfoHasRun = true;
            if(agreementsNeedingCCData.size()>0){
                update agreementsNeedingCCData.values();
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: copyProgramInfo
    /////////////////////////////////////////////////////////////////////////
    private void copyProgramInfo(List<StudentProgram__c> newStudentProgramList){
system.debug('StudentProgramTriggerHandler.copyProgramInfo()'); 
        
        //moving to staticProgramMap
        //Set<ID> programIDs = new Set<ID>();
        //for(StudentProgram__c studProg : newStudentProgramList){
        //    programIDs.add(studProg.Program__c);
        //}
        //Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(programIDs);

        for(StudentProgram__c studProg : newStudentProgramList){
            if(!studProg.BypassAutomation__c){
                if(programMap.containsKey(studProg.Program__c)){
                    studProg.GraceMonthsAllowed__c = programMap.get(studProg.Program__c).GracePeriodMonths__c;
                    studProg.DefermentMonthsAllowed__c = programMap.get(studProg.Program__c).TotalDefermentMonths__c;
                    studProg.MinimumIncomePerMonth__c = programMap.get(studProg.Program__c).MinimumIncomePerMonth__c;
                    studProg.MinimumIncomePerYear__c = programMap.get(studProg.Program__c).MinimumIncomePerYear__c;
                }
            }
        }

    }

    /////////////////////////////////////////////////////////////////////////
    //Method: disclosureCalculations
    /////////////////////////////////////////////////////////////////////////
    private void disclosureCalculations(Map<ID, StudentProgram__c> oldStudentProgramMap, Map<ID, StudentProgram__c> newStudentProgramMap){
system.debug('StudentProgramTriggerHandler.disclosureCalculations()'); 
        List<StudentProgram__c> candidates = new List<StudentProgram__c>();
        for(StudentProgram__c agreement: newStudentProgramMap.values()){

            if(!agreement.BypassAutomation__c){
                StudentProgram__c agOld = oldStudentProgramMap == null ? null : oldStudentProgramMap.get(agreement.id);
                
                if(agOld == null ||
                        ((agreement.CongaUnsignedAgreementStatus__c == 'Generate' && agOld.CongaUnsignedAgreementStatus__c != 'Generate') ||
                        (agreement.CongaFinalDisclosureStatus__c == 'Generate' && agOld.CongaFinalDisclosureStatus__c != 'Generate') ||
                        (agreement.DisclosureCalculationProcess__c == 'Generate' && agOld.DisclosureCalculationProcess__c != 'Generate') ||
                        (agreement.Program__c != agOld.Program__c) ||
                        (agreement.AllocatedAmount__c != agOld.AllocatedAmount__c) ||
                        (agreement.IncomeShare__c != agOld.IncomeShare__c) ||
                        (agreement.PaymentCap__c != agOld.PaymentCap__c) ||
                        (agreement.PaymentTerm__c != agOld.PaymentTerm__c))){
                    
                    candidates.add(agreement);
                }
            }
        }

        if(!disclosureCalculationsHasRun){
            system.debug('disclosureCalculationsHasRun is false');
            System.Debug('*** candidates ' + candidates);
            DisclosureService.Calculation(candidates);
            //disclosureCalculationsHasRun = true;
        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: manageAudit
    /////////////////////////////////////////////////////////////////////////
    private void manageAudit(Map<ID, StudentProgram__c> oldStudentProgramMap,
                                Map<ID, StudentProgram__c> newStudentProgramMap){
        System.debug('***********Running manageAudit*************');
        List<StudentProgramAudit__c> auditToCreate = new List<StudentProgramAudit__c>();
        Set<String> excludeFields = new Set<String>{'studentprogram__c','auditdatetime__c','monthend__c'};    
        
        for(StudentProgram__c stud : newStudentProgramMap.values()){
            if(!stud.BypassAutomation__c){
                Boolean createAuditRecord = false;
                if(oldStudentProgramMap == null){
                    createAuditRecord = true;
                    continue;
                }
                //if(stud.Status__c != oldStudentProgramMap.get(stud.id).Status__c) createAuditRecord = true;
                //if(stud.Deferment__c != oldStudentProgramMap.get(stud.id).Deferment__c) createAuditRecord = true;
               
                
                
                SObjectType studentProgramAuditDescribe = Schema.getGlobalDescribe().get('StudentProgramAudit__c');
                Map<String,Schema.SObjectField> studProgAudFields = studentProgramAuditDescribe.getDescribe().fields.getMap();
                for(String fld : studProgAudFields.keySet()){
                    if(fld.endsWith('__c') && !excludeFields.contains(fld)){
                        if(stud.get(fld) != oldStudentProgramMap.get(stud.id).get(fld)){
                            System.debug('***********A Field Changed!!!!*************');
                            createAuditRecord = true;
                        }
                    }
                }
                System.debug('***********createAuditRecord = ' + createAuditRecord);
                if(createAuditRecord){
                    StudentProgramAudit__c audit = new StudentProgramAudit__c();
                    audit.StudentProgram__c = stud.Id;
                    for(String fld : studProgAudFields.keySet()){
                        if(fld.endsWith('__c') && !excludeFields.contains(fld)){
                            audit.put(fld, stud.get(fld));
                        }
                    }
                    auditToCreate.add(audit);
                }
                
                

                

            }
        }
        if(auditToCreate.size()>0){
            insert auditToCreate;
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageRTCDates
    /////////////////////////////////////////////////////////////////////////
    private void manageRTCDates(Map<ID, StudentProgram__c> oldStudentProgramMap,
                                Map<ID, StudentProgram__c> newStudentProgramMap){

        Set<ID> programIDs = new Set<ID>();
        for(StudentProgram__c stud : newStudentProgramMap.values()){
            programIDs.add(stud.Program__c);
        }
        
        //moving to static programMap variable
        //Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(programIDs);

        for(StudentProgram__c stud : newStudentProgramMap.values()){
            if(!stud.BypassAutomation__c){
                if(stud.SetRTCDates__c && !oldStudentProgramMap.get(stud.id).SetRTCDates__c){
                    stud.RightToCancelDate__c = GlobalUtil.addBusinessDays(Date.today().addDays(1), (Integer) programMap.get(stud.Program__c).RightToCancelDays__c);

                }
            }
        }
    }
    public class StudentProgramTriggerHandlerException extends Exception {}
}