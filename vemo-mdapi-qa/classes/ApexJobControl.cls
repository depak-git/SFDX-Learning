public class ApexJobControl {
    
    @AuraEnabled
    public static List<ApexJobControl__c> getCustomSettingsRecord(){
        string query = 'select id,Name,BatchJob__c from ApexJobControl__c';
        List<ApexJobControl__c> detailList = Database.query(query);
        return detailList;
    }
    
    @AuraEnabled
    public static ApexJobControl__c getdetails(String jobName){
        string query = 'select id,Name,BatchJob__c,BatchJobJobType__c,ScheduleJob__c,Hour__c,SchedulerActive__c,CronMode__c,CronSchedule__c from ApexJobControl__c where Name like \''+jobName+'\' limit 1';
        ApexJobControl__c detailList = Database.query(query);
        return detailList;
    }
    
    @AuraEnabled
    public static string runJobNow(ApexJobControl__c apxjobCtr){
        system.debug(apxjobCtr);
        if (apxjobCtr.BatchJob__c == 'StudentProgramBatch'){
        
            StudentProgramBatch job = new StudentProgramBatch();
            
            if(apxjobCtr.BatchJobJobType__c == 'CONTRACT_ASSESSMENT'){
                job.job = StudentProgramBatch.JobType.CONTRACT_ASSESSMENT;
            }
            else if(apxjobCtr.BatchJobJobType__c == 'PURGE_DELETED'){
                job.job = StudentProgramBatch.JobType.PURGE_DELETED;
            }
            else if(apxjobCtr.BatchJobJobType__c == 'MONTH_END_AUDIT'){
                job.job = StudentProgramBatch.JobType.MONTH_END_AUDIT;
            }
            else if(apxjobCtr.BatchJobJobType__c == 'DELINQUENCY'){
                job.job = StudentProgramBatch.JobType.DELINQUENCY;
            }
            Database.executeBatch(job);
        }
        update apxjobCtr;
        
        return 'Completed';
    }
    
    @AuraEnabled
    public static string schedule_UnscheduleTheJob(string mode, ApexJobControl__c apxjobCtr){
        if(apxjobCtr.SchedulerActive__c == true){
            string CRONexp;
            if(mode.toLowerCase() == 'hourly')
                CRONexp = '0 0 * * * ?';            
                
            if(mode.toLowerCase() == 'daily')
            {
                if(apxjobCtr.Hour__c == NULL){
                    apxjobCtr.Hour__c = 0;
                }
                CRONexp = '0 0 ' + apxjobCtr.Hour__c +' * * ?';
            }
                
            if(apxjobCtr.ScheduleJob__c == 'StudentProgramBatchScheduled'){
                StudentProgramBatchScheduled scheduledJob = new StudentProgramBatchScheduled();
                if (apxjobCtr.BatchJobJobType__c == 'CONTRACT_ASSESSMENT'){
                    scheduledJob.jobType = StudentProgramBatch.JobType.CONTRACT_ASSESSMENT;
                }
                else if(apxjobCtr.BatchJobJobType__c == 'PURGE_DELETED'){
                    scheduledJob.jobType = StudentProgramBatch.JobType.PURGE_DELETED;
                }
                else if(apxjobCtr.BatchJobJobType__c == 'MONTH_END_AUDIT'){
                    scheduledJob.jobType = StudentProgramBatch.JobType.MONTH_END_AUDIT;
                }
                else if(apxjobCtr.BatchJobJobType__c == 'DELINQUENCY'){
                    scheduledJob.jobType = StudentProgramBatch.JobType.DELINQUENCY;
                }
                System.schedule(apxjobCtr.Name + ' ' + apxjobCtr.CronMode__c, cronexp, scheduledJob); //where Y = Daily or Hourly
            }
            update apxjobCtr;
            return 'Successfully Scheduled';
        }
        else{
            String JOB_NAME = 'SELECT Id, Name, JobType FROM CronJobDetail WHERE Name like \'%'+apxjobCtr.Name+'%\' limit 1';
            List<CronJobDetail> cronDetails = Database.query(JOB_NAME);
            Set<ID> cronTriggerIDs = new Set<ID>();
            for(CronJobDetail cjd : cronDetails){
                cronTriggerIDs.add(cjd.id);
            }
            List<CronTrigger> abort_job = [SELECT id from CronTrigger where CronJobDetailId = :cronTriggerIDs];
            for(CronTrigger ct : abort_job){
                system.abortJob(ct.id);
            }
            update apxjobCtr;
            return 'Successfully Unscheduled';
        }
    }
}
