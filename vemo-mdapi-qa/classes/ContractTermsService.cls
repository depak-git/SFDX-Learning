/////////////////////////////////////////////////////////////////////////
// Class: ContractTermsService
// 
// Description: 
// 	Handles all Contract Terms Service Layer functionality
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-04-25   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
public with sharing class ContractTermsService {
	public static Map<ID, List<ContractTermsService.ContractTerm>> getContractTermsByStudentIDWithStudentMap(ID programID, Map<ID, Account> studentMap){
		System.debug('ContractTermsService.getContractTermsByStudentIDWithStudentMap');
		Map<ID, List<ContractTermsService.ContractTerm>> contractTermsByStudentID = new Map<ID, List<ContractTermsService.ContractTerm>>();



		for(Account student : studentMap.values()){
			//This is not bulk safe as it must query the income band for each student
			IncomeBandQueries.clearFilterCriteria();
			IncomeBandQueries.filterCriteria.put('SchoolProgramOfStudy__c', student.SchoolProgramOfStudy__pc);

			Map<ID, IncomeBand__c> studentsIncomeBand = IncomeBandQueries.getIncomeBandMap();
			System.debug('studentsIncomeBand:'+studentsIncomeBand);

			if(studentsIncomeBand.size() == 1){
				ContractTermQueries.clearFilterCriteria();
				ContractTermQueries.filterCriteria.put('GradeLevel__c', student.PrimarySchoolGradeLevel__pc);
				ContractTermQueries.filterCriteria.put('Program__c', programID);
				ContractTermQueries.filterCriteria.put('EarningsGroup__c', studentsIncomeBand.values()[0].EarningsGroup__c);
				Map<ID, ContractTerm__c> contractTermMap = ContractTermQueries.getContractTermMap();
				System.debug('contractTermMap:'+contractTermMap);

				if(contractTermMap.size() == 1) {
					if(!contractTermsByStudentID.containsKey(student.id)){
						contractTermsByStudentID.put(student.id, new List<ContractTermsService.ContractTerm>());
					}
					contractTermsByStudentID.get(student.id).add(new ContractTermsService.ContractTerm(contractTermMap.values()[0]));
				}
			}
		}

		system.debug('contractTermsByStudentID:'+contractTermsByStudentID);

		return contractTermsByStudentID;
	}

	public static ContractTermsService.ContractTerm getContractTermsWithCriteria(ID programID, 
																				ID schoolProgramOfStudyID,
																				String gradeLevel){
		System.debug('ContractTermsService.getContractTermsWithCriteria');
		ContractTermsService.ContractTerm contractTerm = new ContractTermsService.ContractTerm();



		IncomeBandQueries.clearFilterCriteria();
		IncomeBandQueries.filterCriteria.put('SchoolProgramOfStudy__c', schoolProgramOfStudyID);

		Map<ID, IncomeBand__c> incomeBand = IncomeBandQueries.getIncomeBandMap();
		System.debug('studentsIncomeBand:'+incomeBand);

		if(incomeBand.size() == 1){
			ContractTermQueries.clearFilterCriteria();
			ContractTermQueries.filterCriteria.put('GradeLevel__c', gradeLevel);
			ContractTermQueries.filterCriteria.put('Program__c', programID);
			ContractTermQueries.filterCriteria.put('EarningsGroup__c', incomeBand.values()[0].EarningsGroup__c);
			Map<ID, ContractTerm__c> contractTermMap = ContractTermQueries.getContractTermMap();
			System.debug('contractTermMap:'+contractTermMap);

			if(contractTermMap.size() == 1) {
				contractTerm = new ContractTermsService.ContractTerm(contractTermMap.values()[0]);
			}
		}

		system.debug('contractTerm:'+contractTerm);

		return contractTerm;
	}


	public class ContractTerm{
		public String contractTermID {get;set;}
		public String programID {get;set;}
		public Decimal minimumFundingAmount {get;set;}
		public Decimal maximumFundingAmount {get;set;}
		public Decimal incomeShare {get;set;}
		public Decimal paymentTerm {get;set;}
		public String gradeLevel {get;set;}
		public String earningsGroup {get;set;}
		public String adjustmentMethod {get;set;}
		public Decimal paymentCapFactor {get;set;}


		public ContractTerm(){

		}

		public ContractTerm(Boolean testValues){
			if(testValues){
				//to do
				//this.programName = 'testProgramName';
				//this.programStatus = 'Open'; //Planned, Closed, Cancelled
			}
		}

		public ContractTerm(ContractTerm__c term){
			this.contractTermID = term.id;
			this.programID = term.Program__c;
			this.minimumFundingAmount = term.MinimumFundingAmount__c;
			this.maximumFundingAmount = term.MaximumFundingAmount__c;
			this.incomeShare = term.IncomeShare__c;
			this.paymentTerm = term.PaymentTerm__c;
			this.gradeLevel = term.GradeLevel__c;
			this.earningsGroup = term.EarningsGroup__c;
			this.adjustmentMethod = term.AdjustmentMethod__c;
			this.paymentCapFactor = term.PaymentCapFactor__c;
		}
	}
	public class ContractTermsServiceException extends Exception {}
}