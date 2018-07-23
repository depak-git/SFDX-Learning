/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIPaymentInstructionResource_TEST
// 
// Description: 
//  Unit test for emoAPIPaymentInstructionResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-18   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIPaymentInstructionResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);

    	Map<String, String> pymntInsParams = new Map<String, String>();
		pymntInsParams.put('paymentInstructionID', TestUtil.createStringFromIDSet(testPaymentInsturctionMap.keySet()));
		pymntInsParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo pymntInsApiInfo = TestUtil.initializeAPI('v1', 'GET', pymntInsParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', TestUtil.createStringFromIDSet(testStudentAccountMap.keySet()));
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse pymntInsResult = (VemoAPI.ResultResponse)VemoAPIPaymentInstructionResource.handleAPI(pymntInsApiInfo);
		System.assertEquals(testPaymentMethodMap.size(), pymntInsResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPIPaymentInstructionResource.handleAPI(studApiInfo);
		System.assertEquals(testPaymentMethodMap.size(), studResult.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testHandlePostV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIPaymentInstructionResource.PaymentInstructionInputV1> pymntInsList = new List<VemoAPIPaymentInstructionResource.PaymentInstructionInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIPaymentInstructionResource.PaymentInstructionInputV1 pymntIns = new VemoAPIPaymentInstructionResource.PaymentInstructionInputV1(true);
			pymntIns.studentID = testStudentAccountMap.values().get(i).ID;
			pymntIns.paymentMethodID = testPaymentMethodMap.values().get(i).ID;
			pymntInsList.add(pymntIns);
		}
		String body = JSON.serialize(pymntInsList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIPaymentInstructionResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandlePutV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIPaymentInstructionResource.PaymentInstructionInputV1> pymntInsList = new List<VemoAPIPaymentInstructionResource.PaymentInstructionInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIPaymentInstructionResource.PaymentInstructionInputV1 pymntIns = new VemoAPIPaymentInstructionResource.PaymentInstructionInputV1(true);
			pymntIns.paymentInstructionID = testPaymentInstructionMap.values().get(i).ID;
			pymntIns.paymentMethodID = testPaymentMethodMap.values().get(i).ID;
			pymntInsList.add(pymntIns);
		}
		String body = JSON.serialize(pymntInsList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIPaymentInstructionResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandleDeleteV1(){
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');		
		params.put('paymentInstructionID', TestUtil.createStringFromIDSet(testPaymentInstructionMap.keySet()));

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);
		
		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIPaymentInstructionResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		System.assertEquals(0, ProgramQueries.getProgramMap().size());
		Test.stopTest();
	}
}