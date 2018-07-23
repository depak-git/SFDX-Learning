/////////////////////////////////////////////////////////////////////////
// Class: SchoolService_TEST
// 
// Description: 
// 	Test class for SchoolService
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
@isTest
public class SchoolService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    
    @isTest public static void validategGetSchoolsWithSchoolID() {
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		List<SchoolService.School> schools = SchoolService.getSchoolsWithSchoolID(testAcctMap.keySet());
		System.assertEquals(testAcctMap.keySet().size(), schools.size());
		Test.stopTest();
	}
	
	@isTest public static void validateGetSchoolsWithSchoolName() {
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertSchoolCustomerAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		Set<String> schoolNames = new Set<String>();
		for(Account acct : testAcctMap.values()){
			schoolNames.add(acct.Name);
		}
		List<SchoolService.School> schools = SchoolService.getSchoolsWithSchoolName(schoolNames);
		System.assertEquals(testAcctMap.keySet().size(), schools.size());
		Test.stopTest();
	}

	@isTest public static void validateCreateSchool(){
		List<SchoolService.School> schools = new List<SchoolService.School>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			SchoolService.School schl = new SchoolService.School(true);
			schools.add(schl);
		}
		Test.startTest();
		Set<ID> schoolIDs = SchoolService.createSchool(schools);
		System.assertEquals(schools.size(), AccountQueries.getSchoolMap().size());
		Test.stopTest();
	}
	
	@isTest public static void validateUpdateSchool(){
		List<SchoolService.School> schools = new List<SchoolService.School>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			SchoolService.School schl = new SchoolService.School(true);
			schools.add(schl);
		}
		Set<ID> schoolIDs = SchoolService.createSchool(schools);		
		List<SchoolService.School> insertedSchools = SchoolService.getSchoolsWithSchoolID(schoolIDs);
		for(SchoolService.School schl : insertedSchools){
			schl.schoolName = 'Updated Name';			
		}
		
		Test.startTest();
		Set<ID> updatedSchools = SchoolService.updateSchool(insertedSchools);
		Test.stopTest();
		Map<ID, Account> updatedAccounts = AccountQueries.getSchoolMapWithSchoolID(updatedSchools);
		for(Account acct : updatedAccounts.values()){
			System.assertEquals('Updated Name', acct.Name);
		}
	}
	
	@isTest public static void validateDeleteSchool(){
		List<SchoolService.School> schools = new List<SchoolService.School>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			SchoolService.School schl = new SchoolService.School(true);
			schools.add(schl);
		}
		Set<ID> schoolIDs = SchoolService.createSchool(schools);
		System.assertEquals(schools.size(), AccountQueries.getSchoolMap().size());

		Test.startTest();
		Integer del = SchoolService.deleteSchool(schoolIDs);
		Test.stopTest();
		System.assertEquals(schoolIDs.size(), del);
		System.assertEquals(0, AccountQueries.getSchoolMap().size());
	}

	
}