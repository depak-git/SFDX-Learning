public class OutboundEmailBatchScheduled implements Schedulable {
  
  public void execute(SchedulableContext sc) {
    
    System.debug('OutboundEmailBatchScheduled.execute()');
    System.debug('session:'+UserInfo.getSessionId());
    
    OutboundEmailBatch job = new OutboundEmailBatch();
    database.executeBatch(job, 1);
  }
  
}