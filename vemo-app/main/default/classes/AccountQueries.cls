/////////////////////////////////////////////////////////////////////////
// Class: AccountQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-07-13   Greg Cook       Created                                 
// 2016-12-17   Greg Cook       Added getStudent(), added fields to getStudentMapByID
// 2016-12-20   Greg Cook       Changed all functions to maps, changed function names to overloaded functions
// 2016-12-24   Greg Cook       Added StudentMayByAuthIDWithAuthID, changed function names
// 2017-02-09   Greg Cook       Added filterCriteria
/////////////////////////////////////////////////////////////////////////
public class AccountQueries {
    public static Map<String, Object> filterCriteria = new Map<String, Object>();
    public static void clearFilterCriteria(){
        filterCriteria.clear();
    }

    public static Map<String, Account> getStudentMapByAuthIDWithAuthID(Set<String> authIDs){
        Map<String, Account> acctMapByAuthID = new Map<String, Account>();
        String query = generateSOQLSelect('student');
        query += ' WHERE AuthSystemUserID__pc IN ' + DatabaseUtil.inSetStringBuilder(authIDs);
        query += ' and ' + generateRecordTypeStatement('Student');

        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        Map<ID, Account> retMap = new Map<ID, Account>((List<Account>)db.query(query));

        for(Account acct : retMap.values()){
            acctMapByAuthID.put(acct.AuthSystemUserID__pc, acct);
        }
        system.debug('acctMapByAuthID:'+acctMapByAuthID);
        return acctMapByAuthID;
    }

    public static Map<ID, Account> getStudentMap(){
        Map<ID, Account> acctMap = new Map<ID, Account>();
        String query = generateSOQLSelect('student');
        query += ' WHERE ' + generateRecordTypeStatement('Student');
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        acctMap = new Map<ID, Account>((List<Account>)db.query(query));
        return acctMap;     
    }
    
    public static Map<ID, Account> getStudentMapWithPersonEmails(Set<String> personEmails){
        Map<ID, Account> acctMap = new Map<ID, Account>();
        String query = generateSOQLSelect('student');
        query += ' WHERE ' + generateRecordTypeStatement('Student');
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += ' and PersonEmail IN ' + DatabaseUtil.inSetStringBuilder(personEmails)+ ' ';
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        acctMap = new Map<ID, Account>((List<Account>)db.query(query));
        return acctMap;     
    }

    public static Map<ID, Account> getStudentMapWithStudentID(Set<ID> studentIDs){
        Map<ID, Account> acctMap = new Map<ID, Account>();
        String query = generateSOQLSelect('student');       
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
        query += ' and ' + generateRecordTypeStatement('Student');
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        acctMap = new Map<ID, Account>((List<Account>)db.query(query));
        return acctMap;     
        
    }   
    
    public static Map<ID, Account> getStudentMapWithVemoAccountNumber(Set<string> vemoAccountNos){
        Map<ID, Account> acctMap = new Map<ID, Account>();
        String query = generateSOQLSelect('student');
        query += ' WHERE ' + generateRecordTypeStatement('Student');
        if(DatabaseUtil.filterByStudentID){
            ID studentID = DatabaseUtil.studentPersonAccountID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
        }
        query += ' and VemoAccountNumber__c IN ' + DatabaseUtil.inSetStringBuilder(vemoAccountNos)+ ' ';
        query += buildFilterString();       
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        acctMap = new Map<ID, Account>((List<Account>)db.query(query));
        return acctMap;     
        
    }  

    ///////////////////////////////////////////////////////////////////////////////////////////
    // School Queries
    ///////////////////////////////////////////////////////////////////////////////////////////
    public static Map<ID, Account> getSchoolMap(){
        Map<ID, Account> schlMap = new Map<ID, Account>();
        String query = generateSOQLSelect('school');        
        query += ' WHERE ' + generateRecordTypeStatement('School - Available Prospect');
        query += 'or ' + generateRecordTypeStatement('School - Customer');
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        schlMap = new Map<ID, Account>((List<Account>)db.query(query));
        return schlMap;     
    }
    
    public static Map<ID, Account> getSchoolCustomerMap(){
        Map<ID, Account> schlMap = new Map<ID, Account>();
        String query = generateSOQLSelect('school');        
        query += ' WHERE ' + generateRecordTypeStatement('School - Customer');
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        schlMap = new Map<ID, Account>((List<Account>)db.query(query));
        return schlMap;     
    }
    public static Map<ID, Account> getSchoolMapWithSchoolID(Set<ID> schoolIDs){
        Map<ID, Account> schlMap = new Map<ID, Account>();
        String query = generateSOQLSelect('school');    
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);          
        query += ' and ';
        query += '(' + generateRecordTypeStatement('School - Available Prospect');

        query += ' or ' + generateRecordTypeStatement('School - Customer') + ') ';
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        schlMap = new Map<ID, Account>((List<Account>)db.query(query));
        return schlMap;         
    }   

    public static Map<ID, Account> getSchoolMapWithSchoolName(Set<String> schoolNames){
        Map<ID, Account> schlMap = new Map<ID, Account>();
        String query = generateSOQLSelect('school');    
        query += ' WHERE Name IN ' + DatabaseUtil.inSetStringBuilder(schoolNames);  
        query += ' and ';
        query += '(' + generateRecordTypeStatement('School - Available Prospect');

        query += ' or ' + generateRecordTypeStatement('School - Customer') + ') ';
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        schlMap = new Map<ID, Account>((List<Account>)db.query(query));
        return schlMap;     
    }

    public static Map<ID, Account> getSchoolMapWithEntryPoint(Set<String> entryPoints){
        Map<ID, Account> schlMap = new Map<ID, Account>();
        String query = generateSOQLSelect('school');    
        query += ' WHERE EntryPoint__c IN ' + DatabaseUtil.inSetStringBuilder(entryPoints); 
        query += ' and ';
        query += '(' + generateRecordTypeStatement('School - Available Prospect');

        query += ' or ' + generateRecordTypeStatement('School - Customer') + ') ';
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and ID = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += buildFilterString();
        query += ' '+ generateLIMITStatement();
        system.debug('***query'+query);
        DatabaseUtil db = new DatabaseUtil();
        schlMap = new Map<ID, Account>((List<Account>)db.query(query));
        return schlMap;     
    }

    private static String generateSOQLSelect(String type){
        String soql;
        if(type == 'student'){
            soql = 'SELECT ' + getStudentFieldNames() + ' FROM Account';
        }
        else if(type == 'school'){
            soql = 'SELECT ' + getSchoolFieldNames() + ' FROM Account';
        }
        return soql;
    }

    private static String getStudentFieldNames(){
        String fieldNames;
        //Account Fields

        fieldNames = 'id, ';
//      fieldNames += 'GUID__c, ';
        fieldNames += 'DueDayOfTheMonth__c, ';
        fieldNames += 'AssessmentDayOfMonth__c, ';
        fieldNames += 'RecordTypeID, ';
        fieldNames += 'Salutation, ';
        fieldNames += 'FirstName, ';
        fieldNames += 'MiddleName, ';
        fieldNames += 'LastName, ';
        fieldNames += 'Suffix, ';
        fieldNames += 'SchoolSecurity__c, ';
        fieldNames += 'PersonBirthDate, ';
        fieldNames += 'PersonEmail, ';
        fieldNames += 'PersonDoNotCall, ';
        fieldNames += 'PersonHasOptedOutOfEmail, ';
        fieldNames += 'PersonHomePhone, ';
        fieldNames += 'PersonMailingCity, ';
        fieldNames += 'PersonMailingCountry, ';
        fieldNames += 'PersonMailingCountryCode, ';     
        fieldNames += 'PersonMailingPostalCode, ';
        fieldNames += 'PersonMailingState, ';
        fieldNames += 'PersonMailingStateCode, ';
        fieldNames += 'PersonMailingStreet, ';
        fieldNames += 'PersonOtherCity, ';
        fieldNames += 'PersonOtherCountry, ';
        fieldNames += 'PersonOtherCountryCode, ';       
        fieldNames += 'PersonOtherPostalCode, ';
        fieldNames += 'PersonOtherState, ';
        fieldNames += 'PersonOtherStateCode, ';
        fieldNames += 'PersonOtherStreet, ';
        fieldNames += 'PersonMobilePhone, ';
        fieldNames += 'PersonContactID, ';

        //Contact fields
        fieldNames += 'AuthSystemUserID__pc, ';
        fieldNames += 'DriversLicenseOrStateID__pc, ';
        fieldNames += 'Residency__pc, ';
        fieldNames += 'PreferredMethodOfCommunication__pc, ';
        fieldNames += 'SSNTaxID__pc, ';
        fieldNames += 'HasOptedOutOfText__pc, ';
        fieldNames += 'TimeZone__pc, ';
        fieldNames += 'PrimarySchool__pc, ';
//      fieldNames += 'PrimarySchool__pr.GUID__c, ';
        fieldNames += 'PrimarySchoolStudentID__pc, ';
        fieldNames += 'PrimarySchoolEmail__pc, ';
        fieldNames += 'PrimarySchoolGraduationDate__pc, ';
        fieldNames += 'PrimarySchoolEnrollmentStatus__pc, ';
        fieldNames += 'PrimarySchoolGradeLevel__pc, ';
        fieldNames += 'SchoolProgramOfStudy__pc, '; 
        fieldNames += 'CommonLineID__pc, '; 
//      fieldNames += 'PendingFirstName__pc, '; 
//      fieldNames += 'PendingMiddleName__pc, ';    
//      fieldNames += 'PendingLastName__pc, ';  
//      fieldNames += 'PendingBirthdate__pc, '; 
//      fieldNames += 'PendingDriversLicenseOrStateID__pc, ';   
//      fieldNames += 'PendingEmail__pc, '; 
//      fieldNames += 'RecordStatus__pc, '; 
//      fieldNames += 'PendingMailingStreet__pc, '; 
//      fieldNames += 'PendingMailingCity__pc, ';   
//      fieldNames += 'PendingMailingState__pc, ';
//      fieldNames += 'PendingMailingStateCode__pc, ';
//      fieldNames += 'PendingMailingCountry__pc, ';
//      fieldNames += 'PendingMailingCountryCode__pc, ';
//      fieldNames += 'PendingMailingPostalCode__pc, ';
        fieldNames += 'VemoAccountNumber__c, ';
        fieldNames += 'VerifiedAnnualIncome__pc, ';

//      fieldNames += 'PendingResidency__pc, ';
        fieldNames += 'Credit__pc, ';
        fieldNames += 'AutoPayment__pc, ';
        fieldNames += 'AutoPaymentFrequency__pc, ';
        fieldNames += 'AutoPaymentDayOfMonth1__pc, ';
        fieldNames += 'AutoPaymentDayOfMonth2__pc, ';
        fieldNames += 'AutoPaymentDateActivated__pc, ';
        fieldNames += 'Age__pc, ';  
        fieldNames += 'DateIncomeVerified__pc, ';
        fieldNames += 'StewardshipPaymentDonorGUID__c, ';
        fieldNames += 'StewardshipDisbursementDonorGUID__c, ';
        fieldNames += 'UnpaidFees__c, ';
        fieldNames += 'CumulativeIncomeShare__pc, ';
        fieldNames += 'CumulativeIncomeShareCap__pc ';

        return fieldNames;
    }

    private static String getSchoolFieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'GUID__c, ';
        fieldNames += 'Name, ';
        fieldNames += 'BillingStreet, ';
        fieldNames += 'BillingCity, ';
        fieldNames += 'BillingCountry, ';
        fieldNames += 'BillingCountryCode, ';
        fieldNames += 'BillingPostalCode, ';
        fieldNames += 'BillingState, ';
        fieldNames += 'BillingStateCode, ';
        fieldNames += 'CampusServiceName__c, ';
        fieldNames += 'CampusServiceEmail__c, ';
        fieldNames += 'CampusServiceMobile__c, ';
        fieldNames += 'CampusServiceAvailability__c, ';
        fieldNames += 'VemoAccountNumber__c, ';
        fieldNames += 'EntryPoint__c, ';
        fieldNames += 'WebsiteStatus__c, ';
        fieldNames += 'WebStyle__c, ';
        fieldNames += 'DisplayName__c, ';
        fieldNames += 'SchoolLogoURL__c, ';
        fieldNames += 'TitleBlock__c, ';
        fieldNames += 'DescriptionBlock__c, ';
        fieldNames += 'DetailBlock__c, ';
        fieldNames += 'SchoolSecurity__c, ';
        fieldNames += 'StudentCampusServiceAvailability__c, ';
        fieldNames += 'StudentCampusServiceEmail__c, ';
        fieldNames += 'StudentCampusServiceMobile__c, ';
        fieldNames += 'StudentCampusServiceName__c ';
        return fieldNames;
    }
    
    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }

    private static String generateRecordTypeStatement(String recordTypeLabel){
        ID recordTypeID = (String)GlobalUtil.getRecordTypeIDByLabelName('Account', recordTypeLabel);
        return 'RecordTypeID = \''+ String.valueOf(recordTypeID) + '\'';
    }

    private static String buildFilterString(){
        String filterStr = '';
        if(filterCriteria.size()>0){
            for(String filter : filterCriteria.keyset()){
                filterStr += ' and ' +filter+'=\''+String.valueOf(filterCriteria.get(filter) +  '\' ');
            }           
        }
        return filterStr;
    }
}