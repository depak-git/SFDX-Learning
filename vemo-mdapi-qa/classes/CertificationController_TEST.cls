@isTest
public class CertificationController_TEST{
    
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        //create students
        Map<Id,Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(2);
        //create Programs with school
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(3,TestDataFactory.createAndInsertSchoolCustomerAccounts(2));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        integer cnt = 0;
        for(Account acc:studentMap.values()){
            if(cnt<3){
                acc.PrimarySchool__pc = schoolMap.values()[0].id;
            }
            else{
                acc.PrimarySchool__pc = schoolMap.values()[1].id;
            }    
        }
        update studentMap.values();
               
        Map<ID, ProgramEligibility__c> eligibilityMap = TestDataFactory.createAndInsertProgramEligibility(2,programMap);
        Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(2);
        Map<ID, SchoolProgramsOfStudy__c> sposMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schoolMap, posMap);
        
        Map<ID, ContractTerm__c> termMap = TestDataFactory.createAndInsertContractTerms(1,programMap);
        Map<ID, TransactionSchedule__c> txSchMap = TestDataFactory.createAndInsertTransactionSchedule(2, programMap);
        Map<ID, IncomeBand__c> bandMap = TestDataFactory.createAndInsertIncomeBands(1, sposMap);
         
        //this will create 3 SP for each student
        for(Account acc:studentMap.values()){
            TestDataFactory.createAndInsertStudentProgram(1,new Map<ID,Account>{acc.id => acc},
                                                          ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{acc.PrimarySchool__pc}));
        }
        
        for(ContractTerm__c ct:termMap.values()){
            ct.MinimumFundingAmount__c = 1000;
        }       
        update termMap.values();                  
    }
    
    @isTest
    public static void testFindStudents(){
        
            Account acc = [Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1];
            acc.personemail = 'test.student.1@test.com';
            update acc;
            Test.startTest();
            // this is the correct case
            List<CertificationController.Student> students = new List<CertificationController.Student>(); 
            students = CertificationController.findStudent('test.student.1@test.com',acc.PrimarySchool__pc);
            System.assertEquals(1,students.size(),'No record found or Email does not match');
            
            //passing a blank search string
            students = CertificationController.findStudent(null,acc.PrimarySchool__pc);
            System.assert(students == null,'Error');
            Test.stopTest();
        
    }
    
   @isTest public static void testGetEligibleProgramsWithCriteria(){
        //Test Case - All 'Invite Only' Offers for a particular school should be returned after chechking the Eligibilty against the given criteria 
        //Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMapWithSchoolID(schoolMap.keySet());
        Map<ID, ProgramEligibility__c> eligibilityMap = ProgramEligibilityQueries.getProgramEligibilityMap();
        Map<Id, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(schoolMap.keySet());
        
        //Account student = studentMap.values()[0];
        Program__c prg = programMap.values()[0];
        SchoolProgramsOfStudy__c spos = sposMap.values()[0];
        ProgramEligibility__c eligibility = null;
        //find 1 eligibilty record for the selected program 
        for(ProgramEligibility__c elig:eligibilityMap.values()){
            if(elig.program__c == prg.id){
                eligibility = elig;
                break;
            }
        }
        
        //set required eligibity field on program
        prg.EnrollmentType__c = 'Invite Only';
        prg.ProgramStatus__c = 'Open';
        prg.EnrollmentBeginDate__c = Date.Today().addDays(-1);
        prg.EnrollmentEndDate__c = Date.Today().addDays(1);
        prg.RegistrationBeginDate__c = Date.Today().addDays(-1);
        prg.RegistrationEndDate__c = Date.Today().addDays(1);
        prg.GradeLevelRequired__c = true;
        prg.SchoolProgramOfStudyRequired__c = true;
        prg.ResidencyRequired__c = true;
        prg.EnrollmentStatusRequired__c = true;
        prg.AgeOfMajorityRequired__c = true;
        update prg;
        
        //set eligility record
        eligibility.EnrollmentStatus__c = 'Full Time';
        eligibility.GradeLevel__c = 'Senior';
        eligibility.Residency__c = 'US Citizen';
        eligibility.SchoolProgramOfStudy__c = spos.id;
        update eligibility;
        
        Test.startTest();        
        List<CertificationController.Offer> resultMap = CertificationController.getEligibleProgramsWithCriteria(prg.School__c,'US Citizen',
                                                    'Full Time','Senior',spos.id,'Colorado',Date.newInstance(1991,1,1));
        System.assertEquals(1,resultMap.size());
        Test.stopTest();
    }
    
    @isTest
    public static void testGetInviteOnlyProgramsBySchool(){
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{schoolMap.values()[0].id});
        Program__c prg = programMap.values()[0];
        prg.EnrollmentType__c = 'Invite Only';
        prg.ProgramStatus__c = 'Open';
        prg.EnrollmentBeginDate__c = Date.Today().addDays(-1);
        prg.EnrollmentEndDate__c = Date.Today().addDays(1);
        prg.RegistrationBeginDate__c = Date.Today().addDays(-1);
        prg.RegistrationEndDate__c = Date.Today().addDays(1);
        update prg;
        
        Test.StartTest();
        CertificationController.getInviteOnlyProgramsBySchool(schoolMap.values()[0].id);    
        Test.StopTest();    
    }
    
    @isTest
    public static void testGetOffersAndEnrolledPrograms(){
        Map<ID,Account> schoolMap = AccountQueries.getSchoolMap();
        Map<ID,Account> studentMap = new Map<ID,Account>([Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1]);
        //Map<ID,Program__c> progMap = ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{studentMap.values()[0].PrimarySchool__pc});
        //Map<ID, StudentProgram__c> studPrgMap = TestDataFactory.createAndInsertStudentProgram(1,studentMap,progMap);    
        
        //studentMap.values()[0].personEmail = 'vemo@test.com';
        //update studentMap.values();
        
        Test.startTest();
        //pass a valid student ID
        CertificationController.Student stud = CertificationController.getEnrolledProgramsWithStudent(studentMap.values()[0].id);
        
        //pass a Invalid ID
        stud = CertificationController.getEnrolledProgramsWithStudent('test');
        
        //pass a wrong Id
        stud = CertificationController.getEnrolledProgramsWithStudent(schoolMap.values()[0].id);
        Test.stopTest();
        
    }
    
    @isTest
    public static void testCreateStudentAndCreateAgreement(){
        Map<ID,Account> schoolMap = AccountQueries.getSchoolMap();
        Map<ID,Program__c> progMap = ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{schoolMap.values()[0].ID});
        Map<Id,SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(new Set<ID>{schoolMap.values()[0].ID});
        Map<ID,TransactionSchedule__c> txSchMap = TransactionScheduleQueries.getTransactionScheduleMapWithProgramID(new Set<ID>{progMap.values()[0].ID});
        
        CertificationController.Student stud = new CertificationController.student();
        stud.firstname = 'Smith';
        stud.lastname = 'Test';
        stud.email = 'vemo@test.com';
        stud.enrollmentStatus = 'Full Time';
        stud.gradeLevel = 'Senior';
        stud.majorID = sposMap.values()[0].ID;
        stud.schoolID = sposMap.values()[0].school__c;
        
        Test.startTest();
        //create with valid parameters
        String studentID = CertificationController.createStudent(stud);
        
        //pass a already existing student with ID   
        stud.studentID = studentID;
        CertificationController.createStudent(stud);
        
        //pass an email which already exists
        stud.studentID = null;
        CertificationController.createStudent(stud);
        
        //populate disbursement wrapper
        List<CertificationController.Disbursement> disList = new List<CertificationController.Disbursement>();
        for(TransactionSchedule__c txSch :txSchMap.values()){
            CertificationController.Disbursement dis = new CertificationController.Disbursement(txSch,null);
            disList.add(dis);
        }
        
        //create an Agreement with student which is not yet inserted in DB
        CertificationController.createAgreement(stud,progMap.values()[0].ID,500,1000,disList);
        
        //create an Agreement with valid student
        stud.studentID = studentID;
        CertificationController.createAgreement(stud,progMap.values()[0].ID,500,1000,disList);
        
        //create an exception
        CertificationController.createStudent(null);
        CertificationController.createAgreement(null,progMap.values()[0].ID,500,1000,disList);
        Test.stopTest();
    }
    
    @isTest
    public Static void testGetMajorOptions(){
        Map<ID,Account> schoolMap = AccountQueries.getSchoolMap();
        CertificationController.getMajorOptions(schoolMap.values()[0].ID);
    }
    
    @isTest
    public Static void testGetNotCertifiedReasonOptions(){
        CertificationController.getNotCertifiedReasonOptions('test');
    }
    
    @isTest
    public Static void testGetGradeLevelOptions(){
        CertificationController.getGradeLevelOptions('test');
    }
    
    @isTest
    public Static void testGetEnrollmentOptions(){
        CertificationController.getEnrollmentOptions('test');
    }
    
    @isTest
    public Static void testGetCitizenshipOptions(){
        CertificationController.getCitizenshipOptions('test');
    }
    
    @isTest
    public static void testGetAgreements(){
        Map<ID,Account> studentMap = new Map<ID,Account>([Select id,personEmail,PrimarySchool__pc From Account Where recordType.developerName = 'Student' Limit 1]);
        Map<ID,Program__c> progMap = ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{studentMap.values()[0].PrimarySchool__pc});
        Map<ID,StudentProgram__c> studPrgMap = StudentProgramQueries.getStudentProgramMapWithStudentID(new Set<ID>{studentMap.values()[0].id});
        Integer cnt=0;
        for(Program__c prog:progMap.values()){
            if(cnt<1){
                prog.programStatus__c = 'Open';
                prog.enrollmentType__c = 'Open';
            }
            else{
                prog.programStatus__c = 'Open';
                prog.enrollmentType__c = 'Invite Only';
            }
            cnt++;
        }
        update progMap.values();
        
        Test.StartTest();
        //call in post certification mode
        CertificationController.getAgreements(studentMap.values()[0].PrimarySchool__pc,'postCert');
        
        for(StudentProgram__c sp:studPrgMap.values()){
            sp.Status__c = 'Draft';
            sp.preCertified__c = false;
        }
        update studPrgMap.values(); 
        //call in pre certification mode
        CertificationController.getAgreements(studentMap.values()[0].PrimarySchool__pc,'preCert');
        
        Test.StopTest(); 
    }
    
    @isTest
    public Static void testGetAndUpdateAgreementStudentInitiated(){
        Map<ID,Account> schoolMap = AccountQueries.getSchoolMap();
        Map<ID,Program__c> progMap = ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{schoolMap.values()[0].id});
        Map<Id, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(new Set<ID>{schoolMap.values()[0].id});
        Integer cnt=0;
        for(Program__c prog:progMap.values()){
            if(cnt<1){
                prog.programStatus__c = 'Open';
                prog.enrollmentType__c = 'Open';
            }
            else{
                prog.programStatus__c = 'Open';
                prog.enrollmentType__c = 'Invite Only';
            }
            cnt++;
        }
        update progMap.values();
        
        Test.StartTest();
        for(Program__c prog:progMap.values()){
            if(prog.enrollmentType__c == 'Open'){
                Map<ID, StudentProgram__c> studProgMap = StudentProgramQueries.getStudentProgramMapWithProgramID(new Set<ID>{prog.id});
                StudentProgram__c sp = studProgMap.values()[0];
                sp.ExpectedGraduationDate__c = Date.today().addDays(90);
                sp.BirthdateStudent__c = Date.Today().addYears(-10);
                sp.MajorStudent__c = sposMap.values()[0].id;
                sp.GradeLevelStudent__c = 'Senior';
                sp.ResidencyCertification__c = 'US Citizen';
                sp.EnrollmentStatusCertification__c = 'Full Time';
                sp.GradeLevelCertification__c = 'Senior';
                sp.MajorCertification__c = sposMap.values()[0].id;
                sp.FundingAmountCertification__c = 3000;
                sp.IncomeShareCertification__c = 2.5;
                sp.PaymentTermCertification__c = 24;
                sp.PaymentCapCertification__c = 1000;
                update sp;
                TestDataFactory.createAndInsertTransactions(1,new Map<ID,StudentProgram__c>{sp.id => sp},'Disbursement');
                
                //funding amount in range
                CertificationController.Agreement agr =  CertificationController.getAgreement(sp.id);
                CertificationController.updateAgreement(agr);

                /*    
                //funding amount too less
                agr.FundingAmount = 500;
                CertificationController.updateAgreement(agr);
                agr =  CertificationController.getAgreement(sp.id);

                //funding amount too high
                agr.FundingAmount = 35000;
                CertificationController.updateAgreement(agr);
                agr =  CertificationController.getAgreement(sp.id);
                
                //funding amount in range
                agr.FundingAmount = 30000;
                */        
                break;
            }
        }
        Test.stopTest();
    }
    
    @isTest
    public Static void testGetAndUpdateAgreementSchoolInitiated(){
        Map<ID,Account> schoolMap = AccountQueries.getSchoolMap();
        Map<ID,Program__c> progMap = ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{schoolMap.values()[0].id});
        Map<Id, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(new Set<ID>{schoolMap.values()[0].id});
        Integer cnt=0;
        for(Program__c prog:progMap.values()){
            if(cnt<1){
                prog.programStatus__c = 'Open';
                prog.enrollmentType__c = 'Open';
            }
            else{
                prog.programStatus__c = 'Open';
                prog.enrollmentType__c = 'Invite Only';
            }
            cnt++;
        }
        update progMap.values();
        
        Test.StartTest();
        for(Program__c prog:progMap.values()){
            if(prog.enrollmentType__c == 'Invite Only'){
                Map<ID, StudentProgram__c> studProgMap = StudentProgramQueries.getStudentProgramMapWithProgramID(new Set<ID>{prog.id});
                StudentProgram__c sp = studProgMap.values()[0];
                sp.ExpectedGraduationDate__c = Date.today().addDays(90);
                sp.MajorStudent__c = sposMap.values()[0].id;
                sp.GradeLevelStudent__c = 'Senior';
                sp.FundingMaximumPreCertification__c = 2000;
                sp.FundingMinimumPreCertification__c = 1000;
                sp.BirthdatePreCertification__c = Date.Today().addYears(-20);
                sp.ResidencyPreCertification__c = 'US Citizen';
                sp.StateOfResidencePreCertification__c = 'CO';
                sp.EnrollmentStatusPreCertification__c = 'Full Time'; 
                sp.GradeLevelPreCertification__c = 'Senior';
                sp.MajorPreCertification__c = sposMap.values()[0].id;
                update sp;
                TestDataFactory.createAndInsertTransactions(2,new Map<ID,StudentProgram__c>{sp.id => sp},'Disbursement');
                CertificationController.Agreement agr = CertificationController.getAgreement(sp.id);
                agr.disbursements[0].disbursementID = null;
                CertificationController.updateAgreement(agr);
                break;
            }    
        }
        Test.stopTest();               
    }    
    
    @isTest
    public static void testSaveAgreement(){
        Map<ID, StudentProgram__c> studProgMap = StudentProgramQueries.getStudentProgramMap();
        List<StudentProgram__c> toUpdateList = new List<StudentProgram__c>();
        List<ID> toSaveList = new List<ID>();
        integer cnt = 0;
        for(StudentProgram__c sp:studProgMap.values()){
            if(cnt == 0){
                sp.CertificationDraftStatus__c = 'Certified';
                toUpdateList.add(sp);
                toSaveList.add(sp.id);
                cnt++;
                continue;
            }
            if(cnt == 1){
                sp.CertificationDraftStatus__c = 'Cancelled';
                toUpdateList.add(sp);
                toSaveList.add(sp.id);
                break;
            }    
        }
        
        Test.startTest();
        update toUpdateList;
        //this id the correct  
        CertificationController.saveAgreements(toSaveList);
        
        //create an exception
        certificationController.saveAgreements(null);
        Test.StopTest();
    }
    
    @isTest
    public static void testSubmitPreCertified(){
        Map<ID, StudentProgram__c> studProgMap = StudentProgramQueries.getStudentProgramMap();
        List<StudentProgram__c> toUpdateList = new List<StudentProgram__c>();
        List<ID> toSaveList = new List<ID>();
        integer cnt = 0;
        for(StudentProgram__c sp:studProgMap.values()){
            if(cnt == 0){
                sp.CertificationDraftStatus__c = 'Certified';
                toUpdateList.add(sp);
                toSaveList.add(sp.id);
                cnt++;
                continue;
            }
            if(cnt == 1){
                sp.CertificationDraftStatus__c = 'Cancelled';
                toUpdateList.add(sp);
                toSaveList.add(sp.id);
                break;
            }    
        }
        
        Test.startTest();
        update toUpdateList;
        //this is correct
        CertificationController.submitPreCertified(toSaveList);
        //create an exception
        CertificationController.submitPreCertified(null);
        Test.StopTest();
    }
    
    @isTest
    public static void testCheckEligibilty(){
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMapWithSchoolID(schoolMap.keySet());
        Map<ID, ProgramEligibility__c> eligibilityMap = ProgramEligibilityQueries.getProgramEligibilityMap();
        Map<Id, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(schoolMap.keySet());
        
        //Account student = studentMap.values()[0];
        Program__c prg = programMap.values()[0];
        SchoolProgramsOfStudy__c spos = sposMap.values()[0];
        ProgramEligibility__c eligibility = null;
        //find 1 eligibilty record for the selected program 
        for(ProgramEligibility__c elig:eligibilityMap.values()){
            if(elig.program__c == prg.id){
                eligibility = elig;
                break;
            }
        }
        
        //set required eligibity field on program
        prg.EnrollmentType__c = 'Invite Only';
        prg.ProgramStatus__c = 'Open';
        prg.EnrollmentBeginDate__c = Date.Today().addDays(-1);
        prg.EnrollmentEndDate__c = Date.Today().addDays(1);
        prg.RegistrationBeginDate__c = Date.Today().addDays(-1);
        prg.RegistrationEndDate__c = Date.Today().addDays(1);
        prg.GradeLevelRequired__c = true;
        prg.SchoolProgramOfStudyRequired__c = true;
        prg.ResidencyRequired__c = true;
        prg.EnrollmentStatusRequired__c = true;
        prg.AgeOfMajorityRequired__c = true;
        update prg;
        
        //set eligility record
        eligibility.EnrollmentStatus__c = 'Full Time';
        eligibility.GradeLevel__c = 'Senior';
        eligibility.Residency__c = 'US Citizen';
        eligibility.SchoolProgramOfStudy__c = spos.id;
        update eligibility;

        CertificationController.Eligibility elig= new CertificationController.Eligibility();
        elig.programID = prg.id;  
        elig.residency = 'US Citizen';
        elig.enrollmentStatus = 'Full Time';
        elig.gradeLevel = 'Senior';
        elig.schoolProgramOfStudyID = spos.id;
        elig.stateOfResidence = 'Colorado'; 
        elig.age = 25;
            
        Test.startTest(); 
            System.assertEquals(true,CertificationController.checkEligibility(elig),'Error');
            //run into exception
            CertificationController.checkEligibility(null);
        Test.stopTest();

    }
    
    @isTest()
    public static void testLoadUser(){
        /*
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<ID, Contact> contactMap = TestDataFactory.createAndInsertContacts(1,schoolMap);
        User u = TestUtil.createUser('8.0 - College Admin Default');
        u.contactID = contactMap.values()[0].id;
        u.username = 'testcertcntrl@test.com';
        insert u;
        System.RunAs(u){
            CertificationController.loadUser('test');
        }
        */
        //vemo users
        CertificationController.loadUser('test');
        
    }
    
    @isTest
    public static void validateContractTerm(){
        Map<ID,Account> schoolMap = AccountQueries.getSchoolMap();
        Map<ID,Program__c> progMap = ProgramQueries.getProgramMapWithSchoolID(new Set<ID>{schoolMap.values()[0].id});
        Map<Id, SchoolProgramsOfStudy__c> sposMap = SchoolProgramsOfStudyQueries.getSchoolProgramOfStudyMapWithSchoolID(new Set<ID>{schoolMap.values()[0].id});
        ContractTermsService.ContractTerm ct = ContractTermsService.getContractTermsWithCriteria(progMap.values()[0].id,sposMap.values()[0].id,'Senior');    
        Test.startTest();
        CertificationController.getContractTerms('test');
        CertificationController.ContractTerm cntrlCT = new CertificationController.ContractTerm(ct); 
        Test.stopTest();
    }
    
    @isTest
    public static void validateGetStateCodesWithStateName(){
        Test.startTest();
        String code = CertificationController.getStateCodesWithStateName('Indiana');
        //System.assertEquals('IN',code,'Error: Should be a IN');
        code = CertificationController.getStateCodesWithStateName(null);
        System.assertEquals('',code,'Error: Should be a blank String');
        Test.stopTest();
    }
       
    
}