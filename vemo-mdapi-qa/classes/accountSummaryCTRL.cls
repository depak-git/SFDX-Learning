public with sharing class accountSummaryCTRL{
       
    @AuraEnabled
    public static wrapperClass getRecords(Id accountId){
        Date dateToday = Date.Today();
        Id studentId = accountId;//(Id)ApexPages.currentPage().getParameters().get('id');
        system.debug('studentId--'+studentId);
        Map<ID, StatementService.StatementV1> statementMap = StatementService.getCurrentStatementV1ByStudentWithStudentID(new Set<Id>{studentId});
        List<TransactionService.Disbursement> Disbursements = TransactionService.getDisbursementWithStudentID(new Set<Id>{studentId});
        
        List<AgreementService.Agreement> allAgreements = AgreementService.getAgreementWithStudentID(new Set<Id>{studentId});
        
        wrapperClass rec = new wrapperClass();
        rec.dueDate = statementMap.values().get(0).dueDate;
        rec.name = statementMap.values().get(0).name;
        rec.expectedPayment = statementMap.values().get(0).expectedPayment;
        rec.currentStatementURL = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/RenderStatement?id='+studentID;
        rec.newIncomeVerificationURL = URL.getSalesforceBaseUrl().toExternalForm()+'/a18/e?CF00N3600000RytmI='+rec.name+'&CF00N3600000RytmI_lkid='+studentId+'&retURL=%'+studentID;
        system.debug('rec.newIncomeVerificationURL'+rec.newIncomeVerificationURL);
        
        PaymentInstructionService.PaymentInstruction pi;
         List<Date> datePosted = new List<Date>();
         List<PaymentInstructionService.PaymentInstruction> paymentList = PaymentInstructionService.getPaymentInstructionWithStudentID(new Set<Id>{studentID});
         
         if(paymentList != null && paymentList.size()>0){
             for(PaymentInstructionService.PaymentInstruction p: paymentList){
                 if(p.paymentDate.month() == rec.DueDate.month()){
                     pi = new PaymentInstructionService.PaymentInstruction();
                     pi = p;
                     //rec.paymentStatus = paymentList[paymentList.size()-1].status;
                     //rec.paymentDate= paymentList[paymentList.size()-1].paymentDate; 
                     break; 
                 } 
             }
         }
         else{
             rec.paymentStatus = 'N/A';    
         } 
            
         if(pi != null){
             rec.paymentStatus = pi.status;
             rec.paymentDate = pi.paymentDate;    
         }
         else if(statementMap.values().get(0).totalAmountPastDue>0){
            if(paymentList != null && paymentList.size()>0 && paymentList[paymentList.size()-1].status == 'Processing'){
                rec.paymentStatus = 'Pending'; 
                rec.daysDelinquent = rec.dueDate.daysBetween(dateToday);   
            } 
            else{
                rec.paymentStatus = 'Past Due';
                rec.paymentDate = rec.dueDate;
                rec.daysDelinquent = rec.dueDate.daysBetween(dateToday);
            }
            if(rec.daysDelinquent < 0)
                rec.daysDelinquent = 0;
         }
         else if(rec.paymentStatus != 'N/A'){
             rec.paymentStatus = paymentList[paymentList.size()-1].status;
             rec.paymentDate= paymentList[paymentList.size()-1].paymentDate;    
         }
         
            
        Map<ID, IncomeVerification__c> incomeVerficationMap = IncomeVerificationQueries.getIncomeVerificationMapWithStudentId(new set<ID>{studentId});
        List<incomeVerification> incomeList = new List<incomeVerification>();
        if(incomeVerficationMap != null && incomeVerficationMap.size() >0){
            for(IncomeVerification__c incVer : incomeVerficationMap.values()){
                if(incVer.Status__c == 'Verified'){
                    incomeVerification inc = new incomeVerification();
                    inc.BeginDate = incVer.BeginDate__c;
                    inc.MonthlyIncome =  incVer.IncomePerMonth__c;
                    inc.type = incVer.type__c;
                    inc.verified = true;
                    inc.DateVerified = incVer.DateVerified__c;
                    incomeList.add(inc);
                }
            }
            incomeList.sort(); 
            Integer size = incomeList.size();
            for(integer i=0;i<incomeList.size();i++){
                if(incomeList[i].BeginDate <= Date.today()){
                    rec.monthlyIncome = incomeList[i].MonthlyIncome;
                    rec.dateVerified = incomeList[i].dateVerified;
                }
                else{
                    continue;
                }
                if(!(i==(incomeList.size()-1))){
                    if(incomeList[i].BeginDate == incomeList[i+1].BeginDate){
                        if(incomeList[i].type == incomeList[i+1].type){
                            if(incomeList[i].dateVerified > incomeList[i+1].DateVerified){
                                break;        
                            }        
                        }
                        else{
                            if(incomeList[i].type == 'Reported'){
                                break;
                            }        
                        }
                    }
                    else{
                        break;
                    }
                }
            }
            /*
            if(incomeList.size()>0){
                rec.monthlyIncome = incomeList[0].MonthlyIncome;
                rec.dateVerified = incomeList[0].dateVerified;
            }
            if(incomeList.size()>1){
                if(incomeList[0].beginDate == incomeList[1].beginDate){
                    if((incomeList[0].type == 'Reported' && incomeList[1].type == 'Reported') || (incomeList[0].type == 'Estimated' && incomeList[1].type == 'Estimated')){
                        //system.debug('same'+ incomeList[0].type + '----'+incomeList[1].type);
                        //integer year1 = incomeList[0].DateVerified.year();
                        //integer year2 = incomeList[1].DateVerified.year();
                        if(incomeList[0].DateVerified > incomeList[1].DateVerified){
                            //system.debug(year1+ '!!!!'+ year2);
                            rec.monthlyIncome = incomeList[0].monthlyIncome;
                            rec.dateVerified = incomeList[0].dateVerified;
                        }
                            else{
                                //system.debug(year1+ '!!!!'+ year2);
                            rec.monthlyIncome = incomeList[1].monthlyIncome;  
                            rec.dateVerified = incomeList[1].dateVerified; 
                        } 
                    }        
                    else if(incomeList[0].type == 'Reported'){
                        rec.monthlyIncome = incomeList[0].monthlyIncome;
                        rec.dateVerified = incomeList[0].dateVerified;
                    }
                    else if(incomeList[1].type == 'Reported'){
                        rec.monthlyIncome = incomeList[1].monthlyIncome;
                        rec.dateVerified = incomeList[1].dateVerified;
                    }
                }
            }
            */
        }
        
       
        
        if(Disbursements != null && Disbursements.size()>0){
            List<Date> transactionDate = new List<Date>();
            for(TransactionService.Disbursement dis: Disbursements){
                if((dis.agreementStatus == 'Partially Funded' || dis.agreementStatus == 'Certified') && dis.status == 'Scheduled' && dis.amount != null){
                    rec.pendingDisbursement = rec.pendingDisbursement + dis.amount;
                    if(dis.transactionDate != null && dis.transactionDate >= dateToday){
                        transactionDate.add(dis.transactionDate); 
                    }
                }
            }
            transactionDate.sort();
            if(transactionDate.size()>0)
                rec.nextDisbursementDate = transactionDate[0];
        }
        
        set<ID> agreementIDs = new set<ID>();
        if(allAgreements != null && allAgreements.size()>0){
            for(AgreementService.Agreement agr: allAgreements){
                agreementIDs.add(agr.agreementID);
            }
        }
        Map<ID, StudentProgramAmountDue__c> amountDueMap = new Map<ID, StudentProgramAmountDue__c>([SELECT id,
                                                                                                           Agreement__c,
                                                                                                           Amount__c,
                                                                                                           AssessmentDateTime__c,
                                                                                                           ExcludeFromBalance__c,
                                                                                                           StudentProgramMonthlyStatus__c,
                                                                                                           Type__c
                                                                                                    FROM StudentProgramAmountDue__c
                                                                                                    WHERE Agreement__c IN :agreementIDs
                                                                                                    ORDER BY AssessmentDateTime__c DESC]);
        Map<ID, List<StudentProgramAmountDue__c>> amountDueByAgreement = new Map<ID, List<StudentProgramAmountDue__c>>();
        if(amountDueMap != null){
            for(StudentProgramAmountDue__c spad : amountDueMap.values()){
                if(!amountDueByAgreement.containsKey(spad.Agreement__c)){
                    amountDueByAgreement.put(spad.Agreement__c, new List<StudentProgramAmountDue__c>());
                }
                amountDueByAgreement.get(spad.Agreement__c).add(spad);
            }
        }
        
        if(allAgreements != null && allAgreements.size()>0){
            for(AgreementService.Agreement agr: allAgreements){
                if(agr.agreementStatus != 'Cancelled' && agr.agreementStatus != 'Refinanced' && agr.agreementStatus != 'Closed'){
                    StatementAgreementV1 obj = new StatementAgreementV1();
                    obj.programName = agr.programName;
                    if(agr.NextPaymentDue > 0 && agr.nextPaymentDueDate != null)
                        obj.daysDelinquent = agr.nextPaymentDueDate.daysBetween(dateToday)>0?agr.nextPaymentDueDate.daysBetween(dateToday):0;
                    else
                        obj.daysDelinquent = 0;   
                    //obj.dateSigned  = agr.dateSigned;
                    obj.status = agr.agreementStatus;
                    obj.incomeSharePostCertification = agr.incomeSharePostCertification != null?agr.incomeSharePostCertification:0;
                    obj.fundingAmountPostCertification = agr.fundingAmountPostCertification != null?agr.fundingAmountPostCertification:0;
                    if(agr.agreementStatus == 'Deferment' && agr.DefermentBeginDate != null){
                        obj.currentStatusDateTime = Date.newinstance(agr.DefermentBeginDate.year(),agr.DefermentBeginDate.month(),agr.DefermentBeginDate.day());
                    }
                    else if(agr.currentStatusDateTime != null){
                        obj.currentStatusDateTime = agr.currentStatusDateTime;
                    }
                    obj.agreementID = agr.agreementID; 
                    obj.agrUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+agr.agreementID;
                    
                    
                    if(rec.totalFundingAmount != null && agr.fundingAmountPostCertification != null)
                        rec.totalFundingAmount = rec.totalFundingAmount + agr.fundingAmountPostCertification;
                    if(rec.totalIncomeShare != null && agr.incomeSharePostCertification != null)    
                        rec.totalIncomeShare = rec.totalIncomeShare + agr.incomeSharePostCertification;
                    if(amountDueByAgreement.containsKey(agr.agreementID)){
                        obj.paymentAmount = amountDueByAgreement.get(agr.agreementID)[0].amount__c;
                        rec.totalPaymentAmount +=obj.paymentAmount; 
                       /* for(StudentProgramAmountDue__c spad : amountDueByAgreement.get(agr.agreementID)){
                            Date assessmentDate = Date.newInstance(spad.AssessmentDateTime__c.year(),
                                                                    spad.AssessmentDateTime__c.month(),
                                                                    spad.AssessmentDateTime__c.day());
                              if(assessmentDate.year() <= dateToday.year() && assessmentDate.month() <= dateToday.month()){
                                System.debug('past month');
                               
                                if(!spad.ExcludeFromBalance__c && spad.Type__c == 'Monthly Amount' && spad.Amount__c != null){
                                    obj.paymentAmount += spad.Amount__c;
                                    rec.totalPaymentAmount +=obj.paymentAmount; 
                                }
                            } 
                        }*/
                    }
                   
                    
                    rec.agreements.add(obj); 
                }   
            } 
             
            
            
            
        }
        
        system.debug('rec.totalFundingAmount--'+rec.totalFundingAmount+'----'+rec.totalIncomeshare);
        
        system.debug('rec---'+statementMap.values().get(0).dueDate+' ---- '+statementMap.values().get(0).expectedPayment);
        return rec;
  }
  
  public class wrapperClass{
      @AuraEnabled public Date dueDate{get;set;}
      @AuraEnabled public String name {get;set;}
      @AuraEnabled public Decimal expectedPayment{get;set;}
      @AuraEnabled public List<StatementAgreementV1> agreements {get;set;}
      @AuraEnabled public Decimal pendingDisbursement {get;set;}
      @AuraEnabled public Decimal totalFundingAmount {get;set;}
      @AuraEnabled public Decimal totalIncomeShare {get;set;}
      @AuraEnabled public Decimal totalPaymentAmount {get;set;}
      @AuraEnabled public string currentStatementURL {get;set;}
      @AuraEnabled public string newIncomeVerificationURL {get;set;}
      @AuraEnabled public Date nextDisbursementDate {get;set;}
      @AuraEnabled public String paymentStatus {get;set;}
      @AuraEnabled public Date paymentDate {get;set;}
      @AuraEnabled public Decimal monthlyIncome {get;set;}
      @AuraEnabled public Integer daysDelinquent {get;set;}
      @AuraEnabled public Date dateVerified{get;set;}
      public wrapperClass(){
          agreements = new List<StatementAgreementV1>(); 
          this.pendingDisbursement = 0; 
          this.totalFundingAmount = 0;
          this.totalIncomeShare = 0; 
          this.totalPaymentAmount = 0; 
          this.monthlyIncome = 0;  
      }
  }
  
  public class StatementAgreementV1{
      @AuraEnabled public String programName {get;set;}
      @AuraEnabled public Date dateSigned {get;set;}
      @AuraEnabled public String status {get;set;}
      @AuraEnabled public string agreementID {get;set;}
      @AuraEnabled public Decimal incomeSharePostCertification {get;set;}
      @AuraEnabled public Decimal fundingAmountPostCertification {get;set;}
      @AuraEnabled public Decimal paymentAmount {get;set;}
      @AuraEnabled public DateTime currentStatusDateTime {get;set;}
      @AuraEnabled public string agrUrl {get;set;}
      @AuraEnabled public Integer daysDelinquent{get;set;}
      
      public StatementAgreementV1(){
          this.fundingAmountPostCertification = 0;  
          this.incomeSharePostCertification = 0; 
          this.paymentAmount = 0;
      }
       
  } 
  
  public class incomeVerification implements comparable{
      String recID;
      Date BeginDate;
      Date DateVerified;
      Decimal MonthlyIncome;
      Boolean Verified;
      String type;
      
      public incomeVerification(){
          monthlyIncome = 0;
      }
      public Integer compareTo(Object objToCompare){
          incomeVerification compareToIncome = (incomeVerification)objToCompare;
          if(BeginDate < compareToIncome.BeginDate )
              return 1;
          else
              return 0;
      }
  }
}