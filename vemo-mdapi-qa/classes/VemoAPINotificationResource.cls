/////////////////////////////////////////////////////////////////////////
// Class: VemoAPINotificationResource
// 
// Description: 
// 	Direction Central for Notification API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-17   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPINotificationResource {
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		/*
		if((api.version == 'v1') && (api.method == 'POST')){
			return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			return handleDeleteV1(api);
		}
		*/	
			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}
	
	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){	
		System.debug('VemoAPINotificationResource.handleGetV1');
		String notificationIDParam = api.params.get('notificationID');
		String studentIDParam = api.params.get('studentID');
		List<NotificationService.Notification> notList = new List<NotificationService.Notification>();
		if(notificationIDParam != null){
			notList = NotificationService.getNotificationWithNotificationID(VemoApi.parseParameterIntoIDSet(notificationIDParam));
		}
		else if(studentIDParam != null){
			notList = NotificationService.getNotificationWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter notificationID or studentID');
		}
		List<NotificationOutputV1> results = new List<NotificationOutputV1>();
		for(NotificationService.Notification noti : notList){
			results.add(new NotificationOutputV1(noti));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));

	}
	

	public class NotificationOutputV1{
		
		public NotificationOutputV1(NotificationService.Notification noti){
			this.notificationID = noti.notificationID;			
			this.contact = noti.contact;
			this.htmlBody = noti.htmlBody;
			this.plainText = noti.plainText;
			this.subject = noti.subject;
			this.toEmail = noti.toEmail;			
		}
		public String notificationID {get;set;}
		public String contact {get;set;}
		public String htmlBody {get;set;}
		public String plainText {get;set;}
		public String subject {get;set;}
		public String toEmail {get;set;}
	}
}