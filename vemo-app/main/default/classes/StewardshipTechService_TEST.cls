@isTest
public with sharing class StewardshipTechService_TEST {
	@TestSetup
	public static void testSetup(){
		//StewardshipTechnologySettings__c settings = new StewardshipTechnologySettings__c();
		//insert settings;
		//TestUtil.createStandardTestConditions();
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//ABARoutingVerify https://www.egsnetwork.com/pages/apidoc.php?ABARoutingVerify
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockABARoutingVerify1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":""},"RoutingNumber":{"ABARoutingNum":"102000076","BankName":"WELLS FARGO BANK NA"}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testABARoutingVerify() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockABARoutingVerify1());
		StewardshipTechService.ABARoutingVerifyRequest input = new StewardshipTechService.ABARoutingVerifyRequest();
		input.ABARoutingNum = '102000076';
		StewardshipTechService.ABARoutingVerify(StewardshipTechService.AccountType.PAYMENT, input);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//CreateDonor https://www.egsnetwork.com/pages/apidoc.php?CreateDonor
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCreateDonor1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":""},"Donor":{"DonorGUID":"7E4A337A-1A0A-4E41-9F48-949732890AA2"}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCreateDonor() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateDonor1());
		StewardshipTechService.CreateDonorRequest input = new StewardshipTechService.CreateDonorRequest();
		input.DonorID = '123';
		input.LastName = 'Test';
		input.City = 'Test';
		input.PostalCode = '12345';
		input.StateCode = 'Test';
		input.Street1 = 'Test';
		StewardshipTechService.CreateDonor(StewardshipTechService.AccountType.PAYMENT, input);
	}

	@isTest
	public static void testCreateDonorQueueable(){
		Account acct = new Account(LastName='Test');
		insert acct;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateDonor1());
		StewardshipTechService.CreateDonorQueueable job = new StewardshipTechService.CreateDonorQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CreateDonorRequest input = new StewardshipTechService.CreateDonorRequest();
		input.DonorID = acct.id;
		input.LastName = 'Test';
		input.City = 'Test';
		input.PostalCode = '12345';
		input.StateCode = 'Test';
		input.Street1 = 'Test';
		job.input = input;
		
		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	

	}
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateDonor2 https://www.egsnetwork.com/pages/apidoc.php?CreateDonor2
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCreateDonor21 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":""},"Donor":{"DonorGUID":"7E4A337A-1A0A-4E41-9F48-949732890AA2"}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCreateDonor2(){
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateDonor21());
		StewardshipTechService.CreateDonor2Request input = new StewardshipTechService.CreateDonor2Request();
		input.DonorID = '123';
		input.LastName = 'Test';
		input.City = 'Test';
		input.PostalCode = '12345';
		input.StateCode = 'Test';
		input.Street1 = 'Test';
		input.BankAccountType ='B';
		input.AccountNumber = '123';
		input.ABARoutingNum = '123';
		input.AccountType = 'C';

		StewardshipTechService.CreateDonor2(StewardshipTechService.AccountType.PAYMENT, input);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//CreateACHAccount https://www.egsnetwork.com/pages/apidoc.php?CreateACHAccount
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCreateACHAccount1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":""},"Account":{"DonorGUID":"117FDE89-F3DD-47AC-806A-C19185F11AB6","AccountGUID":"AF40BF65-5A7F-47D0-9C6F-6569825C4593"}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCreateACHAccount() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateACHAccount1());
		StewardshipTechService.CreateACHAccountRequest input = new StewardshipTechService.CreateACHAccountRequest();
		input.DonorGUID = '80B139CB-EF75-42CE-842B-688672A1CFE7';
		input.Nickname = 'Test';
		input.BankAccountType = 'C';
		input.AccountNumber = '123456789';
		input.ABARoutingNum = '102000076';
		StewardshipTechService.CreateACHAccount(StewardshipTechService.AccountType.Payment, input);
	}
	@isTest
	public static void testCreateACHAccountQueueable(){
		Account acct = new Account(LastName='Test');
		insert acct;
		PaymentMethod__c payment = new PaymentMethod__c(Customer__c = acct.id);
		insert payment;

		StewardshipTechService.CreateACHAccountQueueable job = new StewardshipTechService.CreateACHAccountQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CreateACHAccountRequest input = new StewardshipTechService.CreateACHAccountRequest();
		input.DonorGUID = '80B139CB-EF75-42CE-842B-688672A1CFE7';
		input.Nickname = 'Test';
		input.BankAccountType = 'C';
		input.AccountNumber = '123456789';
		input.ABARoutingNum = '102000076';
		job.input = input;
		job.paymentMethodID = payment.id;
		
		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//CancelAccount https://www.egsnetwork.com/pages/apidoc.php?CancelAccount
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCancelAccount1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCancelAccount() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCancelAccount1());
		StewardshipTechService.CancelAccountRequest input = new StewardshipTechService.CancelAccountRequest();
		input.DonorGUID = '80B139CB-EF75-42CE-842B-688672A1CFE7';
		input.AccountGUID = 'test';
		StewardshipTechService.CancelAccount(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testCancelAccountQueueable(){
		Account acct = new Account(LastName='Test');
		insert acct;
		PaymentMethod__c payment = new PaymentMethod__c(Customer__c = acct.id);
		insert payment;

		StewardshipTechService.CancelAccountQueueable job = new StewardshipTechService.CancelAccountQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CancelAccountRequest input = new StewardshipTechService.CancelAccountRequest();
		input.DonorGUID = '80B139CB-EF75-42CE-842B-688672A1CFE7';
		input.AccountGUID = 'test';
		job.input = input;
		job.paymentMethodID = payment.id;
		
		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//CreateDesignation https://www.egsnetwork.com/pages/apidoc.php?CancelAccount
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCreateDesignation1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCreateDesignation() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateDesignation1());
		StewardshipTechService.CreateDesignationRequest input = new StewardshipTechService.CreateDesignationRequest();
		input.DesignationName = '123';
		input.DesignationDescription = '123';
		input.ExternalID = '123';
		input.IsACH = '1';
		StewardshipTechService.CreateDesignation(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testCreateDesignationQueueable(){
		StewardshipTechnologySettings__c settingsToCreate = new StewardshipTechnologySettings__c(SetupOwnerId = UserInfo.getOrganizationID());
		insert settingsToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateDesignation1());
		StewardshipTechService.CreateDesignationQueueable job = new StewardshipTechService.CreateDesignationQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CreateDesignationRequest input = new StewardshipTechService.CreateDesignationRequest();
		input.DesignationName = '123';
		input.DesignationDescription = '123';
		input.ExternalID = '123';
		input.IsACH = '1';
		job.input = input;
		
		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//PaymentBatchOpen https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchOpen
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockPaymentBatchOpen1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testPaymentBatchOpen() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchOpen1());

		StewardshipTechService.PaymentBatchOpen(StewardshipTechService.AccountType.Payment);
	}

	@isTest
	public static void testPaymentBatchOpenQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchOpen1());
		StewardshipTechService.PaymentBatchOpenQueueable job = new StewardshipTechService.PaymentBatchOpenQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		job.stewardshipBatchID = batchToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreditBatchOpen https://www.egsnetwork.com/pages/apidoc.php?CreditBatchOpen
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCreditBatchOpen1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCreditBatchOpen() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreditBatchOpen1());
		StewardshipTechService.CreditBatchOpenRequest input = new StewardshipTechService.CreditBatchOpenRequest();
		StewardshipTechService.CreditBatchOpen(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testCreditBatchOpenQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreditBatchOpen1());
		StewardshipTechService.CreditBatchOpenQueueable job = new StewardshipTechService.CreditBatchOpenQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CreditBatchOpenRequest input = new StewardshipTechService.CreditBatchOpenRequest();
		job.input = input;
		job.stewardshipBatchID = batchToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//PaymentBatchSelect https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchSelect
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockPaymentBatchSelect1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testPaymentBatchSelect() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchSelect1());
		StewardshipTechService.PaymentBatchSelectRequest input = new StewardshipTechService.PaymentBatchSelectRequest();
		input.BatchGUID = '123';
		StewardshipTechService.PaymentBatchSelect(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testPaymentBatchSelectQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchSelect1());
		StewardshipTechService.PaymentBatchSelectQueueable job = new StewardshipTechService.PaymentBatchSelectQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.PaymentBatchSelectRequest input = new StewardshipTechService.PaymentBatchSelectRequest();
		input.BatchGUID = '123';
		job.input = input;
		job.stewardshipBatchID = batchToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//PaymentBatchApprove https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchApprove
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockPaymentBatchApprove1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testPaymentBatchApprove() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchApprove1());
		StewardshipTechService.PaymentBatchApproveRequest input = new StewardshipTechService.PaymentBatchApproveRequest();
		input.BatchGUID = '123';
		StewardshipTechService.PaymentBatchApprove(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testPaymentBatchApproveQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchApprove1());
		StewardshipTechService.PaymentBatchApproveQueueable job = new StewardshipTechService.PaymentBatchApproveQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.PaymentBatchApproveRequest input = new StewardshipTechService.PaymentBatchApproveRequest();
		input.BatchGUID = '123';
		job.input = input;
		job.stewardshipBatchID = batchToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//PaymentBatchCancel https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchCancel
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockPaymentBatchCancel1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testPaymentBatchCancel() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchCancel1());
		StewardshipTechService.PaymentBatchCancelRequest input = new StewardshipTechService.PaymentBatchCancelRequest();
		input.BatchGUID = '123';
		StewardshipTechService.PaymentBatchCancel(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testPaymentBatchCancelQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockPaymentBatchCancel1());
		StewardshipTechService.PaymentBatchCancelQueueable job = new StewardshipTechService.PaymentBatchCancelQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.PaymentBatchCancelRequest input = new StewardshipTechService.PaymentBatchCancelRequest();
		input.BatchGUID = '123';
		job.input = input;
		job.stewardshipBatchID = batchToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//CreateTransaction https://www.egsnetwork.com/pages/apidoc.php?CreateTransaction
	//
	////////////////////////////////////////////////////////////////////////////////////////////////////			    		
	public class mockCreateTransaction1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCreateTransaction() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateTransaction1());
		StewardshipTechService.CreateTransactionRequest input = new StewardshipTechService.CreateTransactionRequest();
		input.BatchGUID = '123';
		input.DonorGUID = '123';
		input.AccountGUID = '123';
		input.Amount1 = 123;
		input.Amount1String = '123';
		input.Memo1 = '123';
		input.DesignationGUID1 = '123';
		input.RecurringType = '123';
		input.ScheduledDate = Date.today();
		input.ScheduledDateString = '123';
		StewardshipTechService.CreateTransaction(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testCreateTransactionQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		StewardshipACHBatchDetail__c batchDtlToCreate = new StewardshipACHBatchDetail__c(StewardshipACHBatch__c = batchToCreate.id);
		insert batchDtlToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateTransaction1());
		StewardshipTechService.CreateTransactionQueueable job = new StewardshipTechService.CreateTransactionQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CreateTransactionRequest input = new StewardshipTechService.CreateTransactionRequest();
		input.BatchGUID = '123';
		input.DonorGUID = '123';
		input.AccountGUID = '123';
		input.Amount1 = 123;
		input.Amount1String = '123';
		input.Memo1 = '123';
		input.DesignationGUID1 = '123';
		input.RecurringType = '123';
		input.ScheduledDate = Date.today();
		input.ScheduledDateString = '123';
		job.input = input;
		job.stewardshipBatchDetailID = batchDtlToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateCreditTransaction https://www.egsnetwork.com/pages/apidoc.php?CreateCreditTransaction
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCreateCreditTransaction1 implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The account has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCreateCreditTransaction() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateCreditTransaction1());
		StewardshipTechService.CreateCreditTransactionRequest input = new StewardshipTechService.CreateCreditTransactionRequest();
		input.BatchGUID = '123';
		input.DonorGUID = '123';
		input.AccountGUID = '123';
		input.Amount = 123;
		input.AmountString = '123';
		input.Memo = '123';
		StewardshipTechService.CreateCreditTransaction(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testCreateCreditTransactionQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		StewardshipACHBatchDetail__c batchDtlToCreate = new StewardshipACHBatchDetail__c(StewardshipACHBatch__c = batchToCreate.id);
		insert batchDtlToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCreateCreditTransaction1());
		StewardshipTechService.CreateCreditTransactionQueueable job = new StewardshipTechService.CreateCreditTransactionQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CreateCreditTransactionRequest input = new StewardshipTechService.CreateCreditTransactionRequest();
		input.BatchGUID = '123';
		input.DonorGUID = '123';
		input.AccountGUID = '123';
		input.Amount = 123;
		input.AmountString = '123';
		input.Memo = '123';
		job.input = input;
		job.stewardshipBatchDetailID = batchDtlToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CancelTransaction https://www.egsnetwork.com/pages/apidoc.php?CancelTransaction
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
	public class mockCancelTransaction implements HttpCalloutMock {
	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse mockResponse = new HTTPResponse();
	        mockResponse.setBody('{"Root":{"Status":{"ErrorCode":"0","Description":"The transaction has been cancelled."}}}');
	        mockResponse.setStatusCode(200);
	        return mockResponse;
	    }
	}
	@isTest
	public static void testCanceTransaction() {
		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCancelTransaction());
		StewardshipTechService.CancelTransactionRequest input = new StewardshipTechService.CancelTransactionRequest();
		input.DonorGUID = '123';
		input.AccountScheduleGUID = '123';
		StewardshipTechService.CancelTransaction(StewardshipTechService.AccountType.Payment, input);
	}

	@isTest
	public static void testCancelTransactionQueuable(){
		StewardshipACHBatch__c batchToCreate = new StewardshipACHBatch__c();
		insert batchToCreate;

		StewardshipACHBatchDetail__c batchDtlToCreate = new StewardshipACHBatchDetail__c(StewardshipACHBatch__c = batchToCreate.id);
		insert batchDtlToCreate;

		Test.setMock(HttpCalloutMock.class, new StewardshipTechService_TEST.mockCancelTransaction());
		StewardshipTechService.CancelTransactionQueueable job = new StewardshipTechService.CancelTransactionQueueable();
		job.acctType = StewardshipTechService.AccountType.PAYMENT;
		StewardshipTechService.CancelTransactionRequest input = new StewardshipTechService.CancelTransactionRequest();
		input.DonorGUID = '123';
		input.AccountScheduleGUID = '123';
		job.input = input;
		job.stewardshipBatchDetailID = batchDtlToCreate.id;

		Test.startTest();
		System.enqueueJob(job);
		Test.stopTest();	
	}
}