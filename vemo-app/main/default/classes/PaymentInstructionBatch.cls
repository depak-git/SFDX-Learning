public class PaymentInstructionBatch implements Database.Batchable<sObject>, Database.ALlowsCallouts{
	public enum JobType {SCHEDULE_INBOUND_ACH, SCHEDULE_OUTBOUND_ACH} 
	
	public String query {get;set;}
	public JobType job {get;set;}
	
	public PaymentInstructionBatch() {
		job = JobType.SCHEDULE_INBOUND_ACH;
	}
	public PaymentInstructionBatch(String query) {
		this.query = query;
		job = JobType.SCHEDULE_INBOUND_ACH;
	}	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('PaymentInstructionBatch.start()');
		if(job == JobType.SCHEDULE_INBOUND_ACH){
			if(String.isEmpty(this.query)){
				String dateToday = String.valueOf(Date.today());
				String tomorrow = String.valueOf(Date.today().addDays(1));
				query = 'SELECT id from PaymentInstruction__c WHERE (Status__c = \'Created By Student\' or Status__c = \'Automatically Created\')' + ' and TransactionDirection__c = \'Inbound\' and Date__c <= ' + tomorrow + ' ORDER BY Date__c ASC';
				//query = 'SELECT id, Date__c, Amount__c, Status__c from PaymentInstruction__c WHERE Status__c = \'None\' and Date__c <='+dateToday + ' ORDER BY Date__c ASC';
			}
		} else if(job == JobType.SCHEDULE_OUTBOUND_ACH){
			if(String.isEmpty(this.query)){
				String dateToday = String.valueOf(Date.today());
				query = 'SELECT id, Date__c, Amount__c, Status__c from PaymentInstruction__c WHERE Status__c = \'Created By Vemo\'' + 'and TransactionDirection__c = \'Outbound\' ORDER BY Date__c ASC';
				//query = 'SELECT id, Date__c, Amount__c, Status__c from PaymentInstruction__c WHERE Status__c = \'None\' and Date__c <='+dateToday + ' ORDER BY Date__c ASC';
			}
		}
		System.debug('job:'+job);
		System.debug('query:'+query);
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		System.debug('PaymentInstructionBatch.execute()');
		Set<ID> scopeIDs = new Set<ID>();
		for(sObject sobj : scope){
			scopeIDs.add(sobj.id);
		}

		if(job == JobType.SCHEDULE_INBOUND_ACH){
			Map<ID, PaymentInstruction__c> paymentInstructionMap = new Map<ID, PaymentInstruction__c>([SELECT id,
																											   Date__c,
																											   Amount__c,
																											   Status__c,
																											   Student__r.StewardshipPaymentDonorGUID__c,
																											   Student__c,
																											   PaymentMethod__r.StewardshipPaymentAccountGUID__c,
																											   PaymentMethod__c,
																											   Description__c
																	FROM PaymentInstruction__c
																	WHERE id = :scopeIDs
																	and TransactionDirection__c = 'Inbound'
																	and (Status__c = 'Created By Student' or Status__c = 'Automatically Created')
																	and PaymentMethod__r.StewardshipPaymentAccountGUID__c != null
																	and Student__r.StewardshipPaymentDonorGUID__c != null
																	ORDER BY Date__c asc]);
			System.debug('paymentInstructionMap:'+paymentInstructionMap);
			scheduleInboundACH(paymentInstructionMap);
		}
		if(job == JobType.SCHEDULE_OUTBOUND_ACH){
			Map<ID, PaymentInstruction__c> paymentInstructionMap = new Map<ID, PaymentInstruction__c>([SELECT id,
																											   Date__c,
																											   Amount__c,
																											   Status__c,
																											   Student__r.StewardshipPaymentDonorGUID__c,
																											   Student__r.StewardshipDisbursementDonorGUID__c,
																											   Student__c,
																											   PaymentMethod__r.StewardshipPaymentAccountGUID__c,
																											   PaymentMethod__r.StewardshipDisbursementAccountGUID__c,
																											   PaymentMethod__c,
																											   Description__c
																	FROM PaymentInstruction__c
																	WHERE id = :scopeIDs
																	and TransactionDirection__c = 'Outbound'
																	and Status__c = 'Created By Vemo'
																	and PaymentMethod__r.StewardshipPaymentAccountGUID__c != null
																	and Student__r.StewardshipPaymentDonorGUID__c != null
																	ORDER BY Date__c asc]);
			System.debug('paymentInstructionMap:'+paymentInstructionMap);
			scheduleOutboundACH(paymentInstructionMap);
		}
	}
	
	public void finish(Database.BatchableContext BC) {
		System.debug('PaymentInstructionBatch.finish()');		
	}
	
	private static void scheduleInboundACH(Map<ID, PaymentInstruction__c> paymentInstructionMap){
		System.debug('PaymentInstructionBatch.scheduleInboundACH()');
		Map<Date, List<PaymentInstruction__c>> paymentsByDate = new Map<Date, List<PaymentInstruction__c>>();
		Map<ID, PaymentInstruction__c> paymentsToUpdate = new Map<ID, PaymentInstruction__c>();

		Date earliestDate;
		Date latestDate;
		for(PaymentInstruction__c payment : paymentInstructionMap.values()){
			if(earliestDate == null || earliestDate > payment.Date__c) earliestDate = payment.Date__c;
			if(latestDate == null || latestDate < payment.Date__c) latestDate = payment.Date__c;
			if(!paymentsByDate.containsKey(payment.Date__c)){
				paymentsByDate.put(payment.Date__c, new List<PaymentInstruction__c>());
			}
			paymentsByDate.get(payment.Date__c).add(payment);
		}
		System.debug('earliestDate:'+earliestDate);
		System.debug('latestDate:'+latestDate);

		List<StewardshipACHBatch__c> batches = [SELECT id, ScheduledDate__c, BatchGUID__c
												FROM StewardshipACHBatch__c 
												WHERE ScheduledDate__c >= : earliestDate and ScheduledDate__c <= :latestDate and 
												BankAccount__c = 'Payments' and BatchType__c = 'Payment (Incoming Money)' and Status__c = 'Created'];
		Map<Date, List<StewardshipACHBatch__c>> batchesByDate = new Map<Date, List<StewardshipACHBatch__c>>();
		for(StewardshipACHBatch__c btch : batches){
			if(!batchesByDate.containsKey(btch.ScheduledDate__c)){
				batchesByDate.put(btch.ScheduledDate__c, new List<StewardshipACHBatch__c>());
			}
			batchesByDate.get(btch.ScheduledDate__c).add(btch);
		}

		List<StewardshipACHBatch__c> batchesToCreate = new List<StewardshipACHBatch__c>();
		List<StewardshipACHBatchDetail__c> batchDetailsToCreate = new List<StewardshipACHBatchDetail__c>();
		//Schema.SObjectField externalID = StewardshipACHBatch__c.Fields.BatchGUID__c;		
		for(Date theDate : paymentsByDate.keySet()){
			if(!batchesByDate.containsKey(theDate)){
				//Create the Batch before Adding the Lines

				StewardshipTechService.PaymentBatchOpenResponse response = StewardshipTechService.PaymentBatchOpen(StewardshipTechService.AccountType.PAYMENT);
				StewardshipACHBatch__c newBatch = new StewardshipACHBatch__c(BankAccount__c = 'Payments',
															   BatchGUID__c = response.Root.BatchGUID,
															   BatchType__c = 'Payment (Incoming Money)',
															   ScheduledDate__c = theDate,
															   StewardshipProcess__c = 'PaymentBatch Created',
															   Status__c = 'Created');
				batchesToCreate.add(newBatch);
				batchesByDate.put(theDate, new List<StewardshipACHBatch__c>());
				batchesByDate.get(theDate).add(newBatch);					


			}
			if(batchesByDate.containsKey(theDate)){
				//Add the scheduled transactions to the Batch

				if(paymentsByDate.containsKey(theDate)){
					for(PaymentInstruction__c payment : paymentsByDate.get(theDate)){
						try{
							Date dateToSchedule = (theDate < Date.today() ? Date.today() : theDate);
							System.debug('dateToSchedule:'+dateToSchedule);

							StewardshipTechService.CreateTransactionRequest input = new StewardshipTechService.CreateTransactionRequest();
							input.BatchGUID = batchesByDate.get(theDate)[0].BatchGUID__c;
							input.DonorGUID = payment.Student__r.StewardshipPaymentDonorGUID__c;
							input.AccountGUID = payment.PaymentMethod__r.StewardshipPaymentAccountGUID__c;
							input.Amount1 = payment.Amount__c;
							input.Memo1 = payment.Description__c;
							input.RecurringType = '1';
							input.ScheduledDate = dateToSchedule;//theDate;
						
							StewardshipTechService.CreateTransactionResponse response = StewardshipTechService.CreateTransaction(StewardshipTechService.AccountType.PAYMENT, input);
						

							StewardshipACHBatch__c batchReference = new StewardshipACHBatch__c(BatchGUID__c = batchesByDate.get(theDate)[0].BatchGUID__c);
							StewardshipACHBatchDetail__c newBatchDetail = new StewardshipACHBatchDetail__c(StewardshipACHBatch__r = batchReference,
																										  AccountScheduleGUID__c = response.Root.Transaction_x.AccountScheduleGUID,
							                                                                              StewardshipProcess__c = 'Created',
							                                                                              StewardshipStatus__c = 'Created',
							                                                                              RecurringType__c = '1 - One Time Non Recurring',
							                                                                              DonorGUID__c = payment.Student__r.StewardshipPaymentDonorGUID__c,
							                                                                              AccountGUID__c = payment.PaymentMethod__r.StewardshipPaymentAccountGUID__c,
							                                                                              Account__c = payment.Student__c,
							                                                                              PaymentMethod__c = payment.PaymentMethod__c,
							                                                                              BatchGUID__c = batchesByDate.get(theDate)[0].BatchGUID__c,
							                                                                              PaymentInstruction__c = payment.id,
							                                                                              TransactionType__c = 'Payment (Incoming Money)',
							                                                                              Amount__c = payment.Amount__c,
							                                                                              Memo__c = payment.Description__c,
							                                                                              ScheduledDate__c = dateToSchedule/*theDate*/);
							batchDetailsToCreate.add(newBatchDetail);
							paymentsToUpdate.put(payment.id, new PaymentInstruction__c(id = payment.id,
																					   Status__c = 'Scheduled'));


						} catch (Exception e){
							LogService.debug('Error Creating Batch Detail Record:'+e.getMessage(), payment.id);
						}
					}
				}
			} 
		}

		if(batchesToCreate.size()>0){
			Database.insert(batchesToCreate, false);
		}

		if(batchDetailsToCreate.size()>0){
			Database.insert(batchDetailsToCreate, false);
		}

		if(paymentsToUpdate.size()>0){
			Database.update(paymentsToUpdate.values(),false);
		}

		LogService.writeLogs();
	}
	private static void scheduleOutboundACH(Map<ID, PaymentInstruction__c> paymentInstructionMap){
		System.debug('PaymentInstructionBatch.scheduleOutboundACH()');
		Map<Date, List<PaymentInstruction__c>> paymentsByDate = new Map<Date, List<PaymentInstruction__c>>();
		Map<ID, PaymentInstruction__c> paymentsToUpdate = new Map<ID, PaymentInstruction__c>();

		Date earliestDate;
		Date latestDate;
		for(PaymentInstruction__c payment : paymentInstructionMap.values()){
			if(earliestDate == null || earliestDate > payment.Date__c) earliestDate = payment.Date__c;
			if(latestDate == null || latestDate < payment.Date__c) latestDate = payment.Date__c;
			if(!paymentsByDate.containsKey(payment.Date__c)){
				paymentsByDate.put(payment.Date__c, new List<PaymentInstruction__c>());
			}
			paymentsByDate.get(payment.Date__c).add(payment);
		}
		System.debug('earliestDate:'+earliestDate);
		System.debug('latestDate:'+latestDate);

		List<StewardshipACHBatch__c> batches = [SELECT id, ScheduledDate__c, BatchGUID__c
												FROM StewardshipACHBatch__c 
												WHERE ScheduledDate__c >= : earliestDate and ScheduledDate__c <= :latestDate and 
												BankAccount__c = 'Disbursements' and BatchType__c = 'Credit (Outgoing Money)'];
		Map<Date, List<StewardshipACHBatch__c>> batchesByDate = new Map<Date, List<StewardshipACHBatch__c>>();
		for(StewardshipACHBatch__c btch : batches){
			if(!batchesByDate.containsKey(btch.ScheduledDate__c)){
				batchesByDate.put(btch.ScheduledDate__c, new List<StewardshipACHBatch__c>());
			}
			batchesByDate.get(btch.ScheduledDate__c).add(btch);
		}

		List<StewardshipACHBatch__c> batchesToCreate = new List<StewardshipACHBatch__c>();
		List<StewardshipACHBatchDetail__c> batchDetailsToCreate = new List<StewardshipACHBatchDetail__c>();
		//Schema.SObjectField externalID = StewardshipACHBatch__c.Fields.BatchGUID__c;		
		for(Date theDate : paymentsByDate.keySet()){
			if(!batchesByDate.containsKey(theDate)){
				//Create the Batch before Adding the Lines

				StewardshipTechService.CreditBatchOpenRequest input = new StewardshipTechService.CreditBatchOpenRequest();
				input.ScheduledDate = theDate;


				StewardshipTechService.CreditBatchOpenResponse response = StewardshipTechService.CreditBatchOpen(StewardshipTechService.AccountType.DISBURSEMENT, input);
				StewardshipACHBatch__c newBatch = new StewardshipACHBatch__c(BankAccount__c = 'Disbursements',
															   BatchGUID__c = response.Root.BatchGUID,
															   BatchType__c = 'Credit (Outgoing Money)',
															   ScheduledDate__c = theDate,
															   StewardshipProcess__c = 'CreditBatch Created');
				batchesToCreate.add(newBatch);
				batchesByDate.put(theDate, new List<StewardshipACHBatch__c>());
				batchesByDate.get(theDate).add(newBatch);
			}
			if(batchesByDate.containsKey(theDate)){
				//Add the scheduled transactions to the Batch

				if(paymentsByDate.containsKey(theDate)){
					for(PaymentInstruction__c payment : paymentsByDate.get(theDate)){
						StewardshipTechService.CreateCreditTransactionRequest input = new StewardshipTechService.CreateCreditTransactionRequest();
						input.BatchGUID = batchesByDate.get(theDate)[0].BatchGUID__c;
						input.DonorGUID = payment.Student__r.StewardshipDisbursementDonorGUID__c;
						input.AccountGUID = payment.PaymentMethod__r.StewardshipDisbursementAccountGUID__c;
						input.Amount = payment.Amount__c;
						input.Memo = payment.Description__c;
						input.CompanyEntryDescription = 'Credit DISBURSEMENT Account';

					
						StewardshipTechService.CreateCreditTransactionResponse response = StewardshipTechService.CreateCreditTransaction(StewardshipTechService.AccountType.DISBURSEMENT, input);
					

						StewardshipACHBatch__c batchReference = new StewardshipACHBatch__c(BatchGUID__c = batchesByDate.get(theDate)[0].BatchGUID__c);
						StewardshipACHBatchDetail__c newBatchDetail = new StewardshipACHBatchDetail__c(StewardshipACHBatch__r = batchReference,
																									  AccountScheduleGUID__c = response.Root.Transaction_x.AccountScheduleGUID,
						                                                                              StewardshipProcess__c = 'Created',
						                                                                              StewardshipStatus__c = 'Created',
						                                                                              RecurringType__c = '1 - One Time Non Recurring',
						                                                                              DonorGUID__c = payment.Student__r.StewardshipDisbursementDonorGUID__c,
						                                                                              AccountGUID__c = payment.PaymentMethod__r.StewardshipDisbursementAccountGUID__c,
						                                                                              Account__c = payment.Student__c,
						                                                                              PaymentMethod__c = payment.PaymentMethod__c,
						                                                                              BatchGUID__c = batchesByDate.get(theDate)[0].BatchGUID__c,
						                                                                              PaymentInstruction__c = payment.id,
						                                                                              TransactionType__c = 'Credit (Outgoing Money)',
						                                                                              Amount__c = payment.Amount__c,
						                                                                              Memo__c = payment.Description__c,
						                                                                              ScheduledDate__c = theDate);
						batchDetailsToCreate.add(newBatchDetail);
						paymentsToUpdate.put(payment.id, new PaymentInstruction__c(id = payment.id,
																				   Status__c = 'Scheduled'));

					}
				}
			} 
		}

		if(batchesToCreate.size()>0){
			insert batchesToCreate;
		}

		if(batchDetailsToCreate.size()>0){
			insert batchDetailsToCreate;
		}

		if(paymentsToUpdate.size()>0){
			update paymentsToUpdate.values();
		}
	}
}