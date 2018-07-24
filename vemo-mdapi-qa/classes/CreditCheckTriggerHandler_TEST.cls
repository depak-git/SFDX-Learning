@isTest
public class CreditCheckTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(2, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, StudentProgram__c> agreementMap = TestDataFactory.createAndInsertStudentProgram(5, studentMap, programMap);
    }

	@isTest public static void testSetAgreementFields() {
/*		TestUtil.setStandardConfiguration();
    	Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();

    	List<CreditCheck__c> ccList = new List<CreditCheck__c>();
    	for(StudentProgram__c stud : agreementMap.values()){
    		CreditCheck__c cc = new CreditCheck__c();
    		cc.Agreement__c = stud.ID;
    		cc.Student__c = stud.Student__c;
    		cc.Status__c = 'Denied';
    		ccList.add(cc);
    	}
    	Test.startTest();
    	system.debug('ccList:'+ccList);
    	insert ccList;


    	Map<ID, StudentProgram__c> agreementAfterMap = StudentProgramQueries.getStudentProgramMap();
    	for(StudentProgram__c stud : agreementAfterMap.values()){
    		system.assertEquals(stud.Status__c, 'Cancelled', 'Wrong Status');
    	}

    	for(CreditCheck__c cc : ccList){
    		cc.Status__c = 'Under Review';
    	}
    	update ccList;
    	
    	Map<ID, StudentProgram__c> agreementAfter2Map = StudentProgramQueries.getStudentProgramMap();
    	for(StudentProgram__c stud : agreementAfter2Map.values()){
    		system.assertEquals(stud.Status__c, 'Application Under Review', 'Wrong Status');
    	}

    	Test.stopTest();*/
    }
}