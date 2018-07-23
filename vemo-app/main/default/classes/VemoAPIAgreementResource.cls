/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIAgreementResource
// 
// Description: 
//   Direction Central for Agreement Resource API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
// 2016-12-26  Greg Cook     Put and Delete  
/////////////////////////////////////////////////////////////////////////
public class VemoAPIAgreementResource {
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
    System.debug('VemoAPIAgreementResource.handleGetV1');
    String agreementIDParam = api.params.get('agreementID');
    String studentIDParam = api.params.get('studentID');
    String schoolIDParam = api.params.get('schoolID');
    String programIDParam = api.params.get('programID');
    String searchParam = api.params.get('search');
    List<AgreementService.Agreement> agreements = new List<AgreementService.Agreement>();
    if(agreementIDParam != null){
      agreements = AgreementService.getAgreementWithAgreementID(VemoApi.parseParameterIntoIDSet(agreementIDParam));
    }
    else if(studentIDParam != null){
      agreements = AgreementService.getAgreementWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
    }
    else if(schoolIDParam != null){
      agreements = AgreementService.getAgreementWithSchoolID(VemoApi.parseParameterIntoIDSet(schoolIDParam));
    } else if(programIDparam != null){
      agreements = AgreementService.getAgreementWithProgramID(VemoApi.parseParameterIntoIDSet(programIDParam));
    } else if(searchParam != null){
      agreements = AgreementService.getAgreementWithSearch(searchParam);
    }
    else{
      throw new VemoAPI.VemoAPIFaultException('Required parameter agreementID, or studentID, or schoolID, or programID, or search');
    }

    //Get the related structures
    Set<ID> programIDs = new Set<ID>();
    Set<ID> studentIDs = new Set<ID>();
    for(AgreementService.Agreement agreement : agreements){
        studentIDs.add(agreement.studentID);
        programIDs.add(agreement.programID);
    }

    //Students
    Map<ID, VemoAPIStudentResource.StudentResourceOutputV1> studentDetailMap = new Map<ID, VemoAPIStudentResource.StudentResourceOutputV1>();
    List<StudentService.Student> students = StudentService.getStudentsWithStudentID(studentIDs);
    for(StudentService.Student student : students){
        studentDetailMap.put(student.personAccountID, new VemoAPIStudentResource.StudentResourceOutputV1(student));
    }

    //Programs
    Map<ID, VemoAPIProgramResource.ProgramResourceOutputV1> programDetailMap = new Map<ID, VemoAPIProgramResource.ProgramResourceOutputV1>();
    List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(programIDs);
    for(ProgramService.Program program : programs){
        programDetailMap.put(program.programID, new VemoAPIProgramResource.ProgramResourceOutputV1(program));
    }



    List<AgreementResourceOutputV1> results = new List<AgreementResourceOutputV1>();
    for(AgreementService.Agreement agreement: agreements){
        AgreementResourceOutputV1 result = new AgreementResourceOutputV1(agreement);
        result.student = studentDetailMap.get(agreement.studentID);
        result.program = programDetailMap.get(agreement.programID);


        if(agreements.size() == 1){
            //Get the disburesemenents if we are only fetching one agreement   
            try{
                result.disbursements = new List<VemoAPIDisbursementResource.DisbursementResourceOutputV1>();
                List<TransactionService.Disbursement> dists = TransactionService.getDisbursementWithAgreementID(new Set<ID>{agreement.agreementID});
                for(TransactionService.Disbursement dist : dists){
                    result.disbursements.add(new VemoAPIDisbursementResource.DisbursementResourceOutputV1(dist));
                }
            } catch (Exception e){
                System.debug('Exception with disbursements: '+e.getMessage());
            }


            //Get the contract tersm if we are only fetching one student
            try{
                Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(new Set<ID>{agreement.studentID});
                Map<ID, List<ContractTermsService.ContractTerm>> termMapByStudentID = ContractTermsService.getContractTermsByStudentIDWithStudentMap((ID)agreement.programID, studentMap);

                if(termMapByStudentID.size()>0 && termMapByStudentID.containsKey(agreement.studentID)){
                    for(ContractTermsService.ContractTerm term : termMapByStudentID.get(agreement.studentID)){
                        result.contractTerms = new VemoAPIContractTermsResource.ContractTermResourceOutputV1(term);
                    }           
                }   
            } catch (Exception e){
                System.debug('Exception with contract terms: '+e.getMessage());
            }
            
            //Get Attendance Periods for the agreement's Program 
            try{
                result.program.AttendancePeriods = new List<VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1>();
                List<AttendancePeriodService.AttendancePeriod> periodList = AttendancePeriodService.getAttendancePeriodsWithProgramID(new Set<ID>{agreement.programID});
                for(AttendancePeriodService.AttendancePeriod period: periodList){
                   result.program.attendancePeriods.add(new VemoAPIAttendancePeriodResource.AttendancePeriodResourceOutputV1(period));
                }
            } catch (Exception e){
               System.debug('Exception with attendance periods: '+e.getMessage());
            }
        }
        results.add(result);
    }
    return (new VemoAPI.ResultResponse(results, results.size()));
  }
  
  
  public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){  
    System.debug('VemoAPIAgreementResource.handlePostV1');
    List<AgreementService.Agreement> newAgreements = new List<AgreementService.Agreement>();
    List<AgreementService.Agreement> newAgreementsPut = new List<AgreementService.Agreement>();
    List<AgreementResourceInputV1> agreementsJSON = (List<AgreementResourceInputV1>)JSON.deserialize(api.body, List<AgreementResourceInputV1>.class);
    system.debug('agreementsJSON:'+agreementsJSON);
    List<AgreementResourceInputV1> agreementJSONPut = new List<AgreementResourceInputV1>();
    for(AgreementResourceInputV1 agreRes : agreementsJSON){
      system.debug('agreRes:'+agreRes);
      if(!((agreRes.agreementID == null) || (agreRes.agreementID == 'null'))){
        agreRes.validatePUTFields();
        agreRes.studentID = null;
        agreRes.programID = null;
        AgreementService.Agreement agre = agreementResourceV1toAgreement(agreRes);
        newAgreementsPut.add(agre);
      }
      else{
        agreRes.validatePOSTFields();
        AgreementService.Agreement agreement = new AgreementService.Agreement();
        agreement = agreementResourceV1toAgreement(agreRes);
//        agreement.guid = null;
        agreement.agreementID = null;
        newAgreements.add(agreement);
      }
    }
    Set<ID> agreementIDs = new Set<ID>();
    if(!newAgreements.isEmpty()){
      agreementIDs.addAll(AgreementService.createAgreement(newAgreements));
    }
    if(!newAgreementsPut.isEmpty()){
      agreementIDs.addAll(AgreementService.updateAgreement(newAgreementsPut));
    }
    return (new VemoAPI.ResultResponse(agreementIDs, agreementIDs.size()));
  }


  public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
    System.debug('VemoAPIAgreementResource.handlePutV1');
    List<AgreementService.Agreement> agreements = new List<AgreementService.Agreement>();
    List<AgreementResourceInputV1> agreementsJSON = (List<AgreementResourceInputV1>)JSON.deserialize(api.body, List<AgreementResourceInputV1>.class);
    for(AgreementResourceInputV1 agrRes : agreementsJSON){

      agrRes.validatePUTFields();

      AgreementService.Agreement agre = agreementResourceV1toAgreement(agrRes);
      agreements.add(agre);
    }
    Set<ID> ageementIDs = AgreementService.updateAgreement(agreements);
    return (new VemoAPI.ResultResponse(ageementIDs, ageementIDs.size()));
  }

  public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
    System.debug('VemoAPIAgreementResource.handleDeleteV1');
    String agreementIDParam = api.params.get('agreementID');
    Integer numToDelete = AgreementService.deleteAgreement(VemoApi.parseParameterIntoIDSet(agreementIDParam));
    return (new VemoAPI.ResultResponse(true, numToDelete));
  }



  public static AgreementService.Agreement agreementResourceV1toAgreement(AgreementResourceInputV1 agreRes){
    AgreementService.Agreement agreement = new AgreementService.Agreement();

///////

    agreement.agreementID = agreRes.agreementID;
    agreement.studentID = agreRes.studentID;
//    public String studentName {get; set;}
    agreement.programID = agreRes.programID;
//    public String programName {get;set;}
    agreement.schoolID = agreRes.schoolID;
    agreement.schoolProgramOfStudyID = agreRes.schoolProgramOfStudyID;
    agreement.agreementStatus = agreRes.agreementStatus;
//    public String adobeSignStatus {get;set;}
//    public String adobeSignJavascript {get;set;}
    //public String adobeSignURL {get;set;}
//    public String adobeSignWidgetID {get;set;}
//    public String adobeSignAgreementID {get;set;}
    agreement.agreementSigned = agreRes.agreementSigned;
//    public Decimal allocatedAmount {get;set;}
    agreement.applicationStartDateTime = agreRes.applicationStartDateTime;
    agreement.approvalDisclosureDateTime = agreRes.approvalDisclosureDateTime;
    agreement.attendanceBeginDate = agreRes.attendanceBeginDate;
    agreement.attendanceEndDate = agreRes.attendanceEndDate;  
    agreement.birthdate = agreRes.birthdate;
    agreement.birthdateCertification = agreRes.birthdateCertification;
    agreement.birthdatePreCertification = agreRes.birthdatePreCertification;
    agreement.birthdatePostCertification = agreRes.birthdatePostCertification;
    agreement.birthdateStudent = agreRes.birthdateStudent;
    agreement.bypassAutomation = agreRes.bypassAutomation;
    agreement.cancellationReason = agreRes.cancellationReason;
    agreement.certificationComments = agreRes.certificationComments;
    agreement.certificationDateTime = agreRes.certificationDateTime;
    agreement.certificationDraftStatus = agreRes.certificationDraftStatus;
//    public String congaFinalDisclosureStatus {get;set;}
//    public String congaUnsignedAgreementID {get;set;}
//    public String congaUnsignedAgreementStatus {get;set;}
//    public String finalDisclosureID {get;set;}// should this change to congafinaldisclosureid__c
//    public String finalDisclosureURL {get;set;}
    agreement.creditCheckID = agreRes.creditCheckID;
    agreement.creditCheckProcess = agreRes.creditCheckProcess;
    agreement.currentStatusDateTime = agreRes.currentStatusDateTime;
    agreement.customerWithdrawnReason = agreRes.customerWithdrawnReason;
    agreement.customerWithdrawnReasonOther = agreRes.customerWithdrawnReasonOther;
//    public String defermentID {get;set;}
    agreement.defermentMonthsAllowed = agreRes.defermentMonthsAllowed ;
    agreement.defermentMonthsRemaining = agreRes.defermentMonthsRemaining ;
//    public String eligibleToReapply {get;set;}
    agreement.enrollmentStatusCertification = agreRes.enrollmentStatusCertification;
    agreement.enrollmentStatusPreCertification = agreRes.enrollmentStatusPreCertification;
    agreement.enrollmentStatusPostCertification = agreRes.enrollmentStatusPostCertification;
    agreement.enrollmentStatusStudent = agreRes.enrollmentStatusStudent;
//    public Date estimatedAgreementEndDate {get;set;}
//    public Decimal estimatedReconciliationAmount {get;set;}
    agreement.expectedGraduationDate = agreRes.expectedGraduationDate;

    agreement.fundingAmountCertification = agreRes.fundingAmountCertification;
    agreement.fundingAmountPostCertification = agreRes.fundingAmountPostCertification;
    agreement.fundingAmountStudent = agreRes.fundingAmountStudent;
    agreement.fundingMaximumPreCertification = agreRes.fundingMaximumPreCertification;
    agreement.fundingMinimumPreCertification = agreRes.fundingMinimumPreCertification;
    agreement.fundingPurpose = agreRes.fundingPurpose;
    agreement.generateAgreement = agreRes.generateAgreement;
    agreement.generateEsign = agreRes.generateEsign;
    agreement.generateEsignURL = agreRes.generateEsignURL;
    agreement.generateFinalDisclosure = agreRes.generateFinalDisclosure;
    agreement.generateDisclosures = agreRes.generateDisclosures;
    agreement.generateDisbursementSchedule = agreRes.generateDisbursementSchedule;
    agreement.graceMonthsAllowed = agreRes.graceMonthsAllowed; 
//    public Decimal graceMonthsRemaining {get;set;}
//    public Date gracePeriodEndDate {get;set;}
    agreement.gradeLevel = agreRes.gradeLevel;
    agreement.gradeLevelCertification = agreRes.gradeLevelCertification;
    agreement.gradeLevelPreCertification = agreRes.gradeLevelPreCertification;
    agreement.gradeLevelPostCertification = agreRes.gradeLevelPostCertification;
    agreement.gradeLevelStudent = agreRes.gradeLevelStudent;
    agreement.lastDateOfAttendance = agreRes.lastDateOfAttendance;
    agreement.incomeShare = agreRes.incomeShare;
    agreement.incomeShareCertification = agreRes.incomeShareCertification;
    agreement.incomeSharePostCertification = agreRes.incomeSharePostCertification;
    agreement.incomeShareStudent = agreRes.incomeShareStudent;
    agreement.majorIDCertification = agreRes.majorIDCertification;
    agreement.majorIDPreCertification = agreRes.majorIDPreCertification;
    agreement.majorIDPostCertification = agreRes.majorIDPostCertification;
    agreement.majorIDStudent = agreRes.majorIDStudent;
    agreement.minimumIncomePerMonth = agreRes.minimumIncomePerMonth; 
    //agreement.minimumIncomePerYear = agreRes.minimumIncomePerYear ;
//    public Decimal nextPaymentDue {get;set;}
//    public Date nextPaymentDueDate {get;set;}
//    public Decimal paidToDate {get;set;}
    agreement.paveTheWay = agreRes.paveTheWay;
    agreement.paymentCap = agreRes.paymentCap;
    agreement.paymentCapCertification = agreRes.paymentCapCertification;
    agreement.paymentCapPostCertification = agreRes.paymentCapPostCertification;
    agreement.paymentCapStudent = agreRes.paymentCapStudent;
    agreement.paymentTerm = agreRes.paymentTerm;
    agreement.paymentTermCertification = agreRes.paymentTermCertification;
    agreement.paymentTermPostCertification = agreRes.paymentTermPostCertification;
    agreement.paymentTermStudent = agreRes.paymentTermStudent;
    //if(String.isNotEmpty(agreRes.preCertified)){
            agreement.PreCertified = agreRes.precertified; 
    //} 

    agreement.quizLocked = agreRes.quizLocked;
    agreement.quizAttemptsData = agreRes.quizAttempts;
    agreement.quizResponseLink = agreRes.quizResponseLink;
    agreement.quizState = agreRes.quizState;

    agreement.registrationExceptionProcess = agreRes.registrationExceptionProcess;
    agreement.remainingTerm = agreRes.remainingTerm;
    agreement.requestedAmount = agreRes.requestedAmount;
    agreement.resetAgreement = agreRes.resetAgreement;
    agreement.resetFinalDisclosure = agreRes.resetFinalDisclosure;
    agreement.residency = agreRes.residency;
    agreement.residencyCertification = agreRes.residencyCertification;
    agreement.residencyPreCertification = agreRes.residencyPreCertification;
    agreement.residencyPostCertification = agreRes.residencyPostCertification;
    agreement.residencyStudent = agreRes.residencyStudent;
//    public Date rightToCancelDate {get;set;}
//    public String servicing {get;set;}
//    public Date servicingStartDate {get;set;}
//    public String signingURL {get;set;}    
//    public String signedAgreementID {get;set;}
//    public String signedAgreementURL {get;set;}
    agreement.stateOfResidenceCertification = agreRes.stateOfResidenceCertification;
    agreement.stateOfResidencePreCertification = agreRes.stateOfResidencePreCertification;
    agreement.stateOfResidencePostCertification = agreRes.stateOfResidencePostCertification;
    agreement.stateOfResidenceStudent = agreRes.stateOfResidenceStudent;
    agreement.submittedDateTime = agreRes.submittedDateTime;
    agreement.studentEmail = agreRes.studentEmail;
//    public String vemoContractNumber {get;set;}


    return agreement;
  }


  public class AgreementResourceInputV1{

//
    public String agreementID {get;set;}
    public String studentID {get;set;}
//    public String studentName {get; set;}
    public String programID {get;set;}
//    public String programName {get;set;}
    public String schoolID {get;set;}
    public String schoolProgramOfStudyID {get;set;}
    public String agreementStatus {get;set;}
//    public String adobeSignStatus {get;set;}
//    public String adobeSignJavascript {get;set;}
    //public String adobeSignURL {get;set;}
//    public String adobeSignWidgetID {get;set;}
//    public String adobeSignAgreementID {get;set;}
    public String agreementSigned {get;set;}
    public Decimal allocatedAmount {get;set;}
    public DateTime applicationStartDateTime {get;set;}
    public DateTime approvalDisclosureDateTime {get;set;}
    public Date attendanceBeginDate {get;set;}
    public Date attendanceEndDate {get;set;}
    public Date birthdate {get;set;}
    public Date birthdateCertification {get;set;}
    public Date birthdatePreCertification {get;set;}
    public Date birthdatePostCertification {get;set;}
    public Date birthdateStudent {get;set;}
    public String bypassAutomation {get;set;}
    public String cancellationReason {get;set;}
    public String certificationComments {get;set;}
    public DateTime certificationDateTime {get;set;}
    public String certificationDraftStatus {get;set;}
//    public String congaFinalDisclosureStatus {get;set;}
//    public String congaUnsignedAgreementID {get;set;}
//    public String congaUnsignedAgreementStatus {get;set;}
//    public String finalDisclosureID {get;set;}// should this change to congafinaldisclosureid__c
//    public String finalDisclosureURL {get;set;}
    public String creditCheckID {get;set;}
    public String creditCheckProcess {get;set;}
    public DateTime currentStatusDateTime {get;set;}
    public String customerWithdrawnReason {get;set;}
    public String customerWithdrawnReasonOther {get;set;}
//    public String defermentID {get;set;}
    public Decimal defermentMonthsAllowed {get;set;}
    public Decimal defermentMonthsRemaining {get;set;}
//    public String eligibleToReapply {get;set;}
    public String enrollmentStatusCertification {get;set;}
    public String enrollmentStatusPreCertification {get;set;}
    public String enrollmentStatusPostCertification {get;set;}
    public String enrollmentStatusStudent {get;set;}
//    public Date estimatedAgreementEndDate {get;set;}
//    public Decimal estimatedReconciliationAmount {get;set;}
    public Date expectedGraduationDate {get;set;}

    public Decimal fundingAmountCertification {get;set;}
    public Decimal fundingAmountPostCertification {get;set;}
    public Decimal fundingAmountStudent {get;set;}
    public Decimal fundingMaximumPreCertification {get;set;}
    public Decimal fundingMinimumPreCertification {get;set;}
    public String fundingPurpose {get;set;}
    public String generateAgreement {get;set;}
    public String generateEsign {get;set;}
    public String generateEsignURL {get;set;}
    public String generateFinalDisclosure {get;set;}
    public String generateDisclosures {get;set;}
    public String generateDisbursementSchedule {get;set;}
   public Decimal graceMonthsAllowed {get;set;}
//    public Decimal graceMonthsRemaining {get;set;}
//    public Date gracePeriodEndDate {get;set;}
    public String gradeLevel {get;set;}
    public String gradeLevelCertification {get;set;}
    public String gradeLevelPreCertification {get;set;}
    public String gradeLevelPostCertification {get;set;}
    public String gradeLevelStudent {get;set;}    
    public Decimal incomeShare {get;set;}//probably goes away
    public Decimal incomeShareCertification {get;set;}
    public Decimal incomeSharePostCertification {get;set;}
    public Decimal incomeShareStudent {get;set;}
    public Date lastDateOfAttendance {get;set;}
    public String majorIDCertification {get;set;}
    public String majorIDPreCertification {get;set;}
    public String majorIDPostCertification {get;set;}
    public String majorIDStudent {get;set;}
    public Decimal minimumIncomePerMonth {get;set;}
   // public Decimal minimumIncomePerYear {get;set;}
//    public Decimal nextPaymentDue {get;set;}
//    public Date nextPaymentDueDate {get;set;}
//    public Decimal paidToDate {get;set;}
    public String paveTheWay {get;set;}
    public Decimal paymentCap {get;set;}//probably goes away
    public Decimal paymentCapCertification {get;set;}
    public Decimal paymentCapPostCertification {get;set;}
    public Decimal paymentCapStudent {get;set;}
    public Decimal paymentTerm {get;set;}//probably goes away
    public Decimal paymentTermCertification {get;set;}
    public Decimal paymentTermPostCertification {get;set;}
    public Decimal paymentTermStudent {get;set;}
    public String preCertified {get;set;}
    public String quizLocked {get;set;}
    public String quizAttempts {get;set;}
    public String quizState {get;set;}
    public String quizResponseLink {get;set;}
    public String registrationExceptionProcess {get;set;}
    public Integer remainingTerm {get;set;}
    public Decimal requestedAmount {get;set;}//probably goes away
    public String resetAgreement {get;set;}
    public String resetFinalDisclosure {get;set;}
    public String residency {get;set;}//probably goes away
    public String residencyCertification {get;set;}
    public String residencyPreCertification {get;set;}
    public String residencyPostCertification {get;set;}
    public String residencyStudent {get;set;}
//    public Date rightToCancelDate {get;set;}
//    public String servicing {get;set;}
//    public Date servicingStartDate {get;set;}
//    public String signingURL {get;set;}    
//    public String signedAgreementID {get;set;}
//    public String signedAgreementURL {get;set;}
    public String stateOfResidenceCertification {get;set;}
    public String stateOfResidencePreCertification {get;set;}
    public String stateOfResidencePostCertification {get;set;}
    public String stateOfResidenceStudent {get;set;}
    public DateTime submittedDateTime {get;set;}
    public String studentEmail {get;set;}
//    public String vemoContractNumber {get;set;}




    public AgreementResourceInputV1(){}

    public AgreementResourceInputV1(Boolean testValues){
      if(testValues){
        this.agreementStatus = 'Enrolling'; //Enrolling, Enrolled, Completed, Cancelled
      }
    }
  
    public void validatePOSTFields(){
      if(agreementStatus == null) agreementStatus = 'Default Value from APIHandler';
      if(studentID == null) throw new VemoAPI.VemoAPIFaultException('studentID is a required input parameter on POST');
      if(programID == null) throw new VemoAPI.VemoAPIFaultException('programID is a required input parameter on POST');
      if(schoolID != null) throw new VemoAPI.VemoAPIFaultException('schoolID cannot be created in POST');
      if(!((agreementID == null) || (agreementID == 'null'))) throw new VemoAPI.VemoAPIFaultException('agreementID cannot be created in POST');          
//      if(guid != null) throw new VemoAPI.VemoAPIFaultException('guid cannot be created in POST');  
    }
    public void validatePUTFields(){
      if(agreementID == null && (studentID == null || programID == null)) throw new VemoAPI.VemoAPIFaultException('studentID and programID must not be null or agreementID must be provided in POST');
    }
  }
  public class AgreementResourceOutputV1{    
    public AgreementResourceOutputV1(AgreementService.Agreement agreement){

//


      this.agreementID = agreement.agreementID;
      this.studentID = agreement.studentID;
      this.studentName = agreement.studentName;
      this.programID = agreement.programID;
      this.programName = agreement.programName;
      this.schoolID = agreement.schoolID;
      this.schoolProgramOfStudyID = agreement.schoolProgramOfStudyID;
      this.agreementStatus = agreement.agreementStatus;
      this.adobeSignStatus = agreement.adobeSignStatus;
      this.adobeSignJavascript = agreement.adobeSignJavascript;
      this.signingURL = agreement.adobeSignURL;
      this.adobeSignWidgetID = agreement.adobeSignWidgetID;
      this.adobeSignAgreementID = agreement.adobeSignAgreementID;
      this.agreementSigned = agreement.agreementSigned;
      this.allocatedAmount = agreement.allocatedAmount;
      this.applicationStartDateTime = agreement.applicationStartDateTime;
      this.approvalDisclosureDateTime = agreement.approvalDisclosureDateTime;
      this.attendanceBeginDate = agreement.attendanceBeginDate;
      this.attendanceEndDate = agreement.attendanceEndDate; 
      this.birthdate = agreement.birthdate;
      this.birthdateCertification = agreement.birthdateCertification;
      this.birthdatePreCertification = agreement.birthdatePreCertification;
      this.birthdatePostCertification = agreement.birthdatePostCertification;
      this.birthdateStudent = agreement.birthdateStudent;
      this.bypassAutomation = agreement.bypassAutomation;
      this.cancellationReason = agreement.cancellationReason;
      this.certificationComments = agreement.certificationComments;
      this.certificationDateTime = agreement.certificationDateTime;
      this.certificationDraftStatus = agreement.certificationDraftStatus;
      this.congaFinalDisclosureStatus = agreement.congaFinalDisclosureStatus;
      this.congaUnsignedAgreementID = agreement.congaUnsignedAgreementID;
      this.congaUnsignedAgreementStatus = agreement.congaUnsignedAgreementStatus;
      this.finalDisclosureID = agreement.finalDisclosureID;
      this.finalDisclosureURL = agreement.finalDisclosureURL;
      this.creditCheckID = agreement.creditCheckID;
      this.creditCheckProcess = agreement.creditCheckProcess;
      this.currentStatusDateTime = agreement.currentStatusDateTime;
      this.customerWithdrawnReason = agreement.customerWithdrawnReason;
      this.customerWithdrawnReasonOther = agreement.customerWithdrawnReasonOther;
      this.defermentID = agreement.defermentID;
      this.defermentMonthsAllowed = agreement.defermentMonthsAllowed;
      this.defermentMonthsRemaining = agreement.defermentMonthsRemaining;
      this.defermentBeginDate = agreement.defermentBeginDate;
      this.defermentEndDate = agreement.defermentEndDate;

      this.eligibleToReapply = agreement.eligibleToReapply;
      this.enrollmentStatusCertification = agreement.enrollmentStatusCertification;
      this.enrollmentStatusPreCertification = agreement.enrollmentStatusPreCertification;
      this.enrollmentStatusPostCertification = agreement.enrollmentStatusPostCertification;
      this.enrollmentStatusStudent = agreement.enrollmentStatusStudent;
      this.estimatedAgreementEndDate = agreement.estimatedAgreementEndDate;
      this.expectedGraduationDate = agreement.expectedGraduationDate;

      this.fundingAmountCertification = agreement.fundingAmountCertification;
      this.fundingAmountPostCertification = agreement.fundingAmountPostCertification;
      this.fundingAmountStudent = agreement.fundingAmountStudent;
      this.fundingMaximumPreCertification = agreement.fundingMaximumPreCertification;
      this.fundingMinimumPreCertification = agreement.fundingMinimumPreCertification;
      this.fundingPurpose = agreement.fundingPurpose;
    //public String generateAgreement {get;set;}
    //public String generateEsign {get;set;}
    //public String generateEsignURL {get;set;}
    //public String generateFinalDisclosure {get;set;}
    //public String generateDisclosures {get;set;}
    //public String generateDisbursementSchedule {get;set;}
      this.graceMonthsAllowed = agreement.graceMonthsAllowed;
      this.graceMonthsRemaining = agreement.graceMonthsRemaining;
      this.gracePeriodEndDate = agreement.gracePeriodEndDate;
      this.gradeLevel = agreement.gradeLevel;
      this.gradeLevelCertification = agreement.gradeLevelCertification;
      this.gradeLevelPreCertification = agreement.gradeLevelPreCertification;
      this.gradeLevelPostCertification = agreement.gradeLevelPostCertification;
      this.gradeLevelStudent = agreement.gradeLevelStudent;
      this.incomeShare = agreement.incomeShare;
      this.incomeShareCertification = agreement.incomeShareCertification;
      this.incomeSharePostCertification = agreement.incomeSharePostCertification;
      this.incomeShareStudent = agreement.incomeShareStudent;
      this.lastDateOfAttendance = agreement.lastDateOfAttendance;
      this.majorIDCertification = agreement.majorIDCertification;
      this.majorIDPreCertification = agreement.majorIDPreCertification;
      this.majorIDPostCertification = agreement.majorIDPostCertification;
      this.majorIDStudent = agreement.majorIDStudent;
      this.minimumIncomePerMonth = agreement.minimumIncomePerMonth;
      this.minimumIncomePerYear = agreement.minimumIncomePerYear;
      this.nextPaymentDue = agreement.nextPaymentDue;
      this.nextPaymentDueDate = agreement.nextPaymentDueDate;
      this.paidToDate = agreement.paidToDate;
      this.paveTheWay = agreement.paveTheWay;
      this.paymentCap = agreement.paymentCap;
      this.paymentCapCertification = agreement.paymentCapCertification;
      this.paymentCapPostCertification = agreement.paymentCapPostCertification;
      this.paymentCapStudent = agreement.paymentCapStudent;
      this.paymentTerm = agreement.paymentTerm;
      this.paymentTermCertification = agreement.paymentTermCertification;
      this.paymentTermPostCertification = agreement.paymentTermPostCertification;
      this.paymentTermStudent = agreement.paymentTermStudent;
      this.preCertified = agreement.preCertified;
      this.programNotes = agreement.programNotes;
    
        this.quizAttempts = agreement.quizAttemptsData;
        this.quizLocked = agreement.quizLocked;
        this.quizState = agreement.quizState;
        this.quizResponseLink = agreement.quizResponseLink;

      this.registrationExceptionProcess = agreement.registrationExceptionProcess;
      this.remainingTerm = agreement.remainingTerm;
      this.requestedAmount = agreement.requestedAmount;
    //public String resetAgreement {get;set;}
    //public String resetFinalDisclosure {get;set;}
      this.residency = agreement.residency;
      this.residencyCertification = agreement.residencyCertification;
      this.residencyPreCertification = agreement.residencyPreCertification;
      this.residencyPostCertification = agreement.residencyPostCertification;
      this.residencyStudent = agreement.residencyStudent;
      this.rightToCancelDate = agreement.rightToCancelDate;
    
      this.servicing = agreement.servicing;
      this.servicingStartDate = agreement.servicingStartDate;
      //this.signingURL = agreement.signingURL;
      this.signedAgreementID = agreement.signedAgreementID;
      this.signedAgreementURL = agreement.signedAgreementURL;
      this.stateOfResidenceCertification = agreement.stateOfResidenceCertification;
      this.stateOfResidencePreCertification = agreement.stateOfResidencePreCertification;
      this.stateOfResidencePostCertification = agreement.stateOfResidencePostCertification;
      this.stateOfResidenceStudent = agreement.stateOfResidenceStudent;
      this.submittedDateTime = agreement.submittedDateTime;
      this.studentEmail = agreement.studentEmail;
      this.vemoContractNumber = agreement.vemoContractNumber;



    }



//
    public VemoAPIStudentResource.StudentResourceOutputV1 student {get;set;}
    public VemoAPIProgramResource.ProgramResourceOutputV1 program {get;set;}
    public List<VemoAPIDisbursementResource.DisbursementResourceOutputV1> disbursements {get;set;}
    public VemoAPIContractTermsResource.ContractTermResourceOutputV1 contractTerms {get;set;}
    

    public String agreementID {get;set;}
    public String studentID {get;set;}
    public String studentName {get; set;}
    public String programID {get;set;}
    public String programName {get;set;}
    public String schoolID {get;set;}
    public String schoolProgramOfStudyID {get;set;}
    public String agreementStatus {get;set;}
    public String adobeSignStatus {get;set;}
    public String adobeSignJavascript {get;set;}
    //public String adobeSignURL {get;set;}
    public String adobeSignWidgetID {get;set;}
    public String adobeSignAgreementID {get;set;}
    public String agreementSigned {get;set;}
    public Decimal allocatedAmount {get;set;}
    public DateTime applicationStartDateTime {get;set;}
    public DateTime approvalDisclosureDateTime {get;set;}
    public Date attendanceBeginDate {get;set;}
    public Date attendanceEndDate {get;set;}
    public Date birthdate {get;set;}
    public Date birthdateCertification {get;set;}
    public Date birthdatePreCertification {get;set;}
    public Date birthdatePostCertification {get;set;}
    public Date birthdateStudent {get;set;}
    public String bypassAutomation {get;set;}
    public String cancellationReason {get;set;}
    public String certificationComments {get;set;}
    public DateTime certificationDateTime {get;set;}
    public String certificationDraftStatus {get;set;}
    public String congaFinalDisclosureStatus {get;set;}
    public String congaUnsignedAgreementID {get;set;}
    public String congaUnsignedAgreementStatus {get;set;}
    public String finalDisclosureID {get;set;}// should this change to congafinaldisclosureid__c
    public String finalDisclosureURL {get;set;}
    public String creditCheckID {get;set;}
    public String creditCheckProcess {get;set;}
    public DateTime currentStatusDateTime {get;set;}
    public String customerWithdrawnReason {get;set;}
    public String customerWithdrawnReasonOther {get;set;}
    public String defermentID {get;set;}
    public Decimal defermentMonthsAllowed {get;set;}
    public Decimal defermentMonthsRemaining {get;set;}
    public Date defermentBeginDate {get;set;}
    public Date defermentEndDate {get;set;}
    public String eligibleToReapply {get;set;}
    public String enrollmentStatusCertification {get;set;}
    public String enrollmentStatusPreCertification {get;set;}
    public String enrollmentStatusPostCertification {get;set;}
    public String enrollmentStatusStudent {get;set;}
    public Date estimatedAgreementEndDate {get;set;}
    public Date expectedGraduationDate {get;set;}

    public Decimal fundingAmountCertification {get;set;}
    public Decimal fundingAmountPostCertification {get;set;}
    public Decimal fundingAmountStudent {get;set;}
    public Decimal fundingMaximumPreCertification {get;set;}
    public Decimal fundingMinimumPreCertification {get;set;}
    public String fundingPurpose {get;set;}
    //public String generateAgreement {get;set;}
    //public String generateEsign {get;set;}
    //public String generateEsignURL {get;set;}
    //public String generateFinalDisclosure {get;set;}
    //public String generateDisclosures {get;set;}
    //public String generateDisbursementSchedule {get;set;}
    public Decimal graceMonthsAllowed {get;set;}
    public Decimal graceMonthsRemaining {get;set;}
    public Date gracePeriodEndDate {get;set;}
    public String gradeLevel {get;set;}
    public String gradeLevelCertification {get;set;}
    public String gradeLevelPreCertification {get;set;}
    public String gradeLevelPostCertification {get;set;}
    public String gradeLevelStudent {get;set;}    
    public Decimal incomeShare {get;set;}//probably goes away
    public Decimal incomeShareCertification {get;set;}
    public Decimal incomeSharePostCertification {get;set;}
    public Decimal incomeShareStudent {get;set;}
    public Date lastDateOfAttendance {get;set;}
    public String majorIDCertification {get;set;}
    public String majorIDPreCertification {get;set;}
    public String majorIDPostCertification {get;set;}
    public String majorIDStudent {get;set;}
    public Decimal minimumIncomePerMonth {get;set;}
    public Decimal minimumIncomePerYear {get;set;}
    public Decimal nextPaymentDue {get;set;}
    public Date nextPaymentDueDate {get;set;}
    public Decimal paidToDate {get;set;}
    public String paveTheWay {get;set;}
    public Decimal paymentCap {get;set;}//probably goes away
    public Decimal paymentCapCertification {get;set;}
    public Decimal paymentCapPostCertification {get;set;}
    public Decimal paymentCapStudent {get;set;}
    public Decimal paymentTerm {get;set;}//probably goes away
    public Decimal paymentTermCertification {get;set;}
    public Decimal paymentTermPostCertification {get;set;}
    public Decimal paymentTermStudent {get;set;}
    public String programNotes {get;set;}
    public String preCertified {get;set;}
    public String quizAttempts {get;set;}
    public String quizLocked {get;set;}
    public String quizResponseLink {get;set;}
    public String quizState {get;set;}
    public String registrationExceptionProcess {get;set;}
    public Decimal remainingTerm {get;set;}
    public Decimal requestedAmount {get;set;}//probably goes away
    //public String resetAgreement {get;set;}
    //public String resetFinalDisclosure {get;set;}
    public String residency {get;set;}//probably goes away
    public String residencyCertification {get;set;}
    public String residencyPreCertification {get;set;}
    public String residencyPostCertification {get;set;}
    public String residencyStudent {get;set;}
    public Date rightToCancelDate {get;set;}
    public String servicing {get;set;}
    public Date servicingStartDate {get;set;}
    public String signingURL {get;set;}    
    public String signedAgreementID {get;set;}
    public String signedAgreementURL {get;set;}
    public String stateOfResidenceCertification {get;set;}
    public String stateOfResidencePreCertification {get;set;}
    public String stateOfResidencePostCertification {get;set;}
    public String stateOfResidenceStudent {get;set;}
    public DateTime submittedDateTime {get;set;}
    public String studentEmail {get;set;}
    public String vemoContractNumber {get;set;}


  }
}