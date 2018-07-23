/////////////////////////////////////////////////////////////////////////
// Class: PaymentMethodTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-20   Jared Hagemann  Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class PaymentMethodTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {
	/**************************Static Variables***********************************/

    /**************************State acctrol Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    
    /**************************Constructors**********************************************/
    
    /**************************Execution acctrol - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.Triggercontext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.Triggercontext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'PaymentMethodTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'PaymentMethodTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.Triggercontext tc){
		System.debug('PaymentMethodTriggerHandler.onBeforeInsert()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentMethod__c> newPaymentMethodList = (List<PaymentMethod__c>)tc.newList;
        //This is where you should call your business logic
		setDefaultsOnInsert(newPaymentMethodList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.Triggercontext tc){
		System.debug('PaymentMethodTriggerHandler.onBeforeUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentMethod__c> newPaymentMethodList = (List<PaymentMethod__c>)tc.newList;
        List<PaymentMethod__c> oldPaymentMethodList = (List<PaymentMethod__c>)tc.oldList;
        Map<ID, PaymentMethod__c> newPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.newMap;
        Map<ID, PaymentMethod__c> oldPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.oldMap;
        //This is where you should call your business logic
        
		setDefaultsOnUpdate(oldPaymenMethodMap, newPaymenMethodMap); 

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.Triggercontext tc){
		System.debug('PaymentMethodTriggerHandler.onBeforeDelete()');
       //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentMethod__c> oldPaymentMethodList = (List<PaymentMethod__c>)tc.oldList;
        Map<ID, PaymentMethod__c> oldPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.Triggercontext tc){
		System.debug('PaymentMethodTriggerHandler.onAfterInsert()');
         //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentMethod__c> newPaymentMethodList = (List<PaymentMethod__c>)tc.newList;
        Map<ID, PaymentMethod__c> newPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.newMap;
        Map<ID, PaymentMethod__c> oldPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.oldMap;
        //This is where you should call your business logic
        booleanFlipper(newPaymenMethodMap, oldPaymenMethodMap);
        manageStewardship(oldPaymenMethodMap, newPaymenMethodMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.Triggercontext tc){
		System.debug('PaymentMethodTriggerHandler.onAfterUpdate()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentMethod__c> newPaymentMethodList = (List<PaymentMethod__c>)tc.newList;
        List<PaymentMethod__c> oldPaymentMethodList = (List<PaymentMethod__c>)tc.oldList;
        Map<ID, PaymentMethod__c> newPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.newMap;
        Map<ID, PaymentMethod__c> oldPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.oldMap;
        //This is where you should call your business logic
        booleanFlipper(newPaymenMethodMap, oldPaymenMethodMap);
        manageStewardship(oldPaymenMethodMap, newPaymenMethodMap);

   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.Triggercontext tc){
		System.debug('PaymentMethodTriggerHandler.onAfterDelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentMethod__c> oldPaymentMethodList = (List<PaymentMethod__c>)tc.oldList;
        Map<ID, PaymentMethod__c> oldPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.Triggercontext tc){
		System.debug('PaymentMethodTriggerHandler.onAfterUndelete()');
        //Recast the trigger acctext variables into the appropriate shandlerect types
        List<PaymentMethod__c> newPaymentMethodList = (List<PaymentMethod__c>)tc.newList;
        Map<ID, PaymentMethod__c> newPaymenMethodMap = (Map<ID, PaymentMethod__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<PaymentMethod__c> newPaymentMethodList){
		System.debug('PaymentMethodTriggerHandler.setDefaultsOnInsert()');
        for(PaymentMethod__c cc : newPaymentMethodList){
            if(cc.PurgePII__c){
                cc.BankAccountNumber__c = '********'+cc.BankAccountNumber__c.right(4);
                cc.BankRoutingNumber__c = '********'+cc.BankRoutingNumber__c.right(4);
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, PaymentMethod__c> oldPaymentMethodMap, Map<ID, PaymentMethod__c> newPaymentMethodMap){
		System.debug('PaymentMethodTriggerHandler.setDefaultsOnUpdate()'); 
        for(PaymentMethod__c cc : newPaymentMethodMap.values()){
            if(cc.PurgePII__c && oldPaymentMethodMap.get(cc.id).PurgePII__c == false){
                cc.BankAccountNumber__c = '********'+cc.BankAccountNumber__c.right(4);
                cc.BankRoutingNumber__c = '********'+cc.BankRoutingNumber__c.right(4);
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: manageStewardship
    /////////////////////////////////////////////////////////////////////////
    private void manageStewardship(Map<ID, PaymentMethod__c> oldPaymentMethodMap, Map<ID, PaymentMethod__c> newPaymentMethodMap){
        Set<Id> createPaymentIDs = new Set<Id>();
        Set<Id> cancelPaymentIDs = new Set<Id>();
        Set<Id> createDisbursementIDs = new Set<Id>();
        Set<Id> cancelDisbursementIDs = new Set<Id>();
        Set<ID> accountIDs = new Set<ID>();
        for(PaymentMethod__c paymentMethod : newPaymentMethodMap.values()){
            if((oldPaymentMethodMap == null && paymentMethod.StewardshipProcess__c == 'Create Payment AccountGUID') ||
               (paymentMethod.StewardshipProcess__c == 'Create Payment AccountGUID' && paymentMethod.StewardshipProcess__c != oldPaymentMethodMap.get(paymentMethod.id).StewardshipProcess__c)){
                createPaymentIDs.add(paymentMethod.Id);
                accountIDs.add(paymentMethod.Customer__c);
            }
            if((oldPaymentMethodMap == null && paymentMethod.StewardshipProcess__c == 'Cancel Payment Account') ||
               (paymentMethod.StewardshipProcess__c == 'Cancel Payment Account' && paymentMethod.StewardshipProcess__c != oldPaymentMethodMap.get(paymentMethod.id).StewardshipProcess__c)){
                cancelPaymentIDs.add(paymentMethod.Id);
                accountIDs.add(paymentMethod.Customer__c);
            }
            if((oldPaymentMethodMap == null && paymentMethod.StewardshipProcess__c == 'Create Disbursement AccountGUID') ||
               (paymentMethod.StewardshipProcess__c == 'Create Disbursement AccountGUID' && paymentMethod.StewardshipProcess__c != oldPaymentMethodMap.get(paymentMethod.id).StewardshipProcess__c)){
                createDisbursementIDs.add(paymentMethod.Id);
                accountIDs.add(paymentMethod.Customer__c);
            }
            if((oldPaymentMethodMap == null && paymentMethod.StewardshipProcess__c == 'Cancel Disbursement Account') ||
               (paymentMethod.StewardshipProcess__c == 'Cancel Disbursement Account' && paymentMethod.StewardshipProcess__c != oldPaymentMethodMap.get(paymentMethod.id).StewardshipProcess__c)){
                cancelDisbursementIDs.add(paymentMethod.Id);
                accountIDs.add(paymentMethod.Customer__c);
            }
            if((oldPaymentMethodMap == null && paymentMethod.StewardshipProcess__c == 'Create Both Payment and Disbusement AccountGUID') ||
               (paymentMethod.StewardshipProcess__c == 'Create Both Payment and Disbusement AccountGUID' && paymentMethod.StewardshipProcess__c != oldPaymentMethodMap.get(paymentMethod.id).StewardshipProcess__c)){
                createPaymentIDs.add(paymentMethod.Id);
                createDisbursementIDs.add(paymentMethod.Id);
                accountIDs.add(paymentMethod.Customer__c);
            }
        }

        Map<ID, Account> accountMap = AccountQueries.getStudentMapWithStudentID(accountIDs);

        for(ID theID : createPaymentIDs){
            StewardshipTechService.CreateACHAccountRequest input = new StewardshipTechService.CreateACHAccountRequest();
//            input.DonorGUID = 'E873AE94-A878-4302-B125-E863B9AC2C21';

            input.DonorGUID = accountMap.get(newPaymentMethodMap.get(theID).Customer__c).StewardshipPaymentDonorGUID__c;

            input.Nickname = newPaymentMethodMap.get(theID).Description__c;
            if(newPaymentMethodMap.get(theID).BankAccountType__c == 'Checking'){
                input.BankAccountType = 'C';                
            } else if(newPaymentMethodMap.get(theID).BankAccountType__c == 'Savings'){
                input.BankAccountType = 'S';                
            }

            //input.AccountNumber = '123456789';
            input.AccountNumber = newPaymentMethodMap.get(theID).BankAccountNumber__c;
            //input.ABARoutingNum = '102000076';
            input.ABARoutingNum = newPaymentMethodMap.get(theID).BankRoutingNumber__c;
            
            StewardshipTechService.CreateACHAccountQueueable job = new StewardshipTechService.CreateACHAccountQueueable();
            job.input = input;
            job.paymentMethodID = theID;
            job.acctType = StewardshipTechService.AccountType.PAYMENT;
            System.enqueueJob(job);

        }
        for(ID theID : cancelPaymentIDs){
            StewardshipTechService.CancelAccountRequest input = new StewardshipTechService.CancelAccountRequest();
            //input.DonorGUID = 'E873AE94-A878-4302-B125-E863B9AC2C21';
            input.DonorGUID = accountMap.get(newPaymentMethodMap.get(theID).Customer__c).StewardshipPaymentDonorGUID__c;
            input.AccountGUID = newPaymentMethodMap.get(theID).StewardshipPaymentAccountGUID__c;
            
            StewardshipTechService.CancelAccountQueueable job = new StewardshipTechService.CancelAccountQueueable();
            job.input = input;
            job.paymentMethodID = theID;
            job.acctType = StewardshipTechService.AccountType.PAYMENT;
            System.enqueueJob(job);

        }

        for(ID theID : createDisbursementIDs){
            StewardshipTechService.CreateACHAccountRequest input = new StewardshipTechService.CreateACHAccountRequest();
//            input.DonorGUID = 'E873AE94-A878-4302-B125-E863B9AC2C21';

            input.DonorGUID = accountMap.get(newPaymentMethodMap.get(theID).Customer__c).StewardshipDisbursementDonorGUID__c;

            input.Nickname = newPaymentMethodMap.get(theID).Description__c;
            if(newPaymentMethodMap.get(theID).BankAccountType__c == 'Checking'){
                input.BankAccountType = 'C';                
            } else if(newPaymentMethodMap.get(theID).BankAccountType__c == 'Savings'){
                input.BankAccountType = 'S';                
            }

            //input.AccountNumber = '123456789';
            input.AccountNumber = newPaymentMethodMap.get(theID).BankAccountNumber__c;
            //input.ABARoutingNum = '102000076';
            input.ABARoutingNum = newPaymentMethodMap.get(theID).BankRoutingNumber__c;
            
            StewardshipTechService.CreateACHAccountQueueable job = new StewardshipTechService.CreateACHAccountQueueable();
            job.input = input;
            job.paymentMethodID = theID;
            job.acctType = StewardshipTechService.AccountType.DISBURSEMENT;
            System.enqueueJob(job);

        }
        for(ID theID : cancelDisbursementIDs){
            StewardshipTechService.CancelAccountRequest input = new StewardshipTechService.CancelAccountRequest();
            //input.DonorGUID = 'E873AE94-A878-4302-B125-E863B9AC2C21';
            input.DonorGUID = accountMap.get(newPaymentMethodMap.get(theID).Customer__c).StewardshipDisbursementDonorGUID__c;
            input.AccountGUID = newPaymentMethodMap.get(theID).StewardshipDisbursementAccountGUID__c;
            
            StewardshipTechService.CancelAccountQueueable job = new StewardshipTechService.CancelAccountQueueable();
            job.input = input;
            job.paymentMethodID = theID;
            job.acctType = StewardshipTechService.AccountType.DISBURSEMENT;
            System.enqueueJob(job);

        }


    }

    /////////////////////////////////////////////////////////////////////////
    //Method: booleanFlipper
    /////////////////////////////////////////////////////////////////////////    
    private void booleanFlipper(Map<Id, PaymentMethod__c> newPaymentMethodMap, Map<Id, PaymentMethod__c> oldPaymentMethodMap){
        System.debug('*******Running Boolean Flipper***********');
    	Set<Id> priAccountIds = new Set<Id>();
    	Set<Id> disAccountIds = new Set<Id>();
    	Set<Id> recAccountIds = new Set<Id>();
        Set<Id> nonRecAccountIds = new Set<Id>();
    	Set<Id> allAccountIds = new Set<Id>();
    	Set<Id> excludedPaymentMethods = new Set<Id>();
    	Boolean runPrimarySwitcher = false;
    	Boolean runDisbursementSwitcher = false;
    	Boolean runAutoPaymentSwitcher = false;
    	for(PaymentMethod__c pm : newPaymentMethodMap.values()){    		
    		if(pm.Primary__c && (Trigger.isInsert || (!Trigger.isInsert && !oldPaymentMethodMap.get(pm.Id).Primary__c))){
    			priAccountIds.add(pm.Customer__c);
    			allAccountIds.add(pm.Customer__c);
    			runPrimarySwitcher = true;    	
    			excludedPaymentMethods.add(pm.Id);		
    		}
    		if(pm.UseForDisbursements__c && (Trigger.isInsert || (!Trigger.isInsert && !oldPaymentMethodMap.get(pm.Id).UseForDisbursements__c))){
    			disAccountIds.add(pm.Customer__c);
    			allAccountIds.add(pm.Customer__c);
    			runDisbursementSwitcher = true;
    			excludedPaymentMethods.add(pm.Id);
    		}            
    		if(pm.UseForRecurring__c && (Trigger.isInsert || (!Trigger.isInsert && !oldPaymentMethodMap.get(pm.Id).UseForRecurring__c))){
                System.debug('*******Recrruing Flipped***********');
    			recAccountIds.add(pm.Customer__c);
    			allAccountIds.add(pm.Customer__c);
    			runAutoPaymentSwitcher = true;
    			excludedPaymentMethods.add(pm.Id);
    		}
            else if(!Trigger.isInsert && !pm.UseForRecurring__c && oldPaymentMethodMap.get(pm.Id).UseForRecurring__c){
                nonRecAccountIds.add(pm.Customer__c);
            }

    	}
        if(!nonRecAccountIds.isEmpty()){
            accntAutoPayRemove(nonRecAccountIds);
        }
    	if(runPrimarySwitcher || runDisbursementSwitcher || runAutoPaymentSwitcher){
    		//get all associated Payment Methods
    		Map<Id, PaymentMethod__c> paymentMethods = PaymentMethodQueries.getPaymentMethodMapWithCustomerID(allAccountIds);
    		List<PaymentMethod__c> pmsToUpdate = new List<PaymentMethod__c>();
    		for(PaymentMethod__c pm : paymentMethods.values()){
    			//flip primary
    			if(runPrimarySwitcher){
	    			if(priAccountIds.contains(pm.Customer__c)){
    					if(excludedPaymentMethods.contains(pm.Id)){
    						continue;
    					}
	    				pm.Primary__c = false;
	    			}
	    		}
	    		if(runDisbursementSwitcher){
	    			if(disAccountIds.contains(pm.Customer__c)){
    					if(excludedPaymentMethods.contains(pm.Id)){
    						continue;
    					}
	    				pm.UseForDisbursements__c = false;
	    			}
	    		}
	    		if(runAutoPaymentSwitcher){
	    			if(recAccountIds.contains(pm.Customer__c)){
    					if(excludedPaymentMethods.contains(pm.Id)){
    						continue;
    					}
	    				pm.UseForRecurring__c = false;	    				
	    			}                    
	    		}
	    		if(!excludedPaymentMethods.contains(pm.Id)){
					pmsToUpdate.add(pm);
				}
    		}
    		update pmsToUpdate;
            if(!recAccountIds.isEmpty()){
                accntAutoPayUpdate(recAccountIds);
            }
    	}

    }

    private void accntAutoPayRemove(Set<Id> accountIds){
        Map<Id, PaymentMethod__c> paymentMethodsMap = PaymentMethodQueries.getPaymentMethodMapWithCustomerID(accountIds);
        Map<Id, List<PaymentMethod__c>> studToPaymentMethodMap = new Map<Id, List<PaymentMethod__c>>();
        Map<Id, Boolean> studAutoPayMap = new Map<Id, Boolean>();
        for(PaymentMethod__c pm : paymentMethodsMap.values()){
            List<PaymentMethod__c> pms = studToPaymentMethodMap.get(pm.Customer__c);
            if(pms == null){
                pms = new List<PaymentMethod__c>();
                studToPaymentMethodMap.put(pm.Customer__c, pms);
            }
            pms.add(pm);
        }
        List<Account> accntsToUpdate = new List<Account>();
        for(Id studID : studToPaymentMethodMap.keySet()){
            Boolean shutOffAutoPay = true;
            for(PaymentMethod__c pm : studToPaymentMethodMap.get(studID)){
                if(pm.UseForRecurring__c){
                    shutOffAutoPay = false;
                }
            }
            if(shutOffAutoPay){
                Account acc = new Account(Id = studId, AutoPayment__pc = false, AutoPaymentDateActivated__pc = null);
                accntsToUpdate.add(acc);
            }
        }
        if(!accntsToUpdate.isEmpty()){
            update accntsToUpdate;
        }
    }

    private void accntAutoPayUpdate(Set<Id> accountIds){
        System.debug('*******Updating Accounts = ' + accountIds);
        Map<Id, Account> students = AccountQueries.getStudentMapWithStudentID(accountIds);
        for(Account acnt : students.values()){
            acnt.AutoPayment__pc = true;
            acnt.AutoPaymentDateActivated__pc = System.today();
        }
        update students.values();
    }
    public class CreditCheckTriggerHandlerException extends Exception {}
}