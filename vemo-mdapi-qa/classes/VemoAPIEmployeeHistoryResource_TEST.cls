/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIEmployeeHistoryResource_TEST
// 
// Description: 
//		Test class for VemoAPIEmployeeHistoryResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann	Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIEmployeeHistoryResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);


    	Map<String, String> empHisParams = new Map<String, String>();
		empHisParams.put('employmentHistoryID', TestUtil.createStringFromIDSet(testEmpHisMap.keySet()));
		empHisParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo empHisApiInfo = TestUtil.initializeAPI('v1', 'GET', empHisParams, null);

		Map<String, String> studParams = new Map<String, String>();
		studParams.put('studentID', TestUtil.createStringFromIDSet(testStudentAccountMap.keySet()));
		studParams.put('VEMO_AUTH', 'ABC');
		VemoAPI.APIInfo studApiInfo = TestUtil.initializeAPI('v1', 'GET', studParams, null);

		Test.startTest();
		VemoAPI.ResultResponse empHisResult = (VemoAPI.ResultResponse)VemoAPIEmployeeHistoryResource.handleAPI(empHisApiInfo);
		System.assertEquals(testEmpHisMap.size(), empHisResult.numberOfResults);

		VemoAPI.ResultResponse studResult = (VemoAPI.ResultResponse)VemoAPIEmployeeHistoryResource.handleAPI(studApiInfo);
		System.assertEquals(testEmpHisMap.size(), studResult.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testHandlePostV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1> empHisList = new List<VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1 empHis = new VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1(true);
			empHis.studentID = testStudentAccountMap.values().get(i).ID;
			empHisList.add(empHis);
		}
		String body = JSON.serialize(empHisList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIEmployeeHistoryResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void testHandlePutV1(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		
		List<VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1> empHisList = new List<VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1 empHis = new VemoAPIEmployeeHistoryResource.EmploymentHistoryInputV1(true);
			empHis.employmentHistoryID = testEmpHisMap.values().get(i).ID;
			empHis.verified = false;
			empHisList.add(empHis);
		}
		String body = JSON.serialize(empHisList);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'PUT', params, body);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIEmployeeHistoryResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		Test.stopTest();		
	}

	static testMethod void testHandleDeleteV1(){
		Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');		
		params.put('employmentHistoryID', TestUtil.createStringFromIDSet(testEmpHisMap.keySet()));

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);
		
		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIEmployeeHistoryResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, result.numberOfResults);
		System.assertEquals(0, EmploymentHistoryQueries.getEmploymentHistoryMap().size());
		Test.stopTest();
	}
}