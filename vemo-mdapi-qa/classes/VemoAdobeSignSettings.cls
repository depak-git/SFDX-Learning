/////////////////////////////////////////////////////////////////////////
// Class: VemoAdobeSignSettings
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAdobeSignSettings {
    private static VemoAdobeSignSettings__c settingsObj = VemoAdobeSignSettings__c.getInstance();
    private static VemoAdobeSignSettings singletonInstance = null;
    public static VemoAdobeSignSettings getSettings(){
        if(singletonInstance == null){
            singletonInstance = new VemoAdobeSignSettings();
        }
        return singletonInstance;
    }
    public String accessToken {
        get{
            if (accessToken == null){
                accessToken = settingsObj.accessToken__c;
            }
            return accessToken;
        }    
        set;
    }
    public String apiAccessPoint {
        get{
            if (apiAccessPoint == null){
                apiAccessPoint = settingsObj.apiAccessPoint__c;
                apiAccessPoint = apiAccessPoint.removeEnd('/');
            }
            return apiAccessPoint;
        }    
        set;
    }
    public String authorizationCode {
        get{
            if (authorizationCode == null){
                authorizationCode = settingsObj.authorizationCode__c;
            }
            return authorizationCode;
        }    
        set;
    }
    public String clientID {
        get{
            if (clientID == null){
                clientID = settingsObj.clientID__c;
            }
            return clientID;
        }    
        set;
    }
    public String clientSecret {
        get{
            if (clientSecret == null){
                clientSecret = settingsObj.clientSecret__c;
            }
            return clientSecret;
        }    
        set;
    }
    public String redirectURL {
        get{
            if (redirectURL == null){
                redirectURL = settingsObj.redirectURL__c;
            }
            return redirectURL;
        }    
        set;
    }
    public String refreshToken {
        get{
            if (refreshToken == null){
                refreshToken = settingsObj.refreshToken__c;
            }
            return refreshToken;
        }    
        set;
    }
    public String oauthEndPoint {
        get{
            if (oauthEndPoint == null){
                oauthEndPoint = settingsObj.oauthEndPoint__c;
            }
            return oauthEndPoint;
        }    
        set;
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createDefaultSettings
    /////////////////////////////////////////////////////////////////////////
	public static void createDefaultSettings(){
        if(settingsObj == null){
            settingsObj = new VemoAdobeSignSettings__c();
            settingsObj.accessToken__c = 'test';
            settingsObj.apiAccessPoint__c = 'test';
            settingsObj.authorizationCode__c = 'test';
            settingsObj.clientID__c = 'test';
            settingsObj.clientSecret__c = 'test';
            settingsObj.redirectURL__c = 'test';
            settingsObj.refreshToken__c = 'test';
        }
        Database.insert(settingsObj, true);           
	}
    public class VemoAdobeSignSettingsException extends Exception {}
}