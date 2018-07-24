/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIStudentResource
// 
// Description: 
//  Direction Central for Student API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-17   Greg Cook       Moved functionality for handleGetV1, handlePostV1, handlePutV1, and handleDeleteV1 to StudentService
// 2016-12-24   Greg Cook       Added validatePOSTFields functions                             
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIStudentResource implements VemoAPI.ResourceHandler {
    public static Object handleAPI(VemoAPI.APIInfo api){
        if((api.version == 'v1') && (api.method == 'GET')){
            return handleGetV1(api);
        }
        if((api.version == 'v1') && (api.method == 'POST')){
            return handlePostV1(api);
        }
        if((api.version == 'v1') && (api.method == 'PUT')){
            return handlePutV1(api);
        }   
        if((api.version == 'v1') && (api.method == 'DELETE')){
            return handleDeleteV1(api);
        }           
        throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
        return null;
    }
    
    public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
        system.debug('VemoAPIStudentResource.handleGetV1()');
        String studentIDParam = api.params.get('studentID');
        String studentAuthIDParam = api.params.get('authSystemUserID');
        String studentEmailParam = api.params.get('email');
        List<StudentService.Student> students = new List<StudentService.Student>();
        if(studentIDParam != null){
            students = StudentService.getStudentsWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
        }
        else if(studentAuthIDParam != null){
            students = StudentService.getStudentsWithAuthID(VemoApi.parseParameterIntoStringSet(studentAuthIDParam));
        }       
        else if(studentEmailParam != null){
            students = StudentService.getStudentsWithEmail(VemoApi.parseParameterIntoStringSet(studentEmailParam));
        }       
        else{
            throw new VemoAPI.VemoAPIFaultException('Missing parameter: studentID, authSystemUserID, or email required for GET');
        }
        List<StudentResourceOutputV1> results = new List<StudentResourceOutputV1>();
        for(StudentService.Student stud : students){
            results.add(new StudentResourceOutputV1(stud));
        }
        return (new VemoAPI.ResultResponse(results, results.size()));
    }
    
    public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
        system.debug('VemoAPIStudentResource.handlePostV1()');
        List<StudentService.Student> newStudents = new List<StudentService.Student>();
        List<StudentResourceInputV1> studentsJSON = (List<StudentResourceInputV1>)JSON.deserialize(api.body, List<StudentResourceInputV1>.class);
system.debug('deserialized:'+studentsJSON);
        //ensure required fields

        for(StudentResourceInputV1 studRes : studentsJSON){
            studRes.validatePOSTFields();
            StudentService.Student stud = new StudentService.Student();
            stud = studentResourceV1ToStudent(studRes);
            stud.authSystemUserID = api.studentAuthID;
            stud.personAccountID = null;
//          stud.guid = null; //keep until removed completely
            newStudents.add(stud);
        }
        Set<ID> studentIDs = StudentService.createStudents(newStudents);
        return (new VemoAPI.ResultResponse(studentIDs, studentIDs.size()));
        
    }

    public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
        system.debug('VemoAPIStudentResource.handlePutV1()');
        List<StudentService.Student> students = new List<StudentService.Student>();
        List<StudentResourceInputV1> studentsJSON = (List<StudentResourceInputV1>)JSON.deserialize(api.body, List<StudentResourceInputV1>.class);
        for(StudentResourceInputV1 studRes : studentsJSON){
            studRes.validatePUTFields();
            StudentService.Student stud = new StudentService.Student();
            stud = studentResourceV1ToStudent(studRes);
            students.add(stud);
        }
        Set<ID> studentIDs = StudentService.updateStudents(students);

        return (new VemoAPI.ResultResponse(studentIDs, studentIDs.size()));
    }

    public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
        system.debug('VemoAPIStudentResource.handleDeleteV1()');            
        String studentIDParam = api.params.get('studentID');        
        Integer numToDelete = StudentService.deleteStudents(VemoApi.parseParameterIntoIDSet(studentIDParam));
        return (new VemoAPI.ResultResponse(true, numToDelete));
    }
    public static StudentService.Student studentResourceV1ToStudent(StudentResourceInputV1 studRes){
        StudentService.Student stud = new StudentService.Student();
        if(String.isNotBlank(studRes.studentID)) stud.personAccountID = studRes.studentID;
//      stud.guid = studRes.guid;
        stud.ssnTaxID = studRes.ssnTaxID;
        stud.firstName = studRes.firstName; 
        stud.middleName = studRes.middleName;
        if(String.isNotBlank(studRes.lastName)) stud.lastName = studRes.lastName;
        stud.email = studRes.email;
        stud.birthdate = studRes.birthdate;
        if(String.isNotBlank(studRes.authSystemUserID)) stud.authSystemUserID = studRes.authSystemUserID;
        stud.primarySchoolID = studRes.primarySchoolID;
        stud.primarySchoolStudentID = studRes.primarySchoolStudentID;
        stud.primarySchoolEmail = studRes.primarySchoolEmail;
        stud.driversLicenseOrStateID = studRes.driversLicenseOrStateID;
        stud.primarySchoolGraduationDate = studRes.primarySchoolGraduationDate;
        stud.primarySchoolEnrollmentStatus = studRes.primarySchoolEnrollmentStatus;
        stud.primarySchoolGradeLevel = studRes.primarySchoolGradeLevel;
        stud.residency = studRes.residency;
        stud.preferredMethodOfCommunication = studRes.preferredMethodOfCommunication;
        stud.salutation = studRes.salutation;
        stud.suffix = studRes.suffix;
        stud.doNotCall = studRes.doNotCall;
        stud.doNotEmail = studRes.doNotEmail;
        stud.homePhone = studRes.homePhone;
        stud.mailingCity = studRes.city;
        stud.mailingCountry = studRes.country;
        stud.mailingPostalCode = studRes.postalCode;
        stud.mailingState = studRes.state;
        stud.mailingStreet = studRes.street;
        stud.otherCity = studRes.otherCity;
        stud.otherCountry = studRes.otherCountry;
        stud.otherPostalCode = studRes.otherPostalCode;
        stud.otherState = studRes.otherState;
        stud.otherStreet = studRes.otherStreet;
        stud.mobilePhone = studRes.mobilePhone;
        stud.doNotText = studRes.doNotText;
        stud.timeZone = studRes.timeZone;
        stud.schoolProgramOfStudyID = studRes.schoolProgramOfStudyID;
        stud.commonLineID = studRes.commonLineID;
        stud.schoolSecurity = studRes.schoolSecurity;

        stud.autoPaymentFrequency = studRes.autoPaymentFrequency;
        stud.autoPaymentDayOfMonth1 = studRes.autoPaymentDayOfMonth1;
        stud.autoPaymentDayOfMonth2 = studRes.autoPaymentDayOfMonth2;

        return stud;
    }   
    public class StudentResourceInputV1{
        public String studentID {get;set;}
//      public String guid {get;set;}
        public String ssnTaxID {get;set;}
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
        public String suffix {get;set;}
        public Boolean doNotCall {get;set;}
        public Boolean doNotEmail {get;set;}
        public String homePhone {get;set;}
        public String city {get;set;}
        public String country {get;set;}
        public String postalCode {get;set;}
        public String state {get;set;}
        public String street {get;set;}
        public String othercity {get;set;}
        public String otherCountry {get;set;}
        public String otherPostalCode {get;set;}
        public String otherState {get;set;}
        public String otherStreet {get;set;}
        public String mobilePhone {get;set;}
        public Boolean doNotText {get;set;}
        public String timeZone {get;set;}
        public String schoolProgramOfStudyID {get;set;}
        public String commonLineID {get;set;}
        public String schoolSecurity {get;set;}
        public String autoPaymentFrequency {get;set;}
        public String autoPaymentDayOfMonth1 {get;set;}
        public String autoPaymentDayOfMonth2 {get;set;}

        public StudentResourceInputV1(Boolean testValues){
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
                this.suffix  = '123';
//              this.guid = '123';
                this.doNotCall = true;
                this.doNotEmail = true;
                this.homePhone  = '123';
                this.city  = '123';
                this.country  = 'United States';
                this.postalCode  = '123';
                this.state  = 'Colorado';
                this.street  = '123';
                this.otherCity  = '123';
                this.otherCountry  = 'United States';
                this.otherPostalCode  = '123';
                this.otherState  = 'Colorado';
                this.otherStreet  = '123';
                this.mobilePhone  = '123';
                this.doNotText = true;
                this.timeZone  = '(GMT-7) Mountain Standard Time (America/Denver)';
                this.studentID = null;
                this.commonLineID = '123';
            }
        }
        public void validatePOSTFields(){
            if(doNotCall == null) doNotCall = false;
            if(doNotEmail == null) doNotEmail = false;
            if(doNotText == null) doNotText = false;
            if(lastName == null) throw new VemoAPI.VemoAPIFaultException('lastName is a required input parameter on POST');
            if(authSystemUserID == null) throw new VemoAPI.VemoAPIFaultException('authSystemUserID is a required input parameter on POST');
            if(studentID != null) throw new VemoAPI.VemoAPIFaultException('studentID cannot be created in POST');
//          if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be created in POST');                 
        }
        public void validatePUTFields(){
//          if(authSystemUserID != null) throw new VemoAPI.VemoAPIFaultException('authSystemUserID cannot be updated in PUT');
            if(studentID == null) throw new VemoAPI.VemoAPIFaultException('studentID is a required input parameter on PUT');
//          if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be updated in PUT');          
        }
    }
    public class StudentResourceOutputV1{
        public String studentID {get;set;}
//      public String guid {get;set;}
        public String ssnTaxID {get;set;}
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
        public String suffix {get;set;}
        public Boolean doNotCall {get;set;}
        public Boolean doNotEmail {get;set;}
        public String homePhone {get;set;}
        public String city {get;set;}
        public String country {get;set;}
        public String postalCode {get;set;}
        public String state {get;set;}
        public String street {get;set;}
        public String otherCity {get;set;}
        public String otherCountry {get;set;}
        public String otherPostalCode {get;set;}
        public String otherState {get;set;}
        public String otherStreet {get;set;}
        public String mobilePhone {get;set;}
        public Boolean doNotText {get;set;}
        public String timeZone {get;set;}
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

        public String schoolSecurity {get;set;}
        
        public Decimal cumulativeIncomeShare {get;set;}
        public Decimal cumulativeIncomeShareCap {get;set;} 

        public StudentResourceOutputV1(StudentService.Student stud){
            this.studentID = stud.personAccountID;
//          this.guid = stud.guid;
            if(String.isNotEmpty(stud.ssnTaxID)) this.ssnTaxID = '***-**-'+stud.ssnTaxID.right(4);
            this.firstName = stud.firstName;
            this.middleName = stud.middleName;
            this.lastName = stud.lastName;
            this.email = stud.email;
            this.birthdate = stud.birthdate;
            this.authSystemUserID = stud.authSystemUserID;
            this.primarySchoolID = stud.primarySchoolID;
            this.primarySchoolStudentID = stud.primarySchoolStudentID;
            this.primarySchoolEmail = stud.primarySchoolEmail;
            this.driversLicenseOrStateID = stud.driversLicenseOrStateID;
            this.primarySchoolGraduationDate = stud.primarySchoolGraduationDate;
            this.primarySchoolEnrollmentStatus = stud.primarySchoolEnrollmentStatus;
            this.primarySchoolGradeLevel = stud.primarySchoolGradeLevel;
            this.residency = stud.residency;
            this.preferredMethodOfCommunication = stud.preferredMethodOfCommunication;
            this.salutation = stud.salutation;
            this.suffix = stud.suffix;
            this.doNotCall = stud.doNotCall;
            this.doNotEmail = stud.doNotEmail;
            this.homePhone = stud.homePhone;
            this.city = stud.mailingCity;
            this.country = stud.mailingCountry;
            this.postalCode = stud.mailingPostalCode;
            this.state = stud.mailingState;
            this.street = stud.mailingStreet;
            this.otherCity = stud.otherCity;
            this.otherCountry = stud.otherCountry;
            this.otherPostalCode = stud.otherPostalCode;
            this.otherState = stud.otherState;
            this.otherStreet = stud.otherStreet;
            this.mobilePhone = stud.mobilePhone;
            this.doNotText = stud.doNotText;
            this.timeZone = stud.timeZone;
            this.schoolProgramOfStudyID = stud.schoolProgramOfStudyID;
//          this.pendingResidency = stud.pendingResidency;

//          this.pendingFirstName = stud.pendingFirstName;
//          this.pendingMiddleName  = stud.pendingMiddleName;
//          this.pendingLastName = stud.pendingLastName;
//          this.pendingBirthdate = stud.pendingBirthdate;
//          this.pendingDriversLicenseOrStateID = stud.pendingDriversLicenseOrStateID;
//          this.pendingEmail = stud.pendingEmail;
//          this.recordStatus = stud.recordStatus;
//          this.pendingMailingStreet = stud.pendingMailingStreet;
//          this.pendingMailingCity = stud.pendingMailingCity;
//          this.pendingMailingState = stud.pendingMailingState;
//          this.pendingMailingStateCode = stud.pendingMailingStateCode;
//          this.pendingMailingCountry = stud.pendingMailingCountry;
//          this.pendingMailingCountryCode = stud.pendingMailingCountryCode;
//          this.pendingMailingPostalCode = stud.pendingMailingPostalCode;
            this.commonLineID = stud.commonLineID;
            this.accountNumber = stud.accountNumber;
            this.credit = stud.credit;
            this.autoPayment = stud.autoPayment;
            this.autoPaymentDateActivated = stud.autoPaymentDateActivated;
            this.autoPaymentFrequency = stud.autoPaymentFrequency;
            this.autoPaymentDayOfMonth1 = stud.autoPaymentDayOfMonth1;
            this.autoPaymentDayOfMonth2 = stud.autoPaymentDayOfMonth2;
            this.schoolSecurity = stud.schoolSecurity;
            this.cumulativeIncomeShare = stud.cumulativeIncomeShare;
            this.cumulativeIncomeShareCap = stud.cumulativeIncomeShareCap;

        }
    }
}