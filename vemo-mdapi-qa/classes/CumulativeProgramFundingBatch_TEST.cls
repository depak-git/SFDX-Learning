/////////////////////////////////////////////////////////////////////////
// Class: CumulativeProgramFundingBatch_TEST
// 
// Description: 
//  Unit test for CumulativeProgramFundingBatch
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-09-13   Greg Cook  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class CumulativeProgramFundingBatch_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testStart(){
    	Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studentPrograms = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	for(StudentProgram__c sp : studentPrograms.values()){
    		sp.FundingAmountPostCertification__c = 100000;
    	}
    	update studentPrograms.values();
    	Test.startTest();
    	CumulativeProgramFundingBatch job = new CumulativeProgramFundingBatch();
    	Database.executeBatch(job, 200);
    	Test.stopTest();
    }
}