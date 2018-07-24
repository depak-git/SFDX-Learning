/////////////////////////////////////////////////////////////////////////
// Class: DisclosureTest
// 
// Description: 
// 	Test class for DisclosureService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-03-13   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
@isTest
private class Disclosure_TEST {
	@TestSetup static void setupData(){
		Map<ID, Account> testAccounts = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
		Map<ID, Program__c> testPrograms = TestDataFactory.createAndInsertPrograms(1, testAccounts);
		Map<ID, Program_Config__c> testProgramConfigs = TestDataFactory.createAndInsertProgramConfig(1, testPrograms);
		TestDataFactory.createAndInsertProgramConfigIncomes(testProgramConfigs);
		TestDataFactory.createAndInsertProgramConfigLoans(testProgramConfigs);
		
		Map<ID, Account> testStudents = TestDataFactory.createAndInsertStudentAccounts(1);
		Map<ID, StudentProgram__c> testStudentPrograms = TestDataFactory.createAndInsertStudentProgram(1, testStudents, testPrograms);
	}
	
	@isTest private static void myUnitTest() {
/*		List<StudentProgram__c> testStudentPrograms = [Select ID From StudentProgram__c];
		Test.startTest();
			//test StudentProgramTriggerHandler trigger
			for(StudentProgram__c studentProgram : testStudentPrograms){
	            studentProgram.FundingAmountPostCertification__c = 20000;
	            //studentProgram.RequestedAmount__c = 10000;
	            studentProgram.IncomeSharePostCertification__c = 3;
	            studentProgram.PaymentTermPostCertification__c = 92;
	            studentProgram.PaymentCapPostCertification__c = 25000;
	        }
	        update testStudentPrograms;
	        
	        testStudentPrograms = [Select ID, Program__c, FundingAmountPostCertification__c, IncomeSharePostCertification__c, PaymentTermPostCertification__c, PaymentCapPostCertification__c From StudentProgram__c];
	        
	        //test DisclosureService.Calculation
	        testStudentPrograms[0].PaymentCap__c = null;
	        DisclosureService.Calculation(testStudentPrograms);
			
	        //test no Funding Amount, line 78;
	        testStudentPrograms[0].FundingAmountPostCertification__c = null;
//	        testStudentPrograms[0].RequestedAmount__c = null;
	        DisclosureService.Calculation(testStudentPrograms);
	        
			//test PMT
	        DisclosureService.PMT(null, null, null);
		Test.stopTest();*/
	}
}