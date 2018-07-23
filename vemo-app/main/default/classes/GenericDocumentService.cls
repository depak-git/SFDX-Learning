public with sharing class GenericDocumentService {
	public static List<GenericDocument> getGenericDocumentWithGenericDocumentID(Set<ID> genDocIDs){
		System.debug('GenericDocumentService.getGenericDocumentWithGenericDocumentID');
		Map<Id, GenericDocument__c> genDocObjMap = GenericDocumentQueries.getGenericDocumentMapByID(genDocIDs);
		List<GenericDocument> genDocList = new List<GenericDocument>();
		for(GenericDocument__c genDocObj : genDocObjMap.values()){
			genDocList.add(new GenericDocument(genDocObj));
		}
		return genDocList;
	}

	public static List<GenericDocument> getGenericDocumentWithParentID(Set<String> parentIDs){
		System.debug('GenericDocumentService.getGenericDocumentWithParentID');
		System.debug('greg2:'+parentIDs);
		Map<Id, GenericDocument__c> genDocObjMap = GenericDocumentQueries.getGenericDocumentMapByParentID(parentIDs);
		List<GenericDocument> genDocList = new List<GenericDocument>();
		for(GenericDocument__c genDocObj : genDocObjMap.values()){
			genDocList.add(new GenericDocument(genDocObj));
		}
		return genDocList;
	}

	public static Set<Id> createGenericDocument(List<GenericDocument> genericDocuments){
		System.debug('GenericDocumentService.createGenericDocument');
		List<GenericDocument__c> genDocList = new List<GenericDocument__c>();
		for(GenericDocument genDoc : genericDocuments){
			GenericDocument__c genDocObj = genDocClassToGenDocObject(genDoc);
			genDocList.add(genDocObj);
		}
		insert genDocList;
		Set<Id> genDocIDs = new Set<Id>();
		for(GenericDocument__c genDoc : genDocList){
			genDocIDs.add(genDoc.ID);
		}
		return genDocIDs;
	}
	public static Set<Id> updateGenericDocument(List<GenericDocument> genericDocuments){
		System.debug('GenericDocumentService.updateGenericDocument');
		List<GenericDocument__c> genDocList = new List<GenericDocument__c>();
		for(GenericDocument genDoc : genericDocuments){
			GenericDocument__c genDocObj = genDocClassToGenDocObject(genDoc);
			genDocList.add(genDocObj);
		}
		update genDocList;
		Set<Id> genDocIDs = new Set<Id>();
		for(GenericDocument__c genDoc : genDocList){
			genDocIDs.add(genDoc.ID);
		}
		return genDocIDs;
	}

	public static Integer deleteGenericDocument(Set<ID> genDocIDs){
		System.debug('GenericDocumentService.deleteGenericDocument');
		Map<ID, GenericDocument__c> genDocMap = GenericDocumentQueries.getGenericDocumentMapByID(genDocIDs);
		Integer numToDelete = genDocMap.size();
		delete genDocMap.values();
		return numToDelete;
	}
	public static GenericDocument__c genDocClassToGenDocObject(GenericDocument docClass){
		GenericDocument__c docObj = new GenericDocument__c();
		if(docClass.genericDocumentID != null) docObj.ID = docClass.genericDocumentID;
		if(docClass.type != null) docObj.Type__c = docClass.type;
		if(docClass.status != null) docObj.Status__c = docClass.status;
		if(docClass.parentID != null) docObj.ParentID__c = docClass.parentID;
		if(docClass.parentObjectType != null) docObj.ParentObjectType__c = docClass.parentObjectType;
		if(docClass.comments != null) docObj.Comments__c = docClass.comments;
		return docObj;
	}	

	public class GenericDocument{
		public String genericDocumentID {get;set;}
		public String type {get;set;}
		public String status {get;set;}
		public String attachmentID {get;set;}
		public String attachmentName {get;set;}
		public String attachmentURL {get;set;}
		public String parentID {get;set;}
		public String parentObjectType {get;set;}
		public String comments {get;set;}


		public GenericDocument(){

		}

		public GenericDocument(Boolean testValues){
			if(testValues){
				

			}
		}

		public GenericDocument(GenericDocument__c doc){
			this.genericDocumentID = doc.ID;
			this.type = doc.Type__c;
			this.status = doc.Status__c;
			this.attachmentID = doc.AttachmentID__c;
			this.attachmentName = doc.AttachmentName__c;
			this.attachmentURL = doc.AttachmentCleanURL__c;
			this.parentID = doc.ParentID__c;
			this.parentObjectType = doc.ParentObjectType__c;
			this.comments = doc.Comments__c;
		}
	}
}