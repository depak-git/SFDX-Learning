@isTest
public class VemoAPICreditCheckResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, StudentProgram__c> agreementMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, studentMap, programMap);

    }

    static testMethod void testHandleGetV1(){
    	Map<ID, Account> studentMap = AccountQueries.getStudentMap();
    	Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
    	Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);

    	agreementMap.values()[0].CreditCheck__c = ccMap.values()[0].id;
    	update agreementMap.values();

    	System.assertEquals(CreditCheckQueries.getCreditCheckMap().size(), TestUtil.TEST_THROTTLE, 'Did not create credit checks');

    	Map<String, String> ccParams = new Map<String, String>();
		ccParams.put('creditCheckID', (String)ccMap.values().get(0).Id);
		ccParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo ccApiInfo = TestUtil.initializeAPI('v1', 'GET', ccParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', (String)ccMap.values().get(0).Student__c);
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Map<String, String> agreeParams = new Map<String, String>();
		agreeParams.put('agreementID', (String)agreementMap.values().get(0).ID);
		agreeParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo agreeApiInfo = TestUtil.initializeAPI('v1', 'GET', agreeParams, null);

		Test.startTest();
		VemoAPI.ResultResponse ccResult = (VemoAPI.ResultResponse)VemoAPICreditCheckResource.handleAPI(ccApiInfo);
		System.assertEquals(1, ccResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPICreditCheckResource.handleAPI(studApiInfo);
		System.assertEquals(1, studResult.numberOfResults);

		VemoAPI.ResultResponse agreeResult = (VemoAPI.ResultResponse)VemoAPICreditCheckResource.handleAPI(agreeApiInfo);
		System.assertEquals(1, agreeResult.numberOfResults);
		Test.stopTest();		
    }
    
    static testMethod void testHandlePostV1(){
    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'ABC');

		Map<ID, Account> students = AccountQueries.getStudentMap();

		List<VemoAPICreditCheckResource.CreditCheckResourceInputV1> ccResMap = new List<VemoAPICreditCheckResource.CreditCheckResourceInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPICreditCheckResource.CreditCheckResourceInputV1 ccRes = new VemoAPICreditCheckResource.CreditCheckResourceInputV1(true);
			ccRes.studentID = students.values().get(i).ID;
			ccResMap.add(ccRes);
		}

		String body = JSON.serialize(ccResMap);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPICreditCheckResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testHandlePutV1(){
    	Map<ID, Account> studentMap = AccountQueries.getStudentMap();
    	Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);
    	System.assertEquals(CreditCheckQueries.getCreditCheckMap().size(), TestUtil.TEST_THROTTLE, 'Did not create credit checks');

    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'ABC');

    	List<VemoAPICreditCheckResource.CreditCheckResourceInputV1> ccResMap = new List<VemoAPICreditCheckResource.CreditCheckResourceInputV1>();
    	for(CreditCheck__c cc : ccMap.values()){
    		VemoAPICreditCheckResource.CreditCheckResourceInputV1 ccRes = new VemoAPICreditCheckResource.CreditCheckResourceInputV1();
    		ccRes.creditCheckID = cc.ID;
    		ccRes.jsonPayload = 'updated payload';
    		ccResMap.add(ccRes);
    	}
    	String body = JSON.serialize(ccResMap);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPICreditCheckResource.handleAPI(apiInfo);
		System.assertEquals(ccResMap.size(), result.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testHandleDeleteV1(){
    	Map<ID, Account> studentMap = AccountQueries.getStudentMap();
    	Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);
    	System.assertEquals(CreditCheckQueries.getCreditCheckMap().size(), TestUtil.TEST_THROTTLE, 'Did not create credit checks');

    	Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'ABC');
		params.put('creditCheckID', (String)ccMap.values().get(0).Id);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPICreditCheckResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		System.assertEquals(TestUtil.TEST_THROTTLE - 1, CreditCheckQueries.getCreditCheckMap().size(), 'One Credit Check should be deleted');
		Test.stopTest();
    }
    
}