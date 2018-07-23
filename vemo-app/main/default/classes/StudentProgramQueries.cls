/////////////////////////////////////////////////////////////////////////
// Class: StudentProgramQueries
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION----------------------------- 
// 2016-12-23	Greg Cook 		Created
/////////////////////////////////////////////////////////////////////////
public class StudentProgramQueries {

	public static Map<ID, StudentProgram__c> getStudentProgramMap(){
		Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
		String query = generateSOQLSelect();
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' WHERE Deleted__c = false and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));
		return studPrgMap;	
	}

	public static Map<ID, StudentProgram__c> getStudentProgramMapWithAgreementID(Set<ID> agreementIDs){
		Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Deleted__c = false and ID IN ' + DatabaseUtil.inSetStringBuilder(agreementIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));
		return studPrgMap;	
	}


	public static Map<ID, StudentProgram__c> getStudentProgramMapWithStudentID(Set<ID> studentIDs){
		Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Deleted__c = false and Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));
		return studPrgMap;
	}


	public static Map<ID, StudentProgram__c> getStudentProgramMapWithStudentID(Set<ID> studentIDs, Boolean servicing){
		Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Deleted__c = false and Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' and Servicing__c = '+String.valueOf(servicing);
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));
		return studPrgMap;
	}

	public static Map<ID, StudentProgram__c> getInvitedStudentProgramMapWithStudentID(Set<ID> studentIDs){
		Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Deleted__c = false and Student__c IN ' + DatabaseUtil.inSetStringBuilder(studentIDs);
		query += 'and Status__c = \'Invited\' ';
		query += 'and Program__r.ProgramStatus__c = \'Open\' ';
		query += 'and PreCertified__c = true ';
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));
		return studPrgMap;
	}
	public static Map<ID, StudentProgram__c> getStudentProgramMapWithSchoolID(Set<ID> schoolIDs){
		Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Deleted__c = false and Program__r.School__c IN ' + DatabaseUtil.inSetStringBuilder(schoolIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		System.debug('*****************************query = ' + query);
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));
		return studPrgMap;

	}
	public static Map<ID, StudentProgram__c> getStudentProgramMapWithProgramID(Set<ID> programIDs){
		Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
		String query = generateSOQLSelect();
		query += ' WHERE Deleted__c = false and Program__c IN ' + DatabaseUtil.inSetStringBuilder(programIDs);
		if(DatabaseUtil.filterByStudentID){
			ID studentID = DatabaseUtil.studentPersonAccountID;
			query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
			if(DatabaseUtil.filterBySchoolID){
				ID schoolID = DatabaseUtil.schoolID;
				query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
			}
		}
		query += ' '+ generateLIMITStatement();
		DatabaseUtil db = new DatabaseUtil();
		studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));
		return studPrgMap;
	}

	public static String generateSOQLSelect(){
		String soql;
		soql = 'SELECT ' + getfieldNames() + ' FROM StudentProgram__c';
		system.debug(soql);
		return soql;
	}

	public static String getfieldNames(){
		String fieldNames;
		fieldNames = 'id, ';
//		fieldNames += 'CreatedBy, ';
		fieldNames += 'Name, ';
//		fieldNames += 'LastModifiedBy, ';

//		fieldNames += 'GUID__c, ';
		fieldNames += 'Student__c, ';
		fieldNames += 'Student__r.Name, ';
//		fieldNames += 'Student__r.GUID__c, ';


		fieldNames += 'Program__c, ';
//		fieldNames += 'Program__r.GUID__c, ';
		fieldNames += 'Program__r.ProgramName__c, ';
		fieldNames += 'Program__r.ProgramStatus__c, ';
		fieldNames += 'Program__r.School__c, ';
		fieldNames += 'Program__r.School__r.SchoolSecurity__c, ';
//		fieldNames += 'Program__r.School__r.GUID__c, ';
		fieldNames += 'Program__r.AgreementTemplate__c, ';
		fieldNames += 'Program__r.CumulativeIncomeShareCap__c, ';
		fieldNames += 'Program__r.DisclosureTemplate__c, ';		
		fieldNames += 'Program__r.EnrollmentBeginDate__c, ';
		fieldNames += 'Program__r.EnrollmentEndDate__c, ';
		fieldNames += 'Program__r.ProgramNotes__c, ';
		fieldNames += 'Program__r.RegistrationBeginDate__c, ';
		fieldNames += 'Program__r.RegistrationEndDate__c, ';

		fieldNames += 'AdobeSignAgreementID__c, ';
		fieldNames += 'AdobeSignJavascript__c, ';
		fieldNames += 'AdobeSignStatus__c, ';
		fieldNames += 'AdobeSignURL__c, ';
		fieldNames += 'AdobeSignWidgetID__c, ';
		fieldNames += 'AgreementSigned__c, ';

		fieldNames += 'AllocatedAmount__c, ';//will be replaced?
		fieldNames += 'ApplicationStartDate__c, ';
		fieldNames += 'ApprovalDisclosureDate__c, ';
		fieldNames += 'AssessmentDate__c, ';
		fieldNames += 'AssessmentDayOfMonth__c, ';
		fieldNames += 'AssessContract__c, ';
    fieldNames += 'AttendanceBeginDate__c, ';
    fieldNames += 'AttendanceEndDate__c, ';

		fieldNames += 'Birthdate__c, '; //probably goes away
		fieldNames += 'BirthdateCertification__c, ';
		fieldNames += 'BirthdatePreCertification__c, ';
		fieldNames += 'BirthdatePostCertification__c, ';
		fieldNames += 'BirthdateStudent__c, ';

		fieldNames += 'BypassAutomation__c, ';
		fieldNames += 'CancellationReason__c, ';
		fieldNames += 'CertificationComments__c, ';
		fieldNames += 'CertificationDate__c, ';
		fieldNames += 'CertificationDraftStatus__c, ';

		fieldNames += 'CongaFinalDisclosureID__c, ';
		fieldNames += 'CongaFinalDisclosureStatus__c, ';
		fieldNames += 'CongaUnsignedAgreementID__c, ';
		fieldNames += 'CongaUnsignedAgreementStatus__c, ';

		fieldNames += 'CreditCheck__c, ';
		fieldNames += 'CreditCheckDeniedReasonText__c, ';
		fieldNames += 'CreditCheckProcess__c, ';

		fieldNames += 'CurrentStatusDate__c, ';
		fieldNames += 'CustomerWithdrawnReason__c, ';
		fieldNames += 'CustomerWithdrawnReasonOther__c, ';

		fieldNames += 'DaysDelinquent__c, ';
		fieldNames += 'Deferment__c, ';
		fieldNames += 'DefermentMonthsUsed__c, ';
		fieldNames += 'DefermentMonthsAllowed__c, ';
		fieldNames += 'DefermentMonthsRemaining__c, ';
		fieldNames += 'DefermentBeginDate__c, ';
		fieldNames += 'DefermentEndDate__c, ';
		fieldNames += 'Deleted__c, ';

		fieldNames += 'EligibleToReapply__c, ';

		fieldNames += 'EnrollmentStatusCertification__c, ';
		fieldNames += 'EnrollmentStatusPreCertification__c, ';
		fieldNames += 'EnrollmentStatusPostCertification__c, ';
		fieldNames += 'EnrollmentStatusStudent__c, ';

		fieldNames += 'EstimatedAgreementEndDate__c, ';


		fieldNames += 'ExpectedGraduationDate__c, ';
		fieldNames += 'FinalDisclosureCleanURL__c, ';		
		fieldNames += 'FinalDisclosureID__c, ';

		fieldNames += 'FundingAmountCertification__c, ';
		fieldNames += 'FundingAmountPostCertification__c, ';
		fieldNames += 'FundingAmountStudent__c, ';

		fieldNames += 'FundingMaximumPreCertification__c, ';
		fieldNames += 'FundingMinimumPreCertification__c, ';
		fieldNames += 'FundingPurpose__c, ';

		fieldNames += 'GenerateAgreement__c, ';
		fieldNames += 'GenerateDisbursementSchedule__c, ';
		fieldNames += 'GenerateFinalDisclosure__c, ';

		fieldNames += 'GraceMonthsUsed__c, '; 
		fieldNames += 'GraceMonthsAllowed__c, ';
		fieldNames += 'GraceMonthsRemaining__c, ';
		fieldNames += 'GracePeriodEndDate__c, ';

		fieldNames += 'GradeLevel__c, ';
		fieldNames += 'GradeLevelCertification__c, ';
		fieldNames += 'GradeLevelPreCertification__c, ';
		fieldNames += 'GradeLevelPostCertification__c, ';
		fieldNames += 'GradeLevelStudent__c, ';

		fieldNames += 'IncomeShare__c, '; //probably goes away
		fieldNames += 'IncomeShareCertification__c, ';
		fieldNames += 'IncomeSharePostCertification__c, ';
		fieldNames += 'IncomeShareStudent__c, ';

    fieldNames += 'LastDateOfAttendance__c, ';
		fieldNames += 'MajorCertification__c, ';
		fieldNames += 'MajorPreCertification__c, ';
		fieldNames += 'MajorPostCertification__c, ';
		fieldNames += 'MajorStudent__c, ';

		fieldNames += 'MinimumIncomePerMonth__c, ';
		fieldNames += 'MinimumIncomePerYear__c, ';

		fieldNames += 'MonthlyAmountPaidToDate__c, ';
		fieldNames += 'MonthlyAmountDueToDate__c, ';
		fieldNames += 'MonthlyAmountDue__c, ';

		fieldNames += 'NextPaymentDue__c, ';
		fieldNames += 'NextPaymentDueDate__c, ';
		fieldNames += 'NotCertifiedReason__c, ';

		fieldNames += 'PaidToDate__c, ';
		fieldNames += 'PaveTheWay__c, ';

		fieldNames += 'PaymentCap__c, '; //probably goes away
		fieldNames += 'PaymentCapCertification__c, ';
		fieldNames += 'PaymentCapPostCertification__c, ';
		fieldNames += 'PaymentCapStudent__c, ';

		fieldNames += 'PaymentTerm__c, ';//probably goes away
		fieldNames += 'PaymentTermCertification__c, ';
		fieldNames += 'PaymentTermPostCertification__c, ';
		fieldNames += 'PaymentTermStudent__c, ';
		fieldNames += 'PaymentTermAssessed__c, ';
		fieldNames += 'PaymentTermRemaining__c, ';

		fieldNames += 'PreCertified__c, ';
		fieldNames += 'QuizAttemptsData__c, ';
		fieldNames += 'QuizLocked__c, ';
		fieldNames += 'QuizState__c, ';
		fieldNames += 'QuizResponseLink__c, ';

		fieldNames += 'ReconciliationDueToDate__c, ';
		fieldNames += 'ReconciliationPaidTODate__c, ';
		fieldNames += 'ReconciliationDue__c, ';

		fieldNames += 'RegistrationExceptionProcess__c, ';
		fieldNames += 'RemainingTerm__c, '; //deprecated


		fieldNames += 'RequestedAmount__c, '; //probably goes away
		fieldNames += 'Residency__c, ';//probably goes away
		fieldNames += 'ResidencyCertification__c, ';
		fieldNames += 'ResidencyPreCertification__c, ';
		fieldNames += 'ResidencyPostCertification__c, ';
		fieldNames += 'ResidencyStudent__c, ';

		fieldNames += 'RightToCancelDate__c, ';
		fieldNames += 'SchoolName__c, ';
		fieldNames += 'SchoolProgramOfStudy__c, '; //probably goes away
		fieldNames += 'Servicing__c, ';
		fieldNames += 'ServicingStartDate__c, ';
		fieldNames += 'SignedAgreementCleanURL__c, ';				
		fieldNames += 'SignedAgreementID__c, ';

		fieldNames += 'StateOfResidenceCertification__c, ';
		fieldNames += 'StateOfResidencePreCertification__c, ';
		fieldNames += 'StateOfResidencePostCertification__c, ';
		fieldNames += 'StateOfResidenceStudent__c, ';

		fieldNames += 'Status__c, ';
		fieldNames += 'StudentEmail__c, ';
		fieldNames += 'SubmittedDate__c, ';

		fieldNames += 'VemoContractNumber__c ';

		return fieldNames;
	}
	
	public static String generateLIMITStatement(){
		String lim = 'LIMIT 50000';
		return lim;
	}

}