/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIFeeResource
// 
// Description: 
//  	Direction Central for EmployeeHistory API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-24   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIFeeResource {
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		if((api.version == 'v1') && (api.method == 'POST')){
			//return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			//return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			//return handleDeleteV1(api);
		}	
			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}

	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){	
		String feeIDParam = api.params.get('feeID');
		String customerIDParam = api.params.get('customerID');
		List<FeeService.Fee> feeList = new List<FeeService.Fee>();
		if(feeIDParam != null){
			feeList = FeeService.getFeeWithFeeID(VemoApi.parseParameterIntoIDSet(feeIDParam));
		}
		else if(customerIDParam != null){
			feeList = FeeService.getFeeWithCustomerID(VemoApi.parseParameterIntoIDSet(customerIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter feeID or customerID');
		}
		List<FeeOutputV1> results = new List<FeeOutputV1>();
		for(FeeService.Fee feeHis : feeList){
			results.add(new FeeOutputV1(feeHis));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public class FeeOutputV1{
		
		public FeeOutputV1(FeeService.Fee fe){
			this.feeID = fe.feeID;			
			this.amount = fe.amount;
			this.customer = fe.customer;
			this.dateAssessed = fe.dateAssessed;
			this.dateCleared = fe.dateCleared;
			this.status = fe.status;
			this.type = fe.type;
		}
		public String feeID {get;set;}
		public Decimal amount {get;set;}
		public String customer {get;set;}
		public Date dateAssessed {get;set;}
		public Date dateCleared {get;set;}
		public String status {get;set;}
		public String type {get;set;}
	}
}