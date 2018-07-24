/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIProgramOfStudyResource
// 
// Description: 
// 	Direction Central for Program of Study API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-01-01   Greg Cook       Created                       
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIProgramOfStudyResource implements VemoAPI.ResourceHandler{
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
		System.debug('VemoAPIProgramOfStudyResource.handleGetV1');
		String posIDParam = api.params.get('programOfStudyID');
		system.debug('posIDParam-->'+posIDParam+'<--');
		String schoolIDParam = api.params.get('schoolID');
		String studentIDParam = api.params.get('studentID');
		String schoolProgramOfStudyIDparam = api.params.get('schoolProgramOfStudyID');
		List<ProgramOfStudyService.ProgramOfStudy> posList = new List<ProgramOfStudyService.ProgramOfStudy>();
		if(posIDParam != null){
			posList = ProgramOfStudyService.getProgramOfStudyWithPOSID(VemoApi.parseParameterIntoIDSet(posIDParam));
		}
		else if(schoolIDParam != null){
			posList = ProgramOfStudyService.getProgramOfStudyWithSchoolIDs(VemoApi.parseParameterIntoIDSet(schoolIDParam));
		}
		else if(studentIDParam != null){
			posList = ProgramOfStudyService.getProgramOfStudyWithStudentIDs(VemoApi.parseParameterIntoIDSet(studentIDParam));
		}
		else if(schoolProgramOfStudyIDparam != null){
			posList = ProgramOfStudyService.getProgramOfStudyWithSchoolProgramOfStudyIDs(VemoApi.parseParameterIntoIDSet(schoolProgramOfStudyIDparam));
		}
		else{
			posList = ProgramOfStudyService.getProgramOfStudies();
		}
		List<ProgramOfStudyResourceOutputV1> results = new List<ProgramOfStudyResourceOutputV1>();
		for(ProgramOfStudyService.ProgramOfStudy stud : posList){
			results.add(new ProgramOfStudyResourceOutputV1(stud));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIProgramOfStudyResource.handlePostV1');
		List<ProgramOfStudyService.ProgramOfStudy> newPOSList = new List<ProgramOfStudyService.ProgramOfStudy>();
		List<ProgramOfStudyResourceInputV1> posJSON = (List<ProgramOfStudyResourceInputV1>)JSON.deserialize(api.body, List<ProgramOfStudyResourceInputV1>.class);
		for(ProgramOfStudyResourceInputV1 pos : posJSON){
			pos.validatePOSTFields();
			ProgramOfStudyService.ProgramOfStudy newPOS = programOfStudyResourceInputV1ToProgramOfStudy(pos);
			newPOSList.add(newPOS);
		}
		Set<ID> posIDs = ProgramOfStudyService.createProgramOfStudy(newPOSList);
		return (new VemoAPI.ResultResponse(posIDs, posIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIProgramOfStudyResource.handlePutV1');
		List<ProgramOfStudyService.ProgramOfStudy> newPOSList = new List<ProgramOfStudyService.ProgramOfStudy>();
		List<ProgramOfStudyResourceInputV1> posJSON = (List<ProgramOfStudyResourceInputV1>)JSON.deserialize(api.body, List<ProgramOfStudyResourceInputV1>.class);
		for(ProgramOfStudyResourceInputV1 pos : posJSON){
			pos.validatePUTFields();
			ProgramOfStudyService.ProgramOfStudy newPOS = programOfStudyResourceInputV1ToProgramOfStudy(pos);
			newPOSList.add(newPOS);
		}
		Set<ID> posIDs = ProgramOfStudyService.updateProgramOfStudy(newPOSList);
		return (new VemoAPI.ResultResponse(posIDs, posIDs.size()));
	}

	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIProgramOfStudyResource.handleDeleteV1()');			
		String posIDParam = api.params.get('programOfStudyID');	
		Integer numToDelete = ProgramOfStudyService.deleteProgramOfStudy(VemoApi.parseParameterIntoIDSet(posIDParam));
		return (new VemoAPI.ResultResponse(true, numToDelete));
	}

	public static ProgramOfStudyService.ProgramOfStudy programOfStudyResourceInputV1ToProgramOfStudy(ProgramOfStudyResourceInputV1 posRes){
		ProgramOfStudyService.ProgramOfStudy pos = new ProgramOfStudyService.ProgramOfStudy();
		if(String.isNotBlank(posRes.programOfStudyID)) pos.programOfStudyID = posRes.programOfStudyID;
//		if(String.isNotBlank(posRes.guid)) pos.guid = posRes.guid;
		pos.code = posRes.code;
		pos.definition = posRes.definition;
		pos.family = posRes.family;
		pos.title = posRes.title;
		pos.crossReferences = posRes.crossReferences;
		pos.examples = posRes.examples;
		pos.code = posRes.code;
		return pos;
	}

	public class ProgramOfStudyResourceInputV1{
		public String programOfStudyID {get;set;}
		public String code {get;set;}
		public String definition {get;set;}
		public String family {get;set;}
		public String title {get;set;}
		public String crossReferences {get;set;}
		public String examples {get;set;}
//		public String guid {get;set;}

		public ProgramOfStudyResourceInputV1(Boolean testValues){
			if(testValues){
				this.code = 'Test Code';
				this.definition = 'Test Definition';
				this.family = 'Test Family';
				this.title = 'Test Title';
				this.crossReferences = 'Test Cross Reference';
				this.examples = 'Test Examples';
			}
		}

		public void validatePOSTFields(){
			if(programOfStudyID != null) throw new VemoAPI.VemoAPIFaultException('programOfStudyID cannot be created in POST');
//			if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be created in POST');	
		}

		public void validatePUTFields(){
			if(programOfStudyID == null) throw new VemoAPI.VemoAPIFaultException('programOfStudyID is a required input parameter on PUT');
//			if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be updated in PUT');		
		}
	}

	public class ProgramOfStudyResourceOutputV1{
		public String programOfStudyID {get;set;}
		public String schoolProgramOfStudyID {get;set;}
		public String schoolID {get;set;}
		public String code {get;set;}
		public String definition {get;set;}
		public String family {get;set;}
		public String title {get;set;}
		public String crossReferences {get;set;}
		public String examples {get;set;}
//		public String guid {get;set;}
		public String description {get;set;}


		public ProgramOfStudyResourceOutputV1(ProgramOfStudyService.ProgramOfStudy pos){
			this.programOfStudyID = pos.programOfStudyID;
			this.schoolProgramOfStudyID = pos.schoolProgramOfStudyID;
			this.schoolID = pos.schoolID;
//			this.guid = pos.guid;
			this.code = pos.code;
			this.definition = pos.definition;
			this.family = pos.family;
			this.title = pos.title;
			this.crossReferences = pos.crossReferences;
			this.examples = pos.examples;
			this.description = pos.description;

		}
	}
}