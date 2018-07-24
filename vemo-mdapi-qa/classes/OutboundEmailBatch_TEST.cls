@isTest
public class OutboundEmailBatch_TEST {
  @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testStart(){
      
      OutboundEmail__c oEmail = new OutboundEmail__c();
      oEmail.SendviaSES__c = true;
      oEmail.ToAddresses__c = 'test@testing.com';
      oEmail.PlainTextBody__c = 'test';
      oEmail.subject__c = 'subTest';
      insert oEmail;
      
      Test.startTest();
      OutboundEmailBatch oeb = new OutboundEmailBatch();
      Database.executeBatch(oeb, 200);
      Test.stopTest();
    }
}