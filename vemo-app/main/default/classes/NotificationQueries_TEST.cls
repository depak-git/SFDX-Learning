/////////////////////////////////////////////////////////////////////////
// Class: NotificationQueries_TEST
// 
// Description: 
//  Unit test for NotificationQueries
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-17   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class NotificationQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    static testMethod void testGetNotificationMap(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Set<Id> contactIds = new Set<Id>();
    	for(Account acc: testStudentAccountMap.values()){
			contactIds.add(acc.PersonContactId);
    	}
    	Map<Id, Contact> testContactMap = ContactQueries.getContactMapByIDWithContactID(contactIds);
    	Map<ID, Notification__c> testNotificationMap = TestDataFactory.createAndInsertNotification(1, testContactMap);
    	Test.startTest();
    	Map<ID, Notification__c> resultNotificationMap = NotificationQueries.getNotificationMap();
    	System.assertEquals(testNotificationMap.size(), resultNotificationMap.size());
    	Test.stopTest();
    }

    static testMethod void testGetNotificationByID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Set<Id> contactIds = new Set<Id>();
    	for(Account acc: testStudentAccountMap.values()){
			contactIds.add(acc.PersonContactId);
    	}
    	Map<Id, Contact> testContactMap = ContactQueries.getContactMapByIDWithContactID(contactIds);
    	Map<ID, Notification__c> testNotificationMap = TestDataFactory.createAndInsertNotification(1, testContactMap);
    	Test.startTest();
    	Map<ID, Notification__c> resultNotificationMap = NotificationQueries.getNotificationByID(testNotificationMap.keySet());
    	System.assertEquals(testNotificationMap.size(), resultNotificationMap.size());
    	Test.stopTest();
    }
    
    static testMethod void testGetNotificationByStudentID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Set<Id> contactIds = new Set<Id>();
    	for(Account acc: testStudentAccountMap.values()){
			contactIds.add(acc.PersonContactId);
    	}
    	Map<Id, Contact> testContactMap = ContactQueries.getContactMapByIDWithContactID(contactIds);
    	Map<ID, Notification__c> testNotificationMap = TestDataFactory.createAndInsertNotification(1, testContactMap);
    	Test.startTest();
    	Map<ID, Notification__c> resultNotificationMap = NotificationQueries.getNotificationByStudentID(testStudentAccountMap.keySet());
    	System.assertEquals(testNotificationMap.size(), resultNotificationMap.size());
    	Test.stopTest();
    }
}