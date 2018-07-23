public with sharing class TransactionScheduleService{
    
    public static List<transactionSchedule> gettransactionScheduleswithProgramID(set<ID> programIDs){
         System.debug('TransactionScheduleService.gettransactionScheduleswithProgramID');
         Map<Id, transactionSchedule__c> transactionScheduleMap = TransactionScheduleQueries.getTransactionScheduleMapWithProgramID(programIDs);
         List<transactionSchedule> transactionSchedules = new List<transactionSchedule>();
         for(transactionSchedule__c txSch : transactionScheduleMap.values()){
             transactionSchedules.add(new transactionSchedule(txSch));
         }
         return transactionSchedules;
    }
    
     public static Map<ID,List<transactionSchedule>> gettransactionSchedulesByProgramIDWithProgramID(Set<ID> programIDs){
        System.debug('TransactionScheduleService.gettransactionSchedulesByProgramIDWithProgramID');
        List<transactionSchedule> transactionSchedules = TransactionScheduleService.gettransactionScheduleswithProgramID(programIDs); 
        Map<Id, List<transactionSchedule>> transactionScheduleMap = new Map<Id, List<transactionSchedule>>();
        for(transactionSchedule txsch:transactionSchedules){
             if(!transactionScheduleMap.containsKey(txsch.ProgramId)){
                transactionScheduleMap.put(txsch.ProgramId, new List<transactionSchedule>());  
             } 
             transactionScheduleMap.get(txsch.ProgramId).add(txsch);  
        }
        return transactionScheduleMap;
     }
    
    public class TransactionSchedule{
        public String transactionScheduleID {get;set;}
        public Decimal Amount {get;set;}
        public Decimal FundingAmount {get;set;} 
        public String ProgramID {get;set;}
        public Date ScheduledDate {get;set;}
        public String SpecialDisbursementType {get;set;}
        
        public transactionSchedule(){}
        
        public transactionSchedule(TransactionSchedule__c transSch){
            this.transactionScheduleID = transSch.id;
            this.Amount = transSch.Amount__c;
            this.FundingAmount = transSch.FundingAmount__c;
            this.ProgramID = transSch.Program__c;
            this.ScheduledDate =  transSch.ScheduledDate__c;
            this.SpecialDisbursementType = transSch.SpecialDisbursementType__c;
        }
    }
}