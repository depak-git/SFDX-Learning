/////////////////////////////////////////////////////////////////////////
// Class: TestDataFactory
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created
// 2016-12-27   Greg Cook       Updated classes to have multiple prereq params                        
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class TestDataFactory {
 
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProspectAccounts
    /////////////////////////////////////////////////////////////////////////
    public static final String STUDENT_AUTH_KEY = 'testStudent_1';
    public static Integer nextNumber = 0;
    public static Map<ID, Account> createAndInsertSchoolProspectAccounts(Integer cnt) {
        List<Account> accts = new List<Account>();
        String recTypeID = GlobalUtil.getRecordTypeIDByLabelName('Account', 'School - Available Prospect');
        for (Integer i = 0; i<cnt; i++){
            accts.add(new Account(Name = 'Test Account '+String.valueOf(i),
                                  BillingStreet = 'Test Street',
                                  RecordTypeID = recTypeID));
        }
        Database.insert(accts,true);
        Map<ID, Account> acctMap = AccountQueries.getSchoolMap();
        return acctMap;

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProspectAccounts
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Account> createAndInsertSchoolCustomerAccounts(Integer cnt) {
        List<Account> accts = new List<Account>();
        for (Integer i = 0; i<cnt; i++){
            accts.add(new Account(Name = 'Test Account '+String.valueOf(i),
                                  BillingStreet = 'Test Street',
                                  RecordTypeID = (String) GlobalUtil.getRecordTypeIDByLabelName('Account', 'School - Customer')));
        }
        Database.insert(accts,true);
        Map<ID, Account> acctMap = AccountQueries.getSchoolMap();
        return acctMap;

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertPersonAccounts
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Account> createAndInsertStudentAccounts(Integer cnt) {
        List<Account> accts = new List<Account>();

        for (Integer i = 0; i<cnt; i++){
            accts.add(new Account(FirstName = 'Test First '+String.valueOf(i),
                                    LastName = 'Test Last '+String.valueOf(i),
                                    RecordTypeID = (String) GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student'),
                                    CommonLineID__pc = 'TestCommonLineID '+String.valueOf(i),
                                    AuthSystemUserID__pc = String.valueOf(VemoAPI_TEST.vemoAuth++)));
        }
        Database.insert(accts,true);
        Map<ID, Account> acctMap = AccountQueries.getStudentMap();
        return acctMap;

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertTestStudentAccount
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Account> createAndInsertTestStudentAccount() {
        Account acct = new Account(FirstName = 'Test First ',
                                LastName = 'Test Last ',
                                RecordTypeID = (String) GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student'),
                                CommonLineID__pc = 'TestCommonLineID ',
                                AuthSystemUserID__pc = STUDENT_AUTH_KEY.removeStart('testStudent_'));
        Database.insert(acct,true);
        Map<ID, Account> acctMap = AccountQueries.getStudentMap();
        return acctMap;

    }
     /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertCases
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Case> createAndInsertCases(Integer cnt) {
        List<Case> cases = new List<Case>();

        for (Integer i = 0; i<cnt; i++){
            cases.add(new Case(Subject = 'Test Case '+String.valueOf(i)));
        }
        Database.insert(cases,true);
        Map<ID, Case> caseMap = CaseQueries.getCaseMapByID();
        return caseMap;

    }   
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertOpportunities
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Opportunity> createAndInsertOpportunities(Integer cnt) {
        List<Opportunity> opps = new List<Opportunity>();

        for (Integer i = 0; i<cnt; i++){
            opps.add(new Opportunity(Name = 'Test Opp '+String.valueOf(i),
                                  StageName = 'Test Stage',
                                  CloseDate = Date.today()));
        }
        Database.insert(opps,true);
        Map<ID, Opportunity> oppMap = OpportunityQueries.getOpportunityMapByID();
        return oppMap;

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertContacts
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Contact> createAndInsertContacts(Integer cnt, Map<ID, Account> acctMapNeedingContacts) {
        List<Contact> conts = new List<Contact>();

        for(Account acct : acctMapNeedingContacts.values()){
            for (Integer i = 0; i<cnt; i++){
                conts.add(new Contact(LastName = 'Test Contact '+String.valueOf(i),
                                      AccountID = acct.id));
            }            
        }

        Database.insert(conts,true);
        Map<ID, Contact> contMap = ContactQueries.getContactMapByID();
        return contMap;

    }    
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertContacts
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Contact> createAndInsertStudentReferences(Integer cnt, Map<ID, Account> studentsMapNeedingReferences) {
        List<Contact> conts = new List<Contact>();

        for(Account acct : studentsMapNeedingReferences.values()){
            for (Integer i = 0; i<cnt; i++){
                conts.add(new Contact(LastName = 'Test Contact '+String.valueOf(i),
                                      Student__c = acct.id));
            }            
        }

        Database.insert(conts,true);
        Set<ID> contIDs = new Set<ID>();
        for(Contact cont : conts){
            contIDs.add(cont.id);
        }
        Map<ID, Contact> contMap = ContactQueries.getContactMapByIDWithContactID(contIDs);
        return contMap;

    }  
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProgram
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Program__c> createAndInsertPrograms(Integer cnt, Map<ID, Account> schoolMapNeedingPrograms){
        List<Program__c> prgs = new List<Program__c>();
        for(Account acct : schoolMapNeedingPrograms.values()){
            for (Integer i = 0; i<cnt; i++){
                prgs.add(new Program__c(ProgramName__c = 'Test Program '+String.valueOf(i),
                                      ProgramStatus__c = 'Planned',
                                      School__c = acct.Id));
            }            
        }

        Database.insert(prgs,true);
        Map<ID, Program__c> prgMap = ProgramQueries.getProgramMap();
        return prgMap;
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertAttendancePeriods
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, AttendancePeriod__c> createAndInsertAttendancePeriod(Integer cnt, Map<ID, Program__c> programsNeedingAttendancePeriods){
        List<AttendancePeriod__c> atdprd = new List<AttendancePeriod__c>();
        for(Program__c prg : programsNeedingAttendancePeriods.values()){
            for (Integer i = 0; i<cnt; i++){
                atdprd.add(new AttendancePeriod__c(Program__c = prg.id,
                                      AttendanceBeginDate__c = Date.today(),
                                      AttendanceEndDate__c = date.today().addMonths(1)));
            }            
        }

        Database.insert(atdprd,true);
        Map<ID, AttendancePeriod__c> atdprdMap = AttendancePeriodQueries.getAttendancePeriodMap();
        return atdprdMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProgram
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, TransactionSchedule__c> createAndInsertTransactionSchedule(Integer cnt, Map<ID, Program__c> programsNeedingSchedules){
        List<TransactionSchedule__c> txSch = new List<TransactionSchedule__c>();
        for(Program__c prog : programsNeedingSchedules.values()){
            for (Integer i = 0; i<cnt; i++){
                txSch.add(new TransactionSchedule__c(FundingAmount__c = 25,
                                      ScheduledDate__c = Date.today(),
                                      Program__c = prog.Id));
            }            
        }

        Database.insert(txSch,true);
        Map<ID, TransactionSchedule__c> txSchMap = TransactionScheduleQueries.getTransactionScheduleMap();
        return txSchMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertStudentProgram
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, StudentProgram__c> createAndInsertStudentProgram(Integer cnt,
                                                                            Map<ID, Account> studentMapNeedingAgreements,
                                                                            Map<ID, Program__c> programsNeedingAgreements){
        List<StudentProgram__C> studentPrgs = new List<StudentProgram__c>();
        for(Account student : studentMapNeedingAgreements.values()){
            for(Program__c prog : programsNeedingAgreements.values()){
                studentPrgs.add(new StudentProgram__c(Student__c = student.Id,
                                                    Program__c = prog.Id,
                                                    Status__c = 'Application Complete'));                
            }
        }

        Database.insert(studentPrgs, true);
        Map<ID, StudentProgram__c> studPrgMap = StudentProgramQueries.getStudentProgramMap();
        return studPrgMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertCreditCheck
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, CreditCheck__c> createAndInsertCreditCheck(Integer cnt, Map<ID, Account> studentsNeedingCreditChecks){
        List<CreditCheck__c> creditChecks = new List<CreditCheck__c>();
        for(Account acct : studentsNeedingCreditChecks.values()){
            creditChecks.add(new CreditCheck__c(Student__c = acct.id,
                                                ConsentIPAddress__c = '1.1.1.1',
                                                ConsentDateTimeStamp__c = System.now()));            
        }
        Database.insert(creditChecks, true);
        Map<ID, CreditCheck__c> ccMap = CreditCheckQueries.getCreditCheckMap();
        return ccMap;
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertCreditCriteria
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, CreditCriteria__c> createAndInsertCreditCriteria(Integer cnt, Map<ID, Program__c> ProgramsNeedingCreditCriteria){
        List<CreditCriteria__c> creditCriteria = new List<CreditCriteria__c>();
        for(Program__c prg : ProgramsNeedingCreditCriteria.values()){
            creditCriteria.add(new creditCriteria__c(Program__c = prg.id,
                                                 evaluationCriteria__c = 'FICO Score', declineType__c = 'Hard Decline', FICOScore__c = 670, FICOScoreOperator__c = '>'));            
        }
        Database.insert(creditCriteria, true);
        Map<ID, creditCriteria__c> ccMap = new Map<ID, creditCriteria__c>(creditCriteria);
        return ccMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertStudentAttachments
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Attachment> createAndInsertStudentAttachments(Integer cnt){
        List<Attachment> attachments = new List<Attachment>();
        Map<ID, Account> students = createAndInsertStudentAccounts(cnt);
        for(Integer i = 0; i<cnt; i++){
            String body = 'ABC' + i;
            attachments.add(new Attachment(ParentId = students.values().get(i).ID,
                                      Body = Blob.valueOf(body),
                                      ContentType = 'application/pdf',
                                      Name = 'Attachment'));
        }
        Database.insert(attachments, true);
        Map<ID, Attachment> attMap = AttachmentQueries.getAttachmentMap();
        return attMap;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAttachments
    /////////////////////////////////////////////////////////////////////////
    public static List<Attachment> createAttachments(Integer cnt, ID parentID){
        List<Attachment> attachments = new List<Attachment>();
        for(Integer i = 0; i<cnt; i++){
            String body = 'ABC' + i;
            attachments.add(new Attachment(ParentId = parentID,
                                      Body = Blob.valueOf(body),
                                      ContentType = 'application/pdf',
                                      Name = 'Attachment'));
        }
        return attachments;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAttachments
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Transaction__c> createAndInsertTransactions(Integer cnt, Map<ID, StudentProgram__c> agreements, String recordTypeLabel){
        List<Transaction__c> trans = new List<Transaction__c>();
        for(StudentProgram__c agreement : agreements.values()){
            for(Integer i = 0; i<cnt; i++){
                trans.add(new Transaction__c(Student__c = agreement.Student__c,
                                        Agreement__c = agreement.Id,
                                        Amount__c = 1000,
                                        TransactionDate__c = Date.today(),
                                        Status__c = 'Complete',
                                        RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', recordTypeLabel)));                
            }
        }
        Database.insert(trans, true);
        Map<ID, Transaction__c> tranMap = TransactionQueries.getTransactionMap(recordTypeLabel);
        return tranMap;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProgramOfStudy
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, ProgramOfStudy__c> createAndInsertProgramOfStudy(Integer cnt){
        List<ProgramOfStudy__c> posList = new List<ProgramOfStudy__c>();
        for(Integer i = 0; i<cnt; i++){
            ProgramOfStudy__c pos = new ProgramOfStudy__c();
            pos.CIPCode__c = 'CIP Code ' + i;
            pos.CIPDefinition__c = 'CIP Definition ' + i;
            pos.CIPFamily__c = 'CIP Family ' + i;
            pos.CIPTitle__c = 'CIP Title ' + i;
            pos.CrossReferences__c = 'Cross Reference ' + i;
            pos.Examples__c = 'Examples ' + i;
            posList.add(pos);
        }
        Database.insert(posList, true);
        Map<ID, ProgramOfStudy__c> posMap = ProgramOfStudyQueries.getProgramOfStudyMap();
        return posMap;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertSchoolProgramsOfStudy
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, SchoolProgramsOfStudy__c> createAndInsertSchoolProgramsOfStudy(Map<ID, Account> schools, Map<ID, ProgramOfStudy__c> programOfStudies){
        List<SchoolProgramsOfStudy__c> sposList = new List<SchoolProgramsOfStudy__c>();
        for(Account school : schools.values()){
            for(ProgramOfStudy__c pos : programOfStudies.values()){
                SchoolProgramsOfStudy__c spos = new SchoolProgramsOfStudy__c();
                spos.ProgramOfStudy__c = pos.ID;
                spos.School__c = school.ID;
                sposList.add(spos);
            }
        }
        Database.insert(sposList, true);
        Map<ID, SchoolProgramsOfStudy__c> posMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMap();
        return posMap;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProgramConfig
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Program_Config__c> createAndInsertProgramConfig(Integer cnt, Map<ID, Program__c> programs){
        List<Program_Config__c> configList = new List<Program_Config__c>();
        for(Program__c program : programs.values()){
            Program_Config__c config = new Program_Config__c(Program__c = program.Id);
            config.AssumedAnnualIncomeGrowth__c = 5;
            config.PaymentCapFactor__c = 2.5;
            config.InSchoolGraceMonthsDisbursement1__c = 15;
            config.InSchoolGraceMonthsDisbursement2__c = 11;
            
            configList.add(config);
        }
        Database.insert(configList, true);
        Map<ID, Program_Config__c> configMap = new Map<ID, Program_Config__c>(configList);
        return configMap;
    }




    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProgramConfigIncomes
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Config_Annual_Income_Level__c> createAndInsertProgramConfigIncomes(Map<ID, Program_Config__c> configs){
        List<Config_Annual_Income_Level__c> incomeList = new List<Config_Annual_Income_Level__c>();
        for(Program_Config__c config : configs.values()){
            Config_Annual_Income_Level__c income = new Config_Annual_Income_Level__c(ProgramConfig__c = config.Id);
            income.Income__c = 100000;
            income.IsMinimumThreshold__c = false;
            income.ListInIncomeGrowthExample__c = false;
            incomeList.add(income);
            
            income = new Config_Annual_Income_Level__c(ProgramConfig__c = config.Id);
            income.Income__c = 200000;
            income.IsMinimumThreshold__c = true;
            income.ListInIncomeGrowthExample__c = true;
            incomeList.add(income);
            
            income = new Config_Annual_Income_Level__c(ProgramConfig__c = config.Id);
            income.Income__c = 300000;
            income.IsMinimumThreshold__c = false;
            income.ListInIncomeGrowthExample__c = false;
            incomeList.add(income);
        }
        Database.insert(incomeList, true);
        Map<ID, Config_Annual_Income_Level__c> configMap = new Map<ID, Config_Annual_Income_Level__c>(incomeList);
        return configMap;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProgramConfigLoans
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Config_Loan_Alternative__c> createAndInsertProgramConfigLoans(Map<ID, Program_Config__c> configs){
        List<Config_Loan_Alternative__c> loanList = new List<Config_Loan_Alternative__c>();
        for(Program_Config__c config : configs.values()){
            Config_Loan_Alternative__c loan = new Config_Loan_Alternative__c(ProgramConfig__c = config.Id);
            loan.LoanType__c = 'Perkins';
            loan.InPaymentInterestRate__c = 5;
            loan.InSchoolInterestRate__c = 5;
            loan.OriginationFeePercentage__c = 0;
            loan.PaymentTerm__c = 120;
            loanList.add(loan);
            
            loan = new Config_Loan_Alternative__c(ProgramConfig__c = config.Id);
            loan.LoanType__c = 'Stafford Unsubsidized';
            loan.InPaymentInterestRate__c = 4.29;
            loan.InSchoolInterestRate__c = 4.29;
            loan.OriginationFeePercentage__c = 1.068000;
            loan.PaymentTerm__c = 120;
            loanList.add(loan);
        }
        Database.insert(loanList, true);
        Map<ID, Config_Loan_Alternative__c> configMap = new Map<ID, Config_Loan_Alternative__c>(loanList);
        return configMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertProgramEligibility
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, ProgramEligibility__c> createAndInsertProgramEligibility(Integer cnt, Map<ID, Program__c> programs){
        List<ProgramEligibility__c> eligibilityList = new List<ProgramEligibility__c>();
        for(Program__c program : programs.values()){
            ProgramEligibility__c eligibility = new ProgramEligibility__c(Program__c = program.Id);

            
            eligibilityList.add(eligibility);
        }
        Database.insert(eligibilityList, true);
        Map<ID, ProgramEligibility__c> eligibilityMap = new Map<ID, ProgramEligibility__c>(eligibilityList);
        return eligibilityMap;
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertContractTerm
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, ContractTerm__c> createAndInsertContractTerms(Integer cnt, Map<ID, Program__c> programMap){
        List<ContractTerm__c> terms = new List<ContractTerm__c>();
        for(Program__c prog : programMap.values()){
            for(Integer i = 0; i< cnt; i++){
                ContractTerm__c term = new ContractTerm__c(EarningsGroup__c = '1',
                                                           Program__c = prog.id,
                                                           GradeLevel__c = 'Senior',
                                                           IncomeShare__c = 1.2+i,
                                                           MaximumFundingAmount__c = 32000,
                                                           PaymentTerm__c = 90);   
                terms.add(term);             
            }
        }

        Database.insert(terms, true);
        Map<ID, ContractTerm__c> termMap = new Map<ID, ContractTerm__c>(terms);
        return termMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertContractTerm
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, IncomeBand__c> createAndInsertIncomeBands(Integer cnt, Map<ID, SchoolProgramsOfStudy__c> majorMap){
        List<IncomeBand__c> bands = new List<IncomeBand__c>();
        for(SchoolProgramsOfStudy__c major : majorMap.values()) {
            for(Integer i = 0; i<cnt; i++){
                IncomeBand__c band = new IncomeBand__c(EarningsGroup__c = '1',
                                                           SchoolProgramOfStudy__c = major.id);

                
                bands.add(band);                
            }
        }
        Database.insert(bands, true);
        Map<ID, IncomeBand__c> bandMap = new Map<ID, IncomeBand__c>(bands);
        return bandMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertEmploymentHistory
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, EmploymentHistory__c> createAndInsertEmploymentHistory(Integer cnt, Map<Id, Account> studentMap){
        List<EmploymentHistory__c> empHisList = new List<EmploymentHistory__c>();
        for(Account student : studentMap.values()){
            for(Integer i = 0; i<cnt; i++){
                EmploymentHistory__c empHis = new EmploymentHistory__c(Category__c = 'Employee',
                                                                        Employer__c = 'Test Employer ' + i,
                                                                        Student__c = student.Id,
                                                                        Type__c = 'Full Time',
                                                                        Verified__c = true);
                empHisList.add(empHis);
            }
        }
        Database.insert(empHisList, true);
        Map<ID, EmploymentHistory__c> empHisMap = new Map<ID, EmploymentHistory__c>(empHisList);
        return empHisMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertIncomeVerification
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, IncomeVerification__c> createAndInsertIncomeVerification(Integer cnt, Map<Id, EmploymentHistory__c> employmentHistoryMap){
        List<IncomeVerification__c> incVerList = new List<IncomeVerification__c>();
        for(EmploymentHistory__c employmentHis : employmentHistoryMap.values()){
            for(Integer i = 0; i<cnt; i++){
                IncomeVerification__c incVer = new IncomeVerification__c(IncomePerMonth__c = 1000,
                                                                        EmploymentHistory__c = employmentHis.Id,
                                                                        Student__c = employmentHis.Student__c,
                                                                        Verified__c = false);
                incVerList.add(incVer);
            }
        }
        Database.insert(incVerList, true);
        Map<ID, IncomeVerification__c> incVerMap = new Map<ID, IncomeVerification__c>(incVerList);
        return incVerMap;
    }


    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertPaymentMethod
    /////////////////////////////////////////////////////////////////////////
    
    public static Map<ID, PaymentMethod__c> createAndInsertPaymentMethod(Integer cnt, Map<Id, Account> studentAccountMap){
        List<PaymentMethod__c> paymentMethods = new List<PaymentMethod__c>();
        for(Account student : studentAccountMap.values()){
            for(Integer i = 0; i<cnt; i++){
                PaymentMethod__c pymntMthd = new PaymentMethod__c(BankAccountNumber__c = '1234',
                                                                        BankRoutingNumber__c = '5678',
                                                                        CreditCardNumber__c = '91011',
                                                                        Description__c = 'Credit Card',
                                                                        Primary__c = false,
                                                                        Customer__c = student.Id);
                paymentMethods.add(pymntMthd);
            }
        }
        Database.insert(paymentMethods, true);
        Map<ID, PaymentMethod__c> pymntMthdMap = new Map<ID, PaymentMethod__c>(paymentMethods);
        return pymntMthdMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertNotification
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Notification__c> createAndInsertNotification(Integer cnt, Map<Id, Contact> contactMap){
        List<Notification__c> notifications = new List<Notification__c>();
        for(Contact con : contactMap.values()){
            for(Integer i = 0; i<cnt; i++){
                Notification__c noti = new Notification__c(HtmlBody__c = 'HTML Body',
                                                                        PlainText__c = 'Plain Text',
                                                                        Subject__c = 'Test Subject',
                                                                        Contact__c = con.Id);
                notifications.add(noti);
            }
        }
        Database.insert(notifications, true);
        Map<ID, Notification__c> notMap = new Map<ID, Notification__c>(notifications);
        return notMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertPaymentInstruction
    /////////////////////////////////////////////////////////////////////////
    
    public static Map<ID, PaymentInstruction__c> createAndInsertPaymentInstruction(Integer cnt, Map<Id, Account> studentAccountMap, Map<Id, PaymentMethod__c> paymentMethodMap){
        List<PaymentInstruction__c> paymentInstructions = new List<PaymentInstruction__c>();
        for(PaymentMethod__c pymntMeth : paymentMethodMap.values()){
            Account student = studentAccountMap.get(pymntMeth.Customer__c);
            for(Integer i = 0; i<cnt; i++){
                PaymentInstruction__c pymntInt = new PaymentInstruction__c(Amount__c = 1000,
                                                                        Date__c = System.today(),
                                                                        PaymentMethod__c = pymntMeth.Id,
                                                                        Status__c = 'None',
                                                                        Student__c = student.Id);
                paymentInstructions.add(pymntInt);
            }
        }
        
        Database.insert(paymentInstructions, true);
        Map<ID, PaymentInstruction__c> pymntIntMap = new Map<ID, PaymentInstruction__c>(paymentInstructions);
        return pymntIntMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertStudentProgramMonthlyStatus
    /////////////////////////////////////////////////////////////////////////
    
    public static Map<ID, StudentProgramMonthlyStatus__c> createAndInsertStudentProgramMonthlyStatus(Integer numMonths, Map<Id, StudentProgram__c> studProgramMap){
        List<StudentProgramMonthlyStatus__c> studProgMonthStats = new List<StudentProgramMonthlyStatus__c>();
        Date today = System.today();
        for(StudentProgram__c studProg : studProgramMap.values()){
            for(Integer i = 0; i<numMonths; i++){
                Date prgDate = today.addMonths(i);
                StudentProgramMonthlyStatus__c studProgMonthStat = new StudentProgramMonthlyStatus__c(Activity__c = 'Payment',
                                                                        Agreement__c = studProg.Id,
                                                                        Month__c = monthMap.get(prgDate.month()),
                                                                        Year__c = String.valueOf(prgDate.year()));
                studProgMonthStats.add(studProgMonthStat);
            }
        }
        
        Database.insert(studProgMonthStats, true);
        Map<ID, StudentProgramMonthlyStatus__c> studProgMonthStatMap = new Map<ID, StudentProgramMonthlyStatus__c>(studProgMonthStats);
        return studProgMonthStatMap;
    }

    static Map<Integer, String> monthMap = new Map<Integer, String>{1 => 'January',
                                                                    2 => 'February',
                                                                    3 => 'March',
                                                                    4 => 'April',
                                                                    5 => 'May',
                                                                    6 => 'June',
                                                                    7 => 'July',
                                                                    8 => 'August',
                                                                    9 => 'September',
                                                                    10 => 'October',
                                                                    11 => 'November',
                                                                    12 => 'December'};
    

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertStudentProgramMonthlyStatus
    /////////////////////////////////////////////////////////////////////////
    
    public static Map<ID, StudentProgramAmountDue__c> createAndInsertStudentProgramAmountDue(Map<Id, StudentProgram__c> studProgramMap, Map<Id, StudentProgramMonthlyStatus__c> studProgMonthStatsMap){
        List<StudentProgramAmountDue__c> studProgAmountDues = new List<StudentProgramAmountDue__c>();
        Map<Id, List<StudentProgramMonthlyStatus__c>> agreementToMonthStatsMap = new Map<Id, List<StudentProgramMonthlyStatus__c>>();
        for(StudentProgramMonthlyStatus__c spms : studProgMonthStatsMap.values()){
            List<StudentProgramMonthlyStatus__c> msList = agreementToMonthStatsMap.get(spms.Agreement__c);
            if(msList == null){
                msList = new List<StudentProgramMonthlyStatus__c>();
                agreementToMonthStatsMap.put(spms.Agreement__c, msList);
            }
            msList.add(spms);
        }
        for(StudentProgram__c agreement : studProgramMap.values()){
            for(StudentProgramMonthlyStatus__c monthStat : agreementToMonthStatsMap.get(agreement.Id)){
                StudentProgramAmountDue__c spad = new StudentProgramAmountDue__c(Agreement__c = agreement.Id,
                                                                                    Amount__c = 1000,
                                                                                    ExcludeFromBalance__c = false,
                                                                                    StudentProgramMonthlyStatus__c = monthStat.Id, 
                                                                                    Type__c = 'Monthly Amount');
                studProgAmountDues.add(spad);
            }
        }
        Database.insert(studProgAmountDues, true);
        Map<ID, StudentProgramAmountDue__c> studProgAmountDueMap = new Map<ID, StudentProgramAmountDue__c>(studProgAmountDues);
        return studProgAmountDueMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertStudentProgramMonthlyStatus
    /////////////////////////////////////////////////////////////////////////
    
    public static Map<ID, PaymentAllocation__c> createAndInsertPaymentAllocation(Integer cnt, Map<Id, PaymentInstruction__c> paymentInstMap, Map<Id, StudentProgram__c> studProgMap){
        List<PaymentAllocation__c> paymentAllList = new List<PaymentAllocation__c>();
        //group records by student
        //student to payment instruction is 1 to 1
        //student to program is one to many
        Set<Id> studentIds = new Set<Id>();
        Map<Id, PaymentInstruction__c> studentToPIMap = new Map<Id, PaymentInstruction__c>();

        for(PaymentInstruction__c pi : paymentInstMap.values()){
            studentIds.add(pi.Student__c);
            studentToPIMap.put(pi.Student__c, pi);
        }
        Map<Id, List<StudentProgram__c>> studentToSPMap = new Map<Id, List<StudentProgram__c>>();
        for(StudentProgram__c sp : studProgMap.values()){
            List<StudentProgram__c> sps = studentToSPMap.get(sp.Student__c);
            if(sps == null){
                sps = new List<StudentProgram__c>();
                studentToSPMap.put(sp.Student__c, sps);
            }
            sps.add(sp);
        }
        
        for(Id studId : studentIds){
            for(StudentProgram__c sp : studentToSPMap.get(studId)){
                for(Integer i = 0; i < cnt; i++){
                    PaymentAllocation__c spad = new PaymentAllocation__c(Agreement__c = sp.Id,
                                                                        AllocationType__c = 'Monthly Amount',
                                                                        AmountAllocated__c = 1000,
                                                                        PaymentInstruction__c = studentToPIMap.get(studId).Id
                                                                        );
                    paymentAllList.add(spad);
                }
            }
        }
        Database.insert(paymentAllList, true);
        Map<ID, PaymentAllocation__c> paymentAllMap = new Map<ID, PaymentAllocation__c>(paymentAllList);
        return paymentAllMap;
    }


    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertStudentProgramMonthlyStatus
    /////////////////////////////////////////////////////////////////////////
    public static Map<Id, Fee__c> createAndInsertFee(Integer cnt, Map<Id, Account> studentMap){
        List<Fee__c> feeList = new List<Fee__c>();
        for(Account student : studentMap.values()){
            for(Integer i = 0; i < cnt; i++){
                Fee__c fee = new Fee__c(Customer__c = student.Id,
                                        Amount__c = 1000,
                                        Status__c = 'Unpaid',
                                        Type__c = ' Late Fee');
                feeList.add(fee);
            }
        }
        Database.insert(feeList, true);
        Map<ID, Fee__c> feeMap = new Map<ID, Fee__c>(feeList);
        return feeMap;
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertGenericDocument
    /////////////////////////////////////////////////////////////////////////
    public static Map<Id, GenericDocument__c> createAndInsertGenericDocument(Integer cnt){
        List<GenericDocument__c> docList = new List<GenericDocument__c>();
            for(Integer i = 0; i < cnt; i++){
                GenericDocument__c doc = new GenericDocument__c();
                docList.add(doc);
            }
        Database.insert(docList, true);
        Map<ID, GenericDocument__c> docMap = new Map<ID, GenericDocument__c>(docList);
        return docMap;
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertReconciliation
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, Reconciliation__c> createAndInsertReconciliation(Integer cnt) {
        List<Reconciliation__c> reconciliations = new List<Reconciliation__c>();

        for (Integer i = 0; i<cnt; i++){
            reconciliations.add(new Reconciliation__c());
        }
        Database.insert(reconciliations,true);
        Map<ID, Reconciliation__c> reconciliationMap = new Map<ID, Reconciliation__c>(reconciliations);
        return reconciliationMap;
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertReconciliationDetail
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, ReconciliationDetail__c> createAndInsertReconciliationDetail(Integer cnt, Map<ID, Reconciliation__c> reconciliationNeedingRDetails) {
        List<ReconciliationDetail__c> reconciliationDetails = new List<ReconciliationDetail__c>();
        
        for(Reconciliation__c rc : reconciliationNeedingRDetails.values()){
            for (Integer i = 0; i<cnt; i++){
                reconciliationDetails.add(new ReconciliationDetail__c(Reconciliation__c = rc.id));
            }
        }
        Database.insert(reconciliationDetails,true);
        Map<ID, ReconciliationDetail__c> reconciliationDetailMap = new Map<ID, ReconciliationDetail__c>(reconciliationDetails);
        return reconciliationDetailMap;
    }  
    
    /////////////////////////////////////////////////////////////////////////
    //Method: createAndInsertClrHouseStudentEnrollment
    /////////////////////////////////////////////////////////////////////////
    public static Map<ID, ClrHouseStudentEnrollment__c> createAndInsertClrHouseStudentEnrollment(Integer cnt, Map<ID, Account> accountNeedingClrHouseStudentEnrollment) {
        List<ClrHouseStudentEnrollment__c> clrHouseStudentEnrollments = new List<ClrHouseStudentEnrollment__c>();
        
        for(account ac : accountNeedingClrHouseStudentEnrollment.values()){
            for (Integer i = 0; i<cnt; i++){
                clrHouseStudentEnrollments.add(new ClrHouseStudentEnrollment__c( RequestorReturnField__c = ac.id+'_'));
            }
        }
        Database.insert(clrHouseStudentEnrollments,true);
        Map<ID, ClrHouseStudentEnrollment__c> clrHouseStudentEnrollmentMap = new Map<ID, ClrHouseStudentEnrollment__c>(clrHouseStudentEnrollments);
        return clrHouseStudentEnrollmentMap;
    }  


}