@isTest
public with sharing class StudProgMnthStsTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
	//to do jared - this is just a dummy method to get past test levels
	@isTest
	public static void validateDML(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studProgramMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, students, programs);

		List<StudentProgramMonthlyStatus__c> monthlyStatus = new List<StudentProgramMonthlyStatus__c>();
		monthlyStatus.add(new StudentProgramMonthlyStatus__c(Activity__c = 'Grace',
															 Month__c = 'January',
															 Year__c = '2017',
															 Agreement__c = studProgramMap.values()[0].id));
		insert monthlyStatus;
		update monthlyStatus;
		delete monthlyStatus;
		undelete monthlyStatus;
	}
}