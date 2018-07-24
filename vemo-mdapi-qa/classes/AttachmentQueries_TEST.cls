@isTest
public class AttachmentQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetAttachmentMap(){
		Map<Id, Attachment> attMap = TestDataFactory.createAndInsertStudentAttachments(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<Id, Attachment> resultAttMap = AttachmentQueries.getAttachmentMap();
		System.assertEquals(attMap.keySet().size(), resultAttMap.keySet().size());
		Test.stopTest();
	}

	@isTest public static void validateGetAttachmentMapWithAttachmentID(){
		Map<Id, Attachment> attMap = TestDataFactory.createAndInsertStudentAttachments(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<Id, Attachment> resultAttMap = AttachmentQueries.getAttachmentMapWithAttachmentID(attMap.keySet());
		System.assertEquals(attMap.keySet().size(), resultAttMap.keySet().size());
		Test.stopTest();
	}

	@isTest public static void validateGetAttachmentMapWithParentID(){
		Map<Id, Attachment> attMap = TestDataFactory.createAndInsertStudentAttachments(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Set<ID> parentIDS = new Set<ID>();
		for(Attachment att : attMap.values()){
			parentIDS.add(att.ParentID);
		}
		Map<Id, Attachment> resultAttMap = AttachmentQueries.getAttachmentMapWithParentID(parentIDS);
		System.assertEquals(attMap.keySet().size(), resultAttMap.keySet().size());
		Test.stopTest();
	}
}