///////////////////////////////////////////////////////////////////////// test2
// Trigger: AttachmentTrigger
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-29   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger AttachmentTrigger on Attachment (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
//	LogService.debug('Entering AttachmentTrigger()');	
    if(TriggerSettings.getSettings().AttachmentTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'AttachmentTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
//	LogService.debug('Exiting AttachmentTrigger()');
	LogService.writeLogs();
}