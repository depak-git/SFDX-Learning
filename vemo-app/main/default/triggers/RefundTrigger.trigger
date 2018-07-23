///////////////////////////////////////////////////////////////////////// test2
// Trigger: RefundTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-03-19   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger RefundTrigger on Refund__c (after delete, after insert, after undelete, 
                              		after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().refundTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'RefundTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    	LogService.writeLogs();
    }
}