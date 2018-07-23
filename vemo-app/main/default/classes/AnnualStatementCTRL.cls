public with sharing class AnnualStatementCTRL{

    public Id studentId {get;set;}
    
    public account getAccount()
    {
        //Map<ID, Account> acctMap = AccountQueries.getStudentMapWithStudentID(new set<id>{studentId});
        return [select name, VemoAccountNumber__c,personMailingStreet, personMailingCity, personMailingCountry, personMailingPostalCode, personMailingState from account where id =: studentId limit 1];
    }
    public List<StudentProgram__c> getstudentprograms()
    {
        List<StudentProgram__c> stProgramList;
        stProgramList = [select ProgramName__c,VemoContractNumber__c, SchoolName__c, FundingAmountPostCertification__c, 
                        IncomeSharePostCertification__c, PaymentTermPostCertification__c, PaymentCapPostCertification__c, 
                        ServicingStartDate__c,RemainingTerm__c,MinimumIncomePerMonth__c, GraceMonthsAllowed__c, 
                        GraceMonthsRemaining__c, GraceMonthsUsed__c,DefermentMonthsAllowed__c,DefermentMonthsRemaining__c,
                        DefermentMonthsUsed__c, (select Amount__c,AssessmentDateTime__c,RemainingAllocation__c from Student_Program_Debits__r order by AssessmentDateTime__c desc) from StudentProgram__c 
                        where status__c !='Cancelled' and student__c =: studentId];
        return stProgramList;
    }
}