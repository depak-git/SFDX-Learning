/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIAttachmentResource
// 
// Description: 
// 	Direction Central for Credit Check Resource API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                          
// 
/////////////////////////////////////////////////////////////////////////
public class VemoAPIAttachmentResource {
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		if((api.version == 'v1') && (api.method == 'POST')){
			return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			//return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			return handleDeleteV1(api);
		}			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}
	
	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIAttachmentResource.handleGetV1()');
		String attachmentIDparam = api.params.get('attachmentID');
		String returnParam = api.params.get('return');
		//Set<ID> attIDs = new Set<ID>{attachementIDParam};
		if(returnParam=='resource'){
			List<Attachment> atts = [select Id, ParentID, ContentType, Name from Attachment where ID = : VemoApi.parseParameterIntoIDSet(attachmentIDparam)];
			List<AttachmentResourceOutputV1> results = new List<AttachmentResourceOutputV1>();
			system.debug(atts);
			for(Attachment att : atts){
				results.add(new AttachmentResourceOutputV1(att));
			}
			system.debug('results:'+results);
			return (new VemoAPI.ResultResponse(results, results.size()));			
		} else {
			List<Attachment> atts = [select Id, Body, ParentID, ContentType, Name from Attachment where ID = :attachmentIDparam];
			system.debug(atts);
			return (new VemoAPI.ResultResponse(atts[0].body));
		}

		return null;
	}
	
	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		system.debug('VemoAPIAttachmentResource.handlePostV1()');
		RestRequest req = RestContext.request;
		ID parentRecParam = api.params.get('parentID');
		String contentTypeParam = api.params.get('contentType');
		if(String.isEmpty(contentTypeParam)) contentTypeParam = 'application/pdf';
		String fileName = api.params.get('fileName');
		System.debug('******************Attachment name = ' + fileName);
		if(String.isEmpty(fileName)) fileName = 'Attachment';

		String signedAgreementParam = api.params.get('signedAgreement');
		String finalDisclosureParam = api.params.get('finalDisclosure');

		if(signedAgreementParam == 'true'){
			fileName = 'signed-agreement-'+(String.valueOf(parentRecParam)).left(15)+'.pdf';
		}
		if(finalDisclosureParam == 'true'){
			fileName = 'final-disclosure-'+(String.valueOf(parentRecParam)).left(15)+'.pdf';
		}
		Blob content = (req.requestBody);
		Attachment a = new Attachment(ParentId = parentRecParam,
									  Body = content,
									  ContentType = contentTypeParam,
									  Name = fileName);
		insert a;
		Set<ID> results = new Set<ID>{a.ID};
		return (new VemoAPI.ResultResponse(results, results.size()));
	}
	/*
	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		//TODO
		return null;
	}
	*/

	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIAttachmentResource.handleDeleteV1()');
		String attachementIDParam = api.params.get('attachmentID');
		Set<ID> attIDs = new Set<ID>{attachementIDParam};
		List<Attachment> atts = [select Id, ParentID, Body, ContentType, Name from Attachment where ID IN: attIDs];	
		Integer numDeleted = atts.size();
		delete atts;
		return (new VemoAPI.ResultResponse(true, numDeleted));
	}

	public class AttachmentResourceOutputV1{
		public String attachmentID{get;set;}
		public String parentID{get;set;}
		public String contentType{get;set;}
		public String name{get;set;}

		public AttachmentResourceOutputV1(){}

		public AttachmentResourceOutputV1(Attachment att){
			this.attachmentID = att.ID;
			this.parentID = att.ParentId;
			this.contentType = att.ContentType;
			this.name = att.Name;
		}
	}
}