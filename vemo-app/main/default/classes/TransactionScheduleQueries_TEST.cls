@isTest
public class TransactionScheduleQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest public static void validateGetTransactionScheduleMap(){

    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);


    	Map<ID, TransactionSchedule__c> testSchedule = TestDataFactory.createAndInsertTransactionSchedule(2, programs);
    	Test.startTest();
    	Map<ID, TransactionSchedule__c> schMap = TransactionScheduleQueries.getTransactionScheduleMap();
    	Test.stopTest();
    	System.assertEquals(testSchedule.size(), schMap.size());
    }

    @isTest public static void validateGetTransactionScheduleMapWithAgreementID(){

    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);

    	Map<ID, TransactionSchedule__c> testSchedule = TestDataFactory.createAndInsertTransactionSchedule(2, programs);
    	Test.startTest();
    	Map<ID, TransactionSchedule__c> schMap = TransactionScheduleQueries.getTransactionScheduleMapWithProgramID(programs.keyset());
    	Test.stopTest();

    	System.assertEquals(testSchedule.size(), schMap.size());
    }

    @isTest public static void validateGetTransactionSchedulesByProgramIDWithProgramID(){

    	Map<ID, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
    	Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(2, schools);


    	Map<ID, TransactionSchedule__c> testSchedule = TestDataFactory.createAndInsertTransactionSchedule(2, programs);
    	Test.startTest();
    	Map<ID, List<TransactionSchedule__c>> schMap = TransactionScheduleQueries.getTransactionSchedulesByProgramIDWithProgramID(programs.keyset());
    	Test.stopTest();

    	System.assertEquals(programs.size(), schMap.size());
    	for(ID theID : schMap.keySet()){
    		System.assertEquals(schMap.get(theID).size(), 2, 'Should be 2 per program');
    	}
    } 
}