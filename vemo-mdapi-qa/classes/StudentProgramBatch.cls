public with sharing class StudentProgramBatch implements Database.Batchable<sObject>, Database.ALlowsCallouts{
    public enum JobType {DELINQUENCY, PURGE_DELETED, MONTH_END_AUDIT, CONTRACT_ASSESSMENT} 
    
    public String query {get;set;}
    public JobType job {get;set;}
    
    public StudentProgramBatch() {

    }
    public StudentProgramBatch(String query) {
        this.query = query;
    }   
    public Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('StudentProgramBatch.start()');
        if(job == JobType.DELINQUENCY){
            if(String.isEmpty(this.query)){
                query = 'SELECT id, DaysDelinquent__c, Student__c, Student__r.PersonContactID, Student__r.PersonEmail from StudentProgram__c WHERE DaysDelinquent__c > 0 ORDER BY DaysDelinquent__c DESC';
            }
        } else if(job == JobType.PURGE_DELETED){
            if(String.isEmpty(this.query)){
                Set<String> deletableStatuses= new Set<String>{'Draft', 'Invited', 'Cancelled'};
                query = 'SELECT id from StudentProgram__c WHERE Deleted__c = true and Status__c IN :deletableStatuses';
            }
        } else if(job == JobType.MONTH_END_AUDIT){
            if(String.isEmpty(this.query)){
                query = 'SELECT id From StudentProgram__c Where Deleted__c = false';
            }
        } else if(job == JobType.CONTRACT_ASSESSMENT){
            if(String.isEmpty(this.query)){
				String dateToday = String.valueOf(Date.today());			
				query = 'SELECT id from StudentProgram__c WHERE (AssessmentDate__c <= '+dateToday + ' OR AssessContract__c = true)';
            }
        }
        System.debug('job:'+job);
        System.debug('query:'+query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('StudentProgramBatch.execute()');
        System.debug('scope:'+scope);   
        if(job == JobType.DELINQUENCY){
            handleDelinquency((List<StudentProgram__c>)scope);
        }else if(job == JobType.PURGE_DELETED){
            handlePurgeDeleted((List<StudentProgram__c>)scope);
        }else if(job == JobType.MONTH_END_AUDIT){
            handleAudit((List<StudentProgram__c>)scope);
        }else if(job == JobType.CONTRACT_ASSESSMENT){
            Set<ID> agreementIDs = new Set<ID>();
            for(SObject obj : scope){
                agreementIDs.add(obj.id);
            }
            AssessmentService.assessContracts(agreementIDs);
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        System.debug('StudentProgramBatch.finish()');

    }
    
    private static void handlePurgeDeleted(List<StudentProgram__c> agreements){
        System.debug('StudentProgramBatch.handlePurgeDeleted()');   
        Set<ID> agreementIDs = new Set<ID>();
        for(StudentProgram__c agreement : agreements){
            agreementIDs.add(agreement.id);
        }
        Map<ID, Transaction__c> disbMap = TransactionQueries.getTransactionMapWithAgreementID(agreementIDs, TransactionService.disbursementRecType);
        Database.delete(disbMap.values(), false);
        Database.delete(agreements, false);
    }

       private static void handleDelinquency(List<StudentProgram__c> agreements){

        System.debug('StudentProgramBatch.handleDelinquency()');    
        List<Task> tasksToBeCreated = new List<Task>();
        List<OutboundEmail__c> emailToBeCreated = new List<OutboundEmail__c>();
        for(StudentProgram__c agreement : agreements){
            if(agreement.DaysDelinquent__c == 12 ||
               agreement.DaysDelinquent__c == 42 ||
               agreement.DaysDelinquent__c == 72 || 
               agreement.DaysDelinquent__c == 102 ||    
               agreement.DaysDelinquent__c == 132 ||    
               agreement.DaysDelinquent__c == 162 ){    
                 tasksToBeCreated.add(delinquencyCall(agreement));
                 
                 OutboundEmail__c delEmail = delinquencyEmail(agreement);
                 if(delEmail != null)
                     emailToBeCreated.add(delEmail);
            }
            
            else if(agreement.DaysDelinquent__c == 27 ||
               agreement.DaysDelinquent__c == 57 ||
               agreement.DaysDelinquent__c == 87 || 
               agreement.DaysDelinquent__c == 117 ||    
               agreement.DaysDelinquent__c == 147 ||
               agreement.DaysDelinquent__c == 177 ||
               agreement.DaysDelinquent__c == 192 ||
               agreement.DaysDelinquent__c == 207 ||
               agreement.DaysDelinquent__c == 222 ||
               agreement.DaysDelinquent__c == 237 ||
               agreement.DaysDelinquent__c == 252){
                 //emailToBeCreated.add(delinquencyEmail(agreement));
                 
                 OutboundEmail__c delEmail = delinquencyEmail(agreement);
                 if(delEmail != null)
                     emailToBeCreated.add(delEmail);
            }
            //if(agreement.DaysDelinquent__c == 12 ||
            //   agreement.DaysDelinquent__c == 27 ||
            //   agreement.DaysDelinquent__c == 42 ||   
            //   agreement.DaysDelinquent__c == 57 ||   
            //   agreement.DaysDelinquent__c == 72 ||   
            //   agreement.DaysDelinquent__c == 87 ||   
            //   agreement.DaysDelinquent__c == 102 ||  
            //   agreement.DaysDelinquent__c == 117 ||
            //   agreement.DaysDelinquent__c == 132 ||  
            //   agreement.DaysDelinquent__c == 147 ||  
            //   agreement.DaysDelinquent__c == 162 ||
            //   agreement.DaysDelinquent__c == 177){
            //  emailToBeCreated.add(delinquencyEmail(agreement));
            //}
            //if(agreement.DaysDelinquent__c == 27 ||
            //   agreement.DaysDelinquent__c == 57 ||
            //   agreement.DaysDelinquent__c == 87 ||   
            //   agreement.DaysDelinquent__c == 117 ||  
            //   agreement.DaysDelinquent__c == 147 ||      
            //   agreement.DaysDelinquent__c == 177 ){
            //  tasksToBeCreated.add(delinquencyText(agreement));
            //}
        }
        if(tasksToBeCreated != null && tasksToBeCreated.size()>0){
            insert tasksToBeCreated;
        }
        if(emailToBeCreated != null && emailToBeCreated.size()>0){
          insert emailToBeCreated;
        }
    }

    private static Task delinquencyCall(StudentProgram__c agreement){
        String owner;
        try{
            owner = String.isNotBlank(KeyValuePair__c.getValues('DelinquencyTaskOwnerID').ValueText__c) ?
                                        KeyValuePair__c.getValues('DelinquencyTaskOwnerID').ValueText__c :
                                        UserInfo.getUserId();
        } catch (Exception e) {
            owner =  UserInfo.getUserId();
        }
        Task newTask = new Task(Type = 'Call',
                          ActivityDate = Date.today(),
                          Subject = 'Delinquency Notification: (' + String.valueOf((Integer)agreement.DaysDelinquent__c) + ' Days)', 
                          WhatID = agreement.Student__c,
                          WhoID = agreement.Student__r.PersonContactID,
                          OwnerID = owner,
                          Description = 'This student is overdue. Please reach out to the student by telephone.');
        System.debug(newTask);
        return newTask;
    }
    private static OutboundEmail__c delinquencyEmail(StudentProgram__c agreement){
        
        EmailTemplate template;
        
        if(agreement.DaysDelinquent__c == 12 || agreement.DaysDelinquent__c == 27)
            template = selectTemplate('Delinquency_Letter_11_Days');
        else if(agreement.DaysDelinquent__c == 42 || agreement.DaysDelinquent__c == 57)
            template = selectTemplate('Delinquency_Letter_30_Days');
        else if(agreement.DaysDelinquent__c == 72 || agreement.DaysDelinquent__c == 87)
            template = selectTemplate('Delinquency_Letter_60_Days');
        else if(agreement.DaysDelinquent__c == 102 || agreement.DaysDelinquent__c == 117)
            template = selectTemplate('Delinquency_Letter_90_Days');
        else if(agreement.DaysDelinquent__c == 132 || agreement.DaysDelinquent__c == 147)
            template = selectTemplate('Delinquency_Letter_120_Days');
        else if(agreement.DaysDelinquent__c == 162 || agreement.DaysDelinquent__c == 177)
            template = selectTemplate('Delinquency_Letter_150_Days');
        else if(agreement.DaysDelinquent__c == 192 || agreement.DaysDelinquent__c == 207)
            template = selectTemplate('Delinquency_Letter_180_Days');
        else if(agreement.DaysDelinquent__c == 222 || agreement.DaysDelinquent__c == 237)
            template = selectTemplate('Delinquency_Letter_210_Days');
        else if(agreement.DaysDelinquent__c == 252)
            template = selectTemplate('Delinquency_Letter_240_Days');
        
        if(template != null){
            return new OutboundEmail__c(ToAddresses__c = agreement.Student__r.PersonEmail,
                                      TemplateID__c = template.id,
                                      WhatID__c = agreement.id,
                                      TargetObjectId__c = agreement.Student__r.PersonContactID,
                                      SendviaSES__c = true);
        }
        else
            return null;
    }
    
    private static EmailTemplate selectTemplate(string templateName){
        try{
            return [Select id from EmailTemplate where developerName =: templateName];            
        } catch (Exception e){
            return null;
        }
    }
    
    //private static Task delinquencyText(StudentProgram__c agreement){
    //  return new Task(Type = 'Other',
    //                        ActivityDate = Date.today(),
    //                        Subject = 'Delinquency Notification: (' + String.valueOf((Integer)agreement.DaysDelinquent__c) + ' Days)', 
    //                    WhatID = agreement.Student__c,
    //                    WhoID = agreement.Student__r.PersonContactID,
    //                    Description = 'This student is overdue. Please reach out to the student by text message.');
    //}
    
    private static void handleAudit(List<StudentProgram__c> agreements){
        List<StudentProgramAudit__c> auditToCreate = new List<StudentProgramAudit__c>();
        List<StudentProgram__c> spList = new List<StudentProgram__c>();
        Set<ID> agreementIDs = new Set<ID>();
        String queryString = 'Select Id,'; 
        
        for(StudentProgram__c agreement:agreements){
            agreementIDs.add(agreement.id);
        }
        
        SObjectType studentProgramAuditDescribe = Schema.getGlobalDescribe().get('StudentProgramAudit__c');
        Map<String,Schema.SObjectField> studProgAudFields = studentProgramAuditDescribe.getDescribe().fields.getMap();
        
        ////generate a dynamic query string to query studentProgram records
        for(String fld : studProgAudFields.keySet()){
            if(fld.endsWith('__c') && fld != 'StudentProgram__c' && fld != 'auditdatetime__c' && fld != 'MonthEnd__c'){
                queryString += fld;
                queryString += ',';    
            }
        }
        queryString = queryString.removeEnd(',');
        queryString += ' From StudentProgram__c Where ID IN ' + DatabaseUtil.inSetStringBuilder(agreementIDs);
        
        spList = Database.query(queryString);
        
        for(StudentProgram__c agreement:spList){
            StudentProgramAudit__c audit = new StudentProgramAudit__c();
            audit.StudentProgram__c = agreement.Id;
            audit.monthEnd__c = true;
            for(String fld : studProgAudFields.keySet()){
                if(fld.endsWith('__c') && fld != 'StudentProgram__c' && fld != 'auditdatetime__c' && fld != 'MonthEnd__c'){
                    audit.put(fld, agreement.get(fld));
                }
            }
            auditToCreate.add(audit);    
        }
        
        if(auditToCreate.size()>0){
            insert auditToCreate;
        } 
        
                       
    }    
}