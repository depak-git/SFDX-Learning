/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIContractTermsResource_TEST
// 
// Description: 
// 	Test class for VemoAPIContractTermsResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-09  	Jared Hagemann	Created                          
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIContractTermsResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);    	
    	Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schoolMap);
		Map<ID, ContractTerm__c> contractTermMap = TestDataFactory.createAndInsertContractTerms(1, programMap);
		Map<ID, ProgramOfStudy__c> programsOfStudyMap = TestDataFactory.createAndInsertProgramOfStudy(1);
		Map<ID, SchoolProgramsOfStudy__c> schlProgramsOfStudyMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schoolMap, programsOfStudyMap);
		for(Integer i = 0; i < studentMap.keySet().size(); i++){
			studentMap.values().get(i).SchoolProgramOfStudy__pc = schlProgramsOfStudyMap.values().get(i).Id;
			studentMap.values().get(i).PrimarySchoolGradeLevel__pc = contractTermMap.values().get(0).GradeLevel__c;
		}
		update studentMap.values();
		Map<ID, IncomeBand__c> incomeBandMap = TestDataFactory.createAndInsertIncomeBands(1, schlProgramsOfStudyMap);		

		Map<String, String> params = new Map<String, String>();
		params.put('programID', (String)programMap.values().get(0).Id);
		params.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'GET', params, null);
		apiInfo.studentPersonAccountID = studentMap.values()[0].Id;

		Test.startTest();
		VemoAPI.ResultResponse stdResult = (VemoAPI.ResultResponse)VemoAPIContractTermsResource.handleAPI(apiInfo);
		System.assertEquals(1, stdResult.numberOfResults);
		Test.stopTest();

    }
}