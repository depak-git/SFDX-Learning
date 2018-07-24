@isTest
public class DisbursementService_TEST {
/*	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetDisbursementWithDisbursementID(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertDisbursements(1, agreements);
    	Test.startTest();
    	List<DisbursementService.Disbursement> dists = DisbursementService.getDisbursementWithDisbursementID(testDisbursement.keySet());
    	System.assertEquals(testDisbursement.size(), dists.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetDisbursementWithAgreementID(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertDisbursements(1, agreements);
    	Test.startTest();
    	List<DisbursementService.Disbursement> dists = DisbursementService.getDisbursementWithAgreementID(agreements.keySet());
    	System.assertEquals(testDisbursement.size(), dists.size());
    	Test.stopTest();
    }

    @isTest public static void validateGetDisbursementWithStudentID(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertDisbursements(1, agreements);
    	Test.startTest();
    	List<DisbursementService.Disbursement> dists = DisbursementService.getDisbursementWithStudentID(students.keySet());
    	System.assertEquals(testDisbursement.size(), dists.size());
    	Test.stopTest();
    }

    @isTest public static void validateCreateDisbursement(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	List<DisbursementService.Disbursement> dists = new List<DisbursementService.Disbursement>();
    	for(StudentProgram__c agree : agreements.values()){
    		DisbursementService.Disbursement dis = new DisbursementService.Disbursement(true);
    		dis.studentID = agree.Student__c;
    		dis.agreementID = agree.Id;
    		dists.add(dis);
    	}
    	Test.startTest();
    	Set<ID> disbursementIDs = DisbursementService.createDisbursements(dists);
    	System.assertEquals(dists.size(), disbursementIDs.size());
    	Test.stopTest();
    }

    @isTest public static void validateUpdateDisbursement(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	List<DisbursementService.Disbursement> dists = new List<DisbursementService.Disbursement>();
    	for(StudentProgram__c agree : agreements.values()){
    		DisbursementService.Disbursement dis = new DisbursementService.Disbursement(true);
    		dis.studentID = agree.Student__c;
    		dis.agreementID = agree.Id;
    		dists.add(dis);
    	}
    	Set<ID> disbursementIDs = DisbursementService.createDisbursements(dists);
    	List<DisbursementService.Disbursement> distsToUpdate = DisbursementService.getDisbursementWithDisbursementID(disbursementIDs);
    	for(DisbursementService.Disbursement dis : distsToUpdate){
    		dis.status = 'Scheduled';
    	}
    	Test.startTest();
    	Set<ID> updatedDists = DisbursementService.updateDisbursements(distsToUpdate);
    	Test.stopTest();
    	Map<ID, Transaction__c> trans = TransactionQueries.getDisbursementMapWithDisbursementID(updatedDists);
    	for(Transaction__c tran : trans.values()){
    		System.assertEquals(tran.Status__c, 'Scheduled');
    	}
    }

    @isTest public static void validateDeleteDisbursements(){
    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertDisbursements(1, agreements);
    	Test.startTest();
    	Integer numDis = testDisbursement.size();
    	Integer numDisDeleted = DisbursementService.deleteDisbursements(testDisbursement.keySet());
    	Test.stopTest();
    	System.assertEquals(numDis, numDisDeleted);
    	System.assertEquals(0, TransactionQueries.getDisbursementMap().size());
    }
*/
}