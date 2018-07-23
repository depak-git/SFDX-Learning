/////////////////////////////////////////////////////////////////////////
// Class: ProgramOfStudyQueries
// 
// Description: 
// 	
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-01-01   Greg Cook       Created                                 
/////////////////////////////////////////////////////////////////////////
public class ProgramOfStudyQueries {
	public static Map<ID, ProgramOfStudy__c> getProgramOfStudyMap(){
		return new Map<ID, ProgramOfStudy__c> ([SELECT ID,
													CIPCode__c, 
													CIPDefinition__c,
													CIPFamily__c,
													CIPTitle__c,
													CrossReferences__c,
													Examples__c,
													GUID__c,
													Description__c
												FROM ProgramOfStudy__c
												LIMIT 50000]);
	}

	public static Map<ID, ProgramOfStudy__c> getProgramOfStudyMapWithPOSID(Set<ID> programOfStudyID){
		return new Map<ID, ProgramOfStudy__c> ([SELECT ID,
													CIPCode__c, 
													CIPDefinition__c,
													CIPFamily__c,
													CIPTitle__c,
													CrossReferences__c,
													Examples__c,
													GUID__c,
													Description__c
												FROM ProgramOfStudy__c
												WHERE ID IN: programOfStudyID
												LIMIT 50000]);
	}
}