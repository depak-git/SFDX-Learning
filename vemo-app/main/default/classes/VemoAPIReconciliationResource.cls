public with sharing class VemoAPIReconciliationResource implements VemoAPI.ResourceHandler {
    
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
        System.debug('VemoAPIReconciliationResource.handleGetV1');
        
        String studentIDParam = api.params.get('studentID');
        
        List<ReconciliationService.Reconciliation> vcr = new List<ReconciliationService.Reconciliation>();
        
        if(studentIDParam != null){
            vcr = ReconciliationService.getReconciliationMapWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
        }
        else{
            throw new VemoAPI.VemoAPIFaultException('Missing parameter: studentID required for GET');
        }
        
        List<VemoReconciliationResourceOutputV1> results = new List<VemoReconciliationResourceOutputV1>();
        
        for(ReconciliationService.Reconciliation vr : vcr){
            VemoReconciliationResourceOutputV1 result = new VemoReconciliationResourceOutputV1(vr);
            
            result.reconciliationDetails = new List<VemoReconciliationDetailResourceOutputV1>();
            List<ReconciliationService.ReconciliationDetail> rDetails = ReconciliationService.getReconciliationDetailMapWithReconciliationID(new Set<ID>{vr.reconciliationID});
            for(ReconciliationService.ReconciliationDetail rDetail : rDetails){
                result.reconciliationDetails.add(new VemoReconciliationDetailResourceOutputV1(rDetail));
            }
            results.add(result);
        }
        return (new VemoAPI.ResultResponse(results, results.size()));
    }
    
    public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){ 
        System.debug('VemoAPIReconciliationResource.handlePostV1()');  

        String modeParam = api.params.get('mode');

        if(modeParam == 'detail'){
            List<ReconciliationService.ReconciliationDetail> rDetails = new List<ReconciliationService.ReconciliationDetail>();
            List<VemoReconciliationDetailResourceInputV1> rDetailsJSON = (List<VemoReconciliationDetailResourceInputV1>)JSON.deserialize(api.body, List<VemoReconciliationDetailResourceInputV1>.class);
            for(VemoReconciliationDetailResourceInputV1 rDetailJSON: rDetailsJSON){
                rDetailJSON.validatePOSTFields();
                rDetails.add(rDetailResourceToRDetail(rDetailJSON));
            }       
            Set<Id> rDetailIDs = ReconciliationService.createRDetails(rDetails);
            return (new VemoAPI.ResultResponse(rDetailIDs, rDetailIDs.size()));            
        }
        return null;
    }
    
    public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){ 
        System.debug('VemoAPIReconciliationResource.handlePutV1()');  
        String modeParam = api.params.get('mode');

        if(modeParam == 'detail'){
            List<ReconciliationService.ReconciliationDetail> rDetails = new List<ReconciliationService.ReconciliationDetail>();
            List<VemoReconciliationDetailResourceInputV1> rDetailsJSON = (List<VemoReconciliationDetailResourceInputV1>)JSON.deserialize(api.body, List<VemoReconciliationDetailResourceInputV1>.class);
            for(VemoReconciliationDetailResourceInputV1 rDetailJSON: rDetailsJSON){
                rDetailJSON.validatePUTFields();
                rDetails.add(rDetailResourceToRDetail(rDetailJSON));
            }       
            Set<Id> rDetailIDs = ReconciliationService.updateRDetails(rDetails);
            return (new VemoAPI.ResultResponse(rDetailIDs, rDetailIDs.size()));
        } else if(modeParam == 'header'){
            List<ReconciliationService.Reconciliation> recons = new List<ReconciliationService.Reconciliation>();
            List<VemoReconciliationResourceInputV1> reconsJSON = (List<VemoReconciliationResourceInputV1>)JSON.deserialize(api.body, List<VemoReconciliationResourceInputV1>.class);
            for(VemoReconciliationResourceInputV1 rJSON: reconsJSON){
                recons.add(reconResourceToReconObj(rJSON));
            }       
            Set<Id> reocnIDs = ReconciliationService.updateRecons(recons);
            return (new VemoAPI.ResultResponse(reocnIDs, reocnIDs.size()));
        }
        return null;
    }
    
    public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIReconciliationResource.handleDeleteV1()');
        String rDetailIDparam = api.params.get('reconciliationDetailID');
        Integer numToDelete = ReconciliationService.deleteRDetails(VemoApi.parseParameterIntoIDSet(rDetailIDparam)); 
        return (new VemoAPI.ResultResponse(true, numToDelete));
    }
    
    public static ReconciliationService.ReconciliationDetail rDetailResourceToRDetail(VemoReconciliationDetailResourceInputV1 rDetail){
        ReconciliationService.ReconciliationDetail rd = new ReconciliationService.ReconciliationDetail();
        rd.reconciliationDetailID = rDetail.reconciliationDetailID ;
        rd.reconciliationID = rDetail.reconciliationID ;
        rd.employerStartDate = rDetail.employerStartDate;
        rd.employerEndDate = rDetail.employerEndDate;
        rd.usTaxincome = rDetail.usTaxincome;
        rd.employerName = rDetail.employerName;
        return rd;
    }

    public static ReconciliationService.Reconciliation reconResourceToReconObj(VemoReconciliationResourceInputV1 reconRes){
        ReconciliationService.Reconciliation recon = new ReconciliationService.Reconciliation();
        recon.reconciliationID = reconRes.reconciliationID ;
        recon.agreementSigned = reconRes.agreementSigned;
        recon.shouldHaveDetail = reconRes.shouldHaveDetail;
        recon.status = reconRes.status;
        return recon;
    }

    public class VemoReconciliationResourceInputV1{
        public String reconciliationID {get;set;}
        public String agreementSigned {get;set;} 
        public String shouldHaveDetail {get;set;}    
        public String status {get;set;}
    }
    public class VemoReconciliationDetailResourceInputV1{
        public String reconciliationDetailID {get;set;}
        public String reconciliationID {get;set;}
        public date employerStartDate {get;set;}
        public date employerEndDate {get;set;}
        public String employerName {get;set;}
        public boolean usTaxIncome {get;set;}

        public VemoReconciliationDetailResourceInputV1 (Boolean testValues){
            if(testValues){
            }
        }

        public void validatePOSTFields(){
            if(reconciliationDetailID != null) throw new VemoAPI.VemoAPIFaultException('reconciliationDetailID cannot be created in POST');
        }

        public void validatePUTFields(){
            if(reconciliationDetailID == null) throw new VemoAPI.VemoAPIFaultException('reconciliationDetailID is a required input parameter on PUT');
        }
    }
    
    public class VemoReconciliationResourceOutputV1{
        public String reconciliationID {get;set;}

        public Date dateFrom {get;set;}
        public Date dateThrough {get;set;}
        public String agreementSigned {get;set;}
        public String adobeSignStatus {get;set;}
        public String adobeSignURL {get;set;}
        public String shouldHaveDetail {get;set;}
        public String studentID {get;set;}
        public string status {get;set;}
        public List<VemoReconciliationDetailResourceOutputV1> reconciliationDetails {get;set;}

        public VemoReconciliationResourceOutputV1(ReconciliationService.Reconciliation rc){
            this.reconciliationID = rc.reconciliationID;
            this.adobeSignStatus = rc.adobeSignStatus;
            this.adobeSignURL = rc.adobeSignURL;
            this.agreementSigned = rc.agreementSigned;
            this.dateFrom = rc.dateFrom;  
            this.dateThrough = rc.dateThrough;
            this.shouldHaveDetail = rc.shouldHaveDetail;
            this.status = rc.status;
            this.studentID = rc.studentID;
        }
    }
    
    public class VemoReconciliationDetailResourceOutputV1{
        public String reconciliationDetailID {get;set;}
        public String reconciliationID {get;set;}
        public date employerStartDate {get;set;}
        public date employerEndDate {get;set;}
        public boolean usTaxincome {get;set;}
        public String employerName {get;set;}

        public VemoReconciliationDetailResourceOutputV1(ReconciliationService.ReconciliationDetail rd){
            this.reconciliationDetailID = rd.reconciliationDetailID;
            this.reconciliationID = rd.reconciliationID;
            this.employerStartDate = rd.employerStartDate;
            this.employerEndDate = rd.employerEndDate;
            this.usTaxincome = rd.usTaxincome;
            this.employerName = rd.employerName;
        }
    }
 
}