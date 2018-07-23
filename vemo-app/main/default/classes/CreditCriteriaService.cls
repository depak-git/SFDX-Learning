public with sharing class CreditCriteriaService{
    
    public static List<CreditCriteria> getCreditCriteriaWithProgramID(Set<ID> programIDs){
        System.debug('CreditCriteriaService.getCreditCriteriaWithProgramID');
        Map<Id, CreditCriteria__c> CreditCriteriaMap = CreditCriteriaQueries.getCreditCriteriaMapWithProgramID(programIDs);
        List<CreditCriteria> CreditCriteria = new List<CreditCriteria>();
        for(CreditCriteria__c cc : CreditCriteriaMap.values()){
            CreditCriteria.add(new CreditCriteria(cc));
        }
        return CreditCriteria;
    }
    
    public static Map<ID,List<CreditCriteria>> getCreditCriteriaByProgramIDWithProgramID(Set<ID> programIDs){
        System.debug('CreditCriteriaService.getCreditCriteriaByProgramIDWithProgramID');
        List<CreditCriteria> CreditCriteria = CreditCriteriaService.getCreditCriteriaWithProgramID(programIDs); 
        Map<Id, List<CreditCriteria>> CreditCriteriaMap = new Map<Id, List<CreditCriteria>>();
        for(CreditCriteria cc : CreditCriteria){
             if(!CreditCriteriaMap.containsKey(cc.ProgramId)){
                CreditCriteriaMap.put(cc.ProgramId, new List<CreditCriteria>());  
             } 
             CreditCriteriaMap.get(cc.ProgramId).add(cc);  
        }
        return CreditCriteriaMap;
     }
    
     public class creditCriteria{
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
        
        public creditCriteria(){

        }
        
        public creditCriteria(CreditCriteria__c creditcriteria){
            this.creditCriteriaID = creditcriteria.Id;
            this.programId = creditcriteria.program__c;
            this.amount = creditcriteria.Amount__c != null ? String.valueOf(creditcriteria.Amount__c) : '';
            this.amountOperator = creditcriteria.AmountOperator__c != null ? creditcriteria.AmountOperator__c : '';
            this.evaluationCriteria = creditcriteria.EvaluationCriteria__c ; 
            this.FICOScore = creditcriteria.FICOScore__c != null ? string.valueOf(creditcriteria.FICOScore__c) : ''; 
            this.FICOScoreOperator = creditcriteria.FICOScoreOperator__c != null ? creditcriteria.FICOScoreOperator__c : '';
            this.timePeriod  = creditcriteria.TimePeriodMonths__c != null ? String.valueOf(creditcriteria.TimePeriodMonths__c) : '';
            this.timePeriodOperator = creditcriteria.TimePeriodOperator__c != null ? creditcriteria.TimePeriodOperator__c : '';
            this.declineType = creditcriteria.DeclineType__c;   
        }
    }
    public class CreditCriteriaServiceException extends Exception {}

}