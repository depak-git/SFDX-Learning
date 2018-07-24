/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIFeeResource_TEST
// 
// Description: 
//		Test class for VemoAPIFeeResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-24   Jared Hagemann	Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIFeeResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<Id, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Fee__c> feeMap = TestDataFactory.createAndInsertFee(TestUtil.TEST_THROTTLE, studentMap);


    	Map<String, String> feeParams = new Map<String, String>();
		feeParams.put('feeID', TestUtil.createStringFromIDSet(feeMap.keySet()));
		feeParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo feeApiInfo = TestUtil.initializeAPI('v1', 'GET', feeParams, null);

		Map<String, String> custParams = new Map<String, String>();
		custParams.put('customerID', TestUtil.createStringFromIDSet(studentMap.keySet()));
		custParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo custInfo = TestUtil.initializeAPI('v1', 'GET', custParams, null);

		Test.startTest();
		VemoAPI.ResultResponse feeResult = (VemoAPI.ResultResponse)VemoAPIFeeResource.handleAPI(feeApiInfo);
		System.assertEquals(feeMap.size(), feeResult.numberOfResults);

		VemoAPI.ResultResponse custResult = (VemoAPI.ResultResponse)VemoAPIFeeResource.handleAPI(custInfo);
		System.assertEquals(feeMap.size(), custResult.numberOfResults);
		Test.stopTest();
    }
}