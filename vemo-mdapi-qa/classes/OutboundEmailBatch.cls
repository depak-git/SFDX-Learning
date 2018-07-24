global class OutboundEmailBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    String query;
  
    global OutboundEmailBatch() {
        query = 'SELECT id,TemplateID__c,TargetObjectId__c,whatId__c,toaddresses__c,CcAddresses__c,bccAddresses__c,PlainTextBody__c,HtmlBody__c,Subject__c from OutboundEmail__c where SendviaSES__c = true AND Complete__c = false';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        OutboundEmailService oService = new OutboundEmailService();
        oService.sendEmail(scope);
    }
  
    global void finish(Database.BatchableContext BC) {
    }
}