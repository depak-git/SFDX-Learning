/////////////////////////////////////////////////////////////////////////
// Class: VemoAPICaseResource
// 
// Description: 
// 	Direction Central for Case API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-30   Greg Cook       Created                            
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPICaseResource implements VemoAPI.ResourceHandler {
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
			//todo return handleDeleteV1(api);
		}			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}

	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
		System.debug('VemoAPICaseResource.handleGetV1');
		String caseIDParam = api.params.get('caseID');
		String studentIDParam = api.params.get('studentID');
		List<CaseService.VemoCase> vcs = new List<CaseService.VemoCase>();
		if(caseIDParam != null){
			vcs = CaseService.getVemoCaseWithCaseID(VemoApi.parseParameterIntoIDSet(caseIDParam));
		}
		else if(studentIDParam != null){
			vcs = CaseService.getVemoCaseWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Missing parameter: caseID or studentID required for GET');
		}
		List<VemoCaseResourceOutputV1> results = new List<VemoCaseResourceOutputV1>();
		for(CaseService.VemoCase vc : vcs){
			results.add(new VemoCaseResourceOutputV1(vc));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPICaseResource.handlePostV1');
		List<CaseService.VemoCase> newCases = new List<CaseService.VemoCase>();
		List<VemoCaseResourceInputV1> casesJSON = (List<VemoCaseResourceInputV1>)JSON.deserialize(api.body, List<VemoCaseResourceInputV1>.class);
		for(VemoCaseResourceInputV1 caseRes : casesJSON){
			caseRes.validatePOSTFields();
			newCases.add(caseResourceV1ToVemoCase(caseRes));
		}
		Set<ID> caseIDs = CaseService.createVemoCases(newCases);

		return (new VemoAPI.ResultResponse(caseIDs, caseIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPICaseResource.handlePutV1');
		List<CaseService.VemoCase> updateCases = new List<CaseService.VemoCase>();
		List<VemoCaseResourceInputV1> casesJSON = (List<VemoCaseResourceInputV1>)JSON.deserialize(api.body, List<VemoCaseResourceInputV1>.class);
		for(VemoCaseResourceInputV1 caseRes : casesJSON){
			caseRes.validatePUTFields();
			updateCases.add(caseResourceV1ToVemoCase(caseRes));
		}
		Set<ID> caseIDs = CaseService.updateVemoCases(updateCases);

		return (new VemoAPI.ResultResponse(caseIDs, caseIDs.size()));
		return null;
	}

/*todo
	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		/System.debug('VemoAPICaseResource.handleDeleteV1');
		return null;
	}*/

	public static CaseService.VemoCase caseResourceV1ToVemoCase(VemoCaseResourceInputV1 caseRes){
		CaseService.VemoCase vc = new CaseService.VemoCase();
		vc.caseID = caseRes.caseID;
		vc.type = caseRes.type;
		vc.status = caseRes.status;
		vc.reason = caseRes.reason;
		vc.studentID = caseRes.studentID;
		vc.description = caseRes.description;
		vc.subject = caseRes.subject;
		vc.ownerID = caseRes.ownerID;
		return vc;
	}

	public class VemoCaseResourceInputV1{
		public String caseID {get;set;}
		public String type {get;set;}
		public String status {get;set;}
		public String reason {get;set;}
		public String studentID {get;set;}
		public String description {get;set;}
		public String subject {get;set;}
		public String ownerID {get;set;}

		public VemoCaseResourceInputV1(Boolean testValues){
			if(testValues){
				this.type = 'Question'; //Problem, Feature Request
				this.status = 'New'; //In Process, On Hold, Escalated, Closed
				this.reason = 'Disbursement'; //Billing, Other, ....
				this.description = 'Test Case Description';
				this.subject = 'Test Case Subject';
			}
		}

		public void validatePOSTFields(){
			if(caseID != null) throw new VemoAPI.VemoAPIFaultException('caseID cannot be created in POST');
		}

		public void validatePUTFields(){
			if(caseID == null) throw new VemoAPI.VemoAPIFaultException('caseID is a required input parameter on PUT');
		}
	}

	public class VemoCaseResourceOutputV1{
		public String caseID {get;set;}
		public String type {get;set;}
		public String status {get;set;}
		public String reason {get;set;}
		public String studentID {get;set;}
		public String description {get;set;}
		public String subject {get;set;}

		public VemoCaseResourceOutputV1(CaseService.VemoCase vc){
			this.caseID = vc.caseID;
			this.type = vc.type;
			this.status = vc.status;
			this.reason = vc.reason;
			this.studentID = vc.studentID;
			this.description = vc.description;
			this.subject = vc.subject;
		}
	}
}