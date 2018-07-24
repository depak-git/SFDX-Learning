public with sharing class VemoAPIAttendancePeriodResource{
    public static Object handleAPI(VemoAPI.APIInfo api){
        if((api.version == 'v1') && (api.method == 'GET')){
          //return handleGetV1(api);
        }
        if((api.version == 'v1') && (api.method == 'POST')){
          //return handlePostV1(api);
        }
        if((api.version == 'v1') && (api.method == 'PUT')){
          //return handlePutV1(api);
        }  
        if((api.version == 'v1') && (api.method == 'DELETE')){
          //return handleDeleteV1(api);
        }  
          
        //throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
        return null;
  }
  
  public class AttendancePeriodResourceOutputV1{
      public String AttendancePeriodId {get;set;}
      public String programID {get;set;}
      public Date AttendanceBeginDate {get;set;}
      public Date AttendanceEndDate {get;set;}
      
      public AttendancePeriodResourceOutputV1(AttendancePeriodService.AttendancePeriod period){
          this.AttendancePeriodId = period.attendancePeriodID;
          this.programID = period.programID; 
          this.AttendanceBeginDate = period.AttendanceBeginDate;
          this.AttendanceEndDate = period.AttendanceEndDate; 
      }  
  }

}