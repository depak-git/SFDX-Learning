/////////////////////////////////////////////////////////////////////////
// Class: OAuthUtil_TEST
// 
// Description: 
//  Unit test for OAuthUtil
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-28  Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class OAuthUtil_TEST {
	public static testMethod void testRequestAccessToken(){
		OAuthUtil oa = new OAuthUtil('test', 'username', 'password', 'cliendId', 'clientSecret');
		String fullRespones = '{"access_token":"1234","instance_url":"null","id":"null","token_type":"null","issued_at":"null","signature":"null"}';
		SingleRequestMock fakeRes = new SingleRequestMock(200, 'Complete', fullRespones, null);
		Test.setMock(HttpCalloutMock.class, fakeRes);
		String accessToken = oa.requestAccessToken();
		System.assertEquals('1234', accessToken);
	}

	static testMethod void testBuildHttpQuery(){
		Map<String, String> params = new Map<String, String>();
		params.put('Param1', 'Test1');
		params.put('Param2', 'Test2');
		Test.startTest();
		String paramString = OAuthUtil.buildHttpQuery(params);
		Test.stopTest();
		System.assertEquals('Param1=Test1&Param2=Test2', paramString);
	}
}