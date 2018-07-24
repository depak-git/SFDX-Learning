/////////////////////////////////////////////////////////////////////////
// Class: TransactionQueries
// 
// Description: 
//  All queries on the Transaction__c object
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-28   Greg Cook       Created                         
// 
/////////////////////////////////////////////////////////////////////////
public class TransactionQueries {
    
    public static Map<ID, Transaction__c> getTransactionMap(String recordTypeLabel){
        Map<ID, Transaction__c> tranMap = new Map<ID, Transaction__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ' + generateRecordTypeStatement(recordTypeLabel);
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and School__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += ' and Deleted__c = false ';
        query += ' Order By TransactionDate__c asc';
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        tranMap = new Map<ID, Transaction__c>((List<Transaction__c>)db.query(query));
        return tranMap; 
    }

    public static Map<ID, Transaction__c> getTransactionMapWithTransactionID(Set<ID> transactionIDs, String recordTypeLabel){
        Map<ID, Transaction__c> tranMap = new Map<ID, Transaction__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ' + generateRecordTypeStatement(recordTypeLabel);
        query += ' and ID IN ' + DatabaseUtil.inSetStringBuilder(transactionIDs);
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += ' and Deleted__c = false ';
        query += ' Order By TransactionDate__c asc';
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        tranMap = new Map<ID, Transaction__c>((List<Transaction__c>)db.query(query));
        return tranMap; 
    }

    public static Map<ID, Transaction__c> getTransactionMapWithStudentID(Set<ID> accountIDs, String recordTypeLabel){
        Map<ID, Transaction__c> tranMap = new Map<ID, Transaction__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ' + generateRecordTypeStatement(recordTypeLabel);
        query += ' and Student__c IN ' + DatabaseUtil.inSetStringBuilder(accountIDs);
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += ' and Deleted__c = false ';
        query += ' Order By TransactionDate__c asc';
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        tranMap = new Map<ID, Transaction__c>((List<Transaction__c>)db.query(query));
        return tranMap; 
    }

    public static Map<ID, Transaction__c> getTransactionMapWithAgreementID(Set<ID> studentProgramIDs, String recordTypeLabel){
        Map<ID, Transaction__c> tranMap = new Map<ID, Transaction__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ' + generateRecordTypeStatement(recordTypeLabel);
        query += ' and Agreement__c IN ' + DatabaseUtil.inSetStringBuilder(studentProgramIDs);
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += ' and Deleted__c = false ';
        query += ' Order By TransactionDate__c asc';
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        tranMap = new Map<ID, Transaction__c>((List<Transaction__c>)db.query(query));
        return tranMap; 
    }

    public static Map<ID, List<Transaction__c>> getTransactionMapByAgreementWithAgreementID(Set<ID> studentProgramIDs, String recordTypeLabel){
        Map<ID, List<Transaction__c>> transByAgreement = new Map<ID, List<Transaction__c>>();
        Map<ID, Transaction__c> transMap = getTransactionMapWithAgreementID(studentProgramIDs, recordTypeLabel);

        for(Transaction__c tx : transMap.values()){
            if(!transByAgreement.containsKey(tx.Agreement__c)){
                transByAgreement.put(tx.Agreement__c, new List<Transaction__c>());
            }
            transByAgreement.get(tx.Agreement__c).add(tx);
        }
        return transByAgreement;    
    }
    
    public static Map<ID,Transaction__c> getTransactionMapWithSchoolID(Set<ID> schoolIDs, String recordTypeLabel){
        Map<ID, Transaction__c> tranMap = new Map<ID, Transaction__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ' + generateRecordTypeStatement(recordTypeLabel);
        query += ' and Agreement__r.Program__r.School__c IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        if(DatabaseUtil.filterByDate){
            Date fromDate = DatabaseUtil.fromDate;
            Date toDate = DatabaseUtil.toDate;    
            if(fromDate != null){
                query += ' and TransactionDate__c >= :fromDate ';
            }
            if(toDate != null){
                query += ' and TransactionDate__c <= :toDate ';
            }
        }
        if(DatabaseUtil.filterByConfirmFlag){
            if(DatabaseUtil.confirmFlag != null){
                query += ' and Confirmed__c = ' + DatabaseUtil.confirmFlag + ' ';
            }
        }
        query += ' and Deleted__c = false ';
        query += ' Order By TransactionDate__c asc';
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        tranMap = new Map<ID, Transaction__c>((List<Transaction__c>)db.query(query));
        return tranMap; 
    }

    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getFieldNames() + ' FROM Transaction__c';
        return soql;
    }

    private static String getFieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'RecordTypeID, ';
        fieldNames += 'Amount__c, ';
        fieldNames += 'Student__c, ';
        fieldNames += 'Agreement__c, ';
        fieldNames += 'RelatedSchedule__c, ';
        fieldNames += 'TransactionDate__c, ';
        fieldNames += 'DisbursementPercentage__c, ';
        fieldNames += 'ScheduledAmount__c, ';
        fieldNames += 'Status__c, ';
        fieldNames += 'SpecialDisbursementType__c, ';
        fieldNames += 'SchoolSecurity__c, ';
        fieldNames += 'Confirmed__c, ';
        fieldNames += 'Student__r.name, ';
        fieldNames += 'Agreement__r.Program__c, ';
        fieldNames += 'Agreement__r.Program__r.ProgramName__c, ';
        fieldNames += 'Agreement__r.Status__c, ';
        fieldNames += 'Agreement__r.VemoContractNumber__c ';
        return fieldNames;
    }

    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }

    private static String generateRecordTypeStatement(String recordTypeLabel){
        ID recordTypeID = (String)GlobalUtil.getRecordTypeIDByLabelName('Transaction__c', recordTypeLabel);
        return 'RecordTypeID = \''+ String.valueOf(recordTypeID) + '\'';
    }
    
}