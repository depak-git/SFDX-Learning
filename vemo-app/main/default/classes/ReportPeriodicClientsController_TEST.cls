@isTest
public class ReportPeriodicClientsController_TEST{
    @TestSetup static void setupData(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(4);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements;
        
        //create 1 studentProgram for each student, so that each school has 4 students under them 
        Integer count = 1;
        List<Account> studentList = students.values();
        for(Program__c program:programs.values()){
            Map<ID, Program__c> programForAgreement = new Map<ID,Program__c>();
            Map<ID, Account> studentsForAgreement = new Map<ID,Account>();
            programForAgreement.put(program.ID,program);
            for(integer i=0 ;i<studentList.size();i++){
                studentsForAgreement.put(studentList[i].id,studentList[i]);
                if(Math.mod(count,4) == 0) break;    
                count += 1;
            }
            
            agreements = TestDataFactory.createAndInsertStudentProgram(1, studentsForAgreement , programForAgreement);    
        }
        
        Map<ID,Transaction__c> disbursements = TestDataFactory.createAndInsertTransactions(3,agreements, TransactionService.disbursementRecType);
                    
    }
    
    @isTest public static void validateSchoolFilter(){
        
        Test.StartTest(); 

            ReportPeriodicClientsController  cntrl = new ReportPeriodicClientsController();
            cntrl.getSchools();
            cntrl.schools[0].selected = true;
            cntrl.runReport();
            System.assertEquals(4,cntrl.reportData.size(),'Number of rows in report should be 4');
        
        Test.StopTest();    
    }
    
    @isTest public static void validateDateFilter(){
        Test.StartTest();
            
            Date newTxDate = Date.Today().addYears(-1);
            
            Map<ID,Transaction__c> disbursements = TransactionQueries.getTransactionMap(TransactionService.disbursementRecType);
            for(Transaction__c disb: disbursements.values()){
                disb.transactionDate__c = newTxDate;
                break;
            }
            update disbursements.values();
            
            ReportPeriodicClientsController  cntrl = new ReportPeriodicClientsController();
            cntrl.startDate.transactionDate__c = newTxDate.adddays(-1);
            cntrl.endDate.transactionDate__c = newTxDate.adddays(1);
            cntrl.runReport();
            System.assertEquals(1,cntrl.reportData.size(),'Number of rows in report should be 1');
            
        Test.StopTest();    
    }
    
    @isTest public static void testExport(){
        Test.StartTest(); 

            ReportPeriodicClientsController  cntrl = new ReportPeriodicClientsController();
            cntrl.exportToCSV();
            cntrl.buildCsvString(); 
            
        Test.StopTest();   
    }
    
    @isTest public static void testSortDirectionToggling(){
        PageReference pageRef = Page.ReportPeriodicClients;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
            
            ReportPeriodicClientsController  cntrl = new ReportPeriodicClientsController();
            ApexPages.currentPage().getParameters().put('sortByParam','School');
            System.assertEquals('ASCENDING',ReportPeriodicClientsController.sortDirection,'Should be ASCENDING');
            cntrl.sort();
            System.assertEquals('ASCENDING',ReportPeriodicClientsController.sortDirection,'Should be ASCENDING');
            cntrl.sort();
            System.assertEquals('DESCENDING',ReportPeriodicClientsController.sortDirection,'Should be DESCENDING');
            cntrl.sort();
            System.assertEquals('ASCENDING',ReportPeriodicClientsController.sortDirection,'Should be ASCENDING');
            
        Test.StopTest();
    }
    
    @isTest public static void testSortBy(){
            Test.StartTest();
                ReportPeriodicClientsController  cntrl = new ReportPeriodicClientsController();
                ApexPages.currentPage().getParameters().put('sortByParam','firstTxDate');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','firstTxAmount');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','School');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','Program');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','Student');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','StudentProgram');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','Disbursement');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','FundingAmountPostCertification');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','IncomeSharePostCertification');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','DefermentMonthsAllowed');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','GraceMonthsAllowed');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','MinimumIncomePerMonth');
                cntrl.sort();
                cntrl.sort();
                ApexPages.currentPage().getParameters().put('sortByParam','PaymentCapPostCertification');
                cntrl.sort();
                cntrl.sort();
            Test.StopTest();
    }
}