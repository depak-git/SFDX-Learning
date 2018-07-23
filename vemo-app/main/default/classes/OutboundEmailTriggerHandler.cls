/////////////////////////////////////////////////////////////////////////
// Class: OutboundEmailTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class OutboundEmailTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State acctrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution acctrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'OutboundEmailTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'OutboundEmailTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
        System.debug('OutboundEmailTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<OutboundEmail__c> newOutboundEmailList = (List<OutboundEmail__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newOutboundEmailList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
        System.debug('OutboundEmailTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<OutboundEmail__c> newOutboundEmailList = (List<OutboundEmail__c>)tc.newList;
        List<OutboundEmail__c> oldOutboundEmailList = (List<OutboundEmail__c>)tc.oldList;
        Map<ID, OutboundEmail__c> newOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.newMap;
        Map<ID, OutboundEmail__c> oldOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldOutboundEmailMap, newOutboundEmailMap);


    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
        System.debug('OutboundEmailTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<OutboundEmail__c> oldOutboundEmailList = (List<OutboundEmail__c>)tc.oldList;
        Map<ID, OutboundEmail__c> oldOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
        System.debug('OutboundEmailTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<OutboundEmail__c> newOutboundEmailList = (List<OutboundEmail__c>)tc.newList;
        Map<ID, OutboundEmail__c> newOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.newMap;
        //This is where you should call your business logic
        manageSendEmail(null, newOutboundEmailMap);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
        System.debug('OutboundEmailTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<OutboundEmail__c> newOutboundEmailList = (List<OutboundEmail__c>)tc.newList;
        List<OutboundEmail__c> oldOutboundEmailList = (List<OutboundEmail__c>)tc.oldList;
        Map<ID, OutboundEmail__c> newOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.newMap;
        Map<ID, OutboundEmail__c> oldOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.oldMap;
        //This is where you should call your business logic
        manageSendEmail(oldOutboundEmailMap, newOutboundEmailMap);

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
        System.debug('OutboundEmailTriggerHandler.onAfterDelete()');

        List<OutboundEmail__c> oldOutboundEmailList = (List<OutboundEmail__c>)tc.oldList;
        Map<ID, OutboundEmail__c> oldOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
        System.debug('OutboundEmailTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<OutboundEmail__c> newOutboundEmailList = (List<OutboundEmail__c>)tc.newList;
        Map<ID, OutboundEmail__c> newOutboundEmailMap = (Map<ID, OutboundEmail__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<OutboundEmail__c> newOutboundEmailList){
        System.debug('OutboundEmailTriggerHandler.setDefaultsOnInsert()');

        for(OutboundEmail__c email : newOutboundEmailList){
            if(email.SendWhenAttachmentsExist__c == true){
                if(email.ExpectedNumberofAttachements__c == email.CurrentNumberofAttachments__c)
                    email.SendviaSES__c = true;
                else 
                    email.SendviaSES__c = false;
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, OutboundEmail__c> oldOutboundEmailMap, Map<ID, OutboundEmail__c> newOutboundEmailMap){
        System.debug('OutboundEmailTriggerHandler.setDefaultsOnUpdate()'); 
        for(OutboundEmail__c email : newOutboundEmailMap.values()){
            if(email.SendWhenAttachmentsExist__c == true){
                if(email.ExpectedNumberofAttachements__c == email.CurrentNumberofAttachments__c)
                    email.SendviaSES__c = true;
                else 
                    email.SendviaSES__c = false;
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: manageStatements
    /////////////////////////////////////////////////////////////////////////
    private static void manageSendEmail(Map<ID, OutboundEmail__c> oldOutboundEmailMap, Map<ID, OutboundEmail__c> newOutboundEmailMap){
        Set<ID> emailsToSend = new Set<ID>();
        Integer emailCount = 0;
        OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];


        for(OutboundEmail__c email : newOutboundEmailMap.values()){
            if(oldOutboundEmailMap != null && email.Send__c == true && oldOutboundEmailMap.get(email.id).Send__c == false){
                emailsToSend.add(email.id);
            }
            if(oldOutboundEmailMap == null && email.Send__c == true){
                emailsToSend.add(email.id);
            }
        }
        List<Messaging.Email> emails = new List<Messaging.Email>();
        for(ID theID : emailsToSend){
            Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
            
            if(String.isNotBlank(newOutboundEmailMap.get(theID).BccAddresses__c)){
                List<String> bcc = newOutboundEmailMap.get(theID).BccAddresses__c.split(',');
                sem.setBccAddresses(bcc);
                emailCount+=bcc.size();             
            }

            if(String.isNotBlank(newOutboundEmailMap.get(theID).CcAddresses__c)){
                List<String> cc = newOutboundEmailMap.get(theID).CcAddresses__c.split(',');         
                sem.setCCAddresses(cc);
                emailCount+=cc.size();              
            }           


            sem.setCharset(newOutboundEmailMap.get(theID).Charset__c);

            //if(String.isNotBlank(newOutboundEmailMap.get(theID).EntityAttachmentIDs__c)){
            //  List<String> attachments = newOutboundEmailMap.get(theID).EntityAttachmentIDs__c.split(',');
            //  sem.setEntityAttachments(attachments);
            //}

//List<Attachment> attachments = [SELECT Name, Body, ContentType, BodyLength from Attachment where id = '00P7A000003SHWD'];

            //if(String.isNotBlank(newOutboundEmailMap.get(theID).FileAttachments__c)){
            //  List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
            //  Messaging.EmailFileAttachment efa = new MEssaging.EmailFileAttachment();
            //  efa.setFileName('test attachment');
            //  efa.setBody(attachments[0].Body);
            //  efa.setInline(false); //false = attachment, true = inline
            //  efa.setContentType(attachments[0].ContentType);
            //  fileAttachments.add(efa);
            //  sem.setFileAttachments(fileAttachments);
            //}


            sem.setHTMLBody(newOutboundEmailMap.get(theID).HTMLBody__c);
            sem.setInReplyTo(newOutboundEmailMap.get(theID).InReplyToParentMessageIDs__c);
            sem.setOptOutPolicy(newOutboundEmailMap.get(theID).OptOutPolicy__c);
            sem.setPlainTextBody(newOutboundEmailMap.get(theID).PlainTextBody__c);

            if(newOutboundEmailMap.get(theID).SendFromOrgWideEmail__c){
                sem.setOrgWideEmailAddressID(owa.id);               
            } else if(String.isNotBlank(newOutboundEmailMap.get(theID).OrgWideEmailAddressId__c)){
                sem.setOrgWideEmailAddressId(newOutboundEmailMap.get(theID).OrgWideEmailAddressId__c);              
            }

            sem.setReferences(newOutboundEmailMap.get(theID).References__c);
            sem.setSubject(newOutboundEmailMap.get(theID).Subject__c); //Don't send with template

            sem.setTargetObjectId(newOutboundEmailMap.get(theID).TargetObjectId__c); //send with templateID
            sem.setTemplateId(newOutboundEmailMap.get(theID).TemplateID__c);

            if(String.isNotBlank(newOutboundEmailMap.get(theID).ToAddresses__c)){
                List<String> to = newOutboundEmailMap.get(theID).ToAddresses__c.split(',');             
                sem.setToAddresses(to);
                emailCount+=to.size(); 
            }           

            sem.setTreatBodiesAsTemplate(newOutboundEmailMap.get(theID).TreatBodiesAsTemplate__c);
            sem.setTreatTargetObjectAsRecipient(newOutboundEmailMap.get(theID).TreatTargetObjectAsRecipient__c);
            sem.setWhatId(newOutboundEmailMap.get(theID).WhatID__c); //send with templateID


/////////////////////////////////////////////////////////
            //not in object yet

            //EmailTemplate templateId = [Select id from EmailTemplate where name = 'All Schools Adverse Action Credit Not Approved'];
            //sem.setTemplateId(templateId.id);


            sem.setBccSender(false);
            sem.setUseSignature(false);
            //sem.setReplyTo('info@vemo.com');
            //sem.setSenderDisplayName('Vemo Education');
            sem.setSaveAsActivity(false);

System.debug('sem:'+sem);
            emails.add(sem);
        }

        if(emails.size()>0){
            System.debug('emailCount:'+emailCount);
            Messaging.reserveSingleEmailCapacity(emailCount);

            Boolean opt_AllOrNone = true;
            Messaging.SendEmailResult[] semr = Messaging.sendEmail(emails, opt_AllOrNone);
        }
    }

    public class OutboundEmailTriggerHandlerException extends Exception {}
}