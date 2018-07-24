/////////////////////////////////////////////////////////////////////////
// Class: FeeService
// 
// Description: 
// 	Handles all FeeService DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-24   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class FeeService {
	public static List<Fee> getFeeWithFeeID(Set<ID> feeIDs){
		Map<Id, Fee__c> feeMap = FeeQueries.getFeeMapWithFeeId(feeIDs);
		List<Fee> feeList = new List<Fee>();
		for(Fee__c fe : feeMap.values()){
			feeList.add(new Fee(fe));
		}
		return feeList;
	}

	public static List<Fee> getFeeWithCustomerID(Set<ID> customerIDs){
		Map<Id, Fee__c> feeMap = FeeQueries.getFeeMapWithCustomerId(customerIDs);
		List<Fee> feeList = new List<Fee>();
		for(Fee__c fe : feeMap.values()){
			feeList.add(new Fee(fe));
		}
		return feeList;
	}

	public class Fee{
		public String feeID {get;set;}
		public Decimal amount {get;set;}
		public String customer {get;set;}
		public Date dateAssessed {get;set;}
		public Date dateCleared {get;set;}
		public String status {get;set;}
		public String type {get;set;}

		public Fee(){

		}

		public Fee(Boolean testValues){
			if(testValues){
				this.amount = 1000; 
				this.dateAssessed = System.today(); 
				this.dateCleared = System.today();
				this.status = 'Unpaid'; //Paid, Cancelled
				this.type = 'Late Fee'; //NSF Fee
			}
		}

		public Fee(Fee__c fe){
			this.feeID = fe.ID;
			this.amount = fe.Amount__c;	
			this.customer = fe.Customer__c;
			this.dateAssessed = fe.DateAssessed__c;		
			this.dateCleared = fe.DateCleared__c;
			this.status = fe.Status__c;
			this.type = fe.Type__c;
		}
	}
}