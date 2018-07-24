/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIDisbursementResource
// 
// Description: 
//  Handles all Disbursement API Functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-28   Greg Cook       Created                         
// 
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIDisbursementResource implements VemoAPI.ResourceHandler {
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
        System.debug('VemoAPIDisbursementResource.handleGetV1');
        String disbursementIDParam = api.params.get('disbursementID');
        String agreementIDParam = api.params.get('agreementID');
        String schoolIDParam = api.params.get('schoolID');
        List<TransactionService.Disbursement> dists = new List<TransactionService.Disbursement>();
        if(disbursementIDParam != null){
            dists = TransactionService.getDisbursementWithDisbursementID(VemoApi.parseParameterIntoIDSet(disbursementIDParam));
        } else if(agreementIDParam != null){
            dists = TransactionService.getDisbursementWithAgreementID(VemoApi.parseParameterIntoIDSet(agreementIDParam));
        } else if(schoolIDParam != null){
            //filter by Confirmed checkbox on Disbursement
            if(api.params.containsKey('confirmed')){
                DatabaseUtil.filterByConfirmFlag = true;
                DatabaseUtil.confirmFlag = api.params.get('confirmed') == 'true' ? true : false;
            }
            //filter by transaction date
            if(api.params.containsKey('fromDate')){
                DatabaseUtil.filterByDate = true;
                DatabaseUtil.fromDate = Date.parse(api.params.get('fromDate'));
            }
            if(api.params.containsKey('toDate')){
                DatabaseUtil.filterByDate = true;
                DatabaseUtil.toDate = Date.parse(api.params.get('toDate'));
            }
            dists = TransactionService.getDisbursementWithSchoolID(VemoApi.parseParameterIntoIDSet(schoolIDParam));
        }
        else{
            throw new VemoAPI.VemoAPIFaultException('Missing parameter: disbursementID or agreementID or schoolID required for GET');
        }
        List<DisbursementResourceOutputV1> results = new List<DisbursementResourceOutputV1>();
        for(TransactionService.Disbursement dis : dists){
            results.add(new DisbursementResourceOutputV1(dis));
        }
        return (new VemoAPI.ResultResponse(results, results.size()));
    }

    public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIDisbursementResource.handlePostV1');
        List<TransactionService.Disbursement> newDisbursements = new List<TransactionService.Disbursement>();
        List<DisbursementResourceInputV1> DisbursementJSON = (List<DisbursementResourceInputV1>)JSON.deserialize(api.body, List<DisbursementResourceInputV1>.class);
        for(DisbursementResourceInputV1 disRes : DisbursementJSON){
            disRes.validatePOSTFields();
            TransactionService.Disbursement dis = disbursementResourceV1ToDisbursement(disRes);
            newDisbursements.add(dis);
        }
        Set<ID> disIDs = TransactionService.createDisbursements(newDisbursements);
        return (new VemoAPI.ResultResponse(disIDs, disIDs.size()));
    }

    public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIDisbursementResource.handlePutV1');
        List<TransactionService.Disbursement> newDisbursements = new List<TransactionService.Disbursement>();
        List<DisbursementResourceInputV1> DisbursementJSON = (List<DisbursementResourceInputV1>)JSON.deserialize(api.body, List<DisbursementResourceInputV1>.class);
        for(DisbursementResourceInputV1 disRes : DisbursementJSON){
            disRes.validatePUTFields();
            TransactionService.Disbursement dis = disbursementResourceV1ToDisbursement(disRes);
            newDisbursements.add(dis);
        }
        Set<ID> disIDs = TransactionService.updateDisbursements(newDisbursements);
        return (new VemoAPI.ResultResponse(disIDs, disIDs.size()));
    }

    public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIDisbursementResource.handleDeleteV1');
        String disIDParam = api.params.get('disbursementID');       
        Integer numToDelete = TransactionService.deleteDisbursements(VemoApi.parseParameterIntoIDSet(disIDParam));
        return (new VemoAPI.ResultResponse(true, numToDelete));
    }

    public static TransactionService.Disbursement disbursementResourceV1ToDisbursement(DisbursementResourceInputV1 disRes){
        TransactionService.Disbursement dis = new TransactionService.Disbursement();
        dis.disbursementID = disRes.disbursementID;
        dis.studentID = disRes.studentID;
        dis.agreementID = disRes.agreementID;
        dis.relatedScheduleID = disRes.relatedScheduleID;
        dis.amount = disRes.amount;
        dis.transactionDate = disRes.transactionDate;
        dis.status = disRes.status;
        dis.specialDisbursementType  = disRes.specialDisbursementType; 
        dis.confirmed = disRes.confirmed;
        dis.schoolSecurity = disRes.schoolSecurity;
        dis.disbursementPercentage = disRes.disbursementPercentage;
        return dis;
    }

    public class DisbursementResourceInputV1{
        public String disbursementID {get;set;}
        public String studentID {get;set;}
        public String agreementID {get;set;}
        public String relatedScheduleID {get;set;}
        public Decimal amount {get;set;}
        public Date transactionDate {get;set;}
        public String status {get;set;}
        public String specialDisbursementType {get;set;}
        public String confirmed {get;set;}
        public String schoolSecurity {get;set;}
        public Decimal disbursementPercentage {get;set;}
        
        public DisbursementResourceInputV1(){}

        public DisbursementResourceInputV1(Boolean testValues){
            if(testValues){
                this.transactionDate = Date.today();
                this.amount = 1000; 
                this.status = 'Complete'; //Pending, Scheduled  
            }
        }
        public void validatePOSTFields(){
            if(disbursementID != null) throw new VemoAPI.VemoAPIFaultException('disbursementID cannot be created in POST');             
        }
        public void validatePUTFields(){
            if(disbursementID == null) throw new VemoAPI.VemoAPIFaultException('disbursementID is a required input parameter on PUT');      
        }
    }

    public class DisbursementResourceOutputV1{
        public String disbursementID {get;set;}
        public String studentID {get;set;}
        public String agreementID {get;set;}
        public String relatedScheduleID {get;set;}
        public Decimal amount {get;set;}
        public Date transactionDate {get;set;}
        public Decimal disbursementPercentage {get;set;}
        public String status {get;set;}
        public String confirmed {get;set;}
        public String schoolSecurity {get;set;}
        public string specialDisbursementType {get;set;}
        public String studentName {get;set;}
        public String programID {get;set;}
        public String programName {get;set;}
        public String vemoContractNumber {get;set;} 
        public String agreementStatus {get;set;}

        public DisbursementResourceOutputV1(TransactionService.Disbursement dis){
            this.disbursementID = dis.disbursementID;
            this.studentID = dis.studentID;
            this.agreementID = dis.agreementID;
            this.relatedScheduleID = dis.relatedScheduleID;
            this.amount = dis.amount;
            this.transactionDate = dis.transactionDate;
            this.disbursementPercentage = dis.disbursementPercentage;
            this.status = dis.status;
            this.confirmed = dis.confirmed;
            this.schoolSecurity = dis.schoolSecurity;
            this.specialDisbursementType = dis.specialDisbursementType; 
            this.studentName = dis.studentName;
            this.programID = dis.programID;
            this.programName = dis.programName;
            this.vemoContractNumber  = dis.vemoContractNumber; 
            this.agreementStatus = dis.agreementStatus;
        }
    }

}