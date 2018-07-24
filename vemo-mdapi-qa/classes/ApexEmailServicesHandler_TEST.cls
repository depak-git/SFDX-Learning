@isTest
public with sharing class ApexEmailServicesHandler_TEST {
	@isTEst public static void validateInboundEmail() {
        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        // setup the data for the email
        email.subject = 'Test Subject';
        email.fromAddress = 'testemailaddress@email.com';
        email.plainTextBody = 'Test Body\nLine 2\nLine 3';
        email.toAddresses = new List<String>{'test@vemo.com'};

        // add an Binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };



        // add an Text atatchment
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };


        // call the email service class and test it with the data in the testMethod
        ApexEmailServicesHandler  testInbound =new ApexEmailServicesHandler();

        Test.startTest();
        testInbound.handleInboundEmail(email, env);
        Test.stopTest();

        List<Notification__c> results = [SELECT id from Notification__c];
        System.assertEquals(results.size(),1);
 		
	}
}