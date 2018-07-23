public class LedgerViewController{
    
    
    @AuraEnabled
    public static List<JournalEntry> getJournalEntriesWithCustomerID(ID studentID){
        List<JournalEntry> output = new List<JournalEntry>();                                                                                                    
        List<JournalEntry> reverseOutput = new List<JournalEntry>();
        Set<LedgerService.LedgerType> exclusionSet = new Set<LedgerService.LedgerType>{LedgerService.LedgerType.DISBURSEMENT};
        Map<ID,String> agreementNameMap = new Map<ID,String>();
        Set<ID> agreementIds = new Set<ID>();
        Integer size = 0;
        if(studentID <> null){
            List<LedgerService.JournalEntry> tempList = LedgerService.getJournalEntriesWithCustomerID(new Set<ID>{studentID},exclusionSet);
            for(LedgerService.JournalEntry theEntry:tempList){
                //filter out the Monthly Amount type = fee records
                if(theEntry.amountDueType <> 'Fee' && theEntry.feeStatus <> 'Cancelled'){
                    output.add(new JournalEntry(theEntry));
                }
                if(theEntry.agreementID <> null){
                    agreementIds.add(theEntry.agreementID); 
                }
            }
            
            if(agreementIds <> null && agreementIds.size()>0){
                List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(agreementIds);
                for(AgreementService.Agreement agr:agreements){
                    if(!agreementNameMap.containsKey(agr.agreementID))
                        agreementNameMap.put(agr.agreementID,agr.programName);
                }
            }
            
            //reverse the order to get the list in reverse chronological order
            size = output.size();
            for(Integer i = output.size()-1; i>=0; i--){
                if(output[i].agreementID <> null){
                    if(agreementNameMap.containsKey(output[i].agreementID)){
                        output[i].programName = agreementNameMap.get(output[i].agreementID);
                    }
                }
                reverseOutput.add(output[i]);
            }
            
            
            System.debug('@@@OUTPUT: '+output);
            return reverseOutput;
        }
        return reverseOutput;                               
    }
    
    @AuraEnabled
    public static Student getStudent(ID studentID){
        Student output = new Student();
        List<StudentService.Student> students = new List<StudentService.Student>();
        if(studentID <> null){
            students = StudentService.getStudentsWithStudentID(new Set<ID>{studentID});    
            if(students.size()==1){
                output = new Student(students[0]); 
            }
        }                                                                                        
        return output;
    }
    
    public class Student{
        @AuraEnabled public String name {get;set;}
        
        public Student(){
        }
        
        public Student(StudentService.Student stud){
            this.name = stud.firstName + ' ' + stud.lastname;
        } 
    }
    
    public class JournalEntry{
        
        @AuraEnabled public String customerID {get;set;}
        @AuraEnabled public String agreementID {get;set;}
        @AuraEnabled public Date transactionDate {get;set;}
        @AuraEnabled public Decimal transactionAmount {get;set;}
        @AuraEnabled public String agreementName {get;set;}
        @AuraEnabled public String programName {get;set;}
        @AuraEnabled public Boolean isFullyAllocated {get;set;} 
        @AuraEnabled public Boolean isPaymentInstruction {get;set;} 
         
        @AuraEnabled public String feeID {get;set;}
        @AuraEnabled public String feeType {get;set;}
        
        @AuraEnabled public String amountDueID {get;set;}
        @AuraEnabled public String amountDueType {get;set;}
        @AuraEnabled public String amountDueExclude {get;set;}
        
        @AuraEnabled public String paymentInstructionID {get;set;}
        @AuraEnabled public Decimal paymentAmountAllocated {get;set;}
        @AuraEnabled public Decimal paymentRemainingAllocation {get;set;}
         
        @AuraEnabled public String entryType {get;set;}
        @AuraEnabled public String linkToRecord {get;set;}
               
        public journalEntry(LedgerService.JournalEntry theEntry){
            this.customerID  = theEntry.customerID; 
            this.agreementID = theEntry.agreementID; 
            this.transactionDate = theEntry.transactionDate;
            this.transactionAmount = theEntry.transactionAmount; 
            
            this.feeID = theEntry.feeID;
            this.feeType = theEntry.feeType; 
            
            this.amountDueID = theEntry.amountDueID;
            this.amountDueType = theEntry.amountDueType;
            this.amountDueExclude = theEntry.amountDueExclude;
            
            this.paymentInstructionID = theEntry.paymentInstructionID; 
            this.paymentAmountAllocated = theEntry.paymentAmountAllocated; 
            this.paymentRemainingAllocation = theEntry.paymentRemainingAllocation;
            
            if(theEntry.feeID <> null){ 
                entryType = 'Fee';  
                linkToRecord = '/' + theEntry.feeID;  
            }
            else{ 
                if(theEntry.paymentInstructionID <> null){
                    entryType = 'Payment Instruction'; 
                    linkToRecord = '/' + theEntry.paymentInstructionID; 
                }
                else{
                    if(theEntry.amountDueID <> null && amountDueType == 'Monthly Amount'){
                        entryType = 'Monthly Amount';
                        linkToRecord = '/' + theEntry.amountDueID; 
                    }
                    else{ 
                        if(theEntry.amountDueID <> null && amountDueType == 'Reconciliation'){
                            entryType = 'Reconciliation';
                            linkToRecord = '/' + theEntry.amountDueID;
                        }
                        else{
                            if(theEntry.refundID <> null){
                                entryType = 'Refund';
                                linkToRecord = '/' + theEntry.refundID;
                            }
                            else{
                                entryType = '';
                            }  
                        }  
                        
                    }
                }
            }
            this.isPaymentInstruction = false;
            if(entryType == 'Payment Instruction') this.isPaymentInstruction = true;
            
            this.isFullyAllocated = false;
            if(theEntry.paymentInstructionID <> null && theEntry.paymentRemainingAllocation == 0) this.isFullyAllocated = true;    
        
            
        }    
                             
    }  
}