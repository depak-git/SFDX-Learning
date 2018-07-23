/////////////////////////////////////////////////////////////////////////
// Class: VemoAPI_TEST
// 
// Description: 
//  Unit test for VemoAPI
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-17   Greg Cook       Created                             
// 2016-12-24	Greg Cook 		Refactored to loop through all services
/////////////////////////////////////////////////////////////////////////
@IsTest
public class VemoAPI_TEST {
	public static Integer vemoAuth = 1;
	static RestRequest req;
	static RestResponse res;
	static List<String> services = new List<String>();
	static{
		services.add('student');
		services.add('program');
		services.add('creditcheck');
		services.add('attachment');
		services.add('school');
		services.add('agreement');
		services.add('offer');
		services.add('disbursement');
		services.add('disbursementrefund');
		services.add('case');
		services.add('programofstudy');
		services.add('programeligibility');
		services.add('contractterms');
		services.add('reconciliation');

	}
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        TestDataFactory.createAndInsertTestStudentAccount();
    }

	static void initializeAPIRequest(String version, String service, String httpMethod, String vemoAuthStr){	
		req = new RestRequest();
		res = new RestResponse();
		String host = URL.getSalesforceBaseUrl().getHost();
		req.requestURI = '/vemo/' + version + '/' + service;	
		req.addParameter('VEMO_AUTH', vemoAuthStr);
		req.httpMethod = httpMethod;		
	}
	
	static testMethod void testDoGet(){		
		Test.startTest();
		for(String service : services){
			initializeAPIRequest('v1', service, 'GET', TestDataFactory.STUDENT_AUTH_KEY);
			RestContext.request = req;
			RestContext.response = res;
			System.debug(VemoAPI.doGet());
			break;
			VemoAPI.ResultResponse results = (VemoAPI.ResultResponse)VemoAPI.doGet();
			List<String> handler = (List<String>)results.result;
			System.assertEquals('handling ' + service, handler.get(0));
		}
		Test.stopTest();
	}
	
	static testMethod void testDoPost(){
		Test.startTest();
		for(String service : services){
			initializeAPIRequest('v1', service, 'POST', TestDataFactory.STUDENT_AUTH_KEY);
			RestContext.request = req;
			RestContext.response = res;
			VemoAPI.ResultResponse results = (VemoAPI.ResultResponse )VemoAPI.doPost();
			List<String> handler = (List<String>)results.result;
			System.assertEquals('handling ' + service, handler.get(0));
		}
		Test.stopTest();
	}
	
	static testMethod void testDoPut(){
		Test.startTest();
		for(String service : services){
			initializeAPIRequest('v1', service, 'PUT', TestDataFactory.STUDENT_AUTH_KEY);
			RestContext.request = req;
			RestContext.response = res;
			VemoAPI.ResultResponse results = (VemoAPI.ResultResponse )VemoAPI.doPut();
			List<String> handler = (List<String>)results.result;
			System.assertEquals('handling ' + service, handler.get(0));
		}
		Test.stopTest();
	}
	
	
	static testMethod void testDoDelete(){
		Test.startTest();
		for(String service : services){
			initializeAPIRequest('v1', service, 'DELETE', TestDataFactory.STUDENT_AUTH_KEY);
			RestContext.request = req;
			RestContext.response = res;
			VemoAPI.ResultResponse results = (VemoAPI.ResultResponse )VemoAPI.doDelete();
			List<String> handler = (List<String>)results.result;
			System.assertEquals('handling ' + service, handler.get(0));
		}
		Test.stopTest();
	}

 	static testMethod void testVemoExeptionHandling(){
 		Test.startTest();
 		for(String service : services){
	 		initializeAPIRequest('v1', service, 'DELETE', null);
			RestContext.request = req;
			RestContext.response = res;
			VemoAPI.FaultResponse results = (VemoAPI.FaultResponse )VemoAPI.doDelete();
			System.assert(results != null);
		}
		Test.stopTest();
 	}

// 	static testMethod void testDecryptVemoAuth(){
 		//TODO
// 	}
}