public with sharing class ReportClearinghouseController{
    public String selectedSchool {get;set;}
    transient public List<reportDataWrapper> reportData {get;set;}   
    transient public String csv {get;set;}
    
    private static Set<String> exclusionStatus = new Set<String>{'Draft','Invited','Application Incomplete','Application Complete','Application Under Review','Cancelled','Closed'};  
     
    public ReportClearinghouseController(){
        selectedSchool = '';
        reportData = new List<reportDataWrapper>();    
        
    }
    
    public List<SelectOption> getSchools(){
        List<Account> schools = [Select id,name From Account Where RecordType.developerName = 'SchoolCustomer' Order By name ASC];
        List<SelectOption> options = new List<SelectOption>();
        for(Account sch:schools){
            options.add(new SelectOption(sch.id,sch.name));    
        }
        return options;
    }
    
    public void runReport(){
        ///////////////////////////////////////////////////////////////////////////////////
        Map<ID,List<StudentProgram__c>> agreementsByStudent = new Map<ID,List<StudentProgram__c>>();
        
        Map<ID,List<ClrHouseStudentEnrollment__c>> clrHouseEnrollmentsByStudent = new Map<ID,List<ClrHouseStudentEnrollment__c>>(); 
        ///////////////////////////////////////////////////////////////////////////////////    
        getAgreements(agreementsByStudent);
        getClrHouseEnrollments(clrHouseEnrollmentsByStudent,agreementsByStudent.keySet());
        
        reportData = buildReportData(agreementsByStudent,clrHouseEnrollmentsByStudent);
    }
    
    ///////////////////////////////////////////////
    ///Get Student Programs for the selected School
    ///////////////////////////////////////////////
    public void getAgreements(Map<ID,List<StudentProgram__c>> agreementsByStudent){
        List<StudentProgram__c> agreementList = [SELECT id,name,student__c,student__r.name,student__r.vemoAccountNumber__c,certificationDate__c,
                                                  expectedGraduationDate__c,lastDateOfAttendance__c,Servicing__c,ServicingStartDate__c,status__c 
                                                  FROM StudentProgram__c
                                                  WHERE Status__c NOT IN :exclusionStatus AND Program__r.school__c =: selectedSchool
                                                  ORDER BY CertificationDate__c DESC];            
        
        for(StudentProgram__c agreement:agreementList){
            if(!agreementsByStudent.containsKey(agreement.student__c)){
                agreementsByStudent.put(agreement.student__c,new List<StudentProgram__c>());
            }
            agreementsByStudent.get(agreement.student__c).add(agreement);
        }
    }
    
    ////////////////////////////////////////////////////
    ///Get Clearinghouse Data for the given students school
    ////////////////////////////////////////////////////
    public void getClrHouseEnrollments(Map<ID,List<ClrHouseStudentEnrollment__c>> clrHouseEnrollmentsByStudent,Set<ID> studentIDs){
        List<ClrHouseStudentEnrollment__c> clrHouseEnrollmentList = [SELECT id,name,Enrollment_status__c,Graduated__c,Graduation_date__c,
                                                                     Enrollment_begin__c,Enrollment_end__c,College_Name__c,account__c
                                                                     FROM ClrHouseStudentEnrollment__c
                                                                     WHERE Account__c IN :studentIDs
                                                                     ORDER BY Enrollment_begin__c DESC];
        for(ClrHouseStudentEnrollment__c clrHouseEnrollment:clrHouseEnrollmentList){
            if(!clrHouseEnrollmentsByStudent.containsKey(clrHouseEnrollment.account__c)){
                clrHouseEnrollmentsByStudent.put(clrHouseEnrollment.account__c,new List<ClrHouseStudentEnrollment__c>());    
            }
            clrHouseEnrollmentsByStudent.get(clrHouseEnrollment.account__c).add(clrHouseEnrollment);
        }
    }
    
    ////////////////////////////////////////////////////////
    ///Build final report data
    ////////////////////////////////////////////////////////
    public List<ReportDataWrapper> buildReportData(Map<ID,List<StudentProgram__c>> agreementsByStudent,Map<ID,List<ClrHouseStudentEnrollment__c>> clrHouseEnrollmentsByStudent){
        List<ReportDataWrapper> output = new List<ReportDataWrapper>();
        
        for(ID studentID:clrHouseEnrollmentsByStudent.keySet()){
            Date earliestCertDate = null;
            //get the earliest cert date across all agreements
            for(StudentProgram__c agreement:agreementsByStudent.get(studentID)){
                if(agreement.certificationDate__c <> null){
                    if(earliestCertDate == null || earliestCertDate > agreement.certificationDate__c.date()) earliestCertDate = agreement.certificationDate__c.date();            
                }
            }
            
            if(earliestCertDate == null) continue;
            
            //iterate on ClrHouse enrollement records to check if the student needs to appear on the report OR not
            Boolean showOnReport = false;
            for(ClrHouseStudentEnrollment__c clrHouse:clrHouseEnrollmentsByStudent.get(studentID)){
                Date enrollmentEndDate;
                if(clrHouse.Graduated__c == 'N') enrollmentEndDate = convertTextToDate(clrHouse.Enrollment_end__c);
                if(clrHouse.Graduated__c == 'Y') enrollmentEndDate = convertTextToDate(clrHouse.Graduation_date__c);
                
                if(enrollmentEndDate == null) continue; 
                if(enrollmentEndDate < earliestCertDate) continue;
                if(clrHouse.Graduated__c == 'Y'){
                     showOnReport = true;
                     break;   
                }
                if(clrHouse.Enrollment_status__c == 'L' || clrHouse.Enrollment_status__c == 'W' ){
                     showOnReport = true;
                     break;
                }
            }
            
            //if showOnReport is true format the output 
            if(showOnReport){
                ReportDataWrapper wrapper = new ReportDataWrapper();        
                Integer sizeOfAgreements = agreementsByStudent.get(studentID).size();
                Integer sizeOfClrHouseEnrollments = clrHouseEnrollmentsByStudent.get(studentID).size();
                Integer interationCount = (sizeOfAgreements > sizeOfClrHouseEnrollments)? sizeOfAgreements:sizeOfClrHouseEnrollments; 
                List<StudentProgram__c> agreementList = agreementsByStudent.get(studentID);
                List<ClrHouseStudentEnrollment__c> clrHouseList = clrHouseEnrollmentsByStudent.get(studentID);
                
                for(integer index=0;index<interationCount;index++){
                    if(index == 0){
                        wrapper.vemoAccountNumber = agreementList[index].student__r.vemoAccountNumber__c;
                        wrapper.studentName = agreementList[index].student__r.name;
                        wrapper.studentId = agreementList[index].student__c;
                    }
                    
                    ReportRowWrapper row = new ReportRowWrapper();
                    if(index < sizeOfClrHouseEnrollments){
                        row.CHId = clrHouseList[index].id;
                        row.CHRecNumber = clrHouseList[index].name; 
                        row.collegeName = clrHouseList[index].college_Name__c;
                        row.enrollmentStatus = clrHouseList[index].enrollment_status__c;
                        row.enrollmentBegin = convertTextToDate(clrHouseList[index].Enrollment_begin__c);
                        row.enrollmentEnd = convertTextToDate(clrHouseList[index].Enrollment_end__c);
                        row.graduated = clrHouseList[index].Graduated__c;
                        row.graduationDate = convertTextToDate(clrHouseList[index].Graduation_date__c);              
                    }
                    if(index<sizeOfAgreements){
                        row.SPId = agreementList[index].id;
                        row.SPNumber = agreementList[index].name; 
                        row.status = agreementList[index].status__c;
                        row.expectedGradDate = agreementList[index].expectedGraduationDate__c;
                        row.lastDateOfAttendance = agreementList[index].lastDateOfAttendance__c;
                        row.servicing = agreementList[index].servicing__c;
                        row.servicingStartDate = agreementList[index].servicingStartDate__c;
                    }
                    wrapper.rowData.add(row);                
                }
                
                output.add(wrapper);
            }        
        } 
        return output;       
    } 
    
    ////////////////////////////////////////////////////////
    ///Convert text field to date
    ///////////////////////////////////////////////////////
    public Date convertTextToDate(String dateStr){
        Integer year,month,day;
        Date outputDate;
        try{
            year = Integer.valueOf(dateStr.subString(0,4));
            month = Integer.valueOf(dateStr.subString(4,6)); 
            day = Integer.valueOf(dateStr.subString(6,8));
            outputDate = date.newinstance(year, month, day);
        }
        catch(Exception e){
        } 
        return outputDate; 

    }
    
    ////////////////////////////////////////////////
    ///Wrapper to hold complete report data
    //////////////////////////////////////////////// 
    public class ReportDataWrapper{
        public String vemoAccountNumber {get;set;}
        public String studentName {get;set;}
        public String studentId {get;set;}
        public List<reportRowWrapper> rowData {get;set;}
        
        public reportDataWrapper(){
            this.rowData = new List<reportRowWrapper>();    
        }
    }
    
    ////////////////////////////////////////////////
    ///Wrapper to hold row level Data
    ////////////////////////////////////////////////
    public class ReportRowWrapper{
        public String CHId {get;set;}
        public String CHRecNumber {get;set;}
        public String collegeName {get;set;}
        public String enrollmentStatus {get;set;}
        public Date enrollmentBegin {get;set;}
        public Date enrollmentEnd {get;set;}
        public string graduated {get;set;}
        public Date graduationDate {get;set;}
        public String SPId {get;set;}
        public string SPNumber {get;set;}
        public String status {get;set;}
        public Date expectedGradDate {get;set;}
        public Date lastDateOfAttendance {get;set;}
        public Boolean servicing {get;set;}
        public Date servicingStartDate {get;set;}
    }
}