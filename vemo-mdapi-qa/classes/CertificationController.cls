public class CertificationController{
    
    public CertificationController(){
    }
    
    public CertificationController(VemoAPIVFController cntrl){
    }
    
    public class ControllerException extends Exception {}

    public class Agreement {
        public String studentName {get; set;}
        public String studentID {get;set;}
        public String agreementID {get; set;}
        public String programName {get;set;}
        public String programID {get;set;}
        public String schoolID {get;set;}
        public DateTime birthdate {get; set;}
        public DateTime expectedGraduation {get; set;}
        public DateTime expectedGraduationStudent {get; set;}
        public String studentEmail {get; set;}
        public String residency {get; set;}
        public String residencyStudent {get; set;}
        public String stateOfResidence {get; set;}
        public Integer age {get; set;}
        public String enrollmentStatus {get; set;}
        public String enrollmentStatusStudent {get; set;}
        public String majorID {get; set;}
        public String majorIDStudent {get; set;}
        public Decimal fundingMax {get; set;}
        public Decimal fundingMin {get; set;}
        public Decimal fundingAmount {get;set;}
        public Decimal fundingAmountStudent {get;set;}
        public Decimal fundingAmountCertification {get;set;}
        public String gradeLevel {get; set;}
        public String gradeLevelStudent {get; set;}
        public DateTime applicationDate {get; set;}
        public DateTime fundingPeriodStartDate {get; set;}
        public DateTime fundingPeriodEndDate {get; set;}
        public String status {get; set;}
        public String notCertifiedReason {get; set;}
        public String comments {get; set;}
        public String certificationDraftStatus {get;set;}
        public Integer rightToCancelDays {get; set;}
        public Decimal incomeShare {get; set;}
        public Decimal incomeShareStudent {get; set;}
        public Decimal incomeSharePostCertification {get;set;}
        public Decimal paymentTerm {get; set;}
        public Decimal paymentTermStudent {get; set;}
        public Decimal paymentCap {get; set;}
        public Decimal paymentCapStudent {get; set;}
        public Boolean errorFundingAmountNotSet {get; set;}
        public Boolean errorFundingAmountBelowMinimum {get; set;}
        public Boolean errorFundingAmountAboveMaximum {get; set;}
        public Boolean errorContractTermsNotFound {get; set;}
        public String ssnTaxID {get; set;}
        public String vemoContractNumber {get; set;}
        public Integer earningsGroup {get; set;}        
        public Integer earningsGroupStudent {get; set;}     
        public String adjustmentMethod {get; set;}      
        public String adjustmentMethodStudent {get; set;}
        public String preCertified{get;set;}
        public Decimal programFundingMax{get;set;}
        public Decimal programFundingMin{get;set;}
        public DateTime rightToCancelDate{get;set;}
        public Decimal cumulativeIncomeShare{get;set;}
        public Decimal cumulativeIncomeShareCap{get;set;}
        public ContractTermsService.ContractTerm contractTerms {get;set;}

        public List<Disbursement> disbursements {get; set;}

        public Agreement() {
        }

        public Agreement(AgreementService.Agreement agreement, Boolean isStudentInitiated) {
            this.agreementID = agreement.agreementID;
            this.studentName = agreement.studentName;
            this.programID = agreement.programID;
            this.programName = agreement.programName;
            if(agreement.certificationDraftStatus <> null){
                this.certificationDraftStatus = agreement.certificationDraftStatus;
            }
            else{
                this.certificationDraftStatus = 'None';
            }
            // Most of the DateTimes in SF are in UTC, but for some reason
            // applicationStartDateTime is in localtime, so we need to convert.
            this.applicationDate = DateTime.newInstanceGmt(
                agreement.applicationStartDateTime.year(),
                agreement.applicationStartDateTime.month(),
                agreement.applicationStartDateTime.day(),
                agreement.applicationStartDateTime.hour(),
                agreement.applicationStartDateTime.minute(),
                agreement.applicationStartDateTime.second());
            
                this.comments = agreement.certificationComments;         
            if (isStudentInitiated) {
                //added to student initiated flow 
                this.birthdate = agreement.birthdateStudent;
                this.residencyStudent = agreement.residencyStudent;
                this.enrollmentStatusStudent = agreement.enrollmentStatusStudent;
                this.gradeLevelStudent = agreement.gradeLevelStudent;
                this.majorIDStudent = agreement.majorIDStudent;
                this.fundingAmountStudent = agreement.fundingAmountStudent;
                this.incomeShareStudent = agreement.incomeShareStudent;
                this.paymentTermStudent = agreement.paymentTermStudent;
                this.paymentCapStudent = agreement.paymentCapStudent;
                this.stateOfResidence = agreement.stateOfResidenceStudent;    
                
                this.residency = agreement.residencyStudent;
                if (String.isNotEmpty(agreement.residencyCertification))
                    this.residency = agreement.residencyCertification;

                this.enrollmentStatus = agreement.enrollmentStatusStudent;
                if (String.isNotEmpty(agreement.enrollmentStatusCertification))
                    this.enrollmentStatus = agreement.enrollmentStatusCertification;

                this.gradeLevel = agreement.gradeLevelStudent;
                if (String.isNotEmpty(agreement.gradeLevelCertification))
                    this.gradeLevel = agreement.gradeLevelCertification;

                this.majorID = agreement.majorIDStudent;
                if (String.isNotEmpty(agreement.majorIDCertification))
                    this.majorID = agreement.majorIDCertification;

                this.fundingAmount = agreement.fundingAmountStudent;
                if (agreement.fundingAmountCertification != null)
                    this.fundingAmount = agreement.fundingAmountCertification;

                this.incomeShare = agreement.incomeShareStudent;
                if (agreement.incomeShareCertification != null)
                    this.incomeShare = agreement.incomeShareCertification;

                this.paymentTerm = agreement.paymentTermStudent;
                if (agreement.paymentTermCertification != null)
                    this.paymentTerm = agreement.paymentTermCertification;

                this.paymentCap = agreement.paymentCapStudent;
                if (agreement.paymentCapCertification != null)
                    this.paymentCap = agreement.paymentCapCertification;
            } else {
                // this code block is for school initiated flow ie Pre-Certification App                
                this.stateOfResidence = agreement.stateOfResidenceStudent;
                if (String.isNotEmpty(agreement.stateOfResidencePreCertification))
                    this.stateOfResidence = agreement.stateOfResidencePreCertification;
                
                this.residency = agreement.residencyStudent;
                if (String.isNotEmpty(agreement.residencyPreCertification))
                    this.residency = agreement.residencyPreCertification;

                this.enrollmentStatus = agreement.enrollmentStatusStudent;
                if (String.isNotEmpty(agreement.enrollmentStatusPreCertification))
                    this.enrollmentStatus = agreement.enrollmentStatusPreCertification;

                this.gradeLevel = agreement.gradeLevelStudent;
                if (String.isNotEmpty(agreement.gradeLevelPreCertification))
                    this.gradeLevel = agreement.gradeLevelPreCertification;

                this.majorID = agreement.majorIDStudent;
                if (String.isNotEmpty(agreement.majorIDPreCertification))
                    this.majorID = agreement.majorIDPreCertification;

                // There is no fundingAmountPreCertification instead fetch the range min & max
                //this.fundingAmount = agreement.fundingAmountStudent;
                this.fundingMax = agreement.fundingMaximumPreCertification; 
                this.fundingMin = agreement.fundingMinimumPreCertification; 
                //this.preCertified = agreement.preCertified;
                this.birthdate = agreement.birthdatePreCertification;
                this.rightToCancelDate = agreement.rightToCancelDate;
                 
                if(agreement.notCertifiedReason <> null){
                    this.notCertifiedReason = agreement.notCertifiedReason;  
                }
                else{
                    this.notCertifiedReason = 'None';
                }
            }
        }
    }

    public class Disbursement {
        public String agreementID {get;set;}
        public String disbursementID {get; set;}
        public DateTime disbursementDate {get; set;}
        public Decimal disbursementAmount {get; set;}
        public String relatedScheduleID {get; set;}
        public Decimal disbursementPercentage {get; set;}
        public String specialDisbursementType {get;set;}
        public Disbursement() {
        }

        public Disbursement(TransactionService.Disbursement disb,Boolean isStudentInitiated) {
            this.agreementID = disb.agreementID;
            this.disbursementID = disb.disbursementID;
            this.disbursementDate = DateTime.newInstanceGmt(
                disb.transactionDate.year(),
                disb.transactionDate.month(),
                disb.transactionDate.day());
            this.relatedScheduleID = disb.relatedScheduleID;
            if(isStudentInitiated){
                this.disbursementAmount = disb.amount;
            }
            else {
                this.disbursementAmount = disb.amount;
                this.disbursementPercentage = disb.disbursementPercentage;
            }
            this.specialDisbursementType = disb.specialDisbursementType;
        }
        
        public Disbursement(TransactionSchedule__c txSch,Id agreementID){
            this.agreementID = agreementID;
            this.disbursementDate = DateTime.newInstanceGmt(
                txSch.ScheduledDate__c.year(),
                txSch.ScheduledDate__c.month(),
                txSch.ScheduledDate__c.day());
            this.relatedScheduleID = txSch.id;
            this.disbursementPercentage = txSch.FundingAmount__c;
            this.specialDisbursementType = txSch.specialDisbursementType__c;
            this.disbursementAmount = txSch.Amount__c;
        }
    }

    public class School {
        String schoolID {get;set;}
        String schoolName {get;set;}
        String campusServiceName {get;set;}
        String campusServiceEmail {get;set;}
        String campusServiceMobile {get;set;}
        String campusServiceAvailability {get;set;}
    }
    
    public class Student{
        public String studentID {get;set;}
        public String firstName {get;set;}
        public String middleName {get;set;}
        public String lastName {get;set;}
        public String email {get;set;}
        public String SSN {get;set;}
        public Date birthdate {get;set;}
        public String citizenship {get;set;}
        public String enrollmentStatus {get;set;}
        public String gradeLevel {get;set;}
        public String majorID {get;set;}
        public Date graduationDate {get;set;}
        public String mailingStateCode {get;set;}
        public String mailingState {get;set;}
        public String mobilePhone {get;set;}
        public String schoolID {get;set;}
        public List<Offer> offers {get;set;}
        public List<Agreement> enrolledPrograms {get;set;}
        
        public Student(){
        }
        
        public Student(StudentService.Student student){
            this.studentID = student.personAccountID;
            this.firstName = student.firstName; 
            this.middleName = student.middleName;
            this.lastName = student.lastName;
            this.email = student.email; 
            this.SSN = student.ssnTaxID; 
            this.birthdate = student.birthdate; 
            this.citizenship = student.residency; 
            this.enrollmentStatus = student.primarySchoolEnrollmentStatus; 
            this.gradeLevel = student.primarySchoolGradeLevel;
            this.majorID = student.schoolProgramOfStudyID; 
            this.graduationDate = student.primarySchoolGraduationDate;
            this.mailingStateCode = student.mailingStateCode;
            this.mailingState = student.mailingState;
            this.mobilePhone = student.mobilePhone;
            this.schoolID = student.primarySchoolID; 
        }
        public Student(Account acc){
            this.studentID = acc.ID;
            this.firstName = acc.firstName; 
            this.middleName = acc.middleName;
            this.lastName = acc.lastName;
            this.email = acc.personemail; 
            this.SSN = acc.SSNTaxID__pc ; 
        }
    }
    
    public class Offer{
        public String programID {get;set;}
        public String programName {get;set;}
        public String schoolID {get;set;}
        public String programStatus {get;set;}
        public String agreementStatus {get;set;}
        public String agreementID {get;set;}
        public String studentID {get;set;}
        public Date enrollmentBeginDate {get;set;}
        public Date enrollmentEndDate {get;set;}
        public Date registrationBeginDate {get;set;}
        public Date registrationEndDate {get;set;}
        public Decimal programFundingMax{get;set;}
        public Decimal programFundingMin{get;set;}
        public Integer rightToCancelDays{get;set;}
        public List<Disbursement> disbSchedule {get;set;}
        
        public Offer(OfferService.Offer offer,Boolean isAgreement){
            this.enrollmentBeginDate = offer.enrollmentBeginDate;
            this.enrollmentEndDate = offer.enrollmentEndDate;
            this.registrationBeginDate = offer.registrationBeginDate;
            this.registrationEndDate = offer.registrationEndDate;  
            this.programID = offer.programID;
            this.programName = offer.programName;
            this.schoolID = offer.schoolID;
            this.programStatus = offer.programStatus;
            if(isAgreement){
                this.agreementStatus = offer.agreementStatus;
                this.agreementID = offer.agreementID;
                this.studentID = offer.studentID;
            }    
        }
        
        public Offer(Program__c prog){
            this.enrollmentBeginDate = prog.EnrollmentBeginDate__c;
            this.enrollmentEndDate = prog.EnrollmentEndDate__c;
            this.registrationBeginDate = prog.RegistrationBeginDate__c;
            this.registrationEndDate = prog.RegistrationEndDate__c;  
            this.rightToCancelDays = (Integer) prog.RightToCancelDays__c;
            this.programID = prog.Id;
            this.programName = prog.ProgramName__c;
            this.schoolID = prog.School__c;
            this.programStatus = prog.ProgramStatus__c;
        }
    }

    @RemoteAction
    public static List<School> loadUser(String val) {
        System.debug('Running CertificationController.loadUser');
        List<School> schools = new List<School>();
        try{
            List<User> userList = [SELECT id, AccountID, Account.RecordType.Id, ContactID from User where id = :UserInfo.getUserID()];
            System.debug('User List = ' + userList);
            System.debug('Account Record Type = ' + userList.get(0).Account.RecordType.Id);
            if (userList.size() == 1 && String.isNotEmpty(userList[0].AccountID)) {
                List<SchoolService.School> schoolsList = SchoolService.getSchoolsWithSchoolID(new Set<ID>{userList[0].AccountID});
                for (SchoolService.School schoolServiceSchool : schoolsList) {
                    School sch = new School();
                    sch.schoolID = schoolServiceSchool.schoolID;
                    sch.schoolName = schoolServiceSchool.schoolName;
                    sch.campusServiceName = schoolServiceSchool.campusServiceName;
                    sch.campusServiceEmail = schoolServiceSchool.campusServiceEmail;
                    sch.campusServiceMobile = schoolServiceSchool.campusServiceMobile;
                    sch.campusServiceAvailability = schoolServiceSchool.campusServiceAvailability;  
                    schools.add(sch);
                }
            }

            if (!schools.isEmpty())
                return schools;

            // This must be a Vemo user

            List<SchoolService.School> schoolCustomers = SchoolService.getSchoolCustomers();
            for (SchoolService.School schoolCustomer : schoolCustomers) {
                School sch = new School();
                sch.schoolID = schoolCustomer.schoolID;
                sch.schoolName = schoolCustomer.schoolName;
                sch.campusServiceName = schoolCustomer.campusServiceName;
                sch.campusServiceEmail = schoolCustomer.campusServiceEmail;
                sch.campusServiceMobile = schoolCustomer.campusServiceMobile;
                sch.campusServiceAvailability = schoolCustomer.campusServiceAvailability;  
                    
                schools.add(sch);
            }

            return schools;
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.loadUser');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an issue loading users');
            ApexPages.addMessage(msg);
        }
        return schools;
    }
    
        
    @RemoteAction
    public static List<Agreement> getAgreements(String schoolID,String mode) {
        if(mode == null || (mode <> 'preCert' && mode <> 'postCert')){
            mode = 'postCert';
        }
        List<Agreement> output = new List<Agreement>();
        try{
            // TODO: try sending all programIDs in one db call
            Map<String, Boolean> cache = new Map<String, Boolean>();
                
            List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithSchoolID(new Set<ID>{schoolID});
            for (AgreementService.Agreement agr : agreements) {
                if(mode == 'postCert'){
                    if (agr.agreementStatus == 'Application Complete') {
                        Boolean isStudentInitiated;
                        System.debug('in getAgreements, cache.containsKey ' + agr.programID);
                        if (cache.containsKey(agr.programID)) {
                            isStudentInitiated = cache.get(agr.programID);
                            System.debug('in getAgreements with postCert mode, yes');
                        } else {
                            System.debug('in getAgreements, no');
                            List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(new Set<ID>{agr.programID});
                            isStudentInitiated = (programs[0].enrollmentType == 'Open');
                            cache.put(agr.programID, isStudentInitiated);
                        }
    
                        output.add(new Agreement(agr, isStudentInitiated));
                    }
                }
                else{
                    if(mode == 'preCert'){
                        if(agr.agreementStatus == 'Draft' && agr.preCertified == 'false'){
                            Boolean isInviteOnly;
                            if (cache.containsKey(agr.programID)) {
                                isInviteOnly = cache.get(agr.programID);
                                System.debug('in getAgreements with preCert mode, yes');
                                if(isInviteOnly){
                                    output.add(new Agreement(agr, false));
                                } 
                            } else {
                                System.debug('in getAgreements, no');
                                List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(new Set<ID>{agr.programID});
                                isInviteOnly = (programs[0].enrollmentType == 'Invite Only');
                                cache.put(agr.programID, isInviteOnly);
                                if(isInviteOnly){
                                    output.add(new Agreement(agr, false));
                                }
                            }
                                
                        }
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getAgreements');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error getting agreements');
            ApexPages.addMessage(msg);
        }
        return output;
    }
    
    // Call this function to retrieve all valid residency options
    @RemoteAction
    public static List<String> getCitizenshipOptions(String val) {
        List<String> options = GlobalUtil.getPicklistValues('StudentProgram__c', 'Residency__c');
        return options;
    }
    
    // Call this function to retrive all valid enrollment status options
    @RemoteAction
    public static List<String> getEnrollmentOptions(String val) {
        List<String> options = GlobalUtil.getPicklistValues('StudentProgram__c', 'EnrollmentStatus__c');
        return options;
    }
    
    // Call this function to retrieve all valid grade level options
    @RemoteAction
    public static List<String> getGradeLevelOptions(String val) {
        List<String> options = GlobalUtil.getPicklistValues('StudentProgram__c', 'GradeLevel__c');
        return options;
    }

    // Call this function to retrieve all valid grade level options
    @RemoteAction
    public static List<String> getNotCertifiedReasonOptions(String val) {
        List<String> options = GlobalUtil.getPicklistValues('StudentProgram__c', 'NotCertifiedReason__c');
        return options;
    }
    
    // Use this function to return the correct list of majors by schoolID
    @RemoteAction
    public static List<MajorOptions> getMajorOptions(String schoolID) {
        List<MajorOptions> majorOptList = new List<MajorOptions>();
        try{
            System.debug('in CertificationController.getMajorOptions schoolID is:' + schoolID);
            List<ProgramOfStudyService.ProgramOfStudy> posList = ProgramOfStudyService.getProgramOfStudyWithSchoolIDs(new Set<ID>{schoolID});
            
            for (ProgramOfStudyService.ProgramOfStudy pos : posList) {
                MajorOptions mo = new MajorOptions();
                mo.majorID = pos.schoolProgramOfStudyID;
                mo.majorName = pos.description;
                majorOptList.add(mo);
            }
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getMajorOptions');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error getting agreements');
            ApexPages.addMessage(msg);
        }
        return majorOptList;
    }

    public class MajorOptions {
        String majorID {get;set;}
        String majorName {get;set;}
    }

    @RemoteAction
    public static Agreement getAgreement(String agreementID) {
        Agreement agr = null;
        try{
            List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(new Set<ID>{agreementID});
            List<StudentService.Student> students = StudentService.getStudentsWithStudentID(new Set<ID>{agreements[0].studentID});
            List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(new Set<ID>{agreements[0].programID});
            Boolean isStudentInitiated = (programs[0].enrollmentType == 'Open');

            agr = new Agreement(agreements[0], isStudentInitiated);
            agr.studentEmail = students[0].email;
            agr.studentID = students[0].personAccountID;
            agr.expectedGraduationStudent = students[0].primarySchoolGraduationDate;

            agr.expectedGraduation = students[0].primarySchoolGraduationDate;
            if (agreements[0].expectedGraduationDate != null)
                agr.expectedGraduation = agreements[0].expectedGraduationDate;

            
            agr.fundingPeriodStartDate = programs[0].enrollmentBeginDate;
            agr.fundingPeriodEndDate = programs[0].enrollmentEndDate;
            
            agr.ssnTaxID = students[0].SSNTaxID;
            agr.vemoContractNumber = agreements[0].vemoContractNumber;
            agr.rightToCancelDays = programs[0].rightToCancelDays;
            
            agr.cumulativeIncomeShare = students[0].cumulativeIncomeShare;
            agr.cumulativeIncomeShareCap = students[0].cumulativeIncomeShareCap;  
                
            if (isStudentInitiated) {
                //moving some fields here which are not required by school initiated flow
                
                agr.notCertifiedReason = agreements[0].notCertifiedReason;
                
                // Calc age from birthdateStudent
                if (agreements[0].birthdateStudent != null) {
                    Integer ageTotalDays = agreements[0].birthdateStudent.daysBetween(system.today());
                    agr.age = (Integer)(math.Floor(ageTotalDays / 365.2425));
                }
                    
                System.debug('in CertificationController.Agreement about to call getContractTermsWithCriteria');
                ContractTermsService.ContractTerm contractTerms = ContractTermsService.getContractTermsWithCriteria(
                    agr.programID,
                    agr.majorID,
                    agr.gradeLevel);

                System.debug('in CertificationController.getAgreement contractTerms=' + contractTerms);
                if(contractTerms != null) {
                   agr.contractTerms = contractTerms;
                }
                if (contractTerms != null && 
                    contractTerms.minimumFundingAmount != null &&
                    contractTerms.maximumFundingAmount != null) {

                    agr.fundingMin = contractTerms.minimumFundingAmount;
                    agr.fundingMax = contractTerms.maximumFundingAmount;
                    agr.earningsGroup = Integer.valueof(contractTerms.earningsGroup);       
                    agr.adjustmentMethod = contractTerms.adjustmentMethod;
                    
                    if (agr.fundingAmount != null) {
                        System.debug('in CertificationController.getAgreement in');
                        if (agr.fundingAmount < contractTerms.minimumFundingAmount)
                            agr.errorFundingAmountBelowMinimum = true;
                        else if (agr.fundingAmount > contractTerms.maximumFundingAmount)
                            agr.errorFundingAmountAboveMaximum = true;
                    } else {
                        agr.errorFundingAmountNotSet = true;
                    }
                } else {
                    agr.errorContractTermsNotFound = true;
                }
                
                // Now get the contractTerms with Student fields        
                System.debug('in CertificationController.getAgreement agr.majorIDStudent=' + agr.majorIDStudent);       
                System.debug('in CertificationController.getAgreement agr.gradeLevelStudent=' + agr.gradeLevelStudent);     
                contractTerms = ContractTermsService.getContractTermsWithCriteria(      
                    agr.programID,      
                    agr.majorIDStudent,     
                    agr.gradeLevelStudent);     
                System.debug('in CertificationController.getAgreement contractTerms=' + contractTerms);     

                if (contractTerms != null &&        
                    contractTerms.minimumFundingAmount != null &&       
                    contractTerms.maximumFundingAmount != null) {       
                    agr.earningsGroupStudent = Integer.valueof(contractTerms.earningsGroup);        
                    agr.adjustmentMethodStudent = contractTerms.adjustmentMethod;       
                }

                System.debug('in CertificationController.getAgreement after');
            }
            else{
                
                //this is for school initiated flow to give the the min/max funding from program
                if((agr.programID <> null) && (agr.majorID <> null) && (agr.gradeLevel <> null)){
                    ContractTermsService.ContractTerm contractTerms = ContractTermsService.getContractTermsWithCriteria(
                        agr.programID,
                        agr.majorID,
                        agr.gradeLevel);
                    
                    if(contractTerms != null){
                       agr.contractTerms = contractTerms;
                       if(contractTerms.minimumFundingAmount != null) agr.programFundingMin = contractTerms.minimumFundingAmount;       
                       if(contractTerms.maximumFundingAmount != null) agr.programFundingMax = contractTerms.maximumFundingAmount;
                    }
                }

            }

            // Disbursements
            agr.disbursements = new List<Disbursement>();
            List<TransactionService.Disbursement> tsds = TransactionService.getDisbursementWithAgreementID(new Set<ID>{agreementID});
            for (TransactionService.Disbursement tsd : tsds) {
                agr.disbursements.add(new Disbursement(tsd,isStudentInitiated));
            }
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getAgreement');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error getting agreements');
            ApexPages.addMessage(msg);
        }
        return agr;
    }

    @RemoteAction
    public static void updateAgreement(Agreement agr) {
        try{
            System.debug('in CertificationController.updateAgreement agreementID is:' + agr.agreementID);

            List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(new Set<ID>{agr.agreementID});
            List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(new Set<ID>{agreements[0].programID});
            Boolean isStudentInitiated = (programs[0].enrollmentType == 'Open');

            //todo - convert to service layer call
            // for student-initiated, these should write to the (Certification) fields.
            // for school-initiated, these should write to the (Pre-Certification) fields.
            AgreementService.Agreement agreement = new AgreementService.Agreement();
            agreement.agreementID = agr.agreementID;
            agreement.certificationComments = agr.comments;
            if (isStudentInitiated) {
                agreement.residencyCertification = agr.residency;
                agreement.enrollmentStatusCertification = agr.enrollmentStatus;
                agreement.gradeLevelCertification = agr.gradeLevel;
                agreement.majorIDCertification = agr.majorID;
                agreement.fundingAmountCertification = agr.fundingAmount;

                agreement.birthdateCertification = agreements[0].birthdateStudent;
                agreement.stateOfResidenceCertification = agreements[0].stateOfResidenceStudent;
                
                //moving some fields to student initiated flow
                agreement.certificationDraftStatus = agr.certificationDraftStatus;
                
                // Calculate contract terms
                System.debug('in CertificationController.updateAgreement about to calculate terms');
                ContractTermsService.ContractTerm contractTerms = ContractTermsService.getContractTermsWithCriteria(
                    agreements[0].programID,
                    agr.majorID,
                    agr.gradeLevel);

                System.debug('in CertificationController.updateAgreement about to calculate terms' + contractTerms);
                System.debug('in CertificationController.updateAgreement agr.fundingAmount=' + agr.fundingAmount);

                if (contractTerms != null &&
                    contractTerms.minimumFundingAmount != null &&
                    contractTerms.maximumFundingAmount != null) {
                    if (agr.fundingAmount != null) {
                        if (agr.fundingAmount < contractTerms.minimumFundingAmount) {
                            // Set these back to defaults
                            //agreement.incomeShareCertification = agreement.incomeShareStudent;
                            //agreement.paymentTermCertification = agreement.paymentTermStudent;
                            //agreement.paymentCapCertification = agreement.paymentCapStudent;
                        } else if (agr.fundingAmount > contractTerms.maximumFundingAmount) {
                            // Set these back to defaults
                            //agreement.incomeShareCertification = agreement.incomeShareStudent;
                            //agreement.paymentTermCertification = agreement.paymentTermStudent;
                            //agreement.paymentCapCertification = agreement.paymentCapStudent;
                        } else {
                            Decimal adjustmentRatio = agr.fundingAmount / 10000;
                            System.debug('in CertificationController.updateAgreement adjustmentRatio=' + adjustmentRatio);
                            if (contractTerms.adjustmentMethod == 'Income Share') {
                                agreement.incomeShareCertification = (contractTerms.incomeShare * adjustmentRatio).setScale(2);
                                System.debug('in CertificationController.updateAgreement agreement.incomeShareCertification=' + agreement.incomeShareCertification);

                                // Set this back to default in case it was changed
                                agreement.paymentTermCertification = contractTerms.paymentTerm;
                            } else if (contractTerms.adjustmentMethod == 'Payment Term') {
                                agreement.paymentTermCertification = (contractTerms.paymentTerm * adjustmentRatio).round();
                                System.debug('in CertificationController.updateAgreement agreement.paymentTermCertification=' + agreement.paymentTermCertification);

                                // Set this back to default in case it was changed
                                agreement.incomeShareCertification = contractTerms.incomeShare;
                            }

                            agreement.paymentCapCertification = contractTerms.paymentCapFactor * agr.fundingAmount;
                            System.debug('in CertificationController.updateAgreement agreement.paymentCapCertification=' + agreement.paymentCapCertification);
                        }
                    } else {
                        // Funding amount not set, set these back to defaults
                        //agreement.incomeShareCertification = agreement.incomeShareStudent;
                        //agreement.paymentTermCertification = agreement.paymentTermStudent;
                        //agreement.paymentCapCertification = agreement.paymentCapStudent;
                    }
                } else {
                    // Contract terms not found, set these back to defaults
                    //agreement.incomeShareCertification = agreement.incomeShareStudent;
                    //agreement.paymentTermCertification = agreement.paymentTermStudent;
                    //agreement.paymentCapCertification = agreement.paymentCapStudent;
                }
            } else {
                if(agr.residency <> null)
                    agreement.residencyPreCertification = agr.residency;
                if(agr.enrollmentStatus <> null)
                    agreement.enrollmentStatusPreCertification = agr.enrollmentStatus;
                if(agr.gradeLevel <> null)
                    agreement.gradeLevelPreCertification = agr.gradeLevel;
                if(agr.majorID <> null)
                    agreement.majorIDPreCertification = agr.majorID;
                // There is no fundingAmountPreCertification
                //agreement.fundingAmountPreCertification = agr.fundingAmount;
                if(agr.birthdate <> null)
                    agreement.birthdatePreCertification = agr.birthdate.dateGMT();
                if(agr.stateOfResidence <> null)
                    agreement.stateOfResidencePreCertification = agr.stateOfResidence;
                if(agr.fundingMax <> null)
                    agreement.fundingMaximumPreCertification = agr.fundingMax;
                if(agr.fundingMin <> null)
                    agreement.fundingMinimumPreCertification = agr.fundingMin;  
                //if(agr.preCertified <> null)
                //    agreement.preCertified = agr.preCertified; 
                if(agr.certificationDraftStatus <> null)    
                    agreement.certificationDraftStatus = agr.certificationDraftStatus;
            }

            if(agr.notCertifiedReason <> null && agr.notCertifiedReason <> 'None'){
                agreement.notCertifiedReason = agr.notCertifiedReason;
            }
            else{
                agreement.notCertifiedReason = '';
            }
            
            if (agr.expectedGraduation != null) {
                Date expectedGraduation = Date.newInstance(
                    agr.expectedGraduation.yearGmt(),
                    agr.expectedGraduation.monthGmt(),
                    agr.expectedGraduation.dayGmt());
                agreement.expectedGraduationDate = expectedGraduation;
            }

            AgreementService.updateAgreement(new List<AgreementService.Agreement>{agreement});

            // Query existing disbursements so we know if any were deleted
            Set<ID> disbursementsToDelete = new Set<ID>();
            List<TransactionService.Disbursement> tsds = TransactionService.getDisbursementWithAgreementID(new Set<ID>{agr.agreementID});
            for (TransactionService.Disbursement tsd : tsds) {
                disbursementsToDelete.add(tsd.disbursementID);
            }

            System.debug('in CertificationController.updateAgreement disbursementsToDelete.size():' + disbursementsToDelete.size());

            //todo - convert to service layer
            List<TransactionService.Disbursement> disbursementsToUpdate = new List<TransactionService.Disbursement>();
            List<TransactionService.Disbursement> disbursementsToCreate = new List<TransactionService.Disbursement>();
            for (Disbursement disb : agr.disbursements){
                TransactionService.Disbursement disbursement = new TransactionService.Disbursement();
                Date disbDate = Date.newInstance(disb.disbursementDate.yearGmt(), disb.disbursementDate.monthGmt(), disb.disbursementDate.dayGmt());
                if (String.isNotEmpty(disb.disbursementID)) {
                    disbursement.disbursementID = disb.disbursementID;
                    disbursement.agreementID = agr.agreementID;
                    disbursement.transactionDate = disbDate;
                    
                    if (isStudentInitiated == true) 
                        disbursement.amount = disb.disbursementAmount;
                    else {
                        disbursement.disbursementPercentage = disb.disbursementPercentage;
                        disbursement.amount = disb.disbursementAmount;
                    }
                        
                    disbursementsToUpdate.add(disbursement);
                    disbursementsToDelete.remove(disb.disbursementID);
                    System.debug('in CertificationController.updateAgreement just removed one disbursementsToDelete.size():' + disbursementsToDelete.size());
                } else {
                    disbursement.studentID = agreements[0].studentID;
                    disbursement.agreementID = agr.agreementID;
                    disbursement.transactionDate = disbDate;
                    disbursement.status = 'Scheduled';
                    
                    if (isStudentInitiated == true) 
                        disbursement.amount = disb.disbursementAmount;
                    else {
                        disbursement.disbursementPercentage = disb.disbursementPercentage;
                        disbursement.amount = disb.disbursementAmount;
                    }

                    
                    disbursementsToCreate.add(disbursement);
                }
            }
            TransactionService.updateDisbursements(disbursementsToUpdate);
            TransactionService.createDisbursements(disbursementsToCreate);
            System.debug('in CertificationController.updateAgreement about to delete disbursementsToDelete.size():' + disbursementsToDelete.size());
            TransactionService.deleteDisbursements(disbursementsToDelete);
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.updateAgreement');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error updating agreements');
            ApexPages.addMessage(msg);
        }
    }

    @RemoteAction
    public static void saveAgreements(List<ID> agreementIDs) {
        try{
            System.debug('in CertificationController.saveAgreements');
            List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(new Set<ID>(agreementIDs));
            List<StudentProgram__c> sps = new List<StudentProgram__c>();
            //List<AgreementService.Agreement> agreementsToUpdate = new List<AgreementService.Agreement>();
            for (ID agreementID : agreementIDs) {
                System.debug('in CertificationController.saveAgreements agreementID:' + agreementID);
                AgreementService.Agreement agreement = null;
                //AgreementService.Agreement agreementToUpdate = new AgreementService.Agreement();
                for (AgreementService.Agreement agrTmp : agreements) {
                    if (agrTmp.agreementID == agreementID) {
                        System.debug('in CertificationController.saveAgreements found');
                        agreement = agrTmp;
                        break;
                    }
                }

                StudentProgram__c sp = new StudentProgram__c(
                    Id = agreementID,
                    Status__c = agreement.certificationDraftStatus);
                if (agreement.certificationDraftStatus == 'Cancelled')
                    sp.CancellationReason__c = 'Not Certified';
                sps.add(sp);

                List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(new Set<ID>{agreement.programID});
                Boolean isStudentInitiated = (programs[0].enrollmentType == 'Open');

                /*

                // TODO: why am i doing this? Shouldn't the Cert fields be set by updateAgreement? saveAgreements
                // should not be possible to be called for an agreement that has not been updated by updateAgreements

                if (isStudentInitiated) {
                    if (String.isEmpty(agreement.residencyCertification))
                        agreement.residencyCertification = agreement.residencyStudent;

                    if (String.isEmpty(agreement.enrollmentStatusCertification))
                        agreement.enrollmentStatusCertification = agreement.enrollmentStatusStudent;

                    if (String.isEmpty(agreement.gradeLevelCertification))
                        agreement.gradeLevelCertification = agreement.gradeLevelStudent;

                    if (String.isEmpty(agreement.majorIDCertification))
                        agreement.majorIDCertification = agreement.majorIDStudent;

                    if (agreement.fundingAmountCertification == null)
                        agreement.fundingAmountCertification = agreement.fundingAmountStudent;

                    if (agreement.incomeShareCertification == null)
                        agreement.incomeShareCertification = agreement.incomeShareStudent;

                    if (agreement.paymentTermCertification == null)
                        agreement.paymentTermCertification = agreement.paymentTermStudent;

                    if (agreement.paymentCapCertification == null)
                        agreement.paymentCapCertification = agreement.paymentCapStudent;

                    // Calculate contract terms
                    System.debug('in CertificationController.updateAgreement about to calculate terms');
                    ContractTermsService.ContractTerm contractTerms = ContractTermsService.getContractTermsWithCriteria(
                        agreement.programID,
                        agreement.majorIDCertification,
                        agreement.gradeLevelCertification);

                    System.debug('in CertificationController.updateAgreement about to calculate terms' + contractTerms);
                    System.debug('in CertificationController.updateAgreement agreement.fundingAmountCertification=' + agreement.fundingAmountCertification);

                    if (contractTerms != null &&
                        contractTerms.minimumFundingAmount != null &&
                        contractTerms.maximumFundingAmount != null) {
                        if (agreement.fundingAmountCertification != null) {
                            if (agreement.fundingAmountCertification < contractTerms.minimumFundingAmount) {
                                throw new ControllerException('Funding amount is below minimum.');
                            } else if (agreement.fundingAmountCertification > contractTerms.maximumFundingAmount) {
                                throw new ControllerException('Funding amount is above maximum.');
                            }
                        } else {
                            throw new ControllerException('Funding amount not set.');
                        }
                    } else {
                        throw new ControllerException('Contract terms not found.');
                    }

                    agreement.birthdateCertification = agreement.birthdateStudent;
                    agreement.stateOfResidenceCertification = agreement.stateOfResidenceStudent;
                    //agreement.incomeShareCertification = agreement.incomeShareStudent;
                    //agreement.paymentTermCertification = agreement.paymentTermStudent;
                    //agreement.paymentCapCertification = agreement.paymentCapStudent;
                } else {
                    if (String.isEmpty(agreement.residencyPreCertification))
                        agreement.residencyPreCertification = agreement.residencyStudent;

                    if (String.isEmpty(agreement.enrollmentStatusPreCertification))
                        agreement.enrollmentStatusPreCertification = agreement.enrollmentStatusStudent;

                    if (String.isEmpty(agreement.gradeLevelPreCertification))
                        agreement.gradeLevelPreCertification = agreement.gradeLevelStudent;

                    if (String.isEmpty(agreement.majorIDPreCertification))
                        agreement.majorIDPreCertification = agreement.majorIDStudent;

                    // There is no fundingAmountPreCertification
                    //agreement.fundingAmountPreCertification = agreement.fundingAmount;

                    agreement.birthdatePreCertification = agreement.birthdateStudent;
                    agreement.stateOfResidencePreCertification = agreement.stateOfResidenceStudent;

                    // TODO: fundingMax and fundingMin?
                }

                // TODO: should expectedGraduation be saved here?

                */
                /* no id is being assigned so does not make any sense for this code    
                if (agreement.certificationDraftStatus == 'Certified') {
                    // Write fields to PostCertification
                    if (isStudentInitiated) {
                        agreementToUpdate.residencyPostCertification = agreement.residencyCertification;
                        agreementToUpdate.enrollmentStatusPostCertification = agreement.enrollmentStatusCertification;
                        agreementToUpdate.gradeLevelPostCertification = agreement.gradeLevelCertification;
                        agreementToUpdate.majorIDPostCertification = agreement.majorIDCertification;
                        agreementToUpdate.fundingAmountPostCertification = agreement.fundingAmountCertification;

                        agreementToUpdate.birthdatePostCertification = agreement.birthdateCertification;
                        agreementToUpdate.stateOfResidencePostCertification = agreement.stateOfResidenceCertification;
                        agreementToUpdate.incomeSharePostCertification = agreement.incomeShareCertification;
                        agreementToUpdate.paymentTermPostCertification = agreement.paymentTermCertification;
                        agreementToUpdate.paymentCapPostCertification = agreement.paymentCapCertification;
                    } else {
                        agreementToUpdate.residencyPostCertification = agreement.residencyPreCertification;
                        agreementToUpdate.enrollmentStatusPostCertification = agreement.enrollmentStatusPreCertification;
                        agreementToUpdate.gradeLevelPostCertification = agreement.gradeLevelPreCertification;
                        agreementToUpdate.majorIDPostCertification = agreement.majorIDPreCertification;
                        //agreementToUpdate.fundingAmountPostCertification = agreement.fundingAmountPreCertification;
                        agreementToUpdate.fundingAmountPostCertification = agreement.fundingAmountStudent; // TODO: This may not be correct
                         
                        agreementToUpdate.birthdatePostCertification = agreement.birthdatePreCertification;
                        agreementToUpdate.stateOfResidencePostCertification = agreement.stateOfResidencePreCertification;

                        // TODO: fundingMax and fundingMin?
                    }
                }

                agreementsToUpdate.add(agreementToUpdate);
                */
            }

            update sps;
            //AgreementService.updateAgreement(agreementsToUpdate);
            System.debug('in CertificationController.saveAgreements done');
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getContractTerms');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
        }
    }
    
    @RemoteAction
    public static void submitPreCertified(List<ID> agreementIDs){
        try{
            System.debug('in CertificationController.submitPreCertified');
            List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(new Set<ID>(agreementIDs));
            List<StudentProgram__c> sps = new List<StudentProgram__c>();
            
            for (AgreementService.Agreement agreement : agreements){
                StudentProgram__c sp = new StudentProgram__c(Id = agreement.agreementID);
                if(agreement.certificationDraftStatus == 'Certified'){
                    sp.Status__c = 'Invited';
                    sp.PreCertified__c = true;
                    sps.add(sp);
                }
                else{
                    if(agreement.certificationDraftStatus == 'Cancelled'){
                        sp.Status__c = 'Cancelled';
                        sp.CancellationReason__c = 'Not Certified';
                        sp.Deleted__c = true;
                        sp.PreCertified__c = true;
                        sps.add(sp);
                    }
                }                            
            }
            if(sps.size()>0){
                update sps;
                System.debug('@@@'+ sps);    
            }
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.submitPreCertified');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
        }                                
    }

    @RemoteAction
    public static Boolean checkEligibility(Eligibility elig) {
        try{
            Boolean eligibilityResults = ProgramService.evaluateProgramEligibilityWithCriteria(
                (ID)elig.programID,
                elig.residency,
                elig.enrollmentStatus,
                elig.gradeLevel,
                (ID)elig.schoolProgramOfStudyID,
                elig.stateOfResidence,
                elig.age);

            return eligibilityResults;
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.checkEligibility');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return false;
        }
    }

    public class Eligibility {
        public String programID {get;set;}
        public String residency {get;set;}
        public String enrollmentStatus {get;set;}
        public String gradeLevel {get;set;}
        public String schoolProgramOfStudyID {get;set;}
        public String stateOfResidence {get;set;}
        public Integer age {get;set;}
    }

    // TODO: remove
    @RemoteAction
    public static ContractTerm getContractTerms(String agreementID) {
        ContractTerm contractTerm = null;
        /*
        try {
            System.debug('in CertificationController.getContractTerms');
            List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(new Set<ID>{agreementID});
            List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(new Set<ID>{agreements[0].programID});
            Boolean isStudentInitiated = (programs[0].enrollmentType == 'Open');
            Agreement agr = new Agreement(agreements[0], isStudentInitiated);
            System.debug('in CertificationController.getContractTerms programID: ' + agr.programID);
            System.debug('in CertificationController.getContractTerms majorID: ' + agr.majorID);
            System.debug('in CertificationController.getContractTerms gradeLevel: ' + agr.gradeLevel);

            ContractTermsService.ContractTerm term = ContractTermsService.getContractTermsWithCriteria(
                agr.programID,
                agr.majorID,
                agr.gradeLevel);

            System.debug('in CertificationController.getContractTerms got term');
            contractTerm = new ContractTerm(term);
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getContractTerms');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
        }
        */

        return contractTerm;
    }

    public class ContractTerm {
        public Decimal incomeShare {get; set;}
        public Decimal paymentCapFactor {get; set;}
        public Decimal paymentTerm {get; set;}

        public ContractTerm(ContractTermsService.ContractTerm term) {
            this.incomeShare = term.incomeShare;
            this.paymentCapFactor = term.paymentCapFactor;
            this.paymentTerm = term.paymentTerm;
        }
    }
    
    //Use Case: Gets the students by email id with the eligible programs including min/max funding and disbursement schedule 
    //for each program
    /*@DEPRECATED
    @RemoteAction
    public static Student getStudentByEmail(String studentEmail){
        try{
            List<StudentService.Student> students = StudentService.getStudentsWithEmail(new Set<String>{studentEmail});
            Student stud = null;
            if(students.size() == 1){
                //initialize student
                stud = new Student(students[0]);
                stud.offers = new List<Offer>();
                stud.enrolledPrograms = new List<Agreement>();
                
                //get eligible programs
                List<Offer> offers = getEligibleProgramsWithCriteria(stud.schoolID,
                                                        stud.citizenship, stud.enrollmentStatus, stud.gradeLevel, stud.majorID,
                                                        stud.mailingStateCode, stud.birthdate);
                if(offers <> null){
                    stud.offers.addAll(offers);
                }
                
                //get enrolled programs
                List<Agreement> enrolledPrograms = getEnrolledPrograms(stud.studentID);
                if(enrolledPrograms <> null){
                    stud.enrolledPrograms.addAll(enrolledPrograms);
                }
                
                return stud;
            }
            else{
                if(students.size() == 0){
                    System.debug('No Students found');
                    return null; 
                }
                System.debug('Multiple students found with same email');
                return null;    
            }
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getStudentByEmail');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return null;
        }
    }
    */
    
    @RemoteAction
    public static List<Student> findStudent(String searchStr,String schoolID){
        try{
            if(searchStr <> null && searchStr <> ''){
                List<Student> output = new List<Student>();
                if(searchStr.isNumeric()){ 
                    //this is SSN 
                    /*
                    String queryStr = 'Select ID,firstname,middlename,lastname,personemail,SSNTaxID__pc From Account ';
                    queryStr += 'Where PrimarySchool__pc = \''+ schoolID +'\' ';
                    queryStr += 'AND recordtype.name = \'Student\'';
                     
                    List<Account> accList = (List<Account>)Database.query(queryStr);
                    for(Account acc:accList){
                        if(acc.SSNTaxID__pc <> null && acc.SSNTaxID__pc == searchStr){
                            Student outputStudent = new Student(acc);
                            output.add(outputStudent);
                        }
                    }
                    */
                    return output;
                }
                else{
                    //this is for name and email
                    // should be moved to query class
                    String queryStr = 'Select ID,firstname,middlename,lastname,personemail,SSNTaxID__pc From Account ';
                    queryStr += 'Where ((personemail Like \'%'+searchStr+'%\') OR (name Like \'%'+searchStr+'%\')) '; 
                    queryStr += 'AND PrimarySchool__pc = \''+schoolID+'\' ';
                    queryStr += 'AND recordtype.name = \'Student\'';
                    
                    List<Account> accList = (List<Account>)Database.query(queryStr);
                    for(Account acc:accList){
                        Student outputStudent = new Student(acc);
                        output.add(outputStudent);
                    }
                    return output;
                }
                return output;
            }
            else{
                System.debug('Search String is blank');
            }
            return null;    
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.findStudent');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return null;
        }
    }
    
    //Use Case: get all enrolled programs for a students 
    @RemoteAction
    public Static Student getEnrolledProgramsWithStudent(String StudentID){
        try{
            List<StudentService.Student> students = StudentService.getStudentsWithStudentID(new Set<ID>{StudentID});
            Student stud = null;
            if(students.size() == 1){
                //initialize student
                stud = new Student(students[0]);
                //stud.offers = new List<Offer>();
                stud.enrolledPrograms = new List<Agreement>();
                
                //get eligible programs
                /*
                List<Offer> offers = getEligibleProgramsWithCriteria(stud.schoolID,
                                                        stud.citizenship, stud.enrollmentStatus, stud.gradeLevel, stud.majorID,
                                                        stud.mailingStateCode, stud.birthdate);
                if(offers <> null){
                    stud.offers.addAll(offers);
                }
                */
                //get enrolled programs
                List<Agreement> enrolledPrograms = getEnrolledPrograms(stud.studentID);
                if(enrolledPrograms <> null){
                    stud.enrolledPrograms.addAll(enrolledPrograms);
                }
                
                return stud;
            }
            else{
                if(students.size() == 0){
                    System.debug('No Students found');
                    return null; 
                }
                return null;    
            }
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getOffersAndEnrolledPrograms');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return null;
        }    
    } 
    
    //Use Case: get all Eligible program for a particular school with the provided criteria with min/max funding and disbursement schedule
    @RemoteAction
    public Static List<Offer> getEligibleProgramsWithCriteria(String schoolID, String citizenship, String enrollmentStatus, 
                                                              String gradeLevel, String majorID,
                                                              String mailingState, Date birthdate){
        try{
            List<Offer> output = new List<Offer>();
            
            String mailingStateCode = getStateCodesWithStateName(mailingState);
            System.debug('@@@mailingStateCode'+mailingStateCode);
            //Get offers
            Map<ID,OfferService.Offer> offerMap= OfferService.getEligibleOffersByProgramIDWithCriteria( schoolID,
                                                    citizenship, enrollmentStatus, gradeLevel, majorID,
                                                    mailingStateCode, birthdate);
            
            if(offerMap <> null && offerMap.size() > 0){
                //get disbursements from program
                Map<ID, List<TransactionSchedule__c>> txSchMap = TransactionScheduleQueries.getTransactionSchedulesByProgramIDWithProgramID(offerMap.keySet());    
                
                ContractTermsService.ContractTerm contractTerms = null;
                
                for(OfferService.Offer off:offerMap.values()){
                    Offer offer = new Offer(off,false);
                    
                    //this is to get the min/max funding from program
                    contractTerms = ContractTermsService.getContractTermsWithCriteria(
                        off.programID,
                        majorID,
                        gradeLevel);
                    
                    if(contractTerms != null){        
                       if(contractTerms.maximumFundingAmount != null) offer.programFundingMax = contractTerms.maximumFundingAmount;
                       if(contractTerms.minimumFundingAmount != null) offer.programFundingMin = contractTerms.minimumFundingAmount;
                    }
                    
                    //add disbursement Schedule to Offer
                    offer.disbSchedule = new List<Disbursement>();
                    if(txSchMap.containsKey(off.programID)){
                        for(TransactionSchedule__c txSch:txSchMap.get(off.programID)){
                            offer.disbSchedule.add(new Disbursement(txSch,null));    
                        }
                    }
                    output.add(offer);            
                }
            }
            return output;    
        }    
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getEligibleProgramsWithCriteria');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return null;
        }
    }
    
    //Use Case: get all Programs with Status Invite only for a school
    @RemoteAction
    public Static List<Offer> getInviteOnlyProgramsBySchool(String SchoolID){
        try{
            List<Offer> output = new List<Offer>();
            Map<Id,Program__c> programMap = ProgramQueries.getInviteOnlyProgramMapWithSchoolID(new Set<ID>{schoolID});
            if(programMap.keySet().size()>0){
                Map<ID, List<TransactionSchedule__c>> txSchMap = TransactionScheduleQueries.getTransactionSchedulesByProgramIDWithProgramID(programMap.keySet());    
                for(Program__c prog:programMap.values()){
                    if(prog.RegistrationEndDate__c >= Date.today()){
                        Offer offer = new Offer(prog);
                        //add disbursement Schedule to Offer
                        offer.disbSchedule = new List<Disbursement>();
                        if(txSchMap.containsKey(prog.ID)){
                            for(TransactionSchedule__c txSch:txSchMap.get(prog.ID)){
                                offer.disbSchedule.add(new Disbursement(txSch,null));    
                            }
                        }
                        output.add(offer);
                    }
                }
            }
            return output;            
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getInviteOnlyProgramsBySchool');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return null;
        }    
    } 
    
    //Use Case: get all enrolled programs for a student
    @RemoteAction
    public Static List<Agreement> getEnrolledPrograms(String studentID){
        try{
            List<Agreement> output = new List<Agreement>();
            if(studentID <> null){
                List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithStudentID(new Set<ID>{studentID});
                for(AgreementService.Agreement studProg:agreements){
                    Agreement agr = new Agreement();
                    agr.agreementID = studProg.agreementID;
                    agr.programName = studProg.programName;
                    agr.programID = studProg.programID;
                    agr.schoolID = studProg.schoolID;
                    agr.status = studProg.agreementStatus;
                    agr.fundingAmount = studProg.fundingAmountPostCertification;
                    agr.fundingMax = studProg.fundingMaximumPreCertification;
                    agr.fundingMin = studProg.fundingMinimumPreCertification;
                    agr.fundingAmountStudent = studProg.fundingAmountStudent;
                    agr.fundingAmountCertification = studProg.fundingAmountCertification; 
                    agr.incomeShare = studProg.incomeShareCertification;
                    agr.incomeShareStudent = studProg.incomeShareStudent;
                    agr.incomeSharePostCertification = studProg.incomeSharePostCertification;
                    output.add(agr);
                }
                return output;
                
            }
            else{
                return null;
            }
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.getEnrolledPrograms');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return null;
        }
    }
    
    //Use Case: creates a new Student and returns the ID of the created student        
    @RemoteAction
    public Static String createStudent(Student student){
        try{
            //Check if its an existing student or not
            if(student.studentID <> null){
                List<StudentService.Student> students = StudentService.getStudentsWithStudentID(new Set<ID>{student.studentID});
                if(students <> null && students.size() > 0){
                    return 'Student with this ID:'+student.studentID+' already exists';
                }
            }
            //check if a student with same email already exists
            if(student.email <> null && student.email <> ''){
                List<StudentService.Student> students = StudentService.getStudentsWithEmail(new Set<String>{student.email});            
                if(students<>null && students.size()>0){
                    return 'Student with email: '+student.email+' already exists.';
                }
            }
            else{
                return 'No email defined for student.';
            } 
                
            StudentService.Student stud = new StudentService.Student();
            stud.primarySchoolID = student.schoolID;
            stud.firstName = student.firstName;
            stud.middleName = student.middleName;
            stud.lastName = student.lastName;
            stud.email = student.email;
            stud.birthdate = student.birthdate;
            stud.ssnTaxID = student.SSN;
            stud.primarySchoolEnrollmentStatus = student.enrollmentStatus;
            stud.primarySchoolGradeLevel = student.gradeLevel;
            stud.primarySchoolGraduationDate = student.graduationDate;
            stud.schoolProgramOfStudyID = student.majorID;
            stud.residency = student.citizenship;
            stud.mobilePhone = student.mobilePhone;
            stud.mailingState = student.mailingState;
            //insert student
            Set<ID> createdStudentsIdSet = StudentService.createStudents(new List<StudentService.Student>{stud});
            //query the student from the database
            if(createdStudentsIdSet <> null && createdStudentsIdSet.size()==1){
                String studentID = new List<ID>(createdStudentsIdSet)[0];
                return studentID;
            }
            else{
                return 'Error creating Student.';
            }
            return null;
            
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.createStudent');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return 'Error creating Student.';
        }    
    }
     
    @RemoteAction
    public Static String createAgreement(Student student,String programID,Decimal fundingMin,Decimal fundingMax,List<Disbursement> disbSchedule){
        try{
            //Check if its an existing student or not
            StudentService.Student stud = null;
            String enrollmentStatus = null;
            String gradeLevel = null;
            String majorID = null;
            
            if(student.enrollmentStatus <> null) enrollmentStatus = student.enrollmentStatus; 
            if(student.gradeLevel <> null) gradeLevel  = student.gradeLevel;
            if(student.majorID <> null) majorID = student.majorID;
            
            if(student.studentID <> null){
                List<StudentService.Student> students = StudentService.getStudentsWithStudentID(new Set<ID>{student.studentID});
                if(students.size() == 1){
                    stud = students[0];
                }
                else{
                    return 'Student does not exist. Please create the student first.';
                }    
            }
            else{
                return 'Student does not exist. Please create the student first.';
            }
            
                        
            //check if program exist or not
            List<ProgramService.Program> programs = ProgramService.getProgramsWithProgramID(new Set<ID>{programID});
            if(programs.size() == 1){
                           
                List<AgreementService.Agreement> agrToInsert = new List<AgreementService.Agreement>();
                
                AgreementService.Agreement agr = new AgreementService.Agreement();
                agr.studentID = stud.personAccountID;
                agr.programID = programs[0].programID ;
                agr.schoolID = programs[0].schoolID;
                if(stud.birthdate <> null) {
                  agr.birthdatePreCertification = stud.birthdate;                
                }
                agr.majorIDPreCertification = majorID;
                agr.gradeLevelPreCertification = gradeLevel;
                agr.enrollmentStatusPreCertification = enrollmentStatus;
                agr.stateOfResidencePreCertification = stud.mailingStateCode;
                agr.residencyPreCertification = stud.residency;
                agr.fundingMaximumPreCertification = fundingMax;
                agr.fundingMinimumPreCertification = fundingMin;
                agr.agreementStatus = 'Draft';
                agrToInsert.add(agr);
                
                Set<ID> agrIds = AgreementService.createAgreement(agrToInsert);
                if(agrIds.size()==1){
                    Id agreementID = new List<ID>(agrIds)[0];
                    
                    //now create disbursments
                    List<TransactionService.Disbursement> disbursementsToCreate = new List<TransactionService.Disbursement>();

                    for (Disbursement disb : disbSchedule){
                        TransactionService.Disbursement disbursement = new TransactionService.Disbursement();
                        Date disbDate = Date.newInstance(disb.disbursementDate.yearGmt(), disb.disbursementDate.monthGmt(), disb.disbursementDate.dayGmt());
                        disbursement.studentID = stud.personAccountID;
                        disbursement.agreementID = agreementID;
                        disbursement.transactionDate = disbDate;
                        disbursement.status = 'Scheduled';
                        disbursement.disbursementPercentage = disb.disbursementPercentage;
                        disbursement.relatedScheduleID = disb.relatedScheduleID; 
                        disbursement.specialDisbursementType = disb.specialDisbursementType;
                        disbursement.amount = disb.disbursementAmount;
                        disbursementsToCreate.add(disbursement);
                        
                    }
                    TransactionService.createDisbursements(disbursementsToCreate);
                    return agreementID;
                }
                else{
                    System.debug('Error creating Agreement');
                    return 'Error creating Agreement';
                }                                                       
            }
            else{
                System.debug('No program found');
                return 'No program found';
            }
            
        }
        catch(Exception e){
            System.debug('Exception thrown by CertificationController.createAgreement');
            System.debug('Exception = ' + e.getMessage());
            System.debug('Stack Traace = ' + e.getStackTraceString());
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'There was an error');
            ApexPages.addMessage(msg);
            return 'Error creating Agreement';
        }
    }
    
    //Use case: get state code corresponding to state name
    public Static String getStateCodesWithStateName(String stateName){
        Schema.DescribeFieldResult fieldResult = User.statecode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple){
            if(f.getLabel() == stateName){
                return f.getValue();
            }
        }
        return '';
    }
}