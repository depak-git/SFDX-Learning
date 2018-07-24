/////////////////////////////////////////////////////////////////////////
// Class: AgreementService
// 
// Description: 
//  Handles all Agreement Service DML functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created    
// 2016-12-26   Greg Cook       Put and Delete        
// 2017-05-08   Greg Cook       Added schoolProgramOfStudy ATOM2-1455             
/////////////////////////////////////////////////////////////////////////
public with sharing class AgreementService {

    public static List<Agreement> getAgreementWithAgreementID(Set<ID> agreementIDs){
        System.debug('AgreementService.getAgreementWithAgreementID');
        Map<ID, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
        List<Agreement> agreements = new List<Agreement>();
        for(StudentProgram__c studProg : studProgramMap.values()){
            agreements.add(new Agreement(studProg));
        }       
        return agreements;
    }

    public static List<Agreement> getAgreementWithStudentID(Set<ID> studentIDs){
        System.debug('AgreementService.getAgreementWithStudentID');
        Map<ID, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMapWithStudentID(studentIDs);
        List<Agreement> agreements = new List<Agreement>();
        for(StudentProgram__c studProg : studProgramMap.values()){
            agreements.add(new Agreement(studProg));
        }       
        return agreements;
    }

    public static List<Agreement> getAgreementWithSchoolID(Set<ID> schoolIDs){
        System.debug('AgreementService.getAgreementWithSchoolID');
        Map<ID, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMapWithSchoolID(schoolIDs);
        List<Agreement> agreements = new List<Agreement>();
        for(StudentProgram__c studProg : studProgramMap.values()){
            agreements.add(new Agreement(studProg));
        }       
        return agreements;
    }

    public static List<Agreement> getAgreementWithProgramID(Set<ID> programIDs){
        System.debug('AgreementService.getAgreementWithProgramID');
        Map<ID, StudentProgram__c> studProgramMap = StudentProgramQueries.getStudentProgramMapWithProgramID(programIDs);
        List<Agreement> agreements = new List<Agreement>();
        for(StudentProgram__c studProg : studProgramMap.values()){
            agreements.add(new Agreement(studProg));
        }       
        return agreements;
    }   

    public static List<Agreement> getAgreementWithSearch(String searchString){
        //Temporary implementation
        System.debug('AgreementService.getAgreementWithSearch');
        Map<ID, StudentProgram__c> studProgramMap = getStudentProgramMapWithSearch(searchString);
        List<Agreement> agreements = new List<Agreement>();
        for(StudentProgram__c studProg : studProgramMap.values()){
            agreements.add(new Agreement(studProg));
        }       
        return agreements;
    }   

    private static Map<ID, StudentProgram__c> getStudentProgramMapWithSearch(String searchString){
        Map<ID, StudentProgram__c> studPrgMap = new Map<ID, StudentProgram__c>();
        if(searchString.length() > 2){
            String query = StudentProgramQueries.generateSOQLSelect();
            query += ' WHERE Deleted__c = false';
            if(DatabaseUtil.filterByStudentID){
                ID studentID = DatabaseUtil.studentPersonAccountID;
                query += ' and Student__c = ' + DatabaseUtil.inStringBuilder(studentID)+ ' ';
                if(DatabaseUtil.filterBySchoolID){
                    ID schoolID = DatabaseUtil.schoolID;
                    query += ' and Program__r.School__c = ' + DatabaseUtil.inStringBuilder(schoolID)+ ' ';
                }
            }
            query += ' and (Student__r.FirstName like \'' + searchString + '%\' or Student__r.LastName like \'' + searchString + '%\' or Student__r.PersonEmail like \'' + searchString + '%\'or VemoContractNumber__c like \'' + searchString + '%\')';
            query += ' '+ StudentProgramQueries.generateLIMITStatement();
            DatabaseUtil db = new DatabaseUtil();
            studPrgMap = new Map<ID, StudentProgram__c>((List<StudentProgram__c>)db.query(query));          
        }

        return studPrgMap;
    }


    public static Set<Id> createAgreement(List<Agreement> agreements){
        System.debug('AgreementService.createAgreement');
        List<StudentProgram__c> studPrograms = new List<StudentProgram__c>();
        for(Agreement agre : agreements){
            StudentProgram__c studProgram = agreementToStudentProgram(agre);
            system.debug(studProgram);
            studProgram.ID = null;
            studProgram.GUID__c = null; // keep until removed completely
            studPrograms.add(studProgram);
        }
        insert studPrograms;
        Set<ID> studProgramIDs = new Set<ID>();
        for(StudentProgram__c studProgram : studPrograms){
            studProgramIDs.add(studProgram.ID);
        }
        return studProgramIDs;
    }
    
    
    public static Set<Id> updateAgreement(List<Agreement> agreements){
        System.debug('AgreementService.updateAgreement');
        List<StudentProgram__c> studProgs = new List<StudentProgram__c>();
        for(Agreement agre : agreements){
            //decouple async processing
            if(agre.generateDisclosures == 'true'){
                LogService.critical('BEGIN - Front End Generate Disclosures: '+agre.agreementID, String.valueOf(agre.agreementID));     
                List<StudentProgram__c> candidates = new List<StudentProgram__c>();
                candidates.add(new StudentProgram__c(id = agre.agreementID));
                DisclosureService.Calculation(candidates);
                LogService.critical('End - Front End Generate Disclosures: '+agre.agreementID, String.valueOf(agre.agreementID));       
            }
            if(agre.generateAgreement == 'true'){
                LogService.critical('BEGIN - Front End Generate Agreement: '+agre.agreementID, String.valueOf(agre.agreementID));               
                generateUnsignedAgreement(agre.agreementID, false, UserInfo.getSessionId());
                LogService.critical('END - Front End Generate Agreement: '+agre.agreementID, String.valueOf(agre.agreementID));     
            }
            if(agre.generateEsign == 'true'){
                LogService.critical('BEGIN - Front End Generate Esign: '+agre.agreementID, String.valueOf(agre.agreementID));       
                generateEsignDocument(agre.agreementID);
                LogService.critical('End - Front End Generate Esign: '+agre.agreementID, String.valueOf(agre.agreementID));     
            }
            if(agre.generateEsignURL == 'true'){
                LogService.critical('BEGIN - Front End Generate EsignURL: '+agre.agreementID, String.valueOf(agre.agreementID));        
                getEsignUrl(agre.agreementID);
                LogService.critical('End - Front End Generate EsignURL: '+agre.agreementID, String.valueOf(agre.agreementID));      
            }

            if(agre.resetAgreement == 'true'){
                system.debug('***resetAgreement');
                agre.congaUnsignedAgreementStatus = 'None';
                agre.adobeSignStatus = 'None';
                agre.adobeSignJavascript= ' ';
                agre.adobeSignURL= ' ';
                agre.adobeSignWidgetID= ' ';
                agre.congaUnsignedAgreementID= ' ';
                agre.signedAgreementID= ' ';
                agre.adobeSignAgreementID = ' ';
                agre.agreementSigned = 'false';

            }
            if(agre.resetFinalDisclosure == 'true'){

                agre.congaFinalDisclosureStatus = 'None';
                agre.finalDisclosureID= ' ';

            }
            //end decouple async processing
            agre.studentID = null;
            agre.programID = null;
            StudentProgram__c prg = agreementToStudentProgram(agre);
            studProgs.add(prg);
        }
        update studProgs;
        Set<ID> agreementIDs = new Set<ID>();
        for(StudentProgram__c studPrg : studProgs){
            agreementIDs.add(studPrg.Id);
        }
        return agreementIDs;
    }   
    
    public static Integer deleteAgreement(Set<ID> agreementIDs){
        System.debug('AgreementService.deleteAgreement');
        Map<ID, StudentProgram__c> prgs = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
        Integer numToDelete = prgs.size();
        delete prgs.values();
        return numToDelete;
    }

    /*************************************************************************************************
    *
    *   Conga Service
    *
    **************************************************************************************************/
    public static void generateUnsignedAgreement(ID agreementID, Boolean generateEsign, String sessionID){
        system.debug('AgreementService.generatePDFAgreement()');
        LogService.debug('Entering AgreementService.generateUnsignedAgreement()', String.valueOf(agreementID));     
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(new Set<ID>{agreementID});
        if(agreementMap.size()==1){
            StudentProgram__c agreement = agreementMap.values()[0];
            String fileName = unsignedAgreementFileName(agreement.id); 
            //String fileName = 'unsigned-agreement-'+String.valueOf(agreement.id).substring(0,15);
            agreement.CongaUnsignedAgreementID__c = CongaService.generateDocument(agreementID, agreement.Program__r.AgreementTemplate__c, fileName, sessionID);
            agreement.CongaUnsignedAgreementStatus__c = 'Generated';
            agreement.GenerateAgreement__c = false;

            TriggerSettings.getSettings().studentProgramTrigger = false;
            update agreement;
            TriggerSettings.getSettings().studentProgramTrigger = true;

            if(generateEsign){
                GenerateESignDocQueueable esign = new GenerateESignDocQueueable();
                esign.agreementID = agreementID;
                system.debug('enqueueJob: GenerateESignDocQueueable'+esign);
                System.enqueueJob(esign);                   
            }
    

        }
        LogService.debug('Exiting AgreementService.generateUnsignedAgreement()', String.valueOf(agreementID));  
    }

    public static void generateFinalDisclosure(ID agreementID, String sessionID){
        LogService.debug('Entering AgreementService.generateFinalDisclosure()', String.valueOf(agreementID));   
        system.debug('AgreementService.generateFinalDisclosure()');

        
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(new Set<ID>{agreementID});


        if(agreementMap.size()==1){
            StudentProgram__c agreement = agreementMap.values()[0];
            String fileName = AgreementService.finalDisclosureFileName(agreementID);
            agreement.CongaFinalDisclosureID__c = CongaService.generateDocument(agreementID, agreement.Program__r.DisclosureTemplate__c, fileName, sessionID);
            agreement.CongaFinalDisclosureStatus__c = 'Generated';

            //try asynch
            AgreementService.UpdateAgreementAsync job = new AgreementService.UpdateAgreementAsync();
            job.congaFinalDisclosureStatus = 'Generated';
            job.generateFinalDisclosure = 'false';
            job.Agreement = agreement;
            system.debug('enqueueJob: UpdateAgreementAsync'+job);
            system.enqueueJob(job);
            //TriggerSettings.getSettings().studentProgramTrigger = false;
            //update agreement;
            //TriggerSettings.getSettings().studentProgramTrigger = true;
    
        }
        LogService.debug('Exiting AgreementService.generateFinalDisclosure()', String.valueOf(agreementID));
    }

    public static String finalDisclosureFileName(ID agreementID){
        return 'final-disclosure-'+String.valueOf(agreementID).substring(0,15);
    }
    public static String signedAgreementFileName(ID agreementID){
        return 'signed-agreement-'+String.valueOf(agreementID).substring(0,15);
    }
    public static String unsignedAgreementFileName(ID agreementID){
        return 'unsigned-agreement-'+String.valueOf(agreementID).substring(0,15);
    }
    /*************************************************************************************************
    *
    *   Adobe Service
    *
    **************************************************************************************************/

    public static void generateESignDocument(ID studProgID){
        LogService.debug('Entering AgreementService.generateESignDocument()', String.valueOf(studProgID));
        system.debug('AgreementService.generateESignDocument()');
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(new Set<ID>{studProgID});
        String transDocID;
        String adobeAgreementID;

        try{
            AdobeSignService.refreshRequest();          
        } catch (Exception e){
            StudentProgram__c agreement = new StudentProgram__c(id = studProgID, AdobeSignStatus__c = e.getMessage().substring(0,255));
            update agreement;           
            return; 
        }


        try{
            transDocID = AdobeSignService.uploadDocument(agreementMap.values()[0].CongaUnsignedAgreementID__c, studProgID, AdobeSignService.DocumentType.ATTACHMENT);
            system.debug('transDocID:'+transDocID);     
        } catch (Exception e){
            system.debug('Caught');
            LogService.critical('Exception caught by AdobeSignService.uploadDocument():'+e.getMessage(), String.valueOf(studProgID));
            //try again

            try{
                LogService.critical('Retry uploadDocument', String.valueOf(studProgID));
                system.debug('try again');
                transDocID = AdobeSignService.uploadDocument(agreementMap.values()[0].CongaUnsignedAgreementID__c, studProgID, AdobeSignService.DocumentType.ATTACHMENT);
                system.debug('transDocID:'+transDocID); 
            } catch (Exception e1){
                LogService.critical('Exception caught by AdobeSignService.uploadDocument():'+e.getMessage(), String.valueOf(studProgID));
                StudentProgram__c agreement = new StudentProgram__c(id = studProgID, AdobeSignStatus__c = e.getMessage().substring(0,255));
                update agreement;
                return; 
            }
        }

        try{
            system.debug('try createAgreement');
            adobeAgreementID = AdobeSignService.createAgreement(transDocID, null, agreementMap.values()[0].StudentEmail__c, studProgID, 'Income Share Agreement');
            system.debug('adobeAgreementID:'+adobeAgreementID);     
        } catch (Exception e){
            StudentProgram__c agreement = new StudentProgram__c(id = studProgID, AdobeSignStatus__c = e.getMessage().substring(0,255));
            update agreement;           
            return; 
        }

        StudentProgram__c agreement = new StudentProgram__c(id = studProgID,
            AdobeSignAgreementID__c = adobeAgreementID,
            AdobeSignStatus__c = 'Document Uploaded to Adobe');

        update agreement;

//decoupleasync     GenerateESignUrlQueueable job = new GenerateESignUrlQueueable();
//decoupleasync     job.agreementID = agreement.id;
//decoupleasync     System.enqueueJob(job);     
        LogService.debug('Exiting AgreementService.generateESignDocument()', String.valueOf(studProgID));
    }

    public static void getEsignUrl(ID studProgID){
        LogService.debug('Entering AgreementService.getEsignUrl()', String.valueOf(studProgID));
        system.debug('AgreementService.getEsignUrl()');
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(new Set<ID>{studProgID});
        
        AdobeSignService.refreshRequest();
        String url = AdobeSignService.getSigningURL(agreementMap.values()[0].AdobeSignAgreementID__c, studProgID);
        system.debug('url:'+url);

        StudentProgram__c agreement = new StudentProgram__c(id = studProgID,
            AdobeSignURL__c = url,
            AdobeSignStatus__c = 'Document Awaiting Signature');

        update agreement;
        LogService.critical('END - Student Program Object - Document Ready for Signature: '+studProgID, String.valueOf(studProgID));        
        LogService.debug('Exiting AgreementService.getEsignUrl()', String.valueOf(studProgID));
    }

    public static void getSignedDocument(ID studProgID){
        LogService.debug('Entering AgreementService.getSignedDocument()', String.valueOf(studProgID));
        system.debug('AgreementService.getsignedDocument()');
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(new Set<ID>{studProgID});

        try{
            AdobeSignService.refreshRequest();
            AdobeSignService.getCombinedDocument(studProgID,agreementMap.values()[0].AdobeSignAgreementID__c, AdobeSignService.DocumentType.ATTACHMENT, AgreementService.signedAgreementFileName(studProgID)+'.pdf');
            
        } catch (Exception e){
            StudentProgram__c agreement = new StudentProgram__c(id = studProgID,
                                                                AdobeSignStatus__c = e.getMessage().substring(0,255));
            update agreement;
        }
        LogService.debug('Exiting AgreementService.getSignedDocument()', String.valueOf(studProgID));
    }


    public static void determineAmountsDue(List<Agreement> agreements){
        System.debug('AgreementService.determineAmountsDue');
        Map<ID, Agreement> agreementMap = new Map<ID, Agreement>();
        for(Agreement agree : agreements){
            agreementMap.put(agree.agreementID, agree);
        }

        //query layer?
        Map<ID, StudentProgramAmountDue__c> amountDueMap = new Map<ID, StudentProgramAmountDue__c>([SELECT id,
                                                                                                           Agreement__c,
                                                                                                           Amount__c,
                                                                                                           AssessmentDateTime__c,
                                                                                                           ExcludeFromBalance__c,
                                                                                                           StudentProgramMonthlyStatus__c,
                                                                                                           Type__c
                                                                                                    FROM StudentProgramAmountDue__c
                                                                                                    WHERE Agreement__c IN :agreementMap.keySet()
                                                                                                    ORDER BY AssessmentDateTime__c asc]);
        Map<ID, List<StudentProgramAmountDue__c>> amountDueByAgreement = new Map<ID, List<StudentProgramAmountDue__c>>();
        for(StudentProgramAmountDue__c spad : amountDueMap.values()){
            if(!amountDueByAgreement.containsKey(spad.Agreement__c)){
                amountDueByAgreement.put(spad.Agreement__c, new List<StudentProgramAmountDue__c>());
            }
            amountDueByAgreement.get(spad.Agreement__c).add(spad);
        }

        Map<ID, StudentProgramMonthlyStatus__c> monthlyStatusMap = new Map<ID, StudentProgramMonthlyStatus__c>([SELECT id, 
                                                                                                                       Activity__c,
                                                                                                                       Agreement__c,
                                                                                                                       Month__c,
                                                                                                                       Year__c
                                                                                                                FROM StudentProgramMonthlyStatus__c
                                                                                                                WHERE Agreement__c IN :agreementMap.keySet()]);
        Map<ID, List<StudentProgramMonthlyStatus__c>> monthlyStatusByAgreement = new Map<ID, List<StudentProgramMonthlyStatus__c>>();
        for(StudentProgramMonthlyStatus__c spms : monthlyStatusMap.values()){
            if(!monthlyStatusByAgreement.containsKey(spms.Agreement__c)){
                monthlyStatusByAgreement.put(spms.Agreement__c, new List<StudentProgramMonthlyStatus__c>());
            }
            monthlyStatusByAgreement.get(spms.Agreement__c).add(spms);
        }   

        Map<ID, PaymentAllocation__c> paymentAllocationMap = new Map<ID, PaymentAllocation__c>([SELECT id,
                                                                                                       Agreement__c,
                                                                                                       AllocationType__c,
                                                                                                       AmountAllocated__c,
                                                                                                       Fee__c,
                                                                                                       PaymentInstruction__c
                                                                                                FROM PaymentAllocation__c
                                                                                                WHERE ID IN :agreementMap.keySet()]);
        Map<ID, List<PaymentAllocation__c>> paymentAllocationByAgreement = new Map<ID, List<PaymentAllocation__c>>();
        for(PaymentAllocation__c alloc : paymentAllocationMap.values()){
            if(!paymentAllocationByAgreement.containsKey(alloc.Agreement__c)){
                paymentAllocationByAgreement.put(alloc.Agreement__c, new List<PaymentAllocation__c>());
            }
            paymentAllocationByAgreement.get(alloc.Agreement__c).add(alloc);
        }

        Date today = Date.today();
        Integer month = today.month();
        Integer year = today.year();
        Integer day = today.day();
        System.debug('today:'+today);
        for(Agreement agree : agreementMap.values()){
            System.debug('agree:'+agree);
            //Add up the reconciliations for months past
            if(amountDueByAgreement.containsKey(agree.agreementID)){
                Decimal reconciliationPastDue = 0;
                Decimal monthlyAmountPastDue = 0;
                Decimal reconciliationCurrentDue = 0;
                Decimal monthlyAmountCurrentDue = 0;
                for(StudentProgramAmountDue__c spad : amountDueByAgreement.get(agree.agreementID)){
                    System.debug('spad:'+spad);
                    if(spad.AssessmentDateTime__c != null){
                        Date assessmentDate = Date.newInstance(spad.AssessmentDateTime__c.year(),
                                                                spad.AssessmentDateTime__c.month(),
                                                                spad.AssessmentDateTime__c.day());
                        system.debug('assessmentDate:'+assessmentDate);     
                        if((assessmentDate.year() <= today.year() && assessmentDate.month() < today.month()) || 
                            (assessmentDate.year() < today.year())){
                            System.debug('past month');
                            if(!spad.ExcludeFromBalance__c && spad.Type__c == 'Reconciliation'){
                                reconciliationPastDue += spad.Amount__c;
                            }
                            if(!spad.ExcludeFromBalance__c && spad.Type__c == 'Monthly Amount'){
                                monthlyAmountPastDue += spad.Amount__c;
                            }
                        } else {
                            System.debug('not past month');
                            if(assessmentDate.year() == today.year() && assessmentDate.month() == today.month()){
                                System.debug('current month');
                                if(!spad.ExcludeFromBalance__c && spad.Type__c == 'Reconciliation'){
                                    reconciliationCurrentDue += spad.Amount__c;
                                }
                                if(!spad.ExcludeFromBalance__c && spad.Type__c == 'Monthly Amount'){
                                    monthlyAmountCurrentDue += spad.Amount__c;
                                }                       
                            }
                        }
                        
                    }

                }
                System.debug('reconciliationPastDue:'+reconciliationPastDue);
                System.debug('agree.reconciliationDueToDate:'+agree.reconciliationDueToDate);
                System.debug('agree.reconciliationPaidToDate:'+agree.reconciliationPaidToDate);             
                System.debug('agree.reconciliationDue:'+agree.reconciliationDue);


                Decimal remainingReconciliationDue = agree.reconciliationDue;

                agree.reconciliationCurrentDue = (reconciliationCurrentDue > remainingReconciliationDue ? remainingReconciliationDue : reconciliationCurrentDue);               
                
                System.debug('agree.reconciliationCurrentDue:'+agree.reconciliationCurrentDue);

                agree.reconciliationCurrentDue = (agree.reconciliationCurrentDue < 0 ? 0 : agree.reconciliationCurrentDue);
                remainingReconciliationDue = remainingReconciliationDue - agree.reconciliationCurrentDue;

                agree.reconciliationPastDue = (reconciliationPastDue > remainingReconciliationDue ? remainingReconciliationDue : reconciliationPastDue);

                agree.reconciliationPastDue = (agree.reconciliationPastDue < 0 ? 0 : agree.reconciliationPastDue);

                System.debug('agree.reconciliationPastDue:'+agree.reconciliationPastDue);


                System.debug('monthlyAmountPastDue:'+monthlyAmountPastDue);
                System.debug('agree.monthlyAmountDueToDate:'+agree.monthlyAmountDueToDate);
                System.debug('agree.monthlyAmountPaidToDate:'+agree.monthlyAmountPaidToDate);               
                System.debug('agree.monthlyAmountDue:'+agree.monthlyAmountDue);

                Decimal remainingMonthlyAmountDue = agree.monthlyAmountDue;
                System.debug('monthlyAmountCurrentDue:'+monthlyAmountCurrentDue);
                System.debug('remainingMonthlyAmountDue:'+remainingMonthlyAmountDue);

                //agree.monthlyAmountDue = (agree.monthlyAmountDue < 0 ? 0 : agree.monthlyAmountDue);
                agree.monthlyAmountCurrentDue = (monthlyAmountCurrentDue > remainingMonthlyAmountDue ? remainingMonthlyAmountDue : monthlyAmountCurrentDue);    
                
                System.debug('agree.monthlyAmountCurrentDue:'+agree.monthlyAmountCurrentDue);

                agree.monthlyAmountCurrentDue = (agree.monthlyAmountCurrentDue < 0 ? 0 : agree.monthlyAmountCurrentDue);
                remainingMonthlyAmountDue = remainingMonthlyAmountDue - agree.monthlyAmountCurrentDue;
                //agree.monthlyAmountCurrentDue = (monthlyAmountCurrentDue > agree.monthlyAmountDue ? agree.monthlyAmountDue : 0);          
                System.debug('agree.monthlyAmountCurrentDue:'+agree.monthlyAmountCurrentDue);

                System.debug('remainingMonthlyAmountDue:'+remainingMonthlyAmountDue);
                System.debug('monthlyAmountPastDue:'+monthlyAmountPastDue);

                agree.monthlyAmountPastDue = (monthlyAmountPastDue > remainingMonthlyAmountDue ? remainingMonthlyAmountDue : monthlyAmountPastDue);
                System.debug('agree.monthlyAmountPastDue:'+agree.monthlyAmountPastDue);
    //          agree.monthlyAmountPastDue = (monthlyAmountPastDue > (agree.monthlyAmountDue - agree.monthlyAmountCurrentDue) ? (agree.monthlyAmountDue - agree.monthlyAmountCurrentDue) : monthlyAmountPastDue);
                agree.monthlyAmountPastDue = (agree.monthlyAmountPastDue < 0 ? 0 : agree.monthlyAmountPastDue);
                //agree.monthlyAmountPastDue = (monthlyAmountPastDue > agree.monthlyAmountDue ? agree.monthlyAmountDue : monthlyAmountPastDue);
                System.debug('agree.monthlyAmountPastDue:'+agree.monthlyAmountPastDue);

                agree.amountDue = agree.monthlyAmountDue + agree.reconciliationDue;
                agree.amountPastDue = agree.monthlyAmountPastDue + agree.reconciliationPastDue;
                agree.amountCurrentDue = agree.monthlyAmountCurrentDue + agree.reconciliationCurrentDue;

                System.debug('agree.amountDue'+agree.amountDue);
                System.debug('ageee.amountPastDue'+agree.amountPastDue);
                System.debug('agree.amountCurrentDue:'+agree.amountCurrentDue);



//              //Subtract out any reconciliations paid on the agreement
//              reconciliationPastDue -= agree.reconciliationPaidToDate;
//              System.debug('reconciliationPastDue:'+reconciliationPastDue);
//              agree.reconciliationPastDue = reconciliationPastDue;    

//              //Subtract out any monthlyAmounts paid on the agreement
//              monthlyAmountPastDue -= agree.monthlyAmountPaidToDate;
//              System.debug('monthlyAmountPastDue'+monthlyAmountPastDue);
//              agree.monthlyAmountPastDue = monthlyAmountPastDue;  
//
//greg - this is where i am - this should not get counted again for the second payment allocaiton once it has already been paid off
//              agree.reconciliationCurrentDue = reconciliationCurrentDue;
//              System.debug('reconciliationCurrentDue:'+reconciliationCurrentDue);
//
//              agree.monthlyAmountCurrentDue = monthlyAmountCurrentDue;
//              System.debug('monthlyAmountCurrentDue:'+monthlyAmountCurrentDue);
            }
        }   
        //Detemine the Current Month Reconciliations
        //Detemine the current month status

    }


    /*************************************************************************************************
    *
    *   Inner Classes Service
    *
    **************************************************************************************************/
    public static StudentProgram__c  agreementToStudentProgram(Agreement agre){

        StudentProgram__c studProgram = new StudentProgram__c();
        if(String.isNotEmpty(agre.agreementID)) studProgram.ID = agre.agreementID;
//      if(String.isNotEmpty(agre.guid)) studProgram.GUID__c = agre.guid;
        if(String.isNotEmpty(agre.studentID)) studProgram.Student__c = agre.studentID;
        if(String.isNotEmpty(agre.programID)) studProgram.Program__c = agre.programID;
        if(String.isNotEmpty(agre.agreementStatus)) studProgram.Status__c = agre.agreementStatus;

        if(agre.allocatedAmount != null) studProgram.AllocatedAmount__c = agre.allocatedAmount;





        if(String.isNotEmpty(agre.adobeSignStatus)) studProgram.AdobeSignStatus__c = agre.adobeSignStatus;
        if(String.isNotEmpty(agre.adobeSignJavascript)) studProgram.AdobeSignJavascript__c = agre.adobeSignJavascript;
        if(String.isNotEmpty(agre.adobeSignURL)) studProgram.AdobeSignURL__c = agre.adobeSignURL;       
        if(String.isNotEmpty(agre.adobeSignWidgetID)) studProgram.AdobeSignWidgetID__c = agre.adobeSignWidgetID;


        if(agre.applicationStartDateTime != null) studProgram.ApplicationStartDate__c = agre.applicationStartDateTime;      


        if(agre.approvalDisclosureDateTime != null) studProgram.ApprovalDisclosureDate__c = agre.approvalDisclosureDateTime;


        if(String.isNotEmpty(agre.adobeSignAgreementID)) studProgram.AdobeSignAgreementID__c = agre.adobeSignAgreementID;
        if(String.isNotEmpty(agre.eligibleToReapply)){
            if(agre.eligibleToReapply == 'true'){
                studProgram.EligibleToReapply__c = true;
            } else {
                studProgram.EligibleToReapply__c = false;               
            }
        } 
        if(String.isNotEmpty(agre.agreementSigned)){
            if(agre.agreementSigned == 'true'){
                studProgram.AgreementSigned__c = true;
            } else {
                studProgram.AgreementSigned__c = false;             
            }
        } 

        if(agre.attendanceBeginDate != null) studProgram.AttendanceBeginDate__c = agre.attendanceBeginDate; 
        if(agre.attendanceEndDate != null) studProgram.AttendanceEndDate__c = agre.attendanceEndDate;   
        if(agre.birthdate != null) studProgram.Birthdate__c = agre.birthdate;
        if(agre.birthdateCertification != null) studProgram.BirthdateCertification__c = agre.birthdateCertification;
        if(agre.birthdatePreCertification != null) studProgram.BirthdatePreCertification__c = agre.birthdatePreCertification;
        if(agre.birthdatePostCertification != null) studProgram.BirthdatePostCertification__c = agre.birthdatePostCertification;
        if(agre.birthdateStudent != null) studProgram.BirthdateStudent__c = agre.birthdateStudent;

        if(String.isNotEmpty(agre.bypassAutomation)){
            studProgram.BypassAutomation__c = agre.bypassAutomation == 'true' ?  true : false;
        }
    
        if(String.isNotEmpty(agre.cancellationReason)) studProgram.CancellationReason__c = agre.cancellationReason;
        if(String.isNotEmpty(agre.certificationComments)) studProgram.CertificationComments__c = agre.certificationComments;

        if(agre.certificationDateTime != null) studProgram.CertificationDate__c = agre.certificationDateTime;

        if(String.isNotEmpty(agre.certificationDraftStatus)) studProgram.CertificationDraftStatus__c = agre.certificationDraftStatus;

        if(String.isNotEmpty(agre.congaFinalDisclosureStatus)) studProgram.CongaFinalDisclosureStatus__c = agre.congaFinalDisclosureStatus;

        if(String.isNotEmpty(agre.congaUnsignedAgreementStatus)) studProgram.CongaUnsignedAgreementStatus__c = agre.congaUnsignedAgreementStatus;
        if(String.isNotEmpty(agre.congaUnsignedAgreementID)) studProgram.CongaUnsignedAgreementID__c = agre.congaUnsignedAgreementID;


        if(String.isNotEmpty(agre.creditCheckID)) studProgram.CreditCheck__c = agre.creditCheckID;
        if(String.isNotEmpty(agre.creditCheckProcess)) studProgram.CreditCheckProcess__c = agre.creditCheckProcess;


        if(agre.currentStatusDateTime != null) studProgram.CurrentStatusDate__c = agre.currentStatusDateTime;
        if(String.isNotEmpty(agre.customerWithdrawnReason)) studProgram.CustomerWithdrawnReason__c = agre.customerWithdrawnReason;
        if(String.isNotEmpty(agre.customerWithdrawnReasonOther)) studProgram.CustomerWithdrawnReasonOther__c = agre.customerWithdrawnReasonOther;




        if(String.isNotEmpty(agre.defermentID)) studProgram.Deferment__c = agre.defermentID;
        if(agre.defermentMonthsAllowed != null) studProgram.DefermentMonthsAllowed__c = agre.defermentMonthsAllowed;
        if(agre.defermentMonthsRemaining != null) studProgram.DefermentMonthsRemaining__c = agre.defermentMonthsRemaining;
        if(String.isNotEmpty(agre.deleted)){
            studProgram.Deleted__c = agre.deleted == 'true' ?  true : false;
        }

        if(String.isNotEmpty(agre.eligibleToReapply)){
            studProgram.EligibleToReapply__c = agre.eligibleToReapply == 'true' ?  true : false;
        }

        if(String.isNotEmpty(agre.enrollmentStatusCertification)) studProgram.EnrollmentStatusCertification__c = agre.enrollmentStatusCertification;
        if(String.isNotEmpty(agre.enrollmentStatusPreCertification)) studProgram.EnrollmentStatusPreCertification__c = agre.enrollmentStatusPreCertification;
        if(String.isNotEmpty(agre.enrollmentStatusPostCertification)) studProgram.EnrollmentStatusPostCertification__c = agre.enrollmentStatusPostCertification;
        if(String.isNotEmpty(agre.enrollmentStatusStudent)) studProgram.EnrollmentStatusStudent__c = agre.enrollmentStatusStudent;


        if(agre.estimatedAgreementEndDate != null) studProgram.EstimatedAgreementEndDate__c = agre.estimatedAgreementEndDate;
        
        if(agre.expectedGraduationDate != null) studProgram.ExpectedGraduationDate__c = agre.expectedGraduationDate;

        if(String.isNotEmpty(agre.finalDisclosureID)) studProgram.FinalDisclosureID__c = agre.finalDisclosureID;
        if(String.isNotEmpty(agre.finalDisclosureURL)) studProgram.FinalDisclosureID__c = agre.finalDisclosureURL;

        if(agre.fundingAmountCertification != null) studProgram.FundingAmountCertification__c = agre.fundingAmountCertification;
        if(agre.fundingAmountPostCertification != null) studProgram.FundingAmountPostCertification__c = agre.fundingAmountPostCertification;

        if(agre.fundingAmountStudent != null) studProgram.FundingAmountStudent__c = agre.fundingAmountStudent;

        if(agre.fundingMaximumPreCertification != null) studProgram.FundingMaximumPreCertification__c = agre.fundingMaximumPreCertification;
        if(agre.fundingMinimumPreCertification != null) studProgram.FundingMinimumPreCertification__c = agre.fundingMinimumPreCertification;
        if(String.isNotEmpty(agre.fundingPurpose)) studProgram.FundingPurpose__c = agre.fundingPurpose;


//decoupleasync 
//      if(String.isNotEmpty(agre.generateAgreement)){
//          studProg.GenerateAgreement__c = agre.generateAgreement == 'true' ?  true : false;
//      }
        if(String.isNotEmpty(agre.generateFinalDisclosure)){
            studProgram.GenerateFinalDisclosure__c = agre.generateFinalDisclosure == 'true' ?  true : false;
        }


//      public String generateEsign {get;set;}
//      public String generateEsignURL {get;set;}
//      public String generateDisclosures {get;set;}
//      public String generateDisbursementSchedule {get;set;}

        if(agre.graceMonthsAllowed != null) studProgram.GraceMonthsAllowed__c = agre.graceMonthsAllowed;
        if(agre.graceMonthsRemaining != null) studProgram.GraceMonthsRemaining__c = agre.graceMonthsRemaining;
        if(agre.gracePeriodEndDate != null) studProgram.GracePeriodEndDate__c = agre.gracePeriodEndDate;


        if(String.isNotEmpty(agre.gradeLevel)) studProgram.GradeLevel__c = agre.gradeLevel;
        //if(String.isNotEmpty(agre.gradeLevelCertification)) 
        studProgram.GradeLevelCertification__c = agre.gradeLevelCertification;
        //if(String.isNotEmpty(agre.gradeLevelPreCertification)) 
        studProgram.GradeLevelPreCertification__c = agre.gradeLevelPreCertification;
        if(String.isNotEmpty(agre.gradeLevelPostCertification)) studProgram.GradeLevelPostCertification__c = agre.gradeLevelPostCertification;
        if(String.isNotEmpty(agre.gradeLevelStudent)) studProgram.GradeLevelStudent__c = agre.gradeLevelStudent;

        if(agre.incomeShare != null) studProgram.IncomeShare__c = agre.incomeShare;
        if(agre.incomeShareCertification != null) studProgram.IncomeShareCertification__c = agre.incomeShareCertification;
        if(agre.incomeSharePostCertification != null) studProgram.IncomeSharePostCertification__c = agre.incomeSharePostCertification;

        if(agre.incomeShareStudent != null) studProgram.IncomeShareStudent__c = agre.incomeShareStudent;

        if(agre.lastDateOfAttendance != null) studProgram.LastDateOfAttendance__c = agre.lastDateOfAttendance;
        
        //if(String.isNotEmpty(agre.majorIDCertification)) 
        studProgram.MajorCertification__c = agre.majorIDCertification;
        //if(String.isNotEmpty(agre.majorIDPreCertification)) 
        studProgram.MajorPreCertification__c = agre.majorIDPreCertification;
        if(String.isNotEmpty(agre.majorIDPostCertification)) studProgram.MajorPostCertification__c = agre.majorIDPostCertification;
        if(String.isNotEmpty(agre.majorIDStudent)) studProgram.MajorStudent__c = agre.majorIDStudent;


        if(agre.minimumIncomePerMonth != null) studProgram.MinimumIncomePerMonth__c = agre.minimumIncomePerMonth;
        if(agre.minimumIncomePerYear != null) studProgram.MinimumIncomePerYear__c = agre.minimumIncomePerYear;

        if(agre.nextPaymentDue != null) studProgram.NextPaymentDue__c = agre.nextPaymentDue;
        if(agre.nextPaymentDueDate != null) studProgram.NextPaymentDueDate__c = agre.nextPaymentDueDate;
        if(String.isNotEmpty(agre.notCertifiedReason)) studProgram.NotCertifiedReason__c = agre.notCertifiedReason;

        if(agre.paidToDate != null) studProgram.PaidToDate__c = agre.paidToDate;

        if(String.isNotEmpty(agre.paveTheWay)){
            studProgram.PaveTheWay__c = agre.paveTheWay == 'true' ?  true : false;
        }

        if(agre.paymentCap != null) studProgram.PaymentCap__c = agre.paymentCap;
        if(agre.paymentCapCertification != null) studProgram.PaymentCapCertification__c = agre.paymentCapCertification;
        if(agre.paymentCapPostCertification != null) studProgram.PaymentCapPostCertification__c = agre.paymentCapPostCertification;
        if(agre.paymentCapStudent != null) studProgram.PaymentCapStudent__c = agre.paymentCapStudent;

        if(agre.paymentTerm != null) studProgram.PaymentTerm__c = agre.paymentTerm;
        if(agre.paymentTermCertification != null) studProgram.PaymentTermCertification__c = agre.paymentTermCertification;
        if(agre.paymentTermPostCertification != null) studProgram.PaymentTermPostCertification__c = agre.paymentTermPostCertification;

        if(agre.paymentTermStudent != null) studProgram.PaymentTermStudent__c = agre.paymentTermStudent;

        if(String.isNotEmpty(agre.preCertified)){
            studProgram.PreCertified__c = agre.preCertified == 'true' ?  true : false;
        }

        if(String.isNotEmpty(agre.quizLocked)){
            studProgram.QuizLocked__c = agre.quizLocked == 'true' ?  true : false;
        }
        if(agre.quizAttemptsData !=null) studProgram.QuizAttemptsData__c = agre.quizAttemptsData;
        if(agre.quizState != null) studProgram.QuizState__c = agre.quizState;
        if(agre.quizResponseLink != null) studProgram.QuizResponseLink__c = agre.quizResponseLink;

        if(String.isNotEmpty(agre.registrationExceptionProcess)) studProgram.RegistrationExceptionProcess__c = agre.registrationExceptionProcess;

//        if(agre.remainingTerm != null) studProgram.RemainingTerm__c = agre.remainingTerm;
        if(agre.requestedAmount != null) studProgram.RequestedAmount__c = agre.requestedAmount;

        //      

        if(String.isNotEmpty(agre.residency)) studProgram.Residency__c = agre.residency;
        if(String.isNotEmpty(agre.residencyCertification)) studProgram.ResidencyCertification__c = agre.residencyCertification;
        if(String.isNotEmpty(agre.residencyPreCertification)) studProgram.ResidencyPreCertification__c = agre.residencyPreCertification;
        if(String.isNotEmpty(agre.residencyPostCertification)) studProgram.ResidencyPostCertification__c = agre.residencyPostCertification;
        if(String.isNotEmpty(agre.residencyStudent)) studProgram.ResidencyStudent__c = agre.residencyStudent;

        if(agre.rightToCancelDate != null) studProgram.RightToCancelDate__c = agre.rightToCancelDate;



//      public String resetAgreement {get;set;}
//      public String resetFinalDisclosure {get;set;}

        if(String.isNotEmpty(agre.servicing)){
            studProgram.Servicing__c = agre.servicing == 'true' ?  true : false;
        }
        if(agre.servicingStartDate != null) studProgram.ServicingStartDate__c = agre.servicingStartDate;
        if(String.isNotEmpty(agre.signedAgreementID)) studProgram.SignedAgreementID__c = agre.signedAgreementID;

        if(String.isNotEmpty(agre.signedAgreementURL)) studProgram.SignedAgreementID__c = agre.signedAgreementURL;

        if(String.isNotEmpty(agre.stateOfResidenceCertification)) studProgram.StateOfResidenceCertification__c = agre.stateOfResidenceCertification;
        if(String.isNotEmpty(agre.stateOfResidencePreCertification)) studProgram.StateOfResidencePreCertification__c = agre.stateOfResidencePreCertification;
        if(String.isNotEmpty(agre.stateOfResidencePostCertification)) studProgram.StateOfResidencePostCertification__c = agre.stateOfResidencePostCertification;

        if(String.isNotEmpty(agre.stateOfResidenceStudent)) studProgram.StateOfResidenceStudent__c = agre.stateOfResidenceStudent;

        if(agre.submittedDateTime != null) studProgram.SubmittedDate__c = agre.submittedDateTime;

        if(String.isNotEmpty(agre.studentEmail)) studProgram.StudentEmail__c = agre.studentEmail;



        return studProgram;
    }

    public class Agreement implements Comparable{
//      public String guid {get;set;}
        public String agreementID {get;set;}
        public String studentID {get;set;}
        public String studentName {get; set;}

        public String programID {get;set;}
        public String programName {get;set;}

        public String schoolID {get;set;}
        public String schoolProgramOfStudyID {get;set;}
        public String agreementStatus {get;set;}

        public Decimal amountDue {get;set;}
        public Decimal amountPastDue {get;set;}
        public Decimal amountCurrentDue {get;set;}

        public String adobeSignStatus {get;set;}
        public String adobeSignJavascript {get;set;}
        public String adobeSignURL {get;set;}
        public String adobeSignWidgetID {get;set;}
        public String adobeSignAgreementID {get;set;}

        public String agreementSigned {get;set;}
        public Decimal allocatedAmount {get;set;}
        public DateTime applicationStartDateTime {get;set;}
        public DateTime approvalDisclosureDateTime {get;set;}
        public Date attendanceBeginDate {get;set;}
        public Date attendanceEndDate {get;set;}

        public Date birthdate {get;set;}
        public Date birthdateCertification {get;set;}
        public Date birthdatePreCertification {get;set;}
        public Date birthdatePostCertification {get;set;}
        public Date birthdateStudent {get;set;}

        public String bypassAutomation {get;set;}
        public String cancellationReason {get;set;}
        public String certificationComments {get;set;}
        public DateTime certificationDateTime {get;set;}
        public String certificationDraftStatus {get;set;}

        public String congaFinalDisclosureStatus {get;set;}
        public String congaUnsignedAgreementID {get;set;}
        public String congaUnsignedAgreementStatus {get;set;}

        public String finalDisclosureID {get;set;}// should this change to congafinaldisclosureid__c
        public String finalDisclosureURL {get;set;}

        public String creditCheckID {get;set;}
        public String creditCheckProcess {get;set;}

        public DateTime currentStatusDateTime {get;set;}
        public String customerWithdrawnReason {get;set;}
        public String customerWithdrawnReasonOther {get;set;}


        public String defermentID {get;set;}
        public Decimal defermentMonthsAllowed {get;set;}
        public Decimal defermentMonthsRemaining {get;set;}
        public Date defermentBeginDate {get;set;}
        public Date defermentEndDate {get;set;}
        public String deleted {get;set;}

        public String eligibleToReapply {get;set;}

        public String enrollmentStatusCertification {get;set;}
        public String enrollmentStatusPreCertification {get;set;}
        public String enrollmentStatusPostCertification {get;set;}
        public String enrollmentStatusStudent {get;set;}

        public Date estimatedAgreementEndDate {get;set;}

        public Date expectedGraduationDate {get;set;}

        public Decimal fundingAmountCertification {get;set;}
        public Decimal fundingAmountPostCertification {get;set;}
        public Decimal fundingAmountStudent {get;set;}

        public Decimal fundingMaximumPreCertification {get;set;}
        public Decimal fundingMinimumPreCertification {get;set;}
        public String fundingPurpose {get;set;}

        public String generateAgreement {get;set;}
        public String generateEsign {get;set;}
        public String generateEsignURL {get;set;}
        public String generateFinalDisclosure {get;set;}
        public String generateDisclosures {get;set;}
        public String generateDisbursementSchedule {get;set;}

        public Decimal graceMonthsAllowed {get;set;}
        public Decimal graceMonthsRemaining {get;set;}
        public Date gracePeriodEndDate {get;set;}

        public String gradeLevel {get;set;}
        public String gradeLevelCertification {get;set;}
        public String gradeLevelPreCertification {get;set;}
        public String gradeLevelPostCertification {get;set;}
        public String gradeLevelStudent {get;set;}      

        public Decimal incomeShare {get;set;}//probably goes away
        public Decimal incomeShareCertification {get;set;}
        public Decimal incomeSharePostCertification {get;set;}
        public Decimal incomeShareStudent {get;set;}
        
        public Date lastDateOfAttendance {get;set;}
        
        public String majorIDCertification {get;set;}
        public String majorIDPreCertification {get;set;}
        public String majorIDPostCertification {get;set;}
        public String majorIDStudent {get;set;}

        public Decimal minimumIncomePerMonth {get;set;}
        public Decimal minimumIncomePerYear {get;set;}

        public Decimal monthlyAmountDueToDate {get;set;}
        public Decimal monthlyAmountPaidToDate {get;set;}
        public Decimal monthlyAmountDue {get;set;}
        public Decimal monthlyAmountPastDue {get;set;}
        public Decimal monthlyAmountCurrentDue {get;set;}

        public Decimal nextPaymentDue {get;set;}
        public Date nextPaymentDueDate {get;set;}
        public String notCertifiedReason {get;set;}

        public Decimal paidToDate {get;set;}
        public String paveTheWay {get;set;}


        public Decimal paymentCap {get;set;}//probably goes away
        public Decimal paymentCapCertification {get;set;}
        public Decimal paymentCapPostCertification {get;set;}
        public Decimal paymentCapStudent {get;set;}

        public Decimal paymentTerm {get;set;}//probably goes away
        public Decimal paymentTermCertification {get;set;}
        public Decimal paymentTermPostCertification {get;set;}
        public Decimal paymentTermStudent {get;set;}
        public String preCertified {get;set;}
        public String programNotes {get;set;}

        public String quizAttemptsData {get;set;}
        public String quizLocked {get;set;}
        public String quizResponseLink {get;set;}
        public String quizState {get;set;}

        public Decimal reconciliationPaidToDate {get;set;}
        public Decimal reconciliationDueToDate {get;set;}
        public Decimal reconciliationDue {get;set;}
        public Decimal reconciliationPastDue {get;set;}
        public Decimal reconciliationCurrentDue {get;set;}

        public String registrationExceptionProcess {get;set;}
        public Integer remainingTerm {get;set;}

        public Decimal requestedAmount {get;set;}//probably goes away

        public String resetAgreement {get;set;}
        public String resetFinalDisclosure {get;set;}

        public String residency {get;set;}//probably goes away
        public String residencyCertification {get;set;}
        public String residencyPreCertification {get;set;}
        public String residencyPostCertification {get;set;}
        public String residencyStudent {get;set;}

        public Date rightToCancelDate {get;set;}

        public String schoolName {get;set;}
        public String servicing {get;set;}
        public Date servicingStartDate {get;set;}
        public String signedAgreementID {get;set;}
        public String signedAgreementURL {get;set;}

        public String stateOfResidenceCertification {get;set;}
        public String stateOfResidencePreCertification {get;set;}
        public String stateOfResidencePostCertification {get;set;}
        public String stateOfResidenceStudent {get;set;}

        public DateTime submittedDateTime {get;set;}
        public String studentEmail {get;set;}
        public String vemoContractNumber {get;set;}

        public Integer compareTo(Object compareTo){
            Agreement compareToAgreement = (Agreement)compareTo;
            if(vemoContractNumber == compareToAgreement.vemoContractNumber) return 0;
            if(vemoContractNumber > compareToAgreement.vemoContractNumber) return 1;
            return -1;
        }
        public Agreement(){

        }

        public Agreement(Boolean testValues){
            if(testValues){
                this.agreementStatus = 'Invited'; //Enrolling, Enrolled, Completed, Cancelled
            }
        }

        public Agreement(StudentProgram__c studProg){
            this.agreementID = studProg.ID;
//          this.guid = studProg.GUID__c;
            this.studentID = studProg.Student__c;
            this.studentName = studProg.Student__r.Name;

            this.programID = studProg.Program__c;
            this.programName = studProg.Program__r.ProgramName__c;
            this.schoolID = studProg.Program__r.School__c;

            this.adobeSignStatus = studProg.AdobeSignStatus__c;
            this.adobeSignJavascript = studProg.AdobeSignJavascript__c;
            this.adobeSignURL = studProg.AdobeSignURL__c;
            this.adobeSignWidgetID = studProg.AdobeSignWidgetID__c;
            this.adobeSignAgreementID = studProg.AdobeSignAgreementID__c;

            this.agreementSigned = String.valueOf(studProg.AgreementSigned__c);



            this.allocatedAmount = studProg.AllocatedAmount__c;
            this.applicationStartDateTime = studProg.ApplicationStartDate__c;
            this.approvalDisclosureDateTime = studProg.ApprovalDisclosureDate__c;
            this.attendanceBeginDate = studProg.AttendanceBeginDate__c;
            this.attendanceEndDate = studProg.AttendanceEndDate__c;

            this.birthdate = studProg.Birthdate__c;//probably goes away
            this.birthdateCertification = studProg.BirthdateCertification__c;
            this.birthdatePreCertification = studProg.BirthdatePreCertification__c;
            this.birthdatePostCertification = studProg.BirthdatePostCertification__c;
            this.birthdateStudent = studProg.BirthdateStudent__c;


            this.bypassAutomation = String.valueOf(studProg.BypassAutomation__c);
            this.cancellationReason = studProg.CancellationReason__c;
            this.certificationComments = studProg.CertificationComments__c;
            this.certificationDateTime = studProg.CertificationDate__c;
            this.certificationDraftStatus = studProg.CertificationDraftStatus__c;

            this.congaFinalDisclosureStatus = studProg.CongaFinalDisclosureStatus__c;
            this.congaUnsignedAgreementID = studProg.CongaUnsignedAgreementID__c;
            this.congaUnsignedAgreementStatus = studProg.CongaUnsignedAgreementStatus__c;

            this.expectedGraduationDate = studProg.ExpectedGraduationDate__c;

            this.finalDisclosureID = studProg.FinalDisclosureID__c; // should this change to congafinaldisclosureid__c
            this.finalDisclosureURL = studProg.FinalDisclosureCleanURL__c;

            this.creditCheckID = studProg.CreditCheck__c;
            this.creditCheckProcess = studProg.CreditCheckProcess__c;

            this.currentStatusDateTime = studProg.CurrentStatusDate__c;
            this.customerWithdrawnReason = studProg.CustomerWithdrawnReason__c;
            this.customerWithdrawnReasonOther = studProg.CustomerWithdrawnReasonOther__c;

            this.defermentID = studProg.Deferment__c;
            this.defermentMonthsAllowed = studProg.DefermentMonthsAllowed__c;
            this.defermentMonthsRemaining = studProg.DefermentMonthsRemaining__c;
            this.defermentBeginDate = studProg.DefermentBeginDate__c;
            this.defermentEndDate = studProg.DefermentEndDate__c;
            this.deleted = String.valueOf(studProg.Deleted__c);

            this.eligibleToReapply = String.valueOf(studProg.EligibleToReapply__c);

            this.enrollmentStatusCertification = studProg.EnrollmentStatusCertification__c;
            this.enrollmentStatusPreCertification = studProg.EnrollmentStatusPreCertification__c;
            this.enrollmentStatusPostCertification = studProg.EnrollmentStatusPostCertification__c;
            this.enrollmentStatusStudent = studProg.EnrollmentStatusStudent__c;


            this.estimatedAgreementEndDate = studProg.EstimatedAgreementEndDate__c;


            this.fundingAmountCertification = studProg.FundingAmountCertification__c;
            this.fundingAmountPostCertification = studProg.FundingAmountPostCertification__c;
            this.fundingAmountStudent = studProg.FundingAmountStudent__c;

            this.fundingMaximumPreCertification = studProg.FundingMaximumPreCertification__c;
            this.fundingMinimumPreCertification = studProg.FundingMinimumPreCertification__c;
            this.fundingPurpose = studProg.FundingPurpose__c;

            this.generateAgreement = String.valueOf(studProg.GenerateAgreement__c);
            this.generateDisbursementSchedule = String.valueOf(studProg.GenerateDisbursementSchedule__c);
            this.generateFinalDisclosure = String.valueOf(studProg.GenerateFinalDisclosure__c);

            this.graceMonthsAllowed = studProg.GraceMonthsAllowed__c;
            this.graceMonthsRemaining = studProg.GraceMonthsRemaining__c;
            this.gracePeriodEndDate = studProg.GracePeriodEndDate__c;

            this.gradeLevel = studProg.GradeLevel__c;
            this.gradeLevelCertification = studProg.GradeLevelCertification__c;
            this.gradeLevelPreCertification = studProg.GradeLevelPreCertification__c;
            this.gradeLevelPostCertification = studProg.GradeLevelPostCertification__c;
            this.gradeLevelStudent = studProg.GradeLevelStudent__c;         


            this.incomeShare = studProg.IncomeShare__c;//probably goes away
            this.incomeShareCertification = studProg.IncomeShareCertification__c;
            this.incomeSharePostCertification = studProg.IncomeSharePostCertification__c;
            this.incomeShareStudent = studProg.IncomeShareStudent__c;

            this.lastDateOfAttendance = studProg.LastDateOfAttendance__c;
            
            this.majorIDCertification = studProg.MajorCertification__c;
            this.majorIDPreCertification = studProg.MajorPreCertification__c;
            this.majorIDPostCertification = studProg.MajorPostCertification__c;
            this.majorIDStudent = studProg.MajorStudent__c;         

            this.minimumIncomePerMonth = studProg.MinimumIncomePerMonth__c;
            this.minimumIncomePerYear = studProg.MinimumIncomePerYear__c;

            this.monthlyAmountDueToDate = studProg.MonthlyAmountDueToDate__c;
            this.monthlyAmountPaidToDate = studProg.MonthlyAmountPaidToDate__c;
            this.monthlyAmountDue = studProg.MonthlyAmountDue__c;

            this.nextPaymentDue = studProg.NextPaymentDue__c;
            this.nextPaymentDueDate = studProg.NextPaymentDueDate__c;
            this.notCertifiedReason = studProg.NotCertifiedReason__c;

            this.paidToDate = studProg.PaidToDate__c;
            this.paveTheWay = String.valueOf(studProg.PaveTheWay__c);

            this.paymentCap = studProg.PaymentCap__c;//probably goes away
            this.paymentCapCertification = studProg.PaymentCapCertification__c;
            this.paymentCapPostCertification = studProg.PaymentCapPostCertification__c;
            this.paymentCapStudent = studProg.PaymentCapStudent__c;

            this.paymentTerm = studProg.PaymentTerm__c;//probably goes away
            this.paymentTermCertification = studProg.PaymentTermCertification__c;
            this.paymentTermPostCertification = studProg.PaymentTermPostCertification__c;
            this.paymentTermStudent = studProg.PaymentTermStudent__c;
            this.preCertified = String.valueOf(studProg.PreCertified__c);
            this.programNotes = studProg.Program__r.ProgramNotes__c;

            this.quizLocked = String.valueOf(studProg.QuizLocked__c);
            this.quizAttemptsData = studProg.QuizAttemptsData__c;
            this.quizResponseLink = studProg.QuizResponseLink__c;
            this.quizState = studProg.QuizState__c;
            
            this.registrationExceptionProcess = studProg.RegistrationExceptionProcess__c;
            this.remainingTerm = (Integer) studProg.PaymentTermRemaining__c;

            this.reconciliationPaidToDate = studProg.ReconciliationPaidToDate__c;
            this.reconciliationDueToDate = studProg.ReconciliationDueToDate__c;
            this.reconciliationDue = studProg.ReconciliationDue__c;

            this.requestedAmount = studProg.RequestedAmount__c;//probably goes away

            this.residency = studProg.Residency__c;//probably goes away
            this.residencyCertification = studProg.ResidencyCertification__c;
            this.residencyPreCertification = studProg.ResidencyPreCertification__c;
            this.residencyPostCertification = studProg.ResidencyPostCertification__c;
            this.residencyStudent = studProg.ResidencyStudent__c;

            this.rightToCancelDate = studProg.RightToCancelDate__c;
            this.schoolName = studProg.SchoolName__c;
            this.schoolProgramOfStudyID = studProg.SchoolProgramOfStudy__c;//probably goes away
        
            this.servicing = String.valueOf(studProg.Servicing__c);
            this.servicingStartDate = studProg.ServicingStartDate__c;
            this.signedAgreementID = studProg.SignedAgreementID__c;
            this.signedAgreementURL = studProg.SignedAgreementCleanURL__c;

            this.stateOfResidenceCertification = studProg.StateOfResidenceCertification__c;
            this.stateOfResidencePreCertification = studProg.StateOfResidencePreCertification__c;
            this.stateOfResidencePostCertification = studProg.StateOfResidencePostCertification__c;
            this.stateOfResidenceStudent = studProg.StateOfResidenceStudent__c;

            this.agreementStatus = studProg.Status__c;
            this.submittedDateTime = studProg.SubmittedDate__c;
            this.studentEmail = studProg.StudentEmail__c;

            this.vemoContractNumber = studProg.VemoContractNumber__c;


        }
    }
    public class GenerateESignDocQueueable implements Queueable, Database.AllowsCallouts {
        public GenerateESignDocQueueable(){

        }
        public ID agreementID {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering AgreementService.GenerateESignDocQueueable.execute()', 'Launch Queueable');
            system.debug('AgreementService.GenerateESignDocQueueable.execute()');
            AgreementService.generateESignDocument(agreementID);
            LogService.debug('Exiting AgreementService.GenerateESignDocQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();         
        }
    }
    public class GenerateESignUrlQueueable implements Queueable, Database.AllowsCallouts {
        public GenerateESignUrlQueueable(){

        }
        public ID agreementID {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering AgreementService.GenerateESignUrlQueueable.execute()', 'Launch Queueable');
            system.debug('AgreementService.GenerateESignUrlQueueable.execute()');
            AgreementService.getEsignUrl(agreementID);
            LogService.debug('Exiting AgreementService.GenerateESignUrlQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs();             
        }
    }
    public class GenerateUnsignedAgreementQueueable implements Queueable, Database.AllowsCallouts {
        public GenerateUnsignedAgreementQueueable(){
            
        }

        public String sessionID {get;set;}
        public ID agreementID {get;set;}
        public Boolean generateEsign {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering AgreementService.GenerateUnsignedAgreementQueueable.execute()', 'Launch Queueable');
            system.debug('AgreementService.GenerateUnsignedAgreementQueueable.execute()');
            AgreementService.generateUnsignedAgreement(agreementID, generateEsign, sessionID);
            LogService.debug('Exiting AgreementService.GenerateUnsignedAgreementQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs(); 
        }
    }
    public class GenerateFinalDisclosureQueueable implements Queueable, Database.AllowsCallouts {
        public GenerateFinalDisclosureQueueable(){
            
        }
        public String sessionID {get;set;}
        public ID agreementID {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering AgreementService.GenerateFinalDisclosureQueueable.execute()', 'Launch Queueable');
            system.debug('AgreementService.GenerateFinalDisclosureQueueable.execute()');
            AgreementService.generateFinalDisclosure(agreementID, sessionID);
            LogService.debug('Exiting AgreementService.GenerateFinalDisclosureQueueable.execute()', 'Launch Queueable');
            LogService.writeLogs(); 
        }
    }   
    public class RetrieveSignedDocumentQueuable implements Queueable, Database.AllowsCallouts {
        public RetrieveSignedDocumentQueuable(){
            
        }
        public ID agreementID {get;set;}
        public void execute(QueueableContext context) {
            LogService.debug('Entering AgreementService.RetrieveSignedDocumentQueuable.execute()', 'Launch Queueable');
            system.debug('AgreementService.RetrieveSignedDocumentQueuable.execute()');
            AgreementService.getSignedDocument(agreementID);
            LogService.debug('Exiting AgreementService.RetrieveSignedDocumentQueuable.execute()', 'Launch Queueable');
            LogService.writeLogs(); 
        }
    }
    public class UpdateAgreementAsync implements Queueable {
        public UpdateAgreementAsync(){
            
        }

        public String generateFinalDisclosure {get;set;}
        public String generateAgreement {get;set;}
        public String congaFinalDisclosureStatus {get;set;}
        public String congaAgreementStatus {get;set;}
        public String agreementStatus {get;set;}
        public StudentProgram__c agreement {get;set;}
        public void execute(QueueableContext context) {
            Boolean logUnsignedComplete = false;
            LogService.debug('Entering AgreementService.UpdateAgreementAsync.execute()', 'Launch Queueable');
            system.debug('AgreementService.UpdateAgreementAsync.execute()');
            system.debug('agreement:'+agreement);
            if(String.isNotEmpty(generateFinalDisclosure)){
                if(generateFinalDisclosure=='true'){
                    agreement.GenerateFinalDisclosure__c = true;    
                } else {
                    agreement.GenerateFinalDisclosure__c = false;                       
                }
            }
            if(String.isNotEmpty(generateAgreement)){
                if(generateAgreement=='true'){
                    agreement.GenerateAgreement__c = true;  
                } else {
                    agreement.GenerateAgreement__c = false;                     
                }
            }
            if(String.isNotEmpty(congaFinalDisclosureStatus)){
                agreement.CongaFinalDisclosureStatus__c = congaFinalDisclosureStatus;               
            }           
            if(String.isNotEmpty(congaAgreementStatus)){
                if(congaAgreementStatus == 'Generated'){
                    logUnsignedComplete = true;
                }
                agreement.CongaUnsignedAgreementStatus__c = congaAgreementStatus;               
            }
            if(String.isNotEmpty(agreementStatus)){
                agreement.Status__c = agreementStatus;              
            }
            system.debug('agreement to update:'+agreement);
            update agreement;
            if(logUnsignedComplete) LogService.critical('END - Attachment Trigger Async Update - Probably Unsigned Document Complete: '+agreement.id, String.valueOf(agreement.id));
            LogService.debug('Exiting AgreementService.UpdateAgreementAsync.execute()', 'Launch Queueable');
            LogService.writeLogs(); 
        }
    }
    public class AgreementServiceException extends Exception {}
}