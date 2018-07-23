/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIStudentResource
// 
// Description: 
//  Vemo API start point
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-17   Greg Cook       Added params and body to APIInfo                              
// 2016-12-24   Greg Cook       Added Test.isRunningTest() logic
/////////////////////////////////////////////////////////////////////////
@RestResource(urlMapping='/vemo/*')
global with sharing class VemoAPI  {
    @HttpGet
    global static Response doGet()
    {
        LogService.fine('VemoAPI.doGet()', null);
        Response res = response();
        LogService.writeLogs();
        return res;
    }
    @HttpPost
    global static Response doPost()
    {
        LogService.fine('VemoAPI.doPost()', null);
        Response res = response();
        LogService.writeLogs();
        return res;
    }
    @HttpPut
    global static Response doPut()
    {
        LogService.fine('VemoAPI.doPut()', null);
        Response res = response();
        LogService.writeLogs();
        return res;
    }
    @HttpDelete
    global static Response doDelete()
    {
        LogService.fine('VemoAPI.doDelete()', null);
        Response res = response();
        LogService.writeLogs();
        return res;
    }
    public static Response response()
    {
        try {
            return respond();
        } catch(Exception e){
            return respondToException(e);
        }
    }
    virtual global class Response {} 
    global class FaultResponse extends Response {
        public Object fault;

        public FaultResponse(Exception exc) {
            this.fault = exc.getMessage();
            System.debug(exc);
            System.debug(exc.getStackTraceString());
        }     
    }
    global class ResultResponse extends Response {
        public Object result;
        public Object numberOfResults;
        public ResultResponse(){

        }
        public ResultResponse(Object result) {
            this.result = result;
        }
        public ResultResponse(Object result, Integer num){
            this.result = result;
            this.numberOfResults = num;
        }           
    } 

    public static APIInfo internalAPI;

    public static Response respond(){
        System.debug('VemoApi.respond()');

        try{
            APIInfo api;
            if(internalAPI!= null){
                api = internalAPI;
            } else {
                api = new APIInfo(RestContext.request);
            }

            System.debug('api:'+api);
            if(api.resource == 'student'){
                if(Test.isRunningTest()){                    
                    return new ResultResponse(new List<String>{'handling student'});
                }
                return (Response)(VemoAPIStudentResource.handleAPI(api));
            }
            else if(api.resource == 'references'){
                if(Test.isRunningTest()){                    
                    return new ResultResponse(new List<String>{'handling references'});
                }
                return (Response)(VemoAPIReferenceResource.handleAPI(api));
            }          
            else if(api.resource == 'program'){
                if(Test.isRunningTest()){                    
                    return new ResultResponse(new List<String>{'handling program'});
                }
                return (Response)(VemoAPIProgramResource.handleAPI(api));
            }
            else if(api.resource == 'school'){
                if(Test.isRunningTest()){                    
                    return new ResultResponse(new List<String>{'handling school'});
                }
                return (Response)(VemoAPISchoolResource.handleAPI(api));
            }
            else if(api.resource == 'creditcheck'){
                if(Test.isRunningTest()){                    
                    return new ResultResponse(new List<String>{'handling creditcheck'});
                }
                return(Response)(VemoAPICreditCheckResource.handleAPI(api));
            }
            else if(api.resource == 'attachment'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling attachment'});
                }
                system.debug('attachment route');
                return(Response)(VemoAPIAttachmentResource.handleAPI(api));               
            }
            else if(api.resource == 'agreement'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling agreement'});
                }
                system.debug('agreement route');
                return(Response)(VemoAPIAgreementResource.handleAPI(api));               
            }
            else if(api.resource == 'offer'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling offer'});
                }
                system.debug('offers route');
                return(Response)(VemoAPIOfferResource.handleAPI(api));               
            }   
            else if(api.resource == 'disbursement'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling disbursement'});
                }
                system.debug('disbursement route');
                return(Response)(VemoAPIDisbursementResource.handleAPI(api));               
            }
            else if(api.resource == 'disbursementrefund'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling disbursementrefund'});
                }
                system.debug('disbursement refund route');
                return(Response)(VemoAPIDisbursementRefundResource.handleAPI(api));               
            }
            else if(api.resource == 'case'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling case'});
                }
                system.debug('case route');
                return(Response)(VemoAPICaseResource.handleAPI(api));               
            }
            else if(api.resource == 'reconciliation'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling reconciliation'});
                }
                system.debug('reconciliation route');
                return(Response)(VemoAPIReconciliationResource.handleAPI(api));               
            }
            else if(api.resource == 'programofstudy'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling programofstudy'});
                }
                system.debug('programOfStudy route');
                return(Response)(VemoAPIProgramOfStudyResource.handleAPI(api));               
            }
            else if(api.resource == 'programeligibility'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling programeligibility'});
                }
                system.debug('programeligibility route');
                return(Response)(VemoAPIProgramEligibilityResource.handleAPI(api));               
            }
            else if(api.resource == 'contractterms'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling contractterms'});
                }
                system.debug('contractterms route');
                return(Response)(VemoAPIContractTermsResource.handleAPI(api));               
            }
            else if(api.resource == 'employmenthistory'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling employmenthistory'});
                }
                system.debug('employmenthistory route');
                return(Response)(VemoAPIEmployeeHistoryResource.handleAPI(api));               
            }
            else if(api.resource == 'incomeverification'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling incomeverification'});
                }
                system.debug('incomeverification route');
                return(Response)(VemoAPIIncomeVerificationResource.handleAPI(api));               
            }
            else if(api.resource == 'paymentmethod'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling paymentmethod'});
                }
                system.debug('paymentmethod route');
                return(Response)(VemoAPIPaymentMethodResource.handleAPI(api));               
            }
            else if(api.resource == 'notification'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling notification'});
                }
                system.debug('notification route');
                return(Response)(VemoAPINotificationResource.handleAPI(api));               
            }            
            else if(api.resource == 'paymentinstruction'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling paymentinstruction'});
                }
                system.debug('paymentinstruction route');
                return(Response)(VemoAPIPaymentInstructionResource.handleAPI(api));               
            }  
           else if(api.resource == 'statement'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling statement'});
                }
                system.debug('statement route');
                return(Response)(VemoAPIStatementResource.handleAPI(api));               
            }  
           else if(api.resource == 'fee'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling fee'});
                }
                system.debug('fee route');
                return(Response)(VemoAPIFeeResource.handleAPI(api));               
            }  
           else if(api.resource == 'ledger'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling ledger'});
                }
                system.debug('ledger route');
                return(Response)(VemoAPILedgerResource.handleAPI(api));               
            }  
           else if(api.resource == 'genericDocument'){
                if(Test.isRunningTest()){                    
                        return new ResultResponse(new List<String>{'handling genericDocument'});
                }
                system.debug('genericDocument route');
                return(Response)(VemoAPIGenericDocumentResource.handleAPI(api));               
            } 
        } catch (Exception e){
            throw new VemoAPIFaultException('Unexpected Fault: ' + e.getMessage());
        }
        throw new VemoAPIFaultException('Unsupported URI: ' + RestContext.request.httpMethod + ':' + RestContext.request.requestURI);
        return null;
    }

    public static Response respondToException(Exception exc) { 
        if(internalAPI == null){
            RestResponse res = RestContext.response; 
            res.statusCode = 500;            
        } else {
           throw new VemoAPIFaultException(exc.getMessage()); 
        }                                   

       return new FaultResponse(exc);                                              
    }
    public class VemoAPIFaultException extends Exception {} 

    public Interface ResourceHandler{
        Object handleAPI(APIInfo api); 
    }
    public static Set<ID> parseParameterIntoIDSet(String param){
        List<String> paramList = EncodingUtil.urlDecode(param, 'UTF-8').split(',');
        Set<ID> ids = new Set<ID>();
        for(String str : paramList){
            ids.add((ID)str);
        }
        return ids;      
    }
    public static Set<String> parseParameterIntoStringSet(String param){
        List<String> paramList = EncodingUtil.urlDecode(param, 'UTF-8').split(',');
        Set<String> strs = new Set<String>();
        for(String str : paramList){
            strs.add(str);
        }
        return strs;      
    }
    public class InternalRequest{
        public Map<String, String> headers {get;set;}
        public Map<String, String> params {get;set;}
        public String requestURI {get;set;}
        public String httpMethod {get;set;}
        public String remoteAddress {get;set;}
        public String resourcePath {get;set;}
        public Blob requestBody {get;set;}
        public InternalRequest(){}
    }

    public class APIInfo{        
        public String version {get;set;}
        public String resource {get;set;}
        public String method {get;set;}
        public Map<String,String> params {get;set;}
        public String body {get;set;}
        public Blob blobBody {get;set;}
        String vemoAuth;
        public String studentAuthID {get;set;}
        public String studentPersonAccountID {get;set;}
        final String VEMOAPI_V1_ROUTE = '/vemo/v1/';
        public APIInfo(){}
        public APIInfo(InternalRequest req){
            system.debug('VemoAPI.APIInfo(InternalRequest)');
            system.debug('req:'+req);
            version = null;
            resource = null;
            method = null;
            params = req.params;
            if(req.requestBody != null){
                try{
                    body = req.requestBody.toString();                    
                } catch (Exception e){
                    body = null;
                    blobBody = req.requestBody;
                }

            }
            if(req.requestURI.startsWith(VEMOAPI_V1_ROUTE)){

                version = 'v1';
                resource = req.requestURI.substringAfter(VEMOAPI_V1_ROUTE).removeEnd('/'); 
            }
            method = req.httpMethod;
            
            /*Bypass Vemo Decrypt for Internal Calls
            //Bypass decrypt vemo_auth for the following use cases
            if(method == 'GET' && resource == 'student' && params.containsKey('email')){
                //1) Getting a student by email
            } else if(method == 'GET' && resource == 'disbursement' && params.containsKey('schoolID')){
                //2) Getting all disbursements by school id
            }
            else if (req.params.containsKey('VEMO_AUTH')){
                vemoAuth = params.get('VEMO_AUTH');
                decryptVemoAuth(this);
                system.debug('studentAuthID:'+studentAuthID);
                system.debug('studentPersonAccountID:'+studentPersonAccountID);

            } else{
                throw new VemoAPIFaultException('Request does not contain valid authorization param.');
            }  
            */


            String apiInfoString = '';
            apiInfoString += 'HTTP Method:'+req.httpMethod;
            apiInfoString += '\nRequestURI:'+req.requestURI;

            
            apiInfoString += '\n\nParams:\n';
            for(String param : req.params.keySet()){
                apiInfoString += (param + ':'+ req.params.get(param) + '\n');
            }  
            apiInfoString += '\nHeaders:\n';
            for(String hdr : req.headers.keySet()){
                apiInfoString += (hdr + ':'+ req.headers.get(hdr) + '\n');
            }  
            apiInfoString += '\nResource Path:'+req.resourcePath;    
            apiInfoString += '\nRemote Address:'+req.remoteAddress;
            //apiInfoString += '\nRequest Body:'+req.requestBody.toString();       
            LogService.fine(apiInfoString, null);      

        }
        public APIInfo(RestRequest req){            
            system.debug('VemoAPI.APIInfo(req)');
            system.debug('req:'+req);
            version = null;
            resource = null;
            method = null;
            params = req.params;
            if(req.requestBody != null){
                try{
                    body = req.requestBody.toString();                    
                } catch (Exception e){
                    body = null;
                    blobBody = req.requestBody;
                }

            }
            if(req.requestURI.startsWith(VEMOAPI_V1_ROUTE)){

                version = 'v1';
                resource = RestContext.request.requestURI.substringAfter(VEMOAPI_V1_ROUTE).removeEnd('/'); 
            }
            method = RestContext.request.httpMethod;
            
            //Bypass decrypt vemo_auth for the following use cases
            if(method == 'GET' && resource == 'student' && params.containsKey('email')){
                //1) Getting a student by email
            } else if (req.params.containsKey('VEMO_AUTH')){
                vemoAuth = params.get('VEMO_AUTH');
                decryptVemoAuth(this);
                system.debug('studentAuthID:'+studentAuthID);
                system.debug('studentPersonAccountID:'+studentPersonAccountID);

            } else{
                throw new VemoAPIFaultException('Request does not contain valid authorization param.');
            }  


            String apiInfoString = '';
            apiInfoString += 'HTTP Method:'+req.httpMethod;
            apiInfoString += '\nRequestURI:'+req.requestURI;

            
            apiInfoString += '\n\nParams:\n';
            for(String param : req.params.keySet()){
                apiInfoString += (param + ':'+ req.params.get(param) + '\n');
            }  
            apiInfoString += '\nHeaders:\n';
            for(String hdr : req.headers.keySet()){
                apiInfoString += (hdr + ':'+ req.headers.get(hdr) + '\n');
            }  
            apiInfoString += '\nResource Path:'+req.resourcePath;    
            apiInfoString += '\nRemote Address:'+req.remoteAddress;
            //apiInfoString += '\nRequest Body:'+req.requestBody.toString();       
            LogService.fine(apiInfoString, null);      

        }

        private void decryptVemoAuth(APIInfo api){
            System.debug('VemoAPI.decryptVemoAuth()');
            String studentAuthID;
            System.debug('api:'+api);
            System.debug('vemoAuth:'+vemoAuth);
            if((GlobalSettings.getSettings().allowTestStudent)&&(vemoAuth.startsWith('testStudent_')) || Test.isRunningTest()){
                studentAuthID = vemoAuth.removeStart('testStudent_');
                Set<String> authIDs = new Set<String>{studentAuthID};
                /*
                DatabaseUtil.runQueriesInUserMode = false;
                Map<String,Account> studentMap = AccountQueries.getStudentMapByAuthIDWithAuthID(authIDs);
                if(studentMap.size() >= 1){
                    api.studentPersonAccountID = studentMap.values()[0].id;
                }
                */

            } else {
                try{
                    Blob vemoAuthBlob = EncodingUtil.convertFromHex(vemoAuth);
                    Blob initVector = Blob.valueOf('randomtextstring'); //this is a common secret across the applicaitons
                    BLob key = EncodingUtil.convertFromHex('c6ea9a21d14287be9f34ccd1f86854e6f29a74b1ad3df365c6d23bda7b86f08a'); //this is the aes key generated from python
                    Blob decrypted = Crypto.decrypt('AES256', key, initVector, vemoAuthBlob);
                    String decryptedString = decrypted.toString();

//                    if(decryptedString == 'userID'){
//
//                    } else {
//                        throw new VemoAPIFaultException('Request does not contain valid VEMO_AUTH param: '+ vemoAuth + ':' + decryptedString + ':'+key+ ':'+vemoAuthBlob);
//                    }
                    studentAuthID = decryptedString;                    
                } catch (Exception e){
                    throw new VemoAPIFaultException('Improperly formated VEMO_AUTH:'+e.getMessage());
                }
            }
            if(api.method == 'POST' && api.resource == 'student') {
                //creating student
                api.studentAuthID = studentAuthID;
                DatabaseUtil.runQueriesInUserMode = false;
            } else if (api.method == 'GET' && api.resource == 'student'){
                //let an unauthorized user get a list of all students for the matching of new students
                DatabaseUtil.runQueriesInUserMode = false;
            }  else if (api.method == 'GET' && api.resource == 'school'){
                //let an unauthorized user get a list of all schools
                DatabaseUtil.runQueriesInUserMode = false;
            } else {
                //Get the student ID that matches this vemoAuth
                Set<String> authIDs = new Set<String>{studentAuthID};

                DatabaseUtil.runQueriesInUserMode = false;
                Map<String,Account> studentMap = AccountQueries.getStudentMapByAuthIDWithAuthID(authIDs);

                if(studentMap.size() == 1){
                    api.studentPersonAccountID = studentMap.values()[0].id;
                    api.studentAuthID = studentAuthID;
                    DatabaseUtil.filterByStudentID = true;
                    DatabaseUtil.studentPersonAccountID = studentMap.values()[0].id;
                    if(String.isNotEmpty(studentMap.values()[0].PrimarySchool__pc)){
                        DatabaseUtil.filterBySchoolID = true;
                        DatabaseUtil.schoolID = studentMap.values()[0].PrimarySchool__pc;  
                        system.debug('DatabaseUtil.schoolID:'+DatabaseUtil.schoolID);                      
                    }
                } else {
                    throw new VemoAPIFaultException('invalid VEMO_AUTH param');                    
                }

            }
        }
    }
    public without sharing class SystemContext{
        public Map<String, Account> getStudentMapByAuthIDWithAuthID(Set<String> authIDs){
            return AccountQueries.getStudentMapByAuthIDWithAuthID(authIDs);
        }
    }
}