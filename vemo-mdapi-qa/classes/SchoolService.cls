/////////////////////////////////////////////////////////////////////////
// Class: SchoolService
// 
// Description: 
//  Handles all School Service DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
public with sharing class SchoolService {

    public static List<School> getSchoolCustomers(){
        System.debug('SchoolService.getSchoolCustomers');
        Map<ID, Account> acctMap = AccountQueries.getSchoolCustomerMap();
        List<School> schools = new List<School>();
        for(Account acct : acctMap.values()){
            schools.add(new School(acct));
        }
        return schools;
    }

    public static List<School> getSchoolsWithSchoolID(Set<ID> schoolIDs){
        System.debug('SchoolService.getSchoolsWithSchoolID');
        Map<ID, Account> acctMap = AccountQueries.getSchoolMapWithSchoolID(schoolIDs);
        List<School> schools = new List<School>();
        for(Account acct : acctMap.values()){
            schools.add(new School(acct));
        }
        return schools;
    }

    public static List<School> getSchoolsWithSchoolName(Set<String> schoolNames){
        System.debug('SchoolService.getSchoolsWithSchoolName');
        system.debug('schoolNames:'+schoolNames);
        Map<ID, Account> acctMap = AccountQueries.getSchoolMapWithSchoolName(schoolNames);
        List<School> schools = new List<School>();
        for(Account acct : acctMap.values()){
            schools.add(new School(acct));
        }
        return schools;
        return null;
    }
    
    public static List<School> getSchoolsWithEntryPoint(Set<String> entryPoints){
        System.debug('SchoolService.getSchoolsWithEntryPoints');
        system.debug('entryPoints:'+entryPoints);
        Map<ID, Account> acctMap = AccountQueries.getSchoolMapWithEntryPoint(entryPoints);
        List<School> schools = new List<School>();
        for(Account acct : acctMap.values()){
            schools.add(new School(acct));
        }
        return schools;
        return null;
    }
    
    public static Set<Id> createSchool(List<School> schools){
        System.debug('SchoolService.createSchool');
        List<Account> accts = new List<Account>();
        for(School schl : schools){
            Account acct = schoolToAccount(schl);
            accts.add(acct);
        }
        insert accts;
        Set<Id> schoolIDs = new Set<Id>();
        for(Account acct : accts){
            schoolIDs.add(acct.ID);
        }
        return schoolIDs;
    }
    
    
    public static Set<Id> updateSchool(List<School> schools){
        System.debug('SchoolService.updateSchool');
        List<Account> accts = new List<Account>();
        for(School schl : schools){
            Account acct = schoolToAccount(schl);
            accts.add(acct);
        }
        update accts;
        Set<Id> schoolIDs = new Set<Id>();
        for(Account acct : accts){
            schoolIDs.add(acct.ID);
        }
        return schoolIDs;
    }   
    
    public static Integer deleteSchool(Set<ID> schoolIDs){
        System.debug('SchoolService.deleteSchool');
        Map<ID, Account> accts = AccountQueries.getSchoolMapWithSchoolID(schoolIDs);
        System.debug('******************Schools Returned = ' + accts.size());
        Integer numToDelete = accts.size();
        delete accts.values();
        return numToDelete;
    }
    
    public static  Account schoolToAccount(School schl){
        System.debug('SchoolService.schoolToAccount');      
        Account acct = new Account();
        acct.RecordTypeID = GlobalUtil.getRecordTypeIDByLabelName('Account', 'School - Customer');
        if(schl.schoolID != null) acct.ID = schl.schoolID;
        if(schl.guid != null) acct.GUID__c = schl.guid;
        if(schl.schoolName != null) acct.Name = schl.schoolName;
        if(schl.entryPoint != null) acct.EntryPoint__c = schl.entryPoint;
        if(schl.websiteStatus != null) acct.WebsiteStatus__c = schl.websiteStatus;
        if(schl.webStyle != null) acct.WebStyle__c = schl.webStyle;
        if(schl.displayName!= null) acct.DisplayName__c = schl.displayName;
        if(schl.titleBlock != null) acct.TitleBlock__c = schl.titleBlock;
        if(schl.descriptionBlock != null) acct.DescriptionBlock__c = schl.descriptionBlock;
        if(schl.detailBlock!= null) acct.DetailBlock__c = schl.detailBlock;
        return acct;
    }

    public class School{
        public String schoolID {get;set;}
        public String guid {get;set;}
        public String schoolName {get;set;}
        public String accountNumber {get;set;}
        public String entryPoint {get;set;}
        public String websiteStatus {get;set;}
        public String webStyle {get;set;}
        public String displayName {get;set;}
        public String schoolLogoURL {get;set;}
        public String titleBlock {get;set;}
        public String descriptionBlock {get;set;}
        public String detailBlock {get;set;}
        public String campusServiceName {get;set;}
        public String campusServiceEmail {get;set;}
        public String campusServiceMobile {get;set;}
        public String campusServiceAvailability {get;set;}
        
        public String StudentcampusServiceName {get;set;}
        public String StudentcampusServiceEmail {get;set;}
        public String StudentcampusServiceMobile {get;set;}
        public String StudentcampusServiceAvailability {get;set;}
        
        public School(){

        }

        public School(Boolean testValues){
            if(testValues){
                this.schoolName = 'Test School';
            }
        }

        public School(Account acct){
            this.schoolID = acct.ID;
            this.guid = acct.GUID__c;
            this.schoolName = acct.Name;
            this.accountNumber = acct.VemoAccountNumber__c;
            this.entryPoint = acct.EntryPoint__c;
            this.websiteStatus = acct.WebsiteStatus__c;
            this.webStyle = acct.WebStyle__c;
            this.displayName = acct.DisplayName__c;
            this.schoolLogoURL = acct.SchoolLogoURL__c;
            this.titleBlock = acct.TitleBlock__c;
            this.descriptionBlock = acct.DescriptionBlock__c;
            this.detailBlock = acct.DetailBlock__c;
            
            this.campusServicename = acct.CampusServiceName__c;
            this.campusServiceEmail = acct.CampusServiceEmail__c;
            this.campusServiceMobile = acct.CampusServiceMobile__c;
            this.campusServiceAvailability = acct.CampusServiceAvailability__c;
            
            this.StudentcampusServicename = acct.StudentCampusServiceName__c;
            this.StudentcampusServiceEmail = acct.StudentCampusServiceEmail__c;
            this.StudentcampusServiceMobile = acct.StudentCampusServiceMobile__c;
            this.StudentcampusServiceAvailability = acct.StudentCampusServiceAvailability__c;
        }

    }
    
}