public with sharing class LedgerService {
    public enum LedgerType {DISBURSEMENT, FEE, PAYMENTINSTRUCTION, AMOUNTDUE, REFUND}    
    /////////////////////////////////////////////////////////////////////
    //Disbursement Functions
    /////////////////////////////////////////////////////////////////////
    public static List<JournalEntry> getJournalEntriesWithCustomerID(Set<ID> customerIDs, Set<LedgerType> exclusionList){
        System.debug('LedgerService.getJournalEntriesWithCustomerID');
        List<JournalEntry> journalEntries = new List<JournalEntry>();

        if(exclusionList == null || (exclusionList != null && !exclusionList.contains(LedgerType.DISBURSEMENT))){
            //Get All Disbursements
            Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithStudentID(customerIDs, TransactionService.disbursementRecType);
            for(Transaction__c tran : trans.values()){
                JournalEntry journalEntry = new JournalEntry(tran);
                journalEntries.add(journalEntry);
            }
        }

        if(exclusionList == null || (exclusionList != null && !exclusionList.contains(LedgerType.FEE))){
            //Get All Fees
            Map<ID, Fee__c> fees = FeeQueries.getFeeMapWithCustomerId(customerIDs);
            for(Fee__c fee : fees.values()){
                JournalEntry journalEntry = new JournalEntry(fee);
                journalEntries.add(journalEntry);
            }    
        }    

        if(exclusionList == null || (exclusionList != null && !exclusionList.contains(LedgerType.PAYMENTINSTRUCTION))){
            //Get All Payments
            Map<Id, PaymentInstruction__c> pymntInsMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentStudentID(customerIDs);
            for(PaymentInstruction__c pymntIns : pymntInsMap.values()){
                JournalEntry journalEntry = new JournalEntry(pymntIns);
                journalEntries.add(journalEntry);
            }
        }

        if(exclusionList == null || (exclusionList != null && !exclusionList.contains(LedgerType.AMOUNTDUE))){
            //Get All Amounts Due
            Map<Id, StudentProgramAmountDue__c> amountDueMap = StudProgAmountDueQueries.getAmountDueMapWithStudentID(customerIDs);
            for(StudentProgramAmountDue__c amountDue : amountDueMap.values()){
                if(String.isEmpty(amountDue.Refund__c)){
                    JournalEntry journalEntry = new JournalEntry(amountDue);
                    journalEntries.add(journalEntry);                    
                }
            }
        }

        if(exclusionList == null || (exclusionList != null && !exclusionList.contains(LedgerType.REFUND))){
            //Get All Refunds
            Map<Id, Refund__c> refundMap = new Map<ID, Refund__c>([SELECT id, RefundDate__c, Amount__c, Status__c, Account__c, Agreement__c
                                                                   FROM Refund__c
                                                                   WHERE Account__c IN :customerIDs]);
            for(Refund__c refund : refundMap.values()){
                JournalEntry journalEntry = new JournalEntry(refund);
                journalEntries.add(journalEntry);
            }
        }
        journalEntries.sort();
        
        return journalEntries;
    }
	public LedgerService() {
		
	}
    public class JournalEntry implements Comparable{
        public Integer compareTo(Object compareTo){
            JournalEntry compareToJournalEntry = (JournalEntry)compareTo;
            if(transactionDate == compareToJournalEntry.transactionDate) return 0;
            if(transactionDate > compareToJournalEntry.transactionDate) return 1;
            return -1;
        }
        public String customerID {get;set;}
        public String agreementID {get;set;}
        public Date transactionDate {get;set;}
        public Decimal transactionAmount {get;set;}


        public String disbursementID {get;set;}
        public Decimal disbursementAmount {get;set;}
        public Date disbursementDate {get;set;}
        public String disbursementStatus {get;set;}
        public String disbursementConfirmed {get;set;}

		public String feeID {get;set;}
		public Decimal feeAmount {get;set;}
		public Date feeDateAssessed {get;set;}
		public Date feeDateCleared {get;set;}
		public String feeStatus {get;set;}
		public String feeType {get;set;}

        public String paymentInstructionID {get;set;}
        public Decimal paymentAmount {get;set;}
        public Decimal paymentAmountAllocated {get;set;}
        public Decimal paymentRemainingAllocation {get;set;}
        public Date paymentDate {get;set;}
        public Date paymentDatePosted {get;set;}
        public Decimal paymentAmountPosted {get; set;}
        public String paymentStatus {get;set;}
        public String paymentDescription {get;set;}

        public String amountDueID {get;set;}
        public Decimal amountDueAmount {get;set;}
        public DateTime amountDueAssessmentDateTime {get;set;}
        public String amountDueExclude {get;set;}
        public String amountDueMonthlyStatus {get;set;}
        public String amountDueType {get;set;}

        public String refundID {get;set;}
        public Decimal refundAmount {get;set;}
        public DateTime refundDate {get;set;}
        public String refundStatus {get;set;}
        public String refundType {get;set;}

        public JournalEntry(Transaction__c trans){

            this.customerID = trans.Student__c;
            this.agreementID = trans.Agreement__c;
            

            this.disbursementID = trans.ID;
            this.disbursementAmount = trans.Amount__c;
            this.disbursementDate = trans.TransactionDate__c;
            this.disbursementStatus = trans.Status__c;
            this.disbursementConfirmed = String.valueOf(trans.Confirmed__c);
            this.transactionAmount = trans.Amount__c;
            this.transactionDate = trans.TransactionDate__c;
      	
        }

        public JournalEntry(Fee__c fee){

            this.customerID = fee.Customer__c;
            this.feeID = fee.id;
            this.feeAmount = fee.Amount__c;
            this.feeDateAssessed = fee.DateAssessed__c;
            this.feeDateCleared = fee.DateCleared__c;
            this.feeStatus = fee.Status__c;
            this.feeType = fee.Type__c;
            this.transactionAmount = fee.Amount__c;
            this.transactionDate = fee.DateAssessed__c;
      	
        }
        
        public JournalEntry(PaymentInstruction__c payment){
        	this.customerID = payment.Student__c;
            this.paymentInstructionID = payment.id;
            this.paymentAmount = payment.Amount__c;
            this.paymentAmountAllocated = payment.AmountAllocated__c;
            this.paymentRemainingAllocation = payment.RemainingAllocation__c;
            this.paymentDate = payment.Date__c;
            this.paymentDatePosted = payment.DatePosted__c;
            this.paymentAmountPosted = payment.AmountPosted__c;
            this.paymentStatus = payment.Status__c;
            this.paymentDescription = payment.Description__c;
            this.transactionAmount = (payment.Amount__c * -1);
            this.transactionDate = payment.Date__c;
        }

        public JournalEntry(StudentProgramAmountDue__c amountDue){
        	this.customerID = amountDue.Agreement__r.Student__c;
        	this.agreementID = amountDue.Agreement__c;
        	this.amountDueID = amountDue.id;
        	this.amountDueAmount = amountDue.Amount__c;
        	this.amountDueAssessmentDateTime = amountDue.AssessmentDateTime__c;
        	this.amountDueExclude = String.valueOf(amountDue.ExcludeFromBalance__c);
        	this.amountDueMonthlyStatus = amountDue.StudentProgramMonthlyStatus__c;
        	this.amountDueType = amountDue.Type__c;
            this.transactionAmount = amountDue.Amount__c;
            DateTime dT = amountDue.AssessmentDateTime__c;
            this.transactionDate = date.newinstance(dT.year(), dT.month(), dT.day());
        }

        public JournalEntry(Refund__c refund){
            this.customerID = refund.Account__c;
            this.agreementID = refund.Agreement__c;

            this.refundID = refund.id;
            this.refundAmount = refund.Amount__c;
            this.refundDate = refund.RefundDate__c;
            this.refundStatus = refund.Status__c;
            //this.refundType = refund.Amount__c;
            this.transactionAmount = refund.Amount__c;
            this.transactionDate = refund.RefundDate__c;
        }
        

        
        public JournalEntry(Boolean testValues){
            if(testValues){
   
            }
        }
    }
}