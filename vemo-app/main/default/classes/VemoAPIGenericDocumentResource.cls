/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIGenericDocumentResource
// 
// Description: 
// 	Handles all Generic Document API Functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-01-04   Greg Cook       Created                         
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIGenericDocumentResource implements VemoAPI.ResourceHandler {
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		if((api.version == 'v1') && (api.method == 'POST')){
			return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			return handleDeleteV1(api);
		}			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}

	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIGenericDocumentResource.handleGetV1');
		String genericDocumentIDparam = api.params.get('genericDocumentID');
		String parentIDparam;
		if(String.isNotBlank(String.valueOf(api.params.get('parentID')))){
			parentIDparam = String.valueOf(api.params.get('parentID')).substring(0,15);
		}
		

		List<GenericDocumentService.GenericDocument> docs = new List<GenericDocumentService.GenericDocument>();
		if(genericDocumentIDparam != null){

			docs = GenericDocumentService.getGenericDocumentWithGenericDocumentID(VemoApi.parseParameterIntoIDSet(genericDocumentIDparam));
		}else if(parentIDparam != null){
			System.debug('parentIDparam:'+parentIDparam);
			docs = GenericDocumentService.getGenericDocumentWithParentID(new Set<String>{parentIDparam});
		}  
		else{
			throw new VemoAPI.VemoAPIFaultException('Missing parameter: genericDocumentID required for GET');
		}
		List<GenericDocumentOutputV1> results = new List<GenericDocumentOutputV1>();
		for(GenericDocumentService.GenericDocument doc : docs){
			results.add(new GenericDocumentOutputV1(doc));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIGenericDocumentResource.handlePostV1');
		List<GenericDocumentService.GenericDocument> newGenDocs = new List<GenericDocumentService.GenericDocument>();
		List<GenericDocumentResourceInputV1> GenDocsJSON = (List<GenericDocumentResourceInputV1>)JSON.deserialize(api.body, List<GenericDocumentResourceInputV1>.class);
		for(GenericDocumentResourceInputV1 genDocsRes : GenDocsJSON){
			genDocsRes.validatePOSTFields();
			GenericDocumentService.GenericDocument genDoc = genDocumentResourceV1ToGenDoc(genDocsRes);
			newGenDocs.add(genDoc);
		}
		Set<ID> genDocIDs = GenericDocumentService.createGenericDocument(newGenDocs);
		return (new VemoAPI.ResultResponse(genDocIDs, genDocIDs.size()));
	}

	public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIGenericDocumentResource.handlePutV1');
		List<GenericDocumentService.GenericDocument> newGenDocs = new List<GenericDocumentService.GenericDocument>();
		List<GenericDocumentResourceInputV1> GenDocsJSON = (List<GenericDocumentResourceInputV1>)JSON.deserialize(api.body, List<GenericDocumentResourceInputV1>.class);
		for(GenericDocumentResourceInputV1 genDocsRes : GenDocsJSON){
			genDocsRes.validatePUTFields();
			GenericDocumentService.GenericDocument genDoc = genDocumentResourceV1ToGenDoc(genDocsRes);
			newGenDocs.add(genDoc);
		}
		Set<ID> genDocIDs = GenericDocumentService.updateGenericDocument(newGenDocs);
		return (new VemoAPI.ResultResponse(genDocIDs, genDocIDs.size()));
	}

	public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIGenericDocumentResource.handleDeleteV1');
		String genDocIDParam = api.params.get('genericDocumentID');		
		Integer numToDelete = GenericDocumentService.deleteGenericDocument(VemoApi.parseParameterIntoIDSet(genDocIDParam));
		return (new VemoAPI.ResultResponse(true, numToDelete));
	}

	public static GenericDocumentService.GenericDocument genDocumentResourceV1ToGenDoc(GenericDocumentResourceInputV1 disRes){
		GenericDocumentService.GenericDocument genDoc = new GenericDocumentService.GenericDocument();
		genDoc.genericDocumentID = disRes.genericDocumentID;
		genDoc.type = disRes.type;
		genDoc.status = disRes.status;
		genDoc.parentID = disRes.parentID;
		genDoc.parentObjectType = disRes.parentObjectType;
		genDoc.comments = disRes.comments;
		return genDoc;
	}

	public class GenericDocumentResourceInputV1{
		public String genericDocumentID {get;set;}
		public String type {get;set;}
		public String status {get;set;}
		public String parentID {get;set;}
		public String parentObjectType {get;set;}
		public String comments {get;set;}



		public GenericDocumentResourceInputV1(){}

		public GenericDocumentResourceInputV1(Boolean testValues){
			if(testValues){

			}
		}
		public void validatePOSTFields(){
			if(genericDocumentID != null) throw new VemoAPI.VemoAPIFaultException('genericDocumentID cannot be created in POST');				
		}
		public void validatePUTFields(){
			if(genericDocumentID == null) throw new VemoAPI.VemoAPIFaultException('genericDocumentID is a required input parameter on PUT');		
		}
	}

	//public static GenericDocumentService.GenericDocument genDocClassToGenDocObject(GenericDocument docClass){
	//	GenericDocument__c docObj = new GenericDocument__c();
	//	if(docClass.genericDocumentID != null) docObj.ID = docClass.genericDocumentID;
	//	if(docClass.type != null) docObj.Type__c = docClass.type;
	//	if(docClass.status != null) docObj.Status__c = docClass.status;

	//	return docObj;
	//}	

	public class GenericDocumentOutputV1{
		public String genericDocumentID {get;set;}
		public String type {get;set;}
		public String status {get;set;}
		public String attachmentID {get;set;}
		public String attachmentName {get;set;}
		public String attachmentURL {get;set;}
		public String parentID {get;set;}
		public String parentObjectType {get;set;}
		public String comments {get;set;}


		public GenericDocumentOutputV1(){

		}

		public GenericDocumentOutputV1(Boolean testValues){
			if(testValues){
				

			}
		}

		public GenericDocumentOutputV1(GenericDocumentService.GenericDocument doc){
			this.genericDocumentID = doc.genericDocumentID;
			this.type = doc.type;
			this.status = doc.status;
			this.attachmentID = doc.attachmentID;
			this.attachmentName = doc.attachmentName;
			this.attachmentURL = doc.attachmentURL;
			this.parentID = doc.parentID;
			this.parentObjectType = doc.parentObjectType;
			this.comments = doc.comments;
		}
	}
}