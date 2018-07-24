///////////////////////////////////////////////////////////////////////// test2
// Trigger: CreditCheckTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-02-06   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger CreditCheckTrigger on CreditCheck__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().creditCheckTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'CreditCheckTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}