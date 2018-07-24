/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIPaymentMethodResource
// 
// Description: 
// 	Direction Central for PaymentMethod API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-13   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIPaymentMethodResource{
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
		System.debug('VemoAPIPaymentMethodResource.handleGetV1');
		String paymentMethodIDParam = api.params.get('paymentMethodID');
		String studentIDParam = api.params.get('studentID');
		List<PaymentMethodService.PaymentMethod> pymntMethList = new List<PaymentMethodService.PaymentMethod>();
		if(paymentMethodIDParam != null){
			pymntMethList = PaymentMethodService.getPaymentMethodWithPaymentMethodID(VemoApi.parseParameterIntoIDSet(paymentMethodIDParam));
		}
		else if(studentIDParam != null){
			pymntMethList = PaymentMethodService.getPaymentMethodWithCustomerID(VemoApi.parseParameterIntoIDSet(studentIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter paymentMethodID or studentID');
		}
		List<PaymentMethodOutputV1> results = new List<PaymentMethodOutputV1>();
		for(PaymentMethodService.PaymentMethod pymntMeth : pymntMethList){
			results.add(new PaymentMethodOutputV1(pymntMeth));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));

	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIPaymentMethodResource.handlePostV1');
		List<PaymentMethodService.PaymentMethod> newPaymentMethods = new List<PaymentMethodService.PaymentMethod>();
		List<PaymentMethodInputV1> paymentMethodJSON = (List<PaymentMethodInputV1>)JSON.deserialize(api.body, List<PaymentMethodInputV1>.class);
		for(PaymentMethodInputV1 pymntMeth : paymentMethodJSON){
			pymntMeth.validatePOSTFields();
			PaymentMethodService.PaymentMethod pymntMethServ = new PaymentMethodService.PaymentMethod();
			pymntMethServ = paymentMethodInputV1ToPayment(pymntMeth);
			newPaymentMethods.add(pymntMethServ);
		}
		Set<ID> paymentMethodIDs = PaymentMethodService.createPaymentMethod(newPaymentMethods);
		return (new VemoAPI.ResultResponse(paymentMethodIDs, paymentMethodIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIPaymentMethodResource.handlePutV1');
		List<PaymentMethodService.PaymentMethod> newPaymentMethods = new List<PaymentMethodService.PaymentMethod>();
		List<PaymentMethodInputV1> paymentMethodJSON = (List<PaymentMethodInputV1>)JSON.deserialize(api.body, List<PaymentMethodInputV1>.class);
		for(PaymentMethodInputV1 pymntMeth : paymentMethodJSON){
			pymntMeth.validatePUTFields();
			PaymentMethodService.PaymentMethod pymntMethServ = new PaymentMethodService.PaymentMethod();
			pymntMethServ = paymentMethodInputV1ToPayment(pymntMeth);
			newPaymentMethods.add(pymntMethServ);
		}
		Set<ID> paymentMethodIDs = PaymentMethodService.updatePaymentMethod(newPaymentMethods);
		return (new VemoAPI.ResultResponse(paymentMethodIDs, paymentMethodIDs.size()));
	}

	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIPaymentMethodResource.handleDeleteV1');
		String paymentMethodIDParam = api.params.get('paymentMethodID');
		Integer numToDelete = PaymentMethodService.deletePaymentMethod(VemoApi.parseParameterIntoIDSet(paymentMethodIDParam));
		return (new VemoAPI.ResultResponse(true, numToDelete));
	}



	public class PaymentMethodOutputV1{
		
		public PaymentMethodOutputV1(PaymentMethodService.PaymentMethod pymntMeth){
			this.paymentMethodID = pymntMeth.paymentMethodId;			

			if(String.isNotEmpty(pymntMeth.bankAccountNumber)) this.bankAccountNumber = '********'+pymntMeth.bankAccountNumber.right(4);
			if(String.isNotEmpty(pymntMeth.bankRoutingNumber)) this.bankRoutingNumber = '********'+pymntMeth.bankRoutingNumber.right(4);
			if(String.isNotEmpty(pymntMeth.creditCardNumber)) this.creditCardNumber = '********'+pymntMeth.creditCardNumber.right(4);		

			this.paymentMethodType = pymntMeth.paymentMethodType;
			//this.bankAccountNumber = pymntMeth.bankAccountNumber;
			//this.bankRoutingNumber = pymntMeth.bankRoutingNumber;
			//this.creditCardNumber = pymntMeth.creditCardNumber;
			this.description = pymntMeth.description;
			this.primary = pymntMeth.primary;
			this.studentID = pymntMeth.customerID;
			this.useForRecurring = pymntMeth.useForRecurring;
			this.useForDisbursements = pymntMeth.useForDisbursements;
			this.bankAccountCategory = pymntMeth.bankAccountCategory;
			this.bankAccountType = pymntMeth.bankAccountType;
			this.bankName = pymntMeth.bankName;

		}
		public String paymentMethodID {get;set;}
		public String bankAccountNumber {get;set;}
		public String bankRoutingNumber {get;set;}
		public String bankAccountCategory {get;set;}
		public String bankAccountType {get;set;}
		public String bankName {get;set;}
		public String creditCardNumber {get;set;}
		public String description {get;set;}
		public String primary {get;set;}
		public String studentID {get;set;}
		public String useForDisbursements {get;set;}
		public String useForRecurring {get;set;}
		public String paymentMethodType {get;set;}
	}

	public class PaymentMethodInputV1{
		public String paymentMethodID {get;set;}
		public String bankAccountNumber {get;set;}
		public String bankRoutingNumber {get;set;}
		public String creditCardNumber {get;set;}
		public String description {get;set;}
		public String primary {get;set;}
		public String studentID {get;set;}
		public String useForDisbursements {get;set;}
		public String useForRecurring {get;set;}
		public String paymentMethodType {get;set;}
		public String bankAccountType {get;set;}
		public String bankAccountCategory {get;set;}
		public String bankName {get;set;}
		public String tokenize {get;set;}

		public PaymentMethodInputV1(Boolean testValues){
			if(testValues){
				this.bankAccountNumber = '1234';
                this.bankRoutingNumber = '5678';
                this.creditCardNumber = '91011';
                this.description = 'Credit Card';
                this.primary = 'true';
			}
		}

		public void validatePOSTFields(){
			if(paymentMethodId != null) throw new VemoAPI.VemoAPIFaultException('paymentMethodId cannot be created in POST');
		}
		public void validatePUTFields(){
			if(paymentMethodId == null) throw new VemoAPI.VemoAPIFaultException('paymentMethodId is a required input parameter on PUT');
		}
	}

	public static PaymentMethodService.PaymentMethod paymentMethodInputV1ToPayment(PaymentMethodInputV1 input){
		PaymentMethodService.PaymentMethod output = new PaymentMethodService.PaymentMethod();
		output.paymentMethodID = input.paymentMethodID;			
		output.bankAccountNumber = input.bankAccountNumber;
		output.bankRoutingNumber = input.bankRoutingNumber;
		output.creditCardNumber = input.creditCardNumber;
		output.description = input.description;
		output.primary = input.primary;
		output.customerID = input.studentID;
		output.useForRecurring = input.useForRecurring;
		output.paymentMethodType = input.paymentMethodType;
		output.bankAccountCategory = input.bankAccountCategory;
		output.bankAccountType = input.bankAccountType;
		output.bankName = input.bankName;
		output.useForDisbursements = input.useForDisbursements;
		
		//Switch the following line of code when it is time to go live with tokenization
		output.tokenize = (input.tokenize == 'false' ? false : true);
		//output.tokenize = (input.tokenize == 'true' ? true : false);		
		return output;
	}
}