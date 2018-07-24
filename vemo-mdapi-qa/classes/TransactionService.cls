/////////////////////////////////////////////////////////////////////////
// Class: TransactionService
// 
// Description: 
//  Handles all Transaction DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-28   Greg Cook       Created
// 2017-01-24   Greg Cook       Renamed and Converted to generic transaction service                         
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class TransactionService {

    /////////////////////////////////////////////////////////////////////
    //Record Type Constants
    /////////////////////////////////////////////////////////////////////
    public static final String disbursementRecType = 'Disbursement';
    public static final String disbursementRefundRecType = 'Disbursement Refund';
    public static final String paymentRecType = 'Payment';
    public static final String paymentRefundRecType = 'Payment Refund';
    public static final String feeRecType = 'Fee';
    public static final String feeRefundRecType = 'Fee Refund';
    public static final String remittanceRecType = 'Remittance';        


    /////////////////////////////////////////////////////////////////////
    //Disbursement Functions
    /////////////////////////////////////////////////////////////////////
    public static List<Disbursement> getDisbursementWithDisbursementID(Set<ID> distributionIDs){
        System.debug('TransactionService.getDisbursementWithDisbursementID');
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithTransactionID(distributionIDs, TransactionService.disbursementRecType);
        List<Disbursement> dists = new List<Disbursement>();
        for(Transaction__c tran : trans.values()){
            Disbursement dist = new Disbursement(tran);
            dists.add(dist);
        }
        return dists;
    }

    public static List<Disbursement> getDisbursementWithAgreementID(Set<ID> studentProgramIDs){
        System.debug('TransactionService.getDisbursementWithAgreementID');
        system.debug(studentProgramIDs);
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithAgreementID(studentProgramIDs, TransactionService.disbursementRecType);
        List<Disbursement> dists = new List<Disbursement>();
        for(Transaction__c tran : trans.values()){
            Disbursement dist = new Disbursement(tran);
            dists.add(dist);
        }
        return dists;
    }

    public static List<Disbursement> getDisbursementWithStudentID(Set<ID> accountIDs){
        System.debug('TransactionService.getDisbursementWithStudentID');
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithStudentID(accountIDs, TransactionService.disbursementRecType);
        List<Disbursement> dists = new List<Disbursement>();
        for(Transaction__c tran : trans.values()){
            Disbursement dist = new Disbursement(tran);
            dists.add(dist);
        }
        return dists;
    }
    
    public static List<Disbursement> getDisbursementWithSchoolID(Set<ID> schoolIDs){
        System.debug('TransactionService.getUnconfirmedDisbursementsWithSchoolID');
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithSchoolID(schoolIDs, TransactionService.disbursementRecType);
        List<Disbursement> dists = new List<Disbursement>();
        for(Transaction__c tran : trans.values()){
            Disbursement dist = new Disbursement(tran);
            dists.add(dist);
        }
        return dists;
    }

    public static Set<Id> createDisbursements(List<Disbursement> disbursement){
        System.debug('TransactionService.createDisbursement');
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
        System.debug('TransactionService.updateDisbursement');
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
        System.debug('TransactionService.deleteDisbursements');
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithTransactionID(disbursementIDs, TransactionService.disbursementRecType);
        Integer numToDelete = trans.size();
        //School admins can't delete due to role hierarchy so they will be flagged and filtered
        for(Transaction__c disb : trans.values()){
            disb.Deleted__c = true;
        }
        update trans.values();
        return numToDelete;
    }
    /////////////////////////////////////////////////////////////////////
    //Disbursement Refund Functions
    /////////////////////////////////////////////////////////////////////
    public static List<DisbursementRefund> getDisbursementRefundWithDisbursementRefundID(Set<ID> distRefundIDs){
        System.debug('TransactionService.getDisbursementRefundWithDisbursementRefundID');
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithTransactionID(distRefundIDs, TransactionService.disbursementRefundRecType);
        List<DisbursementRefund> dists = new List<DisbursementRefund>();
        for(Transaction__c tran : trans.values()){
            DisbursementRefund dist = new DisbursementRefund(tran);
            dists.add(dist);
        }
        return dists;
    }

    public static List<DisbursementRefund> getDisbursementRefundWithAgreementID(Set<ID> studentProgramIDs){
        System.debug('TransactionService.getDisbursementRefundWithAgreementID');
        system.debug(studentProgramIDs);
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithAgreementID(studentProgramIDs, TransactionService.disbursementRefundRecType);
        List<DisbursementRefund> dists = new List<DisbursementRefund>();
        for(Transaction__c tran : trans.values()){
            DisbursementRefund dist = new DisbursementRefund(tran);
            dists.add(dist);
        }
        return dists;
    }

    public static List<DisbursementRefund> getDisbursementRefundWithStudentID(Set<ID> accountIDs){
        System.debug('TransactionService.getDisbursementRefundWithStudentID');
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithStudentID(accountIDs, TransactionService.disbursementRefundRecType);
        List<DisbursementRefund> dists = new List<DisbursementRefund>();
        for(Transaction__c tran : trans.values()){
            DisbursementRefund dist = new DisbursementRefund(tran);
            dists.add(dist);
        }
        return dists;
    }

    public static Set<Id> createDisbursementRefunds(List<DisbursementRefund> disbursementRefunds){
        System.debug('TransactionService.createDisbursementRefunds');
        List<Transaction__c> trans = new List<Transaction__c>();
        for(DisbursementRefund dis : disbursementRefunds){
            Transaction__c tran = disbursementRefundToTransaction(dis);
            trans.add(tran);
        }
        insert trans;
        Set<ID> disIDs = new Set<ID>();
        for(Transaction__c tran : trans){
            disIDs.add(tran.ID);
        }
        return disIDs;
    }

    public static Set<Id> updateDisbursementRefunds(List<DisbursementRefund> disbursementRefunds){
        System.debug('TransactionService.updateDisbursementRefunds');
        List<Transaction__c> trans = new List<Transaction__c>();
        for(DisbursementRefund dis : disbursementRefunds){
            Transaction__c tran = disbursementRefundToTransaction(dis);
            trans.add(tran);
        }
        update trans;
        Set<ID> disIDs = new Set<ID>();
        for(Transaction__c tran : trans){
            disIDs.add(tran.ID);
        }
        return disIDs;
    }

    public static Integer deleteDisbursementRefunds(Set<ID> distRefundIDs){
        System.debug('TransactionService.deleteDisbursementRefunds');
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithTransactionID(distRefundIDs, TransactionService.disbursementRefundRecType);
        Integer numToDelete = trans.size();
        delete trans.values();
        return numToDelete;
    }
    
    /////////////////////////////////////////////////////////////////////
    //Mapper Functions
    /////////////////////////////////////////////////////////////////////
    public static Transaction__c disbursementToTransaction(Disbursement dist){
        System.debug('TransactionService.disbursementToTransaction');
        Transaction__c trans = new Transaction__c();
        
        if(dist.disbursementID != null) trans.ID = dist.disbursementID;
        if(dist.studentID != null) trans.Student__c = dist.studentID;
        if(dist.agreementID != null) trans.Agreement__c = dist.agreementID;
        if(dist.relatedScheduleID != null) trans.RelatedSchedule__c = dist.relatedScheduleID;
        if(dist.amount != null) trans.Amount__c = dist.amount;
        if(dist.disbursementPercentage != null) trans.DisbursementPercentage__c = dist.disbursementPercentage;
        if(dist.transactionDate != null) trans.TransactionDate__c = dist.transactionDate;
        if(dist.status != null) trans.Status__C = dist.status;
        if(dist.specialDisbursementType != null) trans.SpecialDisbursementType__c = dist.specialDisbursementType;
        trans.RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRecType);
        
        if(String.isNotEmpty(dist.confirmed)){
            trans.Confirmed__c = dist.confirmed == 'true' ?  true : false;
        } 
        if(dist.schoolSecurity != null) trans.SchoolSecurity__c = dist.schoolSecurity;
        
        return trans;
    }
    public static Transaction__c disbursementRefundToTransaction(DisbursementRefund distRefund){
        System.debug('TransactionService.disbursementRefundToTransaction');
        Transaction__c trans = new Transaction__c();
        
        if(distRefund.disbursementRefundID != null) trans.ID = distRefund.disbursementRefundID;
        if(distRefund.studentID != null) trans.Student__c = distRefund.studentID;
        if(distRefund.agreementID != null) trans.Agreement__c = distRefund.agreementID;
        if(distRefund.amount != null) trans.Amount__c = distRefund.amount;
        if(distRefund.transactionDate != null) trans.TransactionDate__c = distRefund.transactionDate;
        if(distRefund.status != null) trans.Status__C = distRefund.status;
        trans.RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', TransactionService.disbursementRefundRecType);
        if(distRefund.schoolSecurity != null) trans.SchoolSecurity__c = distRefund.schoolSecurity;

        return trans;
    }

    /////////////////////////////////////////////////////////////////////
    //Record Type Classes
    /////////////////////////////////////////////////////////////////////
    public class Disbursement{
        public String disbursementID {get;set;}
        public String studentID {get;set;}
        public String agreementID {get;set;}
        public String relatedScheduleID {get;set;}
        public Decimal amount {get;set;}
        public Date transactionDate {get;set;}
        public String status {get;set;}
        public Decimal disbursementPercentage {get;set;}
        public String confirmed {get;set;}
        public String schoolSecurity {get;set;}
        public String specialDisbursementType {get;set;}
        public String studentName {get;set;}
        public String programID {get;set;}
        public String programName {get;set;}
        public String agreementStatus {get;set;}
        public String vemoContractNumber {get;set;}
        public Disbursement(){

        }

        public Disbursement(Boolean testValues){
            if(testValues){
                this.transactionDate = Date.today();
                this.amount = 1000; 
                this.status = 'Complete'; //Pending, Scheduled      
            }
        }

        public Disbursement(Transaction__c trans){
            this.disbursementID = trans.ID;
            this.studentID = trans.Student__c;
            this.agreementID = trans.Agreement__c;
            this.relatedScheduleID = trans.RelatedSchedule__c;
            this.amount = trans.Amount__c;
            this.transactionDate = trans.TransactionDate__c;
            this.status = trans.Status__c;
            this.disbursementPercentage = trans.DisbursementPercentage__c;
            this.confirmed = String.valueOf(trans.Confirmed__c);
            this.schoolSecurity = trans.SchoolSecurity__c;
            this.specialDisbursementType = trans.SpecialDisbursementType__c;
            this.studentName = trans.Student__r.name;
            this.programID = trans.Agreement__r.Program__c;
            this.programName = trans.Agreement__r.Program__r.ProgramName__c;
            this.agreementStatus = trans.Agreement__r.Status__c;
            this.vemoContractNumber = trans.Agreement__r.VemoContractNumber__c;
        }
    }

    public class DisbursementRefund{
        public String disbursementRefundID {get;set;}
        public String studentID {get;set;}
        public String agreementID {get;set;}
        public Decimal amount {get;set;}
        public Date transactionDate {get;set;}
        public String status {get;set;}
        public String schoolSecurity {get;set;}

        public DisbursementRefund(){

        }

        public DisbursementRefund(Boolean testValues){
            if(testValues){
                this.transactionDate = Date.today();
                this.amount = 1000; 
                this.status = 'Complete'; //Pending, Scheduled      
            }
        }

        public DisbursementRefund(Transaction__c trans){
            this.disbursementRefundID = trans.ID;
            this.studentID = trans.Student__c;
            this.agreementID = trans.Agreement__c;
            this.amount = trans.Amount__c;
            this.transactionDate = trans.TransactionDate__c;
            this.status = trans.Status__c;
            this.schoolSecurity = trans.SchoolSecurity__c;

        }
    }

}