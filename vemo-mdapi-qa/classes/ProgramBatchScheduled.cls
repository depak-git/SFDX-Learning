/*
//Disbursement Confirmation Notifification
ProgramBatchScheduled job1 = new ProgramBatchScheduled();
//job1.job = ProgramBatch.JobType.DISB_CONF_NOTIFICATION;
//String cronStr = '0 0 * * * ? *'; //hourly
String cronStr = '0 0 9 * * ? *'; //nightly at 9am
System.schedule('Disbursement Confirmation Notification', cronStr, job1);
*/
public class ProgramBatchScheduled implements Schedulable {

	public static ProgramBatch.JobType job {get;set;}

	public void execute(SchedulableContext sc) {
		if(job == null){
			job = ProgramBatch.JobType.DISB_CONF_NOTIFICATION;
		}
		ProgramBatch job1 = new ProgramBatch();
		job1.job = job;
		Database.executeBatch(job1);
	}
}