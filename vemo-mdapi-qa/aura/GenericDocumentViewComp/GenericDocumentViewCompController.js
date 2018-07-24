({
	doInit : function(component, event, helper) {
        console.log("GenericDocumentViewComp.Controller.doInit()");
        helper.getGenericDocuments(component);
        component.set('v.genericDocumentDataColumns', [
            {label: 'Document ID', fieldName: 'Id', type: 'text'},
            {label: 'Document Type', fieldName: 'Type__c', type: 'text'},
            {label: 'Document Status', fieldName: 'Status__c', type: 'text'},
            {label: 'Attachment ID', fieldName: 'AttachmentID__c', type: 'text'},
            {label: 'Attachment URL', fieldName: 'AttachmentCleanURL__c', type: 'url'}
        ]);
        /*
        component.set('v.genericDocumentData', [{
            documentName: 'a',
            documentURL: 'www.google.com'
        },
        {
            documentName: 'b',
            documentURL: 'www.yahoo.com'
        }]);*/
    }
})