/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIAttendancePeriodResource_TEST
// 
// Description: 
//   Test class for VemoAPIAttendancePeriodResource
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-03-20    Rini Gupta  Created                          
// 
/////////////////////////////////////////////////////////////////////////

@isTest
public class VemoAPIAttendancePeriodResource_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    static testMethod void testHandleGetV1(){
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        VemoAPI.APIInfo attendanceperiodApiInfo = TestUtil.initializeAPI('v1', 'GET', null, null);
        Map<ID, AttendancePeriod__c> AttendancePeriodMap = TestDataFactory.createAndInsertAttendancePeriod(2,programMap);  
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(AttendancePeriod__c atdprd : AttendancePeriodMap.values()){
            programIDs.add(atdprd.Program__c);
        }
        List<AttendancePeriodService.AttendancePeriod> atdprdList = AttendancePeriodService.getAttendancePeriodsWithProgramID(programIDs);
        List<VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1> periodList = new List<VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1>();
        for(AttendancePeriodService.AttendancePeriod period: atdprdList){
            VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1 periodResource = new VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1(period);    
            periodList.add(periodResource); 
        }
        VemoAPI.ResultResponse AttendancePeriodResult = (VemoAPI.ResultResponse)VemoAPIAttendancePeriodResource.handleAPI(attendanceperiodApiInfo);
        system.assertEquals(atdprdList.size(), periodList.size());
        Test.stopTest();  
    }
}