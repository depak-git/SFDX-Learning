///////////////////////////////////////////////////////////////////////// test2
// Trigger: ContactTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-22   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger ContactTrigger on Contact (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().contactTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'ContactTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}