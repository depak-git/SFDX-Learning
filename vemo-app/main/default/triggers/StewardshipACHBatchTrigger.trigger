/////////////////////////////////////////////////////////////////////////
// Trigger: StewardshipACHBatchTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger StewardshipACHBatchTrigger on StewardshipACHBatch__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().stewardshipACHBatchTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'StewardshipACHBatchTriggerHndlr');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}