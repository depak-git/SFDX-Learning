/////////////////////////////////////////////////////////////////////////
// Class: PaymentAllocationScheduled_TEST
// 
// Description: 
// 		Test class for PaymentAllocationScheduled_
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-17   Jared Hagemann  Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class PaymentAllocationScheduled_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(1);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);

    	//Add a few fees
    	//5 fees @ $1000 apiece
    	Map<ID, Fee__c> testFeeMap = TestDataFactory.createAndInsertFee(1, testStudentAccountMap);
    	
    	Map<Id, PaymentInstruction__c> paymenetInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    }

	static testMethod void testPaymentAllocationScheduled(){
		Test.startTest();
		PaymentAllocationScheduled pas = new PaymentAllocationScheduled();
		String sch = '0 0 23 * * ?';
//		System.schedule('Test PaymentAllocationScheduled', sch, pas);
		Test.stopTest();
	}
}