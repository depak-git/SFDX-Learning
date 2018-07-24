@isTest
public with sharing class OfferService_TEST {
    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<ID, Account> studentMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(TestUtil.TEST_THROTTLE, 
                                                                                    TestDataFactory.createAndInsertSchoolCustomerAccounts(1));
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        for(Account stud : studentMap.values()){
            stud.PrimarySchool__pc = schoolMap.values()[0].id;
        }
        update studentMap.values();
        Map<ID, ProgramEligibility__c> eligibilityMap = TestDataFactory.createAndInsertProgramEligibility(2,programMap);
        Map<ID, ProgramOfStudy__c> posMap = TestDataFactory.createAndInsertProgramOfStudy(2);
        Map<ID, SchoolProgramsOfStudy__c> sposMap = TestDataFactory.createAndInsertSchoolProgramsOfStudy(schoolMap, posMap);
        
        //Map<ID, ContractTerm__c> termMap = TestDataFactory.createAndInsertContractTerms(2,programMap);
        //Map<ID, TransactionSchedule__c> txSchMap = TestDataFactory.createAndInsertTransactionSchedule(2, programMap);
        //Map<ID, IncomeBand__c> bandMap = TestDataFactory.createAndInsertIncomeBands(1, sposMap);

    }
    @isTest public static void testOpenOffers() {
        //Test Case 1 - Any program with an enrollment type of open should appear in the list
        System.assertEquals(ProgramQueries.getProgramMap().size(), TestUtil.TEST_THROTTLE);
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMap();
        for(Program__c prog : programMap.values()){
            prog.EnrollmentType__c = 'Invite Only';
        }
        update programMap.values();
        Test.startTest();
        Map<ID, List<OfferService.Offer>> offersBefore = OfferService.getOffersByStudentIDWithStudentMap(studentMap);
        System.assertEquals(offersBefore.size(), 0, 'No Offers should exist');

        for(Program__c prog : programMap.values()){
            prog.EnrollmentType__c = 'Open';
        }
        update programMap.values();
        Map<ID, List<OfferService.Offer>> offersAfter = OfferService.getOffersByStudentIDWithStudentMap(studentMap);
        Test.stopTest();
        //todo System.assertEquals(offersAfter.size(), TestUtil.TEST_THROTTLE, 'Offers should exist');      
        
    }

    @isTest public static void testInvitedAgreements(){
        //Test Case - Any StudentProgram__c with a Status of Invited should appear in the list
        System.assertEquals(ProgramQueries.getProgramMap().size(), TestUtil.TEST_THROTTLE);
        Map<ID, Account> studentMap = AccountQueries.getStudentMap();
        Map<ID, Account> schoolMap = AccountQueries.getSchoolMap();
        Map<Id, Program__c> programMap = ProgramQueries.getProgramMap();
        Map<ID, StudentProgram__c> agreementMap = TestDataFactory.createAndInsertStudentProgram(TestUtil.TEST_THROTTLE, 
                                                                                                studentMap, 
                                                                                                programMap);
        for(StudentProgram__c agreement : agreementMap.values()){
            agreement.Status__c = 'Application Complete';
        }                                   
        update agreementMap.values();

        Test.startTest();
        Map<ID, List<OfferService.Offer>> offersBefore = OfferService.getOffersByStudentIDWithStudentMap(studentMap);
        System.assertEquals(offersBefore.size(), 0, 'No Offers should exist');

        for(StudentProgram__c agreement : agreementMap.values()){
            agreement.Status__c = 'Invited';
        }
        update agreementMap.values();
        Map<ID, List<OfferService.Offer>> offersAfter = OfferService.getOffersByStudentIDWithStudentMap(studentMap);
        Test.stopTest();
        //todo System.assertEquals(offersAfter.size(), TestUtil.TEST_THROTTLE, 'Offers should exist');      
        

    }
    
    @isTest public static void testEligibleOffersWithCriteria(){
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
        Map<ID,OfferService.Offer> resultMap = OfferService.getEligibleOffersByProgramIDWithCriteria(prg.School__c,'US Citizen',
                                                    'Full Time','Senior',spos.id,'CO',Date.newInstance(1991,1,1));
        System.assertEquals(1,resultMap.size());
        Test.stopTest();
    }
}