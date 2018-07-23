({
	doInit : function(component, event, helper) {
		//show spinner while initializing
        //component.set("v.Spinner", true);
        component.set("v.pageNumber",1);
        var str = '/apex/StudentCommunications?Id=';
        str += component.get("v.schoolID");
        str += '&fullView=true';
        component.set("v.redirectURL",str);
        helper.getCommunicationEntries(component,event);
        component.set("v.sortAsc", true);
        
        //component.set("v.Spinner", false);
    },
    
    handleClick: function(cmp, ev, helper) {
        var fDate = cmp.find("fromDate").get("v.value");
        var tDate = cmp.find("toDate").get("v.value");        
        
        var action = cmp.get("c.getCommunicationEntriesWithSchoolID");
		//cmp.set('v.schoolID','null');
		console.log(cmp.get("v.selectedValue"));
        action.setParams({
           schoolID : cmp.get("v.schoolID"),
           studentId : cmp.get("v.selectedValue"),
           fromDate : fDate,
           toDate : tDate
        });
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState: "+responseState);
            if (responseState === "SUCCESS") {
                cmp.set("v.allCommunicationEntries", response.getReturnValue());
                //cmp.set("v.totalEntries",response.getReturnValue().length);
                //console.log(cmp.get("v.toDisplayCommunicationEntries"));
                console.log('ABC: '+cmp.get("v.totalEntries"));
            	var fullViewJS = cmp.get("v.fullView");
                console.log('###'+fullViewJS);
                //console.log(cmp.get("v.allCommunicationEntries").length);
                
                cmp.set("v.totalSize", cmp.get("v.allCommunicationEntries").length);
                //cmp.set("v.totalPages",Math.ceil(cmp.get("v.allCommunicationEntries").length/cmp.get("v.pageSize")));
                //cmp.set("v.start",0);
                cmp.set("v.pageNumber",1);
                var pageSize = cmp.get("v.pageSize");
                //cmp.set("v.end",pageSize-1);
                var paginationList = [];
                var List2show = [];
                
                var counter = 0;
                for(var i=0; i< cmp.get("v.allCommunicationEntries").length; i++){
                    if(response.getReturnValue()[i].showOrNot != 'show'){
                        //studentListvar.push(response.getReturnValue()[i]);
                    }
                    else{
                        List2show.push(response.getReturnValue()[i]);
                        counter++;
                    }
                }
                cmp.set('v.totalEntries',counter);
                cmp.set("v.totalPages",Math.ceil(counter/cmp.get("v.pageSize")));
                
                for(var i=0; i< pageSize; i++)
                {
                    if(List2show[i] != null && List2show[i] != '' && List2show[i].showOrNot == 'show')
                		paginationList.push(List2show[i]);    
    			}                
                cmp.set('v.paginationList', paginationList);
            
                helper.sortBy(cmp, "student");
                helper.sortBy(cmp, "student"); // To keep order same as original
            }
        	else{ 
            	if (responseState === "ERROR") {
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        
        $A.enqueueAction(action); 
        
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
   
    hideSpinner : function(component,event,helper){
    	component.set("v.Spinner", false);   
    },
    sortByType: function(component, event, helper) {
        helper.sortBy(component, "type");
    },
    sortByStudent: function(component, event, helper) {
        helper.sortBy(component, "student");
    },
    sortByCreated: function(component, event, helper) {
        helper.sortBy(component, "createdDate");
    },
    sortBySubject: function(component, event, helper) {
        helper.sortBy(component, "subject");
    },
 	/*sortByProgram: function(component, event, helper) {
        helper.sortBy(component, "program");
    },*/
    
    
    next : function(component, event, helper) 
    {        
        component.set('v.pageNumber',component.get("v.pageNumber")+1);
        helper.changerecords(component,event);
 	},
    previous : function(component, event, helper) 
    {        
        component.set('v.pageNumber',component.get("v.pageNumber")-1);
        helper.changerecords(component,event);
 	},
    
    changePageNumber : function(component, event, helper) 
    {
     	helper.changerecords(component,event);        
 	},
    studentChange : function(cmp, event, helper) 
    {
     	var fDate = cmp.find("fromDate").get("v.value");
        var tDate = cmp.find("toDate").get("v.value");
        
        cmp.set("v.selectedValue",event.currentTarget.dataset.id);
        cmp.set("v.selectedStudent",event.currentTarget.dataset.name);
        cmp.set("v.studentSearchList",null)      
        
        var action = cmp.get("c.getCommunicationEntriesWithSchoolID");
		console.log(cmp.get("v.selectedValue"));
        action.setParams({
           schoolID : cmp.get("v.schoolID"),
           studentId : cmp.get("v.selectedValue"),
           fromDate : fDate,
           toDate : tDate
        });
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState: "+responseState);
            if (responseState === "SUCCESS") {
                cmp.set("v.allCommunicationEntries", response.getReturnValue());
                cmp.set("v.totalEntries",response.getReturnValue().length);
                console.log('MKM');
                console.log(response.getReturnValue());
                //console.log(cmp.get("v.toDisplayCommunicationEntries"));
                console.log(cmp.get("v.totalEntries"));
            	var fullViewJS = cmp.get("v.fullView");
                console.log('###'+fullViewJS);
                //console.log(cmp.get("v.allCommunicationEntries").length);
                
                cmp.set("v.totalSize", cmp.get("v.allCommunicationEntries").length);
                cmp.set("v.totalPages",Math.ceil(cmp.get("v.allCommunicationEntries").length/cmp.get("v.pageSize")));
                //cmp.set("v.start",0);
                cmp.set("v.pageNumber",1);
                var pageSize = cmp.get("v.pageSize");
                //cmp.set("v.end",pageSize-1);
                var paginationList = [];
                
                for(var i=0; i< pageSize; i++)
                {
                    if(response.getReturnValue()[i] != null && response.getReturnValue()[i] != '' && response.getReturnValue()[i].showOrNot == 'show')
                		paginationList.push(response.getReturnValue()[i]);    
    			}                
                cmp.set('v.paginationList', paginationList);            
            
                helper.sortBy(cmp, "student");
                helper.sortBy(cmp, "student"); // To keep order same as original
            }
        	else{ 
            	if (responseState === "ERROR") {
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        
        $A.enqueueAction(action);        
 	},
    
    studentSearch : function(cmp, event, helper) 
    {
     	if(cmp.get("v.selectedStudent").length > 0){
     		setTimeout($A.getCallback(() => helper.studentSearchHelper(cmp, event)), 1000);
        }
        else{
            cmp.set("v.studentSearchList", null);
            var fDate = cmp.find("fromDate").get("v.value");
        var tDate = cmp.find("toDate").get("v.value");
        
        cmp.set("v.selectedValue",null);
        cmp.set("v.selectedStudent",'');
        cmp.set("v.studentSearchList",null)      
        
        var action = cmp.get("c.getCommunicationEntriesWithSchoolID");
		console.log(cmp.get("v.selectedValue"));
        action.setParams({
           schoolID : cmp.get("v.schoolID"),
           studentId : cmp.get("v.selectedValue"),
           fromDate : fDate,
           toDate : tDate
        });
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState: "+responseState);
            if (responseState === "SUCCESS") {
                cmp.set("v.allCommunicationEntries", response.getReturnValue());
                cmp.set("v.totalEntries",response.getReturnValue().length);
                console.log('MKM');
                console.log(response.getReturnValue());
                //console.log(cmp.get("v.toDisplayCommunicationEntries"));
                console.log(cmp.get("v.totalEntries"));
            	var fullViewJS = cmp.get("v.fullView");
                console.log('###'+fullViewJS);
                //console.log(cmp.get("v.allCommunicationEntries").length);
                
                cmp.set("v.totalSize", cmp.get("v.allCommunicationEntries").length);
                cmp.set("v.totalPages",Math.ceil(cmp.get("v.allCommunicationEntries").length/cmp.get("v.pageSize")));
                //cmp.set("v.start",0);
                cmp.set("v.pageNumber",1);
                var pageSize = cmp.get("v.pageSize");
                //cmp.set("v.end",pageSize-1);
                var paginationList = [];
                
                for(var i=0; i< pageSize; i++)
                {
                    if(response.getReturnValue()[i] != null && response.getReturnValue()[i] != '' && response.getReturnValue()[i].showOrNot == 'show')
                		paginationList.push(response.getReturnValue()[i]);    
    			}                
                cmp.set('v.paginationList', paginationList);            
            
                helper.sortBy(cmp, "student");
                helper.sortBy(cmp, "student"); // To keep order same as original
            }
        	else{ 
            	if (responseState === "ERROR") {
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        
        $A.enqueueAction(action);
        }
 	},
    
    onblur : function(cmp, event, helper) 
    {
     	cmp.set("v.studentSearchList",null);
        //cmp.set("v.selectedStudent",'');
 	},
    
})