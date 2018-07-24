@isTest
public class NotificationNActivityViewCls_TEST{
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
        
        Map<ID, Notification__c> notificationMap = NotificationQueries.getNotificationMap(); 
        ApexPages.CurrentPage().getparameters().put('id',notificationMap.values()[0].id);
        ApexPages.CurrentPage().getparameters().put('record','notification');

        Test.StartTest();
        NotificationNActivityViewCls nvCls = new NotificationNActivityViewCls();
        Test.StopTest();
    }
    
}
