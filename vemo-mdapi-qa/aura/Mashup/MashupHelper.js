({
    doInit : function(cmp, ev) {
        var action = cmp.get("c.getRecords");
 		action.setParams({
            "accountId": cmp.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("test--"+response.getReturnValue());
            if (state === "SUCCESS") {
                //alert("success!!");
                cmp.set("v.rec", response.getReturnValue());
                console.log("response"+response.getReturnValue());
            }
            else if (state === "ERROR") {
            	//alert('Failed');   
            }
        });
        $A.enqueueAction(action);
    }
})