public with sharing class StewardshipTechService {
    public enum AccountType {PAYMENT, DISBURSEMENT} 

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //ABARoutingVerify https://www.egsnetwork.com/pages/apidoc.php?ABARoutingVerify
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static ABARoutingVerifyResponse ABARoutingVerify(AccountType acctType, ABARoutingVerifyRequest input) {
        //System.debug('StewardshipTechService.ABARoutingVerify()');
        LogService.debug('Entering StewardshipTechService.ABARoutingVerify()', 'ABARoutingVerify');

        if(String.isEmpty(input.ABARoutingNum)) throw new StewardshipTechServiceException('ABARoutingNum is Required');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }

            bodyStr += '&Action='+'ABARoutingVerify';
            bodyStr += '&ABARoutingNum='+EncodingUtil.urlEncode(input.ABARoutingNum,'UTF-8');//input.ABARoutingNum;
            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr); //hide this for security reasons
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'ABARoutingVerify'); //hide this for security reasons
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'ABARoutingVerify');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'ABARoutingVerify');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'ABARoutingVerify');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'ABARoutingVerify');

        //system.debug(res);
        String jsonResponse = res.getBody();
        ABARoutingVerifyResponse routingVerifyResponse = (ABARoutingVerifyResponse) JSON.deserialize(jsonResponse, ABARoutingVerifyResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(routingVerifyResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(routingVerifyResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(routingVerifyResponse.root.Status.Description);            
        }
        LogService.debug('Exiting StewardshipTechService.ABARoutingVerify()', 'ABARoutingVerify');
        return routingVerifyResponse;
    }
    public class ABARoutingVerifyRequest{
        public String ABARoutingNum {get;set;}
    }
    public class ABARoutingVerifyResponse{
        public ABARoutingVerifyResponseRoot Root {get;set;}
    }
    public class ABARoutingVerifyResponseRoot{
        public ABARoutingVerifyResponseStatus Status {get;set;}
        public ABARoutingVerifyResponseRoutingNumber RoutingNumber {get;set;}
    }
    public class ABARoutingVerifyResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class ABARoutingVerifyResponseRoutingNumber{
        public String ABARoutingNum {get;set;}
        public String BankName {get;set;}
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateDonor https://www.egsnetwork.com/pages/apidoc.php?CreateDonor
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CreateDonorResponse CreateDonor(AccountType acctType, CreateDonorRequest input) {
        //system.debug('StewardshipTechService.CreateDonor()');
        LogService.debug('Entering StewardshipTechService.CreateDonor()', 'CreateDonor');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'CreateDonor';

            bodyStr += '&DonorID='+EncodingUtil.urlEncode(input.DonorID,'UTF-8');//input.DonorID;
            bodyStr += '&LastName='+EncodingUtil.urlEncode(input.LastName,'UTF-8');//input.LastName;
            bodyStr += '&City='+EncodingUtil.urlEncode(input.City,'UTF-8');//input.City;
            bodyStr += '&PostalCode='+EncodingUtil.urlEncode(input.PostalCode,'UTF-8');//input.PostalCode;
            bodyStr += '&StateCode='+EncodingUtil.urlEncode(input.StateCode,'UTF-8');//input.StateCode;
            bodyStr += '&Street1='+EncodingUtil.urlEncode(input.Street1,'UTF-8');//input.Street1;

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
       // System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CreateDonor');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CreateDonor');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CreateDonor');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CreateDonor');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CreateDonor');

        //system.debug(res);
        String jsonResponse = res.getBody();
        CreateDonorResponse createDonResponse = (CreateDonorResponse) JSON.deserialize(jsonResponse, CreateDonorResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(createDonResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(createDonResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(createDonResponse.root.Status.Description);            
        }
        LogService.debug('Exiting StewardshipTechService.CreateDonor()', 'CreateDonor');
        return createDonResponse;
    }
    public class CreateDonorRequest{
        public String DonorID {get;set;}
        //String UserName {get;set;}
        //String Password {get;set;}
        //String FirstName {get;set;}
        public String LastName {get;set;}
        public String Street1 {get;set;}
        //String Street2 {get;set;}
        //String Street3 {get;set;}
        public String City {get;set;}
        public String StateCode {get;set;}
        //String StateProvinceName {get;set;}
        public String PostalCode {get;set;}
        //String CountryCode {get;set;}
        //String PhoneNum {get;set;}
        //String EmailAddress {get;set;}
        //String SendLoginInformation {get;set;}
    }
    public class CreateDonorResponse{
        public CreateDonorResponseRoot Root {get;set;}
    }
    public class CreateDonorResponseRoot{
        public CreateDonorResponseStatus Status {get;set;}
        public CreateDonorResponseDonor Donor {get;set;}
    }
    public class CreateDonorResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class CreateDonorResponseDonor{
        public String DonorGUID {get;set;}
    }


    public class CreateDonorQueueable implements Queueable, Database.AllowsCallouts {
        public CreateDonorQueueable(){

        }
        public CreateDonorRequest input {get;set;}
        public AccountType acctType {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CreateDonorQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CreateDonorQueueable.execute()');
            

            StewardshipTechService.CreateDonorResponse response;
            List<Account> acctsToUpdate = new List<Account>();
            try{
                response = StewardshipTechService.CreateDonor(acctType, input);
                Account acct = new Account(id = input.DonorID,
                                           StewardshipProcess__c = 'DonorGUID Created');
                if(acctType == AccountType.PAYMENT){
                    acct.StewardshipPaymentDonorGUID__c = response.Root.Donor.DonorGUID;
                } else if (acctType == AccountType.DISBURSEMENT){
                    acct.StewardshipDisbursementDonorGUID__c = response.Root.Donor.DonorGUID;
                } 
                acctsToUpdate.add(acct);
            } catch (Exception e){
                System.debug(e);
                acctsToUpdate.add(new Account(id = input.DonorID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(acctsToUpdate.size()>0){
                update acctsToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.CreateDonorQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }   
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateDonor2 https://www.egsnetwork.com/pages/apidoc.php?CreateDonor2
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CreateDonor2Response CreateDonor2(AccountType acctType, CreateDonor2Request input) {
        //system.debug('StewardshipTechService.CreateDonor2()');
        LogService.debug('Entering StewardshipTechService.CreateDonor2()', 'CreateDonor2');
        
        if(String.isEmpty(input.DonorID)) throw new StewardshipTechServiceException('DonorID is Required');
        if(String.isEmpty(input.LastName)) throw new StewardshipTechServiceException('LastName is Required');
        if(String.isEmpty(input.City)) throw new StewardshipTechServiceException('City is Required');
        if(String.isEmpty(input.PostalCode)) throw new StewardshipTechServiceException('PostalCode is Required');
        if(String.isEmpty(input.StateCode)) throw new StewardshipTechServiceException('StateCode is Required');
        if(String.isEmpty(input.Street1)) throw new StewardshipTechServiceException('Street1 is Required');

        if(String.isEmpty(input.AccountNumber)) throw new StewardshipTechServiceException('AccountNumber is Required');

        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'CreateDonor2';

            bodyStr += '&DonorID='+EncodingUtil.urlEncode(input.DonorID,'UTF-8');//input.DonorID;
            bodyStr += '&LastName='+EncodingUtil.urlEncode(input.LastName,'UTF-8');//input.LastName;
            bodyStr += '&City='+EncodingUtil.urlEncode(input.City,'UTF-8');//input.City;
            bodyStr += '&PostalCode='+EncodingUtil.urlEncode(input.PostalCode,'UTF-8');//input.PostalCode;
            bodyStr += '&StateCode='+EncodingUtil.urlEncode(input.StateCode,'UTF-8');//input.StateCode;
            bodyStr += '&Street1='+EncodingUtil.urlEncode(input.Street1,'UTF-8');//input.Street1;

            bodyStr += '&BankAccountType='+EncodingUtil.urlEncode(input.BankAccountType,'UTF-8');
            bodyStr += '&AccountNumber='+EncodingUtil.urlEncode(input.AccountNumber,'UTF-8');
            bodyStr += '&ABARoutingNum='+EncodingUtil.urlEncode(input.ABARoutingNum,'UTF-8');
            bodyStr += '&AccountType='+EncodingUtil.urlEncode(input.AccountType,'UTF-8');

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CreateDonor2');
        //LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CreateDonor2');
        HttpResponse res = h.send(req);
        //LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CreateDonor2');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CreateDonor2');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CreateDonor2');

        //system.debug(res);
        String jsonResponse = res.getBody();
        CreateDonor2Response createDonResponse = (CreateDonor2Response) JSON.deserialize(jsonResponse, CreateDonor2Response.class);

        //ystem.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(createDonResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(createDonResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(createDonResponse.root.Status.Description);            
        }
        LogService.debug('Exiting StewardshipTechService.CreateDonor2()', 'CreateDonor2');
        return createDonResponse;
    }
    public class CreateDonor2Request{
        public String DonorID {get;set;}
        //String UserName {get;set;}
        //String Password {get;set;}
        //String FirstName {get;set;}
        public String LastName {get;set;}
        public String Street1 {get;set;}
        //String Street2 {get;set;}
        //String Street3 {get;set;}
        public String City {get;set;}
        public String StateCode {get;set;}
        //String StateProvinceName {get;set;}
        public String PostalCode {get;set;}
        //String CountryCode {get;set;}
        //String PhoneNum {get;set;}
        //String EmailAddress {get;set;}
        //String SendLoginInformation {get;set;}
        public String BankAccountType {get;set;}
        public String AccountNumber {get;set;}
        public String ABARoutingNum {get;set;}
        public STring AccountType {get;set;}

    }
    public class CreateDonor2Response{
        public CreateDonor2ResponseRoot Root {get;set;}
    }
    public class CreateDonor2ResponseRoot{
        public CreateDonor2ResponseStatus Status {get;set;}
        public CreateDonor2ResponseDonor Donor {get;set;}
    }
    public class CreateDonor2ResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class CreateDonor2ResponseDonor{
        public String DonorGUID {get;set;}
        public String AccountGUID {get;set;}
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateACHAccount https://www.egsnetwork.com/pages/apidoc.php?CreateACHAccount
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CreateACHAccountResponse CreateACHAccount(AccountType acctType, CreateACHAccountRequest input) {
        //system.debug('StewardshipTechService.CreateACHAccount()');
        LogService.debug('Entering StewardshipTechService.CreateACHAccount()', 'CreateACHAccount');

        if(String.isEmpty(input.DonorGUID)) throw new StewardshipTechServiceException('DonorGUID is Required');
        if(String.isEmpty(input.Nickname)) throw new StewardshipTechServiceException('(ACH Account) Nickname is Required');
        if(String.isEmpty(input.BankAccountType)) throw new StewardshipTechServiceException('BankAccountType is Required');
        if(String.isEmpty(input.AccountNumber)) throw new StewardshipTechServiceException('AccountNumber is Required');
        if(String.isEmpty(input.ABARoutingNum)) throw new StewardshipTechServiceException('ABARoutingNum is Required');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'CreateACHAccount';

            bodyStr += '&DonorGUID='+EncodingUtil.urlEncode(input.DonorGUID,'UTF-8');//input.DonorGUID;
            bodyStr += '&Nickname='+EncodingUtil.urlEncode(input.Nickname,'UTF-8');//input.Nickname;
            bodyStr += '&BankAccountType='+EncodingUtil.urlEncode(input.BankAccountType,'UTF-8');//input.BankAccountType;
            bodyStr += '&AccountNumber='+EncodingUtil.urlEncode(input.AccountNumber,'UTF-8');//input.AccountNumber;
            bodyStr += '&ABARoutingNum='+EncodingUtil.urlEncode(input.ABARoutingNum,'UTF-8');//input.ABARoutingNum;

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CreateACHAccount');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CreateACHAccount');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CreateACHAccount');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CreateACHAccount');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CreateACHAccount');

        //system.debug(res);
        String jsonResponse = res.getBody();
        CreateACHAccountResponse createAccountResponse = (CreateACHAccountResponse) JSON.deserialize(jsonResponse, CreateACHAccountResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
       // system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(createAccountResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(createAccountResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(createAccountResponse.root.Status.Description);            
        }
        LogService.debug('Exiting StewardshipTechService.CreateACHAccount()', 'CreateACHAccount');
        return createAccountResponse;
    }
    public class CreateACHAccountRequest{
        public String DonorGUID {get;set;}
        public String Nickname {get;set;}
        public String BankAccountType {get;set;}
        public String AccountNumber {get;set;}
        public STring ABARoutingNum {get;set;}
    }
    public class CreateACHAccountResponse{
        public CreateACHAccountResponseRoot Root {get;set;}
    }
    public class CreateACHAccountResponseRoot{
        public CreateACHAccountResponseStatus Status {get;set;}
        public CreateACHAccountResponseAccount Account {get;set;}
    }
    public class CreateACHAccountResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class CreateACHAccountResponseAccount{
        public String DonorGUID {get;set;}
        public String AccountGUID {get;set;}
    }

    public class CreateACHAccountQueueable implements Queueable, Database.AllowsCallouts {
        public CreateACHAccountQueueable(){

        }
        public CreateACHAccountRequest input {get;set;}
        public AccountType acctType {get;set;}
        public String paymentMethodID {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CreateACHAccountQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CreateACHAccountQueueable.execute()');
            

            StewardshipTechService.CreateACHAccountResponse response;
            List<PaymentMethod__c> paymentMethodsToUpdate = new List<PaymentMethod__c>();
            try{
                response = StewardshipTechService.CreateACHAccount(acctType, input);
                PaymentMethod__c payment = new PaymentMethod__c(id = paymentMethodID,
                                                                StewardshipProcess__c ='AccountGUID Created');


                if(acctType == AccountType.PAYMENT){
                    payment.StewardshipPaymentAccountGUID__c = response.Root.Account.AccountGUID;
                } else if (acctType == AccountType.DISBURSEMENT){
                    payment.StewardshipDisbursementAccountGUID__c = response.Root.Account.AccountGUID;
                } 
                paymentMethodsToUpdate.add(payment);

            } catch (Exception e){
                System.debug(e);
                paymentMethodsToUpdate.add(new PaymentMethod__c(id = paymentMethodID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(paymentMethodsToUpdate.size()>0){
                update paymentMethodsToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.CreateACHAccountQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CancelAccount https://www.egsnetwork.com/pages/apidoc.php?CancelAccount
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CancelAccountResponse CancelAccount(AccountType acctType, CancelAccountRequest input) {
        //system.debug('StewardshipTechService.CancelAccount()');
        LogService.debug('Entering StewardshipTechService.CancelAccount()', 'CancelAccount');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'CancelAccount';

            bodyStr += '&DonorGUID='+EncodingUtil.urlEncode(input.DonorGUID,'UTF-8');//input.DonorGUID;
            bodyStr += '&AccountGUID='+EncodingUtil.urlEncode(input.AccountGUID,'UTF-8');//input.AccountGUID;

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CancelAccount');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CancelAccount');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CancelAccount');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CancelAccount');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CancelAccount');

        //system.debug(res);
        String jsonResponse = res.getBody();
        CancelAccountResponse cancelAcctResponse = (CancelAccountResponse) JSON.deserialize(jsonResponse, CancelAccountResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(cancelAcctResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(cancelAcctResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(cancelAcctResponse.root.Status.Description);           
        }
        LogService.debug('Exiting StewardshipTechService.CancelAccount()', 'CancelAccount');
        return cancelAcctResponse;
    }
    public class CancelAccountRequest{
        public String DonorGUID {get;set;}
        public String AccountGUID {get;set;}
    }
    public class CancelAccountResponse{
        public CancelAccountResponseRoot Root {get;set;}
    }
    public class CancelAccountResponseRoot{
        public CancelAccountResponseStatus Status {get;set;}
    }
    public class CancelAccountResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    
    public class CancelAccountQueueable implements Queueable, Database.AllowsCallouts {
        public CancelAccountQueueable(){

        }
        public CancelAccountRequest input {get;set;}
        public AccountType acctType {get;set;}
        public String paymentMethodID {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CancelAccountQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CancelAccountQueueable.execute()');
            

            StewardshipTechService.CancelAccountResponse response;
            List<PaymentMethod__c> paymentMethodsToUpdate = new List<PaymentMethod__c>();
            try{
                response = StewardshipTechService.CancelAccount(acctType, input);
                PaymentMethod__c payment = new PaymentMethod__c(id = paymentMethodID);
                if(acctType == AccountType.PAYMENT){
                    payment.StewardshipProcess__c = 'Payment Account: '+response.Root.Status.Description;
                } else if(acctType == AccountType.DISBURSEMENT) {
                    payment.StewardshipProcess__c = 'Disbursment Account: '+response.Root.Status.Description;
                }
                paymentMethodsToUpdate.add(payment);
            } catch (Exception e){
                //System.debug(e);
                paymentMethodsToUpdate.add(new PaymentMethod__c(id = paymentMethodID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(paymentMethodsToUpdate.size()>0){
                update paymentMethodsToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.CancelAccountQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateDesignation https://www.egsnetwork.com/pages/apidoc.php?CreateDesignation
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CreateDesignationResponse CreateDesignation(AccountType acctType, CreateDesignationRequest input) {
        //system.debug('StewardshipTechService.CreateDesignation()');
        LogService.debug('Entering StewardshipTechService.CreateDesignation()', 'CreateDesignation');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'CreateDesignation';

            bodyStr += '&DesignationName='+EncodingUtil.urlEncode(input.DesignationName,'UTF-8');
            bodyStr += '&DesignationDescription='+EncodingUtil.urlEncode(input.DesignationDescription,'UTF-8');
            bodyStr += '&ExternalID='+EncodingUtil.urlEncode(input.ExternalID,'UTF-8');
            bodyStr += '&IsACH='+EncodingUtil.urlEncode(input.IsACH,'UTF-8');

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CreateDesignation');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CreateDesignation');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CreateDesignation');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CreateDesignation');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CreateDesignation');

        //system.debug(res);
        String jsonResponse = res.getBody();
        CreateDesignationResponse createDesResponse = (CreateDesignationResponse) JSON.deserialize(jsonResponse, CreateDesignationResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(createDesResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(createDesResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(createDesResponse.root.Status.Description);            
        }
        LogService.debug('Exiting StewardshipTechService.CreateDesignation()', 'CreateDesignation');
        return createDesResponse;
    }
    public class CreateDesignationRequest{
        public String DesignationName {get;set;}
        public String DesignationDescription {get;set;}
        public String ExternalID {get;set;}
        public String IsACH {get;set;}
    }
    public class CreateDesignationResponse{
        public CreateDesignationResponseRoot Root {get;set;}
    }
    public class CreateDesignationResponseRoot{
        public CreateDesignationResponsStatus Status {get;set;}
        public CreateDesignationResponseDesignation Designation {get;set;}
    }
    public class CreateDesignationResponsStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class CreateDesignationResponseDesignation{
        public String DesignationGUID {get;set;}
    }

    public class CreateDesignationQueueable implements Queueable, Database.AllowsCallouts {
        public CreateDesignationQueueable(){

        }

        public CreateDesignationRequest input {get;set;}
        public AccountType acctType {get;set;}

        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CreateDesignationQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CreateDesignationQueueable.execute()');
            

            StewardshipTechService.CreateDesignationResponse response;
            List<StewardshipTechnologySettings__c> settingsToUpdate = [SELECT PaymentDesignationGUID__c, DisbursementDesignationGUID__c,
                                                        CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,
                                                        SetupOwnerId,SystemModstamp
                                                      FROM StewardshipTechnologySettings__c
                                                      WHERE SetupOwnerId = :UserInfo.getOrganizationID() limit 1];



            try{
                response = StewardshipTechService.CreateDesignation(acctType, input);
                if(acctType == AccountType.PAYMENT) settingsToUpdate[0].PaymentDesignationGUID__c = response.Root.Designation.DesignationGUID;
                if(acctType == AccountType.DISBURSEMENT) settingsToUpdate[0].DisbursementDesignationGUID__c = response.Root.Designation.DesignationGUID;                

            } catch (Exception e){
                System.debug(e);
                if(acctType == AccountType.PAYMENT) settingsToUpdate[0].PaymentDesignationGUID__c = e.getMessage();
                if(acctType == AccountType.DISBURSEMENT) settingsToUpdate[0].DisbursementDesignationGUID__c = e.getMessage();
            }


            if(settingsToUpdate.size()>0){
                update settingsToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.PaymentBatchOpenQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //PaymentBatchOpen https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchOpen
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static PaymentBatchOpenResponse PaymentBatchOpen(AccountType acctType) {
        //system.debug('StewardshipTechService.PaymentBatchOpen()');
        LogService.debug('Entering StewardshipTechService.PaymentBatchOpen()', 'PaymentBatchOpen');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'PaymentBatchOpen';

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'PaymentBatchOpen');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'PaymentBatchOpen');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'PaymentBatchOpen');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'PaymentBatchOpen');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'PaymentBatchOpen');

        //system.debug(res);
        String jsonResponse = res.getBody();
        PaymentBatchOpenResponse paymentBatchOpnResponse = (PaymentBatchOpenResponse) JSON.deserialize(jsonResponse, PaymentBatchOpenResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(paymentBatchOpnResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(paymentBatchOpnResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(paymentBatchOpnResponse.root.Status.Description);          
        }
        LogService.debug('Exiting StewardshipTechService.PaymentBatchOpen()', 'PaymentBatchOpen');
        return paymentBatchOpnResponse;
    }
    public class PaymentBatchOpenResponse{
        public PaymentBatchOpenResponseRoot Root {get;set;}
    }
    public class PaymentBatchOpenResponseRoot{
        public PaymentBatchOpenResponseStatus Status {get;set;}
        public String BatchGUID {get;set;}
    }
    public class PaymentBatchOpenResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class PaymentBatchOpenQueueable implements Queueable, Database.AllowsCallouts {
        public PaymentBatchOpenQueueable(){

        }

        public String stewardshipBatchID {get;set;}
        public AccountType acctType {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.PaymentBatchOpenQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.PaymentBatchOpenQueueable.execute()');
            

            StewardshipTechService.PaymentBatchOpenResponse response;
            List<StewardshipACHBatch__c> stewardshipBatchToUpdate = new List<StewardshipACHBatch__c>();
            try{
                response = StewardshipTechService.PaymentBatchOpen(acctType);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                                                        BatchGUID__c = response.Root.BatchGUID,
                                                                        StewardshipStatus__c = 'PaymentBatch Created',
                                                                        StewardshipProcess__c = response.Root.Status.Description));
            } catch (Exception e){
                System.debug(e);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(stewardshipBatchToUpdate.size()>0){
                update stewardshipBatchToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.PaymentBatchOpenQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreditBatchOpen https://www.egsnetwork.com/pages/apidoc.php?CreditBatchOpen
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CreditBatchOpenResponse CreditBatchOpen(AccountType acctType, CreditBatchOpenRequest input) {
        //system.debug('StewardshipTechService.CreditBatchOpen()');
        LogService.debug('Entering StewardshipTechService.CreditBatchOpen()', 'CreditBatchOpen');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }           
            bodyStr += '&Action='+'CreditBatchOpen';

            bodyStr += '&Format='+'json';
        }

        if(input.ScheduledDate != null && String.isEmpty(input.ScheduledDateString)){
            //System.debug('input.ScheduledDate:'+input.ScheduledDate);
            input.ScheduledDateString = Datetime.newInstance(input.ScheduledDate, Time.newInstance(0,0,0,0)).format('MM/dd/yyyy');

        }
        //System.debug('input.ScheduledDateString:'+input.ScheduledDateString);

        bodyStr += '&ScheduledDate='+input.ScheduledDateString;

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CreditBatchOpen');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CreditBatchOpen');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CreditBatchOpen');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CreditBatchOpen');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CreditBatchOpen');

        //system.debug(res);
        String jsonResponse = res.getBody();
        CreditBatchOpenResponse creditBatchOpnResponse = (CreditBatchOpenResponse) JSON.deserialize(jsonResponse, CreditBatchOpenResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(creditBatchOpnResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(creditBatchOpnResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(creditBatchOpnResponse.root.Status.Description);          
        }
        LogService.debug('Exiting StewardshipTechService.CreditBatchOpen()', 'CreditBatchOpen');
        return creditBatchOpnResponse;
    }

    public class CreditBatchOpenRequest{
        public Date ScheduledDate {get;set;}
        public String ScheduledDateString {get;set;}
    }
    public class CreditBatchOpenResponse{
        public CreditBatchOpenResponseRoot Root {get;set;}
    }
    public class CreditBatchOpenResponseRoot{
        public CreditBatchOpenResponseStatus Status {get;set;}
        public String BatchGUID {get;set;}
    }
    public class CreditBatchOpenResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class CreditBatchOpenQueueable implements Queueable, Database.AllowsCallouts {
        public CreditBatchOpenQueueable(){

        }

        public String stewardshipBatchID {get;set;}
        public AccountType acctType {get;set;}
        public StewardshipTechService.CreditBatchOpenRequest input {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CreditBatchOpenQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CreditBatchOpenQueueable.execute()');
            

            StewardshipTechService.CreditBatchOpenResponse response;
            List<StewardshipACHBatch__c> stewardshipBatchToUpdate = new List<StewardshipACHBatch__c>();
            try{
                response = StewardshipTechService.CreditBatchOpen(acctType, input);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                                                        BatchGUID__c = response.Root.BatchGUID,
                                                                        StewardshipStatus__c = 'CreditBatch Created',
                                                                        StewardshipProcess__c = response.Root.Status.Description));
            } catch (Exception e){
                //System.debug(e);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(stewardshipBatchToUpdate.size()>0){
                update stewardshipBatchToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.CreditBatchOpenQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //PaymentBatchSelect https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchSelect
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static PaymentBatchSelectResponse PaymentBatchSelect(AccountType acctType, PaymentBatchSelectRequest input) {
        //system.debug('StewardshipTechService.PaymentBatchSelect()');
        LogService.debug('Entering StewardshipTechService.PaymentBatchSelect()', 'PaymentBatchSelect');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }
            bodyStr += '&Action='+'PaymentBatchSelect';

            bodyStr += '&BatchGUID='+EncodingUtil.urlEncode(input.BatchGUID,'UTF-8');

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'PaymentBatchSelect');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'PaymentBatchSelect');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'PaymentBatchSelect');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'PaymentBatchSelect');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'PaymentBatchSelect');

        //system.debug(res);
        String jsonResponse = res.getBody();
        //System.debug(res.getBody());
        PaymentBatchSelectResponse paymentBatchSelResponse;
        try{
            paymentBatchSelResponse = (PaymentBatchSelectResponse) JSON.deserialize(jsonResponse, PaymentBatchSelectResponse.class);            

        } catch (Exception e){
            if(e.getMessage().startsWith('Expected List')){
                //transform single response into a list
                String keyString1 = ':{"BatchItem":{';
                String replaceKeyString1 = ':{"BatchItem":[{';
                String keyString2 = '}}}}';
                String replaceKeyString2 = '}]}}}';
                String replacedJSON = jsonResponse.subStringBefore(keyString1) + replaceKeyString1 + jsonResponse.subStringAfter(keyString1);
                //System.debug(replacedJSON);
                replacedJSON = replacedJSON.subStringBefore(keyString2) + replaceKeyString2 + replacedJSON.subStringAfter(keyString2);
                //System.debug(replacedJSON);
                paymentBatchSelResponse = (PaymentBatchSelectResponse) JSON.deserialize(replacedJSON, PaymentBatchSelectResponse.class);  
            }
        }
        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(paymentBatchSelResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(paymentBatchSelResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(paymentBatchSelResponse.root.Status.Description);          
        }
        LogService.debug('Exiting StewardshipTechService.PaymentBatchOpen()', 'PaymentBatchOpen');
        return paymentBatchSelResponse;

    }
    public class PaymentBatchSelectRequest{
        public String BatchGUID {get;set;}
    }
    public class PaymentBatchSelectResponse{
        public PaymentBatchSelectResponseRoot Root {get;set;}
    }
    public class PaymentBatchSelectResponseRoot{
        public PaymentBatchSelectResponseStatus Status {get;set;}
        public PaymentBatchSelectResponseBatchDetails BatchDetails {get;set;}

    }
    public class PaymentBatchSelectResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }

    public class PaymentBatchSelectResponseBatchDetails{
        public List<PaymentBatchSelectResponseBatchItem> BatchItem {get;set;}
    }

    public class PaymentBatchSelectResponseBatchItem{
        public String BatchGUID {get;set;}
        public String AccountScheduleGUID {get;set;}
        public String AccountGUID {get;set;}
        public String DonorGuid {get;set;}
        public String TransactionGUID {get;set;}
        public String ScheduledDate {get;set;}
        public String TransactionAmount {get;set;}
        public String TransactionStatus {get;set;}
        public String TransactionDate {get;set;}
        public String ReturnDate {get;set;}
        public String ReturnCode {get;set;}
        public String RefundDate {get;set;}
        public String IsRefunded {get;set;}
    }
    public class PaymentBatchSelectSingleResponse{
        public PaymentBatchSelectSingleResponseRoot Root {get;set;}
    }
    public class PaymentBatchSelectSingleResponseRoot{
        public PaymentBatchSelectSingleResponseStatus Status {get;set;}
        public PaymentBatchSelectSingleResponseBatchDetails BatchDetails {get;set;}

    }
    public class PaymentBatchSelectSingleResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }

    public class PaymentBatchSelectSingleResponseBatchDetails{
        public PaymentBatchSelectSingleResponseBatchItem BatchItem {get;set;}
    }

    public class PaymentBatchSelectSingleResponseBatchItem{
        public String BatchGUID {get;set;}
        public String AccountScheduleGUID {get;set;}
        public String AccountGUID {get;set;}
        public String DonorGuid {get;set;}
        public String TransactionGUID {get;set;}
        public String ScheduledDate {get;set;}
        public String TransactionAmount {get;set;}
        public String TransactionStatus {get;set;}
        public String TransactionDate {get;set;}
        public String ReturnDate {get;set;}
        public String ReturnCode {get;set;}
        public String RefundDate {get;set;}
        public String IsRefunded {get;set;}
    }
    public class PaymentBatchSelectQueueable implements Queueable, Database.AllowsCallouts {
        public PaymentBatchSelectQueueable(){

        }

        public String stewardshipBatchID {get;set;}
        public AccountType acctType {get;set;}

        public StewardshipTechService.PaymentBatchSelectRequest input {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.PaymentBatchSelectQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.PaymentBatchSelectQueueable.execute()');
            

            StewardshipTechService.PaymentBatchSelectResponse response;
            Map<ID, StewardshipACHBatch__c> stewardshipBatchMapToUpdate = new Map<ID, StewardshipACHBatch__c>();
            List<StewardshipACHBatchDetail__c> stewardshipBatchDtlToUpdate = new List<StewardshipACHBatchDetail__c>();
            List<StewardshipACHBatchDetail__c> stewardshipBatchDtlToCreate = new List<StewardshipACHBatchDetail__c>();

            try{
                response = StewardshipTechService.PaymentBatchSelect(acctType, input);
                stewardshipBatchMapToUpdate.put(stewardshipBatchID, new StewardshipACHBatch__c(id = stewardshipBatchID,
                                                                        BatchSelectResponse__c = String.valueOf(response),
                                                                        StewardshipProcess__c = 'Selected',
                                                                        LastSelectedDateTime__c = DateTime.now()));

                List<StewardshipACHBatchDetail__c> existingStewardshipBatchDtls = [SELECT id,
                                                                                          BatchGUID__c, 
                                                                                          TransactionGUID__c,
                                                                                          AccountScheduleGUID__c,
                                                                                          PaymentBatchSelectResponse__c
                                                                                  FROM StewardshipACHBatchDetail__c
                                                                                  WHERE BatchGUID__c = :response.root.BatchDetails.BatchItem[0].BatchGUID ];
                //System.debug('result of query:'+existingStewardshipBatchDtls);
                if(existingStewardshipBatchDtls.size()==0){
                    //insert the batchDetailResponse
                    for(StewardshipTechService.PaymentBatchSelectResponseBatchItem batchItem : response.Root.BatchDetails.BatchItem){
                        stewardshipBatchDtlToCreate.add(mapper(batchItem, stewardshipBatchID));
                    }

                } else {
                    //loop through existing records and try to match them
                    for(StewardshipTechService.PaymentBatchSelectResponseBatchItem batchItem : response.Root.BatchDetails.BatchItem){
                        //System.debug('batchItem:'+batchItem);
                        Boolean match = false;
                        for(StewardshipACHBatchDetail__c existingBatchDtl : existingStewardshipBatchDtls){
                            //System.debug('existingBatchDtl:'+existingBatchDtl);

                            if((batchItem.TransactionGUID == existingBatchDtl.TransactionGUID__c) ||
                                (batchItem.AccountScheduleGUID == existingBatchDtl.AccountScheduleGUID__c) /*accountScheduleGUID does not appear unique in sample data set*/){
                                match = true;
                                //System.debug('--Match--');
                                //System.debug('existingBatchDtl:'+existingBatchDtl);
                                //System.debug('batchItem:'+batchItem);
                                existingBatchDtl.PaymentBatchSelectResponse__c = String.valueOf(batchItem);
                                StewardshipACHBatchDetail__c batchDtlToUpdate = mapper(batchItem, stewardshipBatchID);
                                batchDtlToUpdate.id = existingBatchDtl.id;
                                stewardshipBatchDtlToUpdate.add(batchDtlToUpdate);
                                break;
                            }
                        }

                        if(!match){
                            stewardshipBatchDtlToCreate.add(mapper(batchItem, stewardshipBatchID));                            
                        }
                    }
                }
                if(stewardshipBatchDtlToCreate.size()>0){
                    insert stewardshipBatchDtlToCreate;
                }
                if(stewardshipBatchDtlToUpdate.size()>0){
                    update stewardshipBatchDtlToUpdate;
                }
            } catch (Exception e){
                System.debug(e);
                stewardshipBatchMapToUpdate.put(stewardshipBatchID, new StewardshipACHBatch__c(id = stewardshipBatchID,
                                              StewardshipProcess__c = e.getMessage()));
            }

            if(stewardshipBatchMapToUpdate.size()>0){
                update stewardshipBatchMapToUpdate.values();
            }




            LogService.debug('Exiting StewardshipTechService.PaymentBatchSelectQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }

        public StewardshipACHBatchDetail__c mapper(StewardshipTechService.PaymentBatchSelectResponseBatchItem batchItem, String stewardshipBatchID){
            Decimal txAmount = 0;
            if(batchItem.TransactionAmount != null){
                try{
                    txAmount = Decimal.valueof(batchItem.TransactionAmount);                    
                } catch (Exception e){
                    System.debug(e.getMessage());
                }

            }
            //System.debug('txAmount1:'+txAmount);
            return new StewardshipACHBatchDetail__c(StewardshipACHBatch__c = stewardshipBatchID,
                                                     BatchGUID__c = batchItem.BatchGUID,
                                                     AccountScheduleGUID__c = batchItem.AccountScheduleGUID,
                                                     PaymentBatchSelectResponse__c = String.valueOf(batchItem),
                                                     TransactionGUID__c = batchItem.TransactionGUID,
                                                     TransactionDate__c = DateTime.now(),
                                                     TransactionStatus__c = batchItem.TransactionStatus,
                                                     TransactionAmount__c = txAmount,
                                                     ReturnDate__c = DateTime.now(),
                                                     ReturnCode__c = batchItem.ReturnCode,
                                                     RefundDate__c = DateTime.now(),
                                                     IsRefunded__c = batchItem.IsRefunded,
                                                     DonorGUID__c = batchItem.DonorGUID,
                                                     AccountGUID__c = batchITem.AccountGUID,
                                                     ScheduledDate__c = Date.Today());
        }
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //PaymentBatchApprove https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchApprove
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static PaymentBatchApproveResponse PaymentBatchApprove(AccountType acctType, PaymentBatchApproveRequest input) {
        //system.debug('StewardshipTechService.PaymentBatchApprove()');
        LogService.debug('Entering StewardshipTechService.PaymentBatchApprove()', 'PaymentBatchApprove');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'PaymentBatchApprove';

            bodyStr += '&BatchGUID='+EncodingUtil.urlEncode(input.BatchGUID,'UTF-8');

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'PaymentBatchApprove');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'PaymentBatchApprove');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'PaymentBatchApprove');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'PaymentBatchApprove');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'PaymentBatchApprove');

        //system.debug(res);
        String jsonResponse = res.getBody();
        PaymentBatchApproveResponse paymentBatchApprResponse = (PaymentBatchApproveResponse) JSON.deserialize(jsonResponse, PaymentBatchApproveResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(paymentBatchApprResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(paymentBatchApprResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(paymentBatchApprResponse.root.Status.Description);         
        }
        LogService.debug('Exiting StewardshipTechService.PaymentBatchApprove()', 'PaymentBatchApprove');
        return paymentBatchApprResponse;
    }
    public class PaymentBatchApproveRequest{
        public String BatchGUID {get;set;}
    }
    public class PaymentBatchApproveResponse{
        public PaymentBatchSelectResponseRoot Root {get;set;}
    }
    public class PaymentBatchApproveResponseRoot{
        public PaymentBatchSelectResponseStatus Status {get;set;}

    }
    public class PaymentBatchApproveResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }

    public class PaymentBatchApproveQueueable implements Queueable, Database.AllowsCallouts {
        public PaymentBatchApproveQueueable(){

        }

        public String stewardshipBatchID {get;set;}
        public AccountType acctType {get;set;}
        public StewardshipTechService.PaymentBatchApproveRequest input {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.PaymentBatchApproveQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.PaymentBatchApproveQueueable.execute()');
            

            StewardshipTechService.PaymentBatchApproveResponse response;
            List<StewardshipACHBatch__c> stewardshipBatchToUpdate = new List<StewardshipACHBatch__c>();
            try{
                response = StewardshipTechService.PaymentBatchApprove(acctType, input);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                                                        StewardshipStatus__c = 'Approved',
                                                                        StewardshipProcess__c = response.Root.Status.Description));
            } catch (Exception e){
                System.debug(e);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(stewardshipBatchToUpdate.size()>0){
                update stewardshipBatchToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.PaymentBatchApproveQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //PaymentBatchCancel https://www.egsnetwork.com/pages/apidoc.php?PaymentBatchCancel
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static PaymentBatchCancelResponse PaymentBatchCancel(AccountType acctType, PaymentBatchCancelRequest input) {
        //system.debug('StewardshipTechService.PaymentBatchCancel()');
        LogService.debug('Entering StewardshipTechService.PaymentBatchCancel()', 'PaymentBatchCancel');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'PaymentBatchCancel';

            bodyStr += '&BatchGUID='+EncodingUtil.urlEncode(input.BatchGUID,'UTF-8');

            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'PaymentBatchCancel');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'PaymentBatchCancel');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'PaymentBatchCancel');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'PaymentBatchCancel');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'PaymentBatchCancel');

        //system.debug(res);
        String jsonResponse = res.getBody();
        PaymentBatchCancelResponse paymentBatchCancResponse = (PaymentBatchCancelResponse) JSON.deserialize(jsonResponse, PaymentBatchCancelResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(paymentBatchCancResponse);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(paymentBatchCancResponse.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(paymentBatchCancResponse.root.Status.Description);         
        }
        LogService.debug('Exiting StewardshipTechService.PaymentBatchCancel()', 'PaymentBatchCancel');
        return paymentBatchCancResponse;
    }
    public class PaymentBatchCancelRequest{
        public String BatchGUID {get;set;}
    }
    public class PaymentBatchCancelResponse{
        public PaymentBatchCancelResponseRoot Root {get;set;}
    }
    public class PaymentBatchCancelResponseRoot{
        public PaymentBatchCancelResponseStatus Status {get;set;}

    }
    public class PaymentBatchCancelResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }

    public class PaymentBatchCancelQueueable implements Queueable, Database.AllowsCallouts {
        public PaymentBatchCancelQueueable(){

        }

        public String stewardshipBatchID {get;set;}
        public AccountType acctType {get;set;}
        public StewardshipTechService.PaymentBatchCancelRequest input {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.PaymentBatchCancelQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.PaymentBatchCancelQueueable.execute()');
            

            StewardshipTechService.PaymentBatchCancelResponse response;
            List<StewardshipACHBatch__c> stewardshipBatchToUpdate = new List<StewardshipACHBatch__c>();
            try{
                response = StewardshipTechService.PaymentBatchCancel(acctType, input);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                                                        StewardshipStatus__c = 'Cancelled',
                                                                        StewardshipProcess__c = response.Root.Status.Description));
            } catch (Exception e){
                System.debug(e);
                stewardshipBatchToUpdate.add(new StewardshipACHBatch__c(id = stewardshipBatchID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(stewardshipBatchToUpdate.size()>0){
                update stewardshipBatchToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.PaymentBatchCancelQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateTransaction https://www.egsnetwork.com/pages/apidoc.php?CreateTransaction
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CreateTransactionResponse CreateTransaction(AccountType acctType, CreateTransactionRequest input) {
        //system.debug('StewardshipTechService.CreateTransaction()');
        LogService.debug('Entering StewardshipTechService.CreateTransaction()', 'CreateTransaction');
        //System.debug('input:'+input);


        if(String.isEmpty(input.Memo1)) throw new StewardshipTechServiceException('Memo1 is Required');

        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');
                bodyStr += '&DesignationGUID1='+EncodingUtil.urlEncode(StewardshipTechnologySettings__c.getInstance().PaymentDesignationGUID__c,'UTF-8');
            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
                bodyStr += '&DesignationGUID1='+EncodingUtil.urlEncode(StewardshipTechnologySettings__c.getInstance().DisbursementDesignationGUID__c,'UTF-8');
            }            
            bodyStr += '&Action='+'CreateTransaction';

            bodyStr += '&BatchGUID='+EncodingUtil.urlEncode(input.BatchGUID,'UTF-8');
            bodyStr += '&DonorGUID='+EncodingUtil.urlEncode(input.DonorGUID,'UTF-8');
            bodyStr += '&AccountGUID='+EncodingUtil.urlEncode(input.AccountGUID,'UTF-8');
            if(input.Amount1 != null && String.isEmpty(input.Amount1String)){
                input.Amount1String = String.valueOf(input.Amount1);
            }

            bodyStr += '&Amount1='+EncodingUtil.urlEncode(input.Amount1String,'UTF-8');
            bodyStr += '&Memo1='+EncodingUtil.urlEncode(input.Memo1,'UTF-8');

            bodyStr += '&RecurringType='+EncodingUtil.urlEncode(input.RecurringType,'UTF-8');

            if(input.ScheduledDate != null && String.isEmpty(input.ScheduledDateString)){
                //System.debug('input.ScheduledDate:'+input.ScheduledDate);
                input.ScheduledDateString = Datetime.newInstance(input.ScheduledDate, Time.newInstance(0,0,0,0)).format('MM/dd/yyyy');

            }
            //System.debug('input.ScheduledDateString:'+input.ScheduledDateString);

            bodyStr += '&ScheduledDate='+EncodingUtil.urlEncode(input.ScheduledDateString,'UTF-8');


            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        req.setTimeout(30000);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CreateTransaction');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CreateTransaction');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CreateTransaction');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CreateTransaction');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CreateTransaction');

        //system.debug(res);
        String jsonResponse = res.getBody();
        jsonResponse = jsonResponse.replace('"Transaction"', '"Transaction_x"');
        //System.debug(jsonResponse);
        CreateTransactionResponse createTrans = (CreateTransactionResponse) JSON.deserialize(jsonResponse, CreateTransactionResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(createTrans);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(createTrans.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(createTrans.root.Status.Description);          
        }
        LogService.debug('Exiting StewardshipTechService.CreateTransaction()', 'CreateTransaction');
        return createTrans;
    }

    public class CreateTransactionRequest{
        public String BatchGUID {get;set;}
        public String DonorGUID {get;set;}
        public String AccountGUID {get;set;}
        public Decimal Amount1 {get;set;}
        public String Amount1String {get;set;}
        public String Memo1 {get;set;}
        public String DesignationGUID1 {get;set;}
        public String RecurringType {get;set;}
        public Date ScheduledDate {get;set;}
        public String ScheduledDateString {get;set;}


    }
    public class CreateTransactionResponse{
        public CreateTransactionResponseRoot Root {get;set;}
    }
    public class CreateTransactionResponseRoot{
        public CreateTransactionResponseStatus Status {get;set;}
        public CreateTransactionResponseTransaction Transaction_x {get;set;}

    }
    public class CreateTransactionResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class CreateTransactionResponseTransaction{
        public String AccountScheduleGUID {get;set;}
    }

    public class CreateTransactionQueueable implements Queueable, Database.AllowsCallouts {
        public CreateTransactionQueueable(){

        }

        public String stewardshipBatchDetailID {get;set;}
        public AccountType acctType {get;set;}
        public StewardshipTechService.CreateTransactionRequest input {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CreateTransactionQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CreateTransactionQueueable.execute()');
            

            StewardshipTechService.CreateTransactionResponse response;
            List<StewardshipACHBatchDetail__c> stewardshipBatchToUpdate = new List<StewardshipACHBatchDetail__c>();
            try{
                response = StewardshipTechService.CreateTransaction(acctType, input);
                stewardshipBatchToUpdate.add(new StewardshipACHBatchDetail__c(id = stewardshipBatchDetailID,
                                                                              AccountScheduleGUID__c = response.Root.Transaction_x.AccountScheduleGUID,
                                                                              StewardshipProcess__c = 'Created',
                                                                              StewardshipStatus__c = 'Created'));
            } catch (Exception e){
                //System.debug(e);
                stewardshipBatchToUpdate.add(new StewardshipACHBatchDetail__c(id = stewardshipBatchDetailID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(stewardshipBatchToUpdate.size()>0){
                update stewardshipBatchToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.CreateTransactionQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CreateCreditTransaction https://www.egsnetwork.com/pages/apidoc.php?CreateCreditTransaction
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CreateCreditTransactionResponse CreateCreditTransaction(AccountType acctType, CreateCreditTransactionRequest input) {
        //system.debug('StewardshipTechService.CreateCreditTransaction()');
        LogService.debug('Entering StewardshipTechService.CreateCreditTransaction()', 'CreateCreditTransaction');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'CreateCreditTransaction';

            bodyStr += '&BatchGUID='+EncodingUtil.urlEncode(input.BatchGUID,'UTF-8');
            bodyStr += '&DonorGUID='+EncodingUtil.urlEncode(input.DonorGUID,'UTF-8');
            bodyStr += '&AccountGUID='+EncodingUtil.urlEncode(input.AccountGUID,'UTF-8');
            if(input.Amount != null && String.isEmpty(input.AmountString)){
                input.AmountString = String.valueOf(input.Amount);
            }
            bodyStr += '&Amount='+EncodingUtil.urlEncode(input.AmountString,'UTF-8');
            bodyStr += '&Memo='+EncodingUtil.urlEncode(input.Memo,'UTF-8');
            bodyStr += '&CompanyEntryDescription='+EncodingUtil.urlEncode(input.CompanyEntryDescription.left(10), 'UTF-8');




            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        req.setTimeout(30000);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CreateCreditTransaction');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CreateCreditTransaction');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CreateCreditTransaction');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CreateCreditTransaction');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CreateCreditTransaction');

        //system.debug(res);
        String jsonResponse = res.getBody();
        jsonResponse = jsonResponse.replace('"Transaction"', '"Transaction_x"');
        //System.debug(jsonResponse);
        CreateCreditTransactionResponse createTrans = (CreateCreditTransactionResponse) JSON.deserialize(jsonResponse, CreateCreditTransactionResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(createTrans);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(createTrans.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(createTrans.root.Status.Description);          
        }
        LogService.debug('Exiting StewardshipTechService.CreateCreditTransaction()', 'CreateCreditTransaction');
        return createTrans;
    }

    public class CreateCreditTransactionRequest{
        public String BatchGUID {get;set;}
        public String DonorGUID {get;set;}
        public String AccountGUID {get;set;}
        public Decimal Amount {get;set;}
        public String AmountString {get;set;}
        public String Memo {get;set;}
        public String CompanyEntryDescription {get;set;}


    }
    public class CreateCreditTransactionResponse{
        public CreateCreditTransactionResponseRoot Root {get;set;}
    }
    public class CreateCreditTransactionResponseRoot{
        public CreateCreditTransactionResponseStatus Status {get;set;}
        public CreateCreditTransactionResponseTransaction Transaction_x {get;set;}

    }
    public class CreateCreditTransactionResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }
    public class CreateCreditTransactionResponseTransaction{
        public String AccountScheduleGUID {get;set;}
    }

    public class CreateCreditTransactionQueueable implements Queueable, Database.AllowsCallouts {
        public CreateCreditTransactionQueueable(){

        }

        public String stewardshipBatchDetailID {get;set;}
        public AccountType acctType {get;set;}
        public StewardshipTechService.CreateCreditTransactionRequest input {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CreateCreditTransactionQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CreateCreditTransactionQueueable.execute()');
            

            StewardshipTechService.CreateCreditTransactionResponse response;
            List<StewardshipACHBatchDetail__c> stewardshipBatchToUpdate = new List<StewardshipACHBatchDetail__c>();
            try{
                response = StewardshipTechService.CreateCreditTransaction(acctType, input);
                stewardshipBatchToUpdate.add(new StewardshipACHBatchDetail__c(id = stewardshipBatchDetailID,
                                                                              AccountScheduleGUID__c = response.Root.Transaction_x.AccountScheduleGUID,
                                                                              StewardshipProcess__c = 'Credit Transaction Created',
                                                                              StewardshipStatus__c = 'Credit Transaction Created'));
            } catch (Exception e){
                //System.debug(e);
                stewardshipBatchToUpdate.add(new StewardshipACHBatchDetail__c(id = stewardshipBatchDetailID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(stewardshipBatchToUpdate.size()>0){
                update stewardshipBatchToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.CreateCreditTransactionQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //CancelTransaction https://www.egsnetwork.com/pages/apidoc.php?CancelTransaction
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    public static CancelTransactionResponse CancelTransaction(AccountType acctType, CancelTransactionRequest input) {
        //system.debug('StewardshipTechService.CancelTransaction()');
        LogService.debug('Entering StewardshipTechService.CancelTransaction()', 'CancelTransaction');
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : StewardshipTechnologySettings__c.getInstance().Endpoint__c;
        
        String bodyStr = '';
        if(!Test.isRunningTest()){
            if(acctType == AccountType.PAYMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipPaymentMerchKey'),'UTF-8');

            } else if(acctType == AccountType.DISBURSEMENT){
                bodyStr += 'MerchUserName='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementUser'),'UTF-8');
                bodyStr += '&MerchPassword='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementPassword'),'UTF-8');
                bodyStr += '&MerchKey='+EncodingUtil.urlEncode(SecureSettings.getValue('StewardshipDisbursementMerchKey'),'UTF-8');                
            }            
            bodyStr += '&Action='+'CancelTransaction';
            bodyStr += '&AccountScheduleGUID='+EncodingUtil.urlEncode(input.AccountScheduleGUID,'UTF-8');
            bodyStr += '&DonorGUID='+EncodingUtil.urlEncode(input.DonorGUID,'UTF-8');
            bodyStr += '&Format='+'json';
        }

        //System.debug(urlStr);
        req.setEndpoint(urlStr);
        //System.debug(bodyStr);
        req.setBody(bodyStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        //LogService.critical('Stewardship Technology Request Body:'+req.getBody(), 'CancelTransaction');
        LogService.critical('Stewardship Technology Endpoint:'+req.getEndpoint(), 'CancelTransaction');
        HttpResponse res = h.send(req);
        LogService.critical('Stewardship Technology  Response Body:'+res.getBody(), 'CancelTransaction');
        LogService.critical('Stewardship Technology Response Status:'+res.getStatus(), 'CancelTransaction');
        LogService.critical('Stewardship Technology Response Status Code:'+res.getStatusCode(), 'CancelTransaction');

        //system.debug(res);
        String jsonResponse = res.getBody();

        CancelTransactionResponse cancelTrans = (CancelTransactionResponse) JSON.deserialize(jsonResponse, CancelTransactionResponse.class);

        //system.debug(res.getBody());
        //system.debug(res);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(cancelTrans);

        if(res.getStatusCode()>200){
           throw new StewardshipTechServiceException(String.valueOf(res)+':'+res.getBody());
        }
        if(cancelTrans.root.Status.ErrorCode != '0'){
           throw new StewardshipTechServiceException(cancelTrans.root.Status.Description);          
        }
        LogService.debug('Exiting StewardshipTechService.CancelTransaction()', 'CancelTransaction');
        return cancelTrans;
    }

    public class CancelTransactionRequest{
        public String DonorGUID {get;set;}
        public String AccountScheduleGUID {get;set;}
    }
    public class CancelTransactionResponse{
        public CancelTransactionResponseRoot Root {get;set;}
    }
    public class CancelTransactionResponseRoot{
        public CancelTransactionResponseStatus Status {get;set;}
    }
    public class CancelTransactionResponseStatus{
        public String ErrorCode {get;set;}
        public String Description {get;set;}
    }


    public class CancelTransactionQueueable implements Queueable, Database.AllowsCallouts {
        public CancelTransactionQueueable(){

        }

        public String stewardshipBatchDetailID {get;set;}
        public AccountType acctType {get;set;}
        public StewardshipTechService.CancelTransactionRequest input {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering StewardshipTechService.CancelTransactionQueueable.execute()', 'Launch Queueable');
            //system.debug('StewardshipTechService.CancelTransactionQueueable.execute()');
            

            StewardshipTechService.CancelTransactionResponse response;
            List<StewardshipACHBatchDetail__c> stewardshipBatchToUpdate = new List<StewardshipACHBatchDetail__c>();
            try{
                response = StewardshipTechService.CancelTransaction(acctType, input);
                stewardshipBatchToUpdate.add(new StewardshipACHBatchDetail__c(id = stewardshipBatchDetailID,
                                                                              StewardshipProcess__c = 'Transaction Cancelled',
                                                                              StewardshipStatus__c = 'Transaction Cancelled'));
            } catch (Exception e){
                //System.debug(e);
                stewardshipBatchToUpdate.add(new StewardshipACHBatchDetail__c(id = stewardshipBatchDetailID,
                                              StewardshipProcess__c = e.getMessage()));
            }


            if(stewardshipBatchToUpdate.size()>0){
                update stewardshipBatchToUpdate;
            }




            LogService.debug('Exiting StewardshipTechService.CancelTransactionQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }

    public class StewardshipTechServiceException extends Exception{}
}