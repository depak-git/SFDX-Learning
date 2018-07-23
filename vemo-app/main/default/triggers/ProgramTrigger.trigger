///////////////////////////////////////////////////////////////////////// test2
// Trigger: ProgramTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-09   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger ProgramTrigger on Program__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {

    if(TriggerSettings.getSettings().programTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'ProgramTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }


}