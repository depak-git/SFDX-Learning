/////////////////////////////////////////////////////////////////////////
// Class: GenerateFinalDisclosureBatch_TEST
// 
// Description: 
//  Unit test for GenerateFinalDisclosureBatch
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-25   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class GenerateFinalDisclosureBatch_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testStart(){
    	Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studentPrograms = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	for(StudentProgram__c sp : studentPrograms.values()){
    		sp.GenerateFinalDisclosure__c = true;
    	}
    	update studentPrograms.values();
    	Test.startTest();
    	GenerateFinalDisclosureBatch gfdb = new GenerateFinalDisclosureBatch();
    	Database.executeBatch(gfdb, 200);
    	Test.stopTest();
    }
}