({
    getStudent : function(cmp,ev){
    	var action = cmp.get("c.getStudent");
        action.setParams({
            "studentID" : cmp.get("v.studentID")
        });
        action.setCallback(this, function(response){
			var responseState = response.getState();
        	//console.log("responseState: "+responseState);
            if (responseState === "SUCCESS") {
                cmp.set("v.student", response.getReturnValue());
                console.log("Student object: "+response.getReturnValue());
                //console.log("@@@v.journalEntries"+cmp.get("v.journalEntries")[0].agreementID);
            }
        	else{ 
            	if (responseState === "ERROR") {
                	console.log("ERROR: "+response.getReturnValue());
                }
            }            
        });
        $A.enqueueAction(action);
    },
    
    getJournalEntries : function(cmp,ev) {
		var action = cmp.get("c.getJournalEntriesWithCustomerID");
        action.setParams({
            "studentID" : cmp.get("v.studentID")
        });
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState: "+responseState);
            if (responseState === "SUCCESS") {
                cmp.set("v.allJournalEntries", response.getReturnValue());
                cmp.set("v.totalEntries",response.getReturnValue().length);
                //console.log("SUCCESS: "+response.getReturnValue()[0].agreementID);
                //console.log("@@@v.journalEntries"+cmp.get("v.journalEntries")[0].agreementID);
            	var fullViewJS = cmp.get("v.fullView");
                console.log('###'+fullViewJS);
                if(fullViewJS == 'true'){
                    this.displayAllEntries(cmp,ev);
                }
                else{
            		this.displayFiveEntries(cmp,ev);        
                }
            }
        	else{ 
            	if (responseState === "ERROR") {
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);             
    },
    
    displayFiveEntries : function(cmp,ev){
		var allEntries = cmp.get("v.allJournalEntries");
        var tempList = new Array();
        var count = 0;
        for(var i=0;i<allEntries.length;i++){
            if(count<5){
            	tempList.push(allEntries[i]); 
                count++;
            }
            else{
                break;
            }
            
        }
        cmp.set("v.toDisplayJournalEntries",tempList);
        //hide the spinner once complete
        cmp.set("v.Spinner", false);
	},
    
    displayAllEntries : function(cmp,ev){
    	var allEntries = cmp.get("v.allJournalEntries");
        cmp.set("v.toDisplayJournalEntries",allEntries); 
        //hide the spinner once complete
        cmp.set("v.Spinner", false);
    }
})