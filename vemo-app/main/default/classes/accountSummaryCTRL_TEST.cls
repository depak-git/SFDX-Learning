@isTest
public class accountSummaryCTRL_TEST{
     @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        //create students
        Map<Id,Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(2);
        //create Programs with school
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(3,TestDataFactory.createAndInsertSchoolCustomerAccounts(2));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        integer cnt = 0;
        for(Account acc:studentMap.values()){
            if(cnt<3){
                acc.PrimarySchool__pc = schoolMap.values()[0].id;
            }
            else{
                acc.PrimarySchool__pc = schoolMap.values()[1].id;
            }    
        }
        update studentMap.values();
               
        Map<ID, ProgramEligibility__c> eligibilityMap = TestDataFactory.createAndInsertProgramEligibility(2,programMap);
        Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(2);
        Map<ID, SchoolProgramsOfStudy__c> sposMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schoolMap, posMap);
        
        Map<ID, ContractTerm__c> termMap = TestDataFactory.createAndInsertContractTerms(1,programMap);
        Map<ID, TransactionSchedule__c> txSchMap = TestDataFactory.createAndInsertTransactionSchedule(2, programMap);
        Map<ID, IncomeBand__c> bandMap = TestDataFactory.createAndInsertIncomeBands(1, sposMap);
        
        Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(3,studentMap,programMap);
        Map<ID, Transaction__c> transactionMap = TestDataFactory.createAndInsertTransactions(3,agreements, 'Disbursement');
        List<transaction__c> transactionList = new list<transaction__c>();//transactionMap.values();
        transactionList.addAll(transactionMap.values());
        transactionList[0].status__c = 'Pending'; 
        transactionList[1].status__c = 'Scheduled';
        update transactionList;
        Map<ID, EmploymentHistory__c> empHistory =  TestDataFactory.createAndInsertEmploymentHistory(1,studentMap);
        
        /*
        Map<ID, IncomeVerification__c> incomeVerMap = TestDataFactory.createAndInsertIncomeVerification(4,empHistory); 
        List<incomeVerification__c> incList = new list<incomeVerification__c>();
        incList = incomeVerMap.values(); 
        incList[0].begindate__c = Date.today().toStartOfMonth();
        incList[0].status__c = true;
        incList[0].type__c = 'Estimated';
        incList[1].begindate__c = Date.today().toStartOfMonth();
        incList[1].status__c = true; 
        incList[1].type__c = 'Reported';
        
        //incList.add(incomeVerMap[0]);
        //incList.add(incomeVerMap[1]);
        update incList;
        */
        Map<ID, StudentProgramMonthlyStatus__c> monthlystatusMap = TestDataFactory.createAndInsertStudentProgramMonthlyStatus(2,agreements);
        Map<ID, StudentProgramAmountDue__c> amountDueMap = TestDataFactory.createAndInsertStudentProgramAmountDue(agreements , monthlystatusMap );
        for(StudentProgramAmountDue__c amountdue: amountdueMap.values()){
            amountdue.AssessmentDateTime__c = datetime.now().addDays(-30);
        }
        update amountdueMap.values();
       /* for(Account acc:studentMap.values()){
            TestDataFactory.createAndInsertStudentProgram(1,new Map<ID,Account>{acc.id => acc},
                                                          ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{acc.PrimarySchool__pc}));
        }
        
        for(ContractTerm__c ct:termMap.values()){
            ct.MinimumFundingAmount__c = 1000;
        }       
        update termMap.values();   */               
    } 
    
    @isTest
    public static void testgetRecords(){
         Account acc = [Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1];
         Test.startTest();
         //accountSummaryCTRL obj = new accountSummaryCTRL();
         accountSummaryCTRL.getRecords(acc.id);
         Test.stopTest();
    }

    /////////////////////////////////////////////////////////////
    ///Test Case: only 1 income record with a future begin date
    /////////////////////////////////////////////////////////////
    @isTest
    public static void validateIncomeScenario1(){
        Map<ID, EmploymentHistory__c> empHistoryMap = EmploymentHistoryQueries.getEmploymentHistoryMap();
        Map<ID, IncomeVerification__c> incomeVerficationMap = TestDataFactory.createAndInsertIncomeVerification(1,empHistoryMap);
        
        incomeVerficationMap.values()[0].begindate__c = Date.today().addDays(120); 
        incomeVerficationMap.values()[0].incomePerMonth__c = 1000;                                               
        incomeVerficationMap.values()[0].status__c = 'Verified';
        update incomeVerficationMap.values();
        Account acc = [Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1];
        Test.startTest();
        //accountSummaryCTRL obj = new accountSummaryCTRL();
        accountSummaryCTRL.wrapperClass output = accountSummaryCTRL.getRecords(acc.id);
        System.assertEquals(0,output.monthlyIncome,'Income should be 0');
        Test.stopTest();
    }

    /////////////////////////////////////////////////////////////
    ///Test Case: only 1 income record with a past begin date
    /////////////////////////////////////////////////////////////
    @isTest
    public static void validateIncomeScenario2(){
        Map<ID, EmploymentHistory__c> empHistoryMap = EmploymentHistoryQueries.getEmploymentHistoryMap();
        Map<ID, IncomeVerification__c> incomeVerficationMap = TestDataFactory.createAndInsertIncomeVerification(1,empHistoryMap);
        
        incomeVerficationMap.values()[0].begindate__c = Date.today().addDays(-120); 
        incomeVerficationMap.values()[0].incomePerMonth__c = 1000;                                               
        incomeVerficationMap.values()[0].status__c = 'Verified';
        update incomeVerficationMap.values();
        Account acc = [Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1];
        Test.startTest();
        //accountSummaryCTRL obj = new accountSummaryCTRL();
        accountSummaryCTRL.wrapperClass output = accountSummaryCTRL.getRecords(acc.id);
        System.assertEquals(1000,output.monthlyIncome,'Income should be 1000');
        Test.stopTest();
    }

    /////////////////////////////////////////////////////////////
    ///Test Case: 2 income records. one with a future begin date
    ///another with past begin date
    /////////////////////////////////////////////////////////////
    @isTest
    public static void validateIncomeScenario3(){
        Map<ID, EmploymentHistory__c> empHistoryMap = EmploymentHistoryQueries.getEmploymentHistoryMap();
        Map<ID, IncomeVerification__c> incomeVerficationMap = TestDataFactory.createAndInsertIncomeVerification(2,empHistoryMap);
        
        incomeVerficationMap.values()[0].begindate__c = Date.today().addDays(-120); 
        incomeVerficationMap.values()[0].incomePerMonth__c = 1000;  
        incomeVerficationMap.values()[0].status__c = 'Verified';                                             
        incomeVerficationMap.values()[1].begindate__c = Date.today().addDays(120); 
        incomeVerficationMap.values()[1].incomePerMonth__c = 2000;
        incomeVerficationMap.values()[1].status__c = 'Verified';                                               
        
        update incomeVerficationMap.values();
        Account acc = [Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1];
        Test.startTest();
        //accountSummaryCTRL obj = new accountSummaryCTRL();
        accountSummaryCTRL.wrapperClass output = accountSummaryCTRL.getRecords(acc.id);
        System.assertEquals(1000,output.monthlyIncome,'Income should be 1000');
        Test.stopTest();
    }

    /////////////////////////////////////////////////////////////
    ///Test Case: 2 income records with same begin date
    ///one of type Reported another of type estimated
    /////////////////////////////////////////////////////////////
    @isTest
    public static void validateIncomeScenario4(){
        Map<ID, EmploymentHistory__c> empHistoryMap = EmploymentHistoryQueries.getEmploymentHistoryMap();
        Map<ID, IncomeVerification__c> incomeVerficationMap = TestDataFactory.createAndInsertIncomeVerification(2,empHistoryMap);
        
        incomeVerficationMap.values()[0].begindate__c = Date.today().addDays(-120);
        incomeVerficationMap.values()[0].type__c = 'Reported'; 
        incomeVerficationMap.values()[0].incomePerMonth__c = 1000;
        incomeVerficationMap.values()[0].status__c = 'Verified';                                               
        incomeVerficationMap.values()[1].begindate__c = Date.today().addDays(-120); 
        incomeVerficationMap.values()[1].type__c = 'Estimated';
        incomeVerficationMap.values()[1].incomePerMonth__c = 2000; 
        incomeVerficationMap.values()[1].status__c = 'Verified';                                              
        
        update incomeVerficationMap.values();
        Account acc = [Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1];
        Test.startTest();
        //accountSummaryCTRL obj = new accountSummaryCTRL();
        accountSummaryCTRL.wrapperClass output = accountSummaryCTRL.getRecords(acc.id);
        System.assertEquals(1000,output.monthlyIncome,'Income should be 1000');
        Test.stopTest();
    }

    /////////////////////////////////////////////////////////////
    ///Test Case: 2 income records with same begin date
    ///both of same type with different DateVerified
    /////////////////////////////////////////////////////////////
    @isTest
    public static void validateIncomeScenario5(){
        Map<ID, EmploymentHistory__c> empHistoryMap = EmploymentHistoryQueries.getEmploymentHistoryMap();
        Map<ID, IncomeVerification__c> incomeVerficationMap = TestDataFactory.createAndInsertIncomeVerification(2,empHistoryMap);
        
        incomeVerficationMap.values()[0].begindate__c = Date.today().addDays(-120);
        incomeVerficationMap.values()[0].type__c = 'Reported';
        incomeVerficationMap.values()[0].dateVerified__c = Date.today();
        incomeVerficationMap.values()[0].incomePerMonth__c = 1000;
        incomeVerficationMap.values()[0].status__c = 'Verified';                                               
        incomeVerficationMap.values()[1].begindate__c = Date.today().addDays(-120); 
        incomeVerficationMap.values()[1].type__c = 'Reported';
        incomeVerficationMap.values()[1].dateVerified__c = Date.today().addDays(-10);
        incomeVerficationMap.values()[1].incomePerMonth__c = 2000; 
        incomeVerficationMap.values()[1].status__c = 'Verified';                                              
        
        update incomeVerficationMap.values();
        Account acc = [Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1];
        Test.startTest();
        //accountSummaryCTRL obj = new accountSummaryCTRL();
        accountSummaryCTRL.wrapperClass output = accountSummaryCTRL.getRecords(acc.id);
        System.assertEquals(1000,output.monthlyIncome,'Income should be 1000');
        Test.stopTest();
    }
}