/////////////////////////////////////////////////////////////////////////
// Class: CaseService
// 
// Description: 
// 		Handles all Case DML functionality
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-30   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class CaseService {

	public static List<VemoCase> getVemoCaseWithCaseID(Set<ID> caseIDs){
		System.debug('CaseService.getVemoCaseWithCaseID');
		Map<ID, Case> caseMap = CaseQueries.getCaseMapWithCaseID(caseIDs);
		List<VemoCase> vcs = new List<VemoCase>();
		for(Case c : caseMap.values()){
			vcs.add(new VemoCase(c));
		}
		return vcs;
	}

	public static List<VemoCase> getVemoCaseWithStudentID(Set<ID> studentIDs){
		System.debug('CaseService.getVemoCaseWithStudentID');
		Map<ID, Case> caseMap = CaseQueries.getCaseMapWithStudentID(studentIDs);
		List<VemoCase> vcs = new List<VemoCase>();
		for(Case c : caseMap.values()){
			vcs.add(new VemoCase(c));
		}
		return vcs;
	}

	public static Set<ID> createVemoCases(List<VemoCase> vemoCases){
		System.debug('CaseService.createVemoCases');
		List<Case> cases = new List<Case>();
		for(VemoCase vc : vemoCases){
			cases.add(vemoCaseToCase(vc));
		}
		insert cases;
		Set<ID> caseIDs = new Set<ID>();
		for(Case c : cases){
			caseIDs.add(c.ID);
		}
		return caseIDs;
	}

	public static Set<ID> updateVemoCases(List<VemoCase> vemoCases){
		System.debug('CaseService.updateVemoCases');
		List<Case> cases = new List<Case>();
		for(VemoCase vc : vemoCases){
			cases.add(vemoCaseToCase(vc));
		}
		update cases;
		Set<ID> caseIDs = new Set<ID>();
		for(Case c : cases){
			caseIDs.add(c.ID);
		}
		return caseIDs;
	}

	public static Case vemoCaseToCase(VemoCase vc){
		Case c = new Case();
		if(vc.caseID != null) c.ID = vc.caseID;
		if(vc.type != null) c.Type = vc.type;
		if(vc.status != null) c.Status = vc.status;
		if(vc.reason != null) c.Reason = vc.reason;
		if(vc.studentID != null) c.AccountID = vc.studentID;
		if(vc.description != null) c.Description = vc.description;
		if(vc.subject != null) c.Subject = vc.subject;
		if(vc.ownerID != null) c.OwnerID = vc.ownerID;
		return c;
	}

	public class VemoCase{
		public String caseID {get;set;}
		public String type {get;set;}
		public String status {get;set;}
		public String reason {get;set;}
		public String studentID {get;set;}
		public String description {get;set;}
		public String subject {get;set;}
		public String ownerID {get;set;}

		public VemoCase(){}

		public VemoCase(Boolean testValues){
			if(testValues){
				this.type = 'Question'; //Problem, Feature Request
				this.status = 'New'; //In Process, On Hold, Escalated, Closed
				this.reason = 'Disbursement'; //Billing, Other, ....
				this.description = 'Test Case Description';
				this.subject = 'Test Case Subject';
			}
		}

		public VemoCase(Case c){
			this.caseID = c.ID;
			this.type = c.Type;
			this.status = c.Status;
			this.reason = c.Reason;
			this.studentID = c.AccountID;
			this.description = c.Description;
			this.subject = c.Subject;
			this.ownerID = c.OwnerID;
		}
	}
}