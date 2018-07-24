/////////////////////////////////////////////////////////////////////////
// Class: CreditCheckService
// 
// Description: 
// 	Handles all CreditCheck DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-01-08   Greg Cook       Created                          
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class CreditCheckService {
	public static List<CreditCheck> getCreditCheckWithCreditCheckID(Set<ID> creditCheckIDs){
		System.debug('CreditCheckService.getCreditCheckWithCreditCheckID()');
		Map<ID, CreditCheck__c> ccMap = CreditCheckQueries.getCreditCheckMapWithCreditCheckID(creditCheckIDs);
		List<CreditCheck> ccList = new List<CreditCheck>();
		for(CreditCheck__c cc : ccMap.values()){
			CreditCheck ccCls = new CreditCheck(cc);
			ccList.add(ccCls);
		}
		return ccList;
	}

	public static List<CreditCheck> getCreditCheckWithStudentID(Set<ID> studentIDs){
		System.debug('CreditCheckService.getCreditCheckWithStudentID()');
		Map<ID, CreditCheck__c> ccMap = CreditCheckQueries.getCreditCheckMapWithStudentID(studentIDs);
		List<CreditCheck> ccList = new List<CreditCheck>();
		for(CreditCheck__c cc : ccMap.values()){
			CreditCheck ccCls = new CreditCheck(cc);
			ccList.add(ccCls);
		}
		return ccList;
	}

	public static List<CreditCheck> getCreditCheckWithAgreementID(Set<ID> agreementIDs){
		System.debug('CreditCheckService.getCreditCheckWithAgreementID()');
		Map<ID, CreditCheck__c> ccMap = CreditCheckQueries.getCreditCheckMapWithAgreementID(agreementIDs);
		List<CreditCheck> ccList = new List<CreditCheck>();
		for(CreditCheck__c cc : ccMap.values()){
			CreditCheck ccCls = new CreditCheck(cc);
			ccList.add(ccCls);
		}
		return ccList;
	}

	public static Set<ID> createCreditChecks(List<CreditCheck> ccs){
		System.debug('CreditCheckService.createCreditChecks()');
		List<CreditCheck__c> newCCs = new List<CreditCheck__c>();
		for(CreditCheck cc : ccs){
			CreditCheck__c newCC = ccToCC(cc);
			newCCs.add(newCC);
		}
		insert newCCs;
		Set<ID> ccIDs = new Set<ID>();
		for(CreditCheck__c cc : newCCs){
			ccIDs.add(cc.ID);
		}
		return ccIDs;
	}

	public static Set<ID> updateCreditChecks(List<CreditCheck> ccs){
		System.debug('CreditCheckService.updateCreditChecks()');
		List<CreditCheck__c> newCCs = new List<CreditCheck__c>();
		for(CreditCheck cc : ccs){
			CreditCheck__c newCC = ccToCC(cc);
			newCCs.add(newCC);
		}
		update newCCs;
		Set<ID> ccIDs = new Set<ID>();
		for(CreditCheck__c cc : newCCs){
			ccIDs.add(cc.ID);
		}
		return ccIDs;
	}

	public static Integer deleteCreditChecks(Set<ID> creditCheckIDs){
		System.debug('CreditCheckService.deleteCreditChecks()');
		Map<ID, CreditCheck__c> ccMap = CreditCheckQueries.getCreditCheckMapWithCreditCheckID(creditCheckIDs);
		Integer numToDelete = ccMap.size();
		delete ccMap.values();
		return numToDelete;
	}

	public static CreditCheck__c ccToCC(CreditCheck cc){
		CreditCheck__c ccObj = new CreditCheck__c();
		if(cc.studentID != null) ccObj.Student__c = cc.studentID;
		if(cc.consentDateTimeStamp != null) ccObj.ConsentDateTimeStamp__c = cc.consentDateTimeStamp;
		if(cc.consentIPAddress != null) ccObj.ConsentIPAddress__c = cc.consentIPAddress;
		if(cc.creditCheckID != null) ccObj.ID = cc.creditCheckID;
		if(cc.jsonPayload != null) ccObj.JSONPayload__c = cc.jsonPayload;
		if(cc.status != null) ccObj.Status__c = cc.status;		
		if(cc.creditCheckDeniedReasonText != null) ccObj.CreditCheckDeniedReasonText__c = cc.creditCheckDeniedReasonText;
		if(cc.creditCheckDeniedReason != null) ccObj.CreditCheckDeniedReason__c = cc.creditCheckDeniedReason;
		return ccObj;
	}

	public class CreditCheck{
		public String studentID {get;set;}
		public DateTime consentDateTimeStamp {get;set;}
		public String consentIPAddress {get;set;}
		public String creditCheckID {get;set;}
		public String jsonPayload {get;set;}
		public String status {get;set;}
		public String creditCheckDeniedReasonText {get;set;}
		public String creditCheckDeniedReason {get;set;}

		public CreditCheck(){}

		public CreditCheck(boolean testValues){
			if(testValues){
				this.studentID = 'testStudentID';
				this.consentDateTimeStamp = DateTime.Now();
				this.consentIPAddress = '1.1.1.1';
				this.jsonPayload = 'test';

			}
		}

		public CreditCheck(CreditCheck__c cc){
			this.studentID = cc.Student__r.GUID__c;
			this.consentIPAddress = cc.ConsentIPAddress__c;
			this.consentDateTimeStamp = cc.ConsentDateTimeStamp__c;
			this.creditCheckID = cc.ID;
			this.jsonPayload = cc.JSONPayload__c;
			this.status = cc.Status__c;
			this.creditCheckDeniedReasonText = cc.CreditCheckDeniedReasonText__c;
			this.creditCheckDeniedReason = cc.CreditCheckDeniedReason__c;
		}
	}
}