/*
StudentProgramDelinquencyScheduled job1 = new StudentProgramDelinquencyScheduled();
String cronStr = '0 0 0 * * ? *';
System.schedule('Delinquency Tracking', cronStr, job1);
*/
public class StudentProgramDelinquencyScheduled implements Schedulable {
	public void execute(SchedulableContext sc) {
		StudentProgramBatch job = new StudentProgramBatch();
		job.job = StudentProgramBatch.JobType.DELINQUENCY;
		Database.executeBatch(job);
	}
}