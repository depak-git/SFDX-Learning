@isTest
public with sharing class CongaService_TEST {
	static ID agreementID;
	@TestSetup static void setupData(){
        //TestUtil.createStandardTestConditions();
    }
	@isTest public static void validateGenerateDocument(){
        Map<Id, Account> students = TestDataFactory.createAndInsertStudentAccounts(1);
        Map<Id, Account> schools = TestDataFactory.createAndInsertSchoolCustomerAccounts(1);
        Map<ID, Program__c> programs = TestDataFactory.createAndInsertPrograms(1, schools);
    	Map<Id, StudentProgram__c> studentPrgMap = TestDataFactory.createAndInsertStudentProgram(1, students, programs);
    	agreementID = studentPrgMap.values()[0].id;


		List<APXTConga4__Conga_Merge_Query__c> querys = new List<APXTConga4__Conga_Merge_Query__c>();
		querys.add(new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = CongaService.congaAgreementQueryName));
		querys.add(new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = CongaService.congaLoanAlternativesQueryName));
		querys.add(new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = CongaService.congaISAPaymentsQueryName));
		querys.add(new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = CongaService.congaISAPaymentsGrowthQueryName));
		insert querys;

		Test.setMock(HttpCalloutMock.class, new CongaService_TEST.generateDocumentPass());
		Test.startTest();
		ID theID = CongaService.generateDocument(studentPrgMap.values()[0].id, studentPrgMap.values()[0].id, 'FileName', UserInfo.getSessionId());
    	Test.stopTest();		
	}


	public class generateDocumentFail implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	    	HTTPResponse res = new HTTPResponse();
	    	res.setHeader('Content-Type', 'application/json');
	    	res.setBody('{"error_description":"invalid authorization code","error":"invalid_request"}');
	    	res.setStatusCode(401);
	    	return res;
	    }
	}
	public class generateDocumentPass implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	    	HTTPResponse res = new HTTPResponse();
	    	Attachment newAttach = new Attachment(Name = 'FileName.pdf',
	    										  Body = Blob.valueOf('Test'),
	    										  ParentID = agreementID);
	    	insert newAttach;

	    	res.setHeader('Content-Type', 'application/json');
	    	res.setBody(String.valueOf(newAttach.id));
	    	res.setStatusCode(200);
	    	return res;
	    }
	}
}