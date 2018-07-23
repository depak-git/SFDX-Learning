///////////////////////////////////////////////////////////////////////// test2
// Trigger: IncomeVerificationTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-06  Jared Hagemann  Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger IncomeVerificationTrigger on IncomeVerification__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
	if(TriggerSettings.getSettings().incomeVerificationTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'IncomeVerificationTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
}