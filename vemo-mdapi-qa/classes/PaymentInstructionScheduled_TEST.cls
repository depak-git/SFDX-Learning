@isTest
public with sharing class PaymentInstructionScheduled_TEST {
	@isTest public static void testInboundACH(){
        Test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        PaymentInstructionScheduled job = new PaymentInstructionScheduled();
        job.JobType = PaymentInstructionBatch.JobType.SCHEDULE_INBOUND_ACH;
        System.schedule('ScheduledApexTest', CRON_EXP, job);  
        Test.stopTest();
    } 
}