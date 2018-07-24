/////////////////////////////////////////////////////////////////////////
// Class: NotificationService
// 
// Description: 
// 	Handles all Notification DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-17   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class NotificationService {
	
	public static List<Notification> getNotificationWithNotificationID(Set<ID> notificationIDs){
		System.debug('NotificationService.getNotificationWithNotificationID');
		Map<Id, Notification__c> notiMap = NotificationQueries.getNotificationByID(notificationIDs);
		List<Notification> notiList = new List<Notification>();
		for(Notification__c noti : notiMap.values()){
			notiList.add(new Notification(noti));
		}
		return notiList;
	}

	public static List<Notification> getNotificationWithStudentID(Set<ID> studentIDs){
		System.debug('NotificationService.getNotificationWithNotificationID');
		Map<Id, Notification__c> notiMap = NotificationQueries.getNotificationByStudentID(studentIDs);
		List<Notification> notiList = new List<Notification>();
		for(Notification__c noti : notiMap.values()){
			notiList.add(new Notification(noti));
		}
		return notiList;
	}
	

	public class Notification{
		public String notificationID {get;set;}
		public String contact {get;set;}
		public String htmlBody {get;set;}
		public String plainText {get;set;}
		public String subject {get;set;}
		public String toEmail {get;set;}

		public Notification(){

		}

		public Notification(Boolean testValues){
			if(testValues){
				this.htmlBody = 'Test htmlBody'; 
				this.plainText = 'Test Plain Text'; 
				this.subject = 'Test Subject'; 
			}
		}

		public Notification(Notification__c noti){
			this.notificationID = noti.ID;
			this.contact = noti.Contact__c;	
			this.htmlBody = noti.HtmlBody__c;		
			this.plainText = noti.PlainText__c;
			this.subject = noti.Subject__c;
			this.toEmail = noti.ToEmail__c;
		}
	}
}