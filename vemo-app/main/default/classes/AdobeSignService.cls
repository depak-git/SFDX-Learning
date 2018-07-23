public with sharing class AdobeSignService {
	public enum DocumentType {ATTACHMENT, DOCUMENT, GENERIC_DOCUMENT}


    /*public static void updateSettings(){
        List<VemoAdobeSignSettings__c> vassList = [SELECT accessToken__c,authorizationCode__c,clientID__c,clientSecret__c,
                                                    CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,
                                                    redirectURL__c,refreshToken__c,SetupOwnerId,SystemModstamp
                                                  FROM VemoAdobeSignSettings__c
                                                  WHERE SetupOwnerId = :UserInfo.getOrganizationID() limit 1];
        if(vassList.size() ==1){
            vassList[0].accessToken__c = vass.accessToken__c;
            vassList[0].refreshToken__c = vass.refreshToken__c;
            vassList[0].authorizationCode__c = vass.authorizationCode__c;
            //update vassList;
        }
    }*/

    public static AccessTokenResponse accessTokenRequest() {
        system.debug('AdobeSignService.accessTokenRequest()');
        LogService.debug('Entering AdobeSignService.accessTokenRequest()', 'Access Token Request');
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        //String authCode = 'CBNCKBAAHBCAABAApl8Ir7skOh0vLe74KEj5M_k-JhXpJnrl';

        //String redirectURL = 'https://vemo--dev1--c.cs2.visual.force.com/apex/authorizeAdobe';
        String grantType = 'authorization_code';

        //String urlStr = (String.isEmpty(VemoAdobeSignSettings.getSettings().apiAccessPoint) ? 'https://api.echosign.com' : VemoAdobeSignSettings.getSettings().apiAccessPoint);
        //urlStr += 'oauth/token';
        String urlStr = 'https://api.echosign.com/oauth/token';
        
        urlStr += '?code='+VemoAdobeSignSettings.getSettings().authorizationCode;
        urlStr += '&client_id='+VemoAdobeSignSettings.getSettings().clientID;
        urlStr += '&client_secret='+VemoAdobeSignSettings.getSettings().clientSecret;
        urlStr += '&redirect_uri='+VemoAdobeSignSettings.getSettings().redirectURL;
        urlStr += '&grant_type='+grantType;

        system.debug(urlStr);
        req.setEndpoint(urlStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');


        // Send the request, and return a response
        LogService.critical('Adobe Callout Request Body:'+req.getBody(), 'Access Token Request');
        LogService.critical('Adobe Callout Request Endpoint:'+req.getEndpoint(), 'Access Token Request');
        HttpResponse res = h.send(req);
        LogService.critical('Adobe Callout Response Body:'+res.getBody(), 'Access Token Request');
        LogService.critical('Adobe Callout Response Status:'+res.getStatus(), 'Access Token Request');
        LogService.critical('Adobe Callout Response Status Code:'+res.getStatusCode(), 'Access Token Request');

        system.debug(res);
        String jsonResponse = res.getBody();
        AccessTokenResponse atr = (AccessTokenResponse) JSON.deserialize(jsonResponse, AccessTokenResponse.class);
        VemoAdobeSignSettings.getSettings().accessToken = atr.access_token;
        VemoAdobeSignSettings.getSettings().refreshToken = atr.refresh_token;

        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(atr);
        if(res.getStatusCode()>201){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }
        LogService.debug('Exiting AdobeSignService.accessTokenRequest()', 'Access Token Request');
        return atr;
    }

    public static RefreshTokenResponse refreshRequest() {
        LogService.debug('Entering AdobeSignService.refreshRequest()', 'Refresh Token Request');
        system.debug('AdobeSignService.refreshRequest()');
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String grantType = 'refresh_token';

        //String urlStr = (String.isEmpty(VemoAdobeSignSettings.getSettings().apiAccessPoint) ? 'https://api.na1.echosign.com' : VemoAdobeSignSettings.getSettings().apiAccessPoint);
        //urlStr += 'oauth/refresh';
        String urlStr = 'https://api.echosign.com/oauth/refresh';

        urlStr += '?refresh_token='+VemoAdobeSignSettings.getSettings().refreshToken;
        urlStr += '&client_id='+VemoAdobeSignSettings.getSettings().clientID;
        urlStr += '&client_secret='+VemoAdobeSignSettings.getSettings().clientSecret;
        urlStr += '&grant_type='+grantType;

        system.debug(urlStr);
        req.setEndpoint(urlStr);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        // Send the request, and return a response
        LogService.critical('Adobe Callout Request Body:'+req.getBody(), 'Refresh Token Request');
        LogService.critical('Adobe Callout Request Endpoint:'+req.getEndpoint(), 'Refresh Token Request');
        HttpResponse res = h.send(req);
        LogService.critical('Adobe Callout Response Body:'+res.getBody(), 'Refresh Token Request');
        LogService.critical('Adobe Callout Response Status:'+res.getStatus(), 'Refresh Token Request');
        LogService.critical('Adobe Callout Response Status Code:'+res.getStatusCode(), 'Refresh Token Request');

        String jsonResponse = res.getBody();
        RefreshTokenResponse rtr = (RefreshTokenResponse) JSON.deserialize(jsonResponse, RefreshTokenResponse.class);

        VemoAdobeSignSettings.getSettings().accessToken = rtr.access_token;

        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(rtr);

        if(res.getStatusCode()>201){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }
        LogService.debug('Exiting AdobeSignService.refreshRequest()', 'Refresh Token Request');
        return rtr;
    }


    public static String uploadDocument(String documentID, String recordID, AdobeSignService.DocumentType docType){
        LogService.debug('Entering AdobeSignService.uploadDocument()', String.valueOf(recordID));
        system.debug('AdobeSignService.uploadDocument()');
        system.debug('documentID:'+documentID);
        Attachment attachfile = new Attachment();
        Document docFile = new Document();

        String fileName = '';
        if(!Test.isRunningTest()){
            if(docType == AdobeSignService.DocumentType.ATTACHMENT){
                attachFile = [Select id, name, body from Attachment where id = :documentID];
                fileName = attachFile.name;
       
            } else if(docType == AdobeSignService.DocumentType.DOCUMENT){
                docFile = [Select id, name, body from Document where id = :documentID];       
                fileName = docFile.name;       
            }

        } else {
            attachFile = new Attachment(Body = Blob.toPdf('Test'));
        }
        system.debug(attachFile);


        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = (String.isEmpty(VemoAdobeSignSettings.getSettings().apiAccessPoint) ? 'https://api.na1.echosign.com' : VemoAdobeSignSettings.getSettings().apiAccessPoint);
        urlStr += '/api/rest/v5/transientDocuments';
        //String urlStr = 'http://api.echosign.com/oauth/token';
        //String urlStr = 'https://api.na1.echosign.com/api/rest/v5/transientDocuments';

        String boundary = '----------------------------sfdc-multi-form';
        String header = '--';
        header += boundary;
        header += '\nContent-Disposition: form-data; name="File"; filename="';
        header += fileName;
        header += '"\nContent-Type: application/pdf';
        header += '\r\n\r\n';

        system.debug(header);

        String footer = '--';
        footer += boundary;
        footer += '--';   

        system.debug(footer);
        
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header));

        while(headerEncoded.endsWith('=')){
           header+=' ';
           headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header));
        }


        String bodyEncoded;
        if(docType == AdobeSignService.DocumentType.ATTACHMENT){
            bodyEncoded = EncodingUtil.base64Encode(attachFile.body);
        } else if(docType == AdobeSignService.DocumentType.DOCUMENT){
            bodyEncoded = EncodingUtil.base64Encode(docFile.body);
        }


        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

        system.debug(last4Bytes);
        // GW: replacement section to get rid of padding without corrupting data
        if(last4Bytes.endsWith('==')) {

            // The '==' sequence indicates that the last group contained only one 8 bit byte
            // 8 digit binary representation of CR is 00001101
            // 8 digit binary representation of LF is 00001010
            // Stitch them together and then from the right split them into 6 bit chunks
            // 0000110100001010 becomes 0000 110100 001010
            // Note the first 4 bits 0000 are identical to the padding used to encode the
            // second original 6 bit chunk, this is handy it means we can hard code the response in
            // The decimal values of 110100 001010 are 52 10
            // The base64 mapping values of 52 10 are 0 K
            // See http://en.wikipedia.org/wiki/Base64 for base64 mapping table
            // Therefore, we replace == with 0K
            // Note: if using \n\n instead of \r\n replace == with 'oK'
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            // We have appended the \r\n to the Blob, so leave footer as it is.
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            system.debug('footerEncoded:'+footerEncoded);
            system.debug('headerEncoded:'+headerEncoded);
            system.debug('bodyEncoded:'+bodyEncoded);
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
            system.debug('bodyBlob:'+bodyBlob);
        } else if(last4Bytes.endsWith('=')) {

            // '=' indicates that encoded data already contained two out of 3x 8 bit bytes
            // We replace final 8 bit byte with a CR e.g. \r
            // 8 digit binary representation of CR is 00001101
            // Ignore the first 2 bits of 00 001101 they have already been used up as padding
            // for the existing data.
            // The Decimal value of 001101 is 13
            // The base64 value of 13 is N
            // Therefore, we replace = with N
            // Note: if using \n instead of \r replace = with 'K'
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            // We have appended the CR e.g. \r, still need to prepend the line feed to the footer
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
        } else {

            // Prepend the CR LF to the footer
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
        }


        if(!Test.isRunningTest()){
            req.setBodyAsBlob(bodyBlob);            
        } else {
            req.setBody('test');
        }

        system.debug('VemoAdobeSignSettings:'+VemoAdobeSignSettings.getSettings());

        req.setHeader('Access-Token', VemoAdobeSignSettings.getSettings().accessToken);
        
        req.setHeader('Host', VemoAdobeSignSettings.getSettings().apiAccessPoint.remove('https://'));
        //req.setHeader('Host', 'api.na1.echosign.com');
        req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
        req.setHeader('Content-Type', 'multipart/form-data; boundary='+boundary); 

        req.setTimeout(60000);

        req.setMethod('POST');
        req.setEndpoint(urlStr);
        //req.setEndpoint('https://hookb.in/ZrJD94Jq');
        system.debug(req);
        system.debug(req.getHeader('Content-Type'));
        system.debug(req.getHeader('Content-Length'));
        system.debug(req.getBodyAsBlob());


        // Send the request, and return a response
        req.setTimeout(60000);
        LogService.critical('Adobe Callout Request Body:'+req.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Request Endpoint:'+req.getEndpoint(), String.valueOf(recordID));
        HttpResponse res = h.send(req);
        LogService.critical('Adobe Callout Response Body:'+res.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status:'+res.getStatus(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status Code:'+res.getStatusCode(), String.valueOf(recordID));
        String jsonResponse = res.getBody();
        TransientDocumentResponse tdr = (TransientDocumentResponse) JSON.deserialize(jsonResponse, TransientDocumentResponse.class);

        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(tdr);

        if(res.getStatusCode()>201){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }
        LogService.debug('Exiting AdobeSignService.uploadDocument()', String.valueOf(recordID));
        return tdr.transientDocumentID;

    }


/*    public static WidgetCreationResponse createSigningWidget(String transientDocumentID){
        //String transientDocumentID = '3AAABLblqZhAxfsxTj6qr9Ldv-No17K-UjHT5sm4znfYq5AjzCwWRl3ZNKgPtr8Ivz19I0vYuwsGYoHjrQ8COFqJTj2MmEzsYEiu6sy1xYHhyNJ1rdR0XDuG4njJtIfbD-qtAORyNQSxQ4OR6h8v608BlQXYPCr1I0nZs_hHBZ4fEmUidiEokboqxPfHSmBar0uwuz9U-KX6eTvRUot_N9Pe-GBEM99ic';
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = 'https://api.na1.echosign.com/api/rest/v5/widgets';
        req.setHeader('Access-Token', VemoAdobeSignSettings.getSettings().accessToken);
        req.setHeader('Host', 'api.na1.echosign.com');
        req.setHeader('Content-Type', 'application/json');      

        String jsonBody = '{"widgetCreationInfo":{"fileInfos":[{"transientDocumentId":"';
        jsonBody += transientDocumentID;
        jsonBody +='"}],"name":"Vemo Agreement","signatureFlow":""}}';
        system.debug(jsonBody);

        req.setMethod('POST');
        req.setEndpoint(urlStr);
        req.setBody(jsonBody);

        // Send the request, and return a response
        HttpResponse res = h.send(req);

        String jsonResponse = res.getBody();
        WidgetCreationResponse wcr = (WidgetCreationResponse) JSON.deserialize(jsonResponse, WidgetCreationResponse.class);
        
        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(wcr);
        
        if(res.getStatusCode()!=200){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }

        return wcr;

    }

    public static WidgetPersonalizeResponse personalizeWidget(String widgetID, String signersEmail){
        //String widgetID = '3AAABLblqZhABGrUUCg2jnmVyuExesnz3pp4pkTfVaUEO80HWfuCxvONVTH__g1GCnVP1Rv210Uj8Q_jFy7GQG9R5F7CEvoBH';
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = 'https://api.na1.echosign.com/api/rest/v5/widgets/';
        urlStr += widgetID;
        urlStr += '/personalize';

        req.setHeader('Access-Token', VemoAdobeSignSettings.getSettings().accessToken);
        req.setHeader('Host', 'api.na1.echosign.com');
        req.setHeader('Content-Type', 'application/json');      

        String jsonBody = '{"email":"';
        jsonBody += signersEmail;
        jsonBody += '","allowManualVerification": true,"comment": "Agreement","expiration":"date","reusable": false}';

        system.debug(jsonBody);

        req.setMethod('PUT');
        req.setEndpoint(urlStr);
        req.setBody(jsonBody);

        // Send the request, and return a response
        HttpResponse res = h.send(req);

        String jsonResponse = res.getBody();
        WidgetPersonalizeResponse wpr = (WidgetPersonalizeResponse) JSON.deserialize(jsonResponse, WidgetPersonalizeResponse.class);

        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(wpr);
        
        if(res.getStatusCode()!=200){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }

        return wpr;
    }

/*
    public static void getAllWidgets(){
        
        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = 'https://api.na1.echosign.com/api/rest/v5/widgets';

        req.setHeader('Access-Token', vass.accessToken__c);
        req.setHeader('Host', 'api.na1.echosign.com');
        req.setHeader('Content-Type', 'application/json');      

        req.setMethod('GET');
        req.setEndpoint(urlStr);

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        system.debug(res);
        system.debug(res.getBody());

    }


    public static void getWidget(){
        String widgetID = '3AAABLblqZhABGrUUCg2jnmVyuExesnz3pp4pkTfVaUEO80HWfuCxvONVTH__g1GCnVP1Rv210Uj8Q_jFy7GQG9R5F7CEvoBH';

        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = 'https://api.na1.echosign.com/api/rest/v5/widgets/';
        urlStr += widgetID;

        req.setHeader('Access-Token', vass.accessToken__c);
        req.setHeader('Host', 'api.na1.echosign.com');
        req.setHeader('Content-Type', 'application/json');      

        req.setMethod('GET');
        req.setEndpoint(urlStr);

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        system.debug(res);
        system.debug(res.getBody());

    }
*/
    public static String createAgreement(String transientDocumentID, String libraryDocumentID, String studentEmail, String recordID, String agreementName){
        LogService.debug('Entering AdobeSignService.createAgreement()', String.valueOf(recordID));

        //String widgetID = '3AAABLblqZhABGrUUCg2jnmVyuExesnz3pp4pkTfVaUEO80HWfuCxvONVTH__g1GCnVP1Rv210Uj8Q_jFy7GQG9R5F7CEvoBH';

        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = (String.isEmpty(VemoAdobeSignSettings.getSettings().apiAccessPoint) ? 'https://api.na1.echosign.com' : VemoAdobeSignSettings.getSettings().apiAccessPoint);
        urlStr += '/api/rest/v5/agreements';
        //String urlStr = 'http://api.echosign.com/oauth/token';
        //String urlStr = 'https://api.na1.echosign.com/api/rest/v5/transientDocuments';
        //String urlStr = 'https://api.na1.echosign.com:443/api/rest/v5/agreements';

        //urlStr += widgetID;

        req.setHeader('Access-Token', VemoAdobeSignSettings.getSettings().accessToken);
        
        req.setHeader('Host', VemoAdobeSignSettings.getSettings().apiAccessPoint.remove('https://'));
        //req.setHeader('Host', 'api.na1.echosign.com');

        req.setHeader('Content-Type', 'application/json');      
/*
        String nameStr = 'docName';
        String emailStr = 'asugreg2@gmail.com';
        String recipientSetRoleStr = 'SIGNER';
        String signatureTypeStr = 'ESIGN';
        String signatureFlowStr = 'SENDER_SIGNATURE_NOT_REQUIRED';*/

/*      String jsonBody = '{"documentCreationInfo":{"fileInfos":[{"transientDocumentId":"' + transientDocumentID;
        jsonBody += '"}],"name": "' + nameStr;
        jsonBody += '","recipientSetInfos": [{"recipientSetMemberInfos": [{"email": "'+emailStr;
        jsonBody += '"}],"recipientSetRole": "'+recipientSetRoleStr;
        jsonBody += '"}],"signatureType": "'+signatureTypeStr;
        jsonBody += '","signatureFlow": "'+signatureFlowStr;
        jsonBody += '"}}';*/

        AgreementCreationInfo aci = new AgreementCreationInfo();
        DocumentCreationInfo dci = new DocumentCreationInfo();
        List<FileInfo> fileInfos = new List<FileInfo>();
        FileInfo fi = new FileInfo();
        
        //sends transient document when uploaded
        if(String.isNotEmpty(transientDocumentID)){
            fi.transientDocumentId = transientDocumentID;
        }

        //otherwise can send document from library
        if(String.isNotEmpty(libraryDocumentID)){
            fi.libraryDocumentId = libraryDocumentID;
        }

        fileInfos.add(fi);
        dci.fileInfos = fileInfos;
        dci.name = agreementName;//'Income Share Agreement';
        List<RecipientSetInfo> rsiList = new List<RecipientSetInfo>();
        RecipientSetInfo rsi = new RecipientSetInfo();
        List<RecipientInfo> riList = new List<RecipientInfo>();
        
        //Recipient Info*/
        RecipientInfo ri = new RecipientInfo();
        ri.email = studentEmail;
        
        List<RecipientSecurityOption> rsoList = new List<RecipientSecurityOption>();
        RecipientSecurityOption rso = new RecipientSecurityOption();
        rso.authenticationMethod = 'NONE';
        rsoList.add(rso);
        ri.securityOptions = rsoList;


        riList.add(ri);
        rsi.recipientSetRole = 'SIGNER';
        rsi.recipientSetMemberInfos = riList;

        rsiList.add(rsi);




        dci.recipientSetInfos = rsiList;
        dci.signatureType = 'ESIGN';
        dci.signatureFlow = 'SENDER_SIGNATURE_NOT_REQUIRED';

        SecurityOption so = new SecurityOption();
        //trying
/*      public String externalPassword {get;set;} //The secondary password that will be used to protect signing the document for external signers. Note that Adobe Sign will never show this password to anyone, so you will need to separately communicate it to any relevant parties. This password is applied only if password protection is specified for external signers or all signers,
        public String internalPassword {get;set;} //he secondary password that will be used to protect signing the document for internal signers. Note that Adobe Sign will never show this password to anyone, so you will need to separately communicate it to any relevant parties. This password is applied only if password protection is specified for internal signers or all signers,
        public String kbaProtection {get;set;} //['NONE' or 'EXTERNAL_USERS' or 'INTERNAL_USERS' or 'ALL_USERS']: Signers need to pass Knowledge Based Authentication before they gain access to view and sign the document.,
        public String openPassword {get;set;} //The secondary password that will be used to secure the PDF document. Note that Adobe Sign will never show this password to anyone, so you will need to separately communicate it to any relevant parties. This password is used only if protectOpen field is set to true,
        public String passwordProtection {get;set;} //['NONE' or 'EXTERNAL_USERS' or 'INTERNAL_USERS' or 'ALL_USERS']: Specifies if signers are required to enter a password to have access to sign the document.,
        public String protectOpen {get;set;} //If set to true, the document is always be encrypted with this password every time it is sent by email. Recipients need to provide the password to be able to view the PDF files,
        public String webIdentityProtection {get;set;} //['NONE' or 'EXTERNAL_USERS' or 'INTERNAL_USERS' or 'ALL_USERS']: Specifies if signers are required to provide their web identity, before they gain access to view and sign the document.
*/
/*



        so.externalPassword = 'greg1';
        so.internalPassword = 'greg2';
        so.openPassword = 'greg3';
        so.protectOpen = 'false';
        so.passwordProtection = 'NONE';
        so.kbaProtection = 'NONE';
*/

        so.webIdentityProtection = 'NONE';
        dci.securityOptions = so;


        aci.documentCreationInfo = dci;

//      InteractiveOptions io = new InteractiveOptions();
//      io.sendThroughWeb = true;
//      aci.options = io;

        String jsonBody = JSON.serialize(aci);


        system.debug(jsonBody);

        req.setMethod('POST');
        req.setEndpoint(urlStr);
        req.setBody(jsonBody);
        req.setTimeout(20000);

        // Send the request, and return a response
        LogService.critical('Adobe Callout Request Body:'+req.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Request Endpoint:'+req.getEndpoint(), String.valueOf(recordID));
        HttpResponse res = h.send(req);
        LogService.critical('Adobe Callout Response Body:'+res.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status:'+res.getStatus(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status Code:'+res.getStatusCode(), String.valueOf(recordID));

        String jsonResponse = res.getBody();
        AgreementCreationResponse acr = (AgreementCreationResponse) JSON.deserialize(jsonResponse, AgreementCreationResponse.class);

        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(acr);

        if(res.getStatusCode()>201){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }
        LogService.debug('Exiting AdobeSignService.createAgreement()', String.valueOf(recordID));
        return acr.agreementID;
    }

    public static String getSigningURL(String agreementID, String recordID){
        LogService.debug('Entering AdobeSignService.getSigningURL()', String.valueOf(recordID));

    //String widgetID = '3AAABLblqZhABGrUUCg2jnmVyuExesnz3pp4pkTfVaUEO80HWfuCxvONVTH__g1GCnVP1Rv210Uj8Q_jFy7GQG9R5F7CEvoBH';

        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = (String.isEmpty(VemoAdobeSignSettings.getSettings().apiAccessPoint) ? 'https://api.na1.echosign.com' : VemoAdobeSignSettings.getSettings().apiAccessPoint);
        urlStr += '/api/rest/v5/agreements/';
        //String urlStr = 'http://api.echosign.com/oauth/token';
        //String urlStr = 'https://api.na1.echosign.com/api/rest/v5/transientDocuments';
        //String urlStr = 'https://api.na1.echosign.com:443/api/rest/v5/agreements';
        //String urlStr = 'https://api.na1.echosign.com:443/api/rest/v5/agreements/';

        urlStr += agreementID;
        urlStr += '/signingUrls';

        req.setHeader('Access-Token', VemoAdobeSignSettings.getSettings().accessToken);
        
        req.setHeader('Host', VemoAdobeSignSettings.getSettings().apiAccessPoint.remove('https://'));
        //req.setHeader('Host', 'api.na1.echosign.com');
        req.setHeader('Content-Type', 'application/json');      

        req.setMethod('GET');
        req.setEndpoint(urlStr);
        system.debug(urlStr);

        // Send the request, and return a response
        LogService.critical('Adobe Callout Request Body:'+req.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Request Endpoint:'+req.getEndpoint(), String.valueOf(recordID));
        HttpResponse res = h.send(req);
        LogService.critical('Adobe Callout Response Body:'+res.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status:'+res.getStatus(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status Code:'+res.getStatusCode(), String.valueOf(recordID));

        String jsonResponse = res.getBody();
        SigningUrlResponse sur = (SigningUrlResponse) JSON.deserialize(jsonResponse, SigningUrlResponse.class);

        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(sur);
        if(res.getStatusCode()>201){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }

        String returnStr;
        try{
            returnStr = sur.signingUrlSetInfos[0].signingUrls[0].esignUrl;          
        } catch (Exception e){
            returnStr = null;
        }
        

        LogService.debug('Exiting AdobeSignService.getSigningURL()', String.valueOf(recordID));
        return returnStr;           
    }


    public static String getCombinedDocument(String recordID, String agreementID, AdobeSignService.DocumentType storeAs, String fileName){
        LogService.debug('Entering AdobeSignService.getCombinedDocument()', String.valueOf(recordID));
    //String widgetID = '3AAABLblqZhABGrUUCg2jnmVyuExesnz3pp4pkTfVaUEO80HWfuCxvONVTH__g1GCnVP1Rv210Uj8Q_jFy7GQG9R5F7CEvoBH';

        // Instantiate a new http object
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        String urlStr = (String.isEmpty(VemoAdobeSignSettings.getSettings().apiAccessPoint) ? 'https://api.na1.echosign.com' : VemoAdobeSignSettings.getSettings().apiAccessPoint);
        urlStr += '/api/rest/v5/agreements/';
        //String urlStr = 'https://api.na1.echosign.com:443/api/rest/v5/agreements/';
        urlStr += agreementID;
        urlStr += '/combinedDocument';

        req.setHeader('Access-Token', VemoAdobeSignSettings.getSettings().accessToken);
        
        req.setHeader('Host', VemoAdobeSignSettings.getSettings().apiAccessPoint.remove('https://'));
        //req.setHeader('Host', 'api.na1.echosign.com');
        req.setHeader('Content-Type', 'application/json');      

        req.setMethod('GET');
        req.setEndpoint(urlStr);
        system.debug(urlStr);

        // Send the request, and return a response
        LogService.critical('Adobe Callout Request Body:'+req.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Request Endpoint:'+req.getEndpoint(), String.valueOf(recordID));
        HttpResponse res = h.send(req);
        LogService.critical('Adobe Callout Response Body:'+res.getBody(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status:'+res.getStatus(), String.valueOf(recordID));
        LogService.critical('Adobe Callout Response Status Code:'+res.getStatusCode(), String.valueOf(recordID));

//      String jsonResponse = res.getBody();
//      SigningUrlResponse sur = (SigningUrlResponse) JSON.deserialize(jsonResponse, SigningUrlResponse.class);



        String base64Attachment = EncodingUtil.base64Encode(res.getBodyAsBlob());
        Blob body = EncodingUtil.base64Decode(base64Attachment);

        system.debug(base64Attachment);
        system.debug(EncodingUtil.base64Decode(base64Attachment));

        system.debug(res.getBody());
        system.debug(res);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
//        system.debug(sur);
        if(res.getStatusCode()>201){
            throw new AdobeSignServiceException(String.valueOf(res)+':'+res.getBody());
        }

        if(storeAs == AdobeSignService.DocumentType.ATTACHMENT){
            Attachment attach = new Attachment(ParentID = recordID,
                                                //Body = Blob.valueOf(res.getBody()),
                                                //Body = EncodingUtil.base64Decode(res.getBody()),
                                                Body = body,
                                                ContentType = 'application/pdf',
                                                //Name = AgreementService.signedAgreementFileName(recordID)+'.pdf');
                                                Name = fileName);

            insert attach;            
        } else if(storeAs == AdobeSignService.DocumentType.GENERIC_DOCUMENT){
            GenericDocument__c genDoc = new GenericDocument__c(ParentID__c = recordID,
                                                                ParentObjectType__c = 'Reconciliation__c',
                                                                Type__c = 'Signed 4506T authorization',
                                                                Status__c = 'Pending Upload');
            insert genDoc;
            Attachment attach = new Attachment(ParentID = genDoc.id,
                                                Body = body,
                                                ContentType = 'application/pdf',
                                                Name = fileName);
            insert attach;
        }

        String returnStr;
        try{
            returnStr = res.getBody();      
        } catch (Exception e){
            returnStr = null;
        }
        

        LogService.debug('Exiting AdobeSignService.getCombinedDocument()', String.valueOf(recordID));
        return returnStr;           
    }



    public class AccessTokenResponse{
        public String token_type {get;set;}
        public String access_token {get;set;}
        public String refresh_token {get;set;}
        public Integer expires_in {get;set;}
    }

    public class RefreshTokenResponse{
        public String token_type {get;set;}
        public String access_token {get;set;}
        public Integer expires_in {get;set;}
    } 
    
    private class TransientDocumentResponse{
        String transientDocumentId  {get;set;}
    } 
    
    public class WidgetCreationResponse{
        public String javascript  {get;set;}
        public String nextPageEmbeddedCode {get;set;}
        public String nextPageUrl {get;set;}
        public String url {get;set;}
        public String widgetID {get;set;}
    }

    public class WidgetPersonalizeResponse{
        public String javascript  {get;set;}
        public String url {get;set;}
        public String widgetID {get;set;}       
    }
    public class AgreementCreationResponse {
        public String agreementID {get; set;}
        public String embeddedCode {get;set;}
        public Date expiration {get;set;}
        public String url {get;set;} 
    }

    public class AgreementCreationInfo {
        public DocumentCreationInfo documentCreationInfo {get;set;}
        public InteractiveOptions options {get;set;}
    }

    public class DocumentCreationInfo {
        public FileInfo[] fileInfos {get;set;} //A list of one or more files or references to files that will be sent out for signature. If more than one file is provided, they will be combined into one PDF before being sent out. Note: Only one of the four parameters in every FileInfo object must be specified,
        public String name {get;set;} //The name of the agreement that will be used to identify it, in emails and on the website
        public RecipientSetInfo[] recipientSetInfos {get;set;}
        /*
A list of one or more recipient sets. A recipient set may have one or more recipients. If any member of the recipient set signs, the agreement is considered signed by the recipient set. For regular (non-MegaSign) documents, there is no limit on the number of electronic signatures in a single document. Written signatures are limited to four per document. This limit includes the sender if the signature of the sender is also required. Note: If signatureFlow is set to SENDER_SIGNS_ONLY, this parameter is optional,
        */
        public String signatureType {get;set;} //['ESIGN' or 'WRITTEN']: Specifies the type of signature you would like to request - written or e-signature. The possible values are ESIGN or WRITTEN,
        public String callbackInfo {get;set;} //A publicly accessible url to which Adobe Sign will do an HTTP GET operation every time there is a new agreement event. HTTP authentication is supported using standard embedded syntax - i.e. http://username:password@your.server.com/path/to/file. Adobe Sign can also ping your system using HTTP PUT with the final signed PDF. Please contact support@echosign.com if you wish to use this option.,
        public String[] ccs {get;set;} //A list of one or more email addresses that you want to copy on this transaction. The email addresses will each receive an email at the beginning of the transaction and also when the final document is signed. The email addresses will also receive a copy of the document, attached as a PDF file,
        public Integer daysUntilSigningDeadline {get;set;} //The number of days that remain before the document expires. You cannot sign the document after it expires,
        public ExternalId externalId {get;set;}
        public FileInfo[] formFieldLayerTemplates {get;set;} //Specifies the form field layer template or source of form fields to apply on the files in this transaction. If specified, the FileInfo for this parameter must refer to a form field layer template via libraryDocumentId or libraryDocumentName, or if specified via transientDocumentId or documentURL, it must be of a supported file type. Note: Only one of the four parameters in every FileInfo object must be specified,
        public RequestFormField[] formFields {get;set;} //nformation of form fields of an agreement. PDF_SIGNATURE inputType field is currently not supported,
        public String locale {get;set;} //The locale associated with this agreement - specifies the language for the signing page and emails, for example en_US or fr_FR. If none specified, defaults to the language configured for the agreement sender
        public MergefieldInfo[] mergeFieldInfo {get;set;} //Optional default values for fields to merge into the document. The values will be presented to the signers for editable fields; for read-only fields the provided values will not be editable during the signing process. Merging data into fields is currently not supported when used with libraryDocumentId or libraryDocumentName. Only file and url are currently supported
        public String message {get;set;} //An optional message to the recipients, describing what is being sent or why their signature is required
        public PostSignOptions postSignOptions {get;set;} //URL and associated properties for the success page the user will be taken to after completing the signing process,
        public String reminderFrequency {get;set;} //['DAILY_UNTIL_SIGNED' or 'WEEKLY_UNTIL_SIGNED']: Optional parameter that sets how often you want to send reminders to the recipients. The possible values are DAILY_UNTIL_SIGNED or WEEKLY_UNTIL_SIGNED,
        public SecurityOption securityOptions {get;set;} //Sets optional secondary security parameters for your document,
        public String signatureFlow {get;set;} //['SENDER_SIGNATURE_NOT_REQUIRED' or 'SENDER_SIGNS_LAST' or 'SENDER_SIGNS_FIRST' or 'SEQUENTIAL' or 'PARALLEL' or 'SENDER_SIGNS_ONLY']: Selects the workflow you would like to use - whether the sender needs to sign only, before the recipient, after the recipient, or not at all. The possible values for this variable are SENDER_SIGNATURE_NOT_REQUIRED, SENDER_SIGNS_LAST, SENDER_SIGNS_FIRST, SEQUENTIAL, PARALLEL or SENDER_SIGNS_ONLY. Note: leave unspecified for hybrid routing,
        public ValutingInfo vaultingInfo {get;set;} //Sets the vaulting properties that allows Adobe Sign to securely store documents with a vault provider
    }

    public class FileInfo {
        public URLFileInfo documentURL {get;set;} //File at a public URL location,
        public String libraryDocumentId {get;set;} //The ID for a library document that is available to the sender,
        public String libraryDocumentName {get;set;} //The name of a library document that is available to the sender,
        public String transientDocumentId {get;set;} //The documentID as returned from the transient document creation API
    }

    public class URLFileInfo {
        public String mimeType {get;set;} //he mime type of the referenced file, used to determine if the file can be accepted and the necessary conversion steps can be performed,
        public String name {get;set;} //The original system file name of the document being sent - used to name attachments, and to infer the mime type if one is not explicitly specified,
        public String url {get;set;} //A publicly accessible URL for retrieving the raw file content. HTTP authentication is supported using standard embedded syntax - i.e. http://username:password@your.server.com/path/to/file.
    }

    public class RecipientSetInfo {
        public RecipientInfo[] recipientSetMemberInfos {get;set;} // Information about the members of the recipient set,
        public String recipientSetRole {get;set;} 
        /*
['SIGNER' or 'APPROVER' or 'ACCEPTOR' or 'FORM_FILLER' or 'CERTIFIED_RECIPIENT' or 'DELEGATE_TO_SIGNER' or 'DELEGATE_TO_APPROVER' or 'DELEGATE_TO_ACCEPTOR' or 'DELEGATE_TO_FORM_FILLER' or 'DELEGATE_TO_CERTIFIED_RECIPIENT']: Specify the role of recipient set. The possible values are 
SIGNER (enum): Recipients marked as signers need to sign the document. They may be required to enter data into fields. 
APPROVER (enum): Recipients marked as approvers review and approve the document but they are not required to sign it. They may be required to enter data into fields.
ACCEPTOR (enum): Recipients marked as acceptors are required to accept the document. They may be required to enter data into fields.
FORM_FILLER (enum): Recipients marked as form fillers are required to enter data into the form fields and submit the document.
CERTIFIED_RECIPIENT (enum): Recipients marked as certified recipient are required to view and acknowledge the receipt of the document.
Delegators: Recipients marked as delegators may review the document but can’t sign, approve, accept or acknowledge it. They need to forward the document to another user who may take the appropriate action.,
        */
        public String privateMessage {get;set;} //Private message for the recipients in the set,
        public String recipientSetName {get;set;} //Specify the name of Recipient set. Maximum no of characters in recipient set name is restricted to 255.
        public RecipientSecurityOption[] securityOptions {get;set;} //Security options that apply to the recipient,
        public Integer signingOrder {get;set;} // Index indicating sequential signing group -specify for hybrid routing-
    }


    public class RecipientInfo {
        public String email {get;set;} //Email of the recipient. This is required if fax is not provided. Both fax and email can not be provided,
        public String fax {get;set;} //Fax of the recipient. This is required if email is not provided. Both fax and email can not be provided. In case of recipient set having more than one member, fax is not allowed
        public RecipientSecurityOption[] securityOptions {get;set;} //Security options that apply to the recipient
    }

    public class RecipientSecurityOption {
        public String authenticationMethod {get;set;} //['NONE' or 'INHERITED_FROM_DOCUMENT' or 'PASSWORD' or 'WEB_IDENTITY' or 'KBA' or 'PHONE']: The authentication method for the recipients to have access to view and sign the document,
        public PhoneInfo[] phonInfos {get;set;} //The phoneInfo required for the recipient to view and sign the document,
        public String password {get;set;} //The password required for the recipient to view and sign the document
    }

    public class PhoneInfo {
        public String phone {get;set;} //The phone number required for the recipient to view and sign the document if authentication type is PHONE
        public String countryCode {get;set;} //The phoneInfo country code required for the recipient to view and sign the document if authentication type is PHONE

    }
    public class ExternalId {
        public String groupp {get;set;} //An arbitrary value from your system, which can be specified at sending time and then later returned or queried
        public String id {get;set;} //An arbitrary value from your system, which can be specified at sending time and then later returned or queried
        public String namespace {get;set;} //Only supported value for the ExternalID namespace at this time is API_OTHER
    }

    public class RequestFormField {
        public FormFieldLocation[] locations {get;set;} //All locations in a document where the form field is placed,
        public String name {get;set;} //he name of the form field,
        public String alignment {get;set;} //['LEFT' or 'RIGHT' or 'CENTER']: Alignment of the text.,
        public String anyOrAll {get;set;} //['ALL' or 'ANY']: It indicates if any one of the conditions or all of them have to be true
        public String backgroundColor {get;set;} //Background color of the form field in RGB or HEX format
        public String borderColor {get;set;} //Color of the border of the field in RGB or HEX format
        public String borderStyle {get;set;} //['SOLID' or 'DASHED' or 'BEVELED' or 'INSET' or 'UNDERLINE']: Style of the border of the field
        public Decimal borderWidth {get;set;} //Width of the border of the field in pixels
        public String calculatedExpression {get;set;} //Expression to calculate value of the form field,
        public FormFieldCondition[] conditions {get;set;} //Conditions to be evaluated which decides the visibility of the form field in association with showOrHide property,
        public String contentType {get;set;} //['DATA' or 'SIGNATURE_BLOCK' or 'SIGNATURE' or 'SIGNER_NAME' or 'SIGNER_FIRST_NAME' or 'SIGNER_LAST_NAME' or 'SIGNER_INITIALS' or 'SIGNER_EMAIL' or 'SIGNER_TITLE' or 'SIGNER_COMPANY' or 'SIGNATURE_DATE' or 'AGREEMENT_NAME' or 'AGREEMENT_MESSAGE' or 'TRANSACTION_ID' or 'SIGNATURE_STAMP' or 'CALC']: Content Type of the form field.,
        public String defaultValue {get;set;} //Default value of the form field
        public String displayFormat {get;set;} //Format of the value of the field to be displayed based on the displayFormatType property
        public String displayFormatType {get;set;} //['DEFAULT' or 'DATE' or 'NUMBER']: Format type of the text field. ,
        public String displayLabel {get;set;} //Display label attached to the field,
        public String fontColor {get;set;} //Font Color of the form field in RBG or HEX format
        public String fontName {get;set;} //Font name of the form field
        public Decimal fontSize {get;set;} //Font size of the form field in points
        public String format {get;set;} //['CUSTOM' or 'DATE' or 'DATE_CUSTOM' or 'DATE_DD_MM_YY' or 'DATE_DD_MM_YYYY' or 'DATE_MM_DD_YY' or 'DATE_MM_DD_YYYY' or 'DATE_MM_YY' or 'EMAIL' or 'FORMULA' or 'MONEY' or 'MONEY_UK' or 'NONE' or 'NUMBER' or 'PERCENT' or 'PHONE' or 'PHONE_UK' or 'SOCIAL_SEC' or 'SPECIAL' or 'STRING' or 'STRING_ALPHA' or 'STRING_ALPHANUM' or 'STRING_NUM' or 'TIME' or 'XFA_PICTURE' or 'ZIP' or 'ZIP4' or 'ZIP_UK']: Format of the form field,
        public String formatData {get;set;} //The format of data in text field
        public Boolean hidden {get;set;} //true if the field is hidden, else false
        public String[] hiddenOptions {get;set;} //Text values which are hidden in a drop down form field,
        public String inputType {get;set;} //['TEXT_FIELD' or 'MULTILINE' or 'PASSWORD' or 'RADIO' or 'CHECKBOX' or 'DROP_DOWN' or 'LISTBOX' or 'SIGNATURE' or 'PDF_SIGNATURE' or 'BUTTON' or 'BLOCK' or 'FILE_CHOOSER' or 'COMB' or 'UNSUPPORTED']: Input type of the form field,
        public Boolean masked {get;set;} // true if the input entered by the signer has to be masked like password, else false,
        public String maskingText {get;set;} //Text to mask the masked form field
        public Integer maxLength {get;set;} //Maximum length of the input text field in terms of no. of characters
        public Double maxNumberValue {get;set;} //Upper bound of the number that can be entered by the signer
        public Integer minLength {get;set;} //Minimum length of the input text field in terms of no. of characters,
        public Double minNumberValue {get;set;} //Lower bound of the number that can be entered by the signer,
        public String radioCheckType {get;set;} //['CIRCLE' or 'CHECK' or 'CROSS' or 'DIAMOND' or 'SQUARE' or 'STAR']: The type of radio button -if field is radio button, identified by inputType). ,
        public Boolean readOnly {get;set;} //true if it is a read-only field, else false
        public Integer recipientIndex {get;set;} //Index of recipient, starting from 1, in recipients list passed in the request,
        public Integer regularExpression {get;set;} //Regular expression validation of the form field,
        public Boolean required {get;set;} //true if it is a mandatory field to be filled by the signer, else false,
        public String showOrHide {get;set;} //['SHOW' or 'HIDE' or 'DISABLE' or 'ENABLE']: Action to show/hide the form field is to be taken on the basis of evaluation of conditions.,
        public String specialErrMsg {get;set;} // Error message to be shown to the signer if filled value doesn't match the validations of the form field,
        public String specialFormula {get;set;} //Formula used to calculate the value of the form field,
        public String tooltip {get;set;} //Text that appears while hovering over the field,
        public String[] visibleOptions {get;set;} //Text values which are visible in a drop down form field
    }
    public class FormFieldLocation{
        public Double height {get;set;} //Height of the form field in pixels,
        public Double left {get;set;} //No. of pixels from left of the page for form field placement,
        public Integer pageNumber {get;set;} //Number of the page where form field has to be placed, starting from 1.,
        public Double top {get;set;} //No. of pixels from bottom of the page for form field placement
        public Double width {get;set;} //Width of the form field in pixels
    }

    public class FormFieldCondition {
        public String value {get;set;} //Value to compare the value of the whenField with, to evaluate the condition
        public Integer whenFieldLocationIndex {get;set;} //Index of the location of the whenField whose value is the basis of the condition
        public String whenFieldName {get;set;} //Name of the field whose value is the basis of condition
    }
    public class MergefieldInfo {
        public String deafultValue {get;set;} //The default value of the field,
        public String fieldName {get;set;} //The name of the field
    }

    public class PostSignOptions{
        public String redirectURL {get;set;} //A publicly accessible url to which the user will be sent after successfully completing the signing process.
        public Integer redirectDelay {get;set;} //The delay in seconds before the user is taken to the success page. If this value is greater than 0, the user will first see the standard Adobe Sign success message, and then after a delay will be redirected to your success page

    }

    public class SecurityOption{
        public String externalPassword {get;set;} //The secondary password that will be used to protect signing the document for external signers. Note that Adobe Sign will never show this password to anyone, so you will need to separately communicate it to any relevant parties. This password is applied only if password protection is specified for external signers or all signers,
        public String internalPassword {get;set;} //he secondary password that will be used to protect signing the document for internal signers. Note that Adobe Sign will never show this password to anyone, so you will need to separately communicate it to any relevant parties. This password is applied only if password protection is specified for internal signers or all signers,
        public String kbaProtection {get;set;} //['NONE' or 'EXTERNAL_USERS' or 'INTERNAL_USERS' or 'ALL_USERS']: Signers need to pass Knowledge Based Authentication before they gain access to view and sign the document.,
        public String openPassword {get;set;} //The secondary password that will be used to secure the PDF document. Note that Adobe Sign will never show this password to anyone, so you will need to separately communicate it to any relevant parties. This password is used only if protectOpen field is set to true,
        public String passwordProtection {get;set;} //['NONE' or 'EXTERNAL_USERS' or 'INTERNAL_USERS' or 'ALL_USERS']: Specifies if signers are required to enter a password to have access to sign the document.,
        public String protectOpen {get;set;} //If set to true, the document is always be encrypted with this password every time it is sent by email. Recipients need to provide the password to be able to view the PDF files,
        public String webIdentityProtection {get;set;} //['NONE' or 'EXTERNAL_USERS' or 'INTERNAL_USERS' or 'ALL_USERS']: Specifies if signers are required to provide their web identity, before they gain access to view and sign the document.

    }
    public class ValutingInfo {
        public Boolean enabled {get;set;}
    }
    public class InteractiveOptions {
        public Boolean authoringRequested {get;set;} //Indicates that authoring is requested prior to sending the document,
        public Boolean autoLoginUser  {get;set;} //If user settings allow, automatically logs the user in,
        public String locale {get;set;} //The locale in which page returned by this API should be shown in - for example, en_US or fr_FR. In case locale provided by client is not available or no locale is specified, page will be shown in the default language set in the user account,
        public Boolean noChrome {get;set;} //Turn off Chrome for the URL generated,
        public Boolean sendThroughWeb {get;set;} //A url to send page will be returned from where the agreement creation needs to be completed. All the parameters provided here will be retained in the send page,
        public SendThroughWebOptions sendThroughWebOptions {get;set;} //A JSON object of Type SendThroughWebOptions to customize the sendPage. This one will apply only if sendThroughWeb is set to true
    }

    public class SendThroughWebOptions {
        public FileUploadOptions fileUploadOptions {get;set;} //Controls various file upload options available on the send page
    }
    public class FileUploadOptions {
        public Boolean libraryDocument {get;set;} //Whether library documents link should appear or not. Default value is taken as true
        public Boolean localFile {get;set;} //Whether local file upload button should appear or not. Default value is taken as true
        public Boolean webConnectors {get;set;} //Whether link to attach documents from web sources like Dropbox should appear or not. Default value is taken as true
    }

    public class SigningUrlResponse {
        public SigningUrlSetInfo[] signingUrlSetInfos {get;set;}
    }
    public class SigningUrlSetInfo {
        public SigningUrl[] signingUrls {get;set;}
        public String signingUrlSetName {get;set;}
    }
    public class SigningUrl {
        public String email {get;set;}
        public String esignUrl {get;set;}
    }

    public class AdobeSignServiceException extends Exception{}
}