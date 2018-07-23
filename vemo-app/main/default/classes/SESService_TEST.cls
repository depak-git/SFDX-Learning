@isTest
public with sharing class SESService_TEST {

    @isTest static void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new SESService_TEST.SESServiceHttpCalloutMock());
        SESService.MailAttachment ma = new SESService.MailAttachment();
        ma.name = 'test';
        ma.body = Blob.valueOf('test');
        ma.contentType = 'test';
        
        SESService.Email e = new SESService.Email();
        e.to = 'test@astreait.com';
        e.bcc = 'test@astreait.com';
        e.cc = 'test@astreait.com';
        e.subject = 'Test';
        e.bodyText = 'Test';
        e.bodyHtml = 'Test';
        e.attachmentList = new List<SESService.MailAttachment>();
        e.attachmentList.add(ma);
        Boolean response = SESService.sendEmail(e);
    }
    
    public class SESServiceHttpCalloutMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setBody('');
            response.setStatusCode(200);
            return response; 
        }
  }
}