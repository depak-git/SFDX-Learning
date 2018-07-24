/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIProgramResource
// 
// Description: 
//  Direction Central for Program API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-17   Greg Cook       Created                          
// 2016-12-23   Greg Cook       Created resource wrapping classes, implemented refactored program service
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIProgramResource implements VemoAPI.ResourceHandler{
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
        System.debug('VemoAPIProgramResource.handleGetV1()');
        String programIDParam = api.params.get('programID');
        String schoolIDParam = api.params.get('schoolID');
        List<ProgramService.Program> programs = new List<ProgramService.Program>();
        if(programIDParam != null){
            //Set<ID> programIDs = new Set<ID>{programIDParam};
            programs = ProgramService.getProgramsWithProgramID(VemoAPI.parseParameterIntoIDSet(programIDParam));
        }
        else if(schoolIDParam != null){
            programs = ProgramService.getProgramsWithSchoolID(VemoApi.parseParameterIntoIDSet(schoolIDParam));
        }
        else{
            throw new VemoAPI.VemoAPIFaultException('Required parameter programID or schoolID');
        }
        List<ProgramResourceOutputV1> results = new List<ProgramResourceOutputV1>();
        set<ID> programIDs = new set<ID>();
        for(ProgramService.Program program : programs){
            ProgramResourceOutputV1 result = new ProgramResourceOutputV1(program);
            programIDs.add(program.programId); 
            results.add(result);
        }
        try{ // fetching the attendancePeriods for the programs
            Map<id,List<AttendancePeriodService.AttendancePeriod>> attPeriods = AttendancePeriodService.getAttendancePeriodsByProgramIDWithProgramID(programIds);
            for(ProgramResourceOutputV1 prg: results){
                List<AttendancePeriodService.AttendancePeriod> periodList = new List<AttendancePeriodService.AttendancePeriod>();
                prg.attendancePeriods = new List<VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1>();
                if(attPeriods.containsKey(prg.programId)){
                    periodList = attPeriods.get(prg.programId); 
                    for(AttendancePeriodService.AttendancePeriod period : periodList){
                        VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1 periodResource = new VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1(period);    
                        prg.attendanceperiods.add(periodResource);
                    }
                }
            } 
        } catch(Exception e){
            System.debug('Exception with attendance periods: '+e.getMessage());
        } 
        try{ // fetching CreditCriteria for programs
            Map<id,List<CreditCriteriaService.CreditCriteria>> crcriteria = CreditCriteriaService.getCreditCriteriaByProgramIDWithProgramID(programIds);
            for(ProgramResourceOutputV1 prg: results){
                List<CreditCriteriaService.CreditCriteria> criteriaList = new List<CreditCriteriaService.CreditCriteria>();
                prg.CreditCriteria = new List<VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1>();
                if(crcriteria.containsKey(prg.programId)){
                    criteriaList = crcriteria.get(prg.programId); 
                    for(CreditCriteriaService.CreditCriteria criteria : criteriaList){
                        VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1 criteriaResource = new VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1(criteria);    
                        prg.CreditCriteria.add(criteriaResource);
                    }
                }
            } 
        } catch(Exception e){
            System.debug('Exception with attendance periods: '+e.getMessage());
        }  
        
        return (new VemoAPI.ResultResponse(results, results.size()));
    }
    
    public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIProgramResource.handlePostV1');
        List<ProgramService.Program> newPrograms = new List<ProgramService.Program>();
        List<ProgramResourceInputV1> programJSON = (List<ProgramResourceInputV1>)JSON.deserialize(api.body, List<ProgramResourceInputV1>.class);
        for(ProgramResourceInputV1 prgRes : programJSON){
            prgRes.validatePOSTFields();
            ProgramService.Program prg = new ProgramService.Program();
            prg = programResourceV1toProgram(prgRes);
            newPrograms.add(prg);
        }
        Set<ID> programIDs = ProgramService.createProgramV1(newPrograms);
        return (new VemoAPI.ResultResponse(programIDs, programIDs.size()));
    }

    
    public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIProgramResource.handlePutV1');
        List<ProgramService.Program> newPrograms = new List<ProgramService.Program>();
        List<ProgramResourceInputV1> programJSON = (List<ProgramResourceInputV1>)JSON.deserialize(api.body, List<ProgramResourceInputV1>.class);
        for(ProgramResourceInputV1 prgRes : programJSON){
            prgRes.validatePUTFields();
            ProgramService.Program prg = new ProgramService.Program();
            prg = programResourceV1toProgram(prgRes);
            newPrograms.add(prg);
        }
        Set<ID> programIDs = ProgramService.updateProgramV1(newPrograms);
        return (new VemoAPI.ResultResponse(programIDs, programIDs.size()));
    }
    
    
    public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIProgramResource.handleDeleteV1');
        String programIDParam = api.params.get('programID');
        Integer numToDelete = ProgramService.deleteProgramV1(VemoApi.parseParameterIntoIDSet(programIDParam));
        return (new VemoAPI.ResultResponse(true, numToDelete));
    }


    public static ProgramService.Program programResourceV1toProgram(ProgramResourceInputV1 progRes){
        ProgramService.Program program = new ProgramService.Program();
        program.programID = progRes.programID;
        program.programName = progRes.programName;
        program.schoolID = progRes.schoolID;
        program.programStatus = progRes.programStatus;
//      program.enrollmentEndDate = progRes.enrollmentEndDate;
        return program;
    }
    
    //Embeded Classes//
    public class ProgramResourceInputV1{

        public String programID {get;set;}

//      public String ageOfMajorityCollected {get;set;}
//      public String ageOfMajorityRequired {get;set;}
//      public String agreementTemplateID {get;set;}
//      public String asdAttachmentCleanURL {get;set;}
//      public String asdAttachmentID {get;set;}
        public String automaticallyConfirmTransactions {get;set;}
//      public Decimal cumulativeIncomeShareCap {get;set;}
//      public String defaultRules {get;set;}
//      public String defermentTypeRules {get;set;}
//      public String disclosureTemplateID {get;set;}
//      public Date enrollmentBeginDate {get;set;}
//      public Date enrollmentEndDate {get;set;}
//      public String enrollmentStatusCollected {get;set;}
//      public String enrollmentStatusRequired {get;set;}
//      public String enrollmentType {get;set;}
//      public String feeRules {get;set;}
//      public Decimal gracePeriodMonths {get;set;}
//      public String gradeLevelCollected {get;set;}
//      public String gradeLevelDescription {get;set;}
//      public String gradeLevelRequired {get;set;}
//      public Decimal incomeThreshold {get;set;}
//      public String instructionText {get;set;}
        public String programName {get;set;}
        public String programStatus {get;set;}
//      public String recordLabel {get;set;}
//      public String recordLink {get;set;}
//      public Date registrationBeginDate {get;set;}
//      public Date registrationEndDate {get;set;}
//      public String residencyCollected {get;set;}
//      public String residencyRequired {get;set;}
        public String schoolID {get;set;}
//      public String schoolProgramOfStudyCollected {get;set;}
//      public String schoolProgramOfStudyRequired {get;set;}








        public ProgramResourceInputV1(Boolean testValues){
            if(testValues){
                this.programName = 'testProgramName';
                this.programStatus = 'Open'; //Planned, Closed, Cancelled
                DateTime dT = System.Now();
//              this.enrollmentEndDate = Date.newinstance(dT.year(), dT.month(), dT.day());
            }
        }

        public void validatePOSTFields(){
            if(programID != null) throw new VemoAPI.VemoAPIFaultException('programID cannot be created in POST');
//          if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be created in POST');
        }
        public void validatePUTFields(){
            if(programID == null) throw new VemoAPI.VemoAPIFaultException('programID is a required input parameter on PUT');
//          if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be updated in PUT');
        }
    }
    
    public class ProgramResourceOutputV1{
        
        public ProgramResourceOutputV1(ProgramService.Program program){
            this.programID = program.programID;     
            this.ageOfMajorityCollected = program.ageOfMajorityCollected;       
            this.ageOfMajorityRequired = program.ageOfMajorityRequired;   
            this.allowedSpecialDisbursementTypes = program.allowedSpecialDisbursementTypes;  
            this.asdAttachmentID = program.asdAttachmentID;
            this.attendanceDateRequired = program.attendanceDateRequired;
            this.creditCheckRequired = program.creditCheckRequired;
            this.CreditModel = program.CreditModel;
            this.CreditApprovalScore = program.CreditApprovalScore; 
            this.enrollmentBeginDate = program.enrollmentBeginDate;     
            this.enrollmentEndDate = program.enrollmentEndDate;     
            this.enrollmentStatusCollected = program.enrollmentStatusCollected;     
            this.enrollmentStatusRequired = program.enrollmentStatusRequired;       
            this.enrollmentType = program.enrollmentType;       
            this.gradeLevelCollected = program.gradeLevelCollected;     
            this.gradeLevelDescription = program.gradeLevelDescription;     
            this.gradeLevelRequired = program.gradeLevelRequired; 
            this.gracePeriodMonths = program.gracePeriodMonths;       
            this.immediatePayment = program.immediatePayment;
            this.instructionText = program.instructionText; 
            this.minimumIncomePerMonth = program.minimumIncomePerMonth;     
            this.quizAttemptsBeforeLock = program.quizAttemptsBeforeLock;
            this.quizLinkID = program.quizLinkID;
            this.quizLinkURL = program.quizLinkURL;
            this.quizPostID = program.quizPostID;
            this.quizResultID = program.quizResultID;
            this.programName = program.programName;   
            this.programNotes = program.ProgramNotes;  
            this.programStatus = program.programStatus;     
            this.registrationBeginDate = program.registrationBeginDate;     
            this.registrationEndDate = program.registrationEndDate;     
            this.residencyCollected = program.residencyCollected;       
            this.residencyRequired = program.residencyRequired; 
            this.rightToCancelDays = program.rightToCancelDays;     
            this.schoolID = program.schoolID;       
            this.schoolProgramOfStudyCollected = program.schoolProgramOfStudyCollected;     
            this.schoolProgramOfStudyRequired = program.schoolProgramOfStudyRequired;
            this.automaticallyConfirmTransactions = program.automaticallyConfirmTransactions;
            this.schoolCampusServiceName = program.schoolCampusServiceName;
            this.schoolCampusServiceEmail = program.schoolCampusServiceEmail;
            this.schoolCampusServiceMobile = program.schoolCampusServiceMobile;
            this.schoolCampusServiceAvailability = program.schoolCampusServiceAvailability;
            this.totalDefermentMonths = program.totalDefermentMonths;
//          this.postAgreementFlow = program.postAgreementFlow;
//          this.stepText = program.stepText;
        }










        public String programID {get;set;}

        public String ageOfMajorityCollected {get;set;}
        public String ageOfMajorityRequired {get;set;}
//      public String  agreementTemplateID {get;set;}
//      public String asdAttachmentCleanURL {get;set;}
        public String allowedSpecialDisbursementTypes {get;set;}
        public String asdAttachmentID {get;set;}
        public String attendanceDateRequired {get;set;}
        public String automaticallyConfirmTransactions {get;set;}
//      public Decimal cumulativeIncomeShareCap {get;set;}
//      public String defaultRules {get;set;}
//      public String defermentTypeRules {get;set;}
//      public String disclosureTemplateID {get;set;}
        public String creditCheckRequired {get;set;}
        public String creditModel {get;set;}
        public Decimal creditApprovalScore {get;set;}
        public Date enrollmentBeginDate {get;set;}
        public Date enrollmentEndDate {get;set;}
        public String enrollmentStatusCollected {get;set;}
        public String enrollmentStatusRequired {get;set;}
        public String enrollmentType {get;set;}
//      public String feeRules {get;set;}
//      public Decimal gracePeriodMonths {get;set;}
        public String gradeLevelCollected {get;set;}
        public String gradeLevelDescription {get;set;}
        public String gradeLevelRequired {get;set;}
        public Decimal gracePeriodMonths {get;set;}
        public String immediatePayment {get;set;}
//      public Decimal incomeThreshold {get;set;}
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
//      public String recordLabel {get;set;}
//      public String recordLink {get;set;}
        public Date registrationBeginDate {get;set;}
        public Date registrationEndDate {get;set;}
        public String residencyCollected {get;set;}
        public String residencyRequired {get;set;}
        public Integer rightToCancelDays {get;set;}
        public String schoolID {get;set;}
        public String schoolProgramOfStudyCollected {get;set;}
        public String schoolProgramOfStudyRequired {get;set;}
        public String schoolCampusServiceName {get;set;}
        public String schoolCampusServiceMobile {get;set;}
        public String schoolCampusServiceEmail {get;set;}
        public String schoolCampusServiceAvailability {get;set;}
        public Decimal totalDefermentMonths {get;set;}
        public List<VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1> AttendancePeriods{get;set;}
        public List<VemoAPICreditCriteriaResource.CreditCriteriaResourceOutputV1> creditCriteria {get;set;}
//      public String stepText {get;set;}

    }
    
}