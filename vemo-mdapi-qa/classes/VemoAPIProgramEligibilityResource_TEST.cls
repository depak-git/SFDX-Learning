////////////////////////////////////////////////////////////////////////
// Class: VemoAPIProgramEligibilityResource_TEST
// 
// Description: 
//  Unit test for VemoAPIProgramEligibilityResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-12   Jared Hagemann  Created
/////////////////////////////////////////////////////////////////////////
@isTest
public class VemoAPIProgramEligibilityResource_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest static void testHandleGetV1(){
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Account> schools = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, ProgramOfStudy__c> prgOfStudyMap = TestDataFactory.createAndInsertProgramOfStudy(TestUtil.TEST_THROTTLE);
        Map<Id, Program__c> testProgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
        Map<ID, ProgramEligibility__c> testProgEligMap = TestDataFactory.createAndInsertProgramEligibility(1, testProgMap);
        Map<ID, SchoolProgramsOfStudy__c> schlPrgOfStudy = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schools, prgOfStudyMap);

        for(Program__c prg : testProgMap.values()){
            prg.ResidencyRequired__c = true;
            prg.EnrollmentStatusRequired__c = true;
            prg.GradeLevelRequired__c = true;
            prg.SchoolProgramOfStudyRequired__c = true;
        }
        for(ProgramEligibility__c prgEli : testProgEligMap.values()){
            prgEli.Residency__c = 'US Citizen';//Permanent Resident, Non-US Citizen
            prgEli.EnrollmentStatus__c = 'Full Time';//Three Quarter Time,  Half Time, Less than Half Time
            prgEli.GradeLevel__c = 'Freshman';//Sophomore, Junior, Senior, Fifth Year Senior, Other
            prgEli.SchoolProgramOfStudy__c = schlPrgOfStudy.values().get(0).Id;
        }
        for(Account stud : studentMap.values()){
            stud.Residency__pc = 'US Citizen';//Permanent Resident, Non-US Citizen
            stud.PrimarySchoolEnrollmentStatus__pc = 'Full Time';//Three Quarter Time,  Half Time, Less than Half Time
            stud.PrimarySchoolGradeLevel__pc = 'Freshman';//Sophomore, Junior, Senior, Fifth Year Senior, Other
            stud.SchoolProgramOfStudy__pc = schlPrgOfStudy.values().get(0).Id;
        }

        Map<String, String> params = new Map<String, String>();
        params.put('programID', (String)testProgMap.values().get(0).Id);
        params.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);
        VemoAPI.APIInfo apiInfo = TestUtil.initializeAPI('v1', 'GET', params, null);
        apiInfo.studentPersonAccountID = studentMap.values()[0].Id;
        
        Map<String, String> paramsWithAge = new Map<String, String>();
        paramsWithAge.put('programID', (String)testProgMap.values().get(0).Id);
        paramsWithAge.put('VEMO_AUTH', 'testStudent_'+studentMap.values()[0].AuthSystemUserID__pc);
        paramsWithAge.put('age', '24');
        VemoAPI.APIInfo apiInfoWithAge = TestUtil.initializeAPI('v1', 'GET', paramsWithAge, null);
        apiInfoWithAge.studentPersonAccountID = studentMap.values()[0].Id;

        Test.startTest();
        VemoAPI.ResultResponse results = (VemoAPI.ResultResponse)VemoAPIProgramEligibilityResource.handleAPI(apiInfo);
        VemoAPI.ResultResponse results1 = (VemoAPI.ResultResponse)VemoAPIProgramEligibilityResource.handleAPI(apiInfoWithAge );
        System.assertEquals(1, results.numberOfResults);
        Test.stopTest();
    }
}