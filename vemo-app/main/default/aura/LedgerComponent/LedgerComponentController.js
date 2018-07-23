({
	doInit : function(component, event, helper) {
		//show spinner while initializing
        component.set("v.Spinner", true);
        // console.log('Initialization started...');
        var str = '/apex/LedgerView?Id=';
        str += component.get("v.studentID");
        str += '&fullView=true';
        component.set("v.redirectURL",str);
        helper.getJournalEntries(component,event);
        helper.getStudent(component,event);
    },
      
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
   
    hideSpinner : function(component,event,helper){
    	component.set("v.Spinner", false);   
    }
})