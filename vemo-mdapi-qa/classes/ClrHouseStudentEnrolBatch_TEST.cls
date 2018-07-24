@isTest
public class ClrHouseStudentEnrolBatch_TEST {
  @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testStart(){
      Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
      Map<Id, ClrHouseStudentEnrollment__c> clrHouseStudentEnrollments = TestDataFactory.createAndInsertClrHouseStudentEnrollment(TestUtil.TEST_THROTTLE,students);
      Test.startTest();
      ClrHouseStudentEnrolBatch job = new ClrHouseStudentEnrolBatch();
      Database.executeBatch(job, 200);
      Test.stopTest();
    }
}