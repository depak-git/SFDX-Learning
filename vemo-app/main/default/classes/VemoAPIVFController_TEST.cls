@isTest
public with sharing class VemoAPIVFController_TEST {
	@isTest
	public static void validateController() {
		VemoAPIVFController controller = new VemoAPIVFController();
		VemoAPIVFController.callVemoAPI('GET', '/vemo/v1/student', '', 'VEMO_AUTH=testStudent_46&studentID=0017A00000RMCVHQA5');


	}
}