/*
StudentAccountScheduled job1 = new StudentAccountScheduled();
job1.job = StudentAccountBatch.JobType.ACCOUNT_ASSESSMENT;
String cronStr1 = '0 0 * * * ? *';
System.schedule('Student Account Assessment - Hourly', cronStr1, job1);

StudentAccountScheduled job2 = new StudentAccountScheduled();
job2.job = StudentAccountBatch.JobType.RECURRING_PAYMENT_GENERATION;
String cronStr2 = '0 0 * * * ? *';
System.schedule('Auto Payment Instruction Creation - Hourly', cronStr2, job2);
*/
public class StudentAccountScheduled implements Schedulable {
    public StudentAccountBatch.JobType job {get;set;}
	public void execute(SchedulableContext sc) {
		StudentAccountBatch batchJob = new StudentAccountBatch();
        batchJob.job = job;
		Database.executeBatch(batchJob);
	}
}