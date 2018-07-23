/////////////////////////////////////////////////////////////////////////
// Class: ProgramQueries_TEST
// 
// Description: 
//      Test class for ProgramQueries
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class ProgramQueries_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    @isTest public static void validateGetProgram(){
        Map<Id, Account> schools = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Program__c> prgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
        Test.startTest();
        Map<Id, Program__c> resultPrgMap = ProgramQueries.getProgramMapWithProgramID(prgMap.keySet());
        System.assertEquals(prgMap.keySet().size(), resultPrgMap.keySet().size());
        Test.stopTest();
    }
    
    @isTest public static void validateGetProgramMapForSchool(){
        Map<Id, Account> schools = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Program__c> prgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
        Test.startTest();
        Set<Id> schoolIDs  = new Set<ID>();
        for(Program__c prog : prgMap.values()){
            schoolIDs.add(prog.School__c);
        }
        Map<Id,Program__c> prgMapResult = ProgramQueries.getProgramMapWithSchoolID(schoolIDs);
        System.assertEquals(prgMap.keySet().size(), prgMapResult.keySet().size());
        Test.stopTest();
    }

    @isTest public static void validateGetProgramMapById(){
        Map<Id, Account> schools = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<Id, Program__c> prgMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, schools);
        Test.startTest();
        Map<Id,Program__c> prgMapResult = ProgramQueries.getProgramMap();
        System.assertEquals(prgMap.keySet().size(), prgMapResult.keySet().size());
        Test.stopTest();
    }
    
    @isTest public static void validateGetInviteOnlyAndOpenProgramMap(){
        Map<Id, Account> schools = TestDAtaFactory.createAndInsertSchoolCustomerAccounts(2);
        Map<Id, Program__c> prgMap = TestDataFactory.createAndInsertPrograms(5, schools);
        Test.startTest();
            integer cnt = 0;
            for(Program__c prg:prgMap.values()){
                prg.ProgramStatus__c = 'Open';
                prg.EnrollmentType__c = 'Open';
                if(cnt < 5){
                    prg.EnrollmentType__c = 'Invite Only';
                    prg.ProgramStatus__c = 'Open';
                    cnt++;
                }                        
            }
            update prgMap.values();
            Map<ID, Program__c> inviteOnlyResultMap = ProgramQueries.getInviteOnlyProgramMapWithSchoolID(schools.keySet());
            Map<ID, Program__c> openResultMap = ProgramQueries.getOpenProgramMapWithSchoolID(schools.keySet());
            System.assertEquals(5,inviteOnlyResultMap.size());
            System.assertEquals(5,openResultMap.size());
        Test.StopTest();     
    }
    
    
}