/////////////////////////////////////////////////////////////////////////
// Class: ProgramService
// 
// Description: 
//  Handles all Program DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-17   Greg Cook       Created                          
// 2016-12-18   Greg Cook       Added Input/Output classes, skeleton methods, implemented getProgramV1
// 2016-12-23   Greg Cook       Removed ProgramInput/Ouput inner classes and replaced with Program inner class, made service layer independent
// 2016-12-24   Greg Cook       getProgramsWithSchoolID
/////////////////////////////////////////////////////////////////////////
public with sharing class ProgramService {
    
    public static List<Program> getProgramsWithProgramID(Set<ID> programIDs){
        System.debug('ProgramService.getProgramsWithProgramID');
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(programIDs);
        List<Program> programs = new List<Program>();
        for(Program__c prg : programMap.values()){
            programs.add(new Program(prg));
        }
        return programs;
    }

    public static List<Program> getProgramsWithSchoolID(Set<ID> schoolIDs){
        System.debug('ProgramService.getProgramsWithProgramID');
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMapWithSchoolID(schoolIDs);
        List<Program> programs = new List<Program>();
        for(Program__c prg : programMap.values()){
            programs.add(new Program(prg));
        }
        return programs;
    }

    
    public static Set<Id> createProgramV1(List<Program> programs){
        System.debug('ProgramService.createProgramV1');
        List<Program__c> newPrograms = new List<Program__c>();
        For(Program prg : programs){
            Program__c newPrg = programToProgram(prg);
            newPrograms.add(newPrg);
        }
        insert newPrograms;
        Set<Id> prgIDs = new Set<Id>();
        for(Program__c prg : newPrograms){
            prgIDs.add(prg.ID);
        }
        return prgIDs;
    }
    
    
    public static Set<Id> updateProgramV1(List<Program> programs){
        System.debug('ProgramService.updateProgramV1');
        List<Program__c> newPrograms = new List<Program__c>();
        For(Program prg : programs){
            prg.schoolID = null;
            Program__c newPrg = programToProgram(prg);
            newPrograms.add(newPrg);
        }
        update newPrograms;
        Set<Id> prgIDs = new Set<Id>();
        for(Program__c prg : newPrograms){
            prgIDs.add(prg.ID);
        }
        return prgIDs;
    }   
    
    public static Integer deleteProgramV1(Set<ID> programIDs){
        System.debug('ProgramService.deleteProgramV1');
        Map<ID, Program__c> prgMap = ProgramQueries.getProgramMapWithProgramID(programIDs);
        Integer numToDelete = programIDs.size();
        delete prgMap.values();
        return numToDelete;
    }
    
    public static Map<ID, Boolean> evaluateProgramEligibilityForStudents(ID programID, Set<ID> studentIDs){
        System.debug('ProgramService.evaluateProgramEligibilityForStudents');
        Map<ID, Boolean> returnMap = ProgramEligibilityQueries.evaluateEligibility(programID, studentIDs);
        return returnMap;
    }

    public static Boolean evaluateProgramEligibilityWithCriteria(ID programID, String residency,
                                                 String enrollmentStatus, String gradeLevel,
                                                 ID schoolProgramOfStudyID, String state, Integer studentAge){
        System.debug('ProgramService.evaluateProgramEligibilityWithCriteria');
        Boolean returnVal = ProgramEligibilityQueries.evaluateEligibilityWithCriteria(programID,
                                                                                      residency,
                                                                                      enrollmentStatus,
                                                                                      gradeLevel,
                                                                                      schoolProgramOfStudyID,
                                                                                      state,
                                                                                      studentAge);
        return returnVal;
    }

    public static Program__c programToProgram(Program prg){
        Program__c newPrg = new Program__c();

//      if(prg.guid != null) newPrg.GUID__c = prg.guid;





        if(prg.programID != null) newPrg.ID = prg.programID;

        if(String.isNotEmpty(prg.ageOfMajorityCollected)){
            newPrg.AgeOfMajorityCollected__c = prg.ageOfMajorityCollected == 'true' ?  true : false;
        }
        if(String.isNotEmpty(prg.ageOfMajorityRequired)){
            newPrg.AgeOfMajorityRequired__c = prg.ageOfMajorityRequired == 'true' ?  true : false;
        }
        if(prg.agreementTemplateID != null) newPrg.AgreementTemplate__c = prg.agreementTemplateID;
        if(prg.asdAttachmentID != null) newPrg.ASDAttachmentID__c = prg.asdAttachmentID;
        if(String.isNotEmpty(prg.automaticallyConfirmTransactions)){
            newPrg.AutomaticallyConfirmTransactions__c = prg.automaticallyConfirmTransactions == 'true' ?  true : false;
        }
        if(prg.cumulativeIncomeShareCap != null) newPrg.CumulativeIncomeShareCap__c = prg.cumulativeIncomeShareCap;     
        if(prg.defaultRules != null) newPrg.DefaultRules__C = prg.defaultRules;
        if(prg.defermentTypeRules != null) newPrg.DefermentTypeRules__c = prg.defermentTypeRules;
        if(prg.disclosureTemplateID != null) newPrg.DisclosureTemplate__c = prg.disclosureTemplateID;       
        if(prg.enrollmentBeginDate != null) newPrg.EnrollmentBeginDate__c = prg.enrollmentBeginDate;
        if(prg.enrollmentEndDate != null) newPrg.EnrollmentEndDate__c = prg.enrollmentEndDate;
        if(String.isNotEmpty(prg.enrollmentStatusCollected)){
            newPrg.EnrollmentStatusCollected__c = prg.enrollmentStatusCollected == 'true' ?  true : false;
        }
        if(String.isNotEmpty(prg.enrollmentStatusRequired)){
            newPrg.EnrollmentStatusRequired__c = prg.enrollmentStatusRequired == 'true' ?  true : false;
        }
        if(prg.enrollmentType != null) newPrg.EnrollmentType__c = prg.enrollmentType;
        if(prg.feeRules != null) newPrg.FeeRules__c = prg.feeRules;
        if(prg.gracePeriodMonths != null) newPrg.GracePeriodMonths__c = prg.gracePeriodMonths;

        if(String.isNotEmpty(prg.gradeLevelCollected)){
            newPrg.GradeLevelCollected__c = prg.gradeLevelCollected == 'true' ?  true : false;
        }
        if(prg.gradeLevelDescription != null) newPrg.GradeLevelDescription__c = prg.gradeLevelDescription;
        if(String.isNotEmpty(prg.gradeLevelRequired)){
            newPrg.GradeLevelRequired__c = prg.gradeLevelRequired == 'true' ?  true : false;
        }
        if(prg.incomeThreshold != null) newPrg.IncomeThreshold__c = prg.incomeThreshold;
        if(prg.instructionText != null) newPrg.InstructionText__c = prg.instructionText;
        if(prg.quizLinkURL != null) newPrg.QuizLinkURL__c = prg.quizLinkURL;
        if(prg.quizLinkID != null) newPrg.QuizLinkID__c = prg.quizLinkID;
        if(prg.quizAttemptsBeforeLock != null) newPrg.QuizAttemptsBeforeLock__c = prg.quizAttemptsBeforeLock;
        if(prg.quizPostID != null) newPrg.QuizPostID__c = prg.quizPostID;
        if(prg.quizResultID != null) newPrg.QuizResultID__c = prg.quizResultID;
        if(prg.programName != null) newPrg.ProgramName__c = prg.programName;
        if(prg.programStatus != null) newPrg.ProgramStatus__c = prg.programStatus;
        if(prg.registrationBeginDate != null) newPrg.RegistrationBeginDate__c = prg.registrationBeginDate;
        if(prg.registrationEndDate != null) newPrg.RegistrationEndDate__c = prg.registrationEndDate;
        if(String.isNotEmpty(prg.residencyCollected)){
            newPrg.ResidencyCollected__c = prg.residencyCollected == 'true' ?  true : false;
        }
        if(String.isNotEmpty(prg.residencyRequired)){
            newPrg.ResidencyRequired__c = prg.residencyRequired == 'true' ?  true : false;
        }
        if(prg.schoolID != null) newPrg.School__c = prg.schoolID;
        if(String.isNotEmpty(prg.schoolProgramOfStudyCollected)){
            newPrg.SchoolProgramOfStudyCollected__c = prg.schoolProgramOfStudyCollected == 'true' ?  true : false;
        }
        if(String.isNotEmpty(prg.schoolProgramOfStudyRequired)){
            newPrg.SchoolProgramOfStudyRequired__c = prg.schoolProgramOfStudyRequired == 'true' ?  true : false;
        }
        return newPrg;
    }

    public class Program{
        public String programID {get;set;}
//      public String guid {get;set;}

        public String ageOfMajorityCollected {get;set;}
        public String ageOfMajorityRequired {get;set;}
        public String agreementTemplateID {get;set;}
        public String allowedSpecialDisbursementTypes {get;set;}
        public String asdAttachmentCleanURL {get;set;}
        public String asdAttachmentID {get;set;}
        public String attendanceDateRequired {get;set;}
        public String automaticallyConfirmTransactions {get;set;}
        public String creditCheckRequired {get;set;}
        public String creditModel {get;set;}
        public Decimal creditApprovalScore {get;set;}
        public Decimal cumulativeIncomeShareCap {get;set;}
        public String defaultRules {get;set;}
        public String defermentTypeRules {get;set;}
        public String disclosureTemplateID {get;set;}
        public Date enrollmentBeginDate {get;set;}
        public Date enrollmentEndDate {get;set;}
        public String enrollmentStatusCollected {get;set;}
        public String enrollmentStatusRequired {get;set;}
        public String enrollmentType {get;set;}
        public String feeRules {get;set;}
        public Decimal gracePeriodMonths {get;set;}
        public String gradeLevelCollected {get;set;}
        public String gradeLevelDescription {get;set;}
        public String gradeLevelRequired {get;set;}
        public String immediatePayment {get;set;}
        public Decimal incomeThreshold {get;set;}
        public String instructionText {get;set;}
//      public String postAgreementFlow {get;set;}
        public Decimal minimumIncomePerMonth {get;set;}
        public String quizLinkURL {get;set;}
        public String quizLinkID {get;set;}
        public Integer quizAttemptsBeforeLock {get;set;}
        public String quizPostID {get;set;}
        public String quizResultID {get;set;}
        public String programName {get;set;}
        public String programNotes {get;set;}
        public String programStatus {get;set;}
        public String recordLabel {get;set;}
        public String recordLink {get;set;}
        public Date registrationBeginDate {get;set;}
        public Date registrationEndDate {get;set;}
        public String residencyCollected {get;set;}
        public String residencyRequired {get;set;}
        public Integer rightToCancelDays {get;set;}
        public String schoolID {get;set;}
        public String schoolProgramOfStudyCollected {get;set;}
        public String schoolProgramOfStudyRequired {get;set;}
//      public String stepText {get;set;}
        
        public String schoolCampusServiceName {get;set;}
        public String schoolCampusServiceEmail {get;set;}
        public String schoolCampusServiceMobile {get;set;}
        public String schoolCampusServiceAvailability {get;set;}
        public Decimal totalDefermentMonths {get;set;}

        public Program(){

        }

        public Program(Boolean testValues){
            if(testValues){
                this.programName = 'testProgramName';
                this.programStatus = 'Open'; //Planned, Closed, Cancelled
                DateTime dT = System.Now();
                this.enrollmentEndDate = Date.newinstance(dT.year(), dT.month(), dT.day());
            }
        }

        public Program(Program__c prog){
//          this.guid = prog.GUID__c;

            this.programID = prog.Id;   
            this.ageOfMajorityCollected = String.valueOf(prog.AgeOfMajorityCollected__c);
            this.ageOfMajorityRequired = String.valueOf(prog.AgeOfMajorityRequired__c);
            this.agreementTemplateID = prog.AgreementTemplate__c;
            this.allowedSpecialDisbursementTypes = prog.AllowedSpecialDisbursementTypes__c;
            this.asdAttachmentCleanURL = prog.ASDAttachmentCleanURL__c;
            this.asdAttachmentID = prog.ASDAttachmentID__c;
            this.attendanceDateRequired = String.valueOf(prog.AttendanceDateRequired__c);
            this.automaticallyConfirmTransactions = String.valueOf(prog.AutomaticallyConfirmTransactions__c);
            this.creditCheckRequired = String.valueOf(prog.CreditCheckRequired__c);
            this.creditModel = prog.creditModel__c;
            this.creditApprovalScore = prog.creditApprovalScore__c;
            this.cumulativeIncomeShareCap = prog.CumulativeIncomeShareCap__c;
            this.defaultRules = prog.DefaultRules__c;
            this.defermentTypeRules = prog.DefermentTypeRules__c;
            this.disclosureTemplateID = prog.DisclosureTemplate__c;
            this.enrollmentBeginDate = prog.EnrollmentBeginDate__c;
            this.enrollmentEndDate = prog.EnrollmentEndDate__c;
            this.enrollmentStatusCollected = String.valueOf(prog.EnrollmentStatusCollected__c);
            this.enrollmentStatusRequired = String.valueOf(prog.EnrollmentStatusRequired__c);
            this.enrollmentType = prog.EnrollmentType__c;
            this.feeRules = prog.FeeRules__c;
            this.gracePeriodMonths = prog.GracePeriodMonths__c;
            this.gradeLevelCollected = String.valueOf(prog.GradeLevelCollected__c);
            this.gradeLevelDescription = prog.GradeLevelDescription__c;
            this.gradeLevelRequired = String.valueOf(prog.GradeLevelRequired__c);
            this.immediatePayment = String.valueOf(prog.ImmediatePayment__c);
            this.incomeThreshold = prog.IncomeThreshold__c;
            this.instructionText = prog.InstructionText__c;
            this.minimumIncomePerMonth = prog.minimumIncomePerMonth__c; 
            this.quizAttemptsBeforeLock = (Integer) prog.QuizAttemptsBeforeLock__c;
            this.quizLinkID = prog.QuizLinkID__c;
            this.quizLinkURL = prog.QuizLinkURL__c;
            this.quizPostID = prog.QuizPostID__c;
            this.quizResultID = prog.QuizResultID__c;
            this.programName = prog.ProgramName__c; 
            this.programNotes = prog.ProgramNotes__c;    
            this.programStatus = prog.ProgramStatus__c;
//          this.postAgreementFlow = prog.PostAgreementFlow__c;
            this.recordLabel = prog.RecordLabel__c;
            this.recordLink = prog.RecordLink__c;
            this.registrationBeginDate = prog.RegistrationBeginDate__c;
            this.registrationEndDate = prog.RegistrationEndDate__c;
            this.residencyCollected = String.valueOf(prog.ResidencyCollected__c);
            this.residencyRequired = String.valueOf(prog.ResidencyRequired__c);
            this.rightToCancelDays = (Integer) prog.RightToCancelDays__c;
            this.schoolID = prog.School__c;
            this.schoolProgramOfStudyCollected = String.valueOf(prog.SchoolProgramOfStudyCollected__c);
            this.schoolProgramOfStudyRequired = String.valueOf(prog.SchoolProgramOfStudyRequired__c);
            
//          this.stepText = prog.StepText__c;
            
            this.schoolCampusServiceName = prog.School__r.CampusServiceName__c;
            this.schoolCampusServiceEmail = prog.School__r.CampusServiceEmail__c;
            this.schoolCampusServiceMobile = prog.School__r.CampusServiceMobile__c;
            this.schoolCampusServiceAvailability = prog.School__r.CampusServiceAvailability__c;
            this.totalDefermentMonths = prog.totalDefermentMonths__c;  
            
            
        
        }
    }
}