@isTest
public class VemoAPICreditCriteriaResource_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    static testMethod void testHandleGetV1(){
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        VemoAPI.APIInfo CreditCriteriaApiInfo = TestUtil.initializeAPI('v1', 'GET', null, null);
        Map<ID, CreditCriteria__c> CreditCriteriaMap = TestDataFactory.createAndInsertCreditCriteria(1,programMap);  
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(CreditCriteria__c cc : CreditCriteriaMap.values()){
            programIDs.add(cc.Program__c);
        }
        List<CreditCriteriaService.CreditCriteria> ccList = CreditCriteriaService.getCreditCriteriaWithProgramID(programIDs);
        List<VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1> criteriaList = new List<VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1>();
        for(CreditCriteriaService.CreditCriteria cc: ccList){
            VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1 criteriaResource = new VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1(cc);    
            criteriaList.add(criteriaResource); 
        }
        VemoAPI.ResultResponse CreditCriteriaResult = (VemoAPI.ResultResponse)VemoAPICreditCriteriaResource.handleAPI(CreditCriteriaApiInfo);
        system.assertEquals(ccList.size(), criteriaList.size());
        Test.stopTest();  
    }

}