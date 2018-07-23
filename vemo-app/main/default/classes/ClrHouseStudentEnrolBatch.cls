global class ClrHouseStudentEnrolBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    String query;
  
    global ClrHouseStudentEnrolBatch () {
        query = 'SELECT id,RequestorReturnField__c,RequestorReturnFieldId__c from ClrHouseStudentEnrollment__c where Processed__c = false';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        set<string> accountVemoNumberSet = new set<string>();
        List<ClrHouseStudentEnrollment__c> ClrHouseStudentEnrollmentList = new List<ClrHouseStudentEnrollment__c>();
        
        for(ClrHouseStudentEnrollment__c c: (List<ClrHouseStudentEnrollment__c>) scope){
            if(c.RequestorReturnFieldId__c != null){
                accountVemoNumberSet.add(c.RequestorReturnFieldId__c);    
            }
        }
        
        if(accountVemoNumberSet != null && accountVemoNumberSet.size()>0){
            Map<id,account> accountMap = AccountQueries.getStudentMapWithVemoAccountNumber(accountVemoNumberSet);
            
            Map<string,account> vemoAccountNumberNAccountMap = new Map<string,account>();
            if(accountMap != null && accountMap.size()>0){
                for(Id i : accountMap.keyset()){
                    if(accountMap.get(i).VemoAccountNumber__c != null)
                        vemoAccountNumberNAccountMap.put(accountMap.get(i).VemoAccountNumber__c,accountMap.get(i));        
                }
            }
            for(ClrHouseStudentEnrollment__c c: (List<ClrHouseStudentEnrollment__c>) scope){
                if(c.RequestorReturnFieldId__c != null && vemoAccountNumberNAccountMap.get(c.RequestorReturnFieldId__c) != null){
                    c.account__c = vemoAccountNumberNAccountMap.get(c.RequestorReturnFieldId__c).id;
                    c.Processed__c = true;
                    ClrHouseStudentEnrollmentList.add(c);
                }
            }
            
            if(ClrHouseStudentEnrollmentList != null && ClrHouseStudentEnrollmentList.size()>0)
                upsert ClrHouseStudentEnrollmentList;
        }
    }
  
    global void finish(Database.BatchableContext BC) {
    }
}