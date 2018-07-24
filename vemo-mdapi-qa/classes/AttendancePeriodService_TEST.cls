/////////////////////////////////////////////////////////////////////////
// Class: AttendancePeriodService_TEST
// 
// Description: 
//   Test class for AgreementPeriodService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-03-06   Rini Gupta       Created                          
/////////////////////////////////////////////////////////////////////////
@isTest
public class AttendancePeriodService_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
         
    }
    
    @isTest
    public static void validateGetAttendancePeriodsWithProgramID(){
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        
        Map<ID, AttendancePeriod__c> AttendancePeriodMap = TestDataFactory.createAndInsertAttendancePeriod(2,programMap);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(AttendancePeriod__c atdprd : AttendancePeriodMap.values()){
            programIDs.add(atdprd.Program__c);
        }
        List<AttendancePeriodService.AttendancePeriod> atdprdList = AttendancePeriodService.getAttendancePeriodsWithProgramID(programIDs);
        System.assertEquals(AttendancePeriodMap.keySet().size(), atdprdList.size());
        Test.stopTest();
    }
    @isTest
    public static void validateGetAttendancePeriodsByProgramIDWithProgramID(){
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        
        Map<ID, AttendancePeriod__c> AttendancePeriodMap = TestDataFactory.createAndInsertAttendancePeriod(2,programMap);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(AttendancePeriod__c atdprd : AttendancePeriodMap.values()){
            programIDs.add(atdprd.Program__c);
        }
        Map<Id,List<AttendancePeriodService.AttendancePeriod>> atdprdMap = AttendancePeriodService.getAttendancePeriodsByProgramIDWithProgramID(programIDs);
        System.assertEquals(programIDs.size(), atdprdMap.keyset().size());
        Test.stopTest();
    }
}