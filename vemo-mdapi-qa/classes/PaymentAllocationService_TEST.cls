/////////////////////////////////////////////////////////////////////////
// Class: PaymentAllocationService_TEST
// 
// Description: 
// 		Test class for PaymentAllocationService
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-17   Jared Hagemann  Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class PaymentAllocationService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(1);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(1, testStudentAccountMap);
    	Map<ID, PaymentInstruction__c> testPaymentInsturctionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);

    	//Add a few fees
    	//5 fees @ $1000 apiece
    	Map<ID, Fee__c> testFeeMap = TestDataFactory.createAndInsertFee(5, testStudentAccountMap);

    	//Add Agreements
    	//20 Agreements @ $1000 a piece
    	Map<ID, Account> schooolMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
    	Map<ID, Program__c> programMap = TestDataFactory.createAndInsertPrograms(1, schooolMap);
    	Map<ID, StudentProgram__c> agreementMap = TestDataFactory.createAndInsertStudentProgram(1, testStudentAccountMap, programMap);
    	Map<ID, StudentProgramMonthlyStatus__c> agreementMonthlyStatusMap = TestDataFactory.createAndInsertStudentProgramMonthlyStatus(20, agreementMap);
    	Map<ID, StudentProgramAmountDue__c> agreementBillMap = TestDataFactory.createAndInsertStudentProgramAmountDue(agreementMap, agreementMonthlyStatusMap);
    	Date today = System.today();
    	Integer count = 0;
    	for(StudentProgramAmountDue__c bill : agreementBillMap.values()){
    		//Past Due Reconciliations
    		if(count < 5){
    			bill.AssessmentDateTime__c = today.addMonths(-2);
    			bill.Type__c = 'Reconciliation';
    			bill.Amount__c = 1000;
    		}
    		//Current Reconciliations
    		else if(count >= 5 && count < 10){
    			bill.AssessmentDateTime__c = today;
    			bill.Type__c = 'Reconciliation';
    			bill.Amount__c = 1000;
    		}
    		//Past Due Monthly Amounts
    		else if(count >= 10 && count < 15){
    			bill.AssessmentDateTime__c = today.addMonths(-2);
    			bill.Type__c = 'Monthly Amount';
    			bill.Amount__c = 1000;
    		}
    		//Current Monthly Amounts
    		else{
    			bill.AssessmentDateTime__c = today;
    			bill.Type__c = 'Monthly Amount';
    			bill.Amount__c = 1000;
    		}
    		count = count + 1;
    	}
    	update agreementBillMap.values();
    	Map<Id, PaymentInstruction__c> paymenetInstructionMap = TestDataFactory.createAndInsertPaymentInstruction(1, testStudentAccountMap, testPaymentMethodMap);
    }

	static testMethod void testAllocatePaymentInFull(){	    	
    	PaymentInstruction__c pi = PaymentInstructionQueries.getPaymentInstructionMap().values().get(0);
    	//pi.fullyAllocated__c = false;
    	pi.Amount__c = 25000;
    	update pi;

    	Test.startTest();
    	List<PaymentAllocationService.PaymentInstruction> resultPaymentInstructions = PaymentAllocationService.allocatePaymentV2(pi.Id, false);
    	Test.stopTest();
    	PaymentAllocationService.PaymentInstruction result = resultPaymentInstructions.get(0);
    	System.assertEquals(25000, result.paymentAmount);
    	System.assertEquals(0, result.remainingAllocation);
	}

	static testMethod void testAllocatePaymentParital(){	    	
    	PaymentInstruction__c pi = PaymentInstructionQueries.getPaymentInstructionMap().values().get(0);
    	//pi.fullyAllocated__c = false;
    	pi.Amount__c = 500;
    	update pi;

    	Test.startTest();
    	List<PaymentAllocationService.PaymentInstruction> resultPaymentInstructions = PaymentAllocationService.allocatePaymentV2(pi.Id, false);
    	Test.stopTest();
    	PaymentAllocationService.PaymentInstruction result = resultPaymentInstructions.get(0);
    	System.assertEquals(500, result.paymentAmount);
    	System.assertEquals(500, result.remainingAllocation);
    	List<Case> cases = [select Id from Case];
    	System.assertEquals(1, cases.size());
	}
}