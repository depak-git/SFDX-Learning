@isTest
public with sharing class StudentProgramTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateProspectCreate
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateStudentProgramCreate() {	
		//Create Student Programs
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Test.startTest();
    	Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Test.stopTest();
	}

	/////////////////////////////////////////////////////////////////////////
    //Test Case: validateStudentProgramUpdate
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateStudentProgramUpdate() {	
		//Create Student Programs
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);

    	for(StudentProgram__c sp : studentPrgMap.values()){
    		sp.Status__c = 'Certified';
    	}
    	Test.startTest();
    	update studentPrgMap.values();
    	Test.stopTest();
	}

}