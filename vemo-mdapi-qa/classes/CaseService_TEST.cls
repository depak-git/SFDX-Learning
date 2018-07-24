@isTest
public class CaseService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetVemoCaseWithCaseID(){
    	Map<ID, Case> testCases = TestDataFactory.createAndInsertCases(TestUtil.TEST_THROTTLE);
    	Test.startTest();
    	List<CaseService.VemoCase> cases = CaseService.getVemoCaseWithCaseID(testCases.keySet());
    	System.assertEquals(testCases.size(), cases.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetVemoCaseWithStudentID(){
    	Map<ID, Case> testCases = TestDataFactory.createAndInsertCases(TestUtil.TEST_THROTTLE);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	for(Integer i=0; i<TestUtil.TEST_THROTTLE; i++){
    		testCases.values().get(i).AccountID = students.values().get(i).ID;
    	}
    	update testCases.values();
    	Test.startTest();
    	List<CaseService.VemoCase> cases = CaseService.getVemoCaseWithStudentID(students.keySet());
    	System.assertEquals(testCases.size(), cases.size());
    	Test.stopTest();
    }

    @isTest public static void validateCreateVemoCases(){
    	List<CaseService.VemoCase> cases = new List<CaseService.VemoCase>();
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		CaseService.VemoCase vc = new CaseService.VemoCase(true);
    		cases.add(vc);
    	}
    	Test.startTest();
    	Set<ID> caseIDs = CaseService.createVemoCases(cases);
    	System.assertEquals(cases.size(), CaseQueries.getCaseMapByID().size());
    	Test.stopTest();
    }

    @isTest public static void validateUpdateVemoCases(){
    	List<CaseService.VemoCase> cases = new List<CaseService.VemoCase>();
    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		CaseService.VemoCase vc = new CaseService.VemoCase(true);
    		cases.add(vc);
    	}
    	Set<ID> caseIDs = CaseService.createVemoCases(cases);
    	List<CaseService.VemoCase> updateCases = CaseService.getVemoCaseWithCaseID(caseIDs);
    	for(CaseService.VemoCase vc : updateCases){
    		vc.Status = 'Problem';
    	}
    	Test.startTest();
    	Set<ID> updatedIDs = CaseService.updateVemoCases(updateCases);
    	Test.stopTest();
    	Map<ID, Case> updatedCases = CaseQueries.getCaseMapWithCaseID(updatedIDs);
    	for(Case c : updatedCases.values()){
    		System.assertEquals(c.Status, 'Problem');
    	}

    }
}