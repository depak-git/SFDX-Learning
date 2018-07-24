public with sharing class ReconciliationService {
    
    /*public static List<Reconciliation> getReconciliationWithReconciliationID(Set<ID> reconciliationIDs){
        Map<Id, Reconciliation__c> reconciliationMap = ReconciliationQueries.getReconciliationMapWithReconciliationID(ReconciliationIDs);
        List<Reconciliation> reconciliationList = new List<Reconciliation>();
        for(Reconciliation__c re : ReconciliationMap.values()){
            reconciliationList.add(new reconciliation(re));
        }
        return reconciliationList;
    }*/

    public static List<Reconciliation> getReconciliationMapWithStudentID(Set<ID> customerIDs){
        Map<Id, Reconciliation__c> reconciliationMap = ReconciliationQueries.getReconciliationMapWithStudentID(customerIDs);
        List<Reconciliation> reconciliationList = new List<Reconciliation>();
        for(Reconciliation__c re : ReconciliationMap.values()){
            reconciliationList.add(new reconciliation(re));
        }
        return reconciliationList;
    }
    
    public static List<ReconciliationDetail> getReconciliationDetailMapWithReconciliationID(Set<ID> reconciliationIDs){
        Map<Id, ReconciliationDetail__c> reconciliationDetailMap = ReconciliationQueries.getReconciliationDetailMapWithReconciliationID(reconciliationIDs);
        List<ReconciliationDetail> reconciliationDetailList = new List<ReconciliationDetail>();
        for(ReconciliationDetail__c rd : reconciliationDetailMap.values()){
            reconciliationDetailList.add(new ReconciliationDetail(rd));
        }
        return reconciliationDetailList;
    }
    
    //// new
    public static List<ReconciliationDetail> getRDetailMapWithRDetailID(Set<ID> reconciliationDetailIDs){
        Map<Id, ReconciliationDetail__c> reconciliationDetailMap = ReconciliationQueries.getRDetailMapWithRDetailID(reconciliationDetailIDs);
        List<ReconciliationDetail> reconciliationDetailList = new List<ReconciliationDetail>();
        for(ReconciliationDetail__c rd : reconciliationDetailMap.values()){
            reconciliationDetailList.add(new ReconciliationDetail(rd));
        }
        return reconciliationDetailList;
    }
    
    public static Set<ID> createRDetails(List<ReconciliationDetail> rds){
        System.debug('ReconciliationService.createRDetails()');
        List<ReconciliationDetail__c > newRDs = new List<ReconciliationDetail__c >();
        
        for(ReconciliationDetail rd : rds){
            ReconciliationDetail__c  newRD = rdToRD(rd);
            newRDs.add(newRD);
        }
        insert newRDs;
        Set<ID> rdIDs = new Set<ID>();
        for(ReconciliationDetail__c  rd : newRDs){
            rdIDs.add(rd.ID);
        }
        return rdIDs;
    }
    
    public static Set<ID> updateRDetails(List<ReconciliationDetail> rds){
        System.debug('ReconciliationService.updateRDetails()');
        List<ReconciliationDetail__c > newRDs = new List<ReconciliationDetail__c >();
        
        for(ReconciliationDetail rd : rds){
            ReconciliationDetail__c  newRD = rdToRD(rd);
            newRDs.add(newRD);
        }
        update newRDs;
        Set<ID> rdIDs = new Set<ID>();
        for(ReconciliationDetail__c  rd : newRDs){
            rdIDs.add(rd.ID);
        }
        return rdIDs;
    }
    public static Set<ID> updateRecons(List<Reconciliation> recons){
        System.debug('ReconciliationService.updateRecons()');
        List<Reconciliation__c > newRDs = new List<Reconciliation__c >();
        
        for(Reconciliation recon : recons){
            Reconciliation__c  newRecon = reconToReconObj(recon);
            newRDs.add(newRecon);
        }
        update newRDs;
        Set<ID> reconIDs = new Set<ID>();
        for(Reconciliation__c  recon : newRDs){
            reconIDs.add(recon.ID);
        }
        return reconIDs;
    }


    public static Integer deleteRDetails(Set<ID> rDetailIDs){
        System.debug('ReconciliationService.deleteRDetails()');
        Map<ID, ReconciliationDetail__c> rdMap = ReconciliationQueries.getRDetailMapWithRDetailID(rDetailIDs);
        Integer numToDelete = rdMap.size();
        delete rdMap.values();
        return numToDelete;
    }

    /*************************************************************************************************
    *
    *   Adobe Service
    *
    **************************************************************************************************/

    public static void generateESignDocument(ID reconciliationID){
        LogService.debug('Entering ReconciliationService.generateESignDocument()', String.valueOf(reconciliationID));
        system.debug('ReconciliationService.generateESignDocument()');
        Map<ID, Reconciliation__c> reconciliationMap = ReconciliationQueries.getReconciliationMapWithReconciliationID(new Set<ID>{reconciliationID});

        String transDocID;
        String adobeAgreementID;

        try{
            AdobeSignService.refreshRequest();          
        } catch (Exception e){
            Reconciliation__c reconcilation = new Reconciliation__c(id = reconciliationID, AdobeSignStatus__c = e.getMessage().substring(0,255));
            update reconcilation;           
            return; 
        }




        // try{
        //     //use a document not an attachment
        //     transDocID = AdobeSignService.uploadDocument('015J0000000vqcx', reconciliationID, AdobeSignService.DocumentType.DOCUMENT);
        //     system.debug('transDocID:'+transDocID);     
        // } catch (Exception e){
        //     system.debug('Caught');
        //     LogService.critical('Exception caught by AdobeSignService.uploadDocument():'+e.getMessage(), String.valueOf(reconciliationID));
        //     //try again

        //     try{
        //         LogService.critical('Retry uploadDocument', String.valueOf(reconciliationID));
        //         system.debug('try again');
        //         transDocID = AdobeSignService.uploadDocument('015J0000000vqcsIAA', reconciliationID, AdobeSignService.DocumentType.DOCUMENT);
        //         system.debug('transDocID:'+transDocID); 
        //     } catch (Exception e1){
        //         LogService.critical('Exception caught by AdobeSignService.uploadDocument():'+e.getMessage(), String.valueOf(reconciliationID));
        //         Reconciliation__c reconcilation = new Reconciliation__c(id = reconciliationID, AdobeSignStatus__c = e.getMessage().substring(0,255));
        //         update reconcilation;
        //         return; 
        //     }
        // }

        try{
            system.debug('try createAgreement');
            String adobeDocumentLibraryID = SecureSettings.getValue('4506-TDocumentID'); //https://salesforceintegration.na1.echosign.com/public/docs/restapi/v5#!/libraryDocuments/getLibraryDocuments
            System.debug('adobeDocumentLibraryID:'+adobeDocumentLibraryID);
            adobeAgreementID = AdobeSignService.createAgreement(null, adobeDocumentLibraryID, reconciliationMap.get(reconciliationID).Email__c, reconciliationID, '4506-T');/*agreementMap.values()[0].StudentEmail__c, studProgID);*/
            system.debug('adobeAgreementID:'+adobeAgreementID);     
        } catch (Exception e){
            Reconciliation__c reconcilation = new Reconciliation__c(id = reconciliationID, AdobeSignStatus__c = e.getMessage().substring(0,255));
            update reconcilation;           
            return; 
        }

        Reconciliation__c reconciliation = new Reconciliation__c(id = reconciliationID,
            AdobeSignAgreementID__c = adobeAgreementID,
            AdobeSignStatus__c = 'Document Uploaded to Adobe');

        update reconciliation;

//decoupleasync     GenerateESignUrlQueueable job = new GenerateESignUrlQueueable();
//decoupleasync     job.agreementID = agreement.id;
//decoupleasync     System.enqueueJob(job);     
        LogService.debug('Exiting ReconciliationService.generateESignDocument()', String.valueOf(reconciliationID));
    }

    public static void getEsignUrl(ID reconciliationID){
        LogService.debug('Entering ReconciliationService.getEsignUrl()', String.valueOf(reconciliationID));
        system.debug('AgreementService.getEsignUrl()');
        Map<ID, Reconciliation__c> reconciliationMap = ReconciliationQueries.getReconciliationMapWithReconciliationID(new Set<ID>{reconciliationID});
        
        AdobeSignService.refreshRequest();
        String url = AdobeSignService.getSigningURL(reconciliationMap.values()[0].AdobeSignAgreementID__c, reconciliationID);
        system.debug('url:'+url);

        Reconciliation__c reconciliation = new Reconciliation__c(id = reconciliationID,
            AdobeSignURL__c = url,
            AdobeSignStatus__c = 'Document Awaiting Signature');

        update reconciliation;
        LogService.critical('END - Reconciliation Object - Document Ready for Signature: '+reconciliationID, String.valueOf(reconciliationID));        
        LogService.debug('Exiting ReconciliationService.getEsignUrl()', String.valueOf(reconciliationID));
    }

    public static void getSignedDocument(ID reconciliationID){
        LogService.debug('Entering ReconciliationService.getSignedDocument()', String.valueOf(reconciliationID));
        system.debug('ReconciliationService.getsignedDocument()');
        Map<ID, Reconciliation__c> reconciliationMap = ReconciliationQueries.getReconciliationMapWithReconciliationID(new Set<ID>{reconciliationID});

        try{
            AdobeSignService.refreshRequest();
            AdobeSignService.getCombinedDocument(reconciliationID,reconciliationMap.values()[0].AdobeSignAgreementID__c, AdobeSignService.DocumentType.GENERIC_DOCUMENT, 'Signed Document.pdf');
            
        } catch (Exception e){
            Reconciliation__c reconciliation = new Reconciliation__c(id = reconciliationID,
                                                                AdobeSignStatus__c = e.getMessage().substring(0,255));
            update reconciliation;
        }
        LogService.debug('Exiting ReconciliationService.getSignedDocument()', String.valueOf(reconciliationID));
    }





    public static ReconciliationDetail__c  rdToRD(ReconciliationDetail rd){
        ReconciliationDetail__c   rdObj = new ReconciliationDetail__c();
        if(rd.reconciliationID != null) rdObj.Reconciliation__c = rd.reconciliationID;
        if(rd.reconciliationDetailID  != null) rdObj.ID = rd.reconciliationDetailID ;
        if(rd.employerStartDate != null) rdObj.EmployerStartDate__c = rd.employerStartDate;
        if(rd.employerEndDate != null) rdObj.EmployerEndDate__c = rd.employerEndDate;
        if(rd.usTaxincome != null) rdObj.USTaxincome__c = rd.usTaxincome;
        if(rd.employerName != null) rdObj.EmployerName__c = rd.employerName;
        return rdObj;
    }
    public static Reconciliation__c  reconToReconObj(Reconciliation recon){
        Reconciliation__c   reconObj = new Reconciliation__c();
        if(recon.reconciliationID != null) reconObj.ID = recon.reconciliationID;
        if(recon.agreementSigned  != null) reconObj.AgreementSigned__c = recon.agreementSigned == 'true' ? true : false;
        if(recon.shouldHaveDetail  != null) reconObj.ShouldHaveDetail__c = recon.shouldHaveDetail == 'true' ? true : false;
        if(recon.status != null) reconObj.Status__c = recon.status;
        return reconObj;
    }


    public class Reconciliation{
        public String reconciliationID {get;set;}
        public String adobeSignStatus {get;set;}
        public String adobeSignAgreementID {get;set;}
        public String adobeSignURL {get;set;}
        public String agreementSigned {get;set;}
        public Date dateFrom {get;set;}
        public Date dateThrough {get;set;}
        public String shouldHaveDetail {get;set;}
        public String studentID {get;set;}
        public String status {get;set;}
        
        public Reconciliation(){}
    
        public Reconciliation(Reconciliation__c re){
          this.reconciliationID = re.ID;
          this.adobeSignAgreementID = re.AdobeSignAgreementID__c;
          this.adobeSignStatus = re.AdobeSignStatus__c;
          this.adobeSignURL = re.AdobeSignURL__c;
          this.agreementSigned = String.valueOf(re.AgreementSigned__c);
          this.dateFrom = re.DateFrom__c;  
          this.dateThrough = re.DateThrough__c ;
          this.shouldHaveDetail = String.valueOf(re.ShouldHaveDetail__c);
          this.studentID = re.Student__c;
          this.status = re.Status__c;
        }
    }
    
    public class ReconciliationDetail{
        public String reconciliationDetailID {get;set;}
        public String reconciliationID {get;set;}
        public Date employerStartDate {get;set;}
        public Date employerEndDate {get;set;}
        public boolean usTaxincome {get;set;}
        public String employerName {get;set;}
        
        public ReconciliationDetail(){}
        
        public ReconciliationDetail(Boolean testValues){
            if(testValues){
                this.employerStartDate = date.today(); 
                this.employerEndDate = date.today();
                this.usTaxincome = false;
            }
        }
        public ReconciliationDetail(ReconciliationDetail__c rd){
          this.reconciliationDetailID = rd.ID;
          this.reconciliationID = rd.Reconciliation__c;
          this.employerStartDate = rd.EmployerStartDate__c;
          this.employerEndDate = rd.EmployerEndDate__c;
          this.usTaxincome = rd.USTaxincome__c;
          this.employerName = rd.EmployerName__c;
        }
    }
}