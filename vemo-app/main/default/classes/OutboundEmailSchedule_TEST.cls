@isTest
public class OutboundEmailSchedule_TEST{
     static testMethod void testExecute(){
        
        Test.startTest();
        
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        System.schedule('ScheduledApexTest', CRON_EXP, new OutboundEmailBatchScheduled());  
        
        Test.stopTest();
     }
}