/////////////////////////////////////////////////////////////////////////
// Class: IncomeVerificationService
// 
// Description: 
//  Handles all IncomeVerification DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-12   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class IncomeVerificationService {
    public static List<IncomeVerification> getIncomeVerificationWithIncomeVerificationID(Set<ID> incomeVerificationIDs){
        System.debug('IncomeVerificationService.getIncomeVerificationWithIncomeVerificationID');
        Map<Id, IncomeVerification__c> incVerMap = IncomeVerificationQueries.getIncomeVerificationMapWithIncomeVerificationId(incomeVerificationIDs);
        List<IncomeVerification> incVerList = new List<IncomeVerification>();
        for(IncomeVerification__c incVer : incVerMap.values()){
            incVerList.add(new IncomeVerification(incVer));
        }
        return incVerList;
    }


    public static List<IncomeVerification> getIncomeVerificationWithStudentId(Set<ID> studentIds){
        System.debug('IncomeVerificationService.getIncomeVerificationWithStudentId');
        Map<Id, IncomeVerification__c> incVerMap = IncomeVerificationQueries.getIncomeVerificationMapWithStudentId(studentIds);
        List<IncomeVerification> incVerList = new List<IncomeVerification>();
        for(IncomeVerification__c incVer : incVerMap.values()){
            incVerList.add(new IncomeVerification(incVer));
        }
        return incVerList;
    }

    public static Set<Id> createIncomeVerification(List<IncomeVerification> incomeVerifications){
        System.debug('IncomeVerificationService.createIncomeVerification');
        List<IncomeVerification__c> incVerList = new List<IncomeVerification__c>();
        for(IncomeVerification incVer : incomeVerifications){
            IncomeVerification__c incVerObj = incVerClassToIncVerObject(incVer);
            incVerList.add(incVerObj);
        }
        insert incVerList;
        Set<Id> incVerIDs = new Set<Id>();
        for(IncomeVerification__c incVer : incVerList){
            incVerIDs.add(incVer.ID);
        }
        return incVerIDs;
    }

    public static Set<Id> updateIncomeVerification(List<IncomeVerification> incomeVerifications){
        System.debug('IncomeVerificationService.updateIncomeVerification');
        List<IncomeVerification__c> incVerList = new List<IncomeVerification__c>();
        for(IncomeVerification incVer : incomeVerifications){
            IncomeVerification__c incVerObj = incVerClassToIncVerObject(incVer);
            incVerList.add(incVerObj);
        }
        update incVerList;
        Set<Id> incVerIDs = new Set<Id>();
        for(IncomeVerification__c incVer : incVerList){
            incVerIDs.add(incVer.ID);
        }
        return incVerIDs;
    }

    public static Integer deleteIncomeVerificationy(Set<ID> incomeVerificationIDs){
        System.debug('IncomeVerificationService.deleteIncomeVerificationy');
        Map<ID, IncomeVerification__c> incVerMap = IncomeVerificationQueries.getIncomeVerificationMapWithIncomeVerificationId(incomeVerificationIDs);
        Integer numToDelete = incVerMap.size();
        delete incVerMap.values();
        return numToDelete;
    }


    public static IncomeVerification__c incVerClassToIncVerObject(IncomeVerification incVerClass){
        IncomeVerification__c incVerObj = new IncomeVerification__c();
        if(incVerClass.incomeVerificationID != null) incVerObj.ID = incVerClass.incomeVerificationID;

        if(incVerClass.incomePerMonth != null) incVerObj.IncomePerMonth__c = incVerClass.incomePerMonth;        
        if(incVerClass.employmentHistoryID != null) incVerObj.EmploymentHistory__c = incVerClass.employmentHistoryID;
        if(incVerClass.dateVerified != null) incVerObj.DateVerified__c = incVerClass.dateVerified;
        if(incVerClass.dateReported != null) incVerObj.DateReported__c = incVerClass.dateReported;
        if(incVerClass.beginDate != null) incVerObj.BeginDate__c = incVerClass.beginDate;       
        if(incVerClass.studentID != null) incVerObj.Student__c = incVerClass.studentID;
        if(incVerClass.endDate != null) incVerObj.EndDate__c = incVerClass.endDate;
        if(String.isNotEmpty(incVerClass.verified)){
            incVerObj.Verified__c = incVerClass.verified == 'true' ?  true : false;
        }       
        if(incVerClass.type != null) incVerObj.Type__c = incVerClass.type;
        if(incVerClass.status != null) incVerObj.Status__c = incVerClass.status;
        
        return incVerObj;
    }


    public class IncomeVerification{
        public String incomeVerificationID {get;set;}
        public Decimal incomePerYear {get;set;}
        public Decimal incomePerMonth {get;set;}
        public String employmentHistoryID {get;set;}
        public Date dateVerified {get;set;}
        public Date dateReported {get;set;}
        public Date beginDate {get;set;}
        public Date endDate {get;set;}
        public String studentID {get;set;}
        public String verified {get;set;}
        public String type {get;set;}
        public String status {get;set;}

        public IncomeVerification(){

        }

        public IncomeVerification(Boolean testValues){
            if(testValues){
                this.incomePerMonth = 5000; 
                this.dateVerified = System.today(); 
                this.verified = 'true'; 
            }
        }

        public IncomeVerification(IncomeVerification__c incVer){
            this.incomeVerificationID = incVer.ID;
            this.incomePerYear = incVer.IncomePerYear__c;   
            this.incomePerMonth = incVer.IncomePerMonth__c;
            this.employmentHistoryID = incVer.EmploymentHistory__c;     
            this.dateVerified = incVer.DateVerified__c;
            this.dateReported = incVer.DateReported__c;
            this.beginDate = incVer.BeginDate__c;
            this.type = incVer.Type__c;
            this.studentID = incVer.Student__c;
            this.verified = String.valueOf(incVer.Verified__c);
            this.endDate = incVer.EndDate__c;
            this.status = incVer.Status__c;
        }
    }
}