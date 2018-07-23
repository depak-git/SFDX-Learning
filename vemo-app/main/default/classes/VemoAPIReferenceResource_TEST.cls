@isTest
public with sharing class VemoAPIReferenceResource_TEST {
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
	
	static testMethod void validateHandleGetV1(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(2);
        Map<ID, Contact> references = TestDataFactory.createAndInsertStudentReferences(TestUtil.TEST_THROTTLE, students);
        System.assertEquals(references.size(), TestUtil.TEST_THROTTLE * students.size(), 'Not correct number of references');

		Map<String, String> refParams = new Map<String, String>();
		refParams.put('VEMO_AUTH', 'ABC');
		refParams.put('referenceID', (String)references.values().get(0).Id);
		VemoAPI.APIInfo refAPIInfo = initializeAPI('v1', 'GET', refParams, null);
		
		Map<String, String> studParams = new Map<String, String>();
		studParams.put('VEMO_AUTH', 'ABC');
		studParams.put('studentID', (String)students.values().get(0).id);
		VemoAPI.APIInfo studentAPIInfo = initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse refResult = (VemoAPI.ResultResponse)VemoAPIReferenceResource.handleAPI(refApiInfo);
//		System.assertEquals(1, refResult.numberOfResults);
		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPIReferenceResource.handleAPI(studentAPIInfo);
//		System.assertEquals(TestUtil.TEST_THROTTLE, studResult.numberOfResults);

		Test.stopTest();		

	}
	
	/*
	static testMethod void testHandlePostV1(){
		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPIAgreementResource.AgreementResourceInputV1> agrResList = new List<VemoAPIAgreementResource.AgreementResourceInputV1>();
		//POST
		Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
        	VemoAPIAgreementResource.AgreementResourceInputV1 agrRes = new VemoAPIAgreementResource.AgreementResourceInputV1(true);
        	agrRes.studentID = students.values().get(i).ID;
        	agrRes.programID = programs.values().get(i).ID;
        	agrRes.agreementStatus = 'Application Incomplete';
        	agrResList.add(agrRes);
        }
        //PUT
        //Map<Id, Account> studentsPut = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        //Map<Id, Account> schoolsPut = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programsPut = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, StudentProgram__c> studPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programsPut);
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
        	VemoAPIAgreementResource.AgreementResourceInputV1 agrRes = new VemoAPIAgreementResource.AgreementResourceInputV1(true);
        	agrRes.programID = programsPut.values().get(i).ID;
        	agrRes.agreementID = studPrgMap.values().get(i).ID;
        	agrRes.agreementStatus = 'Application Incomplete';        	
        	agrResList.add(agrRes);
        }

        String body = JSON.serialize(agrResList);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

        Test.startTest();
        VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIAgreementResource.handleAPI(apiInfo);
        System.assertEquals(2 * TestUtil.TEST_THROTTLE, result.numberOfResults);
        Test.stopTest();
	}
	
	static testMethod void testHandlePutV1(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
		Map<ID, StudentProgram__c> studPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		List<VemoAPIAgreementResource.AgreementResourceInputV1> agrResList =  new List<VemoAPIAgreementResource.AgreementResourceInputV1>();
		for(StudentProgram__c studPrg : studPrgMap.values()){
			VemoAPIAgreementResource.AgreementResourceInputV1 agrRes = new VemoAPIAgreementResource.AgreementResourceInputV1(true);
			agrRes.agreementID = studPrg.ID;
			//agrRes.programID = studPrgMap.values().get(0).Program__c;
			agrRes.agreementStatus = 'Application Complete';
			agrResList.add(agrRes);
		}

		String body = JSON.serialize(agrResList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIAgreementResource.handleAPI(apiInfo);
		System.assertEquals(studPrgMap.size(), result.numberOfResults);
		Test.stopTest();
	}
	
	static testMethod void testHandleDeleteV1(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
		Map<ID, StudentProgram__c> studPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		params.put('agreementID', studPrgMap.values().get(0).ID);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIAgreementResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		System.assertEquals((TestUtil.TEST_THROTTLE*TestUtil.TEST_THROTTLE) - 1, StudentProgramQueries.getStudentProgramMap().size());
		Test.stopTest();
	}*/
}