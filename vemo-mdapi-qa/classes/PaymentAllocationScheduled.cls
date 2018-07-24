/*
PaymentAllocationScheduled job1 = new PaymentAllocationScheduled();
String cronStr = '0 0 * * * ? *';
System.schedule('PaymentAllocation', cronStr, job1);
*/
public class PaymentAllocationScheduled implements Schedulable {
	public void execute(SchedulableContext sc) {
//		String query = 'Select id from PaymentInstruction__c where FullyAllocated__c = false and (Status__c = \'Scheduled\' or Status__c = \'Complete\')';
		String query = 'Select id from PaymentInstruction__c where FullyAllocated__c = false and (Status__c = \'Cleared\')';
		Boolean proofMode = false;
		PaymentAllocationBatch job = new PaymentAllocationBatch(query, proofMode);
		Database.executeBatch(job, 1);
	}
}