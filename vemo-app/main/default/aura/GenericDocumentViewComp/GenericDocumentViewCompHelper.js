({
	getGenericDocuments : function(component){
        console.log("GenericDocumentViewComp.Helper.getGenericDocuments()"); 
        console.log(component.get("v.recordId"));
		var action = component.get("c.getGenericDocumentList");
        action.setParams({
            recordId:component.get("v.recordId")
        })
		action.setCallback(this,function(response){
            console.log(response);
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.genericDocumentData', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
			
		});
        console.log(action);
        console.log(component);
		$A.enqueueAction(action);
		
	}
})