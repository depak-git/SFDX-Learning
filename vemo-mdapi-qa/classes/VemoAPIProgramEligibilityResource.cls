/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIProgramEligibilityResource
// 
// Description: 
// 	Direction Central for Program Eligibility API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-04-24   Greg Cook       Created
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIProgramEligibilityResource implements VemoAPI.ResourceHandler{

	
	public static Object handleAPI(VemoAPI.APIInfo api){
		
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		/*
		if((api.version == 'v1') && (api.method == 'POST')){
			return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			return handleDeleteV1(api);
		}	
		*/	
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);

		return null;
	}
	
	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIProgramEligibilityResource.handleGetV1()');
		List<ProgramEligibilityResourceOutputV1> results = new List<ProgramEligibilityResourceOutputV1>();
system.debug('test');
		String programIDParam = api.params.get('programID');
		String stateParam = api.params.get('state');
		String ageParam = api.params.get('age');
		String residencyParam = api.params.get('residency');
		String enrollmentStatusParam = api.params.get('enrollmentStatus');
		String gradeLevelParam = api.params.get('gradeLevel');
		String schoolProgramOfStudyIDParam = api.params.get('schoolProgramOfStudyID');
system.debug(programIDParam);
system.debug(stateParam);
system.debug(ageParam);
system.debug(residencyParam);
system.debug(enrollmentStatusParam);
system.debug(schoolProgramOfStudyIDParam);
		Boolean withCriteriaMode = false;
		if(stateParam == null &&
		   ageParam == null &&
		   residencyParam == null &&
		   enrollmentStatusParam == null &&
		   gradeLevelParam == null &&
		   schoolProgramOfStudyIDParam == null &&
		   programIDParam != null){
			withCriteriaMode = false;
		} else {
			withCriteriaMode = true;
		}
		List<ProgramService.Program> programs = new List<ProgramService.Program>();
		if(withCriteriaMode){
			Boolean eligibilityResults = ProgramService.evaluateProgramEligibilityWithCriteria((ID)programIDparam,
																							  residencyParam,
																							  enrollmentStatusParam,
																							  gradeLevelParam,
																							  (ID)schoolProgramOfStudyIDParam,
																							  stateParam,
																							  Integer.valueOf(ageParam));

			ProgramEligibilityResourceOutputV1 pero = new ProgramEligibilityResourceOutputV1();
			pero.programID = programIDparam;
			pero.eligible = eligibilityResults;
			results.add(pero);

		} else if(programIDParam != null){
			Set<ID> studentIDs = new Set<ID>{api.studentPersonAccountID};
			Map<ID, Boolean> eligibilityResults = ProgramService.evaluateProgramEligibilityForStudents(programIDParam, studentIDs);

			for(ID theID : eligibilityResults.keySet()){
				ProgramEligibilityResourceOutputV1 pero = new ProgramEligibilityResourceOutputV1();
				pero.programID = programIDparam;
				pero.studentID = theID;
				pero.eligible = eligibilityResults.get(theID);
				results.add(pero);
			}

		} else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter programID');
		}


		return (new VemoAPI.ResultResponse(results, results.size()));
	}
			
	public class ProgramEligibilityResourceOutputV1{
		public String programID {get;set;}
		public String studentID {get;set;}
		public Boolean eligible {get;set;}
	}
	
}