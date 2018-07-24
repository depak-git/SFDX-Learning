public class ReconciliationQueries {
    public static Map<String, Object> filterCriteria = new Map<String, Object>();
    
    public static void clearFilterCriteria(){
      filterCriteria.clear();
    }
    
    /*public static Map<ID, Reconciliation__c> getReconciliationMapByID(){
        Map<ID, Reconciliation__c> reconciliationMap = new Map<ID, Reconciliation__c>();
        String query = generateSOQLSelect();
        
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' WHERE student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        reconciliationMap = new Map<ID, Reconciliation__c>((List<Reconciliation__c>)db.query(query));
        return reconciliationMap;  
    }*/
    
    public static Map<ID, Reconciliation__c> getReconciliationMapWithStudentID(Set<ID> studentIDs){
        Map<ID, Reconciliation__c> reconciliationMap = new Map<ID, Reconciliation__c>();
        String query = generateSOQLSelect();
        query += ' WHERE student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
        
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        reconciliationMap = new Map<ID, Reconciliation__c>((List<Reconciliation__c>)db.query(query));
        return reconciliationMap;  
    }

    public static Map<ID, Reconciliation__c> getReconciliationMapWithReconciliationID(Set<ID> reconciliationIDs){
        Map<ID, Reconciliation__c> reconciliationMap = new Map<ID, Reconciliation__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(reconciliationIDs);
        
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        reconciliationMap = new Map<ID, Reconciliation__c>((List<Reconciliation__c>)db.query(query));
        return reconciliationMap;  
    }


    public static Map<ID, ReconciliationDetail__c> getReconciliationDetailMapWithReconciliationID(Set<ID> reconciliationIDs){
        Map<ID, ReconciliationDetail__c> reconciliationDetailMap = new Map<ID, ReconciliationDetail__c>();
        String query = generateRDetailSOQLSelect();
        query += ' WHERE Reconciliation__c IN ' + DatabaseUtil.inSetStringBuilder(reconciliationIDs);
        
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        reconciliationDetailMap = new Map<ID, ReconciliationDetail__c>((List<ReconciliationDetail__c>)db.query(query));
        return reconciliationDetailMap;  
    }
    
    public static Map<ID, ReconciliationDetail__c> getRDetailMapWithRDetailID(Set<ID> reconciliationDetailIDs){
        Map<ID, ReconciliationDetail__c> reconciliationDetailMap  = new Map<ID, ReconciliationDetail__c>();
        String query = generateRDetailSOQLSelect();
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(reconciliationDetailIDs);

        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        reconciliationDetailMap  = new Map<ID, ReconciliationDetail__c>((List<ReconciliationDetail__c>)db.query(query));
        return reconciliationDetailMap;  
    }
    
    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getFieldNames() + ' FROM Reconciliation__c';
        return soql;
    }

    private static String generateRDetailSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getRDetailFieldNames() + ' FROM ReconciliationDetail__c';
        return soql;
    }


    private static String getFieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'AdobeSignAgreementID__c, ';
        fieldNames += 'AdobeSignStatus__c, ';
        fieldNames += 'AdobeSignURL__c, ';
        fieldNames += 'AgreementSigned__c, ';
        fieldNames += 'Email__c, ';
        fieldNames += 'SendKickOffEmail__c, ';
        fieldNames += 'SendSubmissionConfirmation__c, ';
        fieldNames += 'Student__c, ';
        fieldNames += 'ShouldHaveDetail__c, ';
        fieldNames += 'DateFrom__c, ';
        fieldNames += 'DateThrough__c, ';
        fieldNames += 'Status__c, ';
        fieldNames += 'OwnerID ';
        return fieldNames;
   }
   
   public static string getRDetailFieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'EmployerName__c, ';
        fieldNames += 'EmployerStartDate__c, ';
        fieldNames += 'EmployerEndDate__c, ';
        fieldNames += 'USTaxincome__c, ';
        fieldNames += 'Reconciliation__c ';
        return fieldNames;
   }

    private static String generateLIMITStatement(){
      String lim = 'LIMIT 50000';
      return lim;
    }
  
    private static String buildFilterString(){
        String filterStr = '';
       
        if(filterCriteria.size()>0){
            for(String filter : filterCriteria.keyset()){
                filterStr += ' and ' +filter+'=\''+String.valueOf(filterCriteria.get(filter) +   '\' ');
            }      
        }
        return filterStr;
    }  
}