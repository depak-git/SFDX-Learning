///////////////////////////////////////////////////////////////////////// test2
// Trigger: FeeTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-01   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger FeeTrigger on Fee__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().feeTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'FeeTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}