@isTest
public with sharing class AdobeSignService_TEST {
	@TestSetup static void setupData(){
        //TestUtil.createStandardTestConditions();
//        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
//        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
//        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
//        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    }
	@isTest public static void validateAccessTokenRequestPass(){
		setSettings();
		Test.setMock(HttpCalloutMock.class, new AdobeSignService_TEST.accessTokenRequestMockPass());
		AdobeSignService.accessTokenRequest();
	}
	@isTest public static void validateRefreshRequestPass(){
		setSettings();
		Test.setMock(HttpCalloutMock.class, new AdobeSignService_TEST.accessTokenRequestMockPass());
		AdobeSignService.refreshRequest();
	}
	@isTest public static void validateUploadDocumentPass(){
		setSettings();
		User tempID = [SELECT id from User limit 1];
		Test.setMock(HttpCalloutMock.class, new AdobeSignService_TEST.accessTokenRequestMockPass());
		AdobeSignService.uploadDocument('123', tempID.id, AdobeSignService.DocumentType.ATTACHMENT);
	}
	@isTest public static void validateCreateAgreementPass(){
		setSettings();
		User tempID = [SELECT id from User limit 1];
		Test.setMock(HttpCalloutMock.class, new AdobeSignService_TEST.accessTokenRequestMockPass());
		AdobeSignService.createAgreement('123', null, 'test@test.com', tempID.id, 'Test Agreement');
	}		
	@isTest public static void validateGetSigningURLPass(){
		setSettings();
		User tempID = [SELECT id from User limit 1];
		Test.setMock(HttpCalloutMock.class, new AdobeSignService_TEST.accessTokenRequestMockPass());
		AdobeSignService.getSigningURL('123', tempID.id);
	}

	public class accessTokenRequestMockFail implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	    	HTTPResponse res = new HTTPResponse();
	    	res.setHeader('Content-Type', 'application/json');
	    	res.setBody('{"error_description":"invalid authorization code","error":"invalid_request"}');
	    	res.setStatusCode(401);
	    	return res;
	    }
	}
	public class accessTokenRequestMockPass implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	    	HTTPResponse res = new HTTPResponse();
	    	res.setHeader('Content-Type', 'application/json');
	    	res.setBody('{"access_token":"3AAABLblqZhATIhEcQJtq1Vu0vG118g2yGBr6XBckJkzeke2Lw6FfaEm0oBR3gs7lPPjoJXoMty8HpCuHgaWo1H1z2-BLImMo","refresh_token":"3AAABLblqZhDWaG_fdq_mBNF7QkjMgLAe_8GWoaToKjD0WKrI9gdajg2t5n5Wl53oKjTklEjUubc*","token_type":"Bearer","expires_in":3600}');
	    	res.setStatusCode(200);
	    	return res;
	    }
	}
	private static void setSettings(){
		VemoAdobeSignSettings.getSettings().apiAccessPoint = 'test';
		VemoAdobeSignSettings.getSettings().accessToken = 'test';
		VemoAdobeSignSettings.getSettings().apiAccessPoint = 'test';
		VemoAdobeSignSettings.getSettings().authorizationCode = 'test';
		VemoAdobeSignSettings.getSettings().clientID = 'test';
		VemoAdobeSignSettings.getSettings().clientSecret = 'test';
		VemoAdobeSignSettings.getSettings().redirectURL = 'test';
		VemoAdobeSignSettings.getSettings().refreshToken = 'test';
	}
}