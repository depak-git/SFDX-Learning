/////////////////////////////////////////////////////////////////////////
// Class: TriggerSettings
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-06   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class TriggerSettings {
    ////////////////////////////////////////////////////////////////////////
    //Static Block
    /////////////////////////////////////////////////////////////////////////
	static{
		if (Test.isRunningTest()){
            Profile sysAdmin = [SELECT Id from Profile where Name = 'System Administrator'];
			User thisUser = [Select Id
                             FROM User
                             WHERE ProfileId = :sysAdmin.id and isActive = true
                             LIMIT 1];
			System.runAs(thisUser) {
				try{
					createDefaultSettings(); //if a test is running - create the settings so the test classes dont have to
				} catch(DMLException e){
				//probably fine - just means it already exists
				}
				
			}
		}	
	}
    private static TriggerSettings__c triggerSettingsObj = TriggerSettings__c.getInstance();
    private static TriggerSettings singletonInstance = null;
    public static TriggerSettings getSettings(){
        if(singletonInstance == null){
            singletonInstance = new TriggerSettings();
        }
        return singletonInstance;
    }
    public Boolean accountTrigger {
        get{
            if (accountTrigger == null){
                accountTrigger = triggerSettingsObj.Account__c;
            }
            return accountTrigger;
        }    
        set;
    }
    public Boolean opportunityTrigger {
        get{
            if (opportunityTrigger == null){
                opportunityTrigger = triggerSettingsObj.Opportunity__c;
            }
            return opportunityTrigger;
        }    
        set;
    }
    public Boolean contactTrigger {
        get{
            if (contactTrigger == null){
                contactTrigger = triggerSettingsObj.Contact__c;
            }
            return contactTrigger;
        }    
        set;
    }
    public Boolean studentProgramTrigger {
        get{
            if (studentProgramTrigger == null){
                studentProgramTrigger = triggerSettingsObj.StudentProgram__c;
            }
            return studentProgramTrigger;
        }    
        set;
    }
    public Boolean attachmentTrigger {
        get{
            if (attachmentTrigger == null){
                attachmentTrigger = triggerSettingsObj.Attachment__c;
            }
            return attachmentTrigger;
        }    
        set;
    }
    public Boolean creditCheckTrigger {
        get{
            if (creditCheckTrigger == null){
                creditCheckTrigger = triggerSettingsObj.CreditCheck__c;
            }
            return creditCheckTrigger;
        }    
        set;
    }
    public Boolean caseTrigger {
        get{
            if (caseTrigger == null){
                caseTrigger = triggerSettingsObj.Case__c;
            }
            return caseTrigger;
        }    
        set;
    }
    public Boolean transactionTrigger {
        get{
            if (transactionTrigger == null){
                transactionTrigger = triggerSettingsObj.Transaction__c;
            }
            return transactionTrigger;
        }    
        set;
    }  
    public Boolean transactionBatchTrigger {
        get{
            if (transactionBatchTrigger == null){
                transactionBatchTrigger = triggerSettingsObj.TransactionBatch__c;
            }
            return transactionBatchTrigger;
        }    
        set;
    }    
    public Boolean programTrigger {
        get{
            if (programTrigger == null){
                programTrigger = triggerSettingsObj.Program__c;
            }
            return programTrigger;
        }    
        set;
    }  
    public Boolean paymentMethodTrigger {
        get{
            if (paymentMethodTrigger == null){
                paymentMethodTrigger = triggerSettingsObj.PaymentMethod__c;
            }
            return paymentMethodTrigger;
        }    
        set;
    }
    public Boolean studentProgramMonthlyStatusTrigger {
        get{
            if (studentProgramMonthlyStatusTrigger == null){
                studentProgramMonthlyStatusTrigger = triggerSettingsObj.StudentProgramMonthlyStatus__c;
            }
            return studentProgramMonthlyStatusTrigger;
        }    
        set;
    }
    public Boolean feeTrigger {
        get{
            if (feeTrigger == null){
                feeTrigger = triggerSettingsObj.Fee__c;
            }
            return feeTrigger;
        }    
        set;
    }
    public Boolean paymentAllocationTrigger {
        get{
            if (paymentAllocationTrigger == null){
                paymentAllocationTrigger = triggerSettingsObj.PaymentAllocation__c;
            }
            return paymentAllocationTrigger;
        }    
        set;
    }
    public Boolean studentProgramAmountDueTrigger {
        get{
            if (studentProgramAmountDueTrigger == null){
                studentProgramAmountDueTrigger = triggerSettingsObj.StudentProgramAmountDue__c;
            }
            return studentProgramAmountDueTrigger;
        }    
        set;
    }
    public Boolean incomeVerificationTrigger {
        get{
            if (incomeVerificationTrigger == null){
                incomeVerificationTrigger = triggerSettingsObj.IncomeVerification__c;
            }
            return incomeVerificationTrigger;
        }    
        set;
    }
    public Boolean paymentInstructionTrigger {
        get{
            if (paymentInstructionTrigger == null){
                paymentInstructionTrigger = triggerSettingsObj.PaymentInstruction__c;
            }
            return paymentInstructionTrigger;
        }    
        set;        
    }
    public Boolean stewardshipACHBatchTrigger {
        get{
            if (stewardshipACHBatchTrigger == null){
                stewardshipACHBatchTrigger = triggerSettingsObj.StewardshipACHBatch__c;
            }
            return stewardshipACHBatchTrigger;
        }    
        set;        
    }
    public Boolean stewardshipACHBatchDetailTrigger {
        get{
            if (stewardshipACHBatchDetailTrigger == null){
                stewardshipACHBatchDetailTrigger = triggerSettingsObj.StewardshipACHBatchDetail__c;
            }
            return stewardshipACHBatchDetailTrigger;
        }    
        set;        
    }
    public Boolean outboundEmailTrigger {
        get{
            if (outboundEmailTrigger == null){
                outboundEmailTrigger = triggerSettingsObj.OutboundEmail__c;
            }
            return outboundEmailTrigger;
        }    
        set;        
    }
    public Boolean secureSettingTrigger {
        get{
            if (secureSettingTrigger == null){
                secureSettingTrigger = triggerSettingsObj.SecureSetting__c;
            }
            return secureSettingTrigger;
        }    
        set;        
    }
    public Boolean genericDocumentTrigger {
        get{
            if (genericDocumentTrigger == null){
                genericDocumentTrigger = triggerSettingsObj.GenericDocument__c;
            }
            return genericDocumentTrigger;
        }    
        set;        
    }
    public Boolean refundTrigger {
        get{
            if (refundTrigger == null){
                refundTrigger = triggerSettingsObj.Refund__c;
            }
            return refundTrigger;
        }    
        set;        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: createDefaultSettings
    /////////////////////////////////////////////////////////////////////////
	public static void createDefaultSettings(){
        if(triggerSettingsObj == null){
            triggerSettingsObj = new TriggerSettings__c();
        }
        Database.insert(triggerSettingsObj, true);           
	}
    public class TriggerSettingsException extends Exception {}
}