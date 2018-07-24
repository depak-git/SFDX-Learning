///////////////////////////////////////////////////////////////////////// test2
// Trigger: AccountTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger AccountTrigger on Account (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().accountTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'AccountTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    	LogService.writeLogs();
    }
}