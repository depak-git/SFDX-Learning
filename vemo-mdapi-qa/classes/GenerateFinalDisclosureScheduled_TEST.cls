/////////////////////////////////////////////////////////////////////////
// Class: GenerateFinalDisclosureScheduled_TEST
// 
// Description: 
//  Unit test for GenerateFinalDisclosureScheduled
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-25   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class GenerateFinalDisclosureScheduled_TEST {
	static testMethod void testExecute(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(1);
    	Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<Id, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studentPrograms = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	for(StudentProgram__c sp : studentPrograms.values()){
    		sp.GenerateFinalDisclosure__c = true;
    	}
    	update studentPrograms.values();
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        System.schedule('ScheduledApexTest', CRON_EXP, new GenerateFinalDisclosureScheduled());  
        Test.stopTest();
    } 
}