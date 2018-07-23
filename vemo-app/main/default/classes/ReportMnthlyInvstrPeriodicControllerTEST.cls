@isTest
public class ReportMnthlyInvstrPeriodicControllerTEST{
    @TestSetup static void setupData(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);    
        Map<ID, PaymentMethod__c> paymentMethods = TestDataFactory.createAndInsertPaymentMethod(1, students);
        Map<ID, PaymentInstruction__c> PIs = TestDataFactory.createAndInsertPaymentInstruction(1, students, paymentMethods);
        Map<ID, PaymentAllocation__c> allocations = TestDataFactory.createAndInsertPaymentAllocation(3,PIs,agreements);
        Map<ID, StudentProgramMonthlyStatus__c> monthlyStatus = TestDataFactory.createAndInsertStudentProgramMonthlyStatus(3, agreements);
        Map<ID, EmploymentHistory__c> employmentHistory = TestDataFactory.createAndInsertEmploymentHistory(20,students);
        Map<ID, IncomeVerification__c> incomes = TestDataFactory.createAndInsertIncomeVerification(1, employmentHistory);
        
        Datetime dt = Datetime.now().addyears(-2);
        integer cnt=0;
        for(Id agreementID:agreements.keySet()){
            agreements.get(agreementID).certificationDate__c = dt.addMonths(cnt);
            if(cnt<4){
                agreements.get(agreementID).expectedGraduationDate__c = dt.addMonths(cnt+6).date();
                agreements.get(agreementID).status__c = 'Closed';
                agreements.get(agreementID).ClosedDate__c = Date.today();
                if(cnt<2) agreements.get(agreementID).ClosedReason__c = 'Default';
                else agreements.get(agreementID).ClosedReason__c = 'Contract Satisfied';  
                        
            }
            if(cnt>=4 && cnt <6){
                agreements.get(agreementID).status__c = 'Cancelled';
                
            }
            if(cnt>=6 && cnt <7){
                agreements.get(agreementID).status__c = 'Pending Reconciliation';
            }
            cnt++;
        }
        update agreements.values();
        
        for(IncomeVerification__c iv:incomes.values()){
            iv.BeginDate__c =Date.today().addDays(-120);
            iv.status__c = 'Verified'; 
        }
        update incomes.values();
        Integer currentMonth = Date.today().month();
        Integer currentYear = Date.today().year();
        
        List<StudentProgramAudit__c> spaList = new List<StudentProgramAudit__c>();
        for(StudentProgram__c sp:agreements.values()){
            Integer month = Date.today().addDays(-120).month();
            Integer year = Date.today().addDays(-120).year();
            Integer count = 1;
            while((month<=currentMonth && year == currentYear) || (year<currentYear)){
                if(count < 3){
                    spaList.add(new StudentProgramAudit__c(studentprogram__c = sp.id,
                                                           auditdatetime__c = Date.newInstance(year,month,28),
                                                           daysdelinquent__c = 0,
                                                           monthend__c = true));
                }
                else{
                    spaList.add(new StudentProgramAudit__c(studentprogram__c = sp.id,
                                                       auditdatetime__c = Date.newInstance(year,month,28),
                                                       daysdelinquent__c = 30,
                                                       servicing__c = true,
                                                       monthend__c = true));
                }
                count++;
                if(month == 12){
                    month = 1;
                    year++;
                }
                else month++;
            }
        }
        insert spaList;    
    }
    
    @isTest public static void validateGetProgram(){
        Test.StartTest(); 
        ReportMnthlyInvstrPeriodicController cntrl = new ReportMnthlyInvstrPeriodicController();
        List<SelectOption> programs = cntrl.getPrograms();
        System.assertEquals(1,programs.size(),'Should be 1');
        Test.StopTest(); 
    }
    
    @isTest public static void testmode1(){
        PageReference pageRef = Page.ReportMonthlyInvestorPeriodic;
        pageRef.getParameters().put('currentvfpage','ReportMonthlyInvestorPeriodic');
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ReportMnthlyInvstrPeriodicController cntrl = new ReportMnthlyInvstrPeriodicController();
        List<SelectOption> programs = cntrl.getPrograms();
        cntrl.selectedProgram = programs[0].getValue();
        cntrl.runReport();
        Test.StopTest(); 
    }
    
    @isTest public static void testExportmode1(){
        PageReference pageRef = Page.ReportMonthlyInvestorPeriodic;
        pageRef.getParameters().put('currentvfpage','ReportMonthlyInvestorPeriodic');
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ReportMnthlyInvstrPeriodicController cntrl = new ReportMnthlyInvstrPeriodicController();
        List<SelectOption> programs = cntrl.getPrograms();
        cntrl.selectedProgram = programs[0].getValue();
        cntrl.exportToCSV();
        cntrl.buildCsvString(); 
        Test.StopTest();   
    }  
    
    @isTest public static void testmode2(){
        PageReference pageRef = Page.ReportSalesForecast;
        pageRef.getParameters().put('currentvfpage','ReportSalesForecast');
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ReportMnthlyInvstrPeriodicController cntrl = new ReportMnthlyInvstrPeriodicController();
        List<SelectOption> programs = cntrl.getPrograms();
        cntrl.selectedProgram = programs[0].getValue();
        cntrl.runReport();
        Test.StopTest(); 
    }
    
    @isTest public static void testExportmode2(){
        PageReference pageRef = Page.ReportSalesForecast;
        pageRef.getParameters().put('currentvfpage','ReportSalesForecast');
        Test.setCurrentPage(pageRef);
        Test.StartTest(); 
        ReportMnthlyInvstrPeriodicController cntrl = new ReportMnthlyInvstrPeriodicController();
        List<SelectOption> programs = cntrl.getPrograms();
        cntrl.selectedProgram = programs[0].getValue();
        cntrl.exportToCSV();
        cntrl.buildCsvString(); 
        Test.StopTest();   
    }  
        
                    
}