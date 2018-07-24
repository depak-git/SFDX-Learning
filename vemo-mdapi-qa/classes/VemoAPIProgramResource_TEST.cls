/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIProgramResource_TEST
// 
// Description: 
// 	Test class for VemoAPIProgramResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIProgramResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
	static VemoAPI.APIInfo initializeAPI(String version, String method, Map<String, String> params, String body){
		VemoAPI.APIInfo apiInfo = new VemoAPI.APIInfo();
		apiInfo.method = method;
		apiInfo.version = version;
		apiInfo.params = params;
		apiInfo.body = body;
		return apiInfo;		
	}
	
	static testMethod void testHandleGetV1(){
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
		Map<String, String> prgParams = new Map<String, String>();
		prgParams.put('VEMO_AUTH', 'ABC');
		prgParams.put('programID', (String)programMap.values().get(0).Id);
		VemoAPI.APIInfo prgApiInfo = initializeAPI('v1', 'GET', prgParams, null);

		Map<String, String> schlParams = new Map<String, String>();
		schlParams.put('VEMO_AUTH', 'ABC');
		schlParams.put('schoolID', (String)programMap.values().get(0).School__c);
		VemoAPI.APIInfo schlApiInfo = initializeAPI('v1', 'GET', schlParams, null);

		Test.startTest();
		VemoAPI.ResultResponse prgResult = (VemoAPI.ResultResponse)VemoAPIProgramResource.handleAPI(prgApiInfo);
		System.assertEquals(1, prgResult.numberOfResults);
		VemoAPI.ResultResponse schlResult = (VemoAPI.ResultResponse)VemoAPIProgramResource.handleAPI(schlApiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, schlResult.numberOfResults);
		Test.stopTest();		

	}
	
	static testMethod void testHandlePostV1(){
		Map<Id, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIProgramResource.ProgramResourceInputV1> prgResList = new List<VemoAPIProgramResource.ProgramResourceInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIProgramResource.ProgramResourceInputV1 prgRes = new VemoAPIProgramResource.ProgramResourceInputV1(true);
			prgRes.schoolID = schoolMap.values().get(i).ID;
			prgResList.add(prgRes);
		}
		String body = JSON.serialize(prgResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIProgramResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}
	
	static testMethod void testHandlePutV1(){
		Map<Id, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Program__c> programMap = TestDataFactory.createAndInsertPrograms(1, schoolMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPIProgramResource.ProgramResourceInputV1> prgResList = new List<VemoAPIProgramResource.ProgramResourceInputV1>();
		VemoAPIProgramResource.ProgramResourceInputV1 prgRes = new VemoAPIProgramResource.ProgramResourceInputV1(true);
		prgRes.programID = programMap.values().get(0).ID;
		prgRes.programStatus = 'Planned';
		prgResList.add(prgRes);

		String body = JSON.serialize(prgResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIProgramResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		Test.stopTest();

	}
	
	static testMethod void testHandleDeleteV1(){
		Map<Id, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Program__c> programMap = TestDataFactory.createAndInsertPrograms(1, schoolMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		params.put('programID', (String)programMap.values().get(0).Id);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);
		
		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIProgramResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		System.assertEquals(TestUtil.TEST_THROTTLE - 1, ProgramQueries.getProgramMap().size(), 'One Program should be deleted');
		Test.stopTest();
	}
	
}