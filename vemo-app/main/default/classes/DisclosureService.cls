/////////////////////////////////////////////////////////////////////////
// Class: DisclosureService
// 
// Description: 
// 	Calculation for Disclosure template output
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-03-03   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
public class DisclosureService {
/**********************************************************
    Calculation Disclosure
***********************************************************/
    public static void Calculation(List<StudentProgram__c> studPrograms) {
        System.debug('DisclosureService.Calculation()');
        //rehydrate the studentprograms:
        Set<ID> studProgIDs = new Set<ID>();
        for(StudentProgram__c stud : studPrograms){
            studProgIDs.add(stud.id);
        }
        List<StudentProgram__c> hydratedStuds = [SELECT id,
                                                        Program__c,
                                                        //AllocatedAmount__c,
                                                        //RequestedAmount__c,
                                                        //PaymentTerm__c,
                                                        //PaymentCap__c,
                                                        //IncomeShare__c,
                                                        FundingAmountPostCertification__c,
                                                        PaymentTermPostCertification__c,
                                                        PaymentCapPostCertification__c,
                                                        IncomeSharePostCertification__c
                                                         from StudentProgram__c where id= :studProgIDs];
        //Collect necessary ids
        Set<String> programIds = new Set<String>();
        for (StudentProgram__c sp : hydratedStuds) {
        	System.Debug('*** sp ' + sp);
        	if (sp.Program__c != null)
            	programIds.add(sp.Program__c);
        }
        if (programIds.size() == 0)
        	return;
        
        Map<String, Program_Config__c> configsByProgram = new Map<String, Program_Config__c>();
        //Retrieve Program_Config__c records
        for (Program_Config__c c : [Select ID, Name, Program__c, 
                                            PaymentCapFactor__c, 
                                            InSchoolGraceMonthsDisbursement2__c, 
                                            InSchoolGraceMonthsDisbursement1__c, 
                                            AssumedAnnualIncomeGrowth__c, 
                                        (Select Id, Name, 
                                            LoanType__c,
                                            OriginationFeePercentage__c, 
                                            InSchoolInterestRate__c, 
                                            InPaymentInterestRate__c, 
                                            PaymentTerm__c, 
                                            ProgramConfig__c 
                                        From ConfigLoanAlternatives__r), 
                                        (Select Id, Name, 
                                            ProgramConfig__c, 
                                            Income__c, 
                                            IsMinimumThreshold__c, 
                                            ListInIncomeGrowthExample__c 
                                        From ConfigAnnualIncomeLevels__r
                                        Order by Income__c) 
                                    From Program_Config__c
                                Where Program__c in: programIds]) {
            configsByProgram.put(c.Program__c, c);
        }
        if (configsByProgram.size() == 0)
        	return;
        
    	CalculateISAPayments(hydratedStuds, configsByProgram);
    	CalculateLoanAlternatives(hydratedStuds, configsByProgram);
    }
    
/**********************************************************
    Calculation Loan Alternatives
***********************************************************/
    public static void CalculateLoanAlternatives(List<StudentProgram__c> studPrograms,
    										Map<String, Program_Config__c> configsByProgram) {
        System.debug('DisclosureService.CalculateLoanAlternatives()');
    	List<Studnet_Loan_Alternative_Payment__c> loanalttoAdd = new List<Studnet_Loan_Alternative_Payment__c>();
        for (StudentProgram__c sp : studPrograms) {
            Program_Config__c config = configsByProgram.get(sp.Program__c);
            if (config == null)
                continue;
            
        /*-------------------------------------
            configuration data
        ---------------------------------------*/
/*            //Funding Amount
            Double largeDbl = 4294967295.00;



            Decimal fundingAmount = Math.min((sp.AllocatedAmount__c == null ? largeDbl : sp.AllocatedAmount__c),
           						(sp.RequestedAmount__c == null ? largeDbl : sp.RequestedAmount__c));
            if (fundingAmount == largeDbl)
            	return;
            */
            //just use the post certified funding amount here
            Decimal fundingAmount = (sp.FundingAmountPostCertification__c == null ? 0 : sp.FundingAmountPostCertification__c);
        /*-------------------------------------
            build the PaymentBreakDown struct
        ---------------------------------------*/
            Map<String, LoanBreakDown> breakdowns = new Map<String, LoanBreakDown>();
            for (Config_Loan_Alternative__c loan : config.ConfigLoanAlternatives__r) {
	            //Payment Terms associated with the loan.
	            Integer paymentTerms = 0;
	            try {
	                paymentTerms = loan.PaymentTerm__c == null ? 0 : Integer.valueOf(loan.PaymentTerm__c);
	            } catch (Exception e) {}
	            if (paymentTerms == 0)
	            	continue;
	            
                LoanBreakDown breakdown = breakdowns.get(loan.Id);
                if (breakdown == null) {
                    breakdown = new LoanBreakDown();
                    breakdowns.put(loan.Id, breakdown);
                }
                
                //Config_Loan_Alternative__c record
                breakdown.Loan = loan;
                
                Decimal originationFee = (loan.OriginationFeePercentage__c == null ? 0 : loan.OriginationFeePercentage__c)/100.00;
            	breakdown.RequiredLoan = fundingAmount / (1.00 - originationFee);
            	
            	Decimal disburseSum = 	(config.InSchoolGraceMonthsDisbursement1__c == null ? 15.00 : config.InSchoolGraceMonthsDisbursement1__c) + 
            							(config.InSchoolGraceMonthsDisbursement2__c == null ? 11.00 : config.InSchoolGraceMonthsDisbursement2__c);
            	Decimal inschoolRate = (loan.InSchoolInterestRate__c == null ? 0 : loan.InSchoolInterestRate__c)/100.00;
            	breakdown.BalanceAtRepayment = breakdown.RequiredLoan * (1 + disburseSum * inschoolRate / 24.00);
            	
            	Decimal paymentRate = (loan.InPaymentInterestRate__c == null ? 0 : loan.InPaymentInterestRate__c)/100.00;
            	breakdown.MonthlyPayment = PMT(paymentRate, paymentTerms, breakdown.BalanceAtRepayment);
				
            	breakdown.TotalPayment = breakdown.MonthlyPayment * paymentTerms;
            }
            
        /*-------------------------------------
            build Student Program - ISA Payment records
        ---------------------------------------*/
            
            for (String b : breakdowns.keySet()) {
                LoanBreakDown breakdown = breakdowns.get(b);
                
                Studnet_Loan_Alternative_Payment__c lonealt = new Studnet_Loan_Alternative_Payment__c();
                loanalttoAdd.add(lonealt);
                
                lonealt.StudentProgram__c = sp.Id;
                lonealt.LoanType__c = breakdown.Loan.LoanType__c;
                lonealt.InterestRates__c = breakdown.Loan.InPaymentInterestRate__c;
                lonealt.TotalPayment__c = breakdown.TotalPayment;
                lonealt.OriginationFeeSurcharge__c = breakdown.RequiredLoan - fundingAmount;
            }
        }
        
        List<Studnet_Loan_Alternative_Payment__c> loanalttoDelete = [Select ID From Studnet_Loan_Alternative_Payment__c Where StudentProgram__c in: studPrograms];
        if (loanalttoDelete.size() > 0)
            database.delete(loanalttoDelete, false);
        
        if (loanalttoAdd.size() > 0)
        	insert loanalttoAdd;
	}
    /*
    Annual Loan Constant = 12 * i / (1 - (1 / ((1 + i) ^ n)))
	where: i = annual mortgage interest rate divided by 12
		n = term of loan in months
	Annual Pay = Annual Loan Constant * Loan Amount
	Monthly Pay = Annual Pay / 12
	
	System.Debug(DisclosureService.PMT(0.05, 48, 10000));
	*/
    public static Decimal PMT(Decimal rate, Integer term, Decimal amount) {
    	if (rate == null || term == null || amount == null)
    		return 0;
    	
    	Decimal step1 = rate / 12.00;
    	Decimal step2 = Math.Pow(Double.valueOf(1.00 + step1), Double.valueOf(term));
    	Decimal step3 = 1.00 / step2;
    	Decimal step4 = 1.00 - step3;
    	Decimal loanconstant = 12.00 * step1 / step4;
    	Decimal annualpay = amount * loanconstant;
    	Decimal monthlypay = annualpay / 12.00;
    	
    	return monthlypay;
    }
    
    class LoanBreakDown {
    	Config_Loan_Alternative__c Loan;
        Decimal TotalPayment;
        
        Decimal RequiredLoan;
        Decimal BalanceAtRepayment;
        Decimal MonthlyPayment;
        Decimal EffectiveImmediateAPR;
        Decimal ImmediateMonthlyPayment;
        Decimal EffectiveImmediateAPR2;
        Decimal AfterGraceMonthlyPayment;
        Decimal EffectiveAfterGraceAPR;
        
    }
	
/**********************************************************
    Calculation ISA Payments
***********************************************************/
    public static void CalculateISAPayments(List<StudentProgram__c> studPrograms,
    										Map<String, Program_Config__c> configsByProgram) {
        System.debug('DisclosureService.CalculateISAPayments()');
        List<Student_ISA_Payment__c> isatoAdd = new List<Student_ISA_Payment__c>();
        for (StudentProgram__c sp : studPrograms) {
            Program_Config__c config = configsByProgram.get(sp.Program__c);
            if (config == null)
                continue;
            
        /*-------------------------------------
            configuration data
        ---------------------------------------*/
/*            //Funding Amount
            Double largeDbl = 4294967295.00;


            Decimal fundingAmount = Math.min((sp.AllocatedAmount__c == null ? largeDbl : sp.AllocatedAmount__c),
           						(sp.RequestedAmount__c == null ? largeDbl : sp.RequestedAmount__c));
            if (fundingAmount == largeDbl)
            	return;*/
            //just use the post certified funding amount here
            Decimal fundingAmount = (sp.FundingAmountPostCertification__c == null ? 0 : sp.FundingAmountPostCertification__c);            
            //Payment Cap
            Decimal paymentCapFactor = config.PaymentCapFactor__c == null ? 2.5 : config.PaymentCapFactor__c;
            Decimal paymentCap = sp.PaymentCapPostCertification__c == null ? 
                                    fundingAmount * paymentCapFactor :
                                    sp.PaymentCapPostCertification__c;
			
            //Income Minimal Threshold
            Decimal incomeMinimalThreshold = 0;
            for (Config_Annual_Income_Level__c level : config.ConfigAnnualIncomeLevels__r) {
                if (level.IsMinimumThreshold__c) {
                    incomeMinimalThreshold = level.Income__c;
                }
            }
            
            //Payment Terms
            Integer paymentTerms = 0;
            try {
                paymentTerms = sp.PaymentTermPostCertification__c == null ? 0 : Integer.valueOf(sp.PaymentTermPostCertification__c);
            } catch (Exception e) {}
            
            if (paymentTerms == 0)
            	continue;
            
            //Income share
            Decimal sharePercent = (sp.IncomeSharePostCertification__c == null ? 3.00 : sp.IncomeSharePostCertification__c) / 100.00;
            
        /*-------------------------------------
            build the PaymentBreakDown struct
        ---------------------------------------*/
            Map<String, PaymentBreakDown> breakdowns = new Map<String, PaymentBreakDown>();
            for (Config_Annual_Income_Level__c level : config.ConfigAnnualIncomeLevels__r) {
                PaymentBreakDown breakdown = breakdowns.get(level.Id);
                if (breakdown == null) {
                    breakdown = new PaymentBreakDown();
                    breakdowns.put(level.Id, breakdown);
                }
                
                //Config_Annual_Income_Level__c record
                breakdown.IncomeLevel = level;
                
                //MonthlyPayment list 
                Decimal income = level.Income__c == null ? 0 : level.Income__c;
                Decimal totalOverTerms = 0;
                Decimal totalOverTerms_Flat = 0;
                for (Integer i = 0; i < paymentTerms; i++) {
                    MonthlyPayment payment = new MonthlyPayment();
                    breakdown.Payments.add(payment);
                    
                    payment.Month = i+1;
                    payment.Year = i/12+1;
                    
                    //consider no growth
                    Decimal flatdollars = 0;
                    if (income < incomeMinimalThreshold) {
                        flatdollars = 0;
                    } else {
                        flatdollars = income * sharePercent / 12.000000000000;
                    }
                    if (paymentCap <= totalOverTerms_Flat + flatdollars) {
                        totalOverTerms_Flat = paymentCap;
                        payment.FlatPayment = (paymentCap - totalOverTerms_Flat);
                        breakdown.IsPaymentCap = true;
                    } else {
                        payment.FlatPayment = flatdollars;
                        totalOverTerms_Flat = totalOverTerms_Flat + flatdollars;
                    }
                    
                    //consider income growth
                    //growth starts at the second year
                    Decimal growth = config.AssumedAnnualIncomeGrowth__c == null ? 0 : config.AssumedAnnualIncomeGrowth__c/100.00;
                    Decimal increment = Math.Pow(Double.valueOf(1 + growth), Double.valueOf(payment.Year - 1));
               		
                    payment.AssumedAnnualIncome = income * increment;
                    breakdown.AssumedAnnualIncome = payment.AssumedAnnualIncome;
                    
                    Decimal dollars = 0;
                    if (payment.AssumedAnnualIncome < incomeMinimalThreshold) {
                        dollars = 0;
                    } else {
                        dollars = payment.AssumedAnnualIncome * sharePercent / 12.000000000000;
                    }
                    if (paymentCap <= totalOverTerms + dollars) {
                        totalOverTerms = paymentCap;
                        payment.Payment = (paymentCap - totalOverTerms);
                        breakdown.IsPaymentCap = true;
                    } else {
                        payment.Payment = dollars;
                        totalOverTerms = totalOverTerms + dollars;
                    }
                }
                
                breakdown.TotalPayments_IncomeGrowth = totalOverTerms;
                breakdown.TotalPayments_Flat = totalOverTerms_Flat;
            }
            
        /*-------------------------------------
            build Student Program - ISA Payment records
        ---------------------------------------*/
            
            for (String b : breakdowns.keySet()) {
                PaymentBreakDown breakdown = breakdowns.get(b);
                
                Student_ISA_Payment__c isa = new Student_ISA_Payment__c();
                isatoAdd.add(isa);
                
                isa.StudentProgram__c = sp.Id;
                isa.AnnualIncomeLevel__c = breakdown.IncomeLevel.Income__c;
                isa.IsPaymentCap__c = breakdown.IsPaymentCap;
                isa.ListInIncomeGrowthExample__c = breakdown.IncomeLevel.ListInIncomeGrowthExample__c;
                isa.MonthlyPaymentFlat__c = breakdown.Payments[0].FlatPayment;
                isa.TotalPaymentsFlat__c = breakdown.TotalPayments_Flat;
                isa.TotalPaymentsWithIncomeGrowth__c = breakdown.TotalPayments_IncomeGrowth;
            }
        }
        
        List<Student_ISA_Payment__c> isatoDelete = [Select ID From Student_ISA_Payment__c Where StudentProgram__c in: studPrograms];
        if (isatoDelete.size() > 0)
            database.delete(isatoDelete, false);
        
        if (isatoAdd.size() > 0)
        	insert isatoAdd;
    }
    
    class PaymentBreakDown {
        Config_Annual_Income_Level__c IncomeLevel;
        Decimal TotalPayments_IncomeGrowth;
        Decimal TotalPayments_Flat;
        List<MonthlyPayment> Payments;
        Boolean IsPaymentCap;
        Decimal AssumedAnnualIncome;
        
        PaymentBreakDown() {
        	IsPaymentCap = false;
            Payments = new List<MonthlyPayment>();
        }
    }
    
    class MonthlyPayment {
        Integer Month;
        Integer Year;
        //consider growth
        Decimal AssumedAnnualIncome;
        Decimal Payment;
        //not consider growth
        Decimal FlatPayment;
    }
/*
    //DisclosureService.CreateData();
    public static void CreateData() {
    	/*
		delete ([Select Id
                From Config_Loan_Alternative__c
                Where Name not in ('LOAN0','LOAN1','LOAN2','LOAN3','LOAN4','LOAN5','LOAN6')]);
        
        delete ([Select Id
                From Config_Annual_Income_Level__c
                Where Name not in ('INCOME0','INCOME1','INCOME2','INCOME3','INCOME4','INCOME5','INCOME6','INCOME6','INCOME7','INCOME8','INCOME9')]);

        delete ([Select Id
                From Config_Loan_Alternative__c
                Where ProgramConfig__c <> 'a0xR0000003ZSJV']);
        
        delete ([Select Id
                From Config_Annual_Income_Level__c
                Where ProgramConfig__c <> 'a0xR0000003ZSJV']);
        *
    	List<Config_Loan_Alternative__c> altersToAdd = new List<Config_Loan_Alternative__c>();
    	List<Config_Annual_Income_Level__c>  incomesToAdd = new List<Config_Annual_Income_Level__c>();
    	List<Config_Loan_Alternative__c> alters = [Select Id, Name, 
                                            LoanType__c,
                                            OriginationFeePercentage__c, 
                                            InSchoolInterestRate__c, 
                                            InPaymentInterestRate__c, 
                                            PaymentTerm__c, 
                                            ProgramConfig__c 
                                        From Config_Loan_Alternative__c];
    	List<Config_Annual_Income_Level__c> incomes = [Select Id, Name, 
                                            ProgramConfig__c, 
                                            Income__c, 
                                            IsMinimumThreshold__c, 
                                            ListInIncomeGrowthExample__c 
                                        From Config_Annual_Income_Level__c];
        
        for (Program_Config__c c : [Select ID From Program_Config__c Where ID <> 'a0xR0000003ZSJV']) {
        	for (Config_Loan_Alternative__c a : alters) {
        		Config_Loan_Alternative__c a1 = a.clone();
        		a1.ProgramConfig__c = c.Id;
        		altersToAdd.add(a1.clone()); 
        	}
        	for (Config_Annual_Income_Level__c a : incomes) {
        		Config_Annual_Income_Level__c a1 = a.clone();
        		a1.ProgramConfig__c = c.Id;
        		incomesToAdd.add(a1.clone()); 
        	}
        }
        
        insert altersToAdd;
        insert incomesToAdd;
    }
*/
}