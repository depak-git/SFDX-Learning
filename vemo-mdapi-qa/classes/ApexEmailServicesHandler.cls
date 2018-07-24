global class ApexEmailServicesHandler implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        System.debug('ApexEmailServicesHandler.handleInboundEmail()');
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        String myErr;
//        List<Log__c> logs = new List<Log__c>();*/
        Set<String> toAddressesSet = new Set<String>();
        toAddressesSet.addAll(email.toAddresses);

        try{
        	
        	ApexEmailServicesHandler.captureNotification(email, envelope, toAddressesSet);
			//throw new ApexEmailServicesHandlerException('Inbound Email Had No Associated Service');                

        } catch (Exception e){
            if (email.plainTextBody != null){
                myErr = 'plainTextBody=' + email.plainTextBody;
            } else {
                myErr = 'htmlBody=' + email.htmlBody;
            }            
//            logs.add(new Log__c(Message__c=e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nmyErr=' + myErr));
//            insert logs;
            
            result.success = false;         
            result.message = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nmyErr=' + myErr + '\n\nemail=' + String.valueOf(email);
            return result;
        }
        return result;
    }

    private static void captureNotification(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope, Set<String>toAddressesSet){
    	Notification__c notice = new Notification__c();
    	Contact cont = new Contact();

    	AccountQueries.clearFilterCriteria();
    	System.debug('toAddressesSet:'+toAddressesSet);
    	Map<ID, Account> acctMap = AccountQueries.getStudentMapWithPersonEmails(toAddressesSet);
    	System.debug('acctMap:'+acctMap);



    	if(acctMap.size()==1){
    		notice.Contact__c = acctMap.values()[0].PersonContactID;    		

    		Task newTask = new Task();
    		newTask.ActivityDate = Date.today();
    		newTask.Subject = 'Email Sent: '+ email.subject;
    		newTask.Status = 'Completed';
    		newTask.WhoId = acctMap.values()[0].PersonContactID;
    		newTask.WhatID = acctMap.values()[0].id;
    		newTask.Description = email.plainTextBody;
    		insert newTask;
    	}

    	notice.ToEmail__c = String.valueOf(toAddressesSet);
    	notice.HTMLBody__c = email.htmlBody;
    	notice.PlainText__c = email.plainTextBody;
    	notice.Subject__c = email.subject;

    	insert notice;



    }
    public class ApexEmailServicesHandlerException extends Exception {}
}