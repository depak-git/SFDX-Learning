@isTest
public class VemoAPIAttachmentResource_TEST {
	static RestRequest req;
	static RestResponse res;

	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testHandlePostV1(){
		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');

		Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(1);

		params.put('parentID', studentMap.values().get(0).ID);
		params.put('fileName', 'test.pdf');

		req = new RestRequest();
		RestContext.request = req;
		req.requestBody = Blob.valueOf('ABC');
		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'POST', params, null);

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIAttachmentResource.handleAPI(apiInfo);
		System.assertEquals(1, result.numberOfResults);
		Test.stopTest();
	}

	static testMethod void validateHandleGetV1(){
		Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(1);
		List<Attachment> attList = TestDataFactory.createAttachments(TestUtil.TEST_THROTTLE, studentMap.values().get(0).ID);
		insert attList;

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		params.put('attachmentID', (String)attList.get(0).Id);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'GET', params, null);

		Test.startTest();
		VemoAPI.ResultResponse attResult = (VemoAPI.ResultResponse)VemoAPIAttachmentResource.handleAPI(apiInfo);
		//System.assertEquals(1, attResult.numberOfResults);
		Test.stopTest();
	}

	static testMethod void validateHandleDeleteV1(){
		Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(1);
		List<Attachment> attList = TestDataFactory.createAttachments(TestUtil.TEST_THROTTLE, studentMap.values().get(0).ID);
		insert attList;

		Map<String, String> params = new Map<String, String>();
		params.put('VEMO_AUTH', 'testStudent_'+'abc');
		params.put('attachmentID', (String)attList.get(0).Id);

		VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'DELETE', params, null);		

		Test.startTest();
		VemoAPI.ResultResponse result = (VemoAPI.ResultResponse)VemoAPIAttachmentResource.handleAPI(apiInfo);
		List<Attachment> atts = [select Id, ParentID, Body, ContentType, Name from Attachment];	
		System.assertEquals(1, result.numberOfResults);
		System.assertEquals(TestUtil.TEST_THROTTLE - 1, atts.size(), 'One Attachment should be deleted');
		Test.stopTest();
	}
}