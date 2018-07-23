@isTest
public with sharing class GenericDocumentService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetWitID(){
    	Map<Id, GenericDocument__c> testDocMap = TestDataFactory.createAndInsertGenericDocument(TestUtil.TEST_THROTTLE);

    	Test.startTest();
    	List<GenericDocumentService.GenericDocument> resultList = GenericDocumentService.getGenericDocumentWithGenericDocumentID(testDocMap.keySet());
    	System.assertEquals(resultList.size(), testDocMap.size());
    	Test.stopTest();

    }

    static testMethod void testGetWitParentID(){
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    	Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
		Map<Id, GenericDocument__c> testDocMap = TestDataFactory.createAndInsertGenericDocument(TestUtil.TEST_THROTTLE);
    	Set<String> incStrings = new Set<String>();		
		for(IncomeVerification__c inc : testIncVerMap.values()){
			incStrings.add(((String)inc.id).subString(0,15));
		}
		for(GenericDocument__c genDoc : testDocMap.values()){
			genDoc.ParentID__c = testIncVerMap.values()[0].id;
		}
		update testDocMap.values();
    	
    	Test.startTest();
    	List<GenericDocumentService.GenericDocument> resultList = GenericDocumentService.getGenericDocumentWithParentID(incStrings);
    	System.assertEquals(resultList.size(), testDocMap.size());
    	Test.stopTest();

    }

    //static testMethod void testCreateIncomeVerification(){
    //    Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    //    //Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    //    List<IncomeVerificationService.IncomeVerification> incVerList = new List<IncomeVerificationService.IncomeVerification>();
    //    for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    //        IncomeVerificationService.IncomeVerification incVer = new IncomeVerificationService.IncomeVerification(true);
    //        incVer.studentID = testStudentAccountMap.values().get(i).Id;
    //        incVerList.add(incVer);
    //    }
    //    Test.startTest();
    //    Set<ID> incVerIDs = IncomeVerificationService.createIncomeVerification(incVerList);
    //    System.assertEquals(incVerList.size(), IncomeVerificationQueries.getIncomeVerificationMap().size());
    //    Test.stopTest();
    //}

    //static testMethod void testUpdateIncomeVerification(){
    //    Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    //    Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    //    Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
    //    List<IncomeVerificationService.IncomeVerification> incVerList = new List<IncomeVerificationService.IncomeVerification>();
    //    for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    //        IncomeVerificationService.IncomeVerification incVer = new IncomeVerificationService.IncomeVerification(true);
    //        incVer.incomeVerificationID = testIncVerMap.values().get(i).Id;
    //        incVer.incomePerMonth = 1000;
    //        incVerList.add(incVer);
    //    }
    //    Test.startTest();
    //    Set<ID> incVerIDs = IncomeVerificationService.updateIncomeVerification(incVerList);        
    //    System.assertEquals(TestUtil.TEST_THROTTLE, incVerIDs.size());
    //    Test.stopTest();
    //    for(IncomeVerification__c incVer : IncomeVerificationQueries.getIncomeVerificationMap().values()){
    //        System.assertEquals(1000, incVer.IncomePerMonth__c);
    //    }
    //}

    //static testMethod void testDeleteIncomeVerification(){
    //    Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    //    Map<Id, EmploymentHistory__c> testEmpHisMap = TestDataFactory.createAndInsertEmploymentHistory(1, testStudentAccountMap);
    //    Map<Id, IncomeVerification__c> testIncVerMap = TestDataFactory.createAndInsertIncomeVerification(1, testEmpHisMap);
    //    Test.startTest();
    //    Integer deleted = IncomeVerificationService.deleteIncomeVerificationy(testIncVerMap.keySet());        
    //    Test.stopTest();
    //    System.assertEquals(testIncVerMap.keySet().size(), deleted);
    //    System.assertEquals(0, IncomeVerificationQueries.getIncomeVerificationMap().size());
    //}
}