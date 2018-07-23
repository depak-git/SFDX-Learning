@isTest
public class StudentCommunicationsCTRL_TEST{
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        
        Map<Id,Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(1);
        //create Programs with school
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(1,TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        integer cnt = 0;
        for(Account acc:studentMap.values()){
            acc.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        
        update studentMap.values();
        Map<Id,contact> contactMap = TestDataFactory.createAndInsertContacts(1,schoolMap);
        Map<Id,Notification__c> notificationMap = TestDataFactory.createAndInsertNotification(1,contactMap);
    }
    
    
    @isTest
    public static void testGetCommunicationEntriesWithSchoolID(){
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap(); 
        Test.StartTest();
        StudentCommunicationsCTRL.getCommunicationEntriesWithSchoolID(schoolMap.values()[0].id,string.valueOf(date.today()),string.valueOf(date.today().adddays(1)),'');
        StudentCommunicationsCTRL.getCommunicationEntriesWithSchoolID(null,'','','');        
        Test.StopTest();
    }
    
    @isTest
    public static void testsearchStudent(){
        Test.StartTest();        
        StudentCommunicationsCTRL.searchStudent('','');        
        Test.StopTest();
    } 
}