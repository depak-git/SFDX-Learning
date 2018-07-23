///////////////////////////////////////////////////////////////////////// test2
// Trigger: StudentProgram
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-29   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
trigger StudentProgramTrigger on StudentProgram__c (after delete, after insert, after undelete, 
                              after update, before delete, before insert, before update) {
//	LogService.debug('Entering StudentProgramTrigger()');
    if(TriggerSettings.getSettings().studentProgramTrigger) {
        TriggerDispatch.TriggerContext tc = new TriggerDispatch.TriggerContext(Trigger.isExecuting, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
                                                                                Trigger.isBefore, Trigger.isAfter, Trigger.isUndelete,
                                                                                Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.size, 'StudentProgramTriggerHandler');
        TriggerDispatch.dispatchTriggerHandler(tc);
    }
//	LogService.debug('Exiting StudentProgramTrigger()');
	LogService.writeLogs();
}