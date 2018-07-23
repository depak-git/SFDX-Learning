@isTest
public class CreditCheckService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, StudentProgram__c> agreementMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, studentMap, programMap);
    }
    
    @isTest public static void validateGetCreditCheckWithCreditCheckID(){
    	Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);

    	Test.startTest();
    	List<CreditCheckService.CreditCheck> ccs = CreditCheckService.getCreditCheckWithCreditCheckID(ccMap.keySet());
    	System.assertEquals(ccMap.size(), ccs.size());
    	Test.stopTest();
    }
    
    @isTest public static void validateGetCreditCheckWithStudentID(){
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMap();
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();        
        Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);
        Set<Id> studentIds = new Set<Id>();
        for(CreditCheck__c cc : ccMap.values()){
            studentIds.add(cc.Student__c);
        }
        Test.startTest();
        List<CreditCheckService.CreditCheck> ccs = CreditCheckService.getCreditCheckWithStudentID(studentIds);
        System.assertEquals(ccMap.size(), ccs.size());
        Test.stopTest();
    }

    @isTest public static void validateGetCreditCheckWithAgreementID(){
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
        List<CreditCheckService.CreditCheck> ccs = CreditCheckService.getCreditCheckWithAgreementID(agreementMap.keySet());
        System.assertEquals(ccMap.size(), ccs.size());
        Test.stopTest();
    }
    
    @isTest public static void validateCreateCreditChecks(){

        Map<ID, Account> studentMap = AccountQueries.getStudentMap();

    	List<CreditCheckService.CreditCheck> ccList = new List<CreditCheckService.CreditCheck>();
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		CreditCheckService.CreditCheck cc = new CreditCheckService.CreditCheck(true);
    		cc.studentID = studentMap.values().get(i).id;
    		ccList.add(cc);
    	}
    	Test.startTest();
    	Set<ID> ccIDs = CreditCheckService.createCreditChecks(ccList);
    	System.assertEquals(ccList.size(), CreditCheckQueries.getCreditCheckMap().size());
    	Test.stopTest();
    }

    @isTest public static void  validateUpdateCreditChecks(){
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();

    	List<CreditCheckService.CreditCheck> ccList = new List<CreditCheckService.CreditCheck>();
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		CreditCheckService.CreditCheck cc = new CreditCheckService.CreditCheck(true);
    		cc.studentID = studentMap.values().get(i).ID;
    		ccList.add(cc);
    	}
    	Set<ID> ccIDs = CreditCheckService.createCreditChecks(ccList);
    	List<CreditCheckService.CreditCheck> newCCs = CreditCheckService.getCreditCheckWithCreditCheckID(ccIDs);
    	for(CreditCheckService.CreditCheck cc : newCCs){
    		cc.jsonPayload = 'updated payload';
    	}
    	Test.startTest();
    	Set<ID> updatedCCIDs = CreditCheckService.updateCreditChecks(newCCs);
    	Test.stopTest();
    	Map<ID, CreditCheck__c> ccMap = CreditCheckQueries.getCreditCheckMapWithCreditCheckID(updatedCCIDs);
    	for(CreditCheck__c cc : ccMap.values()){
    		System.assertEquals('updated payload', cc.JSONPayload__c);
    	}
    }

    @isTest public static void validateDeleteCreditChecks(){
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, CreditCheck__c> ccMap = TestDataFactory.createAndInsertCreditCheck(TestUtil.TEST_THROTTLE, studentMap);

    	Test.startTest();
    	Integer numDeleted = CreditCheckService.deleteCreditChecks(ccMap.keySet());
    	System.assertEquals(ccMap.size(), numDeleted);
    	System.assertEquals(0, CreditCheckQueries.getCreditCheckMap().size());
    	Test.stopTest();
    }
    
}