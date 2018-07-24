/////////////////////////////////////////////////////////////////////////
// Class: EmploymentHistoryService
// 
// Description: 
// 	Handles all EmploymentHistory DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-11   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class EmploymentHistoryService {

	public static List<EmploymentHistory> getEmploymentHistoryWithEmployentHistoryID(Set<ID> programIDs){
		System.debug('EmploymentHistoryService.getEmploymentHistoryWithEmployentHistoryID');
		Map<Id, EmploymentHistory__c> empHisMap = EmploymentHistoryQueries.getEmploymentHistoryMapWithEmploymentHistoryId(programIDs);
		List<EmploymentHistory> empHisList = new List<EmploymentHistory>();
		for(EmploymentHistory__c empHis : empHisMap.values()){
			empHisList.add(new EmploymentHistory(empHis));
		}
		return empHisList;
	}

	public static List<EmploymentHistory> getEmploymentHistoryWithStudentID(Set<ID> studentIds){
		System.debug('EmploymentHistoryService.getEmploymentHistoryWithStudentID');
		Map<Id, EmploymentHistory__c> empHisMap = EmploymentHistoryQueries.getEmploymentHistoryMapWithStudentId(studentIds);
		List<EmploymentHistory> empHisList = new List<EmploymentHistory>();
		for(EmploymentHistory__c empHis : empHisMap.values()){
			empHisList.add(new EmploymentHistory(empHis));
		}
		return empHisList;
	}

	public static Set<Id> createEmploymentHistory(List<EmploymentHistory> employmentHistory){
		System.debug('EmploymentHistoryService.createEmploymentHistory');
		List<EmploymentHistory__c> empHisList = new List<EmploymentHistory__c>();
		for(EmploymentHistory empHis : employmentHistory){
			EmploymentHistory__c empHisObj = empHisClassToEmpHisObject(empHis);
			empHisList.add(empHisObj);
		}
		insert empHisList;
		Set<Id> empHisIDs = new Set<Id>();
		for(EmploymentHistory__c empHis : empHisList){
			empHisIDs.add(empHis.ID);
		}
		return empHisIDs;
	}
	
	
	public static Set<Id> updateEmploymentHistory(List<EmploymentHistory> employmentHistory){
		System.debug('EmploymentHistoryService.updateEmploymentHistory');
		List<EmploymentHistory__c> empHisList = new List<EmploymentHistory__c>();
		for(EmploymentHistory empHis : employmentHistory){
			EmploymentHistory__c empHisObj = empHisClassToEmpHisObject(empHis);
			empHisList.add(empHisObj);
		}
		update empHisList;
		Set<Id> empHisIDs = new Set<Id>();
		for(EmploymentHistory__c empHis : empHisList){
			empHisIDs.add(empHis.ID);
		}
		return empHisIDs;
	}	
	
	public static Integer deleteEmploymentHistory(Set<ID> employmentHistoryIDs){
		System.debug('PaymentMethodService.deleteEmploymentHistory');
		Map<ID, EmploymentHistory__c> empHisMap = EmploymentHistoryQueries.getEmploymentHistoryMapWithEmploymentHistoryId(employmentHistoryIDs);
		Integer numToDelete = empHisMap.size();
		delete empHisMap.values();
		return numToDelete;
	}
	
	public static EmploymentHistory__c empHisClassToEmpHisObject(EmploymentHistory empHisClass){
		EmploymentHistory__c empHisObj = new EmploymentHistory__c();
		if(empHisClass.employmentHistoryID != null) empHisObj.ID = empHisClass.employmentHistoryID;
		if(empHisClass.category != null) empHisObj.Category__c = empHisClass.category;
		if(empHisClass.employer != null) empHisObj.Employer__c = empHisClass.employer;
		if(empHisClass.employmentEndDate != null) empHisObj.EmploymentEndDate__c = empHisClass.employmentEndDate;
		if(empHisClass.employmentStartDate != null) empHisObj.EmploymentStartDate__c = empHisClass.employmentStartDate;
		if(empHisClass.studentID != null) empHisObj.Student__c = empHisClass.studentID;
		if(empHisClass.type != null) empHisObj.Type__c = empHisClass.type;
		if(empHisClass.verified != null) empHisObj.Verified__c = empHisClass.verified;
		return empHisObj;
	}
	
	public class EmploymentHistory{
		public String employmentHistoryID {get;set;}
		public String category {get;set;}
		public String employer {get;set;}
		public Date employmentEndDate {get;set;}
		public Date employmentStartDate {get;set;}
		public String studentID {get;set;}
		public String type {get;set;}
		public Boolean verified {get;set;}

		public EmploymentHistory(){

		}

		public EmploymentHistory(Boolean testValues){
			if(testValues){
				this.category = 'Employee'; //Contractor, Internship
				this.employer = 'Test Employer'; //Planned, Closed, Cancelled
				this.type = 'Full Time'; //Part Time
			}
		}

		public EmploymentHistory(EmploymentHistory__c empHis){
			this.employmentHistoryID = empHis.ID;
			this.category = empHis.Category__c;	
			this.employer = empHis.Employer__c;		
			this.employmentEndDate = empHis.EmploymentEndDate__c;
			this.employmentStartDate = empHis.EmploymentStartDate__c;
			this.studentID = empHis.Student__c;
			this.type = empHis.Type__c;
			this.verified = empHis.Verified__c;
		}
	}
}