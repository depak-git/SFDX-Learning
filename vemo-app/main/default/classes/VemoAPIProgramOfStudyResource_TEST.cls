@isTest
public with sharing class VemoAPIProgramOfStudyResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest static void testHandleGetV1(){
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, ProgramOfStudy__c> testPOSMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, testPOSMap);
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		students.values().get(i).SchoolProgramOfStudy__pc = testSPOSMap.values().get(i).ID;
    	}
    	update students.values();

    	Map<String, String> noParams = new Map<String, String>();
		noParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo noApiInfo = TestUtil.initializeAPI('v1', 'GET', noParams, null);

    	Map<String, String> posParams = new Map<String, String>();
		posParams.put('programOfStudyID', (String)testPOSMap.values().get(0).Id);
		posParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo posApiInfo = TestUtil.initializeAPI('v1', 'GET', posParams, null);

		Map<String, String> schlParams = new Map<String, String>();
		schlParams.put('schoolID', (String)schools.values().get(0).Id);
		schlParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo schlApiInfo = TestUtil.initializeAPI('v1', 'GET', schlParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', (String)students.values().get(0).Id);
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse noResult = (VemoAPI.ResultResponse)VemoAPIProgramOfStudyResource.handleAPI(noApiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, noResult.numberOfResults);

		VemoAPI.ResultResponse posResult = (VemoAPI.ResultResponse)VemoAPIProgramOfStudyResource.handleAPI(posApiInfo);
		System.assertEquals(1, posResult.numberOfResults);
		
		VemoAPI.ResultResponse schlResult = (VemoAPI.ResultResponse)VemoAPIProgramOfStudyResource.handleAPI(schlApiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, schlResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPIProgramOfStudyResource.handleAPI(studApiInfo);
		System.assertEquals(1, studResult.numberOfResults);
		
		Test.stopTest();
    }

    @isTest static void testHandlePostV1(){
    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1> posResList = new List<VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1 posRes = new VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1(true);
			posResList.add(posRes);
		}

		String body = JSON.serialize(posResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIProgramOfStudyResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
    }

    @isTest static void testHandlePutV1(){
    	Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	System.assertEquals(ProgramOfStudyQueries.getProgramOfStudyMap().size(), TestUtil.TEST_THROTTLE, 'Did not create programs of study');

    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1> posResList = new List<VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1>();
		VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1 posRes = new VemoAPIProgramOfStudyResource.ProgramOfStudyResourceInputV1(true);
		posRes.programOfStudyID = posMap.values().get(0).ID;
		posRes.code = 'Updated Code';
		posResList.add(posRes);

		String body = JSON.serialize(posResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIProgramOfStudyResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		Test.stopTest();
    }

    @isTest static void testHandleDeleteV1(){
    	Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	System.assertEquals(ProgramOfStudyQueries.getProgramOfStudyMap().size(), TestUtil.TEST_THROTTLE, 'Did not create programs of study');


    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		params.put('programOfStudyID', (String)posMap.values().get(0).Id);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIProgramOfStudyResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		System.assertEquals(TestUtil.TEST_THROTTLE - 1, ProgramOfStudyQueries.getProgramOfStudyMap().size(), 'One Student should be deleted');
		Test.stopTest();
    }
}