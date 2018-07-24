@isTest
public class ReportClearinghouseController_TEST{
    @TestSetup static void setupData(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students , programs);
        
        for(StudentProgram__c sp:agreements.values()){
            sp.certificationDate__c = Date.newInstance(2018,1,1);
            sp.status__c = 'Fully Funded';
        }
        update agreements.values();
        
        
        Map<ID, ClrHouseStudentEnrollment__c> clrHouseStudentEnrollmentMap = TestDataFactory.createAndInsertClrHouseStudentEnrollment(3,students);
        for(ClrHouseStudentEnrollment__c clrHouse:clrHouseStudentEnrollmentMap.values()){
            clrHouse.account__c = clrHouse.RequestorReturnField__c.removeEnd('_');
            clrHouse.Enrollment_status__c = 'F';
            clrHouse.Graduated__c = 'N';
            clrHouse.Enrollment_begin__c = '20180101';
            clrHouse.Enrollment_end__c = '20190101';
        }
        update clrHouseStudentEnrollmentMap.values();
        
    }
    
    //////////////////////////////////////////////////////////////////////
    ///Test Case 1: Only 1 student should appear in the final reportData
    //////////////////////////////////////////////////////////////////////
    @isTest public static void validateRunReport(){
        
        List<ClrHouseStudentEnrollment__c> clrHouseEnrollmentList = [SELECT id,name,Enrollment_status__c,Graduated__c,Graduation_date__c,
                                                                     Enrollment_begin__c,Enrollment_end__c,College_Name__c,account__c
                                                                     FROM ClrHouseStudentEnrollment__c];
        
        Map<ID,List<ClrHouseStudentEnrollment__c>> clrHouseEnrollmentsByStudent = new Map<ID,List<ClrHouseStudentEnrollment__c>>();
        for(ClrHouseStudentEnrollment__c clrHouse:clrHouseEnrollmentList){
                if(!clrHouseEnrollmentsByStudent.containsKey(clrHouse.account__c)){
                    clrHouseEnrollmentsByStudent.put(clrHouse.account__c,new List<ClrHouseStudentEnrollment__c>());
                }
                clrHouseEnrollmentsByStudent.get(clrHouse.account__c).add(clrHouse);
        }
        
        for(ID studentID:clrHouseEnrollmentsByStudent.keySet()){
            for(ClrHouseStudentEnrollment__c clrHouse:clrHouseEnrollmentsByStudent.get(studentID)){
                clrHouse.Enrollment_status__c = 'L';
                break;
            }
            update clrHouseEnrollmentsByStudent.get(studentID);
            break;
        }
        
        Test.StartTest(); 

            ReportClearinghouseController  cntrl = new ReportClearinghouseController();
            List<SelectOption> schools = cntrl.getSchools();
            cntrl.selectedSchool = schools[0].getValue();
            cntrl.runReport();
            System.assertEquals(1,cntrl.reportData.size(),'Number of rows in report should be 1');
        
        Test.StopTest();    
    }
    
}