public without sharing class StudentCommunicationsCTRL {

    @AuraEnabled
    public static List<communicationWrapper> getCommunicationEntriesWithSchoolID(string schoolID, String fromDate, string toDate, string studentId){
        
        Date frmDate, tDate;
        
        if(fromDate != null && fromDate != '' && toDate != null && toDate != ''){
            frmDate = date.valueof(fromDate);
            tDate = date.valueof(toDate).addDays(1);            
        }
        else{
            frmDate = date.today().addDays(-30);
            tDate = date.today(); 
        }
        
        if(schoolId == null || schoolId == ''){
            schoolId = findSchooldId();
        }
        
        List<communicationWrapper> communicationWrapperList = new List<communicationWrapper>();
        
        Map<ID, Account> accMap = new Map<ID, Account>();
        if(studentId != null && studentId != 'null' && studentId != ''){
            accMap = new Map<ID, Account>([select id, (SELECT account.name,ActivityDate,what.name, 
                                                       subject,Description, createdDate from ActivityHistories 
                                                       where (createdDate >=: frmDate and createdDate <: tDate 
                                                       AND (NOT Subject Like 'Email Sent%'))), 
                                            name from account where PrimarySchool__pc =: schoolid AND id=:studentId]);
        }
        else{
            accMap = new Map<ID, Account>([select id, (SELECT account.name,ActivityDate,what.name, 
                                                       subject,Description, createdDate from ActivityHistories 
                                                       where (createdDate >=: frmDate and createdDate <: tDate 
                                                       AND (NOT Subject Like 'Email Sent%'))), 
                                           name from account where PrimarySchool__pc =: schoolid]);
        }        
        
        Map<ID, Notification__c> notificationMap = new Map<ID, Notification__c>();
        
        notificationMap = new Map<ID, Notification__c>([select id,ToEmail__c,createdDate,subject__c,Contact__r.account.name 
                                                        from Notification__c where contact__r.account.id IN : accMap.keyset() 
                                                        and createdDate >=: frmDate and createdDate <: tDate]);
        
        if(notificationMap != null && notificationMap.size()>0){
            for(id i : notificationMap.keyset()){
                if(notificationMap.get(i).ToEmail__c != null && !(notificationMap.get(i).ToEmail__c.contains('vemo.com'))){
                    communicationWrapper cWr = new communicationWrapper();
                    if(notificationMap.get(i).subject__c != null)
                        cwr.subject = notificationMap.get(i).subject__c;
                    cwr.recordid = i;
                    cwr.createdDate = notificationMap.get(i).createdDate.date();
                    cwr.student = notificationMap.get(i).Contact__r.account.name;
                    cWr.showOrNot = 'show';
                    cWr.objectName = 'Notification';
                    cWr.frm_Date = frmDate;
                    cWr.to_Date = tDate.addDays(-1);
                    communicationWrapperList.add(cWr);   
                }     
            }
        }
        
        if(accMap != null && accMap.size()>0){
            for(id i: accMap.keyset()){
                for(ActivityHistory aHistory : accMap.get(i).ActivityHistories){
                    communicationWrapper cWr = new communicationWrapper();
                    cWr.subject = aHistory.subject;
                    cWr.createdDate = aHistory.createdDate.date();
                    cWr.student = aHistory.account.name;
                    cwr.recordid = aHistory.id; 
                    cWr.showOrNot = 'show';
                    cWr.objectName = 'Activity';
                    cWr.studentid = i;
                    cWr.frm_Date = frmDate;
                    cWr.to_Date = tDate.addDays(-1);
                    communicationWrapperList.add(cWr); 
                }
            }
        }
        return communicationWrapperList;  
    }
    
    @AuraEnabled
    public static List<Account> searchStudent(string schoolID , string studentName){
        if(schoolId == null || schoolId == ''){
            schoolId = findSchooldId();
        }
        string query = 'select id, name from Account where PrimarySchool__pc =: schoolID AND name like \'%'+studentName+'%\'';
        List<Account> studentList = Database.query(query);
        return studentList;
    }
    
    private static string findSchooldId(){
        List<user> currentUser = [select id,accountId from user where id =:userInfo.getuserId()];
        string schoolId = '';
        if(currentUser != null && currentUser.size()>0 && currentUser[0].accountId != null){
            schoolId = currentUser[0].accountId;
        }
        return schoolId;
    }
    
    public class communicationWrapper{
        @AuraEnabled public string type {get;set;}
        @AuraEnabled public string student {get;set;}
        @AuraEnabled public id studentId {get;set;}
        @AuraEnabled public string showOrNot {get;set;}
        @AuraEnabled public string subject {get;set;}
        @AuraEnabled public date createdDate{get;set;}
        @AuraEnabled public Id recordId {get;set;}
        @AuraEnabled public string objectName {get;set;}
        @AuraEnabled public date frm_Date {get;set;}
        @AuraEnabled public date to_Date {get;set;}
    }
}