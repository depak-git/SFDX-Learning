/////////////////////////////////////////////////////////////////////////
// Class: NotificationQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-17   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
public class NotificationQueries {
    public static Map<String, Object> filterCriteria = new Map<String, Object>();
    public static void clearFilterCriteria(){
        filterCriteria.clear();
    }

    public static Map<ID, Notification__c> getNotificationMap(){
        Map<ID, Notification__c> notificationMap = new Map<ID, Notification__c>();
        String query = generateSOQLSelect();
        query += ' WHERE Id != null';
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        notificationMap = new Map<ID, Notification__c>((List<Notification__c>)db.query(query));
        return notificationMap;     
    }

    public static Map<ID, Notification__c> getNotificationByID(Set<Id> notificationIds){
        Map<ID, Notification__c> notificationMap = new Map<ID, Notification__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(notificationIds);
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        notificationMap = new Map<ID, Notification__c>((List<Notification__c>)db.query(query));
        return notificationMap;     
    }

    public static Map<ID, Notification__c> getNotificationByStudentID(Set<Id> studentIds){
        Map<Id, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIds);
        Set<Id> contactIds = new Set<Id>();
        for(Account stud : studentMap.values()){
            contactIds.add(stud.PersonContactID);
        }   
        Map<ID, Notification__c> notificationMap = new Map<ID, Notification__c>();
        String query = generateSOQLSelect();
        query += ' WHERE Contact__c IN ' + DatabaseUtil.inSetStringBuilder(contactIds);
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        notificationMap = new Map<ID, Notification__c>((List<Notification__c>)db.query(query));
        return notificationMap;     
    }

    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }
    
    private static String buildFilterString(){
        String filterStr = '';
        if(filterCriteria.size()>0){
            for(String filter : filterCriteria.keyset()){
                filterStr += ' and ' +filter+'=\''+String.valueOf(filterCriteria.get(filter) +  '\' ');
            }           
        }
        return filterStr;
    }

    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getNotificationFieldNames() + ' FROM Notification__c ';
        return soql;
    }

    private static String getNotificationFieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'Name, ';
        fieldNames += 'Contact__c, ';
        fieldNames += 'HtmlBody__c , ';
        fieldNames += 'PlainText__c, ';
        fieldNames += 'Subject__c, ';
        fieldNames += 'ToEmail__c, ';
        fieldNames += 'Contact__r.account.name, ';
        fieldNames += 'createdDate';
        return fieldNames;
    }
}