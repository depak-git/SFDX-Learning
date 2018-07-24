/////////////////////////////////////////////////////////////////////////
// Class: ContactTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-22   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class ContactTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State Control Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
//    public static Boolean manageCasesHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution Control - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.TriggerContext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'ContactTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.TriggerContext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'ContactTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'ContactTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'ContactTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.TriggerContext tc){
system.debug('ContactTriggerHandler.onBeforeInsert()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Contact> newContactList = (List<Contact>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newContactList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.TriggerContext tc){
system.debug('ContactTriggerHandler.onBeforeUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Contact> newContactList = (List<Contact>)tc.newList;
        List<Contact> oldContactList = (List<Contact>)tc.oldList;
        Map<ID, Contact> newContactMap = (Map<ID, Contact>)tc.newMap;
        Map<ID, Contact> oldContactMap = (Map<ID, Contact>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldContactMap, newContactMap);

        //setPendingFields(oldContactMap, newContactMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.TriggerContext tc){
system.debug('ContactTriggerHandler.onBeforeDelete()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<Contact> oldContactList = (List<Contact>)tc.oldList;
        Map<ID, Contact> oldContactMap = (Map<ID, Contact>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.TriggerContext tc){
system.debug('ContactTriggerHandler.onAfterInsert()');
         //Recast the trigger context variables into the appropriate shandlerect types
        List<Contact> newContactList = (List<Contact>)tc.newList;
        Map<ID, Contact> newContactMap = (Map<ID, Contact>)tc.newMap;
        //This is where you should call your business logic
		setDefaultsOnInsert(newContactList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.TriggerContext tc){
system.debug('ContactTriggerHandler.onAfterUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Contact> newContactList = (List<Contact>)tc.newList;
        List<Contact> oldContactList = (List<Contact>)tc.oldList;
        Map<ID, Contact> newContactMap = (Map<ID, Contact>)tc.newMap;
        Map<ID, Contact> oldContactMap = (Map<ID, Contact>)tc.oldMap;
        //This is where you should call your business logic
		setDefaultsOnUpdate(oldContactMap, newContactMap);
//        manageCases(oldContactMap, newContactMap);
//		createUsersForContacts(oldContactMap, newContactMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.TriggerContext tc){
system.debug('ContactTriggerHandler.onAfterDelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Contact> oldContactList = (List<Contact>)tc.oldList;
        Map<ID, Contact> oldContactMap = (Map<ID, Contact>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.TriggerContext tc){
system.debug('ContactTriggerHandler.onAfterUndelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<Contact> newContactList = (List<Contact>)tc.newList;
        Map<ID, Contact> newContactMap = (Map<ID, Contact>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<Contact> newContactList){
system.debug('ContactTriggerHandler.setDefaultsOnInsert()');
        for(Contact cont : newContactList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, Contact> oldContactMap, Map<ID, Contact> newContactMap){
system.debug('ContactTriggerHandler.setDefaultsOnUpdate()'); 
        for(Contact cont : newContactMap.values()){

        }
    }

/*    /////////////////////////////////////////////////////////////////////////
    //Method: manageCases
    /////////////////////////////////////////////////////////////////////////
    private void manageCases(Map<ID, Contact> oldContactMap, Map<ID, Contact> newContactMap){
        System.debug('ContactTriggerHandler.manageCases()'); 
        List<Case> casesToAdd = new List<Case>();
        if(!manageCasesHasRun){
            System.debug('manageCasesHasRun is false');
            for(Contact cont : newContactMap.values()){
                if(cont.RecordStatus__c == 'Pending Approval' && oldContactMap.get(cont.id).RecordStatus__c != 'Pending Approval'){
                    casesToAdd.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                                            ContactID = cont.ID,
                                            Subject = cont.FirstName + ' ' + cont.LastName + ' ' + ' Contact Requires Approval',
                                            Status = 'Contact Change Requires Approval',
                                            Priority = 'Medium',
                                            Reason = 'Other',
                                            OwnerId=GlobalUtil.getQueueId('Servicing'),
                                            Type = 'Restricted Data Change',                                    
                                            Origin = 'Other'));

                }

            }
            if(casesToAdd.size()>0){
                insert casesToAdd;
            }
            manageCasesHasRun = true;
        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: setPendingFields
    /////////////////////////////////////////////////////////////////////////
    private void setPendingFields(Map<ID, Contact> oldContactMap, Map<ID, Contact> newContactMap){
system.debug('ContactTriggerHandler.setPendingFields()'); 
        for(Contact cont : newContactMap.values()){
            if(cont.RecordStatus__c == 'Approved' && oldContactMap.get(cont.id).RecordStatus__c != 'Approved'){
                if(!String.isEmpty(cont.PendingFirstName__c)){
                    cont.FirstName = cont.PendingFirstName__c;
                    cont.PendingFirstName__c = '';
                } 
                if(!String.isEmpty(cont.PendingLastName__c)){
                    cont.LastName = cont.PendingLastName__c;
                    cont.PendingLastName__c = '';
                } 
                if(!String.isEmpty(cont.PendingMiddleName__c)){
                    cont.MiddleName = cont.PendingMiddleName__c;
                    cont.PendingMiddleName__c = '';
                } 
                if(!String.isEmpty(cont.PendingMailingStreet__c)){
                    cont.MailingStreet = cont.PendingMailingStreet__c;
                    cont.PendingMailingStreet__c = '';
                } 
                if(!String.isEmpty(cont.PendingMailingCity__c)){
                    cont.MailingCity = cont.PendingMailingCity__c;
                    cont.PendingMailingCity__c = '';
                } 
                if(!String.isEmpty(cont.PendingMailingStateCode__c)){
                    cont.MailingState = cont.PendingMailingStateCode__c; 
                    cont.PendingMailingStateCode__c = '';
                } 
                if(!String.isEmpty(cont.PendingMailingState__c)){
                    cont.MailingState = cont.PendingMailingState__c; 
                    cont.PendingMailingState__c = '';
                }  
                if(!String.isEmpty(cont.PendingMailingPostalCode__c)){
                    cont.MailingPostalCode = cont.PendingMailingPostalCode__c;
                    cont.PendingMailingPostalCode__c = '';
                }                                                                 
                if(!String.isEmpty(cont.PendingMailingCountry__c)){
                    cont.MailingCountry = cont.PendingMailingCountry__c;
                    cont.PendingMailingCountry__c = '';
                } 
                if(!String.isEmpty(cont.PendingEmail__c)){
                    cont.Email = cont.PendingEmail__c;
                    cont.PendingEmail__c = '';
                } 
                if(!String.isEmpty(cont.PendingDriversLicenseOrStateID__c)){
                    cont.DriversLicenseOrStateID__c = cont.PendingDriversLicenseOrStateID__c;
                    cont.PendingDriversLicenseOrStateID__c = ''; 
                }                
/*                if(!String.isEmpty(cont.PendingResidency__c)){
                    cont.Residency__c = cont.PendingResidency__c;
                    cont.PendingResidency__c = '';  
                } *//*
                if(cont.PendingBirthdate__c != null){
                    cont.Birthdate = cont.PendingBirthdate__c;
                    cont.PendingBirthdate__c = null;  
                } 
            } else {
system.debug('***cont:'+cont);
                if(!cont.BypassApproval__c){
                    if(cont.FirstName != oldContactMap.get(cont.id).FirstName && String.isNotEmpty(oldContactMap.get(cont.id).FirstName)){
                        cont.PendingFirstName__c = cont.FirstName;
                        cont.FirstName = oldContactMap.get(cont.id).FirstName;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.LastName != oldContactMap.get(cont.id).LastName && String.isNotEmpty(oldContactMap.get(cont.id).LastName)){
                        cont.PendingLastName__c = cont.LastName;
                        cont.LastName = oldContactMap.get(cont.id).LastName;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MiddleName != oldContactMap.get(cont.id).MiddleName && String.isNotEmpty(oldContactMap.get(cont.id).MiddleName)){
                        cont.PendingMiddleName__c = cont.MiddleName;
                        cont.MiddleName = oldContactMap.get(cont.id).MiddleName;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MailingStreet != oldContactMap.get(cont.id).MailingStreet && String.isNotEmpty(oldContactMap.get(cont.id).MailingStreet)){
                        cont.PendingMailingStreet__c = cont.MailingStreet;
                        cont.MailingStreet = oldContactMap.get(cont.id).MailingStreet;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MailingCity != oldContactMap.get(cont.id).MailingCity && String.isNotEmpty(oldContactMap.get(cont.id).MailingCity)){
                        cont.PendingMailingCity__c = cont.MailingCity;
                        cont.MailingCity = oldContactMap.get(cont.id).MailingCity;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MailingStateCode != oldContactMap.get(cont.id).MailingStateCode && String.isNotEmpty(oldContactMap.get(cont.id).MailingStateCode)){
                        cont.PendingMailingStateCode__c = cont.MailingStateCode;
                        cont.PendingMailingState__c = GlobalUtil.getStateLabelByValue(cont.MailingStateCode);
                        cont.MailingStateCode = oldContactMap.get(cont.id).MailingStateCode;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MailingState != oldContactMap.get(cont.id).MailingState && String.isNotEmpty(oldContactMap.get(cont.id).MailingState)){
                        cont.PendingMailingState__c = cont.MailingState;
                        cont.MailingState = oldContactMap.get(cont.id).MailingState;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MailingPostalCode != oldContactMap.get(cont.id).MailingPostalCode && String.isNotEmpty(oldContactMap.get(cont.id).MailingPostalCode)){
                        cont.PendingMailingPostalCode__c = cont.MailingPostalCode;
                        cont.MailingPostalCode = oldContactMap.get(cont.id).MailingPostalCode;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MailingCountryCode != oldContactMap.get(cont.id).MailingCountryCode && String.isNotEmpty(oldContactMap.get(cont.id).MailingCountryCode)){
                        cont.PendingMailingCountryCode__c = cont.MailingCountryCode;
                        cont.PendingMailingCountry__c = GlobalUtil.getStateLabelByValue(cont.MailingCountryCode);
                        cont.MailingCountryCode = oldContactMap.get(cont.id).MailingCountryCode;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.MailingCountry != oldContactMap.get(cont.id).MailingCountry && String.isNotEmpty(oldContactMap.get(cont.id).MailingCountry)){
                        cont.PendingMailingCountry__c = cont.MailingCountry;
                        cont.MailingCountry = oldContactMap.get(cont.id).MailingCountry;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.Email != oldContactMap.get(cont.id).Email && String.isNotEmpty(oldContactMap.get(cont.id).Email)){
                        cont.PendingEmail__c = cont.Email;
                        cont.Email = oldContactMap.get(cont.id).Email;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.DriversLicenseOrStateID__c != oldContactMap.get(cont.id).DriversLicenseOrStateID__c && String.isNotEmpty(oldContactMap.get(cont.id).DriversLicenseOrStateID__c)){
                        cont.PendingDriversLicenseOrStateID__c = cont.DriversLicenseOrStateID__c;
                        cont.DriversLicenseOrStateID__c = oldContactMap.get(cont.id).DriversLicenseOrStateID__c;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.Residency__c != oldContactMap.get(cont.id).Residency__c && String.isNotEmpty(oldContactMap.get(cont.id).Residency__c)){
                        cont.PendingResidency__c = cont.Residency__c;
                        cont.Residency__c = oldContactMap.get(cont.id).Residency__c;
                        cont.RecordStatus__c = 'Pending Approval';
                    }
                    if(cont.Birthdate != oldContactMap.get(cont.id).Birthdate && oldContactMap.get(cont.id).Birthdate != null){
                        cont.PendingBirthdate__c = cont.Birthdate;
                        cont.Birthdate = oldContactMap.get(cont.id).Birthdate;
                        cont.RecordStatus__c = 'Pending Approval';
                    }

                }
            }
            cont.BypassApproval__c = false;
        }
    }

/*
    /////////////////////////////////////////////////////////////////////////
    //Method: createUsersForContacts
    /////////////////////////////////////////////////////////////////////////
    private void createUsersForContacts(Map<ID, Contact> oldContactMap, Map<ID, Contact> newContactMap){
system.debug('ContactTriggerHandler.createUsersForContacts()'); 
        List<Contact> usersToCreate = new List<Contact>();

        for(Contact cont : newContactMap.values()){
        	if((cont.CommunityStatus__c != oldContactMap.get(cont.id).CommunityStatus__c) && 
        		(cont.CommunityStatus__c == 'Enroll')){
        		usersToCreate.add(cont);
        	}
        }
        if(usersToCreate.size()>0){
            ContactTriggerHandler.AsyncCreateUsers acu = new ContactTriggerHandler.AsyncCreateUsers();
            acu.contactsNeedingCreation = usersToCreate;
            System.enqueueJob(acu);            
        }
    }

    public class AsyncCreateUsers implements Queueable {
    	List<Contact> contactsNeedingCreation {get;set;}
    	public void execute(QueueableContext context){
system.debug('ContactTriggerHandler.AsyncCreateUsers.execute()'); 
system.debug('contactsNeedingCreation:'+contactsNeedingCreation);
	        Profile communityPlusProf = [Select id, Name from Profile where Name = '8.0 - College Admin Default' LIMIT 1];
system.debug('communityPlusProf:'+communityPlusProf);
	        PermissionSet defaultCollegePS = [Select id, Name, Label from PermissionSet where Label = '8.0 - School Administrator' LIMIT 1];
system.debug('defaultCollegePS:'+defaultCollegePS);

	        List<User> usersToCreate = new List<User>();

    		if (contactsNeedingCreation != null){
		        for(Contact cont : contactsNeedingCreation){
	        		/*if(cont.isPersonAccount){
	        			//Student
	        			usersToCreate.add(new User(ContactID = cont.id,
						   Email = 'greg@cloudpremise.com',
						   FirstName = 'Greg',
						   LastName = 'Cook',
						   isActive = true,
						   ProfileId = communityLoginProf.id, 
						   Alias = 'gcook123',
						   Username = 'student12345@vemo.edu.dev1',
						   CommunityNickname = 'student12345', //must me unique!!
						   LocaleSidKey = 'en_US',
						   TimeZoneSidKey = 'GMT',
						   LanguageLocaleKey = 'en_US',
						   EmailEncodingKey = 'UTF-8'));
	    			} else { */
	    				//College Admin /*
	        	/*		usersToCreate.add(new User(ContactID = cont.id,
	        									   Email = 'greg@cloudpremise.com',
	        									   FirstName = 'Greg',
	        									   LastName = 'Cook',
	        									   isActive = true,
	        									   ProfileId = communityPlusProf.id, 
	        									   Alias = 'gcook123',
	        									   Username = 'gcook12345@vemo.edu.dev1',
	        									   CommunityNickname = 'gcook1234', //must me unique!!
	        									   LocaleSidKey = 'en_US',
	        									   TimeZoneSidKey = 'GMT',
	        									   LanguageLocaleKey = 'en_US',
	        									   EmailEncodingKey = 'UTF-8'));
	        		/*	contsToUpdate.add(new Contact(id = cont.id,
	        										  CommunityStatus__c = 'Enrolled'));*/
		        	//} 
		    /*	}
		    }
		    if (usersToCreate.size()>0){
                system.debug('usersToCreate:'+usersToCreate);
		    	insert usersToCreate;
		    }
			ContactTriggerHandler.AsyncAssignDefaultPermissions aadp = new ContactTriggerHandler.AsyncAssignDefaultPermissions();
		    aadp.usersToAssign = usersToCreate;
		    System.enqueueJob(aadp);

    	}
    }   
    public class AsyncAssignDefaultPermissions implements Queueable {
    	List<User> usersToAssign {get;set;}
    	public void execute(QueueableContext context){
system.debug('ContactTriggerHandler.AsyncAssignDefaultPermissions.execute()');     		
			//Add Permission Sets as apporpriate to the Users
	        Profile communityLoginProf = [Select id, Name from Profile where Name = '9.0 - Student Default' LIMIT 1];
	        Profile communityPlusProf = [Select id, Name from Profile where Name = '8.0 - College Admin Default' LIMIT 1];
	        PermissionSet defaultCollegePS = [Select id, Name, Label from PermissionSet where Label = '8.0 - School Administrator' LIMIT 1];

			List<PermissionSetAssignment> psas = new List<PermissionSetAssignment>(); 
			for(User usr : usersToAssign){
				if(usr.ProfileId == communityPlusProf.id){
					psas.add(New PermissionSetAssignment(PermissionSetId = defaultCollegePS.id,
														 AssigneeId = usr.id));				
				}
			}

			if(psas.size()>0){
				insert psas;
			}
			ContactTriggerHandler.AsyncUpdateContactsFromUserUpdate aadp = new ContactTriggerHandler.AsyncUpdateContactsFromUserUpdate();
		    aadp.usersToUpdate = usersToAssign;
		    System.enqueueJob(aadp);
    	}
    }
    public class AsyncUpdateContactsFromUserUpdate implements Queueable {

    	List<User> usersToUpdate {get;set;}
    	public void execute(QueueableContext context){
system.debug('ContactTriggerHandler.AsyncUpdateContactsFromUserUpdate.execute()');  
			Set<ID> contactIDs = new Set<ID>();
			for(User usr : usersToUpdate){
				if(!String.isBlank(usr.ContactId)){
					contactIDs.add(usr.ContactId);
				}
			}
			if(contactIDs.size()>0){
				List<Contact> contToUpdate = [SELECT id, CommunityStatus__c from Contact where id = :contactIDs and CommunityStatus__c = 'Enroll'];
				for(Contact cont : contToUpdate){
					cont.CommunityStatus__c = 'Enrolled';
				}
				update contToUpdate;
			}
    	}
    }*/
    public class ContactTriggerHandlerException extends Exception {}
}