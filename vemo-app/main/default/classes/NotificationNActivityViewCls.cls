public without sharing class NotificationNActivityViewCls{
    
    public notification__c notification{get;set;}
    public activityHistory activity{get;set;}

    public NotificationNActivityViewCls(){
        Id id = apexpages.currentpage().getparameters().get('id');
        Id accountd = apexpages.currentpage().getparameters().get('accId');
        string objectName = apexpages.currentpage().getparameters().get('record');
        
        if(objectName == 'Notification'){
            notification = [select id,name,createddate,lastmodifiedDate,createdBy.name,lastModifiedBy.name,
                            owner.name,Contact__c,contact__r.name,HtmlBody__c,PlainText__c,Subject__c,ToEmail__c 
                            from notification__c where Id =: id];    
        }
        else if(objectName == 'Activity'){
            List<account> accList = [select (select id,calltype,subject,activityDate,owner.name,what.name,who.name,
                                             description,priority,status,lastModifiedDate,createddate from activityHistories  
                                             where id =: id) 
                                     from account where id=: accountd];
            if(accList != null && accList.size()>0 && accList[0].activityHistories !=null && accList[0].activityHistories.size()>0)
                activity = accList[0].activityHistories;
            //system.debug(accList);
        }
    }
}