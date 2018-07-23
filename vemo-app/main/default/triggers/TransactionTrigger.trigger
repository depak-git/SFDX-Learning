///////////////////////////////////////////////////////////////////////// test2
// Trigger: TransactionTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-02-20   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger TransactionTrigger on Transaction__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().transactionTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'TransactionTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}