/////////////////////////////////////////////////////////////////////////
// Class: AttachmentTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-2016   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class AttachmentTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State Control Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution Control - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.TriggerContext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'AttachmentTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.TriggerContext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'AttachmentTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'AttachmentTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'AttachmentTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.TriggerContext tc){
system.debug('AttachmentTriggerHandler.onBeforeInsert()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Attachment> newAttachmentList = (List<Attachment>)tc.newList;
        //This is where you should call your business logic


    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.TriggerContext tc){
system.debug('AttachmentTriggerHandler.onBeforeUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Attachment> newAttachmentList = (List<Attachment>)tc.newList;
        List<Attachment> oldAttachmentList = (List<Attachment>)tc.oldList;
        Map<ID, Attachment> newAttachmentMap = (Map<ID, Attachment>)tc.newMap;
        Map<ID, Attachment> oldAttachmentMap = (Map<ID, Attachment>)tc.oldMap;
        //This is where you should call your business logic
 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.TriggerContext tc){
system.debug('AttachmentTriggerHandler.onBeforeDelete()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Attachment> oldAttachmentList = (List<Attachment>)tc.oldList;
        Map<ID, Attachment> oldAttachmentMap = (Map<ID, Attachment>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.TriggerContext tc){
system.debug('AttachmentTriggerHandler.onAfterInsert()');
         //Recast the trigger context variables into the appropriate shandlerect types
        List<Attachment> newAttachmentList = (List<Attachment>)tc.newList;
        Map<ID, Attachment> newAttachmentMap = (Map<ID, Attachment>)tc.newMap;
        //This is where you should call your business logic
        setDefaultsOnInsert(newAttachmentList);
        Map<String, Map<ID, Attachment>> attachmentsByObjectType = determineObjectType(newAttachmentMap);

        for(String objectType : attachmentsByObjectType.keyset()){
            if(objectType == 'StudentProgram__c') handleStudentProgramAttachments(null, newAttachmentMap);
            else if(objectType == 'GenericDocument__c') handleGenericDocumentAttachments(null, newAttachmentMap);
            else if(objectType == 'OutboundEmail__c') handleOutbountEmailAttachments(null, newAttachmentMap);
            
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.TriggerContext tc){
system.debug('AttachmentTriggerHandler.onAfterUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Attachment> newAttachmentList = (List<Attachment>)tc.newList;
        List<Attachment> oldAttachmentList = (List<Attachment>)tc.oldList;
        Map<ID, Attachment> newAttachmentMap = (Map<ID, Attachment>)tc.newMap;
        Map<ID, Attachment> oldAttachmentMap = (Map<ID, Attachment>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldAttachmentMap, newAttachmentMap);
        
        Map<String, Map<ID, Attachment>> attachmentsByObjectType = determineObjectType(newAttachmentMap);
        
        for(String objectType : attachmentsByObjectType.keyset()){
            if(objectType == 'StudentProgram__c') handleStudentProgramAttachments(oldAttachmentMap, newAttachmentMap);
            else if(objectType == 'GenericDocument__c') handleGenericDocumentAttachments(null, newAttachmentMap);
        }
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.TriggerContext tc){
system.debug('AttachmentTriggerHandler.onAfterDelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Attachment> oldAttachmentList = (List<Attachment>)tc.oldList;
        Map<ID, Attachment> oldAttachmentMap = (Map<ID, Attachment>)tc.oldMap;
        //This is where you should call your business logic
        
        Map<String, Map<ID, Attachment>> attachmentsByObjectType = determineObjectType(oldAttachmentMap);

        for(String objectType : attachmentsByObjectType.keyset()){
            if(objectType == 'OutboundEmail__c') handleOutbountEmailAttachments(oldAttachmentMap, null);
        }
     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.TriggerContext tc){
system.debug('AttachmentTriggerHandler.onAfterUndelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Attachment> newAttachmentList = (List<Attachment>)tc.newList;
        Map<ID, Attachment> newAttachmentMap = (Map<ID, Attachment>)tc.newMap;
        //This is where you should call your business logic
        
        Map<String, Map<ID, Attachment>> attachmentsByObjectType = determineObjectType(newAttachmentMap);

        for(String objectType : attachmentsByObjectType.keyset()){
            if(objectType == 'OutboundEmail__c') handleOutbountEmailAttachments(null, newAttachmentMap);
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Attachment> newAttachmentList){
system.debug('AttachmentTriggerHandler.setDefaultsOnInsert()');
        for(Attachment acct : newAttachmentList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Attachment> oldAttachmentMap, Map<ID, Attachment> newAttachmentMap){
system.debug('AttachmentTriggerHandler.setDefaultsOnUpdate()'); 
        for(Attachment acct : newAttachmentMap.values()){

        }
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Method: handleStudentProgramAttachments
    /////////////////////////////////////////////////////////////////////////
    private void handleStudentProgramAttachments(Map<ID, Attachment> oldAttachmentMap, Map<ID, Attachment> newAttachmentMap){
        System.debug('AttachmentTriggerHandler.handleStudentProgramAttachments()'); 
        
        //to do - not bulkified
        List<StudentProgram__c> agreementsToUpdate = new List<StudentProgram__c>();
        Set<ID> attachParentIDs = new Set<ID>();
        for(Attachment attach: newAttachmentMap.values()){
            attachParentIDs.add(attach.ParentID);
        }

        Map<ID, StudentProgram__c> agreementMap = new Map<ID, StudentProgram__c>([SELECT id, AdobeSignStatus__c,
                                                                                            CongaUnsignedAgreementID__c, 
                                                                                            SignedAgreementID__c, 
                                                                                            FinalDisclosureID__c
                                                                                    FROM StudentProgram__c
                                                                                    WHERE id = :attachParentIDs limit 1]);
        Map<ID, List<StudentProgram__c>> agreementsByAttachID = new Map<ID, List<StudentProgram__c>>();
        for(Attachment attach : newAttachmentMap.values()){
            if(!agreementsByAttachID.containsKey(attach.id)){
                agreementsByAttachID.put(attach.id, new List<StudentProgram__c>());
            }
            agreementsByAttachID.get(attach.id).add(agreementMap.get(attach.ParentID));
        }
        system.debug(agreementsByAttachID);

        //This currently will only support one attachment per agreement - the algorithm will fail if there are multipel agreements for the same
        //agreement in the same trigger scope
        for(Attachment attach : newAttachmentMap.values()){
            system.debug(attach.Name);

//          String unsignedKey = 'unsigned-agreement-'+String.valueOf(attach.ParentID).subString(0,15)+'.pdf';
            String unsignedKey = AgreementService.unsignedAgreementFileName(attach.ParentID)+'.pdf';
            system.debug(unsignedKey);

//            String signedKey = 'signed-agreement-'+String.valueOf(attach.ParentID).subString(0,15)+'.pdf';
            String signedKey = AgreementService.signedAgreementFileName(attach.ParentID)+'.pdf';
            system.debug(signedKey);           

            //String finalDisKey = 'final-disclosure-'+String.valueOf(attach.ParentID).subString(0,15)+'.pdf';
            String finalDisKey = AgreementService.finalDisclosureFileName(attach.ParentID)+'.pdf';
            system.debug(finalDisKey);             

            if(attach.Name == unsignedKey){
                StudentProgram__c agreement = new StudentProgram__c();
                agreement.id = agreementsByAttachID.get(attach.id)[0].id;
//decoupleasync             agreement.AdobeSignStatus__c = 'Begin Signing Process';
//decoupleasync             agreement.CongaUnsignedAgreementID__c = attach.id;
                agreement.GenerateAgreement__c = false;
                //try asynch
                AgreementService.UpdateAgreementAsync job = new AgreementService.UpdateAgreementAsync();
                job.congaAgreementStatus = 'Generated';
                job.generateAgreement = 'false';
                job.Agreement = agreement;
                system.debug('enqueueJob: UpdateAgreementAsync:'+job);
                system.enqueueJob(job);
                //agreementsToUpdate.add(agreement);
            
            }
            if(attach.Name == signedKey){
                StudentProgram__c agreement = new StudentProgram__c();
                agreement.id = agreementsByAttachID.get(attach.id)[0].id;
                agreement.AdobeSignStatus__c = 'Signed Document Attached';
                agreement.SignedAgreementID__c = attach.id;
                agreement.AgreementSigned__c = true;
                agreement.Status__c = 'Application Complete';
                //try asynch

                AgreementService.UpdateAgreementAsync job = new AgreementService.UpdateAgreementAsync();
                job.Agreement = agreement;
                job.agreementStatus = agreement.Status__c;
                system.debug('enqueueJob: UpdateAgreementAsync'+job);
                system.enqueueJob(job);
                //agreementsToUpdate.add(agreement);
               
            }
            if(attach.Name == finalDisKey){

                StudentProgram__c agreement = new StudentProgram__c();
                agreement.id = agreementsByAttachID.get(attach.id)[0].id;
                agreement.FinalDisclosureID__c = attach.id;
                //agreement.GenerateFinalDisclosure__c = false;
                //agreement.CongaFinalDisclosureStatus__c = 'Generated';
                system.debug(agreement);
                //try asynch
                AgreementService.UpdateAgreementAsync job = new AgreementService.UpdateAgreementAsync();
                job.congaFinalDisclosureStatus = 'Generated';
                job.generateFinalDisclosure = 'false';
                job.Agreement = agreement;
                system.debug('enqueueJob: UpdateAgreementAsync'+job);
                system.enqueueJob(job);
                //agreementsToUpdate.add(agreement);
               
            }
        }
        if(agreementsToUpdate.size()>0){
            //try asynch
            //update agreementsToUpdate;
        }
    }  

    /////////////////////////////////////////////////////////////////////////
    //Method: handleGenericDocumentAttachments
    /////////////////////////////////////////////////////////////////////////
    private void handleGenericDocumentAttachments(Map<ID, Attachment> oldAttachmentMap, Map<ID, Attachment> newAttachmentMap){
        System.debug('AttachmentTriggerHandler.handleGenericDocumentAttachments()'); 
        
        List<GenericDocument__c> documentsToUpdate = new List<GenericDocument__c>();
        Set<ID> attachParentIDs = new Set<ID>();
        for(Attachment attach: newAttachmentMap.values()){
            attachParentIDs.add(attach.ParentID);
        }

        Map<ID, GenericDocument__c> agreementMap = new Map<ID, GenericDocument__c>([SELECT id, AttachmentID__c, AttachmentName__c, Status__c
                                                                                    FROM GenericDocument__c
                                                                                    WHERE id = :attachParentIDs limit 1]);
        Map<ID, List<GenericDocument__c>> docsByAttachID = new Map<ID, List<GenericDocument__c>>();
        for(Attachment attach : newAttachmentMap.values()){
            if(!docsByAttachID.containsKey(attach.id)){
                docsByAttachID.put(attach.id, new List<GenericDocument__c>());
            }
            docsByAttachID.get(attach.id).add(agreementMap.get(attach.ParentID));
        }
        system.debug(docsByAttachID);

        //This currently will only support one attachment per agreement - the algorithm will fail if there are multipel agreements for the same
        //agreement in the same trigger scope
        List<GenericDocument__c> docListToUpdate = new List<GenericDocument__c>();
        for(Attachment attach : newAttachmentMap.values()){
            system.debug(attach);
            GenericDocument__c document = new GenericDocument__c();
            document.AttachmentID__c = ((String)(attach.id)).subString(0,15);
            document.AttachmentName__c = attach.Name;
            document.id = docsByAttachID.get(attach.id)[0].id;
            document.Status__c = 'Uploaded';
            docListToUpdate.add(document);
        }
        if(docListToUpdate.size()>0){
            update docListToUpdate;
        }
    }
    
    private void handleOutbountEmailAttachments(Map<ID, Attachment> oldAttachmentMap, Map<ID, Attachment> newAttachmentMap){
        Set<ID> attachParentIDs = new Set<ID>();
        List<OutboundEmail__c> oEmailtoUpsert = new List<OutboundEmail__c>();
        
        Map<id,List<Attachment>> oEmailIdNAttachmentListMap = new Map<id,List<Attachment>>();
        Map<id,List<Attachment>> oEmailIdNDelAttachmentListMap = new Map<id,List<Attachment>>();
        
        if(newAttachmentMap != null){
            for(Attachment attach: newAttachmentMap.values()){
                
                if(!oEmailIdNAttachmentListMap.containsKey(attach.ParentID)){
                    oEmailIdNAttachmentListMap.put(attach.ParentID, new List<attachment>());
                }
                oEmailIdNAttachmentListMap.get(attach.ParentID).add(attach);     
                attachParentIDs.add(attach.ParentID);
            }
        }
        
        if(oldAttachmentMap != null){
            for(Attachment attach: oldAttachmentMap.values()){
                if(!oEmailIdNDelAttachmentListMap.containsKey(attach.ParentID)){
                    oEmailIdNDelAttachmentListMap.put(attach.ParentID, new List<attachment>());
                }
                oEmailIdNDelAttachmentListMap.get(attach.ParentID).add(attach);     
                attachParentIDs.add(attach.ParentID);
            }
        } 
        
        Integer noOfAtts = 0;
        for(OutboundEmail__c oEmail : [select id,CurrentNumberofAttachments__c  from OutboundEmail__c where id IN: attachParentIDs]){
            noOfAtts = 0;
            if(oEmailIdNAttachmentListMap.containsKey(oEmail.Id)) {
                noOfAtts += oEmailIdNAttachmentListMap.get(oEmail.Id).size();
            }
            if(oEmailIdNDelAttachmentListMap.containsKey(oEmail.Id)) {
                noOfAtts -= oEmailIdNDelAttachmentListMap.get(oEmail.Id).size();
            }
            oEmail.CurrentNumberofAttachments__c = oEmail.CurrentNumberofAttachments__c == null ? noOfAtts : (oEmail.CurrentNumberofAttachments__c + noOfAtts);
            
            oEmailtoUpsert.add(oEmail);
        } 
        
        if(oEmailtoUpsert != null && oEmailtoUpsert.size()>0)
            upsert oEmailtoUpsert;                                                                             
    }
    
    /////////////////////////////////////////////////////////////////////////
    //Method: determineObjectType
    /////////////////////////////////////////////////////////////////////////
    private Map<String, Map<ID, Attachment>> determineObjectType(Map<ID, Attachment> newAttachmentMap){
        Map<String, Map<ID, Attachment>> attachmentByObjectType = new Map<String, Map<ID, Attachment>>();
        for(Attachment attach : newAttachmentMap.values()){
            String objectType = String.valueOf(attach.ParentId.getSobjectType());
            if(!attachmentByObjectType.containsKey(objectType)) {
                attachmentByObjectType.put(objectType, new Map<ID, Attachment>());
            }
            attachmentByObjectType.get(objectType).put(attach.id, attach);
        }
        system.debug('attachmentByObjectType:'+attachmentByObjectType);
        return attachmentByObjectType;
    }
    public class AttachmentTriggerHandlerException extends Exception {}
}