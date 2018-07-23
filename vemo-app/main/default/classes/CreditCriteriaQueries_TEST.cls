@isTest
public with sharing class CreditCriteriaQueries_TEST{
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    @isTest
    public static void validateGetCreditCriteriaMapWithProgramID(){
        //create students
        Map<Id,Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(2);
        //create Programs with school
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(3,TestDataFactory.createAndInsertSchoolCustomerAccounts(2));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        integer cnt = 0;
        for(Account acc:studentMap.values()){
            if(cnt<3){
                acc.PrimarySchool__pc = schoolMap.values()[0].id;
            }
            else{
                acc.PrimarySchool__pc = schoolMap.values()[1].id;
            }    
        }
        update studentMap.values();
        Map<ID, CreditCriteria__c> CreditCriteriaMap = TestDataFactory.createAndInsertCreditCriteria(1,programMap);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(CreditCriteria__c cc : CreditCriteriaMap.values()){
            programIDs.add(cc.Program__c);
        }
        Map<Id,CreditCriteria__c> ccMapResult = CreditCriteriaQueries.getCreditCriteriaMapWithProgramID(programIDs);
        System.assertEquals(CreditCriteriaMap.keySet().size(), ccMapResult.keySet().size());
        Test.stopTest();
    }

}