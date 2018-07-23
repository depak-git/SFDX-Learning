global with sharing class SandboxSetup implements SandboxPostCopy {



    public static String orgUserTag;

    global void runApexClass(SandboxContext context) {

        System.debug('SandboxSetup.runApexClass()');
        System.debug('context:'+context);
        System.debug('UserInfo.getUserId()'+UserInfo.getUserId());
        System.debug('UserInfo.getUserEmail()'+UserInfo.getUserEmail());
        System.debug('UserInfo.getUserName()'+UserInfo.getUserName());
        System.debug('UserInfo.getUserType()'+UserInfo.getUserType());
        System.debug('UserInfo.getUserRoleId()'+UserInfo.getUserRoleId());
        System.debug('UserInfo.getName()'+UserInfo.getName());

        Set<String> fullCopyOrgs = new Set<String>{'UAT', 'QA', 'FullCopy'};

        if(fullCopyOrgs.contains(context.sandBoxName())){
            System.debug('run maskData');
            maskData(); 
        } else {
            System.debug('run newData');
            newData();
        }

        updateUsers(context.sandboxName().toLowerCase());

    }
    public static void maskData(){
        SandboxSetupMaskData job = new SandboxSetupMaskData();
        job.sObj = 'Contact';
        Database.executeBatch(job);
    }


    public static void newData(){

        createSchools();
        createProgramOfStudy();
        createCongaQueries();
        createCongaTemplates();
        createCongaSolutions();
        createPrograms();

    }


    public static void copyUsersToSandboxSetupTable(){
        Map<String, SandboxSetupUsers__c> sandboxUserMap = SandboxSetupUsers__c.getAll();
        Map<String, SandboxSetupUsers__c> sandboxUserByName = new Map<String, SandboxSetupUsers__c>();
        List<SandboxSetupUsers__c> ssuToAdd = new List<SandboxSetupUsers__c>();
        for(SandboxSetupUsers__c ssu : sandboxUserMap.values()){
            sandboxUserByName.put(ssu.Name, ssu);
        }
        System.debug('sandboxUserByName:'+sandboxUserByName);

        Set<String> profilesToCopy = new Set<String>{'System Administrator', '1.0 - Vemo Default'};
        Map<ID, User> userMap = new Map<ID, User>([SELECT ID, Name, Username, Email, UserRoleID, UserRole.Name, ProfileID, Profile.Name, IsActive
                                                   FROM User
                                                   WHERE Profile.Name IN :profilesToCopy]);
        System.debug('userMap:'+userMap);

        for(User usr : userMap.values()){
            System.debug('usr:'+usr);
            System.debug(usr.Name);
            if(sandboxUserByName.containsKey(String.valueOf(usr.Name))){
                System.debug('Found existing');
            } else {
                ssuToAdd.add(new SandboxSetupUsers__c(Name = usr.Name,
                                                      isActive__c = false,
                                                      ProductionUserName__c = usr.Username,
                                                      ProfileName__c = usr.Profile.Name,
                                                      ResetEmailAddress__c = false,
                                                      ResetPassword__c = false,
                                                      RoleName__c = usr.UserRole.Name));
            }

        }
        if(ssuToAdd.size()>0){
            System.debug(ssuToAdd);
            insert ssuToAdd;
        }
    }

    public static void updateUsers(String orgUserTag){
        Map<String, SandboxSetupUsers__c> sandboxUserMap = SandboxSetupUsers__c.getAll();
        Set<String> roleNames = new Set<String>();
        Set<String> profileNames = new Set<String>();
        Set<String> userNames = new Set<String>();
        for(SandboxSetupUsers__c ssu : sandboxUserMap.values()){
            if(String.isNotEmpty(ssu.RoleName__c)) roleNames.add(ssu.RoleName__c);
            if(String.isNotEmpty(ssu.ProfileName__c)) profileNames.add(ssu.ProfileName__c);
            if(String.isNotEmpty(ssu.ProductionUserName__c)) userNames.add(ssu.ProductionUserName__c + '.' + orgUserTag);
        }
        system.debug('roleNames:'+roleNames);
        system.debug('profileNames:'+profileNames);
        system.debug('userNames:'+userNames);

        Map<ID, UserRole> roleMap = new Map<ID, UserRole>([SELECT id, Name from UserRole where Name  = :roleNames]);
        Map<ID, Profile> profileMap = new Map<ID, Profile>([SELECT id, Name from Profile where Name = :profileNames]); 
        Map<ID, User> userMap = new Map<ID, User>([SELECT Id, Name, UserName, LastName, FirstName, Email, IsActive FROM User where UserName = :userNames]);
        
        system.debug('roleMap:'+roleMap);
        system.debug('profileMap:'+profileMap);
        system.debug('userMap:'+userMap);

        Map<String, UserRole> roleByName = new Map<String, UserRole>();
        Map<String, Profile> profileByName = new Map<String, Profile>();

        Map<String, SandboxSetupUsers__c> sandboxUserBySandboxUserName = new Map<String, SandboxSetupUsers__c>();

        for(UserRole ur : roleMap.values()){
            roleByName.put(ur.Name, ur);
        }
        for(Profile prf : profileMap.values()){
            profileByName.put(prf.Name, prf);
        }
        for(SandboxSetupUsers__c ssu : sandboxUserMap.values()){
            sandboxUserBySandboxUserName.put(ssu.ProductionUserName__c + '.' + orgUserTag, ssu);
        }
        System.debug('sandboxUserBySandboxUserName:'+sandboxUserBySandboxUserName);

        for(User usr : userMap.values()){
            System.debug('usr:'+usr);
            if(sandboxUserBySandboxUserName.containsKey(usr.Username)){
                SandboxSetupUsers__c ssUser = sandboxUserBySandboxUserName.get(usr.Username);
                System.debug('ssUser:'+ssUser);
                //email
                //ben.shiflet=vemo.com@example.com would become ben.shiflet@vemo.com
                if(ssUser.ResetEmailAddress__c){
                    system.debug('reset email');
                    if(usr.email.contains('@example.com')){
                        system.debug('found bad email');
                        usr.email = usr.email.remove('@example.com');
                        usr.email = usr.email.replace('=', '@');
                        system.debug(usr.email);
                    }
                }
                if(String.isNotBlank(ssUser.ProfileName__c)){
                    System.debug('Set Profile');
                    if(profileByName.containsKey(ssUser.ProfileName__c)){
                        System.debug('found Profile:'+profilebyName.get(ssUser.ProfileName__c));
                        usr.ProfileID = profileByName.get(ssUser.ProfileName__c).id;
                    }
                }
                if(String.isNotBlank(ssUser.RoleName__c)){
                    if(roleByName.containsKey(ssUser.RoleName__c)){
                        usr.UserRoleID = roleByName.get(ssUser.RoleName__c).id;
                    }
                }
                usr.IsActive = ssUser.IsActive__c;
            }
        }
        system.debug(userMap);
        Database.update (userMap.values(), false);


    }

    private static Map<ID, Account> createdSchools = new Map<ID, Account>();
    private static Map<ID, Program__c> createdPrograms = new Map<ID, Program__c>();
    private static Map<ID, APXTConga4__Conga_Template__c> createdCongaTemplates = new Map<ID, APXTConga4__Conga_Template__c>();
    private static Map<ID, SchoolProgramsOfStudy__c> createdSchoolProgramOfStudy = new Map<ID, SchoolProgramsOfStudy__c>();

    public static void createSchools(){
        List<Account> acctsToCreate = new List<Account>();
        //Create Vemo Account
        acctsToCreate.add(new Account(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Account', 'School - Customer'),
                                      Name = 'Vemo School',
                                      EntryPoint__c = 'myaccount'));


        insert acctsToCreate;
        createdSchools = new Map<ID, Account>(acctsToCreate);

    }

    public static void createCongaQueries(){
        List<APXTConga4__Conga_Merge_Query__c> queries = new List<APXTConga4__Conga_Merge_Query__c>();
        APXTConga4__Conga_Merge_Query__c query1 = new APXTConga4__Conga_Merge_Query__c();
        query1.APXTConga4__Name__c = 'Agreement and Related Objects';
        query1.APXTConga4__Description__c = 'StudentProgram__c, Account(Student), Account(School), Program__c';
        query1.APXTConga4__Query__c = 'SELECT Student__r.FirstName, Student__r.LastName, Student__r.PersonMailingStreet, Student__r.PersonEmail, Student__r.PersonMailingCity, Student__r.PersonMailingState, Student__r.PersonMailingPostalCode, Student__r.PersonMobilePhone, Program__r.ProgramName__c, Program__r.ProgramStatus__c, Program__r.School__r.Name FROM StudentProgram__c WHERE Id = \'{pv0}\' LIMIT 1';
        queries.add(query1);

        APXTConga4__Conga_Merge_Query__c query2 = new APXTConga4__Conga_Merge_Query__c();
        query2.APXTConga4__Name__c = 'Loan Alternatives';
        query2.APXTConga4__Description__c = 'Loan Alternatives';
        query2.APXTConga4__Query__c = 'SELECT InterestRates__c, LoanType__c, Name, OriginationFeeSurcharge__c, StudentProgram__c, TotalPayment__c FROM Studnet_Loan_Alternative_Payment__c WHERE StudentProgram__r.Id = \'{pv0}\' LIMIT 50';
        queries.add(query2);

        APXTConga4__Conga_Merge_Query__c query3 = new APXTConga4__Conga_Merge_Query__c();
        query3.APXTConga4__Name__c = 'ISA Payments';
        query3.APXTConga4__Description__c = 'ISA Payments';
        query3.APXTConga4__Query__c = 'SELECT AnnualIncomeLevel__c, IsPaymentCap__c, MonthlyPaymentFlat__c, ListInIncomeGrowthExample__c, TotalPaymentsFlat__c, TotalPaymentsWithIncomeGrowth__c from Student_ISA_Payment__c WHERE StudentProgram__r.Id = \'{pv0}\' order by AnnualIncomeLevel__c LIMIT 50';
        queries.add(query3);

        APXTConga4__Conga_Merge_Query__c query4 = new APXTConga4__Conga_Merge_Query__c();
        query4.APXTConga4__Name__c = 'ISA Payments Income Growth Example';
        query4.APXTConga4__Description__c = 'ISA Payments Income Growth Example';
        query4.APXTConga4__Query__c = 'SELECT AnnualIncomeLevel__c, IsPaymentCap__c, MonthlyPaymentFlat__c, ListInIncomeGrowthExample__c, TotalPaymentsFlat__c, TotalPaymentsWithIncomeGrowth__c from Student_ISA_Payment__c WHERE StudentProgram__r.Id = \'{pv0}\' and ListInIncomeGrowthExample__c = true order by AnnualIncomeLevel__c LIMIT 50';
        queries.add(query4);

        insert queries;

    }

    public static void createCongaTemplates(){
        List<APXTConga4__Conga_Template__c> templates = new List<APXTConga4__Conga_Template__c>();
        APXTConga4__Conga_Template__c tempate1 = new APXTConga4__Conga_Template__c();
        tempate1.APXTConga4__Name__c = 'All Fields Merge Test';
        tempate1.APXTConga4__Template_Type__c = 'Document';
        templates.add(tempate1);

        insert templates;
        createdCongaTemplates = new map<ID, APXTConga4__Conga_Template__c>(templates);

        //manually attach document to template
    }

    public static void createCongaSolutions(){
        //manually create
    }

    public static void createProgramOfStudy(){
        List<ProgramOfStudy__c> poss = new List<ProgramOfStudy__c>();
        ProgramOfStudy__c pos = new ProgramOfStudy__c();
        pos.CIPCode__c = '01';
        pos.CIPDefinition__c = 'Instructional programs that focus on agriculture and related sciences and that prepare individuals to apply specific knowledge, methods, and techniques to the management and performance of agricultural operations.';
        pos.CIPFamily__c = '01';
        pos.CIPTitle__c = 'AGRICULTURE, AGRICULTURE OPERATIONS, AND RELATED SCIENCES.';
        pos.RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('ProgramOfStudy__c', 'CIP Code');
        poss.add(pos);
        insert pos;

        List<SchoolProgramsOfStudy__c> sposs = new List<SchoolProgramsOfStudy__c>();

        for(Account acct : createdSchools.values()){
            for(ProgramOfStudy__c posi : poss){
                if(acct.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Account', 'School - Customer')){
                    sposs.add(new SchoolProgramsOfStudy__c(School__c = acct.id,
                                                           ProgramOfStudy__c = posi.id,
                                                           Name = acct.Name + ' Overidden Major Name'));                    
                }
            }
        }
        insert sposs;
        createdSchoolProgramOfStudy = new Map<ID, SchoolProgramsOfStudy__c>(sposs);

        List<IncomeBand__c> incomeBands = new List<IncomeBand__c>();
        for(SchoolProgramsOfStudy__c major : createdSchoolProgramOfStudy.values()){
            incomeBands.add(new IncomeBand__c(SchoolProgramOfStudy__c = major.id,
                                              EarningsGroup__c = '1'));
        }
        insert incomeBands;
    }

    public static void createPrograms(){
        List<Program__c> programs = new List<Program__c>();
        for(Account acct : createdSchools.values()){
            if(acct.RecordTypeID == GlobalUtil.getRecordTypeIdByLabelName('Account', 'School - Customer')){
                programs.add(new Program__c(School__c = acct.id,
                                            AgreementTemplate__c = createdCongaTemplates.values()[0].id,
                                            DisclosureTemplate__c = createdCongaTemplates.values()[0].id,
                                            EnrollmentType__c = 'Open',
                                            ProgramStatus__c = 'Open',
                                            RegistrationBeginDate__c = Date.today().addYears(-1),
                                            RegistrationEndDate__c = Date.today().addYears(1),
                                            SchoolProgramOfStudyRequired__c = true,
                                            ProgramName__c = acct.Name + ' Test Program'));                 
            }
        }
        insert programs;

        //Create Program Eligibility Record
        List<ProgramEligibility__c> programElibibility = new List<ProgramEligibility__c>();
        List<ContractTerm__c> contractTerms = new List<ContractTerm__c>();
        List<TransactionSchedule__c> disbursementSchedule = new List<TransactionSchedule__c>();
        List<Program_Config__c> programConfigs = new List<Program_Config__c>();
        for(Program__c prog : programs){

            for(SchoolProgramsOfStudy__c spos : createdSchoolProgramOfStudy.values()){
                programElibibility.add(new ProgramEligibility__c(Program__c = prog.id,
                                                                 SchoolProgramOfStudy__c = spos.id));
            }

            contractTerms.add(new ContractTerm__c(Program__c = prog.id,
                                                    AdjustmentMethod__c = 'Income Share',
                                                    EarningsGroup__c = '1',
                                                    GradeLevel__c = 'Freshman',
                                                    IncomeShare__c = 5,
                                                    MaximumFundingAmount__c = 1000,
                                                    MinimumFundingAmount__c = 15000,
                                                    PaymentCapFactor__c = 1.5,
                                                    PaymentTerm__c = 96));
            //Create Disbursement Schedules
            disbursementSchedule.add(new TransactionSchedule__c(Program__c = prog.id,
                                                                FundingAmount__c = 25,
                                                                ScheduledDate__c = Date.today().addMonths(1)));
            disbursementSchedule.add(new TransactionSchedule__c(Program__c = prog.id,
                                                                FundingAmount__c = 25,
                                                                ScheduledDate__c = Date.today().addMonths(2)));
            disbursementSchedule.add(new TransactionSchedule__c(Program__c = prog.id,
                                                                FundingAmount__c = 25,
                                                                ScheduledDate__c = Date.today().addMonths(3))); 
            disbursementSchedule.add(new TransactionSchedule__c(Program__c = prog.id,
                                                                FundingAmount__c = 25,
                                                                ScheduledDate__c = Date.today().addMonths(4))); 

            //Create ProgramConfigs
            programConfigs.add(new Program_Config__c(Program__c = prog.id, 
                                                     PaymentCapFactor__c = 2.5,
                                                     InSchoolGraceMonthsDisbursement2__c = 11,
                                                     InSchoolGraceMonthsDisbursement1__c = 15,
                                                     AssumedAnnualIncomeGrowth__c = 5));                                                                
        }

        insert programElibibility;
        insert contractTerms;
        insert disbursementSchedule;
        insert programConfigs;


        List<Config_Loan_Alternative__c> loanAlternatives = new List<Config_Loan_Alternative__c>();
        List<Config_Annual_Income_Level__c> annualIncomeLevels = new List<Config_Annual_Income_Level__c>();
        for (Program_Config__c config : programConfigs){
            loanAlternatives.add(new Config_Loan_Alternative__c(ProgramConfig__c = config.id,
                                                                InPaymentInterestRate__c = 6.84,
                                                                InSchoolInterestRate__c = 6.84,
                                                                LoanType__c = 'PLUS',
                                                                OriginationFeePercentage__c = 4.272,
                                                                PaymentTerm__c = 120));

            loanAlternatives.add(new Config_Loan_Alternative__c(ProgramConfig__c = config.id,
                                                                InPaymentInterestRate__c = 5,
                                                                InSchoolInterestRate__c = 5,
                                                                LoanType__c = 'Perkins',
                                                                OriginationFeePercentage__c = 0,
                                                                PaymentTerm__c = 120));

            loanAlternatives.add(new Config_Loan_Alternative__c(ProgramConfig__c = config.id,
                                                                InPaymentInterestRate__c = 7.21,
                                                                InSchoolInterestRate__c = 7.21,
                                                                LoanType__c = 'Test',
                                                                OriginationFeePercentage__c = 4.228,
                                                                PaymentTerm__c = 120));

            loanAlternatives.add(new Config_Loan_Alternative__c(ProgramConfig__c = config.id,
                                                                InPaymentInterestRate__c = 4.29,
                                                                InSchoolInterestRate__c = 4.29,
                                                                LoanType__c = 'Stafford Unsubsidized',
                                                                OriginationFeePercentage__c = 1.068,
                                                                PaymentTerm__c = 120));

            loanAlternatives.add(new Config_Loan_Alternative__c(ProgramConfig__c = config.id,
                                                                InPaymentInterestRate__c = 9,
                                                                InSchoolInterestRate__c = 9,
                                                                LoanType__c = 'Stafford Unsubsidized',
                                                                OriginationFeePercentage__c = 0,
                                                                PaymentTerm__c = 120));

            loanAlternatives.add(new Config_Loan_Alternative__c(ProgramConfig__c = config.id,
                                                                InPaymentInterestRate__c = 5.84,
                                                                InSchoolInterestRate__c = 5.84,
                                                                LoanType__c = 'Stafford Unsubsidized',
                                                                OriginationFeePercentage__c = 1.068,
                                                                PaymentTerm__c = 120));

            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = false,
                                                                        Income__c = 10000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = true,
                                                                        ListInIncomeGrowthExample__c = true,
                                                                        Income__c = 20000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = false,
                                                                        Income__c = 30000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = true,
                                                                        Income__c = 40000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = false,
                                                                        Income__c = 50000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = true,
                                                                        Income__c = 60000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = false,
                                                                        Income__c = 70000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = true,
                                                                        Income__c = 80000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = false,
                                                                        Income__c = 90000));
            annualIncomeLevels.add(new Config_Annual_Income_Level__c(ProgramConfig__c = config.id,
                                                                        IsMinimumThreshold__c = false,
                                                                        ListInIncomeGrowthExample__c = true,
                                                                        Income__c = 100000));
            

        }

        insert loanAlternatives;
        insert annualIncomeLevels;

    }
}