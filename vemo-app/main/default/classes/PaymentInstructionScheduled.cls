/*
PaymentInstructionScheduled job = new PaymentInstructionScheduled();
job.jobType = PaymentInstructionBatch.JobType.SCHEDULE_INBOUND_ACH;
String cronStr = '0 20 * * * ? *';
System.schedule('Generate ACH Batch Nightly', cronStr, job);
*/

public with sharing class PaymentInstructionScheduled implements Schedulable {
	public PaymentInstructionBatch.JobType jobType {get;set;}
	public String query {get;set;}
	public PaymentInstructionScheduled(){
		jobType = PaymentInstructionBatch.JobType.SCHEDULE_INBOUND_ACH;
	}
	public void execute(SchedulableContext sc) {
		if(jobType == PaymentInstructionBatch.JobType.SCHEDULE_INBOUND_ACH){
			scheduleInboudACH();
		}
	} 

	private void scheduleInboudACH(){
		//Inbound ACH
		PaymentInstructionBatch job = new PaymentInstructionBatch();
		job.job = jobType;
		if(String.isNotBlank(query)){
			job.query = query;
		}
		Database.executeBatch(job, 100);
	}
}