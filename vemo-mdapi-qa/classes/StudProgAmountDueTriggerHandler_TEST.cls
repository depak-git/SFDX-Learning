/////////////////////////////////////////////////////////////////////////
// Class: StudProgAmountDueTriggerHandler_TEST
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-04   Jared Hagemann  Created                              
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class StudProgAmountDueTriggerHandler_TEST {

	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> agreementMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<Id, StudentProgramMonthlyStatus__c> agreementMonthStats = TestDataFactory.createAndInsertStudentProgramMonthlyStatus(5, agreementMap);
    }


	static testMethod void testManageAgreementsInsert(){
		TestUtil.setStandardConfiguration();
		Map<Id, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
		Map<Id, StudentProgramMonthlyStatus__c> agreementMonthStats =new Map<Id, StudentProgramMonthlyStatus__c>([select Id, Agreement__c from StudentProgramMonthlyStatus__c]);
    	Test.startTest();
    	Map<Id, StudentProgramAmountDue__c> agreementAmountDue = TestDataFactory.createAndInsertStudentProgramAmountDue(agreementMap, agreementMonthStats);
    	Test.stopTest();

    	List<StudentProgram__c> resultAgreements = [select Id, AmountDueToDate__c, ReconciliationDueToDate__c, MonthlyAmountDueToDate__c from StudentProgram__c where Id in: agreementMap.keySet() and AmountDueToDate__c > 0];
    	System.assert(!resultAgreements.isEmpty());
    	
    	for(StudentProgram__c agreement : resultAgreements){
    		System.assertEquals(5000 ,agreement.AmountDueToDate__c);
    	}   
    	
	}

	static testMethod void testManageAgreementsUpdate(){
		TestUtil.setStandardConfiguration();
		Map<Id, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
		Map<Id, StudentProgramMonthlyStatus__c> agreementMonthStats =new Map<Id, StudentProgramMonthlyStatus__c>([select Id, Agreement__c from StudentProgramMonthlyStatus__c]);
    	Map<Id, StudentProgramAmountDue__c> agreementAmountDue = TestDataFactory.createAndInsertStudentProgramAmountDue(agreementMap, agreementMonthStats);
    	for(StudentProgramAmountDue__c spad : agreementAmountDue.values()){
    		spad.Amount__c = 500;
    	}
    	Test.startTest();
    		update agreementAmountDue.values();
    	Test.stopTest();

    	List<StudentProgram__c> resultAgreements = [select Id, AmountDueToDate__c, ReconciliationDueToDate__c, MonthlyAmountDueToDate__c from StudentProgram__c where Id in: agreementMap.keySet() and AmountDueToDate__c > 0];
    	System.assert(!resultAgreements.isEmpty());
    	
    	for(StudentProgram__c agreement : resultAgreements){
    		System.assertEquals(2500 ,agreement.AmountDueToDate__c);
    	}   
    	
	}

	static testMethod void testManageAgreementsDelete(){
		TestUtil.setStandardConfiguration();
		Map<Id, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
		Map<Id, StudentProgramMonthlyStatus__c> agreementMonthStats =new Map<Id, StudentProgramMonthlyStatus__c>([select Id, Agreement__c from StudentProgramMonthlyStatus__c]);
    	Map<Id, StudentProgramAmountDue__c> agreementAmountDue = TestDataFactory.createAndInsertStudentProgramAmountDue(agreementMap, agreementMonthStats);
    	
    	Test.startTest();
    		delete agreementAmountDue.values();
    	Test.stopTest();

    	List<StudentProgram__c> resultAgreements = [select Id, AmountDueToDate__c, ReconciliationDueToDate__c, MonthlyAmountDueToDate__c from StudentProgram__c where Id in: agreementMap.keySet() and AmountDueToDate__c > 0];
    	System.assert(resultAgreements.isEmpty());     	
	}
}