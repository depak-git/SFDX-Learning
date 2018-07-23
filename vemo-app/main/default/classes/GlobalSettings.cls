///////////////////////////////////////////////////////////////////////// test2
// Class: GlobalSettings
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class GlobalSettings {
    ////////////////////////////////////////////////////////////////////////
    //Static Block
    /////////////////////////////////////////////////////////////////////////
	static{
		if (Test.isRunningTest()){
            Profile sysAdmin = [SELECT Id from Profile where Name = 'System Administrator'];
			User thisUser = [Select Id
                             FROM User
                             WHERE ProfileId = :sysAdmin.id and isActive = true
                             LIMIT 1];
			System.runAs(thisUser) {
				try{
					createDefaultSettings(); //if a test is running - create the settings so the test classes dont have to
				} catch(DMLException e){
				//probably fine - just means it already exists
				}
				
			}
		}	
	}
    private static GlobalSettings__c globalSettingsObj = GlobalSettings__c.getInstance();
    private static GlobalSettings singletonInstance = null;
    public static GlobalSettings getSettings(){
        if(singletonInstance == null){
            singletonInstance = new GlobalSettings();
        }
        return singletonInstance;
    }
    public Boolean workflowRules {
        get{
            if (workflowRules == null){
                workflowRules = globalSettingsObj.WorkflowRules__c;
            }
            return workflowRules;
        }    
        set;
    }
    public Boolean validationRules {
        get{
            if (validationRules == null){
                validationRules = globalSettingsObj.ValidationRules__c;
            }
            return validationRules;
        }    
        set;
    }
    public String closedWonCaseQueue {
        get{
            if (closedWonCaseQueue == null){
                closedWonCaseQueue = globalSettingsObj.ClosedWonCaseQueue__c;
            }
            return closedWonCaseQueue;
        }    
        set;
    } 
    public Boolean emailNotifications {
        get{
            if (emailNotifications == null){
                emailNotifications = globalSettingsObj.EmailNotifications__c;
            }
            return emailNotifications;
        }    
        set;
    } 
    public String vemoAccountID {
        get{
            if (vemoAccountID == null){
                vemoAccountID = globalSettingsObj.VemoAccountID__c;
            }
            return vemoAccountID;
        }    
        set;
    }     
    public Boolean allowTestStudent {
        get{
            if (allowTestStudent == null){
                allowTestStudent = globalSettingsObj.AllowTestStudent__c;
            }
            return allowTestStudent;
        }    
        set;
    }
    public String oauthUtilUserID {
        get{
            if (oauthUtilUserID == null){
                oauthUtilUserID = globalSettingsObj.OAuthUtilUserID__c;
            }
            return oauthUtilUserID;
        }    
        set;
    }      

    public String oauthUtilPassword {
        get{
            if (oauthUtilPassword == null){
                oauthUtilPassword = globalSettingsObj.OAuthUtilPassword__c;
            }
            return oauthUtilPassword;
        }    
        set;
    }     
    public String oauthUtilConsumerID {
        get{
            if (oauthUtilConsumerID == null){
                oauthUtilConsumerID = globalSettingsObj.OAuthUtilConsumerID__c;
            }
            return oauthUtilConsumerID;
        }    
        set;
    } 
    public String oauthUtilConsumerSecret {
        get{
            if (oauthUtilConsumerSecret == null){
                oauthUtilConsumerSecret = globalSettingsObj.OAuthUtilConsumerSecret__c;
            }
            return oauthUtilConsumerSecret;
        }    
        set;
    }
    public String oauthUtilEndpoint {
        get{
            if (oauthUtilEndpoint == null){
                oauthUtilEndpoint = globalSettingsObj.OAuthUtilEndpoint__c;
            }
            return oauthUtilEndpoint;
        }    
        set;
    }    
    public String debugLevel {
        get{
            if (debugLevel == null){
                debugLevel = globalSettingsObj.DebugLevel__c;
            }
            return debugLevel;
        }    
        set;        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createDefaultSettings
    /////////////////////////////////////////////////////////////////////////
	public static void createDefaultSettings(){
        if(globalSettingsObj == null){
            globalSettingsObj = new GlobalSettings__c();
        }
        List<GlobalSettings__c> settings = new List<GlobalSettings__c>();
        //Organizational Settings
        settings.add(new GlobalSettings__c(SetupOwnerID = UserInfo.getOrganizationID(),
                                             AllowTestStudent__c = false,
                                             AttachmentDownloadPrefix__c = 'https://vemo--dev1--c.cs2.content.force.com/servlet/servlet.FileDownload?file=',
                                             ClosedWonCaseQueue__c = 'Origination',
                                             DebugLevel__c = 'DEBUG',
                                             DocumentDownloadPrefix__c = 'https://vemo--dev2--c.cs44.content.force.com/servlet/servlet.ImageServer?id=',
                                             EmailNotifications__c = true,
                                             OAuthUtilConsumerID__c = '',
                                             OAuthUtilConsumerSecret__c = '',
                                             OAuthUtilEndpoint__c = '',
                                             OAuthUtilPassword__c = '',
                                             OAuthUtilUserID__c = '',
                                             ValidationRules__c = true,
                                             VemoAccountID__c = '',
                                             WorkflowRules__c = true));
        //User Settings
        settings.add(new GlobalSettings__c(SetupOwnerID = UserInfo.getUserID(),
                                             AllowTestStudent__c = true,
                                             AttachmentDownloadPrefix__c = 'https://vemo--dev1--c.cs2.content.force.com/servlet/servlet.FileDownload?file=',
                                             ClosedWonCaseQueue__c = 'Origination',
                                             DebugLevel__c = 'DEBUG',
                                             DocumentDownloadPrefix__c = 'https://vemo--dev2--c.cs44.content.force.com/servlet/servlet.ImageServer?id=',
                                             EmailNotifications__c = true,
                                             OAuthUtilConsumerID__c = '',
                                             OAuthUtilConsumerSecret__c = '',
                                             OAuthUtilEndpoint__c = '',
                                             OAuthUtilPassword__c = '',
                                             OAuthUtilUserID__c = '',
                                             ValidationRules__c = true,
                                             VemoAccountID__c = '',
                                             WorkflowRules__c = true));    


        Database.insert(settings, true);           
	}
    public class GlobalSettingsException extends Exception {}
}