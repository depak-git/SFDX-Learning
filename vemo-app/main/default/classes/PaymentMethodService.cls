/////////////////////////////////////////////////////////////////////////
// Class: PaymentMethodService
// 
// Description: 
// 	Handles all PaymentMethod DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-13   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class PaymentMethodService {
	

	public static List<PaymentMethod> getPaymentMethodWithPaymentMethodID(Set<ID> paymentMethodIDs){
		System.debug('PaymentMethodService.getPaymentMethodWithPaymentMethodID');
		Map<Id, PaymentMethod__c> pymntMethMap = PaymentMethodQueries.getPaymentMethodMapWithPaymentMethodID(paymentMethodIDs);
		system.debug('pymntMethMap:'+pymntMethMap);
		List<PaymentMethod> pymntMethList = new List<PaymentMethod>();
		for(PaymentMethod__c pymntMeth : pymntMethMap.values()){
			system.debug('pymntMeth:'+pymntMeth);//encrypted
			//system.debug('pymntMeth.BankRoutingNumber__c:'+pymntMeth.BankRoutingNumber__c);//in the clear
			pymntMethList.add(new PaymentMethod(pymntMeth));
		}
		return pymntMethList;
	}

	public static List<PaymentMethod> getPaymentMethodWithCustomerID(Set<ID> customerIDs){
		System.debug('PaymentMethodService.getPaymentMethodWithCustomerID');
		Map<Id, PaymentMethod__c> pymntMethMap = PaymentMethodQueries.getPaymentMethodMapWithCustomerID(customerIDs);
		List<PaymentMethod> pymntMethList = new List<PaymentMethod>();
		for(PaymentMethod__c pymntMeth : pymntMethMap.values()){
			pymntMethList.add(new PaymentMethod(pymntMeth));
		}
		return pymntMethList;
	}

	
	
	public static Set<Id> createPaymentMethod(List<PaymentMethod> paymentMethods){
		System.debug('PaymentMethodService.createPaymentMethod');
		List<PaymentMethod__c> pymntMethList = new List<PaymentMethod__c>();
		List<PaymentMethod> pymntMethToTokenize = new List<PaymentMethod>();
		
		for(PaymentMethod pymntMeth : paymentMethods){
			if(pymntMeth.tokenize == true){
				pymntMethToTokenize.add(pymntMeth);
			}
		}
		if(pymntMethToTokenize.size()>0){
			tokenizePayments(pymntMethToTokenize);
		}
		for(PaymentMethod pymntMeth : paymentMethods){

			PaymentMethod__c pymntMethObj = paymentMethodClsToPaymentmMethodObj(pymntMeth, false);
			pymntMethList.add(pymntMethObj);
		}
		insert pymntMethList;
		Set<Id> pymntMethIDs = new Set<Id>();
		for(PaymentMethod__c pymntMeth : pymntMethList){
			pymntMethIDs.add(pymntMeth.ID);
		}
		return pymntMethIDs;
	}
	
	
	public static Set<Id> updatePaymentMethod(List<PaymentMethod> paymentMethods){
		System.debug('PaymentMethodService.createPaymentMethod');
		List<PaymentMethod__c> pymntMethList = new List<PaymentMethod__c>();
		List<PaymentMethod> pymntMethToTokenize = new List<PaymentMethod>();

		for(PaymentMethod pymntMeth : paymentMethods){
			if(pymntMeth.tokenize == true){
				pymntMethToTokenize.add(pymntMeth);
			}
		}

		if(pymntMethToTokenize.size()>0){
			tokenizePayments(pymntMethToTokenize);
		}
		for(PaymentMethod pymntMeth : paymentMethods){
			PaymentMethod__c pymntMethObj = paymentMethodClsToPaymentmMethodObj(pymntMeth, true);
			pymntMethList.add(pymntMethObj);
		}
		update pymntMethList;
		Set<Id> pymntMethIDs = new Set<Id>();
		for(PaymentMethod__c pymntMeth : pymntMethList){
			pymntMethIDs.add(pymntMeth.ID);
		}
		return pymntMethIDs;
	}	
	
	public static Integer deletePaymentMethod(Set<ID> paymentMethodIDs){
		System.debug('PaymentMethodService.deletePaymentMethod');
		Map<ID, PaymentMethod__c> pymntMeth = PaymentMethodQueries.getPaymentMethodMapWithPaymentMethodID(paymentMethodIDs);
		Integer numToDelete = pymntMeth.size();
		for(PaymentMethod__c pm : pymntMeth.values()){
			pm.Inactive__c = true;
		}
		update pymntMeth.values();
		return numToDelete;
	}
	
	public static void tokenizePayments(List<PaymentMethod> pymntMethToTokenize){
		System.debug('PaymentMethodService.tokenizePayments()');
		Set<ID> relatedAccountIDs = new Set<ID>();
		Map<ID, Account> acctsToUpdate = new Map<ID, Account>();

		if(pymntMethToTokenize.size()>50){
			throw new PaymentMethodServiceException('Too many to tokenize');
		}
		for(PaymentMethod payment : pymntMethToTokenize){
			relatedAccountIDs.add(payment.customerID);
		}

		Map<ID, Account> accountMap = AccountQueries.getStudentMapWithStudentID(relatedAccountIDs);

		Integer callouts = 0;
		for(PaymentMethod payment : pymntMethToTokenize){
			if(payment.tokenize){
				System.debug('payment:'+payment);
				System.debug('callouts:'+callouts);
				//validate Routing Number
				System.debug('Call ABARoutingVerify');
				StewardshipTechService.ABARoutingVerifyRequest input1 = new StewardshipTechService.ABARoutingVerifyRequest();
				input1.ABARoutingNum = payment.bankRoutingNumber;
				StewardshipTechService.ABARoutingVerifyResponse output1 = StewardshipTechService.ABARoutingVerify(StewardshipTechService.AccountType.PAYMENT, input1);
				payment.bankName = output1.root.RoutingNumber.BankName;
				callouts++;

				if(accountMap.containsKey(payment.customerID)){
					//Payments
					if(String.isEmpty(accountMap.get(payment.customerID).StewardshipPaymentDonorGUID__c)){
						//Donor2
						System.debug('Call CreateDonor2');
						StewardshipTechService.CreateDonor2Request input2 = new StewardshipTechService.CreateDonor2Request();


						input2.DonorID = payment.CustomerID;
						input2.LastName = accountMap.get(payment.customerID).LastName;
						input2.Street1 = accountMap.get(payment.customerID).PersonMailingStreet;
						input2.City = accountMap.get(payment.customerID).PersonMailingCity;	
						input2.StateCode = accountMap.get(payment.customerID).PersonMailingStateCode;						
						input2.PostalCode = accountMap.get(payment.customerID).PersonMailingPostalCode;	
						input2.BankAccountType = payment.bankAccountTYpe == 'Savings' ? 'S' : 'C';
						input2.AccountNumber = payment.bankAccountNumber;
						input2.ABARoutingNum = payment.bankRoutingNumber;
						input2.AccountType = 'B';//B = Bank, Credit Card = 'P';


						StewardshipTechService.CreateDonor2Response output2 = StewardshipTechService.CreateDonor2(StewardshipTechService.AccountType.PAYMENT, input2);
						payment.paymentMethodToken = output2.root.Donor.AccountGUID;

						if(!acctsToUpdate.containsKey(payment.customerID)){
							acctsToUpdate.put(payment.customerID, new Account(id = payment.customerID,
													  						StewardshipPaymentDonorGUID__c = output2.root.Donor.DonorGUID));								
						} else {
							acctsToUpdate.get(payment.customerID).StewardshipPaymentDonorGUID__c = output2.root.Donor.DonorGUID;								
						}
				
						callouts++;
					} else {
						//CreateACHAccount only
						System.debug('Call CreateACHAccount');
						StewardshipTechService.CreateACHAccountRequest input3 = new StewardshipTechService.CreateACHAccountRequest();

						input3.DonorGUID = accountMap.get(payment.customerID).StewardshipPaymentDonorGUID__c;
						input3.BankAccountType = payment.bankAccountTYpe == 'Savings' ? 'S' : 'C';
						input3.Nickname = payment.description;
						input3.AccountNumber = payment.bankAccountNumber;
						input3.ABARoutingNum = payment.bankRoutingNumber;

						StewardshipTechService.CreateACHAccountResponse output3 = StewardshipTechService.CreateACHAccount(StewardshipTechService.AccountType.PAYMENT, input3);
						payment.paymentMethodToken = output3.root.Account.AccountGUID;
				
						callouts++;
					}

					//Disbursements
					if(String.isEmpty(accountMap.get(payment.customerID).StewardshipDisbursementDonorGUID__c)){
						//Donor2
						System.debug('Call CreateDonor2');
						StewardshipTechService.CreateDonor2Request input2 = new StewardshipTechService.CreateDonor2Request();


						input2.DonorID = payment.CustomerID;
						input2.LastName = accountMap.get(payment.customerID).LastName;
						input2.Street1 = accountMap.get(payment.customerID).PersonMailingStreet;
						input2.City = accountMap.get(payment.customerID).PersonMailingCity;	
						input2.StateCode = accountMap.get(payment.customerID).PersonMailingStateCode;						
						input2.PostalCode = accountMap.get(payment.customerID).PersonMailingPostalCode;	
						input2.BankAccountType = payment.bankAccountTYpe == 'Savings' ? 'S' : 'C';
						input2.AccountNumber = payment.bankAccountNumber;
						input2.ABARoutingNum = payment.bankRoutingNumber;
						input2.AccountType = 'B';//B = Bank, Credit Card = 'P';


						StewardshipTechService.CreateDonor2Response output2 = StewardshipTechService.CreateDonor2(StewardshipTechService.AccountType.DISBURSEMENT, input2);
						payment.disbursementMethodToken = output2.root.Donor.AccountGUID;

						if(!acctsToUpdate.containsKey(payment.customerID)){
							acctsToUpdate.put(payment.customerID, new Account(id = payment.customerID,
													  						StewardshipDisbursementDonorGUID__c = output2.root.Donor.DonorGUID));								
						} else {
							acctsToUpdate.get(payment.customerID).StewardshipDisbursementDonorGUID__c = output2.root.Donor.DonorGUID;								
						}
			
						callouts++;
					} else {
						//CreateACHAccount only
						System.debug('Call CreateACHAccount');
						StewardshipTechService.CreateACHAccountRequest input3 = new StewardshipTechService.CreateACHAccountRequest();

						input3.DonorGUID = accountMap.get(payment.customerID).StewardshipDisbursementDonorGUID__c;
						input3.BankAccountType = payment.bankAccountTYpe == 'Savings' ? 'S' : 'C';
						input3.Nickname = payment.description;
						input3.AccountNumber = payment.bankAccountNumber;
						input3.ABARoutingNum = payment.bankRoutingNumber;

						StewardshipTechService.CreateACHAccountResponse output3 = StewardshipTechService.CreateACHAccount(StewardshipTechService.AccountType.DISBURSEMENT, input3);
						payment.disbursementMethodToken = output3.root.Account.AccountGUID;

						callouts++;
					}

				}
				payment.bankRoutingNumber = '********'+payment.bankRoutingNumber.right(4);
				payment.bankAccountNumber = '********'+payment.bankAccountNumber.right(4);	
			}
		}
		if(acctsToUpdate.size()>0){
			update acctsToUpdate.values();
		}

	}

	public static PaymentMethod__c paymentMethodClsToPaymentmMethodObj(PaymentMethod pymntMeth, boolean isUpdate){
		System.debug('PaymentMethodService.paymentMethodClsToPaymentmMethodObj');		
		PaymentMethod__c result = new PaymentMethod__c();
		if(pymntMeth.paymentMethodType == 'Bank'){
			result.RecordTypeID = GlobalUtil.getRecordTypeIDByLabelName('PaymentMethod__c', 'Bank Account');
		}
		else if(pymntMeth.paymentMethodType == 'Credit'){
			result.RecordTypeID = GlobalUtil.getRecordTypeIDByLabelName('PaymentMethod__c', 'Credit Card');
		}
		if(pymntMeth.paymentMethodId != null) result.ID = pymntMeth.paymentMethodId;
		if(pymntMeth.bankAccountNumber != null) result.BankAccountNumber__c = pymntMeth.bankAccountNumber;
		if(pymntMeth.bankRoutingNumber != null) result.BankRoutingNumber__c = pymntMeth.bankRoutingNumber;
		if(pymntMeth.creditCardNumber != null) result.CreditCardNumber__c = pymntMeth.creditCardNumber;
		if(pymntMeth.description != null) result.Description__c = pymntMeth.description;

		if(String.isNotEmpty(pymntMeth.primary)){
			result.Primary__c = pymntMeth.primary == 'true' ?  true : false;
		}
		if(pymntMeth.bankAccountCategory != null) result.BankAccountCategory__c = pymntMeth.bankAccountCategory;
		if(pymntMeth.bankAccountType != null) result.BankAccountType__c = pymntMeth.bankAccountType;
		if(pymntMeth.bankName != null) result.BankName__c = pymntMeth.bankName;				
		if(!isUpdate){
			if(pymntMeth.customerID!= null) result.Customer__c = pymntMeth.customerID;
		}

		if(String.isNotEmpty(pymntMeth.useForRecurring)){
			result.UseForRecurring__c = pymntMeth.useForRecurring == 'true' ?  true : false;
		}
		if(String.isNotEmpty(pymntMeth.useForDisbursements)){
			result.UseForDisbursements__c = pymntMeth.useForDisbursements == 'true' ?  true : false;
		}
		if(String.isNotEmpty(pymntMeth.paymentMethodToken)){
			result.StewardshipPaymentAccountGUID__c = pymntMeth.paymentMethodToken;
		}
		if(String.isNotEmpty(pymntMeth.disbursementMethodToken)){
			result.StewardshipDisbursementAccountGUID__c = pymntMeth.disbursementMethodToken;
		}
		if(String.isNotEmpty(pymntMeth.disbursementMethodToken)){
			result.StewardshipDisbursementAccountGUID__c = pymntMeth.disbursementMethodToken;
		}
		return result;
	}

	public class PaymentMethod{
		public String paymentMethodId {get;set;}
		public String customerID {get;set;}
		public String bankAccountCategory {get;set;}
		public String bankAccountNumber {get;set;}
		public String bankAccountType {get;set;}
		public String bankName {get;set;}
		public String bankRoutingNumber {get;set;}
		public String creditCardNumber {get;set;}
		public String description {get;set;}
		public String primary {get;set;}
		public String useForDisbursements {get;set;}
		public String useForRecurring {get;set;}
		public String paymentMethodType {get;set;}
		public Boolean tokenize {get;set;}
		public String paymentMethodToken {get;set;}
		public String disbursementMethodToken {get;set;}

		public PaymentMethod(){
		}

		public PaymentMethod(Boolean testValues){
			if(testValues){
				this.bankAccountNumber = '1234';
                this.bankRoutingNumber = '5678';
                this.creditCardNumber = '91011';
                this.description = 'Credit Card';
                this.primary = 'true';
			}
		}

		public PaymentMethod(PaymentMethod__c pymntMeth){
//			system.debug('pymntMeth:'+pymntMeth);//encrypted
//			system.debug('pymntMeth.BankRoutingNumber__c:'+pymntMeth.BankRoutingNumber__c);//in clear
			this.paymentMethodId = pymntMeth.ID;
			if(String.isNotEmpty(pymntMeth.BankAccountNumber__c)) this.bankAccountNumber = '********'+pymntMeth.BankAccountNumber__c.right(4);
			if(String.isNotEmpty(pymntMeth.BankRoutingNumber__c)) this.bankRoutingNumber = '********'+pymntMeth.BankRoutingNumber__c.right(4);
			if(String.isNotEmpty(pymntMeth.CreditCardNumber__c)) this.creditCardNumber = '********'+pymntMeth.CreditCardNumber__c.right(4);		
			this.bankAccountCategory = pymntMeth.BankAccountCategory__c;
			this.bankAccountTYpe = pymntMeth.BankAccountType__c;
			this.bankName = pymntMeth.BankName__c;
			this.description = pymntMeth.Description__c;
			this.primary = String.valueOf(pymntMeth.Primary__c);
			this.customerID = pymntMeth.Customer__c;
			this.useForRecurring = String.valueOf(pymntMeth.UseForRecurring__c);
			this.useForDisbursements = String.valueOf(pymntMeth.UseForDisbursements__c);
		}
	}
	public class PaymentMethodServiceException extends Exception {}
}