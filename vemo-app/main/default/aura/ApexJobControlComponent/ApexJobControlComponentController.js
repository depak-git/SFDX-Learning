({
	getDetail : function(cmp, event, helper) {
        
        cmp.set("v.jobName",event.currentTarget.dataset.name);
        
        var action = cmp.get("c.getdetails");
        
        action.setParams({
           jobName : cmp.get("v.jobName")           
        });
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState: "+responseState);
            if (responseState === "SUCCESS") {               
                    
                	cmp.set("v.ApexJobControlVar",response.getReturnValue());
                	
                	if(response.getReturnValue().CronMode__c.toUpperCase() == 'HOURLY')
                    	cmp.set("v.mode",false);
                	else
                        cmp.set("v.mode",true);
                
                	if(response.getReturnValue().SchedulerActive__c == true)
                        cmp.set("v.schedulerActive",true);
                	
                	cmp.set("v.detailView",true);
                	cmp.set("v.showComponent",true);
                    //alert(cmp.get("v.detailView"));
                    console.log(cmp.get("v.detailView"));               
            }
        	else{ 
            	if (responseState === "ERROR") {
                    //alert('Fail');
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
		
	},
    
    doInit : function(cmp, event, helper) {
        cmp.set("v.showComponent",false);
        var action = cmp.get("c.getCustomSettingsRecord");
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState11: "+responseState);
            console.log(response.getReturnValue());
            if (responseState === "SUCCESS"){
                cmp.set("v.jobList",response.getReturnValue());
            }
        	else{ 
            	if (responseState === "ERROR") {
                    //alert('Fail');
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
		
	},
    
    getComponent : function(cmp, event, helper) {
        var fDate = event.currentTarget.dataset.name;
        console.log(fDate);
		
	},
    
    runNow : function(cmp, event, helper) {
        var action = cmp.get("c.runJobNow");        
        action.setParams({
            apxjobCtr : cmp.get("v.ApexJobControlVar")
        });
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
            if (responseState === "SUCCESS") {
                console.log('SUCCESS');
                //alert(response.getReturnValue());
                cmp.set("v.message2show", response.getReturnValue());
                window.setTimeout( 
                    $A.getCallback(function() { 
                        cmp.set("v.message2show", ''); 
                    }), 3000
                );
            }
            else{ 
                console.log('FAILED');
                cmp.set("v.message2show", 'Failed to Run');
                window.setTimeout( 
                    $A.getCallback(function() { 
                        cmp.set("v.message2show", ''); 
                    }), 3000
                );
                //alert('Failed to Run');
            }
        });
        $A.enqueueAction(action);
        
    },

    activateTheScheduler : function(cmp, event, helper) {
        
        var action = cmp.get("c.schedule_UnscheduleTheJob");
        
        var mode;
        if(cmp.get("v.mode") == false)
            mode = 'hourly';
        if(cmp.get("v.mode") == true)
            mode = 'daily';
        //alert(cmp.get("v.mode"));
        //alert(mode);
        action.setParams({
            
            mode : mode,
            apxjobCtr : cmp.get("v.ApexJobControlVar")
        });
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
            if (responseState === "SUCCESS") {
                if(response.getReturnValue() == 'Successfully Scheduled')
                	cmp.set("v.schedulerActive",true);
                if(response.getReturnValue() == 'Successfully Unscheduled')
                    cmp.set("v.schedulerActive",false);
                //alert(response.getReturnValue());
                cmp.set("v.message2show", response.getReturnValue());
                window.setTimeout( 
                    $A.getCallback(function() { 
                        cmp.set("v.message2show", ''); 
                    }), 3000
                );
            }
            else{ 
                cmp.set("v.message2show", 'Failed to schedule/unschedule');
                window.setTimeout( 
                    $A.getCallback(function() { 
                        cmp.set("v.message2show", ''); 
                    }), 3000
                );
                //alert();
            }
        });
        $A.enqueueAction(action);
        
    },
    
    hourlyMode : function(cmp, event, helper) {
        //alert('Hour');
        cmp.set("v.mode",false);
    },
    
    dailyMode : function(cmp, event, helper) {
        //alert('Day');
        cmp.set("v.mode",true);
        
    }
});