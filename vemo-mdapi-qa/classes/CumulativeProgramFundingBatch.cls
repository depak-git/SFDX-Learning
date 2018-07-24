public class CumulativeProgramFundingBatch implements Database.Batchable<sObject> {
	
	public String query {get;set;}
	public Boolean debugScope {get;set;}
	
	public CumulativeProgramFundingBatch() {
		query = 'SELECT id from Account where RecordTypeID = \''+String.valueOf(GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student')+'\'');
		debugScope = true;
		System.debug(this);
	}
	public CumulativeProgramFundingBatch(String query, Boolean debugScope){
		this.query = query;
		this.debugScope = debugScope;
	}
	
	public Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug(query);
		return Database.getQueryLocator(query);
	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
   		Map<ID, sObject> scopeMap = new Map<ID, sObject>(scope);
   		List<Account> acctsToUpdate = new List<Account>();
		//Get All Students as the main loop
		Boolean debug = debugScope;
		//Boolean debug = true;
		//Boolean debug = false;
		for(List<Account> students : [SELECT id,
											 SchoolProgramOfStudy__pc,
											 PrimarySchoolGradeLevel__pc
									  FROM Account
									  where ID = :scopeMap.keySet()
									  and RecordTypeID = :GlobalUtil.getRecordTypeIdByLabelName('Account', 'Student')]){
			Map<ID, Account> studentMap = new Map<ID, Account>(students);
			if(debug) System.debug(studentMap);
			//Get All Student Programs and Sort them By Programs
			Map<ID, StudentProgram__c> agreementMap = new Map<ID, StudentProgram__c>([SELECT id,
																							 Student__c,
																							 Program__c,
																							 Status__c,
																							 FundingAmountPostCertification__c
																					  FROM StudentProgram__c
																					  Where Student__c in : studentMap.keySet()]);
			if(debug) System.debug(agreementMap);

			Map<ID, Map<ID, List<StudentProgram__c>>> studentProgramsByProgramByStudent = new Map<ID, Map<ID,List<StudentProgram__c>>>();

			for(StudentProgram__c agreement : agreementMap.values()){
				if(!StudentProgramTriggerHandler.cumulativeIncomeStatusExclusions.contains(agreement.Status__c)){


					if(!studentProgramsByProgramByStudent.containsKey(agreement.Student__c)){
						studentProgramsByProgramByStudent.put(agreement.Student__c, new Map<ID, List<StudentProgram__c>>());
					}
					if(!studentProgramsByProgramByStudent.get(agreement.Student__c).containsKey(agreement.Program__c)){
						studentProgramsByProgramByStudent.get(agreement.Student__c).put(agreement.Program__c, new List<StudentProgram__c>());
					}
					studentProgramsByProgramByStudent.get(agreement.Student__c).get(agreement.Program__c).add(agreement);
				}
			}
			if(debug) System.debug(studentProgramsByProgramByStudent);


			for(Account student : students){
				if(debug) System.debug(student);
				if(studentProgramsByProgramByStudent.containsKey(student.id)){
					for(ID programID : studentProgramsByProgramByStudent.get(student.id).keySet()){
						//Get the program terms for this student and this program
						if(debug) System.debug(programID);
						if(debug) System.debug(student.SchoolProgramOfStudy__pc);
						if(debug) System.debug(student.PrimarySchoolGradeLevel__pc);
						if(student.SchoolProgramOfStudy__pc != null && student.PrimarySchoolGradeLevel__pc != null){
							ContractTermsService.ContractTerm ct = ContractTermsService.getContractTermsWithCriteria(programId, student.SchoolProgramOfStudy__pc, student.PrimarySchoolGradeLevel__pc);
							if(debug) System.debug(ct);
							if(debug) System.debug('Maximum Funding Amount:'+ct.maximumFundingAmount);

							Decimal cumulativeFunding = 0;
							for(StudentProgram__c agreement : studentProgramsByProgramByStudent.get(student.id).get(programID)){
								if(debug) System.debug(agreement);
								cumulativeFunding += (agreement.FundingAmountPostCertification__c == null ? 0 : agreement.FundingAmountPostCertification__c);

							}
							if(debug) System.debug('Cumulative Funding:'+cumulativeFunding);
							if(cumulativeFunding > ct.maximumFundingAmount){
								String error = '***Overfunded Account:'+student.id+ ' with Program:'+programID+' (maximumFundingAmount='+ct.maximumFundingAmount+') and Cumulative Funding of '+cumulativeFunding;
								System.debug(error);
								acctsToUpdate.add(new Account(id = student.id,
															  Error__c = error));

							}
						}
					}
				}
			}
		}
		if (acctsToUpdate.size()>0) {
			if(debug) System.debug('acctsToUpdate:'+acctsToUpdate);
			update acctsToUpdate;			
		}


	}
	
	public void finish(Database.BatchableContext BC) {
		
	}
	
}