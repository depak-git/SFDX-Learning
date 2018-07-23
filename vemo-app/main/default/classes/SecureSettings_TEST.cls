@isTest
public with sharing class SecureSettings_TEST {
	@TestSetup public static void setup(){
		SecureSetting__c setting = new SecureSetting__c(Name = 'test',
														Value__c = 'value');
		insert setting;
	}
	@isTest
	public static void validateGetSetting(){
		System.assertEquals(SecureSettings.getValue('test'), 'value', 'Wrong Value');
	}
}