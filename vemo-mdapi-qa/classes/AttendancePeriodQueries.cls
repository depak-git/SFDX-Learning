/////////////////////////////////////////////////////////////////////////
// Class: AttendancePeriodQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION----------------------------- 
// 2018-03-06  Rini Gupta    Created
/////////////////////////////////////////////////////////////////////////

public class AttendancePeriodQueries {
    
    public static Map<ID, AttendancePeriod__c> getAttendancePeriodMapWithProgramID(set<ID> programIDs){
        Map<ID, AttendancePeriod__c> AttendancePeriodMap = new Map<ID, AttendancePeriod__c>();
        String query = generateSOQLSelect();
        query += ' WHERE Program__c IN ' + DatabaseUtil.inSetStringBuilder(programIDs);
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' Order By AttendanceBeginDate__c asc';
        query += ' '+ generateLIMITStatement();
        system.debug('no of queries-');
        DatabaseUtil db = new DatabaseUtil();
        AttendancePeriodMap = new Map<ID, AttendancePeriod__c>((List<AttendancePeriod__c>)db.query(query));
        return AttendancePeriodMap;
    }
    
    
    public static Map<ID, AttendancePeriod__c> getAttendancePeriodMap(){
        Map<ID, AttendancePeriod__c> AtdprdMap = new Map<ID, AttendancePeriod__c>();
        String query = generateSOQLSelect();
        if(DatabaseUtil.filterBySchoolID){
            ID schoolID = DatabaseUtil.schoolID;
            query += ' WHERE Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
        }
        query += ' '+ generateLIMITStatement();
        DatabaseUtil db = new DatabaseUtil();
        AtdprdMap = new Map<ID, AttendancePeriod__c>((List<AttendancePeriod__c>)db.query(query));
        return AtdprdMap;  
    }
    
    private static String generateSOQLSelect(){
        String soql;
        soql = 'SELECT ' + getfieldNames() + ' FROM AttendancePeriod__c';
        system.debug(soql);
        return soql;
   }
   
    private static String getfieldNames(){
        String fieldNames;
        fieldNames = 'id, ';
        fieldNames += 'Name, ';
        fieldNames += 'AttendanceBeginDate__c, ';
        fieldNames += 'AttendanceEndDate__c, ';
        
        fieldNames += 'Program__c, ';
        fieldNames += 'Program__r.ProgramName__c, ';
        fieldNames += 'Program__r.ProgramStatus__c, ';
        fieldNames += 'Program__r.School__c, ';
        fieldNames += 'Program__r.School__r.SchoolSecurity__c, ';
        fieldNames += 'Program__r.EnrollmentType__c ';
        
        return fieldNames;
   }
   
   private static String generateLIMITStatement(){
        String lim = 'LIMIT 50000';
        return lim;
   }
}