/////////////////////////////////////////////////////////////////////////
// Class: OfferService
// 
// Description: 
//  Handles all Offer virtual functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-25   Greg Cook       Created                     
/////////////////////////////////////////////////////////////////////////
public with sharing class OfferService {
    public static Map<ID, List<OfferService.Offer>> getOffersByStudentIDWithStudentMap(Map<ID, Account> studentMap){
        System.debug('OfferService.getOffersByStudentIDWithStudentMap');
        Map<ID, List<OfferService.Offer>> offersByStudentID = new Map<ID, List<OfferService.Offer>>();

        //Get the schools for these students
        Set<ID> schoolIDs = new Set<ID>();
        for(Account stud : studentMap.values()){
            schoolIDs.add(stud.PrimarySchool__pc);
        }
        system.debug('schoolIDs:'+schoolIDs);
        system.debug('studentMap:'+studentMap);
        Map<Id, Program__c> programMap = ProgramQueries.getOpenProgramMapWithSchoolID(schoolIDs);
        system.debug('1');
        Map<ID, StudentProgram__c> invitationMap = StudentProgramQueries.getInvitedStudentProgramMapWithStudentID(studentMap.keyset());
        system.debug('2');
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithStudentID(studentMap.keySet());
        system.debug('3');
        system.debug('programMap:'+programMap);
        system.debug('invitationMap:'+invitationMap);
        system.debug('agreementMap:'+agreementMap);
        
        //Sort the programs by school
        Map<ID, List<Program__c>> programsBySchoolID = new Map<ID, List<Program__c>>();
        if(programMap.size()>0){
            for(Program__c prog : programMap.values()){
                if(!programsBySchoolID.containsKey(prog.School__c)){
                    programsBySchoolID.put(prog.School__c, new List<Program__c>());
                }
                programsBySchoolID.get(prog.School__c).add(prog);
            }
        }
        system.debug('programsBySchoolID:'+programsBySchoolID);
        
        //Sort the invitations by studentID
        Map<ID, List<StudentProgram__c>> invitationsByStudentID = new Map<ID, List<StudentProgram__c>>();
        if(invitationMap.size()>0){
            for(StudentProgram__c agreement : invitationMap.values()){
                if(!invitationsByStudentID.containsKey(agreement.Student__c)){
                    invitationsByStudentID.put(agreement.Student__c, new List<StudentProgram__c>());
                }
                invitationsByStudentID.get(agreement.Student__c).add(agreement);
            }
        }
        system.debug('invitationsByStudentID:'+invitationsByStudentID);

        //Sort the agreements by studentID
        Map<ID, List<StudentProgram__c>> agreementsByStudentID = new Map<ID, List<StudentProgram__c>>();
        if(agreementMap.size()>0){
            for(StudentProgram__c agreement : agreementMap.values()){
                if(!agreementsByStudentID.containsKey(agreement.Student__c)){
                    agreementsByStudentID.put(agreement.Student__c, new List<StudentProgram__c>());
                }
                agreementsByStudentID.get(agreement.Student__c).add(agreement);
            }
        }
        system.debug('agreementsByStudentID:'+agreementsByStudentID);       

        //loop back through students
        for(Account acct : studentMap.values()){
            system.debug('acct:'+acct);
            if(programsBySchoolID.containsKey(acct.PrimarySchool__pc)){
                //return the appropriate list of offers for that students school
                for(Program__c prog : programsBySchoolID.get(acct.PrimarySchool__pc)){
                    //filter out legacy programs
                    //changing to registration date range
//                  if(prog.EnrollmentEndDate__c >= Date.today()){
                    if(prog.RegistrationBeginDate__c <= Date.today() && prog.RegistrationEndDate__c >= Date.today()){
                            

                        system.debug('prog:'+prog);
                        Boolean foundExistingProgram = false;
                        //Loop through the student's existing agreements and make sure they don't already have one for this programID
                        /*as per Jira 886 Don't Assume and Don't filter out
                        if(agreementsByStudentID.containsKey(acct.id)){
                            system.debug('1');
                            for(StudentProgram__c agreement : agreementsByStudentID.get(acct.id)){
                                system.debug('agreement:'+agreement);
                                if(agreement.Program__c == prog.id){
                                    foundExistingProgram = true;
                                    continue; //break out of the for loop
                                }
                            }                   
                        }
                        */

                        if(!foundExistingProgram){
                            if(!offersByStudentID.containsKey(acct.id)){
                                offersByStudentID.put(acct.id, new List<Offer>());
                            }

                            Offer off = new Offer(prog, null);
                            off.studentID = acct.id;
                            offersByStudentID.get(acct.id).add(off);                        
                        }
                    }
                }
            }
            if(invitationsByStudentID.containsKey(acct.id)){
                //return the appropriate list of invitations for that student
                for(StudentProgram__c agreement : invitationsByStudentID.get(acct.id)){
                    //filter out legacy enrollments
                    if(agreement.Program__r.EnrollmentEndDate__c >= Date.today()){
                        if(!offersByStudentID.containsKey(acct.id)){
                            offersByStudentID.put(acct.id, new List<Offer>());
                        }
                        Offer off = new Offer(null, agreement);
                        offersByStudentID.get(acct.id).add(off);
                    }
                }               
            }
        }
        system.debug('offersByStudentID:'+offersByStudentID);

        return offersByStudentID;
    }
    
    //method to get offers after checking the eligibilty for the school initited flow for a particular school
    public static Map<ID,Offer> getEligibleOffersByProgramIDWithCriteria(ID schoolID,String residency,
                         String enrollmentStatus, String gradeLevel,
                         ID schoolProgramOfStudyID, String state, Date birthdate){
        
        Map<ID,Offer> output = new Map<ID,Offer>();
        
        /* Was using this while getting for a existing student
        
        List<StudentService.Student> students = StudentService.getStudentsWithStudentID(new Set<ID>{studentID});
        StudentService.Student student = null;
        
        if(students.size() == 1) student = students[0];
        else return null; //no student found. Cannot proceed!!! 
                
        if(student.primarySchoolID <> null) DatabaseUtil.schoolID = student.primarySchoolID;    
        else return null; // no school found on student. cannot proceed!!!
        */
        
        if(schoolID <> null){
            DatabaseUtil.schoolID = schoolID;
                    
            //get all programs for the required School whose enrollmentStatus = "invite only" and status = "open"
            Map<ID, Program__c> inviteOnlyPrgMap = ProgramQueries.getInviteOnlyProgramMapWithSchoolID(new Set<ID>{schoolID});
            
            //filter the inviteOnlyPrgMap after checking registration end date
            if(inviteOnlyPrgMap <> null && inviteOnlyPrgMap.size()>0){
                List<Program__c> tempList = inviteOnlyPrgMap.values(); 
                inviteOnlyPrgMap = new Map<ID, Program__c>();
                for(Program__c prg:tempList){
                    if(prg.RegistrationEndDate__c >= Date.today()) inviteOnlyPrgMap.put(prg.id,prg);
                }
            }
            
            //get all eligibilityRecords for the required school
            Map<ID, ProgramEligibility__c> prgprgEligibilityMap = ProgramEligibilityQueries.getProgramEligibilityMap();
            Program__c program = null;
             
            for(ProgramEligibility__c prgEligibility: prgprgEligibilityMap.values()){
                
                //check eligibilty only for programs contained in inviteOnlyPrgMap
                
                if(inviteOnlyPrgMap.containsKey(prgEligibility.program__c)){
                    program = inviteOnlyPrgMap.get(prgEligibility.program__c);
                    if(program.ResidencyRequired__c){
                        if(prgEligibility.Residency__c == null || residency == null) continue;
                        if(!prgEligibility.Residency__c.contains(residency)) continue; 
                    }
                    if(program.EnrollmentStatusRequired__c){
                        if(prgEligibility.EnrollmentStatus__c == null || enrollmentStatus == null) continue;
                        if(!prgEligibility.EnrollmentStatus__c.contains(enrollmentStatus)) continue;
                    }
                    if(program.GradeLevelRequired__c){
                        if(prgEligibility.GradeLevel__c == null || gradeLevel == null) continue;
                        if(!prgEligibility.GradeLevel__c.contains(gradeLevel)) continue;
                    }
                    if(program.SchoolProgramOfStudyRequired__c){
                        if(prgEligibility.SchoolProgramOfStudy__c == null || schoolProgramOfStudyID == null) continue;
                        if(prgEligibility.SchoolProgramOfStudy__c <> schoolProgramOfStudyID) continue;
                    }
                    if(program.AgeOfMajorityRequired__c){
                        if(birthdate == null || state == null) continue;
                        
                        // Calc age from birthdate
                        Integer ageTotalDays = birthdate.daysBetween(system.today());
                        Integer studentAge = (Integer)(math.Floor(ageTotalDays / 365.2425));
                        
                        if(ProgramEligibilityQueries.determineAgeOfMajority(state) > studentAge) {
                          continue;
                        }      
                    } 
                    
                    if(!output.containsKey(prgEligibility.program__c)){
                        output.put(prgEligibility.program__c,new Offer(inviteOnlyPrgMap.get(prgEligibility.program__c),null));        
                    }
                }
            }
        }
        return output;                                                                            
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

        public Offer(){

        }

        public Offer(Boolean testValues){
            if(testValues){
                //to do
                //this.programName = 'testProgramName';
                //this.programStatus = 'Open'; //Planned, Closed, Cancelled
            }
        }

        public Offer(Program__c prog, StudentProgram__c agreement){
            //system.debug('OfferService.Offer(prog, agreement)');
            //system.debug('prog:'+prog);
            //system.debug('agreement:'+agreement);
            if(prog != null){
                this.programID = prog.Id;   
                this.programName = prog.ProgramName__c;     
                this.schoolID = prog.School__c;
                this.programStatus = prog.ProgramStatus__c;
                this.enrollmentEndDate = prog.EnrollmentEndDate__c;
                this.enrollmentBeginDate = prog.EnrollmentBeginDate__c;
                this.registrationBeginDate = prog.RegistrationBeginDate__c;
                this.registrationEndDate = prog.RegistrationEndDate__c;
            } else if (agreement != null){
                this.agreementStatus = agreement.Status__c;
                this.studentID = agreement.Student__c;
                this.programID = agreement.Program__c;
                this.programName = agreement.Program__r.ProgramName__c;
                this.programStatus = agreement.Program__r.ProgramStatus__c;
                this.schoolID = agreement.Program__r.School__c;
                this.agreementID = agreement.ID;
                this.enrollmentEndDate = agreement.Program__r.EnrollmentEndDate__c;
                this.enrollmentBeginDate = agreement.Program__r.EnrollmentBeginDate__c;
                this.registrationBeginDate = agreement.Program__r.RegistrationBeginDate__c;
                this.registrationEndDate = agreement.Program__r.RegistrationEndDate__c;
            }
        }
    }
}