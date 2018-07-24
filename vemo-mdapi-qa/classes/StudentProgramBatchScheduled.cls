/*
/////////////////////////////PURGE DELETED///////////////////////////////////
StudentProgramBatchScheduled job = new StudentProgramBatchScheduled();
job.jobType = StudentProgramBatch.JobType.PURGE_DELETED;
String cronStr = '0 0 * * * ? *';
System.schedule('Purge Deleted Agreements Hourly', cronStr, job);
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////DELINQUENCY///////////////////////////////////
StudentProgramBatchScheduled job1 = new StudentProgramBatchScheduled();
job1.jobType = StudentProgramBatch.JobType.DELINQUENCY;
String cronStr1 = '0 0 9 * * ? *';
System.schedule('Delinquency Tracking Daily', cronStr1, job1);
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////MONTH END AUDIT/////////////////////////////////
StudentProgramBatchScheduled job2 = new StudentProgramBatchScheduled();
job2.jobType = StudentProgramBatch.JobType.MONTH_END_AUDIT;
String cronStr2 = '0 0 19 L * ? *';
System.schedule('Student Program Audit Monthly', cronStr2, job2);
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////CONTRACT ASSESSMENT/////////////////////////////////
StudentProgramBatchScheduled job3 = new StudentProgramBatchScheduled();
job3.jobType = StudentProgramBatch.JobType.CONTRACT_ASSESSMENT;
String cronStr3 = '0 0 9 * * ? *';
System.schedule('Contract Assessment Tracking Daily', cronStr3, job3);
/////////////////////////////////////////////////////////////////////////////
*/

public class StudentProgramBatchScheduled implements Schedulable {
    public StudentProgramBatch.JobType jobType {get;set;}
    public String query {get;set;}
    public void execute(SchedulableContext sc) {
        StudentProgramBatch job = new StudentProgramBatch();
        job.job = this.jobType;
        job.query = this.query;
        Database.executeBatch(job);
    }
}