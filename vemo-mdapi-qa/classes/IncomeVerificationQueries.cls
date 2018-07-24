/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
public class IncomeVerificationQueries {
    public static Map<String, Object> filterCriteria = new Map<String, Object>();
    public static void clearFilterCriteria(){
        filterCriteria.clear();
    }

    public static Map<ID, IncomeVerification__c> getIncomeVerificationMap(){
        Map<ID, IncomeVerification__c> incomeVerificationMap = new Map<ID, IncomeVerification__c>();
        String query = generateSOQLSelect();
        query += ' WHERE Id != null';
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        incomeVerificationMap = new Map<ID, IncomeVerification__c>((List<IncomeVerification__c>)db.query(query));
        return incomeVerificationMap;       
    }

    public static Map<ID, IncomeVerification__c> getIncomeVerificationMapWithIncomeVerificationId(Set<Id> incomeVerificationIds){
        Map<ID, IncomeVerification__c> incomeVerificationMap = new Map<ID, IncomeVerification__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(incomeVerificationIds);
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        incomeVerificationMap = new Map<ID, IncomeVerification__c>((List<IncomeVerification__c>)db.query(query));
        return incomeVerificationMap;       
    }

    public static Map<ID, IncomeVerification__c> getIncomeVerificationMapWithStudentId(Set<Id> studentIds){
        Map<ID, IncomeVerification__c> incomeVerificationMap = new Map<ID, IncomeVerification__c>();
        String query = generateSOQLSelect();
        query += ' WHERE Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIds);
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        incomeVerificationMap = new Map<ID, IncomeVerification__c>((List<IncomeVerification__c>)db.query(query));
        return incomeVerificationMap;       
    }

    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }
    
    private static String buildFilterString(){
        String filterStr = '';
        if(filterCriteria.size()>0){
            for(String filter : filterCriteria.keyset()){
                filterStr += ' and ' +filter+'=\''+String.valueOf(filterCriteria.get(filter) +  '\' ');
            }           
        }
        return filterStr;
    }

    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getIncomeVerificationFieldNames() + ' FROM IncomeVerification__c ';
        return soql;
    }

    private static String getIncomeVerificationFieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'IncomePerMonth__c, ';
        fieldNames += 'IncomePerYear__c, ';
        fieldNames += 'BeginDate__c , ';
        fieldNames += 'EmploymentHistory__c, ';
        fieldNames += 'DateVerified__c, ';
        fieldNames += 'DateReported__c, ';
        fieldNames += 'Student__c, ';
        fieldNames += 'Type__c, ';
        fieldNames += 'Verified__c, ';
        fieldNames += 'EndDate__c, ';
        fieldNames += 'Status__c ';
        return fieldNames;
    }
}