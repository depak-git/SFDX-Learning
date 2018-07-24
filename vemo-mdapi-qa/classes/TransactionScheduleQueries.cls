/////////////////////////////////////////////////////////////////////////
// Class: TransactionScheduleQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION----------------------------- 
// 2016-12-23   Greg Cook       Created   
/////////////////////////////////////////////////////////////////////////
public class TransactionScheduleQueries {
    public static Map<ID, TransactionSchedule__c> getTransactionScheduleMap(){
        Map<ID, TransactionSchedule__c> txSchMap = new Map<ID, TransactionSchedule__c>();
        String query = generateSOQLSelect();

        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' Where Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' Order By ScheduledDate__c asc';
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        txSchMap = new Map<ID, TransactionSchedule__c>((List<TransactionSchedule__c>)db.query(query));
        return txSchMap;    
    }

    public static Map<ID, TransactionSchedule__c> getTransactionScheduleMapWithProgramID(Set<ID> programIDs){
        Map<ID, TransactionSchedule__c> txSchMap = new Map<ID, TransactionSchedule__c>();
        String query = generateSOQLSelect();
        query += ' WHERE Program__c IN ' + DatabaseUtil.inSetStringBuilder(programIDs);

        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' Order By ScheduledDate__c asc';
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        txSchMap = new Map<ID, TransactionSchedule__c>((List<TransactionSchedule__c>)db.query(query));
        return txSchMap;
    }

    public static Map<ID, List<TransactionSchedule__c>> getTransactionSchedulesByProgramIDWithProgramID(Set<ID> programIDs){
        Map<ID, TransactionSchedule__c> txSchMap = getTransactionScheduleMapWithProgramID(programIDs);
        Map<ID, List<TransactionSchedule__c>> txSchByProgramID = new Map<ID, List<TransactionSchedule__c>>();

        for(TransactionSchedule__c txSch : txSchMap.values()){
            if(!txSchByProgramID.containsKey(txSch.Program__c)){
                txSchByProgramID.put(txSch.Program__c, new List<TransactionSchedule__c>());
            }
            txSchByProgramID.get(txSch.Program__c).add(txSch);
        }

        return txSchByProgramID;
    }

    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getfieldNames() + ' FROM TransactionSchedule__c';
        system.debug(soql);
        return soql;
    }

    private static String getfieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'Name, ';
        fieldNames += 'Amount__c, ';
        fieldNames += 'FundingAmount__c, ';
        fieldNames += 'Program__c, ';
        fieldNames += 'ScheduledDate__c, ';
        fieldNames += 'SpecialDisbursementType__c ';

        return fieldNames;
    }
    
    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }
}