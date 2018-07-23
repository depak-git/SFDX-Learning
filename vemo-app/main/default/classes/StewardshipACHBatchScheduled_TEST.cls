@isTest
public with sharing class StewardshipACHBatchScheduled_TEST {
	@isTest public static void testQueryAPprovedOpen(){
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        StewardshipACHBatchScheduled job = new StewardshipACHBatchScheduled();
        job.JobType = StewardshipACHBatchBatch.JobType.QUERY_APPROVED_OPEN;
        System.schedule('ScheduledApexTest', CRON_EXP, job);  
        Test.stopTest();
    } 
}