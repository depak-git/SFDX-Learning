@isTest
public class VemoAPIStudentResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	static testMethod void testHandleGetV1(){
		Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		System.assertEquals(AccountQueries.getStudentMap().size(), TestUtil.TEST_THROTTLE, 'Did not create students');

		Map<String, String> stdParams = new Map<String, String>();
		stdParams.put('studentID', (String)studentMap.values().get(0).Id);
		stdParams.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);
		VemoAPI.APIInfo stdApiInfo = TestUtil.initializeAPI('v1', 'GET', stdParams, null);

		Map<String, String> authParams = new Map<String, String>();
		authParams.put('studentID', (String)studentMap.values().get(0).Id);
		authParams.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);
		VemoAPI.APIInfo authApiInfo = TestUtil.initializeAPI('v1', 'GET', authParams, null);

		Test.startTest();
		VemoAPI.ResultResponse stdResult = (VemoAPI.ResultResponse)VemoAPIStudentResource.handleAPI(stdApiInfo);
		System.assertEquals(1, stdResult.numberOfResults);

		VemoAPI.ResultResponse authResult = (VemoAPI.ResultResponse)VemoAPIStudentResource.handleAPI(authApiInfo);
		System.assertEquals(1, authResult.numberOfResults);
		Test.stopTest();
	}
	
	static testMethod void testHandlePostV1(){
		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPIStudentResource.StudentResourceInputV1> studResList = new List<VemoAPIStudentResource.StudentResourceInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIStudentResource.StudentResourceInputV1 studRes = new VemoAPIStudentResource.StudentResourceInputV1(true);
			studRes.commonLineID = String.valueOf(i);
			studRes.studentID = null;
//			studRes.guid = null; //needs to be here until removed completely
			studResList.add(studRes);
		}

		String body = JSON.serialize(studResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIStudentResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}
	
	static testMethod void testHandlePutV1(){
		Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		System.assertEquals(AccountQueries.getStudentMap().size(), TestUtil.TEST_THROTTLE, 'Did not create students');

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);

		List<VemoAPIStudentResource.StudentResourceInputV1> studResList = new List<VemoAPIStudentResource.StudentResourceInputV1>();
		VemoAPIStudentResource.StudentResourceInputV1 studRes1 = new VemoAPIStudentResource.StudentResourceInputV1(true);
		
		studRes1.studentID = studentMap.values()[0].id;
		studRes1.lastName = 'updated';
//		studRes1.guid = null;	//needs to be here until removed completely	
		studRes1.authSystemUserID = null;
		studRes1.commonLineID = '1';
		studResList.add(studRes1);

		VemoAPIStudentResource.StudentResourceInputV1 studRes2 = new VemoAPIStudentResource.StudentResourceInputV1(true);
		
		studRes2.studentID = studentMap.values()[1].id;
		studRes2.lastName = 'updated';
//		studRes2.guid = null; //needs to be here until removed completely
		studRes2.authSystemUserID = null;
		studRes2.commonLineID = '2';
		studResList.add(studRes2);

		String body = JSON.serialize(studResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIStudentResource.handleAPI(apiInfo);
		System.assertEquals(2, result.numberOfResults);
		Test.stopTest();
	}
	
	static testMethod void testHandleDeleteV1(){
		Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		System.assertEquals(AccountQueries.getStudentMap().size(), TestUtil.TEST_THROTTLE, 'Did not create students');

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);
		params.put('studentID', (String)studentMap.values().get(0).Id);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);
		
		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIStudentResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		System.assertEquals(TestUtil.TEST_THROTTLE - 1, AccountQueries.getStudentMap().size(), 'One Student should be deleted');
		Test.stopTest();
	}
}