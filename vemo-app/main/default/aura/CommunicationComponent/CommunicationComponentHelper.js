({
    getCommunicationEntries : function(cmp,ev) {
        
		var action = cmp.get("c.getCommunicationEntriesWithSchoolID");
        action.setParams({
            schoolID : cmp.get("v.schoolID"),
            studentId : null,
        });
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState: "+responseState);
            console.log(response.getReturnValue());
            
            cmp.find("fromDate").set("v.value",'');
            cmp.find("toDate").set("v.value",'');
            
            if (responseState === "SUCCESS") {
                cmp.set('v.allCommunicationEntries', response.getReturnValue());
                
            	var fullViewJS = cmp.get("v.fullView");
                console.log('###'+fullViewJS);
                
               
                cmp.set("v.totalSize", cmp.get("v.allCommunicationEntries").length);
                console.log(cmp.get("v.allCommunicationEntries").length);
                //cmp.set("v.start",0);
                var pageSize = cmp.get("v.pageSize");
                
                //cmp.set("v.end",pageSize-1);
                var paginationList = [];
                var studentListvar = [];
               var List2show = [];
                
                var counter = 0;
                for(var i=0; i< cmp.get("v.allCommunicationEntries").length; i++){
                    if(response.getReturnValue()[i].showOrNot != 'show'){
                        studentListvar.push(response.getReturnValue()[i]);
                    }
                    else{
                        cmp.set("v.fromDate",response.getReturnValue()[i].frm_Date);
                        cmp.set("v.toDate",response.getReturnValue()[i].to_Date);
                        List2show.push(response.getReturnValue()[i]);
                        counter++;
                    }
                }
                cmp.set('v.totalEntries',counter);
                cmp.set("v.totalPages",Math.ceil(counter/cmp.get("v.pageSize")));
                
                if(cmp.get("v.totalPages") == 0)
                    cmp.set("v.totalPages",1);
                
                for(var i=0; i< pageSize; i++)
                {	
                    //console.log(response.getReturnValue()[i].showOrNot);
                    if(List2show[i] != null && List2show[i] != '' && List2show[i].showOrNot == 'show')
                		paginationList.push(List2show[i]);
                    
    			}                
                cmp.set('v.paginationList', paginationList);
                console.log(studentListvar);
                //cmp.set('v.studentList',studentListvar);
                
                /*if(fullViewJS == 'true'){
                    this.displayAllEntries(cmp,ev);
                }
                else{
            		this.displayFiveEntries(cmp,ev);        
                }*/
                this.sortBy(cmp, "student");
            }
        	else{ 
            	if (responseState === "ERROR") {
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);             
    },
    
    /*displayFiveEntries : function(cmp,ev){
		var allEntries = cmp.get("v.allCommunicationEntries");
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
        cmp.set("v.toDisplayCommunicationEntries",tempList);
        //hide the spinner once complete
        cmp.set("v.Spinner", false);
	},
    
    displayAllEntries : function(cmp,ev){
    	var allEntries = cmp.get("v.allCommunicationEntries");
        cmp.set("v.toDisplayCommunicationEntries",allEntries); 
        //hide the spinner once complete
        cmp.set("v.Spinner", false);
    },*/
    
    sortBy: function(component, field) {
        console.log('### In sort');
        var sortAsc = component.get("v.sortAsc"),
        	sortField = component.get("v.sortField"),
        	records = component.get("v.allCommunicationEntries");
        	sortAsc = field == sortField? !sortAsc: true;
        
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.paginationList", records);
    },
    
    changerecords : function(component, event) 
    {
     	var communicationList = component.get("v.allCommunicationEntries");
        console.log(communicationList);
        
        var List2show = [];                
        
        for(var i=0; i< communicationList.length; i++){            
            if(communicationList[i].showOrNot != 'show'){               
                //studentListvar.push(response.getReturnValue()[i]);
            }
            else{
                List2show.push(communicationList[i]);
            }
        }  
        
        var pageSize = component.get("v.pageSize");
        
        var paginationList = [];        
        
        for(var i= pageSize*(component.get("v.pageNumber")-1); i <= (pageSize*component.get("v.pageNumber")-1); i++)
        {            
        	if(communicationList[i] != null && communicationList[i] !='' && communicationList[i].showOrNot == 'show')
            {
            	paginationList.push(communicationList[i]);
         	}            
        }       
        component.set('v.paginationList', paginationList);        
 	},
    
    studentSearchHelper : function(cmp, event, helper) 
    {
     	var action = cmp.get("c.searchStudent");
		//console.log(cmp.find("stud").get("v.value"));
        action.setParams({
            schoolID : cmp.get("v.schoolID"),
           studentName : cmp.get("v.selectedStudent"),
        });
        
        action.setCallback(this, function(response){
            var responseState = response.getState();
        	console.log("responseState: "+responseState);
            if (responseState === "SUCCESS") {
                console.log('ml');
                console.log(cmp.get("v.selectedStudent"));
                cmp.set("v.studentSearchList", response.getReturnValue());
                //console.log('BBB');
                //console.log(cmp.get("v.studentSearchList"));
            }
        	else{ 
            	if (responseState === "ERROR") {
                	console.log("ERROR: "+response.getReturnValue());
                }
            }
        });
        
        $A.enqueueAction(action);
 	},
    
    
})