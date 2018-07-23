public with sharing class AdobeSignAuthController {
	public static String adobeOauthURL {get;set;}
	private static VemoAdobeSignSettings__c vass = VemoAdobeSignSettings__c.getInstance();
	private static String authCode;
	private static String accessPoint;
	public AdobeSignAuthController(){
		System.debug('AdobeSignAuthController.AdobeSignAuthController()');
		initialized = false;
	//?code=CBNCKBAAHBCAABAADoxRw8WPfT6Z1nZRQiyFyIfBRRm18cXy&api_access_point=https%3A%2F%2Fapi.na1.echosign.com%2F&web_access_point=https%3A%2F%2Fsecure.na1.echosign.com%2F	public AuthorizeAdobeController() {


	}

	public Boolean initialized{get; set;}

    public void init(){
	    if (!initialized){

			authCode = ApexPages.currentPage().getParameters().get('code');
		
			if(String.isNotBlank(ApexPages.currentPage().getParameters().get('api_access_point'))){
				accessPoint = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('api_access_point'), 'UTF-8');			
			}
			
			List<VemoAdobeSignSettings__c> vassList = [SELECT accessToken__c,authorizationCode__c,clientID__c,clientSecret__c, apiAccessPoint__c,
														CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,
														redirectURL__c,refreshToken__c,SetupOwnerId,SystemModstamp
													  FROM VemoAdobeSignSettings__c
													  WHERE SetupOwnerId = :UserInfo.getOrganizationID() limit 1];
			System.debug(vass);
			System.debug(vassList);

			if(vassList.size() ==1){
				vassList[0].authorizationCode__c = authCode;
				vassList[0].apiAccessPoint__c = accessPoint;
				System.debug(vassList[0]);
				update vassList;
			}

	    }

	}




	public PageReference redirectToAdobe(){
		System.debug('AdobeSignAuthController.redirectToAdobe()');
		//adobeOauthURL = 'https://secure.na1.echosign.com/public/oauth';
		adobeOauthURL = VemoAdobeSignSettings.getSettings().oauthEndPoint;
		adobeOauthURL += '?redirect_uri='+vass.redirectURL__c;
		adobeOauthURL += '&response_type=code';
		adobeOauthURL += '&client_id='+vass.clientID__c;
		adobeOauthURL += '&scope=user_login:self';
		adobeOauthURL += '+agreement_send:account';
		adobeOauthURL += '+agreement_write:account';		
		adobeOauthURL += '+agreement_read:account';
		System.debug(adobeOauthURL);
		PageReference pageRef = new PageReference(adobeOauthURL);
		return pageRef;		
	}


	public PageReference updateSettings(){
		System.debug('AdobeSignAuthController.updateSettings()');
/*		adobeOauthURL = 'https://secure.na1.echosign.com/public/oauth';
		adobeOauthURL += '?redirect_uri='+vass.redirectURL__c;
		adobeOauthURL += '&response_type=code';
		adobeOauthURL += '&client_id='+vass.clientID__c;
		adobeOauthURL += '&scope=user_login:self+agreement_send:account';
		system.debug(adobeOauthURL);*/
		
		authCode = ApexPages.currentPage().getParameters().get('code');
		
		if(String.isNotBlank(ApexPages.currentPage().getParameters().get('api_access_point'))){
			accessPoint = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('api_access_point'), 'UTF-8');			
		}

	
		system.debug(authCode);
		system.debug(accessPoint);
		system.debug(vass);

		AdobeSignService.AccessTokenResponse atr = AdobeSignService.accessTokenRequest();
		System.debug(atr);





		List<VemoAdobeSignSettings__c> vassList = [SELECT accessToken__c,authorizationCode__c,clientID__c,clientSecret__c, apiAccessPoint__c,
													CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,
													redirectURL__c,refreshToken__c,SetupOwnerId,SystemModstamp
												  FROM VemoAdobeSignSettings__c
												  WHERE SetupOwnerId = :UserInfo.getOrganizationID() limit 1];
		System.debug(vass);
		System.debug(vassList);

		if(vassList.size() ==1){
			vassList[0].authorizationCode__c = authCode;
			vassList[0].apiAccessPoint__c = accessPoint;
			vassList[0].accessToken__c = atr.access_token;
			vassList[0].refreshToken__c = atr.refresh_token;
			System.debug(vassList[0]);
			update vassList;
		}
		return null;
	}
	public class AdobeSignControllerException extends Exception {}
}