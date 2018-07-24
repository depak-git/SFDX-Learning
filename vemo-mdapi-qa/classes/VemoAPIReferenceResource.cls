/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIReferenceResource
// 
// Description: 
// 	Direction Central for Case API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-30   Greg Cook       Created                            
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIReferenceResource implements VemoAPI.ResourceHandler {
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
		System.debug('VemoAPIReferenceResource.handleGetV1');
		String referenceIDparam = api.params.get('referenceID');		
		String studentIDParam = api.params.get('studentID');
		List<StudentService.StudentReference> srs = new List<StudentService.StudentReference>();
		if(referenceIDParam != null){
			srs = StudentService.getStudentReferencesWithReferenceID(VemoApi.parseParameterIntoIDSet(referenceIDParam));
		}
		else if(studentIDParam != null){
			srs = StudentService.getStudentReferencesWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Missing parameter: referenceID or studentID required for GET');
		}
		List<StudentReferenceResourceOutputV1> results = new List<StudentReferenceResourceOutputV1>();
		for(StudentService.StudentReference sr : srs){
			results.add(new StudentReferenceResourceOutputV1(sr));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIReferenceResource.handlePostV1');
		List<StudentService.StudentReference> newReferences = new List<StudentService.StudentReference>();
		List<StudentReferenceResourceInputV1> referencesJSON = (List<StudentReferenceResourceInputV1>)JSON.deserialize(api.body, List<StudentReferenceResourceInputV1>.class);
		for(StudentReferenceResourceInputV1 ref : referencesJSON){
			ref.validatePOSTFields();
			newReferences.add(referenceResourceV1ToStudentReference(ref));
		}
		Set<ID> refIDs = StudentService.createStudentReferences(newReferences);

		return (new VemoAPI.ResultResponse(refIDs, refIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIReferenceResource.handlePutV1');
		List<StudentService.StudentReference> updateRefs = new List<StudentService.StudentReference>();
		List<StudentReferenceResourceInputV1> referenceJSON = (List<StudentReferenceResourceInputV1>)JSON.deserialize(api.body, List<StudentReferenceResourceInputV1>.class);
		for(StudentReferenceResourceInputV1 ref : referenceJSON){
			ref.validatePUTFields();
			updateRefs.add(referenceResourceV1ToStudentReference(ref));
		}
		Set<ID> refIDs = StudentService.updateStudentReferences(updateRefs);

		return (new VemoAPI.ResultResponse(refIDs, refIDs.size()));
		return null;
	}


	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIReferenceResource.handleDeleteV1');
		String referenceIDparam = api.params.get('referenceID');
		Integer numToDelete = StudentService.deleteStudentReferences(VemoApi.parseParameterIntoIDSet(referenceIDparam));
		return (new VemoAPI.ResultResponse(true, numToDelete));


	}

	public static StudentService.StudentReference referenceResourceV1ToStudentReference(StudentReferenceResourceInputV1 referenceRes){
		StudentService.StudentReference sr = new StudentService.StudentReference();
		sr.studentID = referenceRes.studentID;
		sr.referenceID = referenceRes.referenceID;
		sr.firstName = referenceRes.firstName;
		sr.lastName = referenceRes.lastName;
		sr.middleName = referenceRes.middleName;
		sr.street = referenceRes.street;
		sr.city = referenceRes.city;
		sr.state = referenceRes.state;
		sr.country = referenceRes.country;
		sr.postalCode = referenceRes.postalCode;
		sr.primaryPhone = referenceRes.primaryPhone;
		sr.relationship = referenceRes.relationship;
		return sr;
	}

	public class StudentReferenceResourceInputV1{
		public String studentID {get;set;}
		public String referenceID {get;set;}
		public String firstName {get;set;}
		public String lastName {get;set;}
		public String middleName {get;set;}
		public String street {get;set;}
		public String city {get;set;}
		public String state {get;set;}
		public String country {get;set;}
		public String postalCode {get;set;}
		public String primaryPhone {get;set;}
		public String relationship {get;set;}

		public StudentReferenceResourceInputV1(Boolean testValues){
			if(testValues){
				this.firstName = 'First';
				this.lastName = 'Last';
				this.middleName = 'Middle';
				this.street = 'Street';
				this.city = 'City';
				this.state = 'Colorado';
				this.country = 'United States';
				this.postalCode = '12345';
				this.primaryPhone = '12345';
				this.relationship = 'Spouse';
			}
		}

		public void validatePOSTFields(){
			if(referenceID != null) throw new VemoAPI.VemoAPIFaultException('referenceID cannot be created in POST');
			if(studentID == null) throw new VemoAPI.VemoAPIFaultException('studentID is a required input parameter on POST');
		}

		public void validatePUTFields(){
			if(referenceID == null) throw new VemoAPI.VemoAPIFaultException('referenceID is a required input parameter on PUT');
			if(studentID == null) throw new VemoAPI.VemoAPIFaultException('studentID is a required input parameter on PUT');
		}
	}

	public class StudentReferenceResourceOutputV1{
		public String studentID {get;set;}
		public String referenceID {get;set;}
		public String firstName {get;set;}
		public String lastName {get;set;}
		public String middleName {get;set;}
		public String street {get;set;}
		public String city {get;set;}
		public String state {get;set;}
		public String country {get;set;}
		public String postalCode {get;set;}
		public String primaryPhone {get;set;}
		public String relationship {get;set;}

//		public String pendingFirstName {get;set;}
//		public String pendingLastName {get;set;}
//		public String pendingMiddleName {get;set;}
//		public String pendingStreet {get;set;}
//		public String pendingCity {get;set;}
//		public String pendingState {get;set;}
//		public String pendingCountry {get;set;}
//		public String pendingPostalCode {get;set;}



		public StudentReferenceResourceOutputV1(StudentService.StudentReference sr){
			this.studentID = sr.studentID;
			this.referenceID = sr.referenceID;
			this.firstName = sr.firstName;
			this.lastName = sr.lastName;
			this.middleName = sr.middleName;
			this.street = sr.street;
			this.city = sr.city;
			this.state = sr.state;
			this.country = sr.country;
			this.postalCode = sr.postalCode;
			this.primaryPhone = sr.primaryPhone;
			this.relationship = sr.relationship;

//			this.pendingFirstName = sr.pendingFirstName;
//			this.pendingLastName = sr.pendingLastName;
//			this.pendingMiddleName = sr.pendingMiddleName;
//			this.pendingStreet = sr.pendingMailingStreet;
//			this.pendingCity = sr.pendingMailingCity;
//			this.pendingState = sr.pendingMailingState;
//			this.pendingCountry = sr.pendingMailingCountry;
//			this.pendingPostalCode = sr.pendingMailingPostalCode;
		
		}
	}
}