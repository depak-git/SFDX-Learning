public with sharing class VemoAPICreditCriteriaResource{
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
  
  public class creditCriteriaResourceOutputV1{
      public String creditCriteriaID {get;set;}
      public String programID {get;set;}
      public String declineType {get;set;}
      public String evaluationCriteria {get;set;}
      public String amount {get;set;}
      public String amountOperator {get;set;}
      public String FICOScore {get;set;}
      public String FICOScoreOperator {get;set;}
      public String timePeriod {get;set;}
      public String timePeriodOperator {get;set;}
     
      
      public creditCriteriaResourceOutputV1(CreditCriteriaService.CreditCriteria CreditCriteria){
          this.CreditCriteriaID = CreditCriteria.creditcriteriaID;
          this.ProgramId = creditcriteria.programID;
          this.Amount = creditcriteria.Amount;
          this.AmountOperator = creditcriteria.AmountOperator;
          this.EvaluationCriteria = creditcriteria.EvaluationCriteria; 
          this.FICOScore = creditcriteria.FICOScore; 
          this.FICOScoreOperator = creditcriteria.FICOScoreOperator;
          this.Timeperiod  = creditcriteria.TimePeriod;
          this.TimePeriodOperator = creditcriteria.TimePeriodOperator;
          this.DeclineType = creditcriteria.DeclineType;  
      }  
  }
  
  

}