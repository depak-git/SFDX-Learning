/////////////////////////////////////////////////////////////////////////
// Class: PaymentMethodQueries
// 
// Description: 
// 	
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-13   Jared Hagemann  Created      
// 2017-05-18	Greg Cook 		Changed Student__c to Customer__c                           
/////////////////////////////////////////////////////////////////////////
public class PaymentMethodQueries {
	
	public static Map<String, Object> filterCriteria = new Map<String, Object>();
	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}

	public static Map<ID, PaymentMethod__c> getPaymentMethodMap(){
		Map<ID, PaymentMethod__c> paymentMethodMap = new Map<ID, PaymentMethod__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Inactive__c = false';
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Customer__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		paymentMethodMap = new Map<ID, PaymentMethod__c>((List<PaymentMethod__c>)db.query(query));
		return paymentMethodMap;		
	}

	public static Map<ID, PaymentMethod__c> getPaymentMethodMapWithPaymentMethodID(Set<Id> paymentMethodIds){
		Map<ID, PaymentMethod__c> paymentMethodMap = new Map<ID, PaymentMethod__c>();
		String query = generateSOQLSelect();
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(paymentMethodIds);
		query += ' and Inactive__c = false';
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Customer__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		paymentMethodMap = new Map<ID, PaymentMethod__c>((List<PaymentMethod__c>)db.query(query));
		return paymentMethodMap;		
	}

	public static Map<ID, PaymentMethod__c> getPaymentMethodMapWithCustomerID(Set<Id> customerIDs){
		Map<ID, PaymentMethod__c> paymentMethodMap = new Map<ID, PaymentMethod__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Customer__c IN ' + DatabaseUtil.inSetStringBuilder(customerIDs);
		query += ' and Inactive__c = false';
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Customer__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		paymentMethodMap = new Map<ID, PaymentMethod__c>((List<PaymentMethod__c>)db.query(query));
		return paymentMethodMap;		
	}


	private static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}
	
	private static String buildFilterString(){
		String filterStr = '';
		if(filterCriteria.size()>0){
			for(String filter : filterCriteria.keyset()){
				filterStr += ' and ' +filter+'=\''+String.valueOf(filterCriteria.get(filter) + 	'\' ');
			}			
		}
		return filterStr;
	}

	private static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getFieldNames() + ' FROM PaymentMethod__c';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Name, ';
		fieldNames += 'BankAccountCategory__c, ';
		fieldNames += 'BankAccountNumber__c, ';
		fieldNames += 'BankAccountType__c, ';
		fieldNames += 'BankName__c, ';
		fieldNames += 'BankRoutingNumber__c, ';
		fieldNames += 'CreditCardNumber__c, ';
		fieldNames += 'Customer__c, ';
		fieldNames += 'Description__c, ';
		fieldNames += 'Primary__c, ';
		fieldNames += 'UseForDisbursements__c, ';
		fieldNames += 'UseForRecurring__c, ';
		fieldNames += 'Inactive__c ';		
		return fieldNames;
	}
	
}