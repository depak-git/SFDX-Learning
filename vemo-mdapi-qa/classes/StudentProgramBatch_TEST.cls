@isTest
private class StudentProgramBatch_TEST
{
  @isTest
  static void delinquency(){
    Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
      integer days = -12;
      for(StudentProgram__c agreement : studentPrgMap.values()){
        //agreement.Deleted__c = true;
        agreement.NextPaymentDue__c  = 100;
        agreement.NextPaymentDueDate__c = Date.today().addDays(days);
        agreement.bypassautomation__c = true;
        days -= 15;
      }
    TriggerSettings.getSettings().studentProgramTrigger = false;
    update studentPrgMap.values();
    TriggerSettings.getSettings().studentProgramTrigger = true;

        
    Test.startTest();
    StudentProgramBatch job = new StudentProgramBatch();
    job.job = StudentProgramBatch.JobType.DELINQUENCY;
    Database.executeBatch(job, 200);
    Test.stopTest();
  }
  
  @isTest
  static void purgeDeleted(){
    Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
      Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
      for(StudentProgram__c agreement : studentPrgMap.values()){
        agreement.Deleted__c = true;
        agreement.Status__c = 'Draft';
      }
    update studentPrgMap.values();
    
    Test.startTest();
    StudentProgramBatch job = new StudentProgramBatch();
    job.job = StudentProgramBatch.JobType.PURGE_DELETED;
    Database.executeBatch(job, 200);
    Test.stopTest();

  }
  @isTest
  static void monthEndAudit(){
    Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
      Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
      

    Test.startTest();
    StudentProgramBatch job = new StudentProgramBatch();
    job.job = StudentProgramBatch.JobType.MONTH_END_AUDIT;
    Database.executeBatch(job, 200);
    Test.stopTest();

  }


}