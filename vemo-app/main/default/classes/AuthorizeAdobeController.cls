public with sharing class AuthorizeAdobeController {
	public static String adobeOauthURL {get;set;}
	private static VemoAdobeSignSettings__c vass = VemoAdobeSignSettings__c.getInstance();
	private static String authCode;
	private static String accessPoint;
	public AuthorizeAdobeController(){
	//?code=CBNCKBAAHBCAABAADoxRw8WPfT6Z1nZRQiyFyIfBRRm18cXy&api_access_point=https%3A%2F%2Fapi.na1.echosign.com%2F&web_access_point=https%3A%2F%2Fsecure.na1.echosign.com%2F	public AuthorizeAdobeController() {


	}

	public PageReference authorizeAdobe(){
		adobeOauthURL = 'https://secure.na1.echosign.com/public/oauth';
		adobeOauthURL += '?redirect_uri='+vass.redirectURL__c;
		adobeOauthURL += '&response_type=code';
		adobeOauthURL += '&client_id='+vass.clientID__c;
		adobeOauthURL += '&scope=user_login:self+agreement_send:account';
		system.debug(adobeOauthURL);
		authCode = ApexPages.currentPage().getParameters().get('code');
		
		if(String.isNotBlank(ApexPages.currentPage().getParameters().get('api_access_point'))){
			accessPoint = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('api_access_point'), 'UTF-8');			
		}

	
		system.debug(authCode);
		system.debug(accessPoint);
		system.debug(vass);



		List<VemoAdobeSignSettings__c> vassList = [SELECT accessToken__c,authorizationCode__c,clientID__c,clientSecret__c, apiAccessPoint__c,
													CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,
													redirectURL__c,refreshToken__c,SetupOwnerId,SystemModstamp
												  FROM VemoAdobeSignSettings__c
												  WHERE SetupOwnerId = :UserInfo.getOrganizationID() limit 1];
		system.debug(vass);
		system.debug(vassList);
		if(vassList.size() ==1){
			vassList[0].authorizationCode__c = authCode;
			vassList[0].apiAccessPoint__c = accessPoint;
			system.debug(vassList[0]);
			update vassList;
		}
		return null;
	}
}