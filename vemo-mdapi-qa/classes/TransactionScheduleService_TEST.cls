@isTest
public class TransactionScheduleService_TEST {
  @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGettransactionScheduleswithProgramID(){

      Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
      Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);


      Map<ID, TransactionSchedule__c> testSchedule = TestDataFactory.createAndInsertTransactionSchedule(2, programs);
      Test.startTest();
      Set<Id> programIDs = new Set<ID>();
      for(TransactionSchedule__c trsch : testSchedule.values()){
           programIDs.add(trsch.Program__c);
      }
      List<TransactionScheduleService.transactionSchedule> trschList = TransactionScheduleService.gettransactionScheduleswithProgramID(programIDs);
      Test.stopTest();
      System.assertEquals(testSchedule.keySet().size(), trschList.size());
    }

    @isTest public static void validateGettransactionSchedulesByProgramIDWithProgramID(){

      Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
      Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);

      Map<ID, TransactionSchedule__c> testSchedule = TestDataFactory.createAndInsertTransactionSchedule(2, programs);
      Test.startTest();
      Set<Id> programIDs = new Set<ID>();
      for(TransactionSchedule__c trsch : testSchedule.values()){
           programIDs.add(trsch.Program__c);
      }
      Map<Id,List<TransactionScheduleService.transactionSchedule>> trschMap = TransactionScheduleService.gettransactionSchedulesByProgramIDWithProgramID(programIDs);
      
      Test.stopTest();

      System.assertEquals(programIDs.size(), trschMap.keyset().size());
    }
}