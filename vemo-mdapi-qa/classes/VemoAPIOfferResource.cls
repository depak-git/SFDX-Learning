/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIOfferResource
// 
// Description: 
//  Direction Central for Offer API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-25   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIOfferResource implements VemoAPI.ResourceHandler{
    public static Object handleAPI(VemoAPI.APIInfo api){
        if((api.version == 'v1') && (api.method == 'GET')){
            return handleGetV1(api);
        }
        if((api.version == 'v1') && (api.method == 'POST')){
            //todo return handlePostV1(api);
        }
        if((api.version == 'v1') && (api.method == 'PUT')){
            //todo return handlePutV1(api);
        }   
        if((api.version == 'v1') && (api.method == 'DELETE')){
            //todo return handleDeleteV1(api);
        }           
        throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
        return null;
    }

    public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
        System.debug('VemoAPIOfferResource.handleGetV1()');
        //String schoolIDParam = api.params.get('schoolID');
        String studentIDParam = api.params.get('studentID');
        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(VemoApi.parseParameterIntoIDSet(studentIDParam));
        Map<ID, List<OfferService.Offer>> offerMapByStudentID = OfferService.getOffersByStudentIDWithStudentMap(studentMap);
        system.debug('offerMapByStudentID:'+offerMapByStudentID);
        set<ID> programIDs = new set<ID>();
        List<OfferResourceOutputV1> results = new List<OfferResourceOutputV1>();
        if(offerMapByStudentID.size()>0 && offerMapByStudentID.containsKey(studentIDParam)){
            for(OfferService.Offer offer : offerMapByStudentID.get(studentIDParam)){
                programIDs.add(offer.programId); 
                results.add(new OfferResourceOutputV1(offer));
            }           
        }
        try{
            Map<id,List<TransactionScheduleService.transactionSchedule>> txSchMap = transactionScheduleService.gettransactionSchedulesByProgramIDWithProgramID(programIds);
            for(OfferResourceOutputV1 offer: results){
                List<TransactionScheduleService.TransactionSchedule> txSchList = new List<TransactionScheduleService.TransactionSchedule>();
                offer.transactionSchedules = new List<VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1>();
                if(txSchMap.containsKey(offer.programID)){
                   txSchList = txSchMap.get(offer.programID);
                   for(TransactionScheduleService.transactionSchedule sch : txSchList){
                        VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1 txSchResource = new VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1(sch);    
                        offer.transactionSchedules.add(txSchResource);
                   }  
                } 
            }
        }catch(exception e){
             System.debug('Exception with Transaction Schedules: '+e.getMessage());
        }

        return (new VemoAPI.ResultResponse(results, results.size()));
    }
/*
    public static VemoAPI.ResultResponse handlePostV1(VemoAPI.APIInfo api){
        return null;
    }


    public static VemoAPI.ResultResponse handlePutV1(VemoAPI.APIInfo api){
        return null;
    }

    public static VemoAPI.ResultResponse handleDeleteV1(VemoAPI.APIInfo api){
        return null;
    }
*/

    public static OfferService.Offer offerResourceV1toOffer(OfferResourceInputV1 offerRes){
        OfferService.Offer offer = new OfferService.Offer();
        offer.programID = offerRes.programID;
        offer.programName = offerRes.programName;
        offer.schoolID = offerRes.schoolID;
        offer.programStatus = offerRes.programStatus;
        offer.agreementStatus = offerRes.agreementStatus;
        offer.studentID = offerRes.studentID;
        offer.agreementID = offerRes.agreementID;
        offer.enrollmentEndDate = offerRes.enrollmentEndDate;
        offer.enrollmentBeginDate = offerRes.enrollmentBeginDate;
        offer.registrationBeginDate = offerRes.registrationBeginDate;
        offer.registrationEndDate = offerRes.registrationEndDate;
        return offer;
    }

    public class OfferResourceInputV1{
        public String programID {get;set;}
        public String programName {get;set;}
        public String schoolID {get;set;}
        public String programStatus {get;set;}
        public String agreementStatus {get;set;}
        public String studentID {get;set;}
        public String agreementID {get;set;}
        public Date enrollmentBeginDate {get;set;}
        public Date enrollmentEndDate {get;set;}
        public Date registrationBeginDate {get;set;}
        public Date registrationEndDate {get;set;}


    }

    public class OfferResourceOutputV1{
        public OfferResourceOutputV1(Boolean testValues){
            if(testValues){
                //todo
                programName = 'testProgramName';
                programStatus = 'testProgramStatus';
            }
        }
        public OfferResourceOutputV1(OfferService.Offer offer){
            this.programID = offer.programID;           
            this.programName = offer.programName;
            this.schoolID = offer.schoolID;
            this.programStatus = offer.programStatus;
            this.agreementStatus = offer.agreementStatus;
            this.studentID = offer.studentID;
            this.agreementID = offer.agreementID;
            this.enrollmentEndDate = offer.enrollmentEndDate;
            this.enrollmentBeginDate = offer.enrollmentBeginDate;
            this.registrationBeginDate = offer.registrationBeginDate;
            this.registrationEndDate = offer.registrationEndDate;
        }
        public String programID {get;set;}
        public String programName {get;set;}
        public String schoolID {get;set;}
        public String programStatus {get;set;}
        public String agreementStatus {get;set;}
        public String studentID {get;set;}
        public String agreementID {get;set;}
        public Date enrollmentEndDate {get;set;}
        public Date enrollmentBeginDate {get;set;}
        public Date registrationEndDate {get;set;}
        public Date registrationBeginDate {get;set;}
        public List<VemoAPIDisbursementScheduleResource.DisbursementScheduleResourceOutputV1> transactionSchedules{get;set;}
    }
    
}