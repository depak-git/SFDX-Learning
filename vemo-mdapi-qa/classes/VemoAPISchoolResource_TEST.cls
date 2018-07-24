/////////////////////////////////////////////////////////////////////////
// Class: VemoAPISchoolResource_TEST
// 
// Description: 
// 	Test class for VemoAPISchoolResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPISchoolResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	static testMethod void testHandleGetV1(){
		Map<ID, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		System.assertEquals(AccountQueries.getSchoolMap().size(), TestUtil.TEST_THROTTLE, 'Did not create students');

		Map<String, String> schlIDParams = new Map<String, String>();
		schlIDParams.put('VEMO_AUTH', 'ABC');
		schlIDParams.put('schoolID', (String)schoolMap.values().get(0).Id);
		VemoAPI.APIInfo schlIDApiInfo = TestUtil.initializeAPI('v1', 'GET', schlIDParams, null);

		Map<String, String> schlNameParams = new Map<String, String>();
		schlNameParams.put('VEMO_AUTH', 'ABC');
		schlNameParams.put('schoolName', (String)schoolMap.values().get(0).Name);
		VemoAPI.APIInfo schlNameApiInfo = TestUtil.initializeAPI('v1', 'GET', schlNameParams, null);
		
		Test.startTest();
		VemoAPI.ResultResponse idResult = (VemoAPI.ResultResponse)VemoAPISchoolResource.handleAPI(schlIDApiInfo);
		System.assertEquals(1, idResult.numberOfResults);

		VemoAPI.ResultResponse nameResult = (VemoAPI.ResultResponse)VemoAPISchoolResource.handleAPI(schlNameApiInfo);
		System.assertEquals(1, nameResult.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandlePostV1(){
		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPISchoolResource.SchoolResourceInputV1> schlResList = new List<VemoAPISchoolResource.SchoolResourceInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPISchoolResource.SchoolResourceInputV1 schlRes = new VemoAPISchoolResource.SchoolResourceInputV1(true);
			schlResList.add(schlRes);
		}

		String body = JSON.serialize(schlResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPISchoolResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandlePutV1(){
		Map<ID, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		System.assertEquals(AccountQueries.getSchoolMap().size(), TestUtil.TEST_THROTTLE, 'Did not create students');

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPISchoolResource.SchoolResourceInputV1> schlResList = new List<VemoAPISchoolResource.SchoolResourceInputV1>();
		VemoAPISchoolResource.SchoolResourceInputV1 schlRes1 = new VemoAPISchoolResource.SchoolResourceInputV1(true);
		
		schlRes1.schoolID = schoolMap.values()[0].id;
		schlRes1.schoolName = 'updated';
		schlResList.add(schlRes1);

		String body = JSON.serialize(schlResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPISchoolResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandleDeleteV1(){
		Map<ID, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		System.assertEquals(AccountQueries.getSchoolMap().size(), TestUtil.TEST_THROTTLE, 'Did not create students');

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		params.put('schoolID', (String)schoolMap.values().get(0).Id);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);
		
		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPISchoolResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		System.assertEquals(TestUtil.TEST_THROTTLE - 1, AccountQueries.getSchoolMap().size(), 'One Student should be deleted');
		Test.stopTest();
	}
}