/*
StewardshipACHBatchScheduled job = new StewardshipACHBatchScheduled();
job.jobType = StewardshipACHBatchBatch.JobType.QUERY_APPROVED_OPEN;
String cronStr = '0 0 8 * * ? *';
System.schedule('Query Approved Open Stewardship Batches', cronStr, job);
*/

public with sharing class StewardshipACHBatchScheduled implements Schedulable {
	public StewardshipACHBatchBatch.JobType jobType {get;set;}
	public String query {get;set;}
	public StewardshipACHBatchScheduled(){
		jobType = StewardshipACHBatchBatch.JobType.QUERY_APPROVED_OPEN;
	}
	public void execute(SchedulableContext sc) {
		if(jobType == StewardshipACHBatchBatch.JobType.QUERY_APPROVED_OPEN){
			queryApprovedOpen();
		}
	} 

	private void queryApprovedOpen(){
		//Approved Open
		StewardshipACHBatchBatch job = new StewardshipACHBatchBatch();
		job.job = jobType;
		if(String.isNotBlank(query)){
			job.query = query;
		}
		Database.executeBatch(job, 1);
	}
}