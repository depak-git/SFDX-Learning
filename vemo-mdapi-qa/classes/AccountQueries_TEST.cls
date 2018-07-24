/////////////////////////////////////////////////////////////////////////
// Class: AccountQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class AccountQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
	@isTest public static void validateGetSchoolMap() {
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<Id, Account> resultAcctMap = AccountQueries.getSchoolMap();
		System.assertEquals(testAcctMap.keySet().size(), resultAcctMap.keySet().size());
		Test.stopTest();
	}

	@isTest public static void validateGetSchoolMapWithSchoolID(){
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<Id, Account> resultAcctMap = AccountQueries.getSchoolMapWithSchoolID(testAcctMap.keySet());
		System.assertEquals(testAcctMap.keySet().size(), resultAcctMap.keySet().size());
		Test.stopTest();
	}

	@isTest public static void validateGetSchoolMapWithSchoolName(){
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Set<String> schlNames = new Set<String>();
		for(Account acct : testAcctMap.values()){
			schlNames.add(acct.Name);
		}
		Test.startTest();
		Map<Id, Account> resultAcctMap = AccountQueries.getSchoolMapWithSchoolName(schlNames);
		System.assertEquals(testAcctMap.keySet().size(), resultAcctMap.keySet().size());
		Test.stopTest();
	}
	
	
	@isTest public static void validateGetStudentMap() {
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<Id, Account> resultAcctMap = AccountQueries.getStudentMap();
		System.assertEquals(testAcctMap.keySet().size(), resultAcctMap.keySet().size());
		Test.stopTest();
	}

	@isTest public static void validateGetStudent(){
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Map<ID, Account> resultAcctMap = AccountQueries.getStudentMapWithStudentID(testAcctMap.keySet());
		System.assertEquals(testAcctMap.keySet().size(), resultAcctMap.size());
		Test.stopTest();
	}
	
	@isTest public static void validateGetStudentMapByAuthIDWithAuthID(){
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Set<String> authIDs = new Set<String>();
		for(Account stud : testAcctMap.values()){
			authIDs.add(stud.AuthSystemUserID__pc);
		}
		Test.startTest();
		DatabaseUtil.runQueriesInUserMode = false;
		Map<String, Account> resultAcctMap = AccountQueries.getStudentMapByAuthIDWithAuthID(authIDs);
		System.assertEquals(authIDs.size(), resultAcctMap.size());
		Test.stopTest();
	}
	
}