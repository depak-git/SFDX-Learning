@isTest
public class StudentService_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    @isTest public static void validateConstructor() {
    	StudentService.Student student1 = new StudentService.Student(new Account());
    	StudentService.Student student2 = new StudentService.Student();
    	Account acct = StudentService.studentToAccount(student2);
    }
	@isTest public static void validateGetStudents() {
		Map<Id, Account> testAcctMap = TestDataFactory.createAndInsertStudentAccounts(TestUtil.TEST_THROTTLE);
		Test.startTest();
		List<StudentService.Student> students = StudentService.getStudentsWithStudentID(testAcctMap.keySet());
		System.assertEquals(testAcctMap.keySet().size(), students.size());
		Test.stopTest();
	}
	@isTest public static void validateCreateStudents() {
		List<StudentService.Student> students = new List<StudentService.Student>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			StudentService.Student stud = new StudentService.Student(true);
			stud.authSystemUserID = String.valueOf(i);
			stud.commonLineID = String.valueOf(i);
			students.add(stud);
		}
		Test.startTest();
		Set<ID> studentIDs = StudentService.createStudents(students);
		System.assertEquals(students.size(), AccountQueries.getStudentMap().size());
		Test.stopTest();
	}
	@isTest public static void validateUpdateStudents() {
		List<StudentService.Student> students = new List<StudentService.Student>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			StudentService.Student stud = new StudentService.Student(true);
			stud.authSystemUserID = String.valueOf(i);
			stud.commonLineID = String.valueOf(i);
			students.add(stud);
		}
		Set<ID> studentIDs = StudentService.createStudents(students);
		List<StudentService.Student> studentsAfter = StudentService.getStudentsWithStudentID(studentIDs);
		for(StudentService.Student stud : studentsAfter){
			stud.ssnTaxID = 'updated';
		}
		Test.startTest();
		Set<ID> updatedIDs = StudentService.updateStudents(studentsAfter);
		Test.stopTest();
		Map<ID, Account> updatedAccounts = AccountQueries.getStudentMap();
		for(Account acct : updatedAccounts.values()){
			System.assertEquals(acct.SSNTaxID__pc, 'updated');			
		}
	}
	@isTest public static void validateDeleteStudents() {
		List<StudentService.Student> students = new List<StudentService.Student>();
		for(Integer i = 0; i<TestUtil.TEST_THROTTLE; i++){
			StudentService.Student stud = new StudentService.Student(true);
			stud.authSystemUserID = String.valueOf(i);
			students.add(stud);
			stud.commonLineID = String.valueOf(i);
		}

		Set<ID> studentIDs = StudentService.createStudents(students);
		System.assertEquals(students.size(), AccountQueries.getStudentMap().size());

		Test.startTest();
		Integer del = StudentService.deleteStudents(studentIDs);
		Test.stopTest();
		System.assertEquals(studentIDs.size(), del);
		System.assertEquals(0, AccountQueries.getStudentMap().size());	
	}
}