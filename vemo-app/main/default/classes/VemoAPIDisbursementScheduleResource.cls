public with sharing class VemoAPIDisbursementScheduleResource{
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
  
  public class DisbursementScheduleResourceOutputV1{
      public String transactionScheduleID {get;set;}
      public Decimal Amount {get;set;}
      public Decimal FundingAmount {get;set;} 
      public String ProgramID {get;set;}
      public Date ScheduledDate {get;set;}
      public String SpecialDisbursementType {get;set;}
      
      public DisbursementScheduleResourceOutputV1(TransactionScheduleService.TransactionSchedule transSch){
          this.transactionScheduleID = transSch.transactionScheduleID;
          this.Amount = transSch.Amount;
          this.FundingAmount = transSch.FundingAmount;
          this.ProgramID = transSch.ProgramID;
          this.ScheduledDate =  transSch.ScheduledDate;
          this.SpecialDisbursementType = transSch.SpecialDisbursementType;

      }  
  }

}