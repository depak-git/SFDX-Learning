/////////////////////////////////////////////////////////////////////////
// Trigger: PaymentInstructionTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger PaymentInstructionTrigger on PaymentInstruction__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
    if(TriggerSettings.getSettings().paymentInstructionTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'PaymentInstructionTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}