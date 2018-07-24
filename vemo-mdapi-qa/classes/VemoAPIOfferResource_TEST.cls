@isTest
public class VemoAPIOfferResource_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandleGetV1(){
    	Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Account> schoolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	for(Integer i = 0; i < TestUtil.TEST_THROTTLE; i++){
    		studentMap.values().get(i).PrimarySchool__pc = schoolMap.values().get(i).Id;
    	}
    	update studentMap.values();
    	Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schoolMap);
    	for(Program__c prg : programMap.values()){
    		prg.EnrollmentType__c = 'Open';
    		prg.ProgramStatus__c = 'Open';
    		prg.RegistrationBeginDate__c = Date.today().addMonths(-1);
    		prg.RegistrationEndDate__c = Date.today().addMonths(1);
    	}
    	update programMap.values();
    	Map<ID, StudentProgram__c> studentProgramMap = TestDataFactory.createAndInsertStudentProgram(1, studentMap, programMap);

    	Map<String, String> params = new Map<String, String>();
		params.put('studentID', (String)studentMap.values().get(0).Id);
		params.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'GET', params, null);
		//apiInfo.studentPersonAccountID = studentMap.values()[0].Id;

		Test.startTest();
		VemoAPI.ResultResponse stdResult = (VemoAPI.ResultResponse)VemoAPIOfferResource.handleAPI(apiInfo);
		System.assertEquals(TestUtil.TEST_THROTTLE, stdResult.numberOfResults);
		Test.stopTest();
    }

    static testMethod void testOfferResourceV1toOffer(){
    	VemoAPIOfferResource.OfferResourceInputV1 offerInput = new VemoAPIOfferResource.OfferResourceInputV1();
    	offerInput.programID = '1';
    	offerInput.programName = '2';
    	offerInput.schoolID = '3';
    	offerInput.programStatus = 'Open';
    	offerInput.agreementStatus = 'Pending';
    	offerInput.studentID = '4';
    	offerInput.agreementID = '5';
    	offerInput.enrollmentEndDate = Date.today();
    	Test.startTest();
    	OfferService.Offer offer = VemoAPIOfferResource.offerResourceV1toOffer(offerInput);
    	System.assertEquals(offerInput.programID, offer.programID);
    	Test.stopTest();
    }


}