/////////////////////////////////////////////////////////////////////////
// Class: ProgramQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION----------------------------- 
// 2016-12-23   Greg Cook       Changed all functions to return maps
/////////////////////////////////////////////////////////////////////////
public class ProgramQueries {
    public static Map<ID, Program__c> getProgramMapWithProgramID(Set<ID> programIds){
        Map<ID, Program__c> prgMap = new Map<ID, Program__c>();
        String query = generateSOQLSelect();
        query += ' WHERE ID IN ' + DatabaseUtil.inSetStringBuilder(programIds);
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        prgMap = new Map<ID, Program__c>((List<Program__c>)db.query(query));
        return prgMap;  
    }   

    public static Map<ID, Program__c> getProgramMapWithSchoolID(Set<ID> schoolIDs){
        Map<ID, Program__c> prgMap = new Map<ID, Program__c>();
        String query = generateSOQLSelect();
        query += ' WHERE School__c IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        prgMap = new Map<ID, Program__c>((List<Program__c>)db.query(query));
        return prgMap;  
    }
    public static Map<ID, Program__c> getOpenProgramMapWithSchoolID(Set<ID> schoolIDs){
        Map<ID, Program__c> prgMap = new Map<ID, Program__c>();
        String query = generateSOQLSelect();
        query += ' WHERE School__c IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);
        query += ' and EnrollmentType__c = \'Open\' ';
        query += ' and ProgramStatus__c = \'Open\' ';
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        prgMap = new Map<ID, Program__c>((List<Program__c>)db.query(query));
        return prgMap;  
    }
    public static Map<ID, Program__c> getInviteOnlyProgramMapWithSchoolID(Set<ID> schoolIDs){
        Map<ID, Program__c> prgMap = new Map<ID, Program__c>();
        String query = generateSOQLSelect();
        query += ' WHERE School__c IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);
        query += ' and EnrollmentType__c = \'Invite Only\' ';
        query += ' and ProgramStatus__c = \'Open\' ';
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        prgMap = new Map<ID, Program__c>((List<Program__c>)db.query(query));
        return prgMap;  
    }

    public static Map<ID, Program__c> getProgramMap(){
        Map<ID, Program__c> prgMap = new Map<ID, Program__c>();
        String query = generateSOQLSelect();
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' WHERE School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        prgMap = new Map<ID, Program__c>((List<Program__c>)db.query(query));
        return prgMap;  
    }

    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getFieldNames() + ' FROM Program__c';
        return soql;
    }

    private static String getFieldNames(){
        String fieldNames;
        fieldNames = 'Id, ';
        fieldNames += 'Name, ';

        fieldNames += 'School__r.CampusServiceName__c, ';
        fieldNames += 'School__r.CampusServiceEmail__c, ';
        fieldNames += 'School__r.CampusServiceMobile__c, ';
        fieldNames += 'School__r.CampusServiceAvailability__c, ';

//      fieldNames += 'GUID__c, ';
        fieldNames += 'AgeOfMajorityCollected__c, ';
        fieldNames += 'AgeOfMajorityRequired__c, ';
        fieldNames += 'AgreementTemplate__c, ';
        fieldNames += 'AllowedSpecialDisbursementTypes__c, ';
        fieldNames += 'ASDAttachmentCleanURL__c, ';
        fieldNames += 'ASDAttachmentID__c, ';
        fieldNames += 'AttendanceDateRequired__c, ';
        fieldNames += 'AutomaticallyConfirmTransactions__c, ';
        fieldNames += 'CreditCheckRequired__c, ';
        fieldNames += 'CreditModel__c, ';
        fieldNames += 'CreditApprovalScore__c, ';
        fieldNames += 'CumulativeIncomeShareCap__c, ';
        fieldNames += 'DefaultRules__c, ';
        fieldNames += 'DefermentTypeRules__c, ';
        fieldNames += 'DisbursementConfRequiredNotification__c, ';
        fieldNames += 'DisclosureTemplate__c, ';
        fieldNames += 'EnrollmentBeginDate__c, ';
        fieldNames += 'EnrollmentEndDate__c, ';
        fieldNames += 'EnrollmentStatusCollected__c, ';
        fieldNames += 'EnrollmentStatusRequired__c, ';
        fieldNames += 'EnrollmentType__c, ';
        fieldNames += 'FeeRules__c, ';
        fieldNames += 'GracePeriodMonths__c, ';
        fieldNames += 'GradeLevelCollected__c, ';
        fieldNames += 'GradeLevelDescription__c, ';
        fieldNames += 'GradeLevelRequired__c, ';
        fieldNames += 'ImmediatePayment__c, ';
        fieldNames += 'IncomeThreshold__c, ';
        fieldNames += 'InstructionText__c, ';
        fieldNames += 'MinimumIncomePerYear__c, ';
        fieldNames += 'MinimumIncomePerMonth__c, ';
//      fieldNames += 'PostAgreementFlow__c, ';
        fieldNames += 'ProgramName__c, ';
        fieldNames += 'ProgramNotes__c, ';
        fieldNames += 'ProgramStatus__c, ';
        fieldNames += 'QuizLinkURL__c, ';
        fieldNames += 'QuizLinkID__c, ';
        fieldNames += 'QuizAttemptsBeforeLock__c,';
        fieldNames += 'QuizPostID__c, ';
        fieldNames += 'QuizResultID__c, ';
        fieldNames += 'RecordLabel__c, ';
        fieldNames += 'RecordLink__c, ';
        fieldNames += 'RegistrationBeginDate__c, ';
        fieldNames += 'RegistrationEndDate__c, ';
        fieldNames += 'ResidencyCollected__c, ';
        fieldNames += 'ResidencyRequired__c, ';
        fieldNames += 'RightToCancelDays__c, ';
        fieldNames += 'School__c, ';
        fieldNames += 'SchoolEmailNotification1__c, ';
        fieldNames += 'SchoolEmailNotification2__c, ';
        fieldNames += 'SchoolProgramOfStudyCollected__c, ';
        fieldNames += 'SchoolProgramOfStudyRequired__c, ';
//      fieldNames += 'StepText__c, ';
        fieldNames += 'StudentSignedISANotification__c, ';

        fieldNames += 'TotalDefermentMonths__c, ';

        fieldNames += 'CreatedDate, ';
        fieldNames += 'CreatedByID, ';
//      fieldNames += 'OwnerID, ';
        fieldNames += 'LastModifiedById, ';
        fieldNames += 'LastModifiedDate, ';
        fieldNames += 'LastReferencedDate, ';
        fieldNames += 'LastViewedDate, ';
        fieldNames += 'SystemModstamp ';

        return fieldNames;
    }

    private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
    }
}