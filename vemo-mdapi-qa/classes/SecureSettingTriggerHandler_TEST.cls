@isTest
public class SecureSettingTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();

    }

	@isTest	public static void test1() {
		TestUtil.setStandardConfiguration();
		List<SecureSetting__c> secureSettingsList = new List<SecureSetting__c>();
		secureSettingsList.add(new SecureSetting__c(Name = 'test1', Value__c = 'value1', Encrypt__c = false));
		secureSettingsList.add(new SecureSetting__c(Name = 'test2', Value__c = 'value2', Encrypt__c = true));
		insert secureSettingsList;

		Test.startTest();
		System.assertEquals(SecureSettings.getValue('test1'), 'value1');
		System.assertEquals(SecureSettings.getValue('test2'), 'value2');
		Test.stopTest();
	}
}