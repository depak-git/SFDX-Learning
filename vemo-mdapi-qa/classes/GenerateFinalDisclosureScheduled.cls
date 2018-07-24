/*
GenerateFinalDisclosureScheduled job1 = new GenerateFinalDisclosureScheduled();
String cronStr = '0 0 * * * ? *';
System.schedule('Generate Final Disclosures Hourly', cronStr, job1);
*/
public class GenerateFinalDisclosureScheduled implements Schedulable {
	public void execute(SchedulableContext sc) {
		System.debug('GenerateFinalDisclosureScheduled.execute()');
		System.debug('session:'+UserInfo.getSessionId());
		GenerateFinalDisclosureBatch job = new GenerateFinalDisclosureBatch();
		database.executeBatch(job, 1);
	}
}