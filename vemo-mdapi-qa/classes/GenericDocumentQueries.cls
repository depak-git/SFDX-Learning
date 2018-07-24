public with sharing class GenericDocumentQueries {
    public static Map<String, Object> filterCriteria = new Map<String, Object>();
    public static void clearFilterCriteria(){
        filterCriteria.clear();
    }

    public static Map<ID, GenericDocument__c> getGenericDocumentMapByID(Set<ID> genericDocumentIDs){
        String query = generateSOQLSelect();
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(genericDocumentIDs);
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        Map<ID, GenericDocument__c> retMap = new Map<ID, GenericDocument__c>((List<GenericDocument__c>)db.query(query));


        return retMap;
    }

    public static Map<ID, GenericDocument__c> getGenericDocumentMapByParentID(Set<String> parentIDs){
        String query = generateSOQLSelect();
        query += ' WHERE ParentID__c IN ' + DatabaseUtil.inSetStringBuilder(parentIDs);
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        Map<ID, GenericDocument__c> retMap = new Map<ID, GenericDocument__c>((List<GenericDocument__c>)db.query(query));


        return retMap;
    }

    private static String generateSOQLSelect(){
        String soql;
		soql = 'SELECT ' + getFieldNames() + ' FROM GenericDocument__c';
        return soql;
    }

    private static String getFieldNames(){
        String fieldNames;
		fieldNames = 'id, ';
        fieldNames += 'Name, ';
        fieldNames += 'Type__c, ';
        fieldNames += 'ParentID__c, ';
        fieldNames += 'ParentObjectType__c, ';
        fieldNames += 'Status__c, ';
        fieldNames += 'AttachmentID__c, ';
        fieldNames += 'AttachmentName__c, ';
        fieldNames += 'Comments__c, ';
        fieldNames += 'AttachmentCleanURL__c ';

        return fieldNames;
    }
    
    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }

    //private static String generateRecordTypeStatement(String recordTypeLabel){
    //    ID recordTypeID = (String)GlobalUtil.getRecordTypeIDByLabelName('Account', recordTypeLabel);
    //    return 'RecordTypeID = \''+ String.valueOf(recordTypeID) + '\'';
    //}

    private static String buildFilterString(){
        String filterStr = '';
        if(filterCriteria.size()>0){
            for(String filter : filterCriteria.keyset()){
                filterStr += ' and ' +filter+'=\''+String.valueOf(filterCriteria.get(filter) +  '\' ');
            }           
        }
        return filterStr;
    }
}