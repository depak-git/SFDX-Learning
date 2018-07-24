/////////////////////////////////////////////////////////////////////////
// Class: AttendancePeriodService
// 
// Description: 
//  Handles all AttendancePeriod DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-03-06   Rini Gupta      Created                          
/////////////////////////////////////////////////////////////////////////
public with sharing class AttendancePeriodService{
    
     public static List<AttendancePeriod> getAttendancePeriodsWithProgramID(Set<ID> programIDs){
        System.debug('AttendancePeriodService.getAttendancePeriodsWithProgramID');
        Map<Id, AttendancePeriod__c> AttendancePeriodMap = AttendancePeriodQueries.getAttendancePeriodMapWithProgramID(programIDs);
        List<AttendancePeriod> AttendancePeriods = new List<AttendancePeriod>();
        for(AttendancePeriod__c attprd : AttendancePeriodMap.values()){
            AttendancePeriods.add(new AttendancePeriod(attprd));
        }
        return AttendancePeriods;
     }
     
     public static Map<ID,List<AttendancePeriod>> getAttendancePeriodsByProgramIDWithProgramID(Set<ID> programIDs){
        System.debug('AttendancePeriodService.getAttendancePeriodsByProgramIDWithProgramID');
        List<AttendancePeriod> AttendancePeriods = AttendancePeriodService.getAttendancePeriodsWithProgramID(programIDs); 
        Map<Id, List<AttendancePeriod>> AttendancePeriodMap = new Map<Id, List<AttendancePeriod>>();
        for(AttendancePeriod attprd : AttendancePeriods){
             if(!AttendancePeriodMap.containsKey(attprd.ProgramId)){
                AttendancePeriodMap.put(attprd.ProgramId, new List<AttendancePeriod>());  
             } 
             AttendancePeriodMap.get(attprd.ProgramId).add(attprd);  
        }
        return AttendancePeriodMap;
     }
     
    public class AttendancePeriod{
        public String attendancePeriodID {get;set;}
        public String programID {get;set;}
        public Date AttendanceBeginDate {get;set;}
        public Date AttendanceEndDate {get;set;}
        
        public AttendancePeriod(){

        }
        
        public AttendancePeriod(AttendancePeriod__c attprd){
            this.attendancePeriodID = attprd.Id;
            this.ProgramId = attprd.program__c;
            this.AttendanceBeginDate = attprd.AttendanceBeginDate__c;
            this.AttendanceEndDate = attprd.AttendanceEndDate__c;
        }
    }
    public class AttendancePeriodServiceException extends Exception {}
}