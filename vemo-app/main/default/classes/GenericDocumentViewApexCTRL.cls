public class GenericDocumentViewApexCTRL {
    public static String objectType;

    @AuraEnabled
    public static List<GenericDocument__c> getGenericDocumentList(string recordId){
        System.debug('GenericDocumentViewApexCTRL.getGenericDocuments()');
        System.debug('recordId:'+recordId);
        
        String query = '';
        
        if(Id.valueOf(recordId).getSObjectType().getDescribe().getName() == 'Reconciliation__c'){
            Map<Id, ReconciliationDetail__c> reconciliationDetailMap = ReconciliationQueries.getReconciliationDetailMapWithReconciliationID(new Set<ID>{recordID});
            Set<string> reconciliationDetailIDs = new Set<string>();
            
            for(string rDetailId : reconciliationDetailMap.keyset())
                reconciliationDetailIDs.add(rDetailId.substring(0, 15));    
            //query = 'SELECT id, Type__c, Status__c, AttachmentID__c, AttachmentCleanURL__c from GenericDocument__c where ParentID__c != null and (ParentID__c IN '+DatabaseUtil.inSetStringBuilder(reconciliationDetailIDs) + ' or ParentID__c = \''+recordId.substring(0, 15)+')\'';
              query = 'SELECT id, Type__c, Status__c, AttachmentID__c, AttachmentCleanURL__c from GenericDocument__c where ParentID__c != null and (ParentID__c IN '+DatabaseUtil.inSetStringBuilder(reconciliationDetailIDs) + ' or ParentID__c = \''+recordId.substring(0, 15)+'\')';

        }
        else{
            query = 'SELECT id, Type__c, Status__c, AttachmentID__c, AttachmentCleanURL__c from GenericDocument__c where ParentID__c != null and ParentID__c = \''+recordId.substring(0, 15)+'\'';
        }
        
        Map<ID, GenericDocument__c> docMap = new Map<ID, GenericDocument__c>((List<GenericDocument__c>)Database.query(query));
        System.debug('docMap:'+docMap);
        return docMap.values();
    }
}