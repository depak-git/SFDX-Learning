/////////////////////////////////////////////////////////////////////////
// Class: ProgramOfStudyService
// 
// Description: 
// 	
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-01-01   Greg Cook       Created                                 
/////////////////////////////////////////////////////////////////////////
public with sharing class ProgramOfStudyService {

	public static List<ProgramOfStudy> getProgramOfStudies(){
		System.debug('ProgramOfStudyService.getProgramOfStudies');
		Map<ID, ProgramOfStudy__c> posMap = ProgramOfStudyQueries.getProgramOfStudyMap();
		List<ProgramOfStudy> posResults = new List<ProgramOfStudy>();
		for(ProgramOfStudy__c pos : posMap.values()){
			posResults.add(new ProgramOfStudy(pos));
		}
		return posResults;
	}

	public static List<ProgramOfStudy> getProgramOfStudyWithPOSID(Set<ID> programOfStudyIDs){
		System.debug('ProgramOfStudyService.getProgramOfStudyWithPOSID');
		Map<ID, ProgramOfStudy__c> posMap = ProgramOfStudyQueries.getProgramOfStudyMapWithPOSID(programOfStudyIDs);
		List<ProgramOfStudy> posResults = new List<ProgramOfStudy>();
		for(ProgramOfStudy__c pos : posMap.values()){
			posResults.add(new ProgramOfStudy(pos));
		}
		return posResults;
	}

	public static List<ProgramOfStudy> getProgramOfStudyWithSchoolIDs(Set<ID> schoolIDs){
		System.debug('ProgramOfStudyService.getProgramOfStudyWithSchoolIDs');
		Map<ID, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(schoolIDs);
		List<ProgramOfStudy> posResults = new List<ProgramOfStudy>();
		for(SchoolProgramsOfStudy__c spos : sposMap.values()){
			posResults.add(new ProgramOfStudy(spos));
		}
		return posResults;
	}

	public static List<ProgramOfStudy> getProgramOfStudyWithStudentIDs(Set<ID> studentIDs){
		System.debug('ProgramOfStudyService.getProgramOfStudyWithStudentIDs');
		Map<ID, Account> students = AccountQueries.getStudentMapWithStudentID(studentIDs);
		Set<ID> sposIDs = new Set<ID>();
		for(Account student : students.values()){
			if(String.isNotEmpty(student.SchoolProgramOfStudy__pc)){
				sposIDs.add(student.SchoolProgramOfStudy__pc);
			}
		}
		List<ProgramOfStudy> posResults = new List<ProgramOfStudy>();
		if(sposIDs.size()>0){
			system.debug(sposIDs);
			system.debug('query for School Programs with sposIDs from Students');
			Map<ID, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSPOSID(sposIDs);

			for(SchoolProgramsOfStudy__c spos : sposMap.values()){
				posResults.add(new ProgramOfStudy(spos));
			}
		}
		return posResults;
	}
	public static List<ProgramOfStudy> getProgramOfStudyWithSchoolProgramOfStudyIDs(Set<ID> schoolProgramOfStudyIDs){
		System.debug('ProgramOfStudyService.getProgramOfStudyWithSchoolProgramOfStudyIDs');
		List<ProgramOfStudy> posResults = new List<ProgramOfStudy>();

		Map<ID, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSPOSID(schoolProgramOfStudyIDs);

		for(SchoolProgramsOfStudy__c spos : sposMap.values()){
			posResults.add(new ProgramOfStudy(spos));
		}

		return posResults;
	}
	public static Set<ID> createProgramOfStudy(List<ProgramOfStudy> programsOfStudies){
		System.debug('ProgramOfStudyService.createProgramOfStudy');
		List<ProgramOfStudy__c> newPOSList = new List<ProgramOfStudy__c>();
		for(ProgramOfStudy pos : programsOfStudies){
			ProgramOfStudy__c posObj = posToPOSObject(pos);
			newPOSList.add(posObj);
		}
		insert newPOSList;
		Set<ID> posIDs = new Set<ID>();
		for(ProgramOfStudy__c pos : newPOSList){
			posIDs.add(pos.ID);
		}
		return posIDs;
	}

	public static Set<ID> updateProgramOfStudy(List<ProgramOfStudy> programsOfStudies){
		System.debug('ProgramOfStudyService.createProgramOfStudy');
		List<ProgramOfStudy__c> newPOSList = new List<ProgramOfStudy__c>();
		for(ProgramOfStudy pos : programsOfStudies){
			ProgramOfStudy__c posObj = posToPOSObject(pos);
			newPOSList.add(posObj);
		}
		update newPOSList;
		Set<ID> posIDs = new Set<ID>();
		for(ProgramOfStudy__c pos : newPOSList){
			posIDs.add(pos.ID);
		}
		return posIDs;
	}

	public static Integer deleteProgramOfStudy(Set<ID> programOfStudyIDs){
		System.debug('ProgramOfStudyService.deleteProgramOfStudy');
		Map<ID, ProgramOfStudy__c> posMap = ProgramOfStudyQueries.getProgramOfStudyMapWithPOSID(programOfStudyIDs);
		Integer numToDelete = posMap.size();
		delete posMap.values();
		return numToDelete;
	}

	public static ProgramOfStudy__c posToPOSObject(ProgramOfStudy pos){
		System.debug('ProgramOfStudyService.posToPOSObject');
		ProgramOfStudy__c posObj = new ProgramOfStudy__c();
		if(pos.programOfStudyID != null) posObj.ID = pos.programOfStudyID;
		if(pos.code != null) posObj.CIPCode__c = pos.code;
		if(pos.definition != null) posObj.CIPDefinition__c = pos.definition;
		if(pos.family != null) posObj.CIPFamily__c = pos.family;
		if(pos.title != null) posObj.CIPTitle__c = pos.title;
		if(pos.crossReferences != null) posObj.CrossReferences__c = pos.crossReferences;
		if(pos.examples != null) posObj.Examples__c = pos.examples;
//		if(pos.guid != null) posObj.GUID__C = pos.guid;
		return posObj;
	}
	public class ProgramOfStudy{
		public String programOfStudyID {get;set;}
		public String schoolProgramOfStudyID {get;set;}
		public STring schoolID {get;set;}
		public String code {get;set;}
		public String definition {get;set;}
		public String family {get;set;}
		public String title {get;set;}
		public String crossReferences {get;set;}
		public String examples {get;set;}
//		public String guid {get;set;}
		public String description {get;set;}

		public ProgramOfStudy(){

		}

		public ProgramOfStudy(Boolean testValues){
			if(testValues){
				this.code = 'Test Code';
				this.definition = 'Test Definition';
				this.family = 'Test Family';
				this.title = 'Test Title';
				this.crossReferences = 'Test Cross Reference';
				this.examples = 'Test Examples';
			}
		}

		public ProgramOfStudy(ProgramOfStudy__c pos){
			this.programOfStudyID = pos.ID;
			this.schoolProgramOfStudyID = null;
			this.schoolID = null;			
//			this.guid = pos.GUID__C;
			this.code = pos.CIPCode__c;
			this.definition = pos.CIPDefinition__c;
			this.family = pos.CIPFamily__c;
			this.title = pos.CIPTitle__c;
			this.crossReferences = pos.CrossReferences__c;
			this.examples = pos.Examples__c;
			this.description = pos.Description__c;
		}
		public ProgramOfStudy(SchoolProgramsOfStudy__c spos){
			this.programOfStudyID = spos.ProgramOfStudy__c;
			this.schoolProgramOfStudyID = spos.id;
			this.schoolID = spos.School__c;
//			this.guid = spos.ProgramOfStudy__r.GUID__C;
			this.code = spos.ProgramOfStudy__r.CIPCode__c;
			this.definition = spos.ProgramOfStudy__r.CIPDefinition__c;
			this.family = spos.ProgramOfStudy__r.CIPFamily__c;
			this.title = spos.ProgramOfStudy__r.CIPTitle__c;
			this.crossReferences = spos.ProgramOfStudy__r.CrossReferences__c;
			this.examples = spos.ProgramOfStudy__r.Examples__c;
			this.description = spos.Description__c;
		}
	}
}