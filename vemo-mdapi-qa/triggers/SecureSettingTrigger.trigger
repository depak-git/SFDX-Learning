///////////////////////////////////////////////////////////////////////// test2
// Trigger: SecureSettingTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-12-28   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger SecureSettingTrigger on SecureSetting__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().secureSettingTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'SecureSettingTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    	LogService.writeLogs();
    }
}