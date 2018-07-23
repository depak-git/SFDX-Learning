@isTest
public class ProgramOfStudyService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetProgramOfStudies(){
    	Map<ID, ProgramOfStudy__c> testPOSMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Test.startTest();
    	List<ProgramOfStudyService.ProgramOfStudy> posList = ProgramOfStudyService.getProgramOfStudies();
    	System.assertEquals(testPOSMap.size(), posList.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetProgramOfStudyWithPOSID(){
    	Map<ID, ProgramOfStudy__c> testPOSMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Test.startTest();
    	List<ProgramOfStudyService.ProgramOfStudy> posList = ProgramOfStudyService.getProgramOfStudyWithPOSID(testPOSMap.keySet());
    	System.assertEquals(testPOSMap.size(), posList.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetProgramOfStudyWithSchoolIDs(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, ProgramOfStudy__c> testPOSMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
    	Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, testPOSMap);
    	Test.startTest();
    	List<ProgramOfStudyService.ProgramOfStudy> posList = ProgramOfStudyService.getProgramOfStudyWithSchoolIDs(schools.keySet());
    	System.assertEquals(testPOSMap.size(), posList.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetProgramOfStudyWithStudentIDs(){
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, ProgramOfStudy__c> testPOSMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);

        Map<ID, SchoolProgramsOfStudy__c> testSPOSMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, testPOSMap);



    	for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
    		students.values().get(i).SchoolProgramOfStudy__pc = testSPOSMap.values()[i].ID;
    	}

    	update students.values();
    	Test.startTest();
    	List<ProgramOfStudyService.ProgramOfStudy> posList = ProgramOfStudyService.getProgramOfStudyWithStudentIDs(students.keySet());
    	System.assertEquals(testPOSMap.size(), posList.size());
    	Test.stopTest();
    }

    @isTest public static void validateCreateProgramOfStudy(){
        List<ProgramOfStudyService.ProgramOfStudy> posList = new List<ProgramOfStudyService.ProgramOfStudy>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            ProgramOfStudyService.ProgramOfStudy pos = new ProgramOfStudyService.ProgramOfStudy(true);
            posList.add(pos);
        }
        Test.startTest();
        Set<ID> posIDs = ProgramOfStudyService.createProgramOfStudy(posList);
        System.assertEquals(posList.size(), ProgramOfStudyQueries.getProgramOfStudyMap().size());
        Test.stopTest();
    }

    @isTest public static void validateUpdateProgramOfStudy(){
        List<ProgramOfStudyService.ProgramOfStudy> posList = new List<ProgramOfStudyService.ProgramOfStudy>();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            ProgramOfStudyService.ProgramOfStudy pos = new ProgramOfStudyService.ProgramOfStudy(true);
            posList.add(pos);
        }
        Set<ID> posIDs = ProgramOfStudyService.createProgramOfStudy(posList);
        List<ProgramOfStudyService.ProgramOfStudy> newPOSList = ProgramOfStudyService.getProgramOfStudyWithPOSID(posIDs);
        for(ProgramOfStudyService.ProgramOfStudy pos : newPOSList){
            pos.code = 'Updated Code';
        }
        Test.startTest();
        Set<ID> updatedPOSIDs = ProgramOfStudyService.updateProgramOfStudy(newPOSList);
        Test.stopTest();
        Map<ID, ProgramOfStudy__c> updatedPOSMap = ProgramOfStudyQueries.getProgramOfStudyMapWithPOSID(updatedPOSIDs);
        for(ProgramOfStudy__c pos : updatedPOSMap.values()){
            System.assertEquals('Updated Code', pos.CIPCode__c);
        }
    }

    @isTest public static void validateDeleteProgramOfStudy(){
        Map<ID, ProgramOFStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
        Test.startTest();
        Integer del = ProgramOfStudyService.deleteProgramOfStudy(posMap.keySet());
        Test.stopTest();
        System.assertEquals(posMap.keySet().size(), del);
        System.assertEquals(0, ProgramOfStudyQueries.getProgramOfStudyMap().size());
    }
}