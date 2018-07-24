///////////////////////////////////////////////////////////////////////// test2
// Trigger: CaseTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-02-14   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger CaseTrigger on Case (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().caseTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'CaseTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}