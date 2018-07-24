
/*
/////////////////////////////Reconciliation Adobe Process////////////////////
ReconciliationBatchScheduled job = new ReconciliationBatchScheduled();
String cronStr = '0 0 * * * ? *';
System.schedule('Reconciliation Adobe Process Hourly', cronStr, job);
/////////////////////////////////////////////////////////////////////////////

*/

public class ReconciliationBatchScheduled implements Schedulable {
    public ReconciliationBatch.JobType jobType {get;set;}
    public String query {get;set;}
    public void execute(SchedulableContext sc) {
        ReconciliationBatch job = new ReconciliationBatch();
        Database.executeBatch(job, 1);
    }
}