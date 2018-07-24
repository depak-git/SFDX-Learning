/////////////////////////////////////////////////////////////////////////
// Class: ProgramService_TEST
// 
// Description: 
// 	Test class for ProgramService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
@isTest
public class ProgramService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetProgramsByProgramID() {
		Map<Id, Account> schools = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Program__c> testProgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
		Test.startTest();
		List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(testProgMap.keySet());
		System.assertEquals(testProgMap.keySet().size(), programs.size());
		Test.stopTest();
	}

	@isTest public static void validateGetProgramsBySchoolID() {
		Map<Id, Account> schools = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Map<Id, Program__c> testProgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
		Test.startTest();
		Set<ID> schoolIDs = new Set<ID>();
		for(Program__c prg : testProgMap.values()){
			schoolIDs.add(prg.School__c);
		}
		List<ProgramService.Program> programs = ProgramService.getProgramsWithSchoolID(schoolIDs);
		System.assertEquals(testProgMap.keySet().size(), programs.size());
		Test.stopTest();
	}

	@isTest public static void validateCreatePrograms() {
		List<ProgramService.Program> programs = new List<ProgramService.Program>();
		Map<ID, Account> schoolMap = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			ProgramService.Program prg = new ProgramService.Program(true);
			prg.schoolID = schoolMap.values().get(i).ID;
			programs.add(prg);
		}
		Test.startTest();
		Set<ID> prgIDs = ProgramService.createProgramV1(programs);
		System.assertEquals(programs.size(), ProgramQueries.getProgramMap().size());
		Test.stopTest();
	}

	@isTest public static void validateUpdatePrograms() {
		List<ProgramService.Program> programs = new List<ProgramService.Program>();
		Map<ID, Account> schoolMap = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			ProgramService.Program prg = new ProgramService.Program(true);
			prg.schoolID = schoolMap.values().get(i).ID;
			programs.add(prg);
		}
		Set<ID> prgIDs = ProgramService.createProgramV1(programs);
		List<ProgramService.Program> newPrograms = ProgramService.getProgramsWithProgramID(prgIDs);
		for(ProgramService.Program prg : newPrograms){
			prg.programStatus = 'Planned';
		}
		Test.startTest();
		Set<ID> updatedPrgIDs = ProgramService.updateProgramV1(newPrograms);
		Test.stopTest();
		Map<ID, Program__c> prgMap = ProgramQueries.getProgramMapWithProgramID(updatedPrgIDs);
		for(Program__c prg : prgMap.values()){
			System.assertEquals('Planned', prg.ProgramStatus__c);
		}
	}

	@isTest public static void validateDeletePrograms() {
		List<ProgramService.Program> programs = new List<ProgramService.Program>();
		Map<ID, Account> schoolMap = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			ProgramService.Program prg = new ProgramService.Program(true);
			prg.schoolID = schoolMap.values().get(i).ID;
			programs.add(prg);
		}
		Set<ID> prgIDs = ProgramService.createProgramV1(programs);
		Test.startTest();
		Integer del = ProgramService.deleteProgramV1(prgIDs);
		Test.stopTest();
		System.assertEquals(prgIDs.size(), del);
		System.assertEquals(0, ProgramQueries.getProgramMap().size());
	}
}