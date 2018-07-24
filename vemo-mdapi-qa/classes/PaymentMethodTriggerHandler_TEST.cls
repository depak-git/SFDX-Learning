/////////////////////////////////////////////////////////////////////////
// Class: PaymentMethodTriggerHandler
// 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-20   Jared Hagemann  Created                              
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public class PaymentMethodTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    static testMethod void testBooleanSwitcherInsert(){
    	TestUtil.setStandardConfiguration();
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(2);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(TestUtil.TEST_THROTTLE, testStudentAccountMap);
		Map<ID, List<PaymentMethod__c>> studentToPaymentMethodMap = new Map<ID, List<PaymentMethod__c>> ();
		for(PaymentMethod__c pm : testPaymentMethodMap.values()){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(pm.Customer__c);
			if(pms == null){
				pms = new List<PaymentMethod__c>();
				studentToPaymentMethodMap.put(pm.Customer__c, pms);
			}
			pms.add(pm);
		}
		Test.startTest();

		//set first payment method as primary, disbursment, and recurring
		Map<Id, PaymentMethod__c> pmsToUpdate = new Map<Id, PaymentMethod__c>();
		for(Integer i = 0; i < studentToPaymentMethodMap.size(); i++){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(testStudentAccountMap.values().get(i).Id);
			pms.get(0).Primary__c = true;
			pms.get(0).UseForDisbursements__c = true;
			pms.get(0).UseForRecurring__c = true;
			pmsToUpdate.put(pms.get(0).Id, pms.get(0));
		}
		update pmsToUpdate.values();
		
		//set second payment method as primary, disbursment, and recurring
		Map<Id, PaymentMethod__c> pmsToUpdate2 = new Map<Id, PaymentMethod__c>();
		for(Integer i = 0; i < studentToPaymentMethodMap.size(); i++){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(testStudentAccountMap.values().get(i).Id);
			pms.get(1).Primary__c = true;
			pms.get(1).UseForDisbursements__c = true;
			pms.get(1).UseForRecurring__c = true;
			pmsToUpdate2.put(pms.get(1).Id, pms.get(1));
		}
		update pmsToUpdate2.values();

		Test.stopTest();
		
		Map<Id, PaymentMethod__c> updatedPMs = PaymentMethodQueries.getPaymentMethodMapWithPaymentMethodID(pmsToUpdate.keySet());
		for(PaymentMethod__c pm : updatedPMs.values()){
			System.assertEquals(false, pm.Primary__c);
			System.assertEquals(false, pm.UseForDisbursements__c);
			System.assertEquals(false, pm.UseForRecurring__c);
		}
		
		
    }

    static testMethod void testAccntAutoPayUpdate(){
    	TestUtil.setStandardConfiguration();
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(2);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(TestUtil.TEST_THROTTLE, testStudentAccountMap);
		Map<ID, List<PaymentMethod__c>> studentToPaymentMethodMap = new Map<ID, List<PaymentMethod__c>> ();
		for(PaymentMethod__c pm : testPaymentMethodMap.values()){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(pm.Customer__c);
			if(pms == null){
				pms = new List<PaymentMethod__c>();
				studentToPaymentMethodMap.put(pm.Customer__c, pms);
			}
			pms.add(pm);
		}
		Test.startTest();

		//set first payment method as primary, disbursment, and recurring
		Map<Id, PaymentMethod__c> pmsToUpdate = new Map<Id, PaymentMethod__c>();
		for(Integer i = 0; i < studentToPaymentMethodMap.size(); i++){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(testStudentAccountMap.values().get(i).Id);
			pms.get(0).UseForRecurring__c = true;
			pmsToUpdate.put(pms.get(0).Id, pms.get(0));
		}
		update pmsToUpdate.values();

		Test.stopTest();
		Map<Id, Account> resultStudentMap = AccountQueries.getStudentMap();
		for(Account acnt : resultStudentMap.values()){
			System.assert(acnt.AutoPayment__pc);
			System.assertEquals(System.today(), acnt.AutoPaymentDateActivated__pc);
		}
    }
    
    static testMethod void testAccntAutoPayRemove(){
    	TestUtil.setStandardConfiguration();
    	Map<Id, Account> testStudentAccountMap = TestDataFactory.createAndInsertStudentAccounts(2);
    	Map<ID, PaymentMethod__c> testPaymentMethodMap = TestDataFactory.createAndInsertPaymentMethod(TestUtil.TEST_THROTTLE, testStudentAccountMap);
		Map<ID, List<PaymentMethod__c>> studentToPaymentMethodMap = new Map<ID, List<PaymentMethod__c>> ();
		for(PaymentMethod__c pm : testPaymentMethodMap.values()){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(pm.Customer__c);
			if(pms == null){
				pms = new List<PaymentMethod__c>();
				studentToPaymentMethodMap.put(pm.Customer__c, pms);
			}
			pms.add(pm);
		}
		Test.startTest();

		//set first payment method as primary, disbursment, and recurring
		Map<Id, PaymentMethod__c> pmsToUpdate = new Map<Id, PaymentMethod__c>();
		for(Integer i = 0; i < studentToPaymentMethodMap.size(); i++){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(testStudentAccountMap.values().get(i).Id);
			pms.get(0).UseForRecurring__c = true;
			pmsToUpdate.put(pms.get(0).Id, pms.get(0));
		}
		update pmsToUpdate.values();

		for(Integer i = 0; i < studentToPaymentMethodMap.size(); i++){
			List<PaymentMethod__c> pms = studentToPaymentMethodMap.get(testStudentAccountMap.values().get(i).Id);
			pms.get(0).UseForRecurring__c = false;
			pmsToUpdate.put(pms.get(0).Id, pms.get(0));
		}
		update pmsToUpdate.values();

		Test.stopTest();
		Map<Id, Account> resultStudentMap = AccountQueries.getStudentMap();
		for(Account acnt : resultStudentMap.values()){
			System.assert(!acnt.AutoPayment__pc);
		}
    }
       
}