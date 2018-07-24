public with sharing class CongaService {
	public static final String congaAgreementQueryName = 'Agreement and Related Objects';
	public static final String congaLoanAlternativesQueryName = 'Loan Alternatives';
	public static final String congaISAPaymentsQueryName = 'ISA Payments';
	public static final String congaISAPaymentsGrowthQueryName = 'ISA Payments Income Growth Example';
	public static ID generateDocument(String masterRecordID, String templateID, String fileName, String sessId) {
    	LogService.debug('Entering CongaService.generateDocument()', String.valueOf(masterRecordID));
		system.debug('CongaService.generateAgreementDocument()');

		List<APXTConga4__Conga_Merge_Query__c> agrQuery = [Select id, APXTConga4__Name__c
														from APXTConga4__Conga_Merge_Query__c
														where APXTConga4__Name__c = :congaAgreementQueryName];

		List<APXTConga4__Conga_Merge_Query__c> laQuery = [Select id, APXTConga4__Name__c
														from APXTConga4__Conga_Merge_Query__c
														where APXTConga4__Name__c = :congaLoanAlternativesQueryName];

		List<APXTConga4__Conga_Merge_Query__c> isapayQuery = [Select id, APXTConga4__Name__c
														from APXTConga4__Conga_Merge_Query__c
														where APXTConga4__Name__c = :congaISAPaymentsQueryName];

		List<APXTConga4__Conga_Merge_Query__c> isapaygrowQuery = [Select id, APXTConga4__Name__c
														from APXTConga4__Conga_Merge_Query__c
														where APXTConga4__Name__c = :congaISAPaymentsGrowthQueryName];

		if(agrQuery.size()!=1){
			throw new CongaServiceException('Could not find Conga Query with Name = '+congaAgreementQueryName);
		}
		if(laQuery.size()!=1){
			throw new CongaServiceException('Could not find Conga Query with Name = '+congaLoanAlternativesQueryName);
		}
		if(isapayQuery.size()!=1){
			throw new CongaServiceException('Could not find Conga Query with Name = '+congaISAPaymentsQueryName);
		}
		if(isapaygrowQuery.size()!=1){
			throw new CongaServiceException('Could not find Conga Query with Name = '+congaISAPaymentsGrowthQueryName);
		}
		// Instantiate a new http object
		Http h = new Http();
		//String sessId = UserInfo.getSessionId();
    	String servUrl = Url.getSalesforceBaseUrl().toExternalForm()+'/services/Soap/u/29.0/'+UserInfo.getOrganizationId();
        
		 // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
		HttpRequest req = new HttpRequest();
		String urlStr = 'https://composer.congamerge.com/composer8/index.html';/*?SolMgr=1';*/
		if(sessId == null){
			OAuthUtil job = new OAuthUtil(GlobalSettings.getSettings().oauthUtilEndpoint,
										  GlobalSettings.getSettings().oauthUtilUserID,
			                              GlobalSettings.getSettings().oauthUtilPassword,
			                              GlobalSettings.getSettings().oauthUtilConsumerID,
			                              GlobalSettings.getSettings().oauthUtilConsumerSecret);
			sessId = job.requestAccessToken();			
		}
		urlStr += '?sessionId='+sessId;
		urlStr += '&serverUrl='+servUrl;
		urlStr += '&Id=';
		urlStr += masterRecordID;
//		urlStr += '&QueryId=[agreement]a0AR000000G4l62';/*query from conga query*/
		urlStr += '&QueryId=[agreement]'+agrQuery[0].id;/*query from conga query*/
		urlStr += ',[loanalternatives]'+laQuery[0].id;/*query from conga query*/		
		urlStr += ',[isapayments]'+isapayQuery[0].id;/*query from conga query*/
		urlStr += ',[isapaymentsincomegro]'+isapaygrowQuery[0].id;/*query from conga query*/
		urlStr += '&DS7=1';/*no user intervention attach merged doc to master obj*/
		urlStr += '&TemplateID=';
		urlStr += templateID;/*template id from conga template*/
        urlStr += '&APIMode=1';//send via api and attach to main id record
        urlStr += '&DefaultPDF=1';//default as PDF
//        urlStr += '&DefaultPDF=0';//default as same as original
        urlStr += '&OFN=';
        urlStr += fileName;//output file name
		system.debug(urlStr);
		req.setEndpoint(urlStr);
        req.setTimeout(60000);
		req.setMethod('GET');

		// Send the request, and return a response
		LogService.critical('Conga Callout Request Body:'+req.getBody(), String.valueOf(masterRecordID));
		LogService.critical('Conga Callout Request Endpoint:'+req.getEndpoint(), String.valueOf(masterRecordID));

//throw new CongaServiceException('test');

		HttpResponse res = h.send(req);
		LogService.critical('Conga Callout Response Body:'+res.getBody(), String.valueOf(masterRecordID));
		LogService.critical('Conga Callout Response Status:'+res.getStatus(), String.valueOf(masterRecordID));
		LogService.critical('Conga Callout Response Status Code:'+res.getStatusCode(), String.valueOf(masterRecordID));
        system.debug(res);
        system.debug(res.getBody());
		//return res.getBody();
    	LogService.debug('Exiting CongaService.generateDocument()', String.valueOf(masterRecordID));
		return res.getBody();
	}
	public class CongaServiceException extends Exception {}
}