/*
PurgeDeletedDisbursementsScheduled job1 = new PurgeDeletedDisbursementsScheduled();
String cronStr = '0 0 * * * ? *';
System.schedule('Purge Deleted Disbursements', cronStr, job1);
*/
public class PurgeDeletedDisbursementsScheduled implements Schedulable {
	public void execute(SchedulableContext sc) {
		PurgeDeletedDisbursementsBatch job = new PurgeDeletedDisbursementsBatch();
		Database.executeBatch(job);
	}
}