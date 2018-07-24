/////////////////////////////////////////////////////////////////////////
// Class: AttendancePeriodQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-03-07   Rini Gupta       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class AttendancePeriodQueries_TEST { 
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    @isTest
    public static void validateGetAttendancePeriodMapWithProgramID(){
         //create students
        Map<Id,Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(2);
        //create Programs with school
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(3,TestDataFactory.createAndInsertSchoolCustomerAccounts(2));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        integer cnt = 0;
        for(Account acc:studentMap.values()){
            if(cnt<3){
                acc.PrimarySchool__pc = schoolMap.values()[0].id;
            }
            else{
                acc.PrimarySchool__pc = schoolMap.values()[1].id;
            }    
        }
        update studentMap.values();
        Map<ID, AttendancePeriod__c> AttendancePeriodMap = TestDataFactory.createAndInsertAttendancePeriod(2,programMap);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(AttendancePeriod__c atdprd : AttendancePeriodMap.values()){
            programIDs.add(atdprd.Program__c);
        }
        Map<Id,AttendancePeriod__c> atdprdMapResult = AttendancePeriodQueries.getAttendancePeriodMapWithProgramID(programIDs);
        System.assertEquals(AttendancePeriodMap.keySet().size(), atdprdMapResult.keySet().size());
        Test.stopTest();
    }  
    
   /* @isTest
    public static void validateGetAttendancePeriodsByProgramIDWithProgramID(){
         //create students
        Map<Id,Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(2);
        //create Programs with school
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(3,TestDataFactory.createAndInsertSchoolCustomerAccounts(2));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        integer cnt = 0;
        for(Account acc:studentMap.values()){
            if(cnt<3){
                acc.PrimarySchool__pc = schoolMap.values()[0].id;
            }
            else{
                acc.PrimarySchool__pc = schoolMap.values()[1].id;
            }    
        }
        update studentMap.values();
        Map<ID, AttendancePeriod__c> AttendancePeriodMap = TestDataFactory.createAndInsertAttendancePeriod(2,programMap);
        Test.startTest();
        Set<Id> programIDs = new Set<ID>();
        for(AttendancePeriod__c atdprd : AttendancePeriodMap.values()){
            programIDs.add(atdprd.Program__c);
        }
        Map<Id,List<AttendancePeriod__c>> atdprdMapResult = AttendancePeriodQueries.getAttendancePeriodsByProgramIDWithProgramID(programIDs);
        System.assertEquals(programIDs.size(), atdprdMapResult.keyset().size());
        Test.stopTest();
    }  */
    
    
}