@isTest
public class CreditCheckQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, StudentProgram__c> agreementMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, studentMap, programMap);

    }
    @isTest public static void validateGetCreditCheckMap(){
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
    	Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);
    	Test.startTest();
    	Map<ID, CreditCheck__c> resultCCMap = CreditCheckQueries.getCreditCheckMap();
    	System.assertEquals(ccMap.keySet().size(), resultCCMap.keySet().size());
    	Test.stopTest();
    }
    

    @isTest public static void validateGetCreditCheckMapWithCreditCheckID(){
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);
    	Test.startTest();
    	Map<ID, CreditCheck__c> resultCCMap = CreditCheckQueries.getCreditCheckMapWithCreditCheckID(ccMap.keySet());
    	System.assertEquals(ccMap.keySet().size(), resultCCMap.keySet().size());
    	Test.stopTest();
    }

    @isTest public static void validateGetCreditCheckMapWithStudentID(){
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);    
        Test.startTest();
        Map<ID, CreditCheck__c> resultCCMap = CreditCheckQueries.getCreditCheckMapWithStudentID(studentMap.keyset());
        System.assertEquals(ccMap.keySet().size(), resultCCMap.keySet().size());
        Test.stopTest();
    }
    @isTest public static void validateGetCreditCheckMapWithAgreementID(){
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);    



        Integer maxSize = agreementMap.size();
        if(ccMap.size()<maxSize) maxSize = ccMap.size();

        for(Integer i = 0; i<maxSize; i++){
            agreementMap.values()[i].CreditCheck__c = ccMap.values()[i].id;
        }
        update agreementMap.values();
        system.debug('agreementMap:'+agreementMap);
        system.debug('ccMap:'+ccMap);

        Test.startTest();
        Map<ID, CreditCheck__c> resultCCMap = CreditCheckQueries.getCreditCheckMapWithAgreementID(agreementMap.keySet());
        System.assertEquals(ccMap.keySet().size(), resultCCMap.keySet().size());
        Test.stopTest();
    }
}