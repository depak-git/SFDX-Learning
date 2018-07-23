@isTest
public with sharing class GenericDocumentQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
	@isTest public static void validateGetGenericDocumentMapByID() {
		Map<Id, GenericDocument__c> testDocMap = TestDataFactory.createAndInsertGenericDocument(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<Id, GenericDocument__c> resultDocMap = GenericDocumentQueries.getGenericDocumentMapByID(testDocMap.keySet());
		System.assertEquals(testDocMap.keySet().size(), resultDocMap.keySet().size());
		Test.stopTest();
	}

	@isTest public static void validateGetGenericDocumentMapByParentID() {
		TestUtil.setStandardConfiguration();

    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
		Map<Id, GenericDocument__c> testDocMap = TestDataFactory.createAndInsertGenericDocument(TestUtil.TEST_THROTTLE);
    	Set<String> incStrings = new Set<String>();		
		for(IncomeVerification__c inc : testIncVerMap.values()){
			incStrings.add(((String)inc.id).subString(0,15));
		}
		for(GenericDocument__c genDoc : testDocMap.values()){
			genDoc.ParentID__c = ((String)(testIncVerMap.values()[0].id)).substring(0,15);
		}
		update testDocMap.values();

		Test.startTest();
		Map<Id, GenericDocument__c> resultDocMap = GenericDocumentQueries.getGenericDocumentMapByParentID(incStrings);

		System.debug('1:'+[SELECT id, ParentID__c from GenericDocument__c]);
		System.debug('2:'+[SELECT id from IncomeVerification__c]);
		System.assertEquals(testDocMap.keySet().size(), resultDocMap.keySet().size());
		Test.stopTest();
	}

}