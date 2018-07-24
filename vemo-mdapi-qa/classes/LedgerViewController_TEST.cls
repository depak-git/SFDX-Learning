@isTest
public class LedgerViewController_TEST{
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        //create students
        Map<Id,Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(1);
        //create Programs with school
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(1,TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        integer cnt = 0;
        for(Account acc:studentMap.values()){
            acc.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        
                 
        //create an agreement for student
        Map<ID, StudentProgram__c> studProgramMap = TestDataFactory.createAndInsertStudentProgram(1,studentMap,programMap);
        Map<ID, StudentProgramMonthlyStatus__c> monthlyStatusMap = TestDataFactory.createAndInsertStudentProgramMonthlyStatus(2,studProgramMap);
        Map<ID, StudentProgramAmountDue__c> spAmtDueMap = TestDataFactory.createAndInsertStudentProgramAmountDue(studProgramMap, monthlyStatusMap);
        integer count=0;
        for(StudentProgramAmountDue__c ad:spAmtDueMap.values()){
            ad.AssessmentDateTime__c = Datetime.now();
            if(count == 0){
                ad.type__c = 'Reconciliation';
                count++;
            }
        }
        update spAmtDueMap.values();
        
        Map<ID, PaymentMethod__c> pmMap = TestDataFactory.createAndInsertPaymentMethod(1, studentMap);
        Map<ID, PaymentInstruction__c> piMap = TestDataFactory.createAndInsertPaymentInstruction(2, studentMap, pmMap);
        Map<ID, PaymentAllocation__c> paMap = TestDataFactory.createAndInsertPaymentAllocation(2, piMap, studProgramMap);   
        Map<Id, Fee__c> feeMap = TestDataFactory.createAndInsertFee(2, studentMap);            
    }
    
    @isTest
    public static void testGetStudent(){
        Map<ID, Account> studentMap = AccountQueries.getStudentMap(); 
        Test.StartTest();
        LedgerViewController.getStudent(studentMap.values()[0].id);    
        Test.StopTest();
    }
    
    @isTest
    public static void testGetJournalEntriesWithCustomerID(){
    Map<ID, Account> studentMap = AccountQueries.getStudentMap(); 
        Test.StartTest();
        LedgerViewController.getJournalEntriesWithCustomerID(studentMap.values()[0].id);  
        Test.StopTest();
    } 
}