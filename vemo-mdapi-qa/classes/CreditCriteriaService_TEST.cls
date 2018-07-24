@isTest
public class CreditCriteriaService_TEST {

    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
         
    }
    
    @isTest
    public static void validateGetCreditCriteriaWithProgramID(){
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        
        Map<ID, CreditCriteria__c> CreditCriteriaMap = TestDataFactory.createAndInsertCreditCriteria(1,programMap);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(CreditCriteria__c cc : CreditCriteriaMap.values()){
            programIDs.add(cc.Program__c);
        }
        List<CreditCriteriaService.CreditCriteria> ccList = CreditCriteriaService.getCreditCriteriaWithProgramID(programIDs);
        System.assertEquals(CreditCriteriaMap.keySet().size(), ccList.size());
        Test.stopTest();
    
    }
     @isTest
    public static void validategetCreditCriteriaByProgramIDWithProgramID(){
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        
        Map<ID, CreditCriteria__c> CreditCriteriaMap = TestDataFactory.createAndInsertCreditCriteria(1,programMap);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(CreditCriteria__c cc: CreditCriteriaMap.values()){
            programIDs.add(cc.Program__c);
        }
        Map<Id,List<CreditCriteriaService.CreditCriteria>> ccMap = CreditCriteriaService.getCreditCriteriaByProgramIDWithProgramID(programIDs);
        System.assertEquals(programIDs.size(), ccMap.keyset().size());
        Test.stopTest();
    }
}