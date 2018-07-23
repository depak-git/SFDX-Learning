/////////////////////////////////////////////////////////////////////////
// Class: VemoAPICreditCheckResource
// 
// Description: 
// 	Direction Central for Credit Check Resource API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
// 
/////////////////////////////////////////////////////////////////////////
public class VemoAPICreditCheckResource {
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
		System.debug('VemoAPICreditCheckResource.handleGetV1()');	
		String checkIDparam = api.params.get('creditCheckID');
		String studentIDparam = api.params.get('studentID');
		String agreementIDparam = api.params.get('agreementID');
		List<CreditCheckService.CreditCheck> ccs = new List<CreditCheckService.CreditCheck>();
		if(checkIDparam != null){
			ccs = CreditCheckService.getCreditCheckWithCreditCheckID(VemoApi.parseParameterIntoIDSet(checkIDparam));
		}
		else if(studentIDparam != null){
			ccs = CreditCheckService.getCreditCheckWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDparam));
		}
		else if(agreementIDparam != null){
			ccs = CreditCheckService.getCreditCheckWithAgreementID(VemoApi.parseParameterIntoIDSet(agreementIDparam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter creditCheckID, studentID, or agreementID');
		}
		List<CreditCheckResourceOutputV1> results = new List<CreditCheckResourceOutputV1>();
		for(CreditCheckService.CreditCheck cc : ccs){
			results.add(new CreditCheckResourceOutputV1(cc));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}
	
	
	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){	
		System.debug('VemoAPICreditCheckResource.handlePostV1()');	
		List<CreditCheckService.CreditCheck> ccs = new List<CreditCheckService.CreditCheck>();
		List<CreditCheckResourceInputV1> checksJSON = (List<CreditCheckResourceInputV1>)JSON.deserialize(api.body, List<CreditCheckResourceInputV1>.class);
		for(CreditCheckResourceInputV1 checkJSON : checksJSON){
			checkJSON.validatePOSTFields();
			ccs.add(creditCheckResourceToCreditCheck(checkJSON));
		}		
		Set<Id> checkIDs = CreditCheckService.createCreditChecks(ccs);
		return (new VemoAPI.ResultResponse(checkIDs, checkIDs.size()));
	}

	
	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPICreditCheckResource.handlePutV1()');	
		List<CreditCheckService.CreditCheck> ccs = new List<CreditCheckService.CreditCheck>();
		List<CreditCheckResourceInputV1> checksJSON = (List<CreditCheckResourceInputV1>)JSON.deserialize(api.body, List<CreditCheckResourceInputV1>.class);
		for(CreditCheckResourceInputV1 checkJSON : checksJSON){
			checkJSON.validatePUTFields();
			ccs.add(creditCheckResourceToCreditCheck(checkJSON));
		}		
		Set<Id> checkIDs = CreditCheckService.updateCreditChecks(ccs);
		return (new VemoAPI.ResultResponse(checkIDs, checkIDs.size()));
	}
	
	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPICreditCheckResource.handleDeleteV1()');
		String checkIDparam = api.params.get('creditCheckID');
		Integer numToDelete = CreditCheckService.deleteCreditChecks(VemoApi.parseParameterIntoIDSet(checkIDparam));	
		return (new VemoAPI.ResultResponse(true, numToDelete));
	}
	

	public static CreditCheckService.CreditCheck creditCheckResourceToCreditCheck(CreditCheckResourceInputV1 check){
		CreditCheckService.CreditCheck cc = new CreditCheckService.CreditCheck();
		cc.creditCheckID = check.creditCheckID;
		cc.consentDateTimeStamp = check.consentDateTimeStamp;
		cc.consentIPAddress = check.consentIPAddress;
		cc.studentID = check.studentID; //convert from GUID
		cc.jsonPayload = check.jsonPayload;
		cc.status = check.status;
		cc.creditCheckDeniedReason = check.creditCheckDeniedReason;
		cc.creditCheckDeniedReasonText = check.creditCheckDeniedReasonText;
		return cc;
	}

	public class CreditCheckResourceInputV1{
		public String studentID {get;set;}
		public DateTime consentDateTimeStamp {get;set;}
		public String consentIPAddress {get;set;}
		public String creditCheckID {get;set;}
		public String jsonPayload {get;set;}
		public String status {get;set;}
		public String creditCheckDeniedReasonText {get;set;}
		public String creditCheckDeniedReason {get;set;}


		public CreditCheckResourceInputV1(){}

		public CreditCheckResourceInputV1(Boolean testValues){
			if(testValues){
				studentID = 'testStudentID';
				consentDateTimeStamp = DateTime.Now();
				consentIPAddress = '1.1.1.1';
				jsonPayload = 'test';
			}
		}

		public void validatePOSTFields(){
			if(creditCheckID != null) throw new VemoAPI.VemoAPIFaultException('studentID cannot be created in POST');
		}
		public void validatePUTFields(){
			if(creditCheckID == null) throw new VemoAPI.VemoAPIFaultException('creditCheckID is a required input parameter on PUT');
		}
	}


	public class CreditCheckResourceOutputV1{

		public CreditCheckResourceOutputV1(){}
		
		public CreditCheckResourceOutputV1(CreditCheckService.CreditCheck check){
			studentID = check.studentID;
			consentIPAddress = check.consentIPAddress;
			consentDateTimeStamp = check.consentDateTimeStamp;
			creditCheckID = check.creditCheckID;
			jsonPayload = check.jsonPayload;
			status = check.status;
			creditCheckDeniedReason = check.creditCheckDeniedReason;
			creditCheckDeniedReasonText = check.creditCheckDeniedReasonText;
		}
		public String studentID {get;set;}
		public DateTime consentDateTimeStamp {get;set;}
		public String consentIPAddress {get;set;}
		public String creditCheckID {get;set;}
		public String jsonPayload {get;set;}
		public String status {get;set;}
		public String creditCheckDeniedReasonText {get;set;}
		public String creditCheckDeniedReason {get;set;}

	}


}