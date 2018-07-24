/////////////////////////////////////////////////////////////////////////
// Class: EmailService
// 
// Description: 
// 	Handles all Dynamic emails functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-06-08   Jared Hagemann  Created                     
// 
/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////
//Method : Email Service
//@parameter emails - email address of reciepients
//@parameter objectId -  Id of contact, lead, or user that should associate with the template (required via apex)
//@parameter templateId - Id of email template
//@parameter attachmentIds - Ids of attachment for email
/////////////////////////////////////////
public class EmailService {
	public static void sendEmailWithAttachments(List<String> emails, Id objectId, Id templateId, List<Id> attachmentIds){
		OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName LIKE 'Vemo Customer Service%'];
		List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setOrgWideEmailAddressId(owa.Id);
		mail.setTemplateId(templateId);
		//mail.setBccAddresses(emails); // need to disable BCC compliance
		mail.setToAddresses(emails);
		mail.setTargetObjectId(objectId);
		messages.add(mail);		
		if(attachmentIds != null){
			List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
			for (Attachment a : [select Name, Body, BodyLength from Attachment where Id in: attachmentIds]){
				Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
				efa.setFileName(a.Name);
				efa.setBody(a.Body);
				fileAttachments.add(efa);
			}
			mail.setFileAttachments(fileAttachments);
		}
		List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
		for(Messaging.SendEmailResult result : results){
			if(!result.success){
				System.debug('The email failed to send: ' + result.errors[0].message);
			}
		}

	}
}