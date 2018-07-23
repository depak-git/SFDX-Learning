public with sharing class Atom21Migration {
	// public static void migratePayments() {
	// 	List<PaymentInstruction__c> paymentInstructionsToAdd = new List<PaymentInstruction__c>();
	// 	for(List<Transaction__c> trans : [SELECT id, RecordTypeID, Student__c, Agreement__c, Status__c, TransactionDate__c, Amount__c
	// 									  FROM Transaction__c
	// 									  WHERE RecordTypeID = :GlobalUtil.getRecordTypeIdByLabelName('Transaction__c', 'Payment')
	// 									  AND DATA__c != 'DELETE']){
	// 		for(Transaction__c tx : trans){
	// 			PaymentInstruction__c payment = new PaymentInstruction__c();
	// 			payment.Amount__c = tx.Amount__c;
	// 			payment.Date__c = tx.TransactionDate__c;
	// 			payment.DATA__c = String.valueOf(tx.Agreement__c);
	// 			payment.Student__c = tx.Student__c;
	// 			paymentInstructionsToAdd.add(payment);
	// 			tx.DATA__c = 'DELETE';
	// 		}
	// 		update trans;

	// 	}
	// 	if(paymentInstructionsToAdd.size()>0){
	// 		insert paymentInstructionsToAdd;
	// 	}
	// 	List<PaymentAllocation__c> allocations = new List<PaymentAllocation__c>();
	// 	for(PaymentInstruction__c payment : paymentInstructionsToAdd){
	// 		allocations.add(new PaymentAllocation__c(PaymentInstruction__c = payment.id, 
	// 													Agreement__c = payment.DATA__c, Detail__c = 'Data Conversion',
	// 													AmountAllocated__c = payment.Amount__c,
	// 													AllocationType__c = 'Monthly Amount'));
	// 	}
	// 	if(allocations.size()>0){
	// 		insert allocations;
	// 	}
	// }

	// public static void deleteMigratedPayments(){
	// 	delete [SELECT id from Transaction__c where DATA__c = 'DELETE'];
	// }

	// public static void setAssessmentNumbers(){
	// 	for(List<Account> accts : [SELECT id
	// 									from Account where
	// 	 								RecordTypeID = :GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student')]){
	// 		for(Account acct : accts){
	// 			acct.AssessmentDayOfMonth__c = 16;
	// 			acct.DueDayOfTheMonth__c = 1;
	// 		}
	// 		update accts;

	// 	}
	// }

	// public static void approvePendingAccounts(){
	// 	for(List<Account> accts : [SELECT id,
	// 	 								RecordStatus__pc,
	// 									PendingFirstName__pc,
	// 									PendingMiddleName__pc,
	// 									PendingLastName__pc,
	// 									PendingBirthdate__pc,
	// 									PendingDriversLicenseOrStateID__pc,
	// 									PendingEmail__pc,
	// 									PendingResidency__pc,
	// 									PendingMailingStreet__pc,
	// 									PendingMailingCity__pc,
	// 									PendingMailingStateCode__pc,
	// 									PendingMailingState__pc,
	// 									PendingMailingCountryCode__pc,
	// 									PendingMailingCountry__pc,
	// 									PendingMailingPostalCode__pc
	// 									from Account where RecordStatus__pc != 'Approved' and 
	// 	 								RecordTypeID = :GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student')]){
	// 		for(Account acct : accts){
	// 			acct.RecordStatus__pc = 'Approved';
	// 			if(String.isNotEmpty(acct.PendingFirstName__pc)) acct.FirstName = acct.PendingFirstName__pc;
	// 			if(String.isNotEmpty(acct.PendingMiddleName__pc)) acct.MiddleName = acct.PendingMiddleName__pc;
	// 			if(acct.PendingBirthdate__pc != null) acct.PersonBirthdate = acct.PendingBirthDate__pc;
	// 			if(String.isNotEmpty(acct.PendingLastName__pc)) acct.LastName = acct.PendingLastName__pc;
	// 			if(String.isNotEmpty(acct.PendingDriversLicenseOrStateID__pc)) acct.DriversLicenseOrStateID__pc = acct.PendingDriversLicenseOrStateID__pc;
	// 			if(String.isNotEmpty(acct.PendingEmail__pc)) acct.PersonEmail = acct.PendingEmail__pc;
	// 			if(String.isNotEmpty(acct.PendingResidency__pc)) acct.Residency__pc = acct.PendingResidency__pc;

	// 			if(String.isNotEmpty(acct.PendingMailingStreet__pc)) acct.PersonMailingStreet = acct.PendingMailingStreet__pc;
	// 			if(String.isNotEmpty(acct.PendingMailingCity__pc)) acct.PersonMailingCity = acct.PendingMailingCity__pc;				
	// 			if(String.isNotEmpty(acct.PendingMailingStateCode__pc)) acct.PersonMailingStateCode = acct.PendingMailingStateCode__pc;
	// 			if(String.isNotEmpty(acct.PendingMailingState__pc)) acct.PersonMailingState = acct.PendingMailingState__pc;
	// 			if(String.isNotEmpty(acct.PendingMailingCountryCode__pc)) acct.PersonMailingCountryCode = acct.PendingMailingCountryCode__pc;
	// 			if(String.isNotEmpty(acct.PendingMailingCountry__pc)) acct.PersonMailingCountry = acct.PendingMailingCountry__pc;
	// 			if(String.isNotEmpty(acct.PendingMailingPostalCode__pc)) acct.PersonMailingPostalCode = acct.PendingMailingPostalCode__pc;

	// 			acct.PendingFirstName__pc = '';
	// 			acct.PendingMiddleName__pc = '';
	// 			acct.PendingLastName__pc = '';
	// 			acct.PendingBirthdate__pc = null;
	// 			acct.PendingDriversLicenseOrStateID__pc = '';
	// 			acct.PendingEmail__pc = '';
	// 			acct.PendingResidency__pc = '';
	// 			acct.PendingMailingStreet__pc = '';
	// 			acct.PendingMailingCity__pc = '';
	// 			acct.PendingMailingStateCode__pc = '';
	// 			acct.PendingMailingState__pc = '';
	// 			acct.PendingMailingCountryCode__pc = '';
	// 			acct.PendingMailingCountry__pc = '';
	// 			acct.PendingMailingPostalCode__pc = '';


	// 			system.debug(acct);
	// 		}
	// 		system.debug(accts);
	// 		update accts;
	// 	}
	// }

	// public static void migrateAgreementData() {
	// 	Map<ID, StudentProgram__c> agreements1 = new Map<ID, StudentProgram__c>([SELECT id from StudentProgram__c]);
	// 	Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreements1.keySet());
	// 	Set<ID> studentIDs = new Set<ID>();
	// 	for(StudentProgram__c agreement : agreementMap.values()){
	// 		studentIDs.add(agreement.Student__c);
	// 	}
	// 	Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);

	// 	for(StudentProgram__c a : agreementMap.values()){
	// 		Account acct = studentMap.get(a.Student__c);
	// 		if(a.Status__c == 'Application Incomplete' || a.Status__c == 'Application Under Review' || a.Status__c == 'Cancelled' || a.Status__c == 'Application Complete'){
	// 			//Copy from legacy to Student Fields
	// 			a.BirthdateStudent__c = acct.PersonBirthdate;
	// 			a.EnrollmentStatusStudent__c = (String.isNotEmpty(a.EnrollmentStatus__c) ? a.EnrollmentStatus__c : acct.PrimarySchoolEnrollmentStatus__pc);
	// 			a.FundingAmountStudent__c = a.RequestedAmount__c;
	// 			a.GradeLevelStudent__c = (String.isNotEmpty(a.GradeLevel__c) ? a.GradeLevel__c : acct.PrimarySchoolGradeLevel__pc);
	// 			a.IncomeShareStudent__c = a.IncomeShare__c;
	// 			a.MajorStudent__c = (String.isNotEmpty(a.SchoolProgramOfStudy__c) ? a.SchoolProgramOfStudy__c : acct.SchoolProgramOfStudy__pc);
	// 			a.PaymentCapStudent__c = a.PaymentCap__c;
	// 			a.PaymentTermStudent__c = a.PaymentTerm__c;
	// 			a.ResidencyStudent__c = (String.isNotEmpty(a.Residency__c) ? a.Residency__c : acct.Residency__pc);
	// 			a.StateOfResidenceStudent__c = acct.PersonMailingStateCode;

	// 		}
	// 		if(a.Status__c == 'Certified' ||
	// 		   a.Status__c == 'Partially Funded' ||
	// 		   a.Status__c == 'Fully Funded' ||
	// 		   a.Status__c == 'Grace' ||
	// 		   a.Status__c == 'Deferment' || 
	// 		   a.Status__c == 'Payment'){
	// 			a.BirthdateStudent__c = acct.PersonBirthdate;
	// 			a.BirthdateCertification__c = acct.PersonBirthdate;
	// 			a.BirthdatePostCertification__c = acct.PersonBirthdate;	

	// 			a.EnrollmentStatusStudent__c = (String.isNotEmpty(a.EnrollmentStatus__c) ? a.EnrollmentStatus__c : acct.PrimarySchoolEnrollmentStatus__pc);
	// 			a.EnrollmentStatusCertification__c = (String.isNotEmpty(a.EnrollmentStatus__c) ? a.EnrollmentStatus__c : acct.PrimarySchoolEnrollmentStatus__pc);
	// 			a.EnrollmentStatusPostCertification__c = (String.isNotEmpty(a.EnrollmentStatus__c) ? a.EnrollmentStatus__c : acct.PrimarySchoolEnrollmentStatus__pc);
				
	// 			a.FundingAmountStudent__c = a.RequestedAmount__c;
	// 			a.FundingAmountCertification__c = a.AllocatedAmount__c;
	// 			a.FundingAmountPostCertification__c = a.AllocatedAmount__c;								

	// 			a.GradeLevelStudent__c = (String.isNotEmpty(a.GradeLevel__c) ? a.GradeLevel__c : acct.PrimarySchoolGradeLevel__pc);
	// 			a.GradeLevelCertification__c = (String.isNotEmpty(a.GradeLevel__c) ? a.GradeLevel__c : acct.PrimarySchoolGradeLevel__pc);				
	// 			a.GradeLevelPostCertification__c = (String.isNotEmpty(a.GradeLevel__c) ? a.GradeLevel__c : acct.PrimarySchoolGradeLevel__pc);

	// 			a.IncomeShareStudent__c = a.IncomeShare__c;
	// 			a.IncomeShareCertification__c = a.IncomeShare__c;				
	// 			a.IncomeSharePostCertification__c = a.IncomeShare__c;

	// 			a.MajorStudent__c = (String.isNotEmpty(a.SchoolProgramOfStudy__c) ? a.SchoolProgramOfStudy__c : acct.SchoolProgramOfStudy__pc);
	// 			a.MajorCertification__c = (String.isNotEmpty(a.SchoolProgramOfStudy__c) ? a.SchoolProgramOfStudy__c : acct.SchoolProgramOfStudy__pc);
	// 			a.MajorPostCertification__c = (String.isNotEmpty(a.SchoolProgramOfStudy__c) ? a.SchoolProgramOfStudy__c : acct.SchoolProgramOfStudy__pc);
				
	// 			a.PaymentCapStudent__c = a.PaymentCap__c;
	// 			a.PaymentCapCertification__c = a.PaymentCap__c;				
	// 			a.PaymentCapPostCertification__c = a.PaymentCap__c;

	// 			a.PaymentTermStudent__c = a.PaymentTerm__c;
	// 			a.PaymentTermCertification__c = a.PaymentTerm__c;				
	// 			a.PaymentTermPostCertification__c = a.PaymentTerm__c;

	// 			a.ResidencyStudent__c = (String.isNotEmpty(a.Residency__c) ? a.Residency__c : acct.Residency__pc);
	// 			a.ResidencyCertification__c = (String.isNotEmpty(a.Residency__c) ? a.Residency__c : acct.Residency__pc);				
	// 			a.ResidencyPostCertification__c = (String.isNotEmpty(a.Residency__c) ? a.Residency__c : acct.Residency__pc);

	// 			a.StateOfResidenceStudent__c = acct.PersonMailingStateCode;
	// 			a.StateOfResidenceCertification__c = acct.PersonMailingStateCode;
	// 			a.StateOfResidencePostCertification__c = acct.PersonMailingStateCode;
	// 			a.CertificationDraftStatus__c = 'Certified';
	// 		}
	// 		if(a.Status__c == 'Fully Funded' || a.Status__c == 'Grace' || a.Status__c == 'Deferment' || a.Status__c == 'Payment'){

	// 		}
	// 	}
	// 	system.debug(agreementMap.values());
	// 	update agreementMap.values();
	// }
}