public with sharing class OutboundEmailService {
    private static Map<String, EmailTemplate> templatesByDevName;

    public static Set<Id> createOutboundEmailV1(List<OutboundEmail> outboundEmails){
        System.debug('OutboundEmailServcie.createOutboundEmailV1');
        List<OutboundEmail__c> newEmails = new List<OutboundEmail__c>();
        List<String> templateDevNames = new List<String>();
        for(OutboundEmail eml : outboundEmails){
            if(String.isNotBlank(eml.templateDevName)) templateDevNames.add(eml.templateDevName);
        }
        if(templateDevNames.size()>0){
            Map<ID, EmailTemplate> templateMap = new Map<ID, EmailTemplate>([SELECT id,
                                                                                    Name,
                                                                                    DeveloperName
                                                                             FROM EmailTemplate
                                                                             WHERE DeveloperName IN : templateDevNames]);

            templatesByDevName = new Map<String, EmailTemplate>();
            for(EmailTemplate et : templateMap.values()){
                templatesByDevName.put(et.DeveloperName, et);
            }           
        }
        for(OutboundEmail eml : outboundEmails){
            OutboundEmail__c outboundEmail = emailToEmailObj(eml);
            newEmails.add(outboundEmail);
        }
        insert newEmails;
        Set<Id> emailIDs = new Set<Id>();
        for(OutboundEmail__c eml : newEmails){
            emailIDs.add(eml.ID);
        }
        return emailIDs;
    }

    public class OutboundEmail{
        public Boolean sendImmediate {get;set;}
        public ID targetObjectID {get;set;}
        public ID whatID {get;set;}
        public String toAddresses {get;set;}
        public ID templateID {get;set;}
        public String templateDevName {get;set;}
    }

    private static OutboundEmail__c emailToEmailObj(OutboundEmail outboundEmail){
        OutboundEmail__c emailSObj = new OutboundEmail__c();
        emailSObj.Send__c = outboundEmail.sendImmediate;
        emailSObj.TargetObjectId__c = outboundEmail.targetObjectID;
        emailSObj.WhatID__c = outboundEmail.whatID;
        emailSObj.ToAddresses__c = outboundEmail.toAddresses;
        if(String.isBlank(outboundEmail.templateID) && String.isNotBlank(outboundEmail.templateDevName)){
            emailSObj.TemplateID__c = templatesByDevName.get(outboundEmail.templateDevName).id;
        } else {
            emailSObj.TemplateID__c = outboundEmail.templateID;         
        }

        return emailSObj;
    }
    
    public void sendEmail(List<sObject> oEmails){
        List<OutboundEmail__c> outBoundEmails= new List<OutboundEmail__c>();
        List<SESService.Email> sesEmails = new List<SESService.Email>();
        if(oEmails != null && oEmails.size()>0){
            for(OutboundEmail__c oEmail : (List<OutboundEmail__c>) oEmails){
            
                SESService.Email email = sendEmail(oEmail);
                if(email != null ){
                    outBoundEmails.add(oEmail);
                    sesEmails.add(email);
                }    
            }
        }
        if(outBoundEmails != null && outBoundEmails.size()>0)
            completeOutboundEmail(outBoundEmails);
        
        if(sesEmails != null && sesEmails.size()>0)
            saveNotification(sesEmails);   
    }
    
    public SESService.Email sendEmail(OutboundEmail__c oEmail){
    
        string templateId = oEmail.TemplateID__c;
        string whoId = oEmail.TargetObjectId__c;
        string whatId = oEmail.whatid__c;
        
        boolean sendMail;
        boolean emailSent = false;
        
        SESService.Email newEmail = new SESService.Email();
        
        if(templateId != null){
            EmailTemplate template = [select body,HTMLValue,name,TemplateType,subject from EmailTemplate where id =: templateId];
            
            string templateBody = '',templateHtmlBody ='';
            
            if(template != null){
                newEmail.subject = template.subject;
                if(template.TemplateType == 'text'){
                    
                    List<Messaging.RenderEmailTemplateBodyResult> resList =
                           Messaging.renderEmailTemplate(whoId, whatId, new List<String> {template.body}); //whoId, whatId, body
                    
                    if(resList != null && resList.size()>0){
                        newEmail.bodyText  = string.valueOf(resList[0].MergedBody);
                    }
                }
                else{ 
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.id, whoId, whatid); 
                    newEmail.bodyHtml = email.getHTMLBody();  
                }
                
                sendMail = true;
            }
        }
        
        else if((oEmail.PlainTextBody__c !=null || oEmail.HtmlBody__c != null) && oEmail.subject__c != null){
            
            newEmail.subject = oEmail.subject__c;
            newEmail.bodyText = oEmail.PlainTextBody__c;
            newEmail.bodyHtml = oEmail.htmlBody__c; 
            
            sendMail = true;   
        }
        
        if(sendMail == true){
            newEmail.to= oEmail.ToAddresses__c;
            newEmail.cc = oEmail.CcAddresses__c;
            newEmail.bcc = oEmail.BccAddresses__c;
            
            // related attchemnts with outbound Email
            Attachment[] attList = [select id, ContentType, Body,name From Attachment where parentId = :oEmail.Id];
            
            if (attList != null && attList.size()>0) {
                List<SESService.MailAttachment> newEmailAttachmentList = new List<SESService.MailAttachment>();
                
                for(attachment attach : attList){
                    SESService.MailAttachment newEmailAttachment = new SESService.MailAttachment();
                    newEmailAttachment.name = attach.name;
                    newEmailAttachment.body = attach.body;
                    newEmailAttachment.ContentType = attach.ContentType;
                    newEmailAttachmentList.add(newEmailAttachment);
                }
                newEmail.attachmentList = newEmailAttachmentList ;
            }
            
            if(!Test.isRunningTest()){
                emailSent = SESService.sendEmail(newEmail);                
            }
        }
        return emailSent ? newEmail : null; 
    }
    
    private void completeOutboundEmail(List<OutboundEmail__c> oEmailList){
        for(OutboundEmail__c oEmail : oEmailList){
            oEmail.complete__c = true;
        }
        upsert oEmailList;
    }
        
    private void saveNotification(List<SESService.Email> newEmailList){
        
        List<Notification__c> noticeList = new List<Notification__c>();
        List<Task> taskList = new List<Task>();
        
        for(SESService.Email newEmail : newEmailList){
            string toAddresses = newEmail.to;
            List<String> toAddressesList = toAddresses.split(',');
            Set<String> toAddressesSet = new Set<String>(toAddressesList);
            
            Notification__c notice = new Notification__c();
            
            AccountQueries.clearFilterCriteria();
            System.debug('toAddressesSet:'+toAddressesSet);
            
            Map<ID, Account> acctMap = AccountQueries.getStudentMapWithPersonEmails(toAddressesSet);
    
            if(acctMap.size()==1){
                notice.Contact__c = acctMap.values()[0].PersonContactID;            
    
                Task newTask = new Task();
                newTask.ActivityDate = Date.today();
                newTask.Subject = 'Email Sent: '+ newEmail.subject;
                newTask.Status = 'Completed';
                newTask.WhoId = acctMap.values()[0].PersonContactID;
                newTask.WhatID = acctMap.values()[0].id;
                
                if(newEmail.bodyText != null)
                    newTask.Description = newEmail.bodyText;
                else if(newEmail.bodyHtml != null)
                    newTask.Description = newEmail.bodyHtml;
                
                taskList.add(newTask);
            }
            
            notice.ToEmail__c = newEmail.to;
            notice.HTMLBody__c = newEmail.bodyHtml;
            notice.PlainText__c = newEmail.bodyText;
            notice.Subject__c = newEmail.subject;
            noticeList.add(notice);  
        }  
        
        if(noticeList != null && noticeList.size()>0) insert noticeList;
        if(taskList != null && taskList.size()>0) insert taskList;
    }
}