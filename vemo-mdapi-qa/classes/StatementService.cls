public with sharing class StatementService {
	private static Map<ID, List<PaymentInstructionService.PaymentInstruction>> paymentsByStudent;
	public class StatementV1{
		public String accountNumber {get;set;}

		public String studentID {get;set;}
		public String name {get;set;}
		public String email {get;set;}
		public Date statementDate {get;set;}
		public Date dueDate {get;set;}
		public Boolean autoPay {get;set;}

		public Decimal annualIncome {get;set;}
		public Date incomeVerificationDate {get;set;}
		//Decimal previousUnpaidAmountDue {get;set;}
		public Decimal expectedPayment {get;set;}
		public Decimal feesDue {get;set;}

		public Decimal totalAmountDue {get;set;}
		public Decimal totalAmountPastDue {get;set;}
		public Decimal totalAmountCurrentDue {get;set;}

		public Decimal totalMonthlyAmountDue {get;set;}
		public Decimal totalMonthlyAmountPastDue {get;set;}
		public Decimal totalMonthlyAmountCurrentDue {get;set;}

		public Decimal totalReconciliationDue {get;set;}
		public Decimal totalReconciliationPastDue {get;set;}
		public Decimal totalReconciliationCurrentDue {get;set;}

		public Decimal accountCredit {get;set;}

		public Integer remainingTerm {get;set;}

		public Decimal totalPaidToDate {get;set;}

		//public Decimal accountCredit {get;set;}
		public  List<StatementAgreementV1> agreements {get;set;}

		public StatementV1(){
			agreements = new List<StatementAgreementV1>();
		}

		public StatementV1(Boolean test){
			if(test){
				this.accountNumber = '10406839';
				this.name = 'John Smith';
				this.email = 'john.smith@gmail.com';
				this.statementDate = Date.newInstance(2017,06,15);
				this.dueDate = Date.newInstance(2017, 07, 01);
				this.autoPay = true;
//				this.totalDue = 560.16;
				this.annualIncome = 50000;
				this.incomeVerificationDate = Date.newInstance(2017, 02, 14);
				//this.previousUnpaidAmountDue = 20;
				//this.expectedPayment = 540.16;
				this.feesDue = 5;
//				this.totalIncomeShareDue = 510.80;
				//this.accountCredit = 0;

				List<StatementAgreementV1> agreements = new List<StatementAgreementV1>();
				StatementAgreementV1 ag1 = new StatementAgreementV1();
				ag1.agreementNumber = '59284017';
				ag1.programName = 'Program Awesome 2017-18 Fund';
				ag1.dateSigned = Date.newInstance(2017, 03, 05);
				ag1.status = 'Payment';
				ag1.incomeShare = 3.22;
				ag1.amountDue = 25;
				agreements.add(ag1);
				this.agreements = agreements;
				system.debug(this);
			}
		}
		public StatementV1(StudentService.Student student, List<AgreementService.Agreement> studentAgreements){
			System.debug('StatementService.StatementV1(student, studentAgreements)');
			System.debug('student:'+student);
			System.debug('studentAgreements:'+studentAgreements);
			this.accountNumber = student.accountNumber;
			this.studentID = student.personAccountID;
			this.name = student.firstName + ' ' + student.lastName;
			this.email = student.email;
			this.statementDate = Date.today();

			this.autoPay = (student.autoPayment == 'true' ? true : false);
			//this.totalDue = 560.16;
			this.annualIncome = student.verifiedAnnualIncome;
			this.incomeVerificationDate = student.dateIncomeVerified;
			//this.previousUnpaidAmountDue = 20; //not sure where to store /get this
			//this.expectedPayment = 540.16; // calculated value
			this.feesDue = (student.unpaidFees != null ? student.unpaidFees : 0);
			//this.totalIncomeShareDue = 510.80;
			//this.accountCredit = (student.credit != null ? student.credit : 0);

			this.totalAmountDue = 0;
			this.totalAmountPastDue = 0;
			this.totalAmountCurrentDue = 0;

			this.totalMonthlyAmountDue = 0;
			this.totalMonthlyAmountPastDue = 0;
			this.totalMonthlyAmountCurrentDue = 0;

			this.totalReconciliationDue = 0;
			this.totalReconciliationPastDue = 0;
			this.totalReconciliationCurrentDue = 0;

			this.remainingTerm = 0;

			this.totalPaidToDate = 0;
			List<StatementAgreementV1> statementAgreements = new List<StatementAgreementV1>();
			for(AgreementService.Agreement agreement : studentAgreements){

				this.totalPaidToDate += (agreement.paidToDate == null ? 0 : agreement.paidToDate);
				if((agreement.nextPaymentDueDate != null) && (agreement.servicing == 'true')){
					if(this.dueDate == null) this.dueDate = agreement.nextPaymentDueDate;
					this.dueDate = (dueDate < agreement.nextPaymentDueDate ? dueDate : agreement.nextPaymentDueDate);					
				}


				remainingTerm = (agreement.remainingTerm > remainingTerm ? agreement.remainingTerm : remainingTerm);

				StatementAgreementV1 statementAgreement = new StatementAgreementV1(agreement);
				statementAgreements.add(statementAgreement);
				
				this.totalMonthlyAmountDue += statementAgreement.monthlyAmountDue;
				this.totalMonthlyAmountPastDue += statementAgreement.monthlyAmountPastDue;
				this.totalMonthlyAmountCurrentDue += statementAgreement.monthlyAmountCurrentDue;

				this.totalReconciliationDue += statementAgreement.reconciliationDue;
				this.totalReconciliationCurrentDue += statementAgreement.reconciliationCurrentDue;
				this.totalReconciliationPastDue += statementAgreement.reconciliationPastDue;


			}
			if(this.dueDate == null){
				this.dueDate = Date.today();
			}
			this.totalAmountDue = this.totalMonthlyAmountDue + this.totalReconciliationDue;
			this.totalAmountPastDue = this.totalMonthlyAmountPastDue + this.totalReconciliationPastDue;
			this.totalAmountCurrentDue = this.totalMonthlyAmountCurrentDue + this.totalReconciliationCurrentDue;

			//Net out any unallocated payments out of the expected payment
			this.accountCredit = 0;

			if(paymentsByStudent.containsKey(student.personAccountID)){
				for(PaymentInstructionService.PaymentInstruction payment : paymentsByStudent.get(student.personAccountID)){
					accountCredit += (payment.remainingAllocation == null ? 0 : payment.remainingAllocation);

				}
			}


			this.expectedPayment = this.totalAmountDue + this.feesDue;
			if(accountCredit >= expectedPayment){
				this.expectedPayment = 0;
			} else {
				expectedPayment = expectedPayment - accountCredit;
			}
			

			this.agreements = statementAgreements;
		}


	}
	public class StatementAgreementV1{
		public String agreementNumber {get;set;}
		public String programName {get;set;}
		public Date dateSigned {get;set;}
		public String status {get;set;}
		public Decimal incomeShare {get;set;}

		public Decimal amountDue {get;set;}
		public Decimal amountPastDue {get;set;}
		public Decimal amountCurrentDue {get;set;}

		public Decimal monthlyAmountDue {get;set;}
		public Decimal monthlyAmountPastDue {get;set;}
		public Decimal monthlyAmountCurrentDue {get;set;}

		public Decimal reconciliationDue {get;set;}
		public Decimal reconciliationPastDue {get;set;}
		public Decimal reconciliationCurrentDue {get;set;}



		public StatementAgreementV1(){

		}
		public StatementAgreementV1(AgreementService.Agreement agreement){
			System.debug('StatementService.StatementAgreementV1(agreement)');
			System.debug('agreement:'+agreement);
			this.agreementNumber = agreement.vemoContractNumber;
			this.programName = agreement.programName;
			if(agreement.submittedDateTime != null){
				DateTime dt = agreement.submittedDateTime;
				this.dateSigned = Date.newInstance(dt.year(), dt.month(), dt.day());	
				System.debug('this.dateSigned:'+this.dateSigned);			
			}

			this.status = agreement.agreementStatus;
			this.incomeShare = agreement.incomeSharePostCertification;

			this.monthlyAmountDue = (agreement.monthlyAmountDue == null) ? 0 : agreement.monthlyAmountDue;
			this.monthlyAmountPastDue = (agreement.monthlyAmountPastDue == null) ? 0 : agreement.monthlyAmountPastDue;
			this.monthlyAmountCurrentDue = (agreement.monthlyAmountCurrentDue == null) ? 0 : agreement.monthlyAmountCurrentDue;

			this.reconciliationDue = (agreement.reconciliationDue == null) ? 0 : agreement.reconciliationDue;
			this.reconciliationPastDue = (agreement.reconciliationPastDue == null) ? 0 : agreement.reconciliationPastDue;
			this.reconciliationCurrentDue = (agreement.reconciliationCurrentDue == null) ? 0 : agreement.reconciliationCurrentDue;

			this.amountDue = (agreement.amountDue == null) ? 0 : agreement.amountDue;
			this.amountPastDue = (agreement.amountPastDue == null) ? 0 : agreement.amountPastDue;
			this.amountCurrentDue = (agreement.amountCurrentDue == null) ? 0 : agreement.amountCurrentDue;

		}
	}

	public static List<Bill__c> createBillsFromStatements(List<StatementService.StatementV1> statements){
		List<Bill__c> billsToCreate = new List<Bill__c>();
		for(StatementService.StatementV1 statement : statements){
			billsToCreate.add(new Bill__c(StatementData__c = String.valueOf(statement),
										  Email__c = statement.email,
										  SendStatement__c = true,
										  VemoAccountNumber__c = statement.accountNumber,
										  Name__c = statement.name,
										  Student__c = statement.studentID,
										  ExpectedPayment__c = statement.expectedPayment,
										  DueDate__c = statement.dueDate,
										  TotalMonthlyAmountDue__c = statement.totalMonthlyAmountDue,
										  TotalMonthlyAmountPastDue__c = statement.totalMonthlyAmountPastDue,
										  TotalMonthlyAmountCurrentDue__c = statement.totalMonthlyAmountCurrentDue,
										  TotalReconciliationDue__c = statement.totalReconciliationDue,
										  TotalReconciliationPastDue__c = statement.totalReconciliationPastDue,
										  TotalReconciliationCurrentDue__c = statement.totalReconciliationCurrentDue,
										  TotalAmountDue__c = statement.totalAmountDue,
										  TotalAmountPastDue__c = statement.totalAmountPastDue,
										  TotalAmountCurrentDue__c = statement.totalAmountCurrentDue,
										  FeesDue__c = statement.feesDue,
										  AccountCredit__c = statement.accountCredit,
										  RemainingTerm__c = statement.remainingTerm
										  ));
		}
		if(billsToCreate.size()>0){
			insert billsToCreate;
		}
		return billsToCreate;
	}

	public static Map<ID, StatementV1> getCurrentStatementV1ByStudentWithStudentID(Set<ID> studentIDs){
		Map<ID, StatementV1> output = new Map<ID, StatementV1>();
		List<StudentService.Student> students = StudentService.getStudentsWithStudentID(studentIDs);
		List<AgreementService.Agreement> allAgreements = AgreementService.getAgreementWithStudentID(studentIDs);

		AgreementService.determineAmountsDue(allAgreements);

		List<PaymentInstructionService.PaymentInstruction> paymentList = PaymentInstructionService.getPaymentInstructionWithStudentID(studentIDs);
		paymentsByStudent = new Map<ID, List<PaymentInstructionService.PaymentInstruction>>();
		for(PaymentInstructionService.PaymentInstruction payment : paymentList){
			if(payment.Status != 'Bounced'){
				if(!paymentsByStudent.containsKey(payment.studentID)){
					paymentsByStudent.put(payment.studentID, new List<PaymentInstructionService.PaymentInstruction>());
				}
				paymentsByStudent.get(payment.studentID).add(payment);
			}
		}

		Map<ID, List<AgreementService.Agreement>> agreementsByStudent = new Map<ID, List<AgreementService.Agreement>>();

		for(AgreementService.Agreement agreement : allAgreements){
			if(!agreementsByStudent.containsKey(agreement.studentID)){
				agreementsByStudent.put(agreement.studentID, new List<AgreementService.Agreement>());
			}
			agreementsByStudent.get(agreement.studentID).add(agreement);
		}


		for(StudentService.Student stud : students){
			List<AgreementService.Agreement> studentAgreements = (agreementsByStudent.containsKey(stud.personAccountID) ? agreementsByStudent.get(stud.personAccountID) : null);
			StatementV1 statement = new StatementV1(stud, studentAgreements);
			output.put(statement.studentID, statement);
		}
		System.debug(output);
		return output;
	}

	public class GenerateBillQueueable implements Queueable {
		public GenerateBillQueueable(){
			
		}
		public GenerateBillQueueable(Set<ID> studentIDs){
			this.studentIDs = studentIDs;
		}
	    public Set<ID> studentIDs {get;set;}
	    public void execute(QueueableContext context) {
	    	system.debug('StatementService.GenerateBillQueueable.execute()');
			Map<ID, StatementService.StatementV1> statements = StatementService.getCurrentStatementV1ByStudentWithStudentID(studentIDs);
			StatementService.createBillsFromStatements(statements.values());
	    }
	}	
}