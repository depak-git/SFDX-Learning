/////////////////////////////////////////////////////////////////////////
// Class: TransactionBatchTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-29   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class TransactionBatchTriggerHandler implements TriggerDispatch.ITriggerHandlerClass {

    /**************************Static Variables***********************************/

    /**************************State Control Variables**********************************/
    public static boolean mainHasRun = false;
    public static boolean inProgressHasRun = false;
    public static Boolean manageTransactionsHasRun = false;

    /**************************Constructors**********************************************/
    
    /**************************Execution Control - Entry Points**********************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: mainEntry
    /////////////////////////////////////////////////////////////////////////
    public void mainEntry(TriggerDispatch.TriggerContext tc){       
        mainHasRun = true;
            
        if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        
        //the following lines should theoretically never be called but could be called from a simulated transaction
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
            

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: inProgressEntry
    /////////////////////////////////////////////////////////////////////////
    public void inProgressEntry(TriggerDispatch.TriggerContext tc){
        inProgressHasRun = true;
    
         //Call Desired Functions - Or Not - Given this is InProgressEntry
        if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isBefore && tc.isInsert) onBeforeInsert(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isBefore && tc.isUpdate) onBeforeUpdate(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isBefore && tc.isDelete) onBeforeDelete(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isInsert) onAfterInsert(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isUpdate) onAfterUpdate(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isDelete) onAfterDelete(tc);
        else if(tc.handler == 'TransactionBatchTriggerHandler' && tc.isAfter && tc.isUndelete) onAfterUndelete(tc);
        
        //This is where to decide whether or not to allow other triggers to fire based upon DML on other handlerects
        else if(tc.handler != 'TransactionBatchTriggerHandler'){
            //Determine what to do with other triggers - either kill them or forward them along
            TriggerDispatch.forwardTrigger(tc, this);               
        }

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeInsert
    /////////////////////////////////////////////////////////////////////////    
    public void onBeforeInsert(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionBatchTriggerHandler.onBeforeInsert()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<TransactionBatch__c> newTransactionBatchList = (List<TransactionBatch__c>)tc.newList;
        //This is where you should call your business logic
        setDefaultsOnInsert(newTransactionBatchList);

    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeUpdate(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionBatchTriggerHandler.onBeforeUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<TransactionBatch__c> newTransactionBatchList = (List<TransactionBatch__c>)tc.newList;
        List<TransactionBatch__c> oldTransactionBatchList = (List<TransactionBatch__c>)tc.oldList;
        Map<ID, TransactionBatch__c> newTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.newMap;
        Map<ID, TransactionBatch__c> oldTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.oldMap;
        //This is where you should call your business logic
        setDefaultsOnUpdate(oldTransactionBatchMap, newTransactionBatchMap); 
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onBeforeDelete
    /////////////////////////////////////////////////////////////////////////
    public void onBeforeDelete(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionBatchTriggerHandler.onBeforeDelete()');
       //Recast the trigger context variables into the appropriate shandlerect types
        List<TransactionBatch__c> oldTransactionBatchList = (List<TransactionBatch__c>)tc.oldList;
        Map<ID, TransactionBatch__c> oldTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.oldMap;
        //This is where you should call your business logic

    }
    
    /****************************After logic****************************************/
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterInsert
    /////////////////////////////////////////////////////////////////////////
    public void onAfterInsert(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionBatchTriggerHandler.onAfterInsert()');
         //Recast the trigger context variables into the appropriate shandlerect types
        List<TransactionBatch__c> newTransactionBatchList = (List<TransactionBatch__c>)tc.newList;
        Map<ID, TransactionBatch__c> newTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.newMap;
        //This is where you should call your business logic
 		manageTransactions(null, newTransactionBatchMap);
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUpdate
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUpdate(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionBatchTriggerHandler.onAfterUpdate()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<TransactionBatch__c> newTransactionBatchList = (List<TransactionBatch__c>)tc.newList;
        List<TransactionBatch__c> oldTransactionBatchList = (List<TransactionBatch__c>)tc.oldList;
        Map<ID, TransactionBatch__c> newTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.newMap;
        Map<ID, TransactionBatch__c> oldTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.oldMap;
        //This is where you should call your business logic
 		manageTransactions(oldTransactionBatchMap, newTransactionBatchMap);
   }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterDelete
    /////////////////////////////////////////////////////////////////////////    
    public void onAfterDelete(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionBatchTriggerHandler.onAfterDelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<TransactionBatch__c> oldTransactionBatchList = (List<TransactionBatch__c>)tc.oldList;
        Map<ID, TransactionBatch__c> oldTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.oldMap;
        //This is where you should call your business logic

     }
    /////////////////////////////////////////////////////////////////////////
    //Method: onAfterUndelete
    /////////////////////////////////////////////////////////////////////////
    public void onAfterUndelete(TriggerDispatch.TriggerContext tc){
		System.debug('TransactionBatchTriggerHandler.onAfterUndelete()');
        //Recast the trigger context variables into the appropriate shandlerect types
        List<TransactionBatch__c> newTransactionBatchList = (List<TransactionBatch__c>)tc.newList;
        Map<ID, TransactionBatch__c> newTransactionBatchMap = (Map<ID, TransactionBatch__c>)tc.newMap;
        //This is where you should call your business logic
        
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnInsert
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnInsert(List<TransactionBatch__c> newTransactionBatchList){
		System.debug('TransactionBatchTriggerHandler.setDefaultsOnInsert()');
        for(TransactionBatch__c txBatch: newTransactionBatchList){

        }
    }
    /////////////////////////////////////////////////////////////////////////
    //Method: setDefaultsOnUpdate
    /////////////////////////////////////////////////////////////////////////
    private void setDefaultsOnUpdate(Map<ID, TransactionBatch__c> oldTransactionBatchMap, Map<ID, TransactionBatch__c> newTransactionBatchMap){
		System.debug('TransactionBatchTriggerHandler.setDefaultsOnUpdate()'); 
        for(TransactionBatch__c txBatch: newTransactionBatchMap.values()){

        }
    }

    /////////////////////////////////////////////////////////////////////////
    //Method: manageTransactions
    /////////////////////////////////////////////////////////////////////////
    private void manageTransactions(Map<ID, TransactionBatch__c> oldTransactionBatchMap, Map<ID, TransactionBatch__c> newTransactionBatchMap){
        System.debug('TransactionBatchTriggerHandler.manageTransactions()'); 
        if(!manageTransactionsHasRun){
            System.debug('manageTransactionsHasRun is false');     
            Map<ID, Transaction__c> txToUpdate = new Map<ID, Transaction__c>();       
            for(TransactionBatch__c txBatch : newTransactionBatchMap.values()){
	            //NOT BULK SAFE!!! Query in loop due to date specificity - otherwise have to get widest range and filter after the fact
            	if(txBatch.TransactionBatchStatus__c == 'Select Transactions' && (oldTransactionBatchMap == null || oldTransactionBatchMap.get(txBatch.id).TransactionBatchStatus__c != 'Select Transactions')){

/*
                    //User.TimeZoneSidKey
                    DateTime inDateTime = DateTime.now();
                    string dateTimeStr = inDateTime.format('yyyy-MM-dd HH:mm:ss',  '(Americas/Denver)');
                    string dateGmtStr  = inDateTime.formatGMT('yyyy-MM-dd HH:mm:ss');
                    Datetime localDateTime = DateTime.valueOf(dateTimeStr);
                    Datetime baseGMTTime = DateTime.valueOf(dateGMTStr);
                    Long milliSecDiff =  baseGMTTime.getTime() - localDateTime.getTime();
                    Long minDiff = milliSecDiff / 1000 / 60;
                    Datetime outDateTime = inDateTime.addMinutes(minDiff.intValue());


                    Integer d;
                    Integer m;
                    Integer y;

                    d = txBatch.TransactionsFrom__c.day();
                    m = txBatch.TransactionsFrom__c.month();
                    y = txBatch.TransactionsFrom__c.year();*/

                    //String dateFrom = DateTime.newInstanceGMT(y, m, d, 0, 0, 0).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                    String dateFrom = String.valueOf(txBatch.TransactionsFrom__c);//+'T00:00:00Z';
                    String dateThrough = String.valueOf(txBatch.TransactionsThrough__c);//+'T23:59:59Z';
/*
                    d = txBatch.TransactionsThrough__c.day();
                    m = txBatch.TransactionsThrough__c.month();
                    y = txBatch.TransactionsThrough__c.year();        
                                
                    String dateThrough = DateTime.newInstanceGMT(y, m, d, 23, 59, 59).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');*/

            		//String dateFrom = txBatch.TransactionsFrom__c.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
             		//String dateThrough = txBatch.TransactionsThrough__c.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');     


            		String qry = 'SELECT id from Transaction__c where ';
            		qry += 'TransactionBatch__c = null and ';
            		//qry += 'TransactionDateTime__c >= ' + dateFrom + ' and ';
            		//qry += 'TransactionDateTime__c <= ' + dateThrough;

                    qry += 'TransactionDate__c >= ' + dateFrom + ' and ';
                    qry += 'TransactionDate__c <= ' + dateThrough;



            		if(String.isNotBlank(txBatch.Program__c)){
						qry += ' and Agreement__r.Program__c = \'' + String.valueOf(txBatch.Program__c) +'\'';
            		}
            		system.debug(qry);

		            Map<ID, Transaction__c> txMap = new Map<ID, Transaction__c>((List<Transaction__c>)Database.query(qry));




		            System.debug('txMap:'+txMap);
		            for(Transaction__c tx : txMap.values()){
		            	if(txToUpdate.containsKey(tx.id)){
		            		txToUpdate.get(tx.id).TransactionBatch__c =  txBatch.id;
	            		} else {
			            	txToUpdate.put(tx.id, new Transaction__c(id = tx.id,
			            											 TransactionBatch__c =  txBatch.id));	            			
	            		}
		            }            		
            	} else if(txBatch.TransactionBatchStatus__c == 'Release Transactions' && (oldTransactionBatchMap == null || oldTransactionBatchMap.get(txBatch.id).TransactionBatchStatus__c != 'Release Transactions')){


		            Map<ID, Transaction__c> txMap = new Map<ID, Transaction__c>([SELECT id,
		            																	RecordTypeID
		    																	 FROM Transaction__c
		    																	 WHERE TransactionBatch__c = :txBatch.id]);

		            System.debug('txMap:'+txMap);
		            for(Transaction__c tx : txMap.values()){
		            	if(txToUpdate.containsKey(tx.id)){
		            		txToUpdate.get(tx.id).TransactionBatch__c = null;
	            		} else {
			            	txToUpdate.put(tx.id, new Transaction__c(id = tx.id,
			            											 TransactionBatch__c = null));	            			
	            		}
		            }            		
            	} else if(oldTransactionBatchMap!=null){
					if(txBatch.UpdateTransactionStatus__c != oldTransactionBatchMap.get(txBatch.id).UpdateTransactionStatus__c && String.isNotBlank(txBatch.UpdateTransactionStatus__c) ){


			            Map<ID, Transaction__c> txMap = new Map<ID, Transaction__c>([SELECT id,
			            																	RecordTypeID
			    																	 FROM Transaction__c
			    																	 WHERE TransactionBatch__c = :txBatch.id]);

			            System.debug('txMap:'+txMap);
			            for(Transaction__c tx : txMap.values()){
			            	if(txToUpdate.containsKey(tx.id)){
			            		txToUpdate.get(tx.id).Status__c = txBatch.UpdateTransactionStatus__c;
		            		} else {
				            	txToUpdate.put(tx.id, new Transaction__c(id = tx.id,
				            											 Status__c = txBatch.UpdateTransactionStatus__c));	            			
		            		}

			            }            		
	            	}
					if(txBatch.UpdateTransactionDate__c != oldTransactionBatchMap.get(txBatch.id).UpdateTransactionDate__c && (txBatch.UpdateTransactionDate__c != null) ){


			            Map<ID, Transaction__c> txMap = new Map<ID, Transaction__c>([SELECT id,
			            																	RecordTypeID
			    																	 FROM Transaction__c
			    																	 WHERE TransactionBatch__c = :txBatch.id]);

			            System.debug('txMap:'+txMap);
			            for(Transaction__c tx : txMap.values()){
			            	if(txToUpdate.containsKey(tx.id)){
			            		txToUpdate.get(tx.id).TransactionDate__c = txBatch.UpdateTransactionDate__c;
		            		} else {
				            	txToUpdate.put(tx.id, new Transaction__c(id = tx.id,
				            											 TransactionDate__c = txBatch.UpdateTransactionDate__c));	            			
		            		}

			            }            		
	            	}
					if(txBatch.UpdateConfirmed__c != oldTransactionBatchMap.get(txBatch.id).UpdateConfirmed__c && String.isNotBlank(txBatch.UpdateConfirmed__c) ){


			            Map<ID, Transaction__c> txMap = new Map<ID, Transaction__c>([SELECT id,
			            																	RecordTypeID
			    																	 FROM Transaction__c
			    																	 WHERE TransactionBatch__c = :txBatch.id]);

			            System.debug('txMap:'+txMap);
			            Boolean confirm;
			            if(txBatch.UpdateConfirmed__c == 'Confirmed') confirm = true;
			            if(txBatch.UpdateConfirmed__c == 'Not Confirmed') confirm = false;			            
			            for(Transaction__c tx : txMap.values()){
			            	if(txToUpdate.containsKey(tx.id)){
			            		txToUpdate.get(tx.id).Confirmed__c = confirm;
		            		} else {
				            	txToUpdate.put(tx.id, new Transaction__c(id = tx.id,
				            											 Confirmed__c = confirm));	            			
		            		}

			            }            		
	            	}
        		}            	
            }


            if(txToUpdate.size()>0){
                System.debug('txToUpdate:'+txToUpdate);
                update txToUpdate.values();
            }
            manageTransactionsHasRun = true;
        }
    }

    public class TransactionBatchTriggerHandlerException extends Exception {}
}