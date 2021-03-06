/////////////////////////////////////////////////////////////////////////
// Trigger: StudentProgramAmountDueTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-04   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger StudentProgramAmountDueTrigger on StudentProgramAmountDue__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().studentProgramAmountDueTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'StudProgAmountDueTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}