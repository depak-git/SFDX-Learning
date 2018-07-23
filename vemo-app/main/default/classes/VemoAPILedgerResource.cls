/////////////////////////////////////////////////////////////////////////
// Class: VemoAPILedgerResource
// 
// Description: 
// 	Handles all Ledger API Functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-28   Greg Cook       Created                         
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPILedgerResource implements VemoAPI.ResourceHandler {
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		//if((api.version == 'v1') && (api.method == 'POST')){
		//	return handlePostV1(api);
		//}
		//if((api.version == 'v1') && (api.method == 'PUT')){
		//	return handlePutV1(api);
		//}	
		//if((api.version == 'v1') && (api.method == 'DELETE')){
		//	return handleDeleteV1(api);
		//}			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}

	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
		System.debug('VemoAPILedgerResource.handleGetV1');
		String customerIDParam = api.params.get('customerID');

		Set<LedgerService.LedgerType> exclusions = new Set<LedgerService.LedgerType>();
		List<LedgerService.JournalEntry> journalEntries = new List<LedgerService.JournalEntry>();
		if(customerIDParam != null){

			journalEntries = LedgerService.getJournalEntriesWithCustomerID(VemoApi.parseParameterIntoIDSet(customerIDParam), exclusions);
		} /*else if(disbursementIDParam != null){
			dists = TransactionService.getDisbursementWithDisbursementID(VemoApi.parseParameterIntoIDSet(disbursementIDParam));
		} else if(agreementIDParam != null){
			dists = TransactionService.getDisbursementWithAgreementID(VemoApi.parseParameterIntoIDSet(agreementIDParam));
		}*/
		else{
			throw new VemoAPI.VemoAPIFaultException('Missing parameter: customerID required for GET');
		}
		List<JournalEntryOutputV1> results = new List<JournalEntryOutputV1>();
		for(LedgerService.JournalEntry journalEntry : journalEntries){
			results.add(new JournalEntryOutputV1(journalEntry));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	//public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
	//	System.debug('VemoAPIDisbursementResource.handlePostV1');
	//	List<TransactionService.Disbursement> newDisbursements = new List<TransactionService.Disbursement>();
	//	List<DisbursementResourceInputV1> DisbursementJSON = (List<DisbursementResourceInputV1>)JSON.deserialize(api.body, List<DisbursementResourceInputV1>.class);
	//	for(DisbursementResourceInputV1 disRes : DisbursementJSON){
	//		disRes.validatePOSTFields();
	//		TransactionService.Disbursement dis = disbursementResourceV1ToDisbursement(disRes);
	//		newDisbursements.add(dis);
	//	}
	//	Set<ID> disIDs = TransactionService.createDisbursements(newDisbursements);
	//	return (new VemoAPI.ResultResponse(disIDs, disIDs.size()));
	//}

	//public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
	//	System.debug('VemoAPIDisbursementResource.handlePutV1');
	//	List<TransactionService.Disbursement> newDisbursements = new List<TransactionService.Disbursement>();
	//	List<DisbursementResourceInputV1> DisbursementJSON = (List<DisbursementResourceInputV1>)JSON.deserialize(api.body, List<DisbursementResourceInputV1>.class);
	//	for(DisbursementResourceInputV1 disRes : DisbursementJSON){
	//		disRes.validatePUTFields();
	//		TransactionService.Disbursement dis = disbursementResourceV1ToDisbursement(disRes);
	//		newDisbursements.add(dis);
	//	}
	//	Set<ID> disIDs = TransactionService.updateDisbursements(newDisbursements);
	//	return (new VemoAPI.ResultResponse(disIDs, disIDs.size()));
	//}

	//public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
	//	System.debug('VemoAPIDisbursementResource.handleDeleteV1');
	//	String disIDParam = api.params.get('disbursementID');		
	//	Integer numToDelete = TransactionService.deleteDisbursements(VemoApi.parseParameterIntoIDSet(disIDParam));
	//	return (new VemoAPI.ResultResponse(true, numToDelete));
	//}

	//public static TransactionService.Disbursement disbursementResourceV1ToDisbursement(DisbursementResourceInputV1 disRes){
	//	TransactionService.Disbursement dis = new TransactionService.Disbursement();
	//	dis.disbursementID = disRes.disbursementID;
	//	dis.studentID = disRes.studentID;
	//	dis.agreementID = disRes.agreementID;
	//	dis.relatedScheduleID = disRes.relatedScheduleID;
	//	dis.amount = disRes.amount;
	//	dis.transactionDate = disRes.transactionDate;
	//	dis.status = disRes.status;
	//	dis.confirmed = disRes.confirmed;
	//	dis.schoolSecurity = disRes.schoolSecurity;
	//	return dis;
	//}

	public class JournalEntryInputV1{
		//public String disbursementID {get;set;}
		//public String studentID {get;set;}
  //      public String agreementID {get;set;}

  //      public Decimal disbursementAmount {get;set;}
  //      public Date disbursementDate {get;set;}
  //      public String disbursementStatus {get;set;}
  //      public Strinb disbursementConfirmed {get;set;}

		public JournalEntryInputV1(){}

		//public JournalEntryInputV1(Boolean testValues){
		//	if(testValues){
		//		//this.transactionDate = Date.today();
		//		//this.amount = 1000;	
		//		//this.status = 'Complete'; //Pending, Scheduled	
		//	}
		//}
		//public void validatePOSTFields(){
		//	if(disbursementID != null) throw new VemoAPI.VemoAPIFaultException('disbursementID cannot be created in POST');				
		//}
		//public void validatePUTFields(){
		//	if(disbursementID == null) throw new VemoAPI.VemoAPIFaultException('disbursementID is a required input parameter on PUT');		
		//}
	}

	public class JournalEntryOutputV1{

		public String customerID {get;set;}
		public String agreementID {get;set;}
		public Date transactionDate {get;set;}
		public Decimal transactionAmount {get;set;}

		public String disbursementID {get;set;}
		public Decimal disbursementAmount {get;set;}
		public Date disbursementDate {get;set;}
		public String disbursementStatus {get;set;}
		public String disbursementConfirmed {get;set;}

		public String feeID {get;set;}
		public Decimal feeAmount {get;set;}
		public Date feeDateAssessed {get;set;}
		public Date feeDateCleared {get;set;}
		public String feeStatus {get;set;}
		public String feeType {get;set;}		

        public String paymentInstructionID {get;set;}
        public Decimal paymentAmount {get;set;}
        public Decimal paymentAmountAllocated {get;set;}
        public Decimal paymentRemainingAllocation {get;set;}
        public Date paymentDate {get;set;}
        public Date paymentDatePosted {get;set;}
        public Decimal paymentAmountPosted {get; set;}
        public String paymentStatus {get;set;}
        public String paymentDescription {get;set;}

        public String amountDueID {get;set;}
        public Decimal amountDueAmount {get;set;}
        public DateTime amountDueAssessmentDateTime {get;set;}
        public String amountDueExclude {get;set;}
        public String amountDueMonthlyStatus {get;set;}
        public String amountDueType {get;set;}


		public JournalEntryOutputV1(LedgerService.JournalEntry journalEntry){

			this.customerID = journalEntry.customerID;
			this.agreementID = journalEntry.agreementID;
			this.transactionDate = journalEntry.transactionDate;
			this.transactionAmount = journalEntry.transactionAmount;

			this.disbursementID = journalEntry.disbursementID;
			this.disbursementAmount = journalEntry.disbursementAmount;
			this.disbursementDate = journalEntry.disbursementDate;
			this.disbursementStatus = journalEntry.disbursementStatus;
			this.disbursementConfirmed = journalEntry.disbursementConfirmed;

			this.feeID = journalEntry.feeID;
			this.feeAmount = journalEntry.feeAmount;
			this.feeDateAssessed = journalEntry.feeDateAssessed;
			this.feeDateCleared = journalEntry.feeDateCleared;
			this.feeStatus = journalEntry.feeStatus;
			this.feeType = journalEntry.feeType;

			this.paymentInstructionID = journalEntry.paymentInstructionID;
			this.paymentAmount = journalEntry.paymentAmount;
			this.paymentAmountAllocated = journalEntry.paymentAmountAllocated;
			this.paymentRemainingAllocation = journalEntry.paymentRemainingAllocation;
			this.paymentDate = journalEntry.paymentDate;
			this.paymentDatePosted = journalEntry.paymentDatePosted;
 			this.paymentAmountPosted = journalEntry.paymentAmountPosted;
			this.paymentStatus = journalEntry.paymentStatus;
			this.paymentDescription = journalEntry.paymentDescription;

			this.amountDueID = journalEntry.amountDueID;
			this.amountDueAmount = journalEntry.amountDueAmount;
			this.amountDueAssessmentDateTime = journalEntry.amountDueAssessmentDateTime;
			this.amountDueExclude = journalEntry.amountDueExclude;
			this.amountDueMonthlyStatus = journalEntry.amountDueMonthlyStatus;
			this.amountDueType = journalEntry.amountDueType;

		}
	}
}