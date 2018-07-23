/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIStatementResource
// 
// Description: 
// 	Direction Central for Statement API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-18   Greg Cook       Created                              
// 
/////////////////////////////////////////////////////////////////////////
public with sharing  class VemoAPIStatementResource {
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		if((api.version == 'v1') && (api.method == 'POST')){
			//return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			//return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			//return handleDeleteV1(api);
		}			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}

	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){			
		System.debug('VemoAPIStatementResource.handleGetV1()');
		String studentlIDParam = api.params.get('studentID');
		Map<Id, StatementService.StatementV1> statments = new Map<Id, StatementService.StatementV1> ();
		if(studentlIDParam != null){
			statments = StatementService.getCurrentStatementV1ByStudentWithStudentID(VemoApi.parseParameterIntoIDSet(studentlIDParam));
		}
		else{
			throw new VemoAPI.VemoAPIFaultException('Required parameter studentIds');
		}
		List<StatmentResourceOutputV1> results = new List<StatmentResourceOutputV1> ();
		for(StatementService.StatementV1 stat : statments.values()){
			results.add(new StatmentResourceOutputV1(stat));
		}
		return (new VemoAPI.ResultResponse(results, results.size()));
	}

	public class StatmentResourceOutputV1{
		String accountNumber {get;set;}
		String studentID {get;set;}
		String name {get;set;}
		String email {get;set;}
		Date statementDate {get;set;}
		Date dueDate {get;set;}
		Boolean autoPay {get;set;}
		Decimal annualIncome {get;set;}
		Date incomeVerificationDate {get;set;}		

		public Decimal feesDue {get;set;}
		public Decimal expectedPayment {get;set;}
	

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

		List<StatementAgreementResourceOutputV1> agreements {get;set;}

		public StatmentResourceOutputV1(StatementService.StatementV1 statement){
			this.accountNumber = statement.accountNumber;
			this.studentID = statement.studentID;	
			this.name = statement.name;
			this.email = statement.email;
			this.statementDate = statement.statementDate;
			this.dueDate = statement.dueDate;
			this.autoPay = statement.autoPay;

			this.annualIncome = statement.annualIncome;
			this.incomeVerificationDate = statement.incomeVerificationDate;
			this.feesDue = statement.feesDue;
			this.expectedPayment = statement.expectedPayment;

			this.totalAmountDue = statement.totalAmountDue;
			this.totalAmountPastDue = statement.totalAmountPastDue;
			this.totalAmountCurrentDue = statement.totalAmountCurrentDue;

			this.totalMonthlyAmountDue = statement.totalMonthlyAmountDue;
			this.totalMonthlyAmountPastDue = statement.totalMonthlyAmountPastDue;
			this.totalMonthlyAmountCurrentDue = statement.totalMonthlyAmountCurrentDue;

			this.totalReconciliationDue = statement.totalReconciliationDue;
			this.totalReconciliationPastDue = statement.totalReconciliationPastDue;
			this.totalReconciliationCurrentDue = statement.totalReconciliationCurrentDue;

			this.accountCredit = statement.accountCredit;
			this.remainingTerm = statement.remainingTerm;
			this.totalPaidToDate = statement.totalPaidToDate;

			if(statement.agreements != null && !statement.agreements.isEmpty()){
				agreements = new List<StatementAgreementResourceOutputV1>();
				for(StatementService.StatementAgreementV1 agree : statement.agreements){
					agreements.add(new StatementAgreementResourceOutputV1(agree));
				}
			}
		}
	}	

	public class StatementAgreementResourceOutputV1{
		String agreementNumber {get;set;}
		String programName {get;set;}
		Date dateSigned {get;set;}
		String status {get;set;}
		Decimal incomeShare {get;set;}
		
		Decimal amountDue {get;set;}
		Decimal amountPastDue {get;set;}
		Decimal amountCurrentDue {get;set;}

		Decimal monthlyAmountDue {get;set;}
		Decimal monthlyAmountPastDue {get;set;}
		Decimal monthlyAmountCurrentDue {get;set;}

		Decimal reconciliationDue {get;set;}
		Decimal reconciliationPastDue {get;set;}
		Decimal reconciliationCurrentDue {get;set;}		

		public StatementAgreementResourceOutputV1(StatementService.StatementAgreementV1 agreement){
			this.agreementNumber = agreement.agreementNumber;
			this.programName = agreement.programName;
			this.dateSigned = agreement.dateSigned;
			this.status = agreement.status;
			this.incomeShare = agreement.incomeShare;

			this.amountDue = agreement.amountDue;
			this.amountPastDue = agreement.amountPastDue;
			this.amountCurrentDue = agreement.amountCurrentDue;

			this.monthlyAmountDue = agreement.monthlyAmountDue;
			this.monthlyAmountPastDue = agreement.monthlyAmountPastDue;
			this.monthlyAmountCurrentDue = agreement.monthlyAmountCurrentDue;

			this.reconciliationDue = agreement.reconciliationDue;
			this.reconciliationPastDue = agreement.reconciliationPastDue;
			this.reconciliationCurrentDue = agreement.reconciliationCurrentDue;

		}
	}
}