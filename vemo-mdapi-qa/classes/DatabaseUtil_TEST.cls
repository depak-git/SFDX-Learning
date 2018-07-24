/////////////////////////////////////////////////////////////////////////
// Class: DatabaseUtil_TEST
// 
// Description: 
//  Unit test for DatabaseUtil
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-25   Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class DatabaseUtil_TEST {

	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

	static testMethod void testConstructor(){
		Test.startTest();
			DatabaseUtil du1 = new DatabaseUtil();
			DatabaseUtil du2 = new DatabaseUtil(true);
		Test.stopTest();
		System.assert(du1.withSharing == null);
		System.assert(du2.withSharing);
	}

	static testMethod void testSystemContext(){
		String queryString = 'Select Id from User where Id = \'' + UserInfo.getUserId() +'\'';

		Test.startTest();
		DatabaseUtil.SystemContext sc = new DatabaseUtil.SystemContext();
		List<SObject> sObjects = sc.databaseQuery(queryString);
		Test.stopTest();
		System.assertEquals(1, sObjects.size());
	}

	static testMethod void testUserContext(){
		String queryString = 'Select Id from User where Id = \'' + UserInfo.getUserId() +'\'';

		Test.startTest();
		DatabaseUtil.UserContext uc = new DatabaseUtil.UserContext();
		List<SObject> sObjects = uc.databaseQuery(queryString);
		Test.stopTest();
		System.assertEquals(1, sObjects.size());
	}

	static testMethod void testInSetStringBuilderString(){
		Set<String> stringSet = new Set<String>{'one', 'two', 'three'};
		Test.startTest();
		String setString = DatabaseUtil.inSetStringBuilder(stringSet);
		Test.stopTest();
		System.assertEquals('(\'one\',\'two\',\'three\')', setString);
	}

	static testMethod void testInSetStringBuilderSet(){
		Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);		
		Test.startTest();
		String setString = DatabaseUtil.inSetStringBuilder(students.keySet());
		Test.stopTest();
		List<String> parsedSetString = setString.split(',');
		System.assertEquals(parsedSetString.size(), students.size());
	}

	static testMethod void testInStringBuilder(){
		String testString = 'Test';
		Test.startTest();
		String resultString = DatabaseUtil.inStringBuilder(testString);
		Test.stopTest();
		System.assertEquals('\'' + testString + '\'', resultString);
	}
}