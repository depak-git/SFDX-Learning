public with sharing class StudentAccountBatch implements Database.Batchable<sObject>, Database.ALlowsCallouts{
    public enum JobType {RECURRING_PAYMENT_GENERATION, ACCOUNT_ASSESSMENT,ANNUAL_STATEMENT_GENERATION} 
    
    public String query {get;set;}
    public JobType job {get;set;}
    
    public StudentAccountBatch() {
        job = JobType.RECURRING_PAYMENT_GENERATION;
    }
    public StudentAccountBatch(String query) {
        this.query = query;
        job = JobType.RECURRING_PAYMENT_GENERATION;
    }   
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('StudentAccountBatch.start()');
        if(job == JobType.RECURRING_PAYMENT_GENERATION){
            if(String.isEmpty(this.query)){
                query = 'SELECT id from Account WHERE RecordTypeID = \'' + GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student') + '\'';
            }
        } else if (job == JobType.ACCOUNT_ASSESSMENT){
            if(String.isEmpty(this.query)){
                String dateToday = String.valueOf(Date.today());            
                query = 'SELECT id from Account WHERE RecordTypeID = \'' + GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student') + '\'';
                query += ' and (AssessmentDate__c <= '+dateToday + ' OR AssessAccount__c = true)';
            }
        }
        else if(job == JobType.ANNUAL_STATEMENT_GENERATION){
            if(String.isEmpty(this.query)){
                query = 'SELECT id,PersonContactID,PersonEmail from Account WHERE Receive_Annual_Statement__c = true AND RecordTypeID = \'' + GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student') + '\'';
            }
        }
        System.debug('job:'+job);
        System.debug('query:'+query);
        LogService.writeLogs();
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('StudentAccountBatch.execute()');
        Set<ID> scopeIDs = new Set<ID>();
        for(sObject sobj : scope){
            scopeIDs.add(sobj.id);
        }

        Set<String> preservicingAgreementStatus = new Set<String>{'Invited',
                                                                  'Application Incomplete',
                                                                  'Application Under Review',
                                                                  'Under Review',
                                                                  'Cancelled'};
        Set<String> closedStatus = new Set<String>{'Contract Satisfied',
                                                                  'Default',
                                                                  'Forgiven'};
        if(job == JobType.RECURRING_PAYMENT_GENERATION){
            Map<ID, Account> studentMap = new Map<ID, Account>([SELECT id,
                                                                       RecordTypeID,
                                                                       AutoPayment__pc,
                                                                       AutoPaymentDateActivated__pc,
                                                                       AutoPaymentDayOfMonth1__pc,
                                                                       AutoPaymentDayOfMonth2__pc,
                                                                       AutoPaymentFrequency__pc,
                                                                       NextAutoPaymentDate__c,
                                                                       PersonContactID,
                                                                              (SELECT Student__c, Status__c
                                                                               FROM Student_Programs__r
                                                                               WHERE Status__c NOT IN :preservicingAgreementStatus
                                                                               and Status__c NOT IN :closedStatus)

                                                                    FROM Account
                                                                    WHERE RecordTypeID = :GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student')
                                                                    and id = :scopeIDs
                                                                    and AutoPayment__pc = true
                                                                    and (AutoPaymentFrequency__pc = '1 Time Per Month' OR AutoPaymentFrequency__pc = 'On Due Date')
                                                                    and AutoPaymentDayOfMonth1__pc != null
                                                                    and ID IN (SELECT Student__c 
                                                                               FROM StudentProgram__c
                                                                               WHERE Status__c NOT IN :preservicingAgreementStatus
                                                                               and Status__c NOT IN :closedStatus)]);
            System.debug('studentMap:'+studentMap);
            recurringPaymentGeneration(studentMap);
            LogService.writeLogs();
        } else if (job == JobType.ACCOUNT_ASSESSMENT){
            Map<ID, Account> studentMap = new Map<ID, Account>([SELECT id,
                                                                       AssessAccount__c,
                                                                       AssessmentDate__c,
                                                                       AssessmentDayOfMonth__c,
                                                                       DueDayOfTheMonth__c,
                                                                       DueDate__c

                                                                    FROM Account
                                                                    WHERE RecordTypeID = :GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student')
                                                                    and id = :scopeIDs
                                                                    FOR UPDATE]);
            System.debug('studentMap:'+studentMap);
            accountAssessment(studentMap);
            LogService.writeLogs();
        } 
        else if(job == JobType.ANNUAL_STATEMENT_GENERATION){
            Set<ID> studentIDs = new Set<ID>();
            for(SObject obj : scope){
                studentIDs.add(obj.id);
            }
            StudentService.sendAnnualStatements(studentIDs);
        }
        
        LogService.writeLogs(); 
    }
    
    public void finish(Database.BatchableContext BC) {
        System.debug('StudentAccountBatch.finish()');
        if(job == StudentAccountBatch.JobType.ACCOUNT_ASSESSMENT){
            StudentAccountBatch batchJob = new StudentAccountBatch();
            batchJob.job = StudentAccountBatch.JobType.RECURRING_PAYMENT_GENERATION;
            Database.executeBatch(batchJob);
        }

        LogService.writeLogs();
    }
    
    private static void recurringPaymentGeneration(Map<ID, Account> studentMap){
        System.debug('StudentAccountBatch.recurringPaymentGenration()');
        List<PaymentInstruction__c> paymentsToCreate = new List<PaymentInstruction__c>();
        List<Case> casesToCreate = new List<Case>();
        Map<ID, Account> accountsToUpdate = new Map<ID, Account>();
        Map<ID, PaymentMethod__c> paymentMethodMap = PaymentMethodQueries.getPaymentMethodMapWithCustomerID(studentMap.keySet());
        Map<ID, Integer> studentDelinquencyMap = StudentService.getStudentDelinquencyMap(studentMap.keyset());
        Map<ID, List<PaymentMethod__c>> paymentMethodsByStudentID = new Map<ID, List<PaymentMethod__c>>();
        for(PaymentMethod__c paymentMethod : paymentMethodMap.values()){
            if(paymentMethod.UseForRecurring__c){
                if(!paymentMethodsByStudentID.containsKey(paymentMethod.Customer__c)){
                    paymentMethodsByStudentID.put(paymentMethod.Customer__c, new List<PaymentMethod__c>());
                }
                paymentMethodsByStudentID.get(paymentMethod.Customer__c).add(paymentMethod);
            }
        }

        Set<ID> acctsToCreatePayment = new Set<ID>();
        for(Account acct : studentMap.values()){
            System.debug('Account:'+acct);
            System.debug('Open Agreements:'+acct.Student_Programs__r);
            if(paymentMethodsByStudentID.containsKey(acct.id)){
                System.debug('Recurring Payment:'+paymentMethodsByStudentID.get(acct.id)[0]);
                acctsToCreatePayment.add(acct.id);          
            } else {
                casesToCreate.add(new Case(Type = 'Problem',
                                           Origin = 'Other',
                                           Priority = 'High',
                                           ContactID = studentMap.get(acct.id).PersonContactID,
                                           Subject = 'No Recurring Payment Method Found for Account '+acct.id));
                //throw new StudentAccountBatchException('No Payment Method found for '+acct.id);
            }
        }
        Map<ID, PaymentInstruction__c> paymentMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentStudentID(acctsToCreatePayment);
        Map<ID, List<PaymentInstruction__c>> paymentsByStudent = new Map<ID, List<PaymentInstruction__c>>();
        for(PaymentInstruction__c payment : paymentMap.values()){
            if(payment.Status__c == 'Created By Student' || payment.Status__c == 'Automatically Created'){
                if(!paymentsByStudent.containsKey(payment.Student__c)){
                    paymentsByStudent.put(payment.Student__c, new List<PaymentInstruction__c>());
                }
                paymentsByStudent.get(payment.Student__c).add(payment);             
            }

        }

        Map<ID, StatementService.StatementV1> statements = StatementService.getCurrentStatementV1ByStudentWithStudentID(acctsToCreatePayment);
        Map<ID, Decimal> amountDueByStudentID = new Map<ID, Decimal>();
        

        Date systemDate = Date.today();//for testing
        //systemDate = Date.newInstance(2018, 4, 16);//for testing
        
        for(ID theID : acctsToCreatePayment){
            if(statements.containsKey(theID) && statements.get(theID).totalAmountDue > 0){
                System.debug('Statement '+statements.get(theID));
                amountDueByStudentID.put(theID, statements.get(theID).totalAmountDue);
            }
            if(paymentsByStudent.containsKey(theID)){
                System.debug('Student '+theID + ' has an existing Payment Instruction.  Skipping');
            } else if(!amountDueByStudentID.containsKey(theID)){
                System.debug('Student '+theID + ' has no total amount due.  Skipping');
            } else if((studentMap.get(theID).NextAutoPaymentDate__c <= Date.today()) ||
                      (studentMap.get(theID).NextAutoPaymentDate__c == null) ||
                      (studentDelinquencyMap.containsKey(theID) && studentDelinquencyMap.get(theID)>30)){

                System.debug('Create');
                System.debug('studentMap.get(theID).NextAutoPaymentDate__c'+studentMap.get(theID).NextAutoPaymentDate__c);
                try{
                    System.debug('delinquency:'+studentDelinquencyMap.get(theID));                  
                } catch (Exception e){
                    System.debug('no delinquency');
                }

                paymentsToCreate.add(new PaymentInstruction__c(Student__c = theID,
                                                               PaymentMethod__c = paymentMethodsByStudentID.get(theID)[0].id,
                                                               Status__c = 'Automatically Created',
                                                               TransactionDirection__c = 'Inbound',
                                                               Description__c = 'Auto Payment',
                                                               Date__c = systemDate,
                                                               Amount__c = amountDueByStudentID.get(theID)));

                Boolean advanceAutoPaymentDate = false; 
                if(studentMap.get(theID).NextAutoPaymentDate__c <= systemDate || studentMap.get(theID).NextAutoPaymentDate__c == null) advanceAutoPaymentDate = true;
                if(advanceAutoPaymentDate){
                    Integer nextPaymentYear = (systemDate.month() == 12) ? systemDate.year() + 1 : systemDate.year();
                    Integer nextPaymentMonth = (systemDate.month() == 12) ? 1 : systemDate.month() + 1;
                    Integer nextPaymentDay = Integer.valueOf(studentMap.get(theID).AutoPaymentDayOfMonth1__pc);
                    accountsToUpdate.put(theID, new Account(id = theID, 
                                                     NextAutoPaymentDate__c = Date.newInstance(nextPaymentYear, nextPaymentMonth, nextPaymentDay)));                
                }               
            } else {
                System.debug(theID + ' does Not meet the criteria to create payment instructions');
            }
        }
        if(paymentsToCreate.size()>0){
            insert paymentsToCreate;
        }
        if(casesToCreate.size()>0){
            Database.insert(casesToCreate, false);
        }
        if(accountsToUpdate.size()>0){
            Database.update(accountsToUpdate.values(), false);          
        }

        LogService.writeLogs();
    }

    private static void accountAssessment(Map<ID, Account> studentMap){
        System.debug('StudentAccountBatch.accountAssessment()');
        Date systemDate = Date.today();//for testing
        //systemDate = Date.newInstance(2018, 4, 16);//for testing

        String systemYear = String.valueOf(systemDate.year());
        String systemMonth = '';
        if(systemDate.month() ==1){
            systemMonth = 'Janurary';
        } else if(systemDate.month() ==2){
            systemMonth = 'February';
        } else if(systemDate.month() ==3){
            systemMonth = 'March';
        } else if(systemDate.month() ==4){
            systemMonth = 'April';
        } else if(systemDate.month() ==5){
            systemMonth = 'May';
        } else if(systemDate.month() ==6){
            systemMonth = 'June';
        } else if(systemDate.month() ==7){
            systemMonth = 'July';
        } else if(systemDate.month() ==8){
            systemMonth = 'August';
        } else if(systemDate.month() ==9){
            systemMonth = 'September';
        } else if(systemDate.month() ==10){
            systemMonth = 'October';
        } else if(systemDate.month() ==11){
            systemMonth = 'November';
        } else if(systemDate.month() ==12){
            systemMonth = 'December';
        }
        System.debug('systemDate:'+systemDate);
        DateTime monthBeginDate = Date.newInstance(systemDate.year(), systemDate.month(), 1);
        DateTime monthEndDate;
        if(systemMonth == 'December'){
            monthEndDate = Date.newInstance(systemDate.year()+1, 1, 1);
        } else {
            monthEndDate = Date.newInstance(systemDate.year(), systemDate.month()+1, 1);            
        }


        ///////////////////////////////////////////Get Income Data///////////////////////////////////////////////
        Map<ID, IncomeVerification__c> incVerMap = new Map<ID, IncomeVerification__c>([SELECT Id, MonthlyIncome__c, Student__c, Verified__c
                                                                                        FROM IncomeVerification__c
                                                                                        WHERE Verified__c = true
                                                                                        AND BeginDate__c < :Date.today()
                                                                                        AND Student__c IN :studentMap.keySet()
                                                                                        ORDER BY BeginDate__c desc]);

        Map<ID, List<IncomeVerification__c>> incomeByStudent = new Map<ID, List<IncomeVerification__c>>();
        for(IncomeVerification__c income : incVerMap.values()){
            if(!incomeByStudent.containsKey(income.Student__c)){
                incomeByStudent.put(income.Student__c, new List<IncomeVerification__c>());
            }
            incomeByStudent.get(income.Student__c).add(income);
        }
        System.debug('incomeByStudent:'+incomeByStudent);


        ///////////////////////////////////////////Get Agreement Data///////////////////////////////////////////////
        Map<ID, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMapWithStudentID(studentMap.keySet());
        System.debug('studProgramMap:'+studProgramMap);
        Map<ID, List<StudentProgram__c>> agreementsByStudent = new Map<ID, List<StudentProgram__c>>();
        for(StudentProgram__c agreement : studProgramMap.values()){
            if(!agreementsByStudent.containsKey(agreement.Student__c)){
                agreementsByStudent.put(agreement.Student__c, new List<StudentProgram__c>());
            }
            agreementsByStudent.get(agreement.Student__c).add(agreement);
        }
        System.debug('agreementsByStudent:'+agreementsByStudent);


        ////////////////////////////////////////Monthly Tracker Data Structures//////////////////////////////////////
        List<StudentProgramMonthlyStatus__c> monthlyTrackerToAdd = new List<StudentProgramMonthlyStatus__c>();
        Map<Id,StudentProgramMonthlyStatus__c> existingMonthlyTrackers = new Map<ID, StudentProgramMonthlyStatus__c>([SELECT id, Agreement__c, Year__c, Month__c, Activity__c, MonthlyStatusGUID__c
                                                                                                                      FROM StudentProgramMonthlyStatus__c
                                                                                                                      WHERE Agreement__c IN :studProgramMap.keySet()
                                                                                                                      AND Year__c = :systemYear
                                                                                                                      AND Month__c = :systemMonth]);
        System.debug('existingMonthlyTrackers:'+existingMonthlyTrackers);

        Map<ID, List<StudentProgramMonthlyStatus__c>> monthlyTrackersByAgreement = new Map<ID, List<StudentProgramMonthlyStatus__c>>();
        for(StudentProgramMonthlyStatus__c tracker : existingMonthlyTrackers.values()){
            if(!monthlyTrackersByAgreement.containsKey(tracker.Agreement__c)){
                monthlyTrackersByAgreement.put(tracker.Agreement__c, new List<StudentProgramMonthlyStatus__c>());
            }
            monthlyTrackersByAgreement.get(tracker.Agreement__c).add(tracker);
        }
        System.debug('monthlyTrackersByAgreement:'+monthlyTrackersByAgreement);


        ////////////////////////////////////////Amount Due Data Structures//////////////////////////////////////
        List<StudentProgramAmountDue__c> amountDueToAdd = new List<StudentProgramAmountDue__c>();
        Map<ID, StudentProgramAmountDue__c> existingAmountDue = new Map<ID, StudentProgramAmountDue__c>([SELECT id, Agreement__c, AMount__c, AssessmentDateTime__c, ExcludeFromBalance__c, Type__c, StudentProgramMonthlyStatus__c
                                                                                                         FROM StudentProgramAmountDue__c
                                                                                                         WHERE Agreement__c IN : studProgramMap.keySet()
                                                                                                         AND AssessmentDateTime__c > :monthBeginDate
                                                                                                         AND AssessmentDateTime__c < :monthEndDate
                                                                                                         AND Type__c = 'Monthly Amount'
                                                                                                         AND ExcludeFromBalance__c = false]);
        System.debug('existingAmountDue:'+existingAmountDue);
        Map<ID, List<StudentProgramAmountDue__c>> amountDueByAgreement = new Map<ID, List<StudentProgramAmountDue__c>>();
        for(StudentProgramAmountDue__c amountDue : existingAmountDue.values()){
            if(!amountDueByAgreement.containsKey(amountDue.Agreement__c)){
                amountDueByAgreement.put(amountDue.Agreement__c, new List<StudentProgramAmountDue__c>());
            }
            amountDueByAgreement.get(amountDue.Agreement__c).add(amountDue);
        }   


        for(Account acct : studentMap.values()){
            System.debug('On acct:'+acct);

            //////////////////////////////Loop Through Agreements////////////////////////////////////////
            for(StudentProgram__c agreement : agreementsByStudent.get(acct.id)){
                System.debug('On agreement:'+agreement);
                String guid = agreement.id + ':' + systemYear + ':' + systemMonth;
                StudentProgramMonthlyStatus__c monthlyStatus;
                //////////////////////////////Update Monthly Tracker////////////////////////////////////////
                //Check to see if a monthly tracker exists.  If it DOES exist, skip this section
                if(!monthlyTrackersByAgreement.containsKey(agreement.id)){
                    String status = studProgramMap.get(agreement.id).Status__c;
                    Set<String> servicingStatus = new Set<String>{'Grace',
                                                                  'Deferment',
                                                                  'Payment',
                                                                  'Internship',
                                                                  'School',
                                                                  'Leave of Absence'};
                    if(servicingStatus.contains(status)){
                            monthlyStatus = new StudentProgramMonthlyStatus__c(Agreement__c = agreement.id,
                                                                                        Year__c = systemYear,
                                                                                        Month__c = systemMonth,
                                                                                        Activity__c = status,
                                                                                        MonthlyStatusGUID__c = guid);
                            monthlyTrackerToAdd.add(monthlyStatus);                                 
                    }
                } else {
                    monthlyStatus = monthlyTrackersByAgreement.get(agreement.id)[0];
                }

                //////////////////////////////Update Amount Due////////////////////////////////////////
                //Check to see if a monthly amount exists.  If it DOES exist, skip this section
                if(!amountDueByAgreement.containsKey(agreement.id)){
                    StudentProgramMonthlyStatus__c existingMonthlyStatus = new StudentProgramMonthlyStatus__c(MonthlyStatusGUID__c = guid);
                    Decimal amount = 0;
                    Set<String> paymentStatus = new Set<String>{'Payment','Internship'};
                    try{
                        if(paymentStatus.contains(monthlyStatus.Activity__c)){
                            Decimal latestVerifiedMonthlyIncome = incomeByStudent.get(acct.id)[0].MonthlyIncome__c;
                            amount = (latestVerifiedMonthlyIncome * (agreement.IncomeSharePostCertification__c == null ? 0 :agreement.IncomeSharePostCertification__c)/100);
                        } else {
                            amount = 0;
                        }                       
                    } catch (Exception e){
                        System.debug('error calculating amount');
                        amount = 0;
                    }

                    amountDueToAdd.add(new StudentProgramAmountDue__c(Agreement__c = agreement.id,
                                                                      Type__c = 'Monthly Amount',
                                                                      AssessmentDateTime__c = DateTime.now(),
                                                                      Amount__c = amount,
                                                                      ExcludeFromBalance__c = false,
                                                                      StudentProgramMonthlyStatus__r = existingMonthlyStatus));
                }

            }






            //////////////////////////////Update Assessment Date////////////////////////////////////////

            System.debug('acct.AssessmentDate__c:'+acct.AssessmentDate__c);
            System.debug('acct.AssessmentDayOfMonth__c:'+acct.AssessmentDayOfMonth__c);
            Boolean advanceAssessmentDate = false; 
            if(acct.AssessmentDate__c <= systemDate || acct.AssessmentDate__c == null) advanceAssessmentDate = true;
            if(advanceAssessmentDate){
                System.debug('advanceAssessmentDate');
                Integer nextAssessmentYear = systemDate.year();
                Integer nextAssessmentMonth = systemDate.month();
                if(acct.AssessmentDayOfMonth__c < systemDate.day()){
                    //Advance the month
                    nextAssessmentYear = (systemDate.month() == 12) ? systemDate.year() + 1 : systemDate.year();
                    nextAssessmentMonth = (systemDate.month() == 12) ? 1 : systemDate.month() + 1;                  
                }

                Integer nextAssessmentDay = Integer.valueOf(acct.AssessmentDayOfMonth__c);
                acct.AssessmentDate__c = Date.newInstance(nextAssessmentYear, nextAssessmentMonth, nextAssessmentDay);      

                System.debug('Set acct.AssessmentDate__c:'+acct.AssessmentDate__c);     
            }
            //////////////////////////////Update Due Date////////////////////////////////////////
            Boolean advanceDueDate = false; 
            if(acct.DueDate__c <= systemDate || acct.DueDate__c == null) advanceDueDate = true;
            if(advanceDueDate){
                Integer nextDueDateYear = systemDate.year();
                Integer nextDueDateMonth = systemDate.month();
                if(acct.DueDayOfTheMonth__c < systemDate.day()){
                    //Advance the month
                    nextDueDateYear = (systemDate.month() == 12) ? systemDate.year() + 1 : systemDate.year();
                    nextDueDateMonth = (systemDate.month() == 12) ? 1 : systemDate.month() + 1;
                }
                Integer nextDueDateDay = Integer.valueOf(acct.DueDayOfTheMonth__c);
                acct.DueDate__c = Date.newInstance(nextDueDateYear, nextDueDateMonth, nextDueDateDay);              
            }
            acct.AssessAccount__c = false;
        }

        if(monthlyTrackerToAdd.size()>0){
            Database.insert(monthlyTrackerToAdd);
        }
        if(amountDueToAdd.size()>0){
            Database.insert(amountDueToAdd);
        }

        Database.update(studentMap.values());
        LogService.writeLogs();

    }

    public class StudentAccountBatchException extends Exception {}
}