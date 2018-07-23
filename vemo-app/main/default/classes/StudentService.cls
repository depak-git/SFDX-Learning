/////////////////////////////////////////////////////////////////////////
// Class: StudentService
// 
// Description: 
//  Handles all Student DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-17   Greg Cook       Created  
// 2016-12-21   Greg Cook       Created student logical entity, remoed dependency to api
// 2016-12-25   Greg Cook       Added null checks on mapper    
// 2017-01-12   Greg Cook       Added student references                     
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class StudentService {

    //Take in account ID and return list of students
    public static List<Student> getStudentsWithStudentID(Set<ID> studentIDs){
        system.debug('StudentService.getStudentsWithStudentID()');
        Map<ID, Account> acctMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
        List<Student> students = new List<Student>();
        for(Account acct : acctMap.values()){
            students.add(new Student(acct));
        }
        return students;
    }

    public static List<Student> getStudentsWithAuthID(Set<String> authIDs){
        system.debug('StudentService.getStudentsWithAuthID()');
        Map<String, Account> acctMap = AccountQueries.getStudentMapByAuthIDWithAuthID(authIDs);
        List<Student> students = new List<Student>();
        for(Account acct : acctMap.values()){
            students.add(new Student(acct));
        }
        return students;
    }
    public static List<Student> getStudentsWithEmail(Set<String> emails){
        system.debug('StudentService.getStudentsWithEmail()');
        Map<ID, Account> acctMap = AccountQueries.getStudentMapWithPersonEmails(emails);
        List<Student> students = new List<Student>();
        for(Account acct : acctMap.values()){
            students.add(new Student(acct));
        }
        return students;
    }

    public static Map<ID, Integer> getStudentDelinquencyMap(Set<ID> studentIDs){
        system.debug('StudentService.getStudentsWithEmail()');
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithStudentID(studentIDs, true);//where servicing is true
        Map<ID, Integer> delinqencyMap = new Map<ID, Integer>();
        for(StudentProgram__c agreement : agreementMap.values()){
            if(!delinqencyMap.containsKey(agreement.Student__c)){
                delinqencyMap.put(agreement.Student__c, Integer.valueOf(agreement.DaysDelinquent__c));
            } else if(delinqencyMap.get(agreement.Student__c) < agreement.DaysDelinquent__c){
                delinqencyMap.put(agreement.Student__c, Integer.valueOf(agreement.DaysDelinquent__c));
            }
        }
        return delinqencyMap;
    }



    /////////////////////////////student reference quereies/////////////////////////////
    public static List<StudentReference> getStudentReferencesWithStudentID(Set<ID> studentIDs){
        system.debug('StudentService.getStudentReferencesWithStudentID()');
        Map<ID, Contact> contMap = ContactQueries.getStudentReferenceMapWithStudentID(studentIDs);
        List<StudentReference> studentReferences = new List<StudentReference>();
        for(Contact cont : contMap.values()){
            studentReferences.add(new StudentReference(cont));
        }
        return studentReferences;
    }
    public static List<StudentReference> getStudentReferencesWithReferenceID(Set<ID> referenceIDs){
        system.debug('StudentService.getStudentReferencesWithReferenceID()');
        Map<ID, Contact> contMap = ContactQueries.getStudentReferenceMapWithReferenceID(referenceIDs);
        List<StudentReference> studentReferences = new List<StudentReference>();
        for(Contact cont : contMap.values()){
            studentReferences.add(new StudentReference(cont));
        }
        return studentReferences;
    }



    
    public static Set<Id> createStudents(List<Student> students){
        system.debug('StudentService.createStudents()');
        List<Account> accts = new List<Account>();
        for(Student stud : students){
            Account acct = studentToAccount(stud);
            acct.RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student');
//          acct.RecordStatus__pc = 'Approved';
            acct.id = null;
//          acct.GUID__c = null;
            accts.add(acct);
        }
        system.debug(accts);
        insert accts;
        Set<Id> studentIDs = new Set<Id>();
        for(Account acct : accts){
            studentIDs.add(acct.Id);
        }
        return studentIDs;
    }


    public static Set<Id> createStudentReferences(List<StudentReference> studentReferences){
        system.debug('StudentService.createStudentReferences()');
        Set<ID> collegeIDs = new Set<ID>();
        List<Contact> conts = new List<Contact>();
        for(StudentReference studRef : studentReferences){
            Contact cont = studentReferenceToContact(studRef);
            cont.RecordTypeID = GlobalUtil.getRecordTypeIdByLabelName('Contact', 'Student Reference');
            cont.RecordStatus__c = 'Approved';
            cont.AccountId = GlobalSettings.getSettings().vemoAccountID;
            cont.id = null;
            conts.add(cont);
        }
        system.debug(conts);
        insert conts;
        Set<Id> studentRefIDs = new Set<Id>();
        for(Contact cont : conts){
            studentRefIDs.add(cont.Id);
        }
        return studentRefIDs;
    }


    //Take in student class object, update person accounts, return Ids
    public static Set<Id> updateStudents(List<Student> students){
        system.debug('StudentService.updateStudents()');
        List<Account> accts = new List<Account>();
        Set<ID> acctIDs = new Set<ID>();
        for(Student stud : students){
            acctIDs.add(stud.personAccountID);
        }
        Map<ID, Account> existingAccounts = AccountQueries.getStudentMapWithStudentID(acctIDs);
        for(Student stud : students){
            Account accountToUpdate = studentToAccount(stud);
            //accts.add(studentToAccount(stud));
            if(existingAccounts.containsKey(stud.personAccountID)){
                Account oldAcct = existingAccounts.get(stud.personAccountID);
//              if(oldAcct.PersonBirthdate == stud.birthdate) accountToUpdate.PendingBirthdate__pc = null;
//              if(oldAcct.FirstName == stud.firstName) accountToUpdate.PendingFirstName__pc = '';
//              if(oldAcct.LastName == stud.lastName) accountToUpdate.PendingLastName__pc = '';
//              if(oldAcct.MiddleName == stud.middleName) accountToUpdate.PendingMiddleName__pc = '';
//              if(oldAcct.Residency__pc == stud.residency) accountToUpdate.PendingResidency__pc = '';
            }
            accts.add(accountToUpdate);
        }
        update accts;
        Set<Id> studentIDs = new Set<Id>();
        for(Account acct : accts){
            studentIDs.add(acct.Id);
        }
        return studentIDs;
    }
    
    public static Set<Id> updateStudentReferences(List<StudentReference> studentReferences){
        system.debug('StudentService.updateStudentReferences()');
        List<Contact> conts = new List<Contact>();
        for(StudentReference ref : studentReferences){
            conts.add(studentReferenceToContact(ref));
        }
        update conts;
        Set<Id> refIDs = new Set<Id>();
        for(Contact cont : conts){
            refIDs.add(cont.Id);
        }
        return refIDs;
    }



    //Take in account Id, deletes account, retunrs number of accounts deleted
    public static Integer deleteStudents(Set<ID> studentIDs){   
        system.debug('StudentService.deleteStudents()');
        Map<ID, Account> accts = AccountQueries.getStudentMapWithStudentID(studentIDs);     
        Integer numToDelete = accts.size();
        delete accts.values();
        return numToDelete;
    }

    public static Integer deleteStudentReferences(Set<ID> studentReferencesIDs){    
        system.debug('StudentService.deleteStudentReferences()');
        Map<ID, Contact> conts = ContactQueries.getStudentReferenceMapWithReferenceID(studentReferencesIDs);        
        Integer numToDelete = conts.size();
        delete conts.values();
        return numToDelete;
    }  
    
    public static void sendAnnualStatements(Set<ID> studentIDs){
        Map<ID, Account> acctMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
        
        List<OutboundEmail__c> emailToBeCreated = new List<OutboundEmail__c>();
        for(Account acct : acctMap.values()){
            emailToBeCreated.add(annualStatementEmail(acct));
            acct.Receive_Annual_Statement__c = false;
        } 
        if(emailToBeCreated != null && emailToBeCreated.size()>0){
            insert emailToBeCreated;
        }   
        upsert acctMap.values();
    } 
    
    private static OutboundEmail__c annualStatementEmail(Account student){
         
        EmailTemplate template = [Select id from EmailTemplate where DeveloperName =: 'Annual_Account_Statement'];
        
        if(template != null){
            return new OutboundEmail__c(ToAddresses__c = student.PersonEmail,
                                      TemplateID__c = template.id,
                                      WhatID__c = student.id,
                                      TargetObjectId__c = student.PersonContactID,
                                      SendviaSES__c = true);
        }
        else
            return null;
    }
     
    public static Account studentToAccount(Student stud){
        system.debug('StudentService.studentToAccount()');
        Account acct = new Account();
        if(stud.personAccountID != null) acct.ID = stud.personAccountID;
        acct.RecordTypeID = GlobalUtil.getRecordTypeIDByLabelName('Account', 'Student');
        if(stud.firstName != null) acct.firstName = stud.firstName; 
        if(stud.middleName != null) acct.MiddleName = stud.middleName;
        if(stud.lastName != null) acct.LastName = stud.lastName;
        if(stud.email != null) acct.PersonEmail = stud.email;
        if(stud.birthdate != null) acct.PersonBirthdate = stud.birthdate;
        if(stud.authSystemUserID != null) acct.AuthSystemUserID__pc = stud.authSystemUserID;
        if(stud.primarySchoolID != null) acct.PrimarySchool__pc = stud.primarySchoolID;
        if(stud.primarySchoolStudentID != null) acct.PrimarySchoolStudentID__pc = stud.primarySchoolStudentID;
        if(stud.primarySchoolEmail != null) acct.PrimarySchoolEmail__pc = stud.primarySchoolEmail;
        if(stud.driversLicenseOrStateID != null) acct.DriversLicenseOrStateID__pc = stud.driversLicenseOrStateID;
        if(stud.primarySchoolGraduationDate != null) acct.PrimarySchoolGraduationDate__pc = stud.primarySchoolGraduationDate;
        if(stud.primarySchoolEnrollmentStatus != null) acct.PrimarySchoolEnrollmentStatus__pc = stud.primarySchoolEnrollmentStatus;
        if(stud.primarySchoolGradeLevel != null) acct.PrimarySchoolGradeLevel__pc = stud.primarySchoolGradeLevel;
        if(stud.residency != null) acct.Residency__pc = stud.residency;
        if(stud.preferredMethodOfCommunication != null) acct.PreferredMethodOfCommunication__pc = stud.preferredMethodOfCommunication;
        if(stud.salutation != null) acct.Salutation = stud.salutation;
        if(stud.ssnTaxID != null) acct.SSNTaxID__pc = stud.ssnTaxID;
        if(stud.suffix != null) acct.Suffix = stud.suffix;
//      if(stud.guid != null) acct.GUID__c = stud.guid;
        if(stud.doNotCall != null) acct.PersonDoNotCall = stud.doNotCall;
        if(stud.doNotEmail != null) acct.PersonHasOptedOutOfEmail = stud.doNotEmail;
        if(stud.homePhone != null) acct.PersonHomePhone = stud.homePhone;
        if(stud.mailingCity != null) acct.PersonMailingCity = stud.mailingCity;
        if(stud.mailingCountry != null) acct.PersonMailingCountry = stud.mailingCountry;
        if(stud.mailingPostalCode != null) acct.PersonMailingPostalCode = stud.mailingPostalCode;
        if(stud.mailingState != null) acct.PersonMailingState = stud.mailingState;
        if(stud.mailingStreet != null) acct.PersonMailingStreet = stud.mailingStreet;
        if(stud.otherCity != null) acct.PersonOtherCity = stud.otherCity;
        if(stud.otherCountry != null) acct.PersonOtherCountry = stud.otherCountry;
        if(stud.otherPostalCode != null) acct.PersonOtherPostalCode = stud.otherPostalCode;
        if(stud.otherState != null) acct.PersonOtherState = stud.otherState;
        if(stud.otherStreet != null) acct.PersonOtherStreet = stud.otherStreet;

        if(stud.mobilePhone != null) acct.PersonMobilePhone = stud.mobilePhone;
        if(stud.doNotText != null) acct.HasOptedOutOfText__pc = stud.doNotText;
        if(stud.timeZone != null) acct.TimeZone__pc = stud.timeZone;
        if(stud.schoolProgramOfStudyID != null) acct.SchoolProgramOfStudy__pc = stud.schoolProgramOfStudyID;

//      if(stud.pendingResidency != null) acct.PendingResidency__pc = stud.pendingResidency;
//      if(stud.pendingFirstName != null) acct.PendingFirstName__pc = stud.pendingFirstName;
//      if(stud.pendingMiddleName != null) acct.PendingMiddleName__pc = stud.pendingMiddleName;
//      if(stud.pendingLastName != null) acct.PendingLastName__pc = stud.pendingLastName;
//      if(stud.pendingBirthdate != null) acct.PendingBirthdate__pc = stud.pendingBirthdate;
//      if(stud.pendingDriversLicenseOrStateID != null) acct.PendingDriversLicenseOrStateID__pc = stud.pendingDriversLicenseOrStateID;
//      if(stud.pendingEmail != null) acct.PendingEmail__pc = stud.pendingEmail;
//      if(stud.recordStatus != null) acct.RecordStatus__pc = stud.recordStatus;
//      if(stud.pendingMailingStreet != null) acct.PendingMailingStreet__pc = stud.pendingMailingStreet;
//      if(stud.pendingMailingCity != null) acct.PendingMailingCity__pc = stud.pendingMailingCity;
//      if(stud.pendingMailingState != null) acct.PendingMailingState__pc = stud.pendingMailingState;
//      if(stud.pendingMailingStateCode != null) acct.PendingMailingStateCode__pc = stud.pendingMailingStateCode;
//      if(stud.pendingMailingCountry != null) acct.PendingMailingCountry__pc = stud.pendingMailingCountry;
//      if(stud.pendingMailingCountryCode != null) acct.PendingMailingCountryCode__pc = stud.pendingMailingCountryCode;
//      if(stud.pendingMailingPostalCode != null) acct.PendingMailingPostalCode__pc = stud.pendingMailingPostalCode;
        if(stud.commonLineID != null) acct.CommonLineID__pc = stud.commonLineID;
        if(stud.credit != null) acct.Credit__pc = stud.credit;
        if(String.isNotEmpty(stud.autoPayment)){
            acct.AutoPayment__pc = stud.autoPayment == 'true' ?  true : false;
        }       
        System.debug(stud.autoPaymentDateActivated);
        if(stud.autoPaymentDateActivated != null) acct.AutoPaymentDateActivated__pc = stud.autoPaymentDateActivated;    

        if(stud.autoPaymentFrequency != null) acct.AutoPaymentFrequency__pc = stud.autoPaymentFrequency;
        if(stud.autoPaymentDayOfMonth1 != null) acct.AutoPaymentDayOfMonth1__pc = stud.autoPaymentDayOfMonth1;
        if(stud.autoPaymentDayOfMonth2 != null) acct.AutoPaymentDayOfMonth2__pc = stud.autoPaymentDayOfMonth2;

        if(stud.verifiedAnnualIncome != null) acct.VerifiedAnnualIncome__pc = stud.verifiedAnnualIncome;
        if(stud.dateIncomeVerified != null) acct.DateIncomeVerified__pc = stud.dateIncomeVerified;
        //if(stud.unpaidFees != null) acct.UnpaidFees__c = stud.unpaidFees;
        if(stud.schoolSecurity != null) acct.SchoolSecurity__c = stud.schoolSecurity;
        
            
        return acct;
    }




    public class Student{
        //this class is used as the logical entity for the student which would not normally be necessary if there was a physical object
        //but since there is not, we create a veritual entity here that can be used in the service layer        
        public String firstName {get;set;}
        public String middleName {get;set;}
        public String lastName {get;set;}
        public String email {get;set;}
        public String authSystemUserID {get;set;}
        public Date birthdate {get;set;}
        public String primarySchoolID {get;set;}
        public String primarySchoolStudentID {get;set;}
        public String primarySchoolEmail {get;set;}
        public Date primarySchoolGraduationDate {get;set;}
        public String primarySchoolEnrollmentStatus {get;set;}
        public String primarySchoolGradeLevel {get;set;}
        public String driversLicenseOrStateID {get;set;}
        public String residency {get;set;}
        public String preferredMethodOfCommunication {get;set;}
        public String salutation {get;set;}
        public String ssnTaxID {get;set;}
        public String suffix {get;set;}
//      public String guid {get;set;}
        public Boolean doNotCall {get;set;}
        public Boolean doNotEmail {get;set;}
        public String homePhone {get;set;}
        public String mailingCity {get;set;}
        public String mailingCountry {get;set;}
        public String mailingCountryCode {get;set;}
        public String mailingPostalCode {get;set;}
        public String mailingState {get;set;}
        public String mailingStateCode {get;set;}
        public String mailingStreet {get;set;}
        public String otherCity {get;set;}
        public String otherCountry {get;set;}
        public String otherCountryCode {get;set;}
        public String otherPostalCode {get;set;}
        public String otherState {get;set;}
        public String otherStateCode {get;set;}
        public String otherStreet {get;set;}
        public String mobilePhone {get;set;}
        public Boolean doNotText {get;set;}
        public String timeZone {get;set;}
        public String personAccountID {get;set;}
        public String schoolProgramOfStudyID {get;set;}

//      public String pendingResidency {get;set;}
//      public String pendingFirstName {get;set;}
//      public String pendingMiddleName {get;set;}
//      public String pendingLastName {get;set;}
//      public Date pendingBirthdate {get;set;}
//      public String pendingDriversLicenseOrStateID {get;set;}
//      public String pendingEmail {get;set;}
//      public String recordStatus {get;set;}
//      public String pendingMailingStreet {get;set;}
//      public String pendingMailingCity {get;set;}
//      public String pendingMailingState {get;set;}
//      public String pendingMailingStateCode {get;set;}
//      public String pendingMailingCountry {get;set;}
//      public String pendingMailingCountryCode {get;set;}
//      public String pendingMailingPostalCode {get;set;}
        public String commonLineID {get;set;}
        public String accountNumber {get;set;}
        public Decimal credit {get;set;}
        public String autoPayment {get;set;}
        public Date autoPaymentDateActivated {get;set;}
        public String autoPaymentFrequency {get;set;}
        public String autoPaymentDayOfMonth1 {get;set;}
        public String autoPaymentDayOfMonth2 {get;set;}

        public Decimal verifiedAnnualIncome {get;set;}
        public Date dateIncomeVerified {get;set;}
        public Decimal unpaidFees {get;set;}
        public String schoolSecurity {get;set;}
        
        public Decimal cumulativeIncomeShare {get;set;}
        public Decimal cumulativeIncomeShareCap {get;set;}




        public Student(){

        }
        public Student(Boolean testValues){
            if(testValues){
                this.firstName = 'Test First';
                this.middleName = 'Test Middle';
                this.lastName = 'Test Last';
                this.email = 'email@email.com';
                this.authSystemUserID = '123';
                this.birthdate = Date.today();
                this.primarySchoolID = null;//'123';
                this.primarySchoolStudentID  = '123';
                this.primarySchoolEmail  = 'email@email.com';
                this.primarySchoolGraduationDate  = Date.today();
                this.primarySchoolEnrollmentStatus  = 'Full Time';
                this.primarySchoolGradeLevel  = 'Freshman';
                this.driversLicenseOrStateID  = '123';
                this.residency  = 'US Citizen';
                this.preferredMethodOfCommunication  = 'Call';
                this.salutation  = '123';
                this.ssnTaxID  = '123';
                this.suffix  = '123';
//              this.guid = '123';
                this.doNotCall = true;
                this.doNotEmail = true;
                this.homePhone  = '123';
                this.mailingCity  = '123';
                this.mailingCountry  = 'United States';
                this.mailingPostalCode  = '123';
                this.mailingState  = 'Colorado';
                this.mailingStreet  = '123';
                this.otherCity  = '123';
                this.otherCountry  = 'United States';
                this.otherPostalCode  = '123';
                this.otherState  = 'Colorado';
                this.otherStreet  = '123';
                this.mobilePhone  = '123';
                this.doNotText = true;
                this.timeZone  = '(GMT-7) Mountain Standard Time (America/Denver)';
                this.personAccountID = null;
//              this.pendingResidency = '123';
//              this.pendingFirstName = '123';
//              this.pendingMiddleName = '123';
//              this.pendingLastName = '123';
//              this.pendingBirthdate = Date.today();
//              this.pendingDriversLicenseOrStateID = '123';
//              this.pendingEmail = 'email2@email2.com';
//              this.recordStatus = 'Approved';
//              this.pendingMailingStreet = '123';
//              this.pendingMailingCity = '123';
//              this.pendingMailingState = '123';
//              this.pendingMailingStateCode = '123';
//              this.pendingMailingCountry = '123';
//              this.pendingMailingCountryCode = '123';
//              this.pendingMailingPostalCode = '123';
                this.commonLineID = '123';
            }
        }
        public Student(Account acct){
            this.personAccountID = acct.ID;
            this.firstName = acct.FirstName;
            this.middleName = acct.MiddleName;
            this.lastName = acct.LastName;
            this.email = acct.PersonEmail;
            this.birthdate = acct.PersonBirthdate;
            this.authSystemUserID = acct.AuthSystemUserID__pc;
            this.primarySchoolID = acct.PrimarySchool__pc;
            this.primarySchoolStudentID = acct.PrimarySchoolStudentID__pc;
            this.primarySchoolEmail = acct.PrimarySchoolEmail__pc;
            this.driversLicenseOrStateID = acct.DriversLicenseOrStateID__pc;
            this.primarySchoolGraduationDate = acct.PrimarySchoolGraduationDate__pc;
            this.primarySchoolEnrollmentStatus = acct.PrimarySchoolEnrollmentStatus__pc;
            this.primarySchoolGradeLevel = acct.PrimarySchoolGradeLevel__pc;
            this.residency = acct.Residency__pc;
            this.preferredMethodOfCommunication = acct.PreferredMethodOfCommunication__pc;
            this.salutation = acct.Salutation;
            if(String.isNotEmpty(acct.SSNTaxID__pc)) this.ssnTaxID = '***-**-'+acct.SSNTaxID__pc.right(4);
            this.suffix = acct.Suffix;
//          this.guid = acct.GUID__c;
            this.doNotCall = acct.PersonDoNotCall;
            this.doNotEmail = acct.PersonHasOptedOutOfEmail;
            this.homePhone = acct.PersonHomePhone;
            this.mailingCity = acct.PersonMailingCity;
            this.mailingCountry = acct.PersonMailingCountry;
            this.mailingCountryCode = acct.PersonMailingCountryCode;
            this.mailingPostalCode = acct.PersonMailingPostalCode;
            this.mailingState = acct.PersonMailingState;
            this.mailingStateCode = acct.PersonMailingStateCode;
            this.mailingStreet = acct.PersonMailingStreet;
            this.otherCity = acct.PersonOtherCity;
            this.otherCountry = acct.PersonOtherCountry;
            this.otherCountryCode = acct.PersonOtherCountryCode;
            this.otherPostalCode = acct.PersonOtherPostalCode;
            this.otherState = acct.PersonOtherState;
            this.otherStateCode = acct.PersonOtherStateCode;
            this.otherStreet = acct.PersonOtherStreet;
            this.mobilePhone = acct.PersonMobilePhone;
            this.doNotText = acct.HasOptedOutOfText__pc;
            this.timeZone = acct.TimeZone__pc;
            this.schoolProgramOfStudyID = acct.SchoolProgramOfStudy__pc;

//          this.pendingResidency = acct.PendingResidency__pc;
//          this.pendingFirstName = acct.PendingFirstName__pc;
//          this.pendingMiddleName  = acct.PendingMiddleName__pc;
//          this.pendingLastName = acct.PendingLastName__pc;
//          this.pendingBirthdate = acct.PendingBirthdate__pc;
//          this.pendingDriversLicenseOrStateID = acct.PendingDriversLicenseOrStateID__pc;
//          this.pendingEmail = acct.PendingEmail__pc;
//          this.recordStatus = acct.RecordStatus__pc;
//          this.pendingMailingStreet = acct.PendingMailingStreet__pc;
//          this.pendingMailingCity = acct.PendingMailingCity__pc;
//          this.pendingMailingState = acct.PendingMailingState__pc;
//          this.pendingMailingStateCode = acct.PendingMailingStateCode__pc;
//          this.pendingMailingCountry = acct.PendingMailingCountry__pc;
//          this.pendingMailingCountryCode = acct.PendingMailingCountryCode__pc;
//          this.pendingMailingPostalCode = acct.PendingMailingPostalCode__pc;
            this.commonLineID = acct.CommonLineID__pc;
            this.accountNumber = acct.VemoAccountNumber__c;
            this.credit = acct.Credit__pc;
            this.autoPayment = String.valueOf(acct.AutoPayment__pc);
            this.autoPaymentDateActivated = acct.AutoPaymentDateActivated__pc;
            this.autoPaymentFrequency = acct.AutoPaymentFrequency__pc;
            this.autoPaymentDayOfMonth1 = acct.AutoPaymentDayOfMonth1__pc;
            this.autoPaymentDayOfMonth2 = acct.AutoPaymentDayOfMonth2__pc;
            
            this.verifiedAnnualIncome = acct.VerifiedAnnualIncome__pc;
            this.dateIncomeVerified = acct.DateIncomeVerified__pc;
            this.unpaidFees = acct.UnpaidFees__c;
            this.schoolSecurity = acct.SchoolSecurity__c;
            
            this.cumulativeIncomeShare = acct.CumulativeIncomeShare__pc;
            this.cumulativeIncomeShareCap = acct.CumulativeIncomeShareCap__pc; 

        }


    }
    public static Contact studentReferenceToContact(StudentReference studRef){
        system.debug('StudentService.studentReferenceToContact()');
        Contact cont = new Contact();
        if(studRef.studentID != null) cont.Student__c = studRef.studentID;
        if(studRef.referenceID != null) cont.ID = studRef.referenceID;
        if(studRef.firstName != null) cont.FirstName = studRef.firstName;
        if(studRef.lastName != null) cont.LastName = studRef.LastName;
        if(studRef.middleName != null) cont.MiddleName = studRef.middleName;
        if(studRef.street != null) cont.MailingStreet = studRef.street;
        if(studRef.city != null) cont.MailingCity = studRef.city;
        if(studRef.state != null) cont.MailingState = studRef.state;
        if(studRef.country != null) cont.MailingCountry = studRef.country;
        if(studRef.postalCode != null) cont.MailingPostalCode = studRef.postalCode;
        if(studRef.primaryPhone != null) cont.Phone = studRef.primaryPhone;

//      if(studRef.pendingFirstName != null) cont.PendingFirstName__c = studRef.pendingFirstName;
//      if(studRef.pendingMiddleName != null) cont.PendingMiddleName__c = studRef.pendingMiddleName;
//      if(studRef.pendingLastName != null) cont.PendingLastName__c = studRef.pendingLastName;
//      if(studRef.recordStatus != null) cont.RecordStatus__c = studRef.recordStatus;
//      if(studRef.pendingMailingStreet != null) cont.PendingMailingStreet__c = studRef.pendingMailingStreet;
//      if(studRef.pendingMailingCity != null) cont.PendingMailingCity__c = studRef.pendingMailingCity;
//      if(studRef.pendingMailingState != null) cont.PendingMailingState__c = studRef.pendingMailingState;
//      if(studRef.pendingMailingStateCode != null) cont.PendingMailingStateCode__c = studRef.pendingMailingStateCode;
//      if(studRef.pendingMailingCountry != null) cont.PendingMailingCountry__c = studRef.pendingMailingCountry;
//      if(studRef.pendingMailingCountryCode != null) cont.PendingMailingCountryCode__c = studRef.pendingMailingCountryCode;
//      if(studRef.pendingMailingPostalCode != null) cont.PendingMailingPostalCode__c = studRef.pendingMailingPostalCode;
        if(studRef.relationship != null) cont.Relationship__c = studRef.relationship;

        return cont;
    }
    
    public class StudentReference {
        public String studentID {get;set;}
        public String referenceID {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        public String middleName {get;set;}
        public String street {get;set;}
        public String city {get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String postalCode {get;set;}
        public String primaryPhone {get;set;}


//      public String pendingFirstName {get;set;}
//      public String pendingMiddleName {get;set;}
//      public String pendingLastName {get;set;}
//
//      public String recordStatus {get;set;}
//      public String pendingMailingStreet {get;set;}
//      public String pendingMailingCity {get;set;}
//      public String pendingMailingState {get;set;}
//      public String pendingMailingStateCode {get;set;}
//      public String pendingMailingCountry {get;set;}
//      public String pendingMailingCountryCode {get;set;}
//      public String pendingMailingPostalCode {get;set;}
        public String relationship {get;set;}
        

        public StudentReference(){

        }
        public StudentReference(Contact cont){
            this.studentID = cont.Student__c;
            this.referenceID = cont.id;
            this.firstName = cont.FirstName;
            this.lastName = cont.LastName;
            this.middleName = cont.MiddleName;
            this.street = cont.MailingStreet;
            this.city = cont.MailingCity;
            this.state = cont.MailingState;
            this.country = cont.MailingCountry;
            this.postalCode = cont.MailingPostalCode;
            this.primaryPhone  = cont.Phone;


//          this.pendingFirstName = cont.PendingFirstName__c;
//          this.pendingMiddleName  = cont.PendingMiddleName__c;
//          this.pendingLastName = cont.PendingLastName__c;
//
//          this.recordStatus = cont.RecordStatus__c;
//          this.pendingMailingStreet = cont.PendingMailingStreet__c;
//          this.pendingMailingCity = cont.PendingMailingCity__c;
//          this.pendingMailingState = cont.PendingMailingState__c;
//          this.pendingMailingStateCode = cont.PendingMailingStateCode__c;
//          this.pendingMailingCountry = cont.PendingMailingCountry__c;
//          this.pendingMailingCountryCode = cont.PendingMailingCountryCode__c;
//          this.pendingMailingPostalCode = cont.PendingMailingPostalCode__c;
            this.relationship = cont.Relationship__c;
            
        }
        public StudentReference(Boolean testValues){
            if(testValues){
                this.firstName = 'First';
                this.lastName = 'Last';
                this.middleName = 'Middle';
                this.city = 'City';
                this.state = 'Colorado';
                this.country = 'United States';
                this.postalCode = '12345';
                this.primaryPhone = '12345';


//              this.pendingFirstName = '123';
//              this.pendingMiddleName = '123';
//              this.pendingLastName = '123';
//
//              this.recordStatus = '123';
//              this.pendingMailingStreet = '123';
//              this.pendingMailingCity = '123';
//              this.pendingMailingState = '123';
//              this.pendingMailingStateCode = '123';
//              this.pendingMailingCountry = '123';
//              this.pendingMailingCountryCode = '123';
//              this.pendingMailingPostalCode = '123';
                this.relationship = 'Spouse';

            }
        }
        
    }

}