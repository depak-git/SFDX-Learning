/////////////////////////////////////////////////////////////////////////
// Class: AgreementService_TEST
// 
// Description: 
// 	Test class for AgreementService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
@isTest
public class AgreementService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values(); 
    }

    @isTest public static void validateGetAgreementWithAgreementID(){
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMap();


    	Map<Id, StudentProgram__c> testStudPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE,
                                                                                                  studentMap,
                                                                                                  programMap);
    	Test.startTest();
    	List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(testStudPrgMap.keySet());
    	System.assertEquals(testStudPrgMap.keySet().size(), agreements.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetAgreementWithStudentID(){
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMap();


        Map<Id, StudentProgram__c> testStudPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE,
                                                                                                  studentMap,
                                                                                                  programMap);
    	Set<ID> studentIDs = new Set<ID>();
    	for(StudentProgram__c studPrg : testStudPrgMap.values()){
    		studentIDs.add(studPrg.Student__c);
    	}
    	Test.startTest();
    	List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithStudentID(studentIDs);
    	System.assertEquals(testStudPrgMap.keySet().size(), agreements.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetAgreementWithSchoolID(){
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMap();


        Map<Id, StudentProgram__c> testStudPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE,
                                                                                                  studentMap,
                                                                                                  programMap);
    	Set<ID> schoolIDs = new Set<ID>();
    	for(StudentProgram__c studPrg : testStudPrgMap.values()){
    		schoolIDs.add(studPrg.Program__r.School__c);
    	}
    	Test.startTest();
    	List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithSchoolID(schoolIDs);
    	System.assertEquals(testStudPrgMap.keySet().size(), agreements.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetAgreementWithProgramID(){
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMap();


        Map<Id, StudentProgram__c> testStudPrgMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE,
                                                                                                  studentMap,
                                                                                                  programMap);
        Set<ID> programIDs = new Set<ID>();
        for(StudentProgram__c studPrg : testStudPrgMap.values()){
            programIDs.add(studPrg.Program__c);
        }
        Test.startTest();
        List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithProgramID(programIDs);
        System.assertEquals(testStudPrgMap.keySet().size(), agreements.size());
        Test.stopTest();
    }

    @isTest public static void validateCreateAgreement(){
    	List<AgreementService.Agreement> agreements = new List<AgreementService.Agreement>();
        Map<ID, Account> students = AccountQueries.getStudentMap();
        Map<ID, Program__c> programs = ProgramQueries.getProgramMap();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            AgreementService.Agreement agr = new AgreementService.Agreement(true);
            agr.studentID = students.values().get(i).ID;
            agr.programID = programs.values().get(i).ID;
            agreements.add(agr);
        }
        Test.startTest();
        Set<ID> agreementIDs = AgreementService.createAgreement(agreements);
        System.assertEquals(agreements.size(), StudentProgramQueries.getStudentProgramMap().size());
        Test.stopTest();
    }

    @isTest public static void validateUpdateAgreement(){
    	List<AgreementService.Agreement> agreements = new List<AgreementService.Agreement>();
        Map<ID, Account> students = AccountQueries.getStudentMap();
        Map<ID, Program__c> programs = ProgramQueries.getProgramMap();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            AgreementService.Agreement agr = new AgreementService.Agreement(true);
            agr.studentID = students.values().get(i).ID;
            agr.programID = programs.values().get(i).ID;
            agreements.add(agr);
        }        
        Set<ID> agreementIDs = AgreementService.createAgreement(agreements);
        List<AgreementService.Agreement> agreementAfter = AgreementService.getAgreementWithAgreementID(agreementIDs);
        for(AgreementService.Agreement agr : agreementAfter){
            agr.agreementStatus = 'Application Complete';
        }
        Test.startTest();
        Set<ID> updatedIDs = AgreementService.updateAgreement(agreementAfter);
        Test.stopTest();
        Map<ID, StudentProgram__c> updatedStudProgs = StudentProgramQueries.getStudentProgramMap();
        for(StudentProgram__c studProg : updatedStudProgs.values()){
            System.assertEquals('Application Complete', studProg.Status__c);
        }
    }

    @isTest public static void validateDeleteAgreement(){
    	List<AgreementService.Agreement> agreements = new List<AgreementService.Agreement>();
        Map<ID, Account> students = AccountQueries.getStudentMap();
        Map<ID, Program__c> programs = ProgramQueries.getProgramMap();
        for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
            AgreementService.Agreement agr = new AgreementService.Agreement(true);
            agr.studentID = students.values().get(i).ID;
            agr.programID = programs.values().get(i).ID;
            agreements.add(agr);
        }        
        Set<ID> agreementIDs = AgreementService.createAgreement(agreements);
        System.assertEquals(agreements.size(), StudentProgramQueries.getStudentProgramMap().size());

        Test.startTest();
        Integer deletedNum = AgreementService.deleteAgreement(agreementIDs);
        Test.stopTest();
        System.assertEquals(deletedNum, agreementIDs.size());
        System.assertEquals(0, StudentProgramQueries.getStudentProgramMap().size());
    }
}