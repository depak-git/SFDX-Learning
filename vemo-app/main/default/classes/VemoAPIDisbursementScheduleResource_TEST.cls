@isTest
public class VemoAPIDisbursementScheduleResource_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    static testMethod void testHandleGetV1(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, TransactionSchedule__c> TransactionScheduleMap = TestDataFactory.createAndInsertTransactionSchedule(2, programs);
        VemoAPI.APIInfo vemodisbursementscheduleApiInfo = TestUtil.initializeAPI('v1', 'GET', null, null);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(TransactionSchedule__c txSch: TransactionScheduleMap.values()){
            programIDs.add(txSch.Program__c);
        }
        List<TransactionScheduleService.TransactionSchedule> txSchList = TransactionScheduleService.gettransactionScheduleswithProgramID(programIDs);
        List<VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1> SchList = new List<VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1>();
        for(TransactionScheduleService.TransactionSchedule txSch: txSchList){
            VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1 txSchResource = new VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1(txSch);    
            SchList.add(txSchResource); 
        }
        VemoAPI.ResultResponse txSchResult = (VemoAPI.ResultResponse)VemoAPIDisbursementScheduleResource.handleAPI(vemodisbursementscheduleApiInfo);
        system.assertEquals(txSchList.size(), SchList.size());
        Test.stopTest();
    }
    
}