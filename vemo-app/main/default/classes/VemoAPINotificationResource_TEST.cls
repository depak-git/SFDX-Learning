/////////////////////////////////////////////////////////////////////////
// Class: VemoAPINotificationResource_TEST
// 
// Description: 
// 	Unit test for VemoAPINotificationResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-12   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class VemoAPINotificationResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Set<Id> contactIds = new Set<Id>();
    	for(Account acc: testStudentAccountMap.values()){
			contactIds.add(acc.PersonContactId);
    	}
    	Map<Id, Contact> testContactMap = ContactQueries.getContactMapByIDWithContactID(contactIds);
    	Map<ID, Notification__c> testNotificationMap = TestDataFactory.createAndInsertNotification(1, testContactMap);


    	Map<String, String> notiParams = new Map<String, String>();
		notiParams.put('notificationID', TestUtil.createStringFromIDSet(testNotificationMap.keySet()));
		notiParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo notiApiInfo = TestUtil.initializeAPI('v1', 'GET', notiParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', TestUtil.createStringFromIDSet(testStudentAccountMap.keySet()));
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse notiResult = (VemoAPI.ResultResponse)VemoAPINotificationResource.handleAPI(notiApiInfo);
		System.assertEquals(testNotificationMap.size(), notiResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPINotificationResource.handleAPI(studApiInfo);
		System.assertEquals(testNotificationMap.size(), studResult.numberOfResults);
		Test.stopTest();
    }
}