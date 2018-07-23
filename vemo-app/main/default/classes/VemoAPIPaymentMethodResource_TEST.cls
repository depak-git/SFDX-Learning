/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIPaymentMethodResource_TEST
// 
// Description: 
//  Unit test for VemoAPIPaymentMethodResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-13   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIPaymentMethodResource_TEST {
	
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    static testMethod void testHandleGetV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

    	Map<String, String> pymntMethParams = new Map<String, String>();
		pymntMethParams.put('paymentMethodID', TestUtil.createStringFromIDSet(testPaymentMethodMap.keySet()));
		pymntMethParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo pymntMethApiInfo = TestUtil.initializeAPI('v1', 'GET', pymntMethParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', TestUtil.createStringFromIDSet(testStudentAccountMap.keySet()));
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse pymntMethResult = (VemoAPI.ResultResponse)VemoAPIPaymentMethodResource.handleAPI(pymntMethApiInfo);
		System.assertEquals(testPaymentMethodMap.size(), pymntMethResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPIPaymentMethodResource.handleAPI(studApiInfo);
		System.assertEquals(testPaymentMethodMap.size(), studResult.numberOfResults);
		Test.stopTest();
    }
    
    static testMethod void testHandlePostV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIPaymentMethodResource.PaymentMethodInputV1> pymntMethList = new List<VemoAPIPaymentMethodResource.PaymentMethodInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIPaymentMethodResource.PaymentMethodInputV1 pymntMeth = new VemoAPIPaymentMethodResource.PaymentMethodInputV1(true);
			pymntMeth.studentID = testStudentAccountMap.values().get(i).ID;
			pymntMeth.tokenize = 'false';
			pymntMethList.add(pymntMeth);
		}
		String body = JSON.serialize(pymntMethList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIPaymentMethodResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}
	
	static testMethod void testHandlePutV1(){
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPIPaymentMethodResource.PaymentMethodInputV1> pymntMethList = new List<VemoAPIPaymentMethodResource.PaymentMethodInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIPaymentMethodResource.PaymentMethodInputV1 pymntMeth = new VemoAPIPaymentMethodResource.PaymentMethodInputV1(true);
			pymntMeth.paymentMethodId = testPaymentMethodMap.values().get(i).ID;
			pymntMeth.bankAccountNumber = '4321';
			pymntMeth.tokenize = 'false';
			pymntMeth.studentID = testStudentAccountMap.values().get(i).ID;
			pymntMethList.add(pymntMeth);
		}
		String body = JSON.serialize(pymntMethList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIPaymentMethodResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();

	}

	static testMethod void testHandleDeleteV1(){
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');		
		params.put('paymentMethodID', TestUtil.createStringFromIDSet(testPaymentMethodMap.keySet()));

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);
		
		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIPaymentMethodResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		System.assertEquals(0, ProgramQueries.getProgramMap().size());
		Test.stopTest();
	}
		
}