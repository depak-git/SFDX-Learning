///////////////////////////////////////////////////////////////////////// test2
// Trigger: PaymentMethodTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-19  Jared Hagemann  Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger PaymentMethodTrigger on PaymentMethod__c  (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
	if(TriggerSettings.getSettings().paymentMethodTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'PaymentMethodTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}