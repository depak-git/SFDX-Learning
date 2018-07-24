@isTest
public class TransactionService_TEST {

    @TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    /////////////////////////////////////////////////////////////////////
    //Disbursements
    /////////////////////////////////////////////////////////////////////
    @isTest public static void validateGetDisbursementWithDisbursementID(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);
        Test.startTest();
        List<TransactionService.Disbursement> dists = TransactionService.getDisbursementWithDisbursementID(testDisbursement.keySet());
        System.assertEquals(testDisbursement.size(), dists.size());
        Test.stopTest();
    }

    @isTest public static void validateGetDisbursementWithAgreementID(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);
        Test.startTest();
        List<TransactionService.Disbursement> dists = TransactionService.getDisbursementWithAgreementID(agreements.keySet());
        System.assertEquals(testDisbursement.size(), dists.size());
        Test.stopTest();
    }

    @isTest public static void validateGetDisbursementWithStudentID(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);
        Test.startTest();
        List<TransactionService.Disbursement> dists = TransactionService.getDisbursementWithStudentID(students.keySet());
        System.assertEquals(testDisbursement.size(), dists.size());
        Test.stopTest();
    }

    @isTest public static void validateCreateDisbursement(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        List<TransactionService.Disbursement> dists = new List<TransactionService.Disbursement>();
        for(StudentProgram__c agree : agreements.values()){
            TransactionService.Disbursement dis = new TransactionService.Disbursement(true);
            dis.studentID = agree.Student__c;
            dis.agreementID = agree.Id;
            dists.add(dis);
        }
        Test.startTest();
        Set<ID> disbursementIDs = TransactionService.createDisbursements(dists);
        System.assertEquals(dists.size(), disbursementIDs.size());
        Test.stopTest();
    }

    @isTest public static void validateUpdateDisbursement(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        List<TransactionService.Disbursement> dists = new List<TransactionService.Disbursement>();
        for(StudentProgram__c agree : agreements.values()){
            TransactionService.Disbursement dis = new TransactionService.Disbursement(true);
            dis.studentID = agree.Student__c;
            dis.agreementID = agree.Id;
            dists.add(dis);
        }
        Set<ID> disbursementIDs = TransactionService.createDisbursements(dists);
        List<TransactionService.Disbursement> distsToUpdate = TransactionService.getDisbursementWithDisbursementID(disbursementIDs);
        for(TransactionService.Disbursement dis : distsToUpdate){
            dis.status = 'Scheduled';
        }
        Test.startTest();
        Set<ID> updatedDists = TransactionService.updateDisbursements(distsToUpdate);
        Test.stopTest();
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithTransactionID(updatedDists, TransactionService.disbursementRecType);
        for(Transaction__c tran : trans.values()){
            System.assertEquals(tran.Status__c, 'Scheduled');
        }
    }

    @isTest public static void validateDeleteDisbursements(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursement = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRecType);
        Test.startTest();
        Integer numDis = testDisbursement.size();
        Integer numDisDeleted = TransactionService.deleteDisbursements(testDisbursement.keySet());
        Test.stopTest();
        System.assertEquals(numDis, numDisDeleted);
        System.assertEquals(0, TransactionQueries.getTransactionMap(TransactionService.disbursementRecType).size());
    }

    /////////////////////////////////////////////////////////////////////
    //Disbursement Refunds
    /////////////////////////////////////////////////////////////////////

    @isTest public static void validateGetDisbursementRefundsWithDisbursementRefundID(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursementRefunds = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRefundRecType);
        Test.startTest();
        List<TransactionService.DisbursementRefund> distRefunds = TransactionService.getDisbursementRefundWithDisbursementRefundID(testDisbursementRefunds.keySet());
        System.assertEquals(testDisbursementRefunds.size(), distRefunds.size());
        Test.stopTest();
    }

    @isTest public static void validateGetDisbursementRefundsWithAgreementID(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursementRefunds = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRefundRecType);
        Test.startTest();
        List<TransactionService.DisbursementRefund> distRefunds = TransactionService.getDisbursementRefundWithAgreementID(agreements.keySet());
        System.assertEquals(testDisbursementRefunds.size(), distRefunds.size());
        Test.stopTest();
    }

    @isTest public static void validateGetDisbursementRefundsWithStudentID(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__C> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursementRefunds = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRefundRecType);
        Test.startTest();
        List<TransactionService.DisbursementRefund> distRefunds = TransactionService.getDisbursementRefundWithStudentID(students.keySet());
        System.assertEquals(testDisbursementRefunds.size(), distRefunds.size());
        Test.stopTest();
    }

    @isTest public static void validateCreateDisbursementRefunds(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        List<TransactionService.DisbursementRefund> distRefunds = new List<TransactionService.DisbursementRefund>();
        for(StudentProgram__c agree : agreements.values()){
            TransactionService.DisbursementRefund disRefund = new TransactionService.DisbursementRefund(true);
            disRefund.studentID = agree.Student__c;
            disRefund.agreementID = agree.Id;
            distRefunds.add(disRefund);
        }
        Test.startTest();
        Set<ID> disbursementRefundsIDs = TransactionService.createDisbursementRefunds(distRefunds);
        System.assertEquals(distRefunds.size(), disbursementRefundsIDs.size());
        Test.stopTest();
    }

    @isTest public static void validateUpdateDisbursementRefunds(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        List<TransactionService.DisbursementRefund> distRefunds = new List<TransactionService.DisbursementRefund>();
        for(StudentProgram__c agree : agreements.values()){
            TransactionService.DisbursementRefund disRefund = new TransactionService.DisbursementRefund(true);
            disRefund.studentID = agree.Student__c;
            disRefund.agreementID = agree.Id;
            distRefunds.add(disRefund);
        }
        Set<ID> disbursementRefundsIDs = TransactionService.createDisbursementRefunds(distRefunds);
        List<TransactionService.DisbursementRefund> distRefundsToUpdate = TransactionService.getDisbursementRefundWithDisbursementRefundID(disbursementRefundsIDs);
        for(TransactionService.DisbursementRefund disRefund : distRefundsToUpdate){
            disRefund.status = 'Scheduled';
        }
        Test.startTest();
        Set<ID> updatedDists = TransactionService.updateDisbursementRefunds(distRefundsToUpdate);
        Test.stopTest();
        Map<ID, Transaction__c> trans = TransactionQueries.getTransactionMapWithTransactionID(updatedDists, TransactionService.disbursementRecType);
        for(Transaction__c tran : trans.values()){
            System.assertEquals(tran.Status__c, 'Scheduled');
        }
    }

    @isTest public static void validateDeleteDisbursementsRefunds(){
        Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
        Map<ID, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
        Map<ID, StudentProgram__c> agreements = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
        Map<ID, Transaction__c> testDisbursementRefunds = TestDataFactory.createAndInsertTransactions(1, agreements, TransactionService.disbursementRefundRecType);
        Test.startTest();
        Integer numDis = testDisbursementRefunds.size();
        Integer numDisDeleted = TransactionService.deleteDisbursementRefunds(testDisbursementRefunds.keySet());
        Test.stopTest();
        System.assertEquals(numDis, numDisDeleted);
        System.assertEquals(0, TransactionQueries.getTransactionMap(TransactionService.disbursementRecType).size());
    }



}