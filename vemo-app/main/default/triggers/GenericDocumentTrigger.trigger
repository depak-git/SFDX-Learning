///////////////////////////////////////////////////////////////////////// test2
// Trigger: GenericDocumentTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-01-02   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger GenericDocumentTrigger on GenericDocument__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().genericDocumentTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'GenericDocumentTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    	LogService.writeLogs();
    }
}