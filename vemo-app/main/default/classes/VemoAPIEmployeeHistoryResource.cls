/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIEmployeeHistoryResource
// 
// Description: 
//		Direction Central for EmployeeHistory API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann	Created 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIEmployeeHistoryResource {

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
		System.debug('VemoAPIEmployeeHistoryResource.handleGetV1');
		String employmentHistoryIDParam = api.params.get('employmentHistoryID');
		String studentIDParam = api.params.get('studentID');
		List<EmploymentHistoryService.EmploymentHistory> empHisList = new List<EmploymentHistoryService.EmploymentHistory>();
		if(employmentHistoryIDParam != null){
			empHisList = EmploymentHistoryService.getEmploymentHistoryWithEmployentHistoryID(VemoApi.parseParameterIntoIDSet(employmentHistoryIDParam));
		}
		else if(studentIDParam != null){
			empHisList = EmploymentHistoryService.getEmploymentHistoryWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter employmentHistoryID or studentID');
		}
		List<EmploymentHistoryOutputV1> results = new List<EmploymentHistoryOutputV1>();
		for(EmploymentHistoryService.EmploymentHistory empHis : empHisList){
			results.add(new EmploymentHistoryOutputV1(empHis));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIEmployeeHistoryResource.handlePostV1');
		List<EmploymentHistoryService.EmploymentHistory> newEmploymentHistory = new List<EmploymentHistoryService.EmploymentHistory>();
		List<EmploymentHistoryInputV1> employmentHistoryJSON = (List<EmploymentHistoryInputV1>)JSON.deserialize(api.body, List<EmploymentHistoryInputV1>.class);
		for(EmploymentHistoryInputV1 empHis : employmentHistoryJSON){
			empHis.validatePOSTFields();
			EmploymentHistoryService.EmploymentHistory empHisServ = new EmploymentHistoryService.EmploymentHistory();
			empHisServ = employmentHistoryInputV1ToEmploymentHistory(empHis);
			newEmploymentHistory.add(empHisServ);
		}
		Set<ID> employmentHistoryIDs = EmploymentHistoryService.createEmploymentHistory(newEmploymentHistory);
		return (new VemoAPI.ResultResponse(employmentHistoryIDs, employmentHistoryIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIEmployeeHistoryResource.handlePutV1');
		List<EmploymentHistoryService.EmploymentHistory> newEmploymentHistory = new List<EmploymentHistoryService.EmploymentHistory>();
		List<EmploymentHistoryInputV1> employmentHistoryJSON = (List<EmploymentHistoryInputV1>)JSON.deserialize(api.body, List<EmploymentHistoryInputV1>.class);
		for(EmploymentHistoryInputV1 empHis : employmentHistoryJSON){
			empHis.validatePUTFields();
			EmploymentHistoryService.EmploymentHistory empHisServ = new EmploymentHistoryService.EmploymentHistory();
			empHisServ = employmentHistoryInputV1ToEmploymentHistory(empHis);
			newEmploymentHistory.add(empHisServ);
		}
		Set<ID> employmentHistoryIDs = EmploymentHistoryService.updateEmploymentHistory(newEmploymentHistory);
		return (new VemoAPI.ResultResponse(employmentHistoryIDs, employmentHistoryIDs.size()));
	}

	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIEmployeeHistoryResource.handleDeleteV1');
		String employmentHistoryIDParam = api.params.get('employmentHistoryID');
		Integer numToDelete = EmploymentHistoryService.deleteEmploymentHistory(VemoApi.parseParameterIntoIDSet(employmentHistoryIDParam));
		return (new VemoAPI.ResultResponse(true, numToDelete));
	}



	public class EmploymentHistoryOutputV1{
		
		public EmploymentHistoryOutputV1(EmploymentHistoryService.EmploymentHistory empHis){
			this.employmentHistoryID = empHis.employmentHistoryID;			
			this.category = empHis.category;
			this.employer = empHis.employer;
			this.employmentEndDate = empHis.employmentEndDate;
			this.employmentStartDate = empHis.employmentStartDate;
			this.studentID = empHis.studentID;
			this.type = empHis.type;
			this.verified = empHis.verified;
		}
		public String employmentHistoryID {get;set;}
		public String category {get;set;}
		public String employer {get;set;}
		public Date employmentEndDate {get;set;}
		public Date employmentStartDate {get;set;}
		public String studentID {get;set;}
		public String type {get;set;}
		public Boolean verified {get;set;}
	}

	public class EmploymentHistoryInputV1{
		public String employmentHistoryID {get;set;}
		public String category {get;set;}
		public String employer {get;set;}
		public Date employmentEndDate {get;set;}
		public Date employmentStartDate {get;set;}
		public String studentID {get;set;}
		public String type {get;set;}
		public Boolean verified {get;set;}

		public EmploymentHistoryInputV1(Boolean testValues){
			if(testValues){
				this.category = 'Employee'; //Contractor, Internship
				this.employer = 'Test Employer'; //Planned, Closed, Cancelled
				this.type = 'Full Time'; //Part Time
			}
		}

		public void validatePOSTFields(){
			if(employmentHistoryID != null) throw new VemoAPI.VemoAPIFaultException('employmentHistoryID cannot be created in POST');
		}
		public void validatePUTFields(){
			if(employmentHistoryID == null) throw new VemoAPI.VemoAPIFaultException('employmentHistoryID is a required input parameter on PUT');
			if(studentID != null) throw new VemoAPI.VemoAPIFaultException('studentID is not a writable input parameter on PUT');
		}
	}

	public static EmploymentHistoryService.EmploymentHistory employmentHistoryInputV1ToEmploymentHistory(EmploymentHistoryInputV1 input){
		EmploymentHistoryService.EmploymentHistory output = new EmploymentHistoryService.EmploymentHistory();
		output.employmentHistoryID = input.employmentHistoryID;			
		output.category = input.category;
		output.employer = input.employer;
		output.employmentEndDate = input.employmentEndDate;
		output.employmentStartDate = input.employmentStartDate;
		output.studentID = input.studentID;
		output.type = input.type;
		output.verified = input.verified;
		return output;
	}
}