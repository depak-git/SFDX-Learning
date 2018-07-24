///////////////////////////////////////////////////////////////////////// test2
// Trigger: StudentProgramMonthlyStatusTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-26   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger StudentProgramMonthlyStatusTrigger on StudentProgramMonthlyStatus__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().accountTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'StudProgMonthlyStatusTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}