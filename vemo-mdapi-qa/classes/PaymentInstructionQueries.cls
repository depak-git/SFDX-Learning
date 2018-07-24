/////////////////////////////////////////////////////////////////////////
// Class: PaymentInstructionQueries
// 
// Description: 
// 	
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-18   Jared Hagemann  Created      
// 2017-05-18	Greg Cook 		Changed Student__c to Customer__c                           
/////////////////////////////////////////////////////////////////////////
public class PaymentInstructionQueries {
	public static Map<String, Object> filterCriteria = new Map<String, Object>();
	public static void clearFilterCriteria(){
		filterCriteria.clear();
	}

	public static Map<ID, PaymentInstruction__c> getPaymentInstructionMap(){
		Map<ID, PaymentInstruction__c> paymentInstructionMap = new Map<ID, PaymentInstruction__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Id != null';
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' order by CreatedDate asc';
		query += ' '+ generateLIMITStatement();

		DatabaseUtil db = new DatabaseUtil();
		paymentInstructionMap = new Map<ID, PaymentInstruction__c>((List<PaymentInstruction__c>)db.query(query));
		return paymentInstructionMap;		
	}

	public static Map<ID, PaymentInstruction__c> getPaymentInstructionMapWithPaymentInstructionID(Set<Id> paymentInstructionIds){
		Map<ID, PaymentInstruction__c> paymentInstructionMap = new Map<ID, PaymentInstruction__c>();
		String query = generateSOQLSelect();
		query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(paymentInstructionIds);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' order by CreatedDate asc';
		query += ' '+ generateLIMITStatement();

		DatabaseUtil db = new DatabaseUtil();
		paymentInstructionMap = new Map<ID, PaymentInstruction__c>((List<PaymentInstruction__c>)db.query(query));
		return paymentInstructionMap;		
	}

	public static Map<ID, PaymentInstruction__c> getPaymentInstructionMapWithPaymentStudentID(Set<Id> studentIds){
		Map<ID, PaymentInstruction__c> paymentInstructionMap = new Map<ID, PaymentInstruction__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIds);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
		}
		query += buildFilterString();		
		query += ' order by CreatedDate asc';
		query += ' '+ generateLIMITStatement();

		DatabaseUtil db = new DatabaseUtil();
		paymentInstructionMap = new Map<ID, PaymentInstruction__c>((List<PaymentInstruction__c>)db.query(query));
		return paymentInstructionMap;		
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
		soql = 'SELECT ' + getFieldNames() + ' FROM PaymentInstruction__c';
		return soql;
	}

	private static String getFieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
		fieldNames += 'Name, ';
		fieldNames += 'CreatedDate, ';
		fieldNames += 'Amount__c, ';
		fieldNames += 'AmountAllocated__c, ';
		fieldNames += 'FullyAllocated__c, ';
		fieldNames += 'RemainingAllocation__c, ';
		fieldNames += 'Date__c, ';
		fieldNames += 'Description__c, ';
		fieldNames += 'PaymentMethod__c, ';
		fieldNames += 'Student__c, ';
		fieldNames += 'Student__r.UnpaidFees__c, ';
		fieldNames += 'DatePosted__c, ';
		fieldNames += 'AmountPosted__c, ';
		fieldNames += 'TransactionDirection__c, ';
		fieldNames += 'Status__c ';
		return fieldNames;
	}
}