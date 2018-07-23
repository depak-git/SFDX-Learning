/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIIncomeVerificationResource_TEST
// 
// Description: 
// 	Unit test for VemoAPIIncomeVerificationResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-12   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIIncomeVerificationResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);


    	Map<String, String> incVarParams = new Map<String, String>();
		incVarParams.put('incomeVerificationID', TestUtil.createStringFromIDSet(testIncVerMap.keySet()));
		incVarParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo incVarApiInfo = TestUtil.initializeAPI('v1', 'GET', incVarParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', TestUtil.createStringFromIDSet(testStudentAccountMap.keySet()));
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse incHisResult = (VemoAPI.ResultResponse)VemoAPIIncomeVerificationResource.handleAPI(incVarApiInfo);
		System.assertEquals(testIncVerMap.size(), incHisResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPIIncomeVerificationResource.handleAPI(studApiInfo);
		System.assertEquals(testIncVerMap.size(), studResult.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testHandlePostV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIIncomeVerificationResource.IncomeVerificationInputV1> incVerList = new List<VemoAPIIncomeVerificationResource.IncomeVerificationInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIIncomeVerificationResource.IncomeVerificationInputV1 incVer = new VemoAPIIncomeVerificationResource.IncomeVerificationInputV1(true);
			incVer.studentID = testStudentAccountMap.values().get(i).ID;
			incVer.employmentHistoryID = testEmpHisMap.values().get(i).ID;
			incVerList.add(incVer);
		}
		String body = JSON.serialize(incVerList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIIncomeVerificationResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandlePutV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIIncomeVerificationResource.IncomeVerificationInputV1> incVerList = new List<VemoAPIIncomeVerificationResource.IncomeVerificationInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIIncomeVerificationResource.IncomeVerificationInputV1 incVer = new VemoAPIIncomeVerificationResource.IncomeVerificationInputV1(true);
			incVer.incomeVerificationID = testIncVerMap.values().get(i).ID;
			incVer.employmentHistoryID = testEmpHisMap.values().get(i).ID;
			incVerList.add(incVer);
		}
		String body = JSON.serialize(incVerList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIIncomeVerificationResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandleDeleteV1(){
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');		
		params.put('incomeVerificationID', TestUtil.createStringFromIDSet(testIncVerMap.keySet()));

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);
		
		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIIncomeVerificationResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		System.assertEquals(0, IncomeVerificationQueries.getIncomeVerificationMap().size());
		Test.stopTest();
	}
}