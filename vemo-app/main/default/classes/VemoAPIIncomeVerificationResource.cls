/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIIncomeVerificationResource
// 
// Description: 
//  Direction Central for IncomeVerification API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-12   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIIncomeVerificationResource {
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
        System.debug('VemoAPIIncomeVerificationResource.handleGetV1');
        String incomeVerificationIDParam = api.params.get('incomeVerificationID');
        String studentIDParam = api.params.get('studentID');
        List<IncomeVerificationService.IncomeVerification> incVerList = new List<IncomeVerificationService.IncomeVerification>();
        if(incomeVerificationIDParam != null){
            incVerList = IncomeVerificationService.getIncomeVerificationWithIncomeVerificationID(VemoApi.parseParameterIntoIDSet(incomeVerificationIDParam));
        }
        else if(studentIDParam != null){
            incVerList = IncomeVerificationService.getIncomeVerificationWithStudentId(VemoApi.parseParameterIntoIDSet(studentIDParam));
        }
        else{
            throw new VemoAPI.VemoAPIFaultException('Required parameter incomeVerificationID or studentID');
        }
        List<IncomeVerificationOutputV1> results = new List<IncomeVerificationOutputV1>();
        for(IncomeVerificationService.IncomeVerification incVer : incVerList){
            results.add(new IncomeVerificationOutputV1(incVer));
        }
        return (new VemoAPI.ResultResponse(results, results.size()));

    }

    public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIIncomeVerificationResource.handlePostV1');
        List<IncomeVerificationService.IncomeVerification> newIncomeVerification = new List<IncomeVerificationService.IncomeVerification>();
        List<IncomeVerificationInputV1> incomeVerificationJSON = (List<IncomeVerificationInputV1>)JSON.deserialize(api.body, List<IncomeVerificationInputV1>.class);
        for(IncomeVerificationInputV1 incVer : incomeVerificationJSON){
            incVer.validatePOSTFields();
            IncomeVerificationService.IncomeVerification incVerServ = new IncomeVerificationService.IncomeVerification();
            incVerServ = incomeVerificationInputV1ToIncomeVerification(incVer);
            newIncomeVerification.add(incVerServ);
        }
        Set<ID> incVerIDs = IncomeVerificationService.createIncomeVerification(newIncomeVerification);
        return (new VemoAPI.ResultResponse(incVerIDs, newIncomeVerification.size()));
    }

    public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIIncomeVerificationResource.handlePutV1');
        List<IncomeVerificationService.IncomeVerification> newIncomeVerification = new List<IncomeVerificationService.IncomeVerification>();
        List<IncomeVerificationInputV1> incomeVerificationJSON = (List<IncomeVerificationInputV1>)JSON.deserialize(api.body, List<IncomeVerificationInputV1>.class);
        for(IncomeVerificationInputV1 incVer : incomeVerificationJSON){
            incVer.validatePUTFields();
            IncomeVerificationService.IncomeVerification incVerServ = new IncomeVerificationService.IncomeVerification();
            incVerServ = incomeVerificationInputV1ToIncomeVerification(incVer);
            newIncomeVerification.add(incVerServ);
        }
        Set<ID> incVerIDs = IncomeVerificationService.updateIncomeVerification(newIncomeVerification);
        return (new VemoAPI.ResultResponse(incVerIDs, newIncomeVerification.size()));
    }

    public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIIncomeVerificationResource.handleDeleteV1');
        String incomeVerificationIDParam = api.params.get('incomeVerificationID');
        Integer numToDelete = IncomeVerificationService.deleteIncomeVerificationy(VemoApi.parseParameterIntoIDSet(incomeVerificationIDParam));
        return (new VemoAPI.ResultResponse(true, numToDelete));
    }

    public class IncomeVerificationOutputV1{
        
        public IncomeVerificationOutputV1(IncomeVerificationService.IncomeVerification incVer){
            this.incomeVerificationID = incVer.incomeVerificationID;            
            this.incomePerYear = incVer.incomePerYear;
            this.incomePerMonth = incVer.incomePerMonth;
            this.employmentHistoryID = incVer.employmentHistoryID;
//          this.dateVerified = incVer.dateVerified;
            this.studentID = incVer.studentID;
            this.verified = incVer.verified;
            this.beginDate = incVer.beginDate;
            this.dateReported = incVer.dateReported;
            this.type = incVer.type;
            this.endDate = incVer.endDate;
            this.status = incVer.status;
        }
        public String incomeVerificationID {get;set;}
        public Decimal incomePerYear {get;set;}
        public Decimal incomePerMonth {get;set;}
        public String employmentHistoryID {get;set;}
//      public Date dateVerified {get;set;}
        public Date dateReported {get;set;}
        public Date beginDate {get;set;}
        public String studentID {get;set;}
        public String verified {get;set;}
        public String type {get;set;}
        public Date endDate {get;set;}
        public String status {get;set;}
    }

    public class IncomeVerificationInputV1{
        public String incomeVerificationID {get;set;}
        public Decimal incomePerMonth {get;set;}
        public String employmentHistoryID {get;set;}
        public String studentID {get;set;}
        public Date dateReported {get;set;}
        public Date beginDate {get;set;}
        public Date endDate {get;set;}
        public String type {get;set;}
        public String status {get;set;}

        public IncomeVerificationInputV1(Boolean testValues){
            if(testValues){
                this.incomePerMonth = 1000; 
            }
        }

        public void validatePOSTFields(){
            if(incomeVerificationID != null) throw new VemoAPI.VemoAPIFaultException('incomeVerificationID cannot be created in POST');
            if(incomePerMonth == null) throw new VemoAPI.VemoAPIFaultException('incomePerMonth is a required parameter on POST');
        }
        public void validatePUTFields(){
            if(incomeVerificationID == null) throw new VemoAPI.VemoAPIFaultException('incomeVerificationID is a required input parameter on PUT');
            if(studentID != null) throw new VemoAPI.VemoAPIFaultException('studentID is not a writable input parameter on PUT');
        }
    }

    public static IncomeVerificationService.IncomeVerification incomeVerificationInputV1ToIncomeVerification(IncomeVerificationInputV1 input){
        IncomeVerificationService.IncomeVerification output = new IncomeVerificationService.IncomeVerification();
        output.incomeVerificationID = input.incomeVerificationID;           
        output.incomePerMonth = input.incomePerMonth;
        output.employmentHistoryID = input.employmentHistoryID;
        output.studentID = input.studentID;
        output.dateReported = input.dateReported;
        output.beginDate = input.beginDate;
        output.endDate = input.endDate;
        output.type = input.type;
        output.status = input.status;
        return output;
    }
}