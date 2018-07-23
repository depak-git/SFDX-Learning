/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIPaymentInstructionResource
// 
// Description: 
// 	Direction Central for PaymentInstruction API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-18   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIPaymentInstructionResource {
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
		System.debug('VemoAPIPaymentInstructionResource.handleGetV1');
		String paymentInstructionIDParam = api.params.get('paymentInstructionID');
		String studentIDParam = api.params.get('studentID');
		List<PaymentInstructionService.PaymentInstruction> pymntInsList = new List<PaymentInstructionService.PaymentInstruction>();
		if(paymentInstructionIDParam != null){
			pymntInsList = PaymentInstructionService.getPaymentInstructionWithPaymentInstructionID(VemoApi.parseParameterIntoIDSet(paymentInstructionIDParam));
		}
		else if(studentIDParam != null){
			pymntInsList = PaymentInstructionService.getPaymentInstructionWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter paymentInstructionID or studentID');
		}
		List<PaymentInstructionOutputV1> results = new List<PaymentInstructionOutputV1>();
		for(PaymentInstructionService.PaymentInstruction pymntIns : pymntInsList){
			results.add(new PaymentInstructionOutputV1(pymntIns));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIPaymentInstructionResource.handlePostV1');
		List<PaymentInstructionService.PaymentInstruction> newPaymentInstructions = new List<PaymentInstructionService.PaymentInstruction>();
		List<PaymentInstructionInputV1> paymentInstructionJSON = (List<PaymentInstructionInputV1>)JSON.deserialize(api.body, List<PaymentInstructionInputV1>.class);
		for(PaymentInstructionInputV1 pymntIns : paymentInstructionJSON){
			pymntIns.validatePOSTFields();
			PaymentInstructionService.PaymentInstruction pymntInsServ = new PaymentInstructionService.PaymentInstruction();
			pymntInsServ = paymentInsturctionInputV1ToPaymentInstruction(pymntIns);
			newPaymentInstructions.add(pymntInsServ);
		}
		Set<ID> paymentInstructionIDs = PaymentInstructionService.createPaymentInstruction(newPaymentInstructions);
		return (new VemoAPI.ResultResponse(paymentInstructionIDs, paymentInstructionIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIPaymentInstructionResource.handlePostV1');
		List<PaymentInstructionService.PaymentInstruction> newPaymentInstructions = new List<PaymentInstructionService.PaymentInstruction>();
		List<PaymentInstructionInputV1> paymentInstructionJSON = (List<PaymentInstructionInputV1>)JSON.deserialize(api.body, List<PaymentInstructionInputV1>.class);
		for(PaymentInstructionInputV1 pymntIns : paymentInstructionJSON){
			pymntIns.validatePUTFields();
			PaymentInstructionService.PaymentInstruction pymntInsServ = new PaymentInstructionService.PaymentInstruction();
			pymntInsServ = paymentInsturctionInputV1ToPaymentInstruction(pymntIns);
			newPaymentInstructions.add(pymntInsServ);
		}
		Set<ID> paymentInstructionIDs = PaymentInstructionService.updatePaymentInstruction(newPaymentInstructions);
		return (new VemoAPI.ResultResponse(paymentInstructionIDs, paymentInstructionIDs.size()));
	}

	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIPaymentInstructionResource.handleDeleteV1');
		String paymentInstructionIDParam = api.params.get('paymentInstructionID');
		Integer numToDelete = PaymentInstructionService.deletePaymentInstruction(VemoApi.parseParameterIntoIDSet(paymentInstructionIDParam));
		return (new VemoAPI.ResultResponse(true, numToDelete));
	}

	public class PaymentInstructionInputV1{
		public String paymentInstructionID {get;set;}
		public Decimal amount {get;set;}
		public Date paymentDate {get;set;}
		public String paymentMethodID {get;set;}
		public String studentID {get;set;}
		public String status {get;set;}
		public String transactionDirection {get;set;}
		public String description {get;set;}

		public PaymentInstructionInputV1(Boolean testValues){
			if(testValues){
				this.amount = 1000;
                this.paymentDate = System.today();
                this.status = 'None';
			}
		}

		public void validatePOSTFields(){
			if(paymentInstructionID != null) throw new VemoAPI.VemoAPIFaultException('paymentInstructionID cannot be created in POST');
		}
		public void validatePUTFields(){
			if(paymentInstructionID == null) throw new VemoAPI.VemoAPIFaultException('paymentInstructionID is a required input parameter on PUT');
			if(studentID != null) throw new VemoAPI.VemoAPIFaultException('studentID cannot be updated');
		}
	}

	public class PaymentInstructionOutputV1{
		
		public PaymentInstructionOutputV1(PaymentInstructionService.PaymentInstruction pymntIns){
			this.paymentInstructionID = pymntIns.paymentInstructionID;	
			this.amount = pymntIns.amount;
			this.paymentDate = pymntIns.paymentDate;
			this.paymentMethodID = pymntIns.paymentMethodID;
			this.studentID = pymntIns.studentID; 
			this.status = pymntIns.status;
			this.transactionDirection = pymntIns.transactionDirection;
			this.description = pymntIns.description;
		}
		public String paymentInstructionID {get;set;}
		public Decimal amount {get;set;}
		public Date paymentDate {get;set;}
		public String paymentMethodID {get;set;}
		public String studentID {get;set;}
		public String status {get;set;}
		public String transactionDirection {get;set;}
		public string description {get;set;}
	}

	public static PaymentInstructionService.PaymentInstruction paymentInsturctionInputV1ToPaymentInstruction(PaymentInstructionInputV1 input){
		PaymentInstructionService.PaymentInstruction output = new PaymentInstructionService.PaymentInstruction();
		output.paymentInstructionID = input.paymentInstructionID;			
		output.amount = input.amount;
		output.paymentDate = input.paymentDate;
		output.paymentMethodID = input.paymentMethodID;
		output.studentID = input.studentID;
		//output.status = input.status;
		output.status = 'Created By Student';
		//output.transactionDirection = input.transactionDirection;
		output.transactionDirection = 'Inbound';
		output.description = String.isBlank(input.description) ? 'blank' : input.description;
		return output;
	}
}