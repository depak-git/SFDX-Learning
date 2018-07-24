/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIStatementResource_TEST
// 
// Description: 
// 	Test class for VemoAPIStatementResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-10   Jared Hagemann  Created                              
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIStatementResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<Id, StudentProgram__c> studProgramMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);

		Map<String, String> studIDParams = new Map<String, String>();
		studIDParams.put('VEMO_AUTH', 'ABC');
		studIDParams.put('studentID', TestUtil.createStringFromIDSet(students.keySet()));
		VemoAPI.APIInfo studIDApiInfo = TestUtil.initializeAPI('v1', 'GET', studIDParams, null);
		
		Test.startTest();
		VemoAPI.ResultResponse idResult = (VemoAPI.ResultResponse)VemoAPIStatementResource.handleAPI(studIDApiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, idResult.numberOfResults);
		Test.stopTest();
	}
}