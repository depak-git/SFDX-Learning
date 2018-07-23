@isTest
public class SandboxSetup_TEST {
	private static FINAL String DEV1_ORG_ID = '00DR0000001yu46';
	private static FINAL String DEV2_ORG_ID = '00D7A0000000SZi';
	private static FINAL String PROD_ORG_ID = '00D36000001HD53';

	@isTest static void testSandboxSetup(){
		SandboxSetup cls = new SandboxSetup();
		Test.testSandboxPostCopyScript(cls, PROD_ORG_ID, DEV2_ORG_ID, 'Dev2');
	}
}