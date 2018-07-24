@isTest
public class VemoAPICaseResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<ID, Case> caseMap = TestDataFactory.createAndInsertCases(TestUtil.TEST_THROTTLE);
    	System.assertEquals(CaseQueries.getCaseMapByID().size(), TestUtil.TEST_THROTTLE, 'Did not create cases');
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	for(Integer i=0; i<TestUtil.TEST_THROTTLE; i++){
    		caseMap.values().get(i).AccountID = students.values().get(i).ID;
    	}
    	update caseMap.values();

    	Map<String, String> caseParams = new Map<String, String>();
		caseParams.put('caseID', (String)caseMap.values().get(0).Id);
		caseParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo caseApiInfo = TestUtil.initializeAPI('v1', 'GET', caseParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', (String)caseMap.values().get(0).AccountID);
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse caseResult = (VemoAPI.ResultResponse)VemoAPICaseResource.handleAPI(caseApiInfo);
		System.assertEquals(1, caseResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPICaseResource.handleAPI(studApiInfo);
		System.assertEquals(1, studResult.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testHandlePostV1(){
    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'ABC');

		List<VemoAPICaseResource.VemoCaseResourceInputV1> caseResList = new List<VemoAPICaseResource.VemoCaseResourceInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPICaseResource.VemoCaseResourceInputV1 caseRes = new VemoAPICaseResource.VemoCaseResourceInputV1(true);
			caseResList.add(caseRes);
		}

		String body = JSON.serialize(caseResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPICaseResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testHandlePutV1(){
    	Map<ID, Case> caseMap = TestDataFactory.createAndInsertCases(TestUtil.TEST_THROTTLE);
    	System.assertEquals(CaseQueries.getCaseMapByID().size(), TestUtil.TEST_THROTTLE, 'Did not create cases');

    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'ABC');

		List<VemoAPICaseResource.VemoCaseResourceInputV1> caseResList = new List<VemoAPICaseResource.VemoCaseResourceInputV1>();
		VemoAPICaseResource.VemoCaseResourceInputV1 caseRes = new VemoAPICaseResource.VemoCaseResourceInputV1(true);
		caseRes.caseID = caseMap.values().get(0).ID;
		caseRes.status = 'Billing';
		caseResList.add(caseRes);

		String body = JSON.serialize(caseResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPICaseResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		Test.stopTest();
    }
}