/////////////////////////////////////////////////////////////////////////
// Class: PaymentAllocationService
// 
// Description: 
// 	Handles all Agreement Service DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-10   Greg Cook       Created               
/////////////////////////////////////////////////////////////////////////
public with sharing class PaymentAllocationService {
	public class PaymentAllocation{
		AllocatedFee fee {get;set;}
		AllocatedAgreement agreement {get;set;}
	}
	public class PaymentInstruction{
		public ID paymentInstructionID {get;set;}
		public Decimal paymentAmount {get;set;}
		public Decimal remainingAllocation {get;set;}
		public List<PaymentAllocation> allocations {get;set;}

	}
	public class AllocatedFee{
		Decimal amount {get;set;}
	}
	public class AllocatedAgreement{
		String agreementID {get;set;}
		Decimal amount {get;set;}
		String type {get;set;}
	}

	public static List<PaymentInstruction> allocatePayment(ID paymentInstructionID, Boolean proofMode){
		return null;
// 		//THis is only able to operate on one paymentInstruction at a time as it needs to update the database and requery after each allocaiton in complete.
// 		//The best way to run this would be from a batch job set to a scope of 1 record or via a button on a payment instruciton screen
// 		List<PaymentInstruction> returnData = new List<PaymentInstruction>();
// 		String logEntry = 'PaymentAllocationService.allocatePayment()';
// 		////////////////////////////////////////////////////////////////////
// 		//GET ALL REQUIRED DATA STRUCTURES FOR ALLOCATIONS
// 		////////////////////////////////////////////////////////////////////		
// 		Map<ID, PaymentInstruction__c> paymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentInstructionID(new Set<ID>{paymentInstructionID});
// 		Map<ID, PaymentInstruction__c> paymentToAllocateMap = new Map<ID, PaymentInstruction__c>();
// 		Set<ID> studentIDs = new Set<ID>();
// 		Set<ID> studentContactIDs = new Set<ID>();

// 		//Set<ID> agreementIDs = new Set<ID>();


// 		for(PaymentInstruction__c payment : paymentInstructionMap.values()){
// 			if(!payment.fullyAllocated__c){
// 				paymentToAllocateMap.put(payment.id, payment);
// 				studentIDs.add(payment.Student__c);
// 				//agreementIDs.add(payment.Agreement__c);
// 			}
// 		}

// //		List<StudentService.Student> students = StudentService.getStudentsWithStudentID(studentIDs);
// //		Map<ID, StudentService.Student> studentMap = new Map<ID, StudentService.Student>();
// //		for(StudentService.Student student : students){
// //			studentMap.put(student.personAccountID, student);
// //		}

// 		Map<ID, Account> studentAccountMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
// 		for(Account student : studentAccountMap.values()){
// 			studentContactIDs.add(student.PersonContactID);
// 		}

// 		Map<ID, List<PaymentInstruction__c>> paymentsByStudent = new Map<ID, List<PaymentInstruction__c>>();
// 		for(PaymentInstruction__c payment : paymentToAllocateMap.values()){
// 			if(!paymentsByStudent.containsKey(payment.Student__c)){
// 				paymentsByStudent.put(payment.Student__c, new List<PaymentInstruction__c>());
// 			}
// 			paymentsByStudent.get(payment.Student__c).add(payment);
// 		}

// 		//Get all Agreements for these students
// 		List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithStudentID(studentIDs);
// 		agreements.sort();
// 		System.debug('sorted agreements:'+ agreements);
// 		AgreementService.determineAmountsDue(agreements);
// 		Map<ID, List<AgreementService.Agreement>> agreementsByStudent = new Map<ID, List<AgreementService.Agreement>>();
// 		for(AgreementService.Agreement agree : agreements){
// 			if(!agreementsByStudent.containsKey(agree.studentID)){
// 				agreementsByStudent.put(agree.studentID, new List<AgreementService.Agreement>());
// 			}
// 			agreementsByStudent.get(agree.studentID).add(agree);
// 		}

// 		//Get all Open Allocation Cases for these students
// 		Map<ID, Case> openCaseMap = new Map<ID, Case>([SELECT id,
// 															  RecordTypeID,
// 															  ContactID,
// 															  Subject
// 													   FROM Case
// 													   WHERE RecordTypeID = :GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT) and
// 													   		 ContactID IN :studentContactIDs and 
// 													   		 Status != 'Closed' and
// 													   		 PaymentInstruction__c != null]);
// 		System.debug('openCaseMap:'+openCaseMap);
// 		Map<ID, List<Case>> casesByContactID = new Map<ID, List<Case>>();
// 		for(Case cse : openCaseMap.values()){
// 			if(!casesByContactID.containsKey(cse.ContactID)){
// 				casesByContactID.put(cse.ContactID, new List<Case>());
// 			}
// 			casesByContactID.get(cse.ContactID).add(cse);
// 		}



// /*
// 			                       casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
// 		                            ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
// 		                            Subject = 'Not enough funds on payment instruction to pay all open fees',
// 		                            Status = 'New',
// 		                            Priority = 'Medium',
// 		                            Reason = 'Other',
// 		                            OwnerId=GlobalUtil.getQueueId('Servicing'),
// 		                            Type = 'Problem',                                   
// 		                            Origin = 'Other',
// 		                            PaymentInstruction__c = payment.id));*/



// 		//Get All Fees for these students
// 		Map<ID, Fee__c> feeMap = new Map<ID, Fee__c>([SELECT id, Amount__c, Customer__c, DateAssessed__c, DateCleared__c, Status__c, Type__c
// 													   FROM Fee__c
// 													   WHERE Customer__c IN : studentIDs
// 													   and Status__c = 'Unpaid'
// 													   order by DateAssessed__c asc]);
// 		System.debug(feeMap);
// 		Map<ID, List<Fee__c>> feesByStudent = new Map<ID, List<Fee__c>>();
// 		for(Fee__c fee : feeMap.values()){
// 			if(!feesByStudent.containsKey(fee.Customer__c)){
// 				feesByStudent.put(fee.Customer__c, new List<Fee__c>());
// 			}
// 			feesByStudent.get(fee.Customer__c).add(fee);
// 		}
// 		System.debug(feesByStudent);

// 		List<Case> casesToCreate = new List<Case>();
// 		List<PaymentAllocation__c> paymentAllocationsToCreate = new List<PaymentAllocation__c>();
// 		Map<ID, Fee__c> feesToUpdate = new Map<ID, Fee__c>();


// 		////////////////////////////////////////////////////////////////////
// 		//Main Loop
// 		////////////////////////////////////////////////////////////////////
// 		Boolean continueAllocationProcess = true;	
// 		for(PaymentInstruction__c payment : paymentToAllocateMap.values()){
// 			if(continueAllocationProcess){
// 				//Decimal remainingToAllocate = payment.RemainingAllocation__c;

// 				PaymentInstruction paymentInst = new PaymentInstruction();
// 				paymentInst.paymentAmount = payment.Amount__c;
// 				paymentInst.remainingAllocation = payment.RemainingAllocation__c;
// 				System.debug('remainingToAllocate:'+paymentInst.remainingAllocation);
// 				paymentInst.paymentInstructionID = payment.id;
// 				paymentInst.allocations = new List<PaymentAllocation>();

// 				////////////////////////////////////////////////////////////////////
// 				//Pay all Fees First Starting with the Earliest
// 				////////////////////////////////////////////////////////////////////	
// 				//Look for any unpaid fees on this student that are less than or equal to the payment amount
// 				if(feesByStudent.containsKey(payment.Student__c)){
// 					System.debug('Fees');
// 					for(Fee__c fee : feesByStudent.get(payment.Student__c)){
// 						if(continueAllocationProcess){
// 							if(fee.Status__c == 'Unpaid'){ //don't pick up the unpaid fees a second time
// 								if(fee.Amount__c <= paymentInst.remainingAllocation){
// 									System.debug('pay this fee in full:'+ fee);
// 									paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Fee',
// 																							Fee__c = fee.id,
// 																							AmountAllocated__c = fee.Amount__c,
// 																							PaymentInstruction__c = payment.id));
// 									fee.DateCleared__c = Date.today();
// 									fee.Status__c = 'Paid';
// 									feesToUpdate.put(fee.id, fee);
// 									paymentInst.remainingAllocation -= fee.Amount__c;
// 									AllocatedFee allocFee = new AllocatedFee();
// 									allocFee.amount = fee.Amount__c;
// 									PaymentAllocation paymentAlloc = new PaymentAllocation();
// 									paymentAlloc.fee = allocFee;
// 									paymentInst.allocations.add(paymentAlloc);

// 								} else {
// 									if(!casesByContactID.containsKey(studentAccountMap.get(payment.Student__c).PersonContactID)){
// 										//only create a new case if nothing else exists

// 										//not enough money on payment instruction to pay remaining fee - raise a case for servicing
// 										//this will create a case at each payment instruction - if there are multiple payment instructions for the same student a case would
// 										//still be created - so this would need to be refactored to only add a case if allpayments for the student were done being allocated
// 				                       casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
// 			                            ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
// 			                            Subject = 'Not enough funds on payment instruction to pay all open fees',
// 			                            Status = 'New',
// 			                            Priority = 'Medium',
// 			                            Reason = 'Other',
// 			                            OwnerId=GlobalUtil.getQueueId('Servicing'),
// 			                            Type = 'Problem',                                   
// 			                            Origin = 'Other',
// 			                            PaymentInstruction__c = payment.id));

// 									}
// 			                       	continueAllocationProcess = false;
// 								}

// 							}

// 						}
// 					}
// 				}


// 				////////////////////////////////////////////////////////////////////
// 				//Next Pay Past Due Reconciliations - Oldest Contract first
// 				////////////////////////////////////////////////////////////////////	
// 				if(continueAllocationProcess){
// 					System.debug('Past Due Reconciliations Amounts');
// 					if(agreementsByStudent.containsKey(payment.Student__c)){
// 						for(AgreementService.Agreement agree : agreementsByStudent.get(payment.Student__c)){
// 							System.debug('agree:'+agree);
// 							if(agree.reconciliationPastDue > 0){
// 								//allocate to this reconciliation
// 								Decimal allocation = 0;
// 								allocation = (paymentInst.remainingAllocation > agree.reconciliationPastDue ? agree.reconciliationPastDue : paymentInst.remainingAllocation);
// 								if(allocation>0){
// 									System.debug('Allocate to Past Due Reconciliation:'+allocation);
// 									paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Reconciliation',
// 																							Agreement__c = agree.agreementID,
// 																							AmountAllocated__c = allocation,
// 																							PaymentInstruction__c = payment.id,
// 																							Detail__c = 'Past Due Reconciliation'));
// 									paymentInst.remainingAllocation -= allocation;
// 									AllocatedAgreement allocAgreement = new AllocatedAgreement();
// 									allocAgreement.amount = allocation;
// 									allocAgreement.type = 'Past Due Reconciliation';
// 									allocAgreement.agreementID = agree.agreementID;
// 									PaymentAllocation paymentAlloc = new PaymentAllocation();
// 									paymentAlloc.agreement = allocAgreement;
// 									paymentInst.allocations.add(paymentAlloc);										
// 								}
// 							}
// 						}
// 					}
// 				}

// 				////////////////////////////////////////////////////////////////////
// 				//Next Pay Current Reconciliations - Oldest Contract first
// 				////////////////////////////////////////////////////////////////////
// 				if(continueAllocationProcess){
// 					System.debug('Current Reconciliations Amounts');
// 					if(agreementsByStudent.containsKey(payment.Student__c)){
// 						for(AgreementService.Agreement agree : agreementsByStudent.get(payment.Student__c)){
// 							System.debug('agree:'+agree);
// 							if(agree.reconciliationCurrentDue > 0){
// 								//allocate to this reconciliation
// 								Decimal allocation = 0;
// 								allocation = (paymentInst.remainingAllocation > agree.reconciliationCurrentDue ? agree.reconciliationCurrentDue : paymentInst.remainingAllocation);
// 								if(allocation>0){
// 									System.debug('Allocate to Current Reconciliation:'+allocation);
// 									paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Reconciliation',
// 																							Agreement__c = agree.agreementID,
// 																							AmountAllocated__c = allocation,
// 																							PaymentInstruction__c = payment.id,
// 																							Detail__c = 'Current Due Reconciliation'));
// 									paymentInst.remainingAllocation -= allocation;
// 									AllocatedAgreement allocAgreement = new AllocatedAgreement();
// 									allocAgreement.amount = allocation;
// 									allocAgreement.type = 'Current Due Reconciliation';
// 									allocAgreement.agreementID = agree.agreementID;								
// 									PaymentAllocation paymentAlloc = new PaymentAllocation();
// 									paymentAlloc.agreement = allocAgreement;
// 									paymentInst.allocations.add(paymentAlloc);											
// 								}								
// 							}
// 						}
// 					}
// 				}
// 				////////////////////////////////////////////////////////////////////
// 				//Next Pay Past Due Monthly Amounts - Oldest Contract first
// 				////////////////////////////////////////////////////////////////////	
// 				if(continueAllocationProcess){
// 					System.debug('Past Due Monthly Amounts');
// 					if(agreementsByStudent.containsKey(payment.Student__c)){
// 						for(AgreementService.Agreement agree : agreementsByStudent.get(payment.Student__c)){
// 							System.debug('agree:'+agree);
// 							if(agree.monthlyAmountPastDue > 0){
// 								//allocate to this reconciliation
// 								Decimal allocation = 0;
// 								allocation = (paymentInst.remainingAllocation > agree.monthlyAmountPastDue ? agree.monthlyAmountPastDue : paymentInst.remainingAllocation);
// 								if(allocation>0){
// 									System.debug('Allocate to Past Due Monthly Amounts:'+allocation);
// 									paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Monthly Amount',
// 																							Agreement__c = agree.agreementID,
// 																							AmountAllocated__c = allocation,
// 																							PaymentInstruction__c = payment.id,
// 																							Detail__c = 'Monthly Amount Past Due'));
// 									paymentInst.remainingAllocation -= allocation;
// 									AllocatedAgreement allocAgreement = new AllocatedAgreement();
// 									allocAgreement.amount = allocation;
// 									allocAgreement.type = 'Monthly Amount Past Due';
// 									allocAgreement.agreementID = agree.agreementID;
// 									PaymentAllocation paymentAlloc = new PaymentAllocation();
// 									paymentAlloc.agreement = allocAgreement;
// 									paymentInst.allocations.add(paymentAlloc);											
// 								}
// 							}
// 						}
// 					}
// 				}
// 				////////////////////////////////////////////////////////////////////
// 				//Next Pay Current Monthly Amounts - Oldest Contract first
// 				////////////////////////////////////////////////////////////////////
// 				if(continueAllocationProcess){
// 					System.debug('Current Monthly Amounts');
// 					if(agreementsByStudent.containsKey(payment.Student__c)){
// 						Boolean remainingCurrentAmount = false;
// 						System.debug('remainingCurrentAmount = false - entering loop');
// 						for(AgreementService.Agreement agree : agreementsByStudent.get(payment.Student__c)){
// 							System.debug('agree:'+agree);
// 							if(agree.monthlyAmountCurrentDue > 0){
// 								remainingCurrentAmount = true;
// 								//allocate to this reconciliation
// 								Decimal allocation = 0;
// 								allocation = (paymentInst.remainingAllocation >= agree.monthlyAmountCurrentDue ? agree.monthlyAmountCurrentDue : paymentInst.remainingAllocation);
// 								if(allocation>0){
// 									System.debug('Allocate to Current Month Due:'+allocation);
// 									paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Monthly Amount',
// 																							Agreement__c = agree.agreementID,
// 																							AmountAllocated__c = allocation,
// 																							PaymentInstruction__c = payment.id,
// 																							Detail__c = 'Monthly Amount Current Due'));
// 									paymentInst.remainingAllocation -= allocation;
// 									AllocatedAgreement allocAgreement = new AllocatedAgreement();
// 									allocAgreement.amount = allocation;
// 									allocAgreement.type = 'Monthly Amount Current Due';
// 									allocAgreement.agreementID = agree.agreementID;
// 									PaymentAllocation paymentAlloc = new PaymentAllocation();
// 									paymentAlloc.agreement = allocAgreement;
// 									paymentInst.allocations.add(paymentAlloc);
// 									System.debug('adding allocation:'+paymentAlloc);										
// 								}
// 								System.debug('allocation:'+allocation);
// 								System.debug('agree.monthlyAmountCurrentDue'+agree.monthlyAmountCurrentDue);
// 								if(agree.monthlyAmountCurrentDue > allocation){
// 									remainingCurrentAmount = true;
// 									System.debug('remainingCurrentAmount = true');
// 								} else {
// 									remainingCurrentAmount = false;
// 									System.debug('remainingCurrentAmount = false');
// 								}
// 							}
// 						}
// 						if(remainingCurrentAmount){
// 							System.debug('Create the case');
// 							if(!casesByContactID.containsKey(studentAccountMap.get(payment.Student__c).PersonContactID)){
// 								//only create a new case if nothing else exists

// 		                       casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
// 	                            ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
// 	                            Subject = 'Underpayment of current amount due',
// 	                            Status = 'New',
// 	                            Priority = 'Medium',
// 	                            Reason = 'Other',
// 	                            OwnerId=GlobalUtil.getQueueId('Servicing'),
// 	                            Type = 'Problem',                                   
// 	                            Origin = 'Other',
// 	                            PaymentInstruction__c = payment.id));

// 							}	
// 	                       	continueAllocationProcess = false;													
// 						}
// 					}
// 				}

// 				////////////////////////////////////////////////////////////////////
// 				//Any remaining amount to be allocated
// 				////////////////////////////////////////////////////////////////////
// 				if(continueAllocationProcess){
// 					System.debug('Overpayment');
// 					if(paymentInst.remainingAllocation > 0){
// 						if(!casesByContactID.containsKey(studentAccountMap.get(payment.Student__c).PersonContactID)){
// 							//only create a new case if nothing else exists

// 							//not enough money on payment instruction to pay remaining fee - raise a case for servicing
// 							//this will create a case at each payment instruction - if there are multiple payment instructions for the same student a case would
// 							//still be created - so this would need to be refactored to only add a case if allpayments for the student were done being allocated
// 	                       casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
//                             ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
//                             Subject = 'Overpayment',
//                             Status = 'New',
//                             Priority = 'Medium',
//                             Reason = 'Other',
//                             OwnerId=GlobalUtil.getQueueId('Servicing'),
//                             Type = 'Problem',                                   
//                             Origin = 'Other',
//                             PaymentInstruction__c = payment.id));

// 						}	
// 						continueAllocationProcess = false;					
// 					}
// 				}


// 				////////////////////////////////////////////////////////////////////
// 				//Any Remainder of the Payment Should be credited to account or pre-allocated
// 				//to agreements in the future
// 				////////////////////////////////////////////////////////////////////					

// 				returnData.add(paymentInst);
				
// 				logEntry += '\n PaymentInstructionAmount: '+ paymentInst.paymentAmount;
// 				logEntry += '\n PaymentInstructionID: ' + paymentInst.paymentInstructionID;
// 				logEntry += '\n PaymentInstructionRemainingAllocation: '+ paymentInst.remainingAllocation;
// 				for(PaymentAllocation pa : paymentInst.allocations){
// 					logEntry += '\n PaymentAllocation: '+pa;
// 				}				
// 				LogService.debug(logEntry, payment.id);
// 				logEntry = '';
// 			}

// 		}
// 		LogService.writeLogs();


// 		////////////////////////////////////////////////////////////////////
// 		//Update Tables 
// 		////////////////////////////////////////////////////////////////////	
// 		if(!proofMode){
// 			if(paymentAllocationsToCreate.size()>0){
// 				System.debug(paymentAllocationsToCreate);
// 				insert paymentAllocationsToCreate;
// 			}
// 			if(feesToUpdate.size()>0){
// 				System.debug(feesToUpdate);
// 				update feesToUpdate.values();
// 			}
// 			if(casesToCreate.size()>0){
// 				insert casesToCreate;
// 			}			
// 		}
// 		System.debug(returnData);
// 		return returnData;
	}

	public static List<PaymentInstruction> allocatePaymentV2(ID paymentInstructionID, Boolean proofMode){

		//override v2 until data conversion is ready
//		return allocatePayment(paymentInstructionID, proofMode);
		//THis is only able to operate on one paymentInstruction at a time as it needs to update the database and requery after each allocaiton in complete.
		//The best way to run this would be from a batch job set to a scope of 1 record or via a button on a payment instruciton screen
		List<PaymentInstruction> returnData = new List<PaymentInstruction>();
		String logEntry = 'PaymentAllocationService.allocatePaymentV2()';
		////////////////////////////////////////////////////////////////////
		//GET ALL REQUIRED DATA STRUCTURES FOR ALLOCATIONS
		////////////////////////////////////////////////////////////////////		
		Map<ID, PaymentInstruction__c> paymentInstructionMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentInstructionID(new Set<ID>{paymentInstructionID});
		Map<ID, PaymentInstruction__c> paymentToAllocateMap = new Map<ID, PaymentInstruction__c>();
		Set<ID> studentIDs = new Set<ID>();
		Set<ID> studentContactIDs = new Set<ID>();



		for(PaymentInstruction__c payment : paymentInstructionMap.values()){
			if(!payment.fullyAllocated__c){
				paymentToAllocateMap.put(payment.id, payment);
				studentIDs.add(payment.Student__c);
			}
		}



		Map<ID, Account> studentAccountMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
		for(Account student : studentAccountMap.values()){
			studentContactIDs.add(student.PersonContactID);
		}

		Map<ID, List<PaymentInstruction__c>> paymentsByStudent = new Map<ID, List<PaymentInstruction__c>>();
		for(PaymentInstruction__c payment : paymentToAllocateMap.values()){
			if(!paymentsByStudent.containsKey(payment.Student__c)){
				paymentsByStudent.put(payment.Student__c, new List<PaymentInstruction__c>());
			}
			paymentsByStudent.get(payment.Student__c).add(payment);
		}

		//Get all Agreements for these students
		List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithStudentID(studentIDs);
		agreements.sort();
		System.debug('sorted agreements:'+ agreements);
		AgreementService.determineAmountsDue(agreements);
		Map<ID, List<AgreementService.Agreement>> agreementsByStudent = new Map<ID, List<AgreementService.Agreement>>();

		Set<ID> agreementIDs = new Set<ID>();
		for(AgreementService.Agreement agree : agreements){
			agreementIDs.add(agree.agreementID);
			if(!agreementsByStudent.containsKey(agree.studentID)){
				agreementsByStudent.put(agree.studentID, new List<AgreementService.Agreement>());
			}
			agreementsByStudent.get(agree.studentID).add(agree);
		}

		//Get all Open Allocation Cases for these students
		Map<ID, Case> openCaseMap = new Map<ID, Case>([SELECT id,
															  RecordTypeID,
															  ContactID,
															  Subject
													   FROM Case
													   WHERE RecordTypeID = :GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT) and
													   		 ContactID IN :studentContactIDs and 
													   		 Status != 'Closed' and
													   		 PaymentInstruction__c != null]);
		System.debug('openCaseMap:'+openCaseMap);
		Map<ID, List<Case>> casesByContactID = new Map<ID, List<Case>>();
		for(Case cse : openCaseMap.values()){
			if(!casesByContactID.containsKey(cse.ContactID)){
				casesByContactID.put(cse.ContactID, new List<Case>());
			}
			casesByContactID.get(cse.ContactID).add(cse);
		}

		//Get All Fees for these students
		Map<ID, Fee__c> feeMap = new Map<ID, Fee__c>([SELECT id, Amount__c, Customer__c, DateAssessed__c, DateCleared__c, Status__c, Type__c
													   FROM Fee__c
													   WHERE Customer__c IN : studentIDs
													   and Status__c = 'Unpaid'
													   order by DateAssessed__c asc]);
		System.debug(feeMap);
		Map<ID, List<Fee__c>> feesByStudent = new Map<ID, List<Fee__c>>();
		for(Fee__c fee : feeMap.values()){
			if(!feesByStudent.containsKey(fee.Customer__c)){
				feesByStudent.put(fee.Customer__c, new List<Fee__c>());
			}
			feesByStudent.get(fee.Customer__c).add(fee);
		}
		System.debug(feesByStudent);

		List<Case> casesToCreate = new List<Case>();
		List<PaymentAllocation__c> paymentAllocationsToCreate = new List<PaymentAllocation__c>();
		List<PaymentAllocationDetail__c> paymentAllocationDetailsToCreate = new List<PaymentAllocationDetail__c>();
		Map<ID, Fee__c> feesToUpdate = new Map<ID, Fee__c>();

		//Get all the amount due records for 
		Map<ID, StudentProgramAmountDue__c> amountDueMap = new Map<ID, StudentProgramAmountDue__c>([SELECT id,
																										   Agreement__c,
																										   Amount__c,
																										   AmountAllocated__c,
																										   AssessmentDateTime__c,
																										   ExcludeFromBalance__c,
																										   FullyAllocated__c,
																										   RemainingAllocation__c,
																										   StudentProgramMonthlyStatus__c,
																										   Type__c
																								    FROM StudentProgramAmountDue__c
																								    WHERE Agreement__c in :agreementIDs and
																								    	  FullyAllocated__c = false
																								    Order BY AssessmentDateTime__c ASC,
																											 Agreement__r.CertificationDate__c ASC, 
																											 Agreement__r.SubmittedDate__c ASC]);

		Map<ID, StudentProgramAmountDue__c> pastDueReconciliation = new Map<ID, StudentProgramAmountDue__c>();
		Map<ID, StudentProgramAmountDue__c> currentReconciliation = new Map<ID, StudentProgramAmountDue__c>();
		Map<ID, StudentProgramAmountDue__c> pastDueAmountDue = new Map<ID, StudentProgramAmountDue__c>();
		Map<ID, StudentProgramAmountDue__c> currentAmountDue = new Map<ID, StudentProgramAmountDue__c>();

		System.debug(amountDueMap);
		for(StudentProgramAmountDue__c amountDue : amountDueMap.values()){
			System.debug('Date.today().month():'+Date.today().month());
			System.debug('amountDue.AssessmentDateTime__c:'+amountDue.AssessmentDateTime__c);
			if((amountDue.AssessmentDateTime__c.month() < Date.today().month() &&
				amountDue.AssessmentDateTime__c.year() == Date.today().year()) ||
				amountDue.AssessmentDateTime__c.year() < Date.today().year()){
				//Past Due Amount
				if(amountDue.Type__c == 'Reconciliation'){
					pastDueReconciliation.put(amountDue.id, amountDue);
				} else if(amountDue.Type__c == 'Monthly Amount'){
					pastDueAmountDue.put(amountDue.id, amountDue);
				}
			} else {
				if(amountDue.Type__c == 'Reconciliation'){
					currentReconciliation.put(amountDue.id, amountDue);
				} else if(amountDue.Type__c == 'Monthly Amount'){
					currentAmountDue.put(amountDue.id, amountDue);
				}
			}
			
		}
		System.debug('pastDueReconciliation:'+pastDueReconciliation);
		System.debug('currentReconciliation:'+currentReconciliation);
		System.debug('pastDueAmountDue:'+pastDueAmountDue);
		System.debug('currentAmountDue:'+currentAmountDue);

		////////////////////////////////////////////////////////////////////
		//Main Loop
		////////////////////////////////////////////////////////////////////
		Boolean continueAllocationProcess = true;	
		for(PaymentInstruction__c payment : paymentToAllocateMap.values()){
			if(continueAllocationProcess){
				//Decimal remainingToAllocate = payment.RemainingAllocation__c;

				PaymentInstruction paymentInst = new PaymentInstruction();
				paymentInst.paymentAmount = payment.Amount__c;
				paymentInst.remainingAllocation = payment.RemainingAllocation__c;
				System.debug('remainingToAllocate:'+paymentInst.remainingAllocation);
				paymentInst.paymentInstructionID = payment.id;
				paymentInst.allocations = new List<PaymentAllocation>();

				////////////////////////////////////////////////////////////////////
				//Pay all Fees First Starting with the Earliest
				////////////////////////////////////////////////////////////////////	
				//Look for any unpaid fees on this student that are less than or equal to the payment amount
				if(feesByStudent.containsKey(payment.Student__c)){
					System.debug('Fees');
					for(Fee__c fee : feesByStudent.get(payment.Student__c)){
						if(continueAllocationProcess){
							if(fee.Status__c == 'Unpaid'){ //don't pick up the unpaid fees a second time
								if(fee.Amount__c <= paymentInst.remainingAllocation){
									System.debug('pay this fee in full:'+ fee);
									paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Fee',
																							Fee__c = fee.id,
																							AmountAllocated__c = fee.Amount__c,
																							PaymentInstruction__c = payment.id));
									fee.DateCleared__c = Date.today();
									fee.Status__c = 'Paid';
									feesToUpdate.put(fee.id, fee);
									paymentInst.remainingAllocation -= fee.Amount__c;
									AllocatedFee allocFee = new AllocatedFee();
									allocFee.amount = fee.Amount__c;
									PaymentAllocation paymentAlloc = new PaymentAllocation();
									paymentAlloc.fee = allocFee;
									paymentInst.allocations.add(paymentAlloc);

								} else {
									if(!casesByContactID.containsKey(studentAccountMap.get(payment.Student__c).PersonContactID)){
										//only create a new case if nothing else exists

										//not enough money on payment instruction to pay remaining fee - raise a case for servicing
										//this will create a case at each payment instruction - if there are multiple payment instructions for the same student a case would
										//still be created - so this would need to be refactored to only add a case if allpayments for the student were done being allocated
				                       casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
			                            ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
			                            Subject = 'Not enough funds on payment instruction to pay all open fees',
			                            Status = 'New',
			                            Priority = 'Medium',
			                            Reason = 'Other',
			                            OwnerId=GlobalUtil.getQueueId('Servicing'),
			                            Type = 'Problem',                                   
			                            Origin = 'Other',
			                            PaymentInstruction__c = payment.id));

									}
			                       	continueAllocationProcess = false;
								}

							}

						}
					}
				}

				////////////////////////////////////////////////////////////////////
				//Next Pay Past Due Reconciliations - Oldest Reconciliation first
				////////////////////////////////////////////////////////////////////	
				if(continueAllocationProcess){
					System.debug('Past Due Reconciliations Amounts');
					for(StudentProgramAmountDue__c amountDue : pastDueReconciliation.values()){
						System.debug('amountDue:'+amountDue);
						//Allocate to this reconciliation
						Decimal allocation = 0;
						allocation = (paymentInst.remainingAllocation > amountDue.RemainingAllocation__c ? amountDue.RemainingAllocation__c : paymentInst.remainingAllocation);
						if(allocation > 0){
							String allocationGUID = GlobalUtil.createGUID();
							paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Reconciliation',
																					Agreement__c = amountDue.Agreement__c,
																					AllocationGUID__c = allocationGUID,
																					AmountAllocated__c = allocation,
																					PaymentInstruction__c = payment.id,
																					Detail__c = 'Past Due Reconciliation: '+ String.valueOf(amountDue.AssessmentDateTime__c)));
							PaymentAllocationDetail__c allocDetail = new PaymentAllocationDetail__c();
							PaymentAllocation__c parentAlloc = new PaymentAllocation__c(AllocationGUID__c = allocationGUID);
							allocDetail.PaymentAllocation__r = parentAlloc;//.AllocationGUID__c = allocationGUID;
							allocDetail.StudentProgramAmountDue__c = amountDue.id;
							allocDetail.AmountAllocated__c = allocation;

							paymentAllocationDetailsToCreate.add(allocDetail);

							paymentInst.remainingAllocation -= allocation;
							AllocatedAgreement allocAgreement = new AllocatedAgreement();
							allocAgreement.amount = allocation;
							allocAgreement.type = 'Past Due Reconciliation';
							allocAgreement.agreementID = amountDue.Agreement__c;
							PaymentAllocation paymentAlloc = new PaymentAllocation();
							paymentAlloc.agreement = allocAgreement;
							paymentInst.allocations.add(paymentAlloc);	

						}

					}
				}

				////////////////////////////////////////////////////////////////////
				//Next Pay Current  Reconciliations - Oldest Current (and oldest Contract) first
				////////////////////////////////////////////////////////////////////	
				if(continueAllocationProcess){
					System.debug('Current Reconciliations Amounts');
					for(StudentProgramAmountDue__c amountDue : currentReconciliation.values()){
						System.debug('amountDue:'+amountDue);
						//Allocate to this reconciliation
						Decimal allocation = 0;
						allocation = (paymentInst.remainingAllocation > amountDue.RemainingAllocation__c ? amountDue.RemainingAllocation__c : paymentInst.remainingAllocation);
						if(allocation > 0){
							String allocationGUID = GlobalUtil.createGUID();
							paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Reconciliation',
																					Agreement__c = amountDue.Agreement__c,
																					AllocationGUID__c = allocationGUID,
																					AmountAllocated__c = allocation,
																					PaymentInstruction__c = payment.id,
																					Detail__c = 'Current Due Reconciliation: '+ String.valueOf(amountDue.AssessmentDateTime__c)));
							PaymentAllocationDetail__c allocDetail = new PaymentAllocationDetail__c();
							PaymentAllocation__c parentAlloc = new PaymentAllocation__c(AllocationGUID__c = allocationGUID);
							allocDetail.PaymentAllocation__r = parentAlloc;//.AllocationGUID__c = allocationGUID;
							allocDetail.StudentProgramAmountDue__c = amountDue.id;
							allocDetail.AmountAllocated__c = allocation;

							paymentAllocationDetailsToCreate.add(allocDetail);

							paymentInst.remainingAllocation -= allocation;
							AllocatedAgreement allocAgreement = new AllocatedAgreement();
							allocAgreement.amount = allocation;
							allocAgreement.type = 'Current Due Reconciliation';
							allocAgreement.agreementID = amountDue.Agreement__c;
							PaymentAllocation paymentAlloc = new PaymentAllocation();
							paymentAlloc.agreement = allocAgreement;
							paymentInst.allocations.add(paymentAlloc);	

						}

					}

				}

				////////////////////////////////////////////////////////////////////
				//Next Pay PMonthly Amount Past Due - Oldest Amount Due first
				////////////////////////////////////////////////////////////////////	
				if(continueAllocationProcess){
					System.debug('Past Due Monthly Amounts');
					for(StudentProgramAmountDue__c amountDue : pastDueAmountDue.values()){
						System.debug('amountDue:'+amountDue);
						//Allocate to this reconciliation
						Decimal allocation = 0;
						allocation = (paymentInst.remainingAllocation > amountDue.RemainingAllocation__c ? amountDue.RemainingAllocation__c : paymentInst.remainingAllocation);
						if(allocation > 0){
							String allocationGUID = GlobalUtil.createGUID();
							paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Monthly Amount',
																					Agreement__c = amountDue.Agreement__c,
																					AllocationGUID__c = allocationGUID,
																					AmountAllocated__c = allocation,
																					PaymentInstruction__c = payment.id,
																					Detail__c = 'Monthly Amount Past Due: '+ String.valueOf(amountDue.AssessmentDateTime__c)));
							PaymentAllocationDetail__c allocDetail = new PaymentAllocationDetail__c();
							PaymentAllocation__c parentAlloc = new PaymentAllocation__c(AllocationGUID__c = allocationGUID);
							allocDetail.PaymentAllocation__r = parentAlloc;//.AllocationGUID__c = allocationGUID;
							allocDetail.StudentProgramAmountDue__c = amountDue.id;
							allocDetail.AmountAllocated__c = allocation;

							paymentAllocationDetailsToCreate.add(allocDetail);

							paymentInst.remainingAllocation -= allocation;
							AllocatedAgreement allocAgreement = new AllocatedAgreement();
							allocAgreement.amount = allocation;
							allocAgreement.type = 'Monthly Amount Past Due';
							allocAgreement.agreementID = amountDue.Agreement__c;
							PaymentAllocation paymentAlloc = new PaymentAllocation();
							paymentAlloc.agreement = allocAgreement;
							paymentInst.allocations.add(paymentAlloc);	

						}

					}
				}

				////////////////////////////////////////////////////////////////////
				//Next Pay Current  Monthly Amount Due - Oldest Current (and oldest Contract) first
				////////////////////////////////////////////////////////////////////	
				if(continueAllocationProcess){
					Boolean remainingCurrentAmount = false;
					System.debug('Monthly Amount Current Due');
					for(StudentProgramAmountDue__c amountDue : currentAmountDue.values()){
						System.debug('amountDue:'+amountDue);
						//Allocate to this reconciliation
						Decimal allocation = 0;
						allocation = (paymentInst.remainingAllocation > amountDue.RemainingAllocation__c ? amountDue.RemainingAllocation__c : paymentInst.remainingAllocation);
						if(allocation > 0){
							String allocationGUID = GlobalUtil.createGUID();
							paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Monthly Amount',
																					Agreement__c = amountDue.Agreement__c,
																					AllocationGUID__c = allocationGUID,
																					AmountAllocated__c = allocation,
																					PaymentInstruction__c = payment.id,
																					Detail__c = 'Monthly Amount Current Due: '+ String.valueOf(amountDue.AssessmentDateTime__c)));
							PaymentAllocationDetail__c allocDetail = new PaymentAllocationDetail__c();
							PaymentAllocation__c parentAlloc = new PaymentAllocation__c(AllocationGUID__c = allocationGUID);
							allocDetail.PaymentAllocation__r = parentAlloc;//.AllocationGUID__c = allocationGUID;
							allocDetail.StudentProgramAmountDue__c = amountDue.id;
							allocDetail.AmountAllocated__c = allocation;

							paymentAllocationDetailsToCreate.add(allocDetail);

							paymentInst.remainingAllocation -= allocation;
							AllocatedAgreement allocAgreement = new AllocatedAgreement();
							allocAgreement.amount = allocation;
							allocAgreement.type = 'Monthly Amount Current Due';
							allocAgreement.agreementID = amountDue.Agreement__c;
							PaymentAllocation paymentAlloc = new PaymentAllocation();
							paymentAlloc.agreement = allocAgreement;
							paymentInst.allocations.add(paymentAlloc);	

						} else {
							remainingCurrentAmount = true;
							System.debug('remainingCurrentAmount = true');
						}

					}
					if(remainingCurrentAmount){
						System.debug('Create the case');
						if(!casesByContactID.containsKey(studentAccountMap.get(payment.Student__c).PersonContactID)){
							//only create a new case if nothing else exists

	                       casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                           ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
                           Subject = 'Underpayment of current amount due',
                           Status = 'New',
                           Priority = 'Medium',
                           Reason = 'Other',
                           OwnerId=GlobalUtil.getQueueId('Servicing'),
                           Type = 'Problem',                                   
                           Origin = 'Other',
                           PaymentInstruction__c = payment.id));

						}	
                      	continueAllocationProcess = false;			

                   }										


				}

//here


				//////////////////////////////////////////////////////////////////////
				////Next Pay Current Monthly Amounts - Oldest Contract first
				//////////////////////////////////////////////////////////////////////
				//if(continueAllocationProcess){
				//	System.debug('Current Monthly Amounts');
				//	if(agreementsByStudent.containsKey(payment.Student__c)){
				//		Boolean remainingCurrentAmount = false;
				//		System.debug('remainingCurrentAmount = false - entering loop');
				//		for(AgreementService.Agreement agree : agreementsByStudent.get(payment.Student__c)){
				//			System.debug('agree:'+agree);
				//			if(agree.monthlyAmountCurrentDue > 0){
				//				remainingCurrentAmount = true;
				//				//allocate to this reconciliation
				//				Decimal allocation = 0;
				//				allocation = (paymentInst.remainingAllocation >= agree.monthlyAmountCurrentDue ? agree.monthlyAmountCurrentDue : paymentInst.remainingAllocation);
				//				if(allocation>0){
				//					System.debug('Allocate to Current Month Due:'+allocation);
				//					paymentAllocationsToCreate.add(new PaymentAllocation__c(AllocationType__c = 'Monthly Amount',
				//																			Agreement__c = agree.agreementID,
				//																			AmountAllocated__c = allocation,
				//																			PaymentInstruction__c = payment.id,
				//																			Detail__c = 'Monthly Amount Current Due'));
				//					paymentInst.remainingAllocation -= allocation;
				//					AllocatedAgreement allocAgreement = new AllocatedAgreement();
				//					allocAgreement.amount = allocation;
				//					allocAgreement.type = 'Monthly Amount Current Due';
				//					allocAgreement.agreementID = agree.agreementID;
				//					PaymentAllocation paymentAlloc = new PaymentAllocation();
				//					paymentAlloc.agreement = allocAgreement;
				//					paymentInst.allocations.add(paymentAlloc);
				//					System.debug('adding allocation:'+paymentAlloc);										
				//				}
				//				System.debug('allocation:'+allocation);
				//				System.debug('agree.monthlyAmountCurrentDue'+agree.monthlyAmountCurrentDue);
				//				if(agree.monthlyAmountCurrentDue > allocation){
				//					remainingCurrentAmount = true;
				//					System.debug('remainingCurrentAmount = true');
				//				} else {
				//					remainingCurrentAmount = false;
				//					System.debug('remainingCurrentAmount = false');
				//				}
				//			}
				//		}
				//		if(remainingCurrentAmount){
				//			System.debug('Create the case');
				//			if(!casesByContactID.containsKey(studentAccountMap.get(payment.Student__c).PersonContactID)){
				//				//only create a new case if nothing else exists

		  //                     casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
	   //                         ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
	   //                         Subject = 'Underpayment of current amount due',
	   //                         Status = 'New',
	   //                         Priority = 'Medium',
	   //                         Reason = 'Other',
	   //                         OwnerId=GlobalUtil.getQueueId('Servicing'),
	   //                         Type = 'Problem',                                   
	   //                         Origin = 'Other',
	   //                         PaymentInstruction__c = payment.id));

				//			}	
	   //                    	continueAllocationProcess = false;													
				//		}
				//	}
				//}

				////////////////////////////////////////////////////////////////////
				//Any remaining amount to be allocated
				////////////////////////////////////////////////////////////////////
				if(continueAllocationProcess){
					System.debug('Overpayment');
					if(paymentInst.remainingAllocation > 0){
						if(!casesByContactID.containsKey(studentAccountMap.get(payment.Student__c).PersonContactID)){
							//only create a new case if nothing else exists

							//not enough money on payment instruction to pay remaining fee - raise a case for servicing
							//this will create a case at each payment instruction - if there are multiple payment instructions for the same student a case would
							//still be created - so this would need to be refactored to only add a case if allpayments for the student were done being allocated
	                       casesToCreate.add(new Case(RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Case', GlobalUtil.CASE_RECTYPELBL_DEFAULT),
                           ContactID = studentAccountMap.get(payment.Student__c).PersonContactID,
                           Subject = 'Overpayment',
                           Status = 'New',
                           Priority = 'Medium',
                           Reason = 'Other',
                           OwnerId=GlobalUtil.getQueueId('Servicing'),
                           Type = 'Problem',                                   
                           Origin = 'Other',
                           PaymentInstruction__c = payment.id));

						}	
						continueAllocationProcess = false;					
					}
				}


				////////////////////////////////////////////////////////////////////
				//Any Remainder of the Payment Should be credited to account or pre-allocated
				//to agreements in the future
				////////////////////////////////////////////////////////////////////					

				returnData.add(paymentInst);
				
				logEntry += '\n PaymentInstructionAmount: '+ paymentInst.paymentAmount;
				logEntry += '\n PaymentInstructionID: ' + paymentInst.paymentInstructionID;
				logEntry += '\n PaymentInstructionRemainingAllocation: '+ paymentInst.remainingAllocation;
				for(PaymentAllocation pa : paymentInst.allocations){
					logEntry += '\n PaymentAllocation: '+pa;
				}				
				LogService.debug(logEntry, payment.id);
				logEntry = '';
			}

		}
		LogService.writeLogs();


		////////////////////////////////////////////////////////////////////
		//Update Tables 
		////////////////////////////////////////////////////////////////////	
		if(!proofMode){
			if(paymentAllocationsToCreate.size()>0){
				System.debug(paymentAllocationsToCreate);
				insert paymentAllocationsToCreate;
			}
			if(paymentAllocationDetailsToCreate.size()>0){
				System.debug(paymentAllocationDetailsToCreate);
				insert paymentAllocationDetailsToCreate;
			}
			if(feesToUpdate.size()>0){
				System.debug(feesToUpdate);
				update feesToUpdate.values();
			}
			if(casesToCreate.size()>0){
				insert casesToCreate;
			}			
		}
		System.debug(returnData);
		return returnData;
	}



	public class AllocatePaymentQueueable implements Queueable, Database.AllowsCallouts {
		public AllocatePaymentQueueable(){
			
		}
		public AllocatePaymentQueueable(ID paymentInstructionID){
			this.paymentInstructionID = paymentInstructionID;
		}
	    public ID paymentInstructionID {get;set;}
	    public void execute(QueueableContext context) {
	    	system.debug('PaymentAllocationService.AllocatePaymentQueueable.execute()');
	    	PaymentAllocationService.allocatePaymentV2(this.paymentInstructionID, false);
	    }
	}	
}