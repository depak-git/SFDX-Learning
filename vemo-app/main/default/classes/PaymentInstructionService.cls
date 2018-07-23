/////////////////////////////////////////////////////////////////////////
// Class: PaymentInstructionService
// 
// Description: 
//  Handles all PaymentInstruction DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-13   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class PaymentInstructionService {
    
    public static List<PaymentInstruction> getPaymentInstructionWithPaymentInstructionID(Set<ID> paymentInstructionIDs){
        System.debug('PaymentInstructionService.getPaymentInstructionWithPaymentInstructionID');
        Map<Id, PaymentInstruction__c> pymntInsMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentInstructionID(paymentInstructionIDs);
        List<PaymentInstruction> pymntInsList = new List<PaymentInstruction>();
        for(PaymentInstruction__c pymntIns : pymntInsMap.values()){
            pymntInsList.add(new PaymentInstruction(pymntIns));
        }
        return pymntInsList;
    }
    
    public static List<PaymentInstruction> getPaymentInstructionWithStudentID(Set<ID> studentIDs){
        System.debug('PaymentInstructionService.getPaymentInstructionWithStudentID');
        Map<Id, PaymentInstruction__c> pymntInsMap = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentStudentID(studentIDs);
        List<PaymentInstruction> pymntInsList = new List<PaymentInstruction>();
        for(PaymentInstruction__c pymntIns : pymntInsMap.values()){
            pymntInsList.add(new PaymentInstruction(pymntIns));
        }
        return pymntInsList;
    }

    public static Set<Id> createPaymentInstruction(List<PaymentInstruction> paymentInstructions){
        System.debug('PaymentInstructionService.createPaymentInstruction');
        List<PaymentInstruction__c> pymntInsList = new List<PaymentInstruction__c>();
        for(PaymentInstruction pymntIns : paymentInstructions){
            PaymentInstruction__c pymntInsObj = paymentMethodClsToPaymentmMethodObj(pymntIns);
            pymntInsList.add(pymntInsObj);
        }
        insert pymntInsList;
        Set<Id> pymntInsIDs = new Set<Id>();
        for(PaymentInstruction__c pymntIns : pymntInsList){
            pymntInsIDs.add(pymntIns.ID);
        }
        return pymntInsIDs;
    }

    public static Set<Id> updatePaymentInstruction(List<PaymentInstruction> paymentInstructions){
        System.debug('PaymentInstructionService.createPaymentInstruction');
        List<PaymentInstruction__c> pymntInsList = new List<PaymentInstruction__c>();
        for(PaymentInstruction pymntIns : paymentInstructions){
            PaymentInstruction__c pymntInsObj = paymentMethodClsToPaymentmMethodObj(pymntIns);
            pymntInsList.add(pymntInsObj);
        }
        update pymntInsList;
        Set<Id> pymntInsIDs = new Set<Id>();
        for(PaymentInstruction__c pymntIns : pymntInsList){
            pymntInsIDs.add(pymntIns.ID);
        }
        return pymntInsIDs;
    }

    public static Integer deletePaymentInstruction(Set<ID> paymentInstructionIds){
        System.debug('PaymentInstructionService.deletePaymentInstruction');
        Map<ID, PaymentInstruction__c> pymntIns = PaymentInstructionQueries.getPaymentInstructionMapWithPaymentInstructionID(paymentInstructionIds);
        Integer numToDelete = pymntIns.size();
        delete pymntIns.values();
        return numToDelete;
    }

    public static PaymentInstruction__c paymentMethodClsToPaymentmMethodObj(PaymentInstruction input){
        System.debug('PaymentMethodService.paymentMethodClsToPaymentmMethodObj');       
        PaymentInstruction__c result = new PaymentInstruction__c();
        if(input.paymentInstructionID != null) result.ID = input.paymentInstructionID;
        if(input.amount != null) result.Amount__c = input.amount;
        if(input.paymentDate != null) result.Date__c = input.paymentDate;
        if(input.paymentMethodID != null) result.PaymentMethod__c = input.paymentMethodID;
        if(input.studentID != null) result.Student__c = input.studentID;
        if(input.datePosted != null) result.DatePosted__c = input.datePosted;
        if(input.amountPosted != null) result.AmountPosted__c = input.amountPosted;
        if(input.transactionDirection != null) result.TransactionDirection__c = input.transactionDirection;
        if(input.status != null) result.Status__c = input.status;
        if(input.description != null) result.Description__c = input.description;
        return result;
    }



    public class PaymentInstruction{
        public String paymentInstructionID {get;set;}
        public Decimal amount {get;set;}
        public Decimal amountAllocated {get;set;}
        public Decimal remainingAllocation {get;set;}
        public Date paymentDate {get;set;}
        public String paymentMethodID {get;set;}
        public String studentID {get;set;}
        public Date datePosted {get;set;}
        public Decimal amountPosted {get; set;}
        public String transactionDirection {get;set;}
        public String status {get;set;}
        public String description {get;set;}

        public PaymentInstruction(){
        }

        public PaymentInstruction(Boolean testValues){
            if(testValues){
                this.amount = 1000;
                this.paymentDate = System.today();
                this.status = 'None';
            }
        }

        public PaymentInstruction(PaymentInstruction__c pymntIns){
            this.paymentInstructionID = pymntIns.ID;    
            this.amount = pymntIns.Amount__c;
            this.amountAllocated = pymntIns.AmountAllocated__c;
            this.remainingAllocation = pymntIns.RemainingAllocation__c;
            this.paymentDate = pymntIns.Date__c;
            this.paymentMethodID = pymntIns.PaymentMethod__c;
            this.studentID = pymntIns.Student__c;
            this.datePosted = pymntIns.DatePosted__c;
            this.amountPosted = pymntIns.AmountPosted__c;
            this.transactionDirection = pymntIns.TransactionDirection__c;
            this.status = pymntIns.Status__c;
            this.description = pymntIns.Description__c;
        }
    }
}