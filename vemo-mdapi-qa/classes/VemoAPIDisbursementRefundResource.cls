/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIDisbursementRefundResource
// 
// Description: 
// 	Handles all Disbursement Refund API Functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-01-24   Greg Cook       Created                         
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIDisbursementRefundResource implements VemoAPI.ResourceHandler {
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		if((api.version == 'v1') && (api.method == 'POST')){
			return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			return handleDeleteV1(api);
		}			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}

	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIDisbursementRefundResource.handleGetV1');
		String disbursementRefundIDParam = api.params.get('disbursementRefundID');
		String agreementIDParam = api.params.get('agreementID');
		List<TransactionService.DisbursementRefund> distRefunds = new List<TransactionService.DisbursementRefund>();
		if(disbursementRefundIDParam != null){
			distRefunds = TransactionService.getDisbursementRefundWithDisbursementRefundID(VemoApi.parseParameterIntoIDSet(disbursementRefundIDParam));
		} else if(agreementIDParam != null){
			distRefunds = TransactionService.getDisbursementRefundWithAgreementID(VemoApi.parseParameterIntoIDSet(agreementIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Missing parameter: disbursementRefundID or agreementID required for GET');
		}
		List<DisbursementRefundResourceOutputV1> results = new List<DisbursementRefundResourceOutputV1>();
		for(TransactionService.DisbursementRefund disRefund : distRefunds){
			results.add(new DisbursementRefundResourceOutputV1(disRefund));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIDisbursementRefundResource.handlePostV1');
		List<TransactionService.DisbursementRefund> newDisbursementRefunds = new List<TransactionService.DisbursementRefund>();
		List<DisbursementRefundResourceInputV1> DisbursementRefundJSON = (List<DisbursementRefundResourceInputV1>)JSON.deserialize(api.body, List<DisbursementRefundResourceInputV1>.class);
		for(DisbursementRefundResourceInputV1 disRefundRes : DisbursementRefundJSON){
			disRefundRes.validatePOSTFields();
			TransactionService.DisbursementRefund disRefund = disbursementRefundResourceV1ToDisbursementRefund(disRefundRes);
			newDisbursementRefunds.add(disRefund);
		}
		Set<ID> disIDs = TransactionService.createDisbursementRefunds(newDisbursementRefunds);
		return (new VemoAPI.ResultResponse(disIDs, disIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIDisbursementRefundResource.handlePutV1');
		List<TransactionService.DisbursementRefund> newDisbursementRefunds = new List<TransactionService.DisbursementRefund>();
		List<DisbursementRefundResourceInputV1> DisbursementRefundJSON = (List<DisbursementRefundResourceInputV1>)JSON.deserialize(api.body, List<DisbursementRefundResourceInputV1>.class);
		for(DisbursementRefundResourceInputV1 disRefundRes : DisbursementRefundJSON){
			disRefundRes.validatePUTFields();
			TransactionService.DisbursementRefund disRefund = disbursementRefundResourceV1ToDisbursementRefund(disRefundRes);
			newDisbursementRefunds.add(disRefund);
		}
		Set<ID> disIDs = TransactionService.updateDisbursementRefunds(newDisbursementRefunds);
		return (new VemoAPI.ResultResponse(disIDs, disIDs.size()));
	}

	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIDisbursementRefundResource.handleDeleteV1');
		String disRefundIDParam = api.params.get('disbursementRefundID');		
		Integer numToDelete = TransactionService.deleteDisbursementRefunds(VemoApi.parseParameterIntoIDSet(disRefundIDParam));
		return (new VemoAPI.ResultResponse(true, numToDelete));
	}

	public static TransactionService.DisbursementRefund disbursementRefundResourceV1ToDisbursementRefund(DisbursementRefundResourceInputV1 disRefundRes){
		TransactionService.DisbursementRefund disRefund = new TransactionService.DisbursementRefund();
		disRefund.disbursementRefundID = disRefundRes.disbursementRefundID;
		disRefund.studentID = disRefundRes.studentID;
		disRefund.agreementID = disRefundRes.agreementID;
		disRefund.amount = disRefundRes.amount;
		disRefund.transactionDate = disRefundRes.transactionDate;
		disRefund.status = disRefundRes.status;
		disRefund.schoolSecurity = disRefundRes.schoolSecurity;
		
		return disRefund;
	}

	public class DisbursementRefundResourceInputV1{
		public String disbursementRefundID {get;set;}
		public String studentID {get;set;}
		public String agreementID {get;set;}
		public Decimal amount {get;set;}
		public Date transactionDate {get;set;}
		public String status {get;set;}
		public String schoolSecurity {get;set;}

		public DisbursementRefundResourceInputV1(){}

		public DisbursementRefundResourceInputV1(Boolean testValues){
			if(testValues){
				this.transactionDate = Date.today();
				this.amount = 1000;	
				this.status = 'Complete'; //Pending, Scheduled	
			}
		}
		public void validatePOSTFields(){
			if(disbursementRefundID != null) throw new VemoAPI.VemoAPIFaultException('disbursementRefundID cannot be created in POST');				
		}
		public void validatePUTFields(){
			if(disbursementRefundID == null) throw new VemoAPI.VemoAPIFaultException('disbursementRefundID is a required input parameter on PUT');		
		}
	}

	public class DisbursementRefundResourceOutputV1{
		public String disbursementRefundID {get;set;}
		public String studentID {get;set;}
		public String agreementID {get;set;}
		public Decimal amount {get;set;}
		public Date transactionDate {get;set;}
		public String status {get;set;}
		public String schoolSecurity {get;set;}

		public DisbursementRefundResourceOutputV1(TransactionService.DisbursementRefund dis){
			this.disbursementRefundID = dis.disbursementRefundID;
			this.studentID = dis.studentID;
			this.agreementID = dis.agreementID;
			this.amount = dis.amount;
			this.transactionDate = dis.transactionDate;
			this.status = dis.status;
			this.schoolSecurity = dis.schoolSecurity;
		}
	}

}