/////////////////////////////////////////////////////////////////////////
// Class: DisbursementService
// 
// Description: 
// 	Handles all Distribution DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-28   Greg Cook       Created                         
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class DisbursementService {
/*
	public static List<Disbursement> getDisbursementWithDisbursementID(Set<ID> distributionIDs){
		System.debug('DisbursementService.getDisbursementWithDisbursementID');
		Map<ID, Transaction__c> trans = TransactionQueries.getDisbursementMapWithDisbursementID(distributionIDs);
		List<Disbursement> dists = new List<Disbursement>();
		for(Transaction__c tran : trans.values()){
			Disbursement dist = new Disbursement(tran);
			dists.add(dist);
		}
		return dists;
	}

	public static List<Disbursement> getDisbursementWithAgreementID(Set<ID> studentProgramIDs){
		System.debug('DisbursementService.getDisbursementWithAgreementID');
        system.debug(studentProgramIDs);
		Map<ID, Transaction__c> trans = TransactionQueries.getDisbursementMapWithAgreementID(studentProgramIDs);
		List<Disbursement> dists = new List<Disbursement>();
		for(Transaction__c tran : trans.values()){
			Disbursement dist = new Disbursement(tran);
			dists.add(dist);
		}
		return dists;
	}

	public static List<Disbursement> getDisbursementWithStudentID(Set<ID> accountIDs){
		System.debug('DisbursementService.getDisbursementWithStudentID');
		Map<ID, Transaction__c> trans = TransactionQueries.getDisbursementMapWithStudentID(accountIDs);
		List<Disbursement> dists = new List<Disbursement>();
		for(Transaction__c tran : trans.values()){
			Disbursement dist = new Disbursement(tran);
			dists.add(dist);
		}
		return dists;
	}

	public static Set<Id> createDisbursements(List<Disbursement> disbursement){
		System.debug('DisbursementService.createDisbursement');
		List<Transaction__c> trans = new List<Transaction__c>();
		for(Disbursement dis : disbursement){
			Transaction__c tran = disbursementToTransaction(dis);
			trans.add(tran);
		}
		insert trans;
		Set<ID> disIDs = new Set<ID>();
		for(Transaction__c tran : trans){
			disIDs.add(tran.ID);
		}
		return disIDs;
	}

	public static Set<Id> updateDisbursements(List<Disbursement> disbursements){
		System.debug('DisbursementnService.updateDisbursement');
		List<Transaction__c> trans = new List<Transaction__c>();
		for(Disbursement dis : disbursements){
			Transaction__c tran = disbursementToTransaction(dis);
			trans.add(tran);
		}
		update trans;
		Set<ID> disIDs = new Set<ID>();
		for(Transaction__c tran : trans){
			disIDs.add(tran.ID);
		}
		return disIDs;
	}

	public static Integer deleteDisbursements(Set<ID> disbursementIDs){
		System.debug('DisbursementService.deleteDisbursements');
		Map<ID, Transaction__c> trans = TransactionQueries.getDisbursementMapWithDisbursementID(disbursementIDs);
		Integer numToDelete = trans.size();
		delete trans.values();
		return numToDelete;
	}
	
	public static Transaction__c disbursementToTransaction(Disbursement dist){
		System.debug('DisbursementService.disbursementToTransaction');
		Transaction__c trans = new Transaction__c();
		
		if(dist.disbursementID != null) trans.ID = dist.disbursementID;
		if(dist.studentID != null) trans.Student__c = dist.studentID;
		if(dist.agreementID != null) trans.Agreement__c = dist.agreementID;
		if(dist.relatedScheduleID != null) trans.RelatedSchedule__c = dist.relatedScheduleID;
		if(dist.amount != null) trans.Amount__c = dist.amount;
		if(dist.transactionDate != null) trans.TransactionDateTime__c = dist.transactionDate;
		if(dist.status != null) trans.Status__C = dist.status;
		return trans;
	}

	public class Disbursement{
		public String disbursementID {get;set;}
		public String studentID {get;set;}
		public String agreementID {get;set;}
		public String relatedScheduleID {get;set;}
		public Decimal amount {get;set;}
		public DateTime transactionDate {get;set;}
		public String status {get;set;}

		public Disbursement(){

		}

		public Disbursement(Boolean testValues){
			if(testValues){
				this.transactionDate = System.now();
				this.amount = 1000;	
				this.status = 'Received'; //Pending, Scheduled		
			}
		}

		public Disbursement(Transaction__c trans){
			this.disbursementID = trans.ID;
			this.studentID = trans.Student__c;
			this.agreementID = trans.Agreement__c;
			this.relatedScheduleID = trans.RelatedSchedule__c;
			this.amount = trans.Amount__c;
			this.transactionDate = trans.TransactionDateTime__c;
			this.status = trans.Status__c;
		}
	}*/
}