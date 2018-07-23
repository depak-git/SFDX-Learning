public class CreditCriteriaQueries{
    
    public static Map<ID, CreditCriteria__c> getCreditCriteriaMapWithProgramID(set<ID> programIDs){
        Map<ID, CreditCriteria__c> CreditCriteriaMap = new Map<ID, CreditCriteria__c>();
        String query = generateSOQLSelect();
        query += ' WHERE Program__c IN ' + DatabaseUtil.inSetStringBuilder(programIDs);
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        //query += ' Order By AttendanceBeginDate__c asc';
        query += ' '+ generateLIMITStatement();
        system.debug('no of queries-');
        DatabaseUtil db = new DatabaseUtil();
        CreditCriteriaMap = new Map<ID, CreditCriteria__c>((List<CreditCriteria__c>)db.query(query));
        return CreditCriteriaMap;
    }
    
    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getfieldNames() + ' FROM CreditCriteria__c';
        system.debug(soql);
        return soql;
    }
   
    private static String getfieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'Name, ';
        fieldNames += 'Amount__c, ';
        fieldNames += 'AmountOperator__c, ';
        fieldNames += 'DeclineType__c, ';
        fieldNames += 'EvaluationCriteria__c, ';
        
        fieldNames += 'FICOScore__c, ';
        fieldNames += 'FICOScoreOperator__c, ';
        fieldNames += 'Program__c, ';
        fieldNames += 'TimePeriodMonths__c, ';
        fieldNames += 'TimePeriodOperator__c ';
        
        
        return fieldNames;
    }
    
    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }

}