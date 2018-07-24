/////////////////////////////////////////////////////////////////////////
// Class: NotificationService_TEST
// 
// Description: 
// 	Unit test for NotificationService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-12   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
@isTest
public class NotificationService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetNotificationWithNotificationID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Set<Id> contactIds = new Set<Id>();
    	for(Account acc: testStudentAccountMap.values()){
			contactIds.add(acc.PersonContactId);
    	}
    	Map<Id, Contact> testContactMap = ContactQueries.getContactMapByIDWithContactID(contactIds);
    	Map<ID, Notification__c> testNotificationMap = TestDataFactory.createAndInsertNotification(1, testContactMap);
    	Test.startTest();
    	List<NotificationService.Notification> resultNotificationList = NotificationService.getNotificationWithNotificationID(testNotificationMap.keySet());
    	System.assertEquals(testNotificationMap.size(), resultNotificationList.size());
    	Test.stopTest();
    }

    static testMethod void testGetNotificationWithStudentID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Set<Id> contactIds = new Set<Id>();
    	for(Account acc: testStudentAccountMap.values()){
			contactIds.add(acc.PersonContactId);
    	}
    	Map<Id, Contact> testContactMap = ContactQueries.getContactMapByIDWithContactID(contactIds);
    	Map<ID, Notification__c> testNotificationMap = TestDataFactory.createAndInsertNotification(1, testContactMap);
    	Test.startTest();
    	List<NotificationService.Notification> resultNotificationList = NotificationService.getNotificationWithStudentID(testStudentAccountMap.keySet());
    	System.assertEquals(testNotificationMap.size(), resultNotificationList.size());
    	Test.stopTest();
    }
}