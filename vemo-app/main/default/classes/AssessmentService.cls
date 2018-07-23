public with sharing class AssessmentService {
    public static void assessContracts(Set<ID> agreementIDs) {
		System.debug('AssessmentService.accountAssessment()');
		Date systemDate = Date.today();//for testing
		//systemDate = Date.newInstance(2018, 4, 16);//for testing

		String systemYear = String.valueOf(systemDate.year());
		String systemMonth = monthToMonthStr(systemDate.month());
		System.debug('systemDate:'+systemDate);

		///////////////////////////////////////////Get Agreement Data///////////////////////////////////////////////
        Map<ID, StudentProgram__c> agreementMap = StudentProgramQueries.getStudentProgramMapWithAgreementID(agreementIDs);
        System.debug('agreementMap:'+agreementMap);


		///////////////////////////////////////////Get Student & Program Data///////////////////////////////////////////////
        Set<ID> studentIDs = new Set<ID>();
		Set<ID> programIDs = new Set<ID>();
        for(StudentProgram__c agreement : agreementMap.values()){
            studentIDs.add(agreement.Student__c);
			programIDs.add(agreement.Program__c);
        }
        Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(studentIDs);
        System.debug('studentMap:'+studentMap);
		Map<ID, Program__c> programMap = ProgramQueries.getProgramMapWithProgramID(programIDs);
		System.debug('programMap:'+programMap);


		///////////////////////////////////////////Get Income Data///////////////////////////////////////////////
        Map<ID, IncomeVerification__c> incVerMap = new Map<ID, IncomeVerification__c>([SELECT Id, MonthlyIncome__c, Student__c, BeginDate__c, EndDate__c, Verified__c, IncomePerMonth__c, Type__c
																						FROM IncomeVerification__c
																						WHERE BeginDate__c < :systemDate
																						AND Student__c IN :studentMap.keySet()
																						AND Status__c = 'Verified'
																						ORDER BY BeginDate__c asc]);

		Map<ID, List<IncomeVerification__c>> incomeByStudent = new Map<ID, List<IncomeVerification__c>>();
		for(IncomeVerification__c income : incVerMap.values()){
			if(!incomeByStudent.containsKey(income.Student__c)){
				incomeByStudent.put(income.Student__c, new List<IncomeVerification__c>());
			}
			incomeByStudent.get(income.Student__c).add(income);
		}
		System.debug('incomeByStudent:'+incomeByStudent);


		////////////////////////////////////////Monthly Tracker Data Structures//////////////////////////////////////
		List<StudentProgramMonthlyStatus__c> monthlyTrackerToAdd = new List<StudentProgramMonthlyStatus__c>();
		Map<Id,StudentProgramMonthlyStatus__c> existingMonthlyTrackers = new Map<ID, StudentProgramMonthlyStatus__c>([SELECT id, Agreement__c, Year__c, Month__c, Activity__c, MonthlyStatusGUID__c, Sequence__c
																													  FROM StudentProgramMonthlyStatus__c
																													  WHERE Agreement__c IN :agreementMap.keySet()
																													  ORDER BY Sequence__c ASC]);
		System.debug('existingMonthlyTrackers:'+existingMonthlyTrackers);

		Map<ID, List<StudentProgramMonthlyStatus__c>> monthlyTrackersByAgreement = new Map<ID, List<StudentProgramMonthlyStatus__c>>();
		for(StudentProgramMonthlyStatus__c tracker : existingMonthlyTrackers.values()){
			if(!monthlyTrackersByAgreement.containsKey(tracker.Agreement__c)){
				monthlyTrackersByAgreement.put(tracker.Agreement__c, new List<StudentProgramMonthlyStatus__c>());
			}
			monthlyTrackersByAgreement.get(tracker.Agreement__c).add(tracker);
		}
		System.debug('monthlyTrackersByAgreement:'+monthlyTrackersByAgreement);


		////////////////////////////////////////Amount Due Data Structures//////////////////////////////////////
		List<StudentProgramAmountDue__c> amountDueToAdd = new List<StudentProgramAmountDue__c>();
		Map<ID, StudentProgramAmountDue__c> existingAmountDue = new Map<ID, StudentProgramAmountDue__c>([SELECT id, Agreement__c, AMount__c, AssessmentDateTime__c, ExcludeFromBalance__c, Type__c, StudentProgramMonthlyStatus__c
																										 FROM StudentProgramAmountDue__c
																										 WHERE Agreement__c IN : agreementMap.keySet()
																										 AND Type__c = 'Monthly Amount'
																										 AND ExcludeFromBalance__c = false]);
		System.debug('existingAmountDue:'+existingAmountDue);
		Map<ID, List<StudentProgramAmountDue__c>> amountDueByAgreement = new Map<ID, List<StudentProgramAmountDue__c>>();
		for(StudentProgramAmountDue__c amountDue : existingAmountDue.values()){
			if(!amountDueByAgreement.containsKey(amountDue.Agreement__c)){
				amountDueByAgreement.put(amountDue.Agreement__c, new List<StudentProgramAmountDue__c>());
			}
			amountDueByAgreement.get(amountDue.Agreement__c).add(amountDue);
		}	

        //////////////////////////////Main Loop////////////////////////////////////////
        Map<ID, List<StudentProgramMonthlyStatus__c>> trackersMissingByAgreement = new Map<ID, List<StudentProgramMonthlyStatus__c>>();
		Integer assessUntilSeq = Integer.valueOf(String.valueOf(systemDate.year()) + monthIntToMonthSeq(systemDate.month()));
		List<Case> casesToAdd = new List<Case>();


		System.debug('....assessUntilSeq'+assessUntilSeq);
		for(StudentProgram__c agreement : agreementMap.values()){
			System.debug('....Main Loop on Agreement:'+agreement);
			Integer ssYear = agreement.ServicingStartDate__c.year();
			String ssYearStr = String.valueOf(ssYear);
			Integer ssMonth = agreement.ServicingStartDate__c.month();
			String ssMonthStr = monthIntToMonthSeq(ssMonth);
			System.debug('....ssMonthStr:'+ssMonthStr);
			Integer ssSequence = Integer.valueOf(ssYearStr + ssMonthStr);
			System.debug('....ssSequence:'+ssSequence);

			if(!trackersMissingByAgreement.containsKey(agreement.id)){
				trackersMissingByAgreement.put(agreement.id, new List<StudentProgramMonthlyStatus__c>());
			}
            Set<String> validStatus = new Set<String>{'Payment', 'Internship'};
            if((agreement.Servicing__c = true) && validStatus.contains(agreement.Status__c)){

                //Loop Through The Monthly Tracker for this agreement.  Assess any months that do not have Monthly Trackers from the date of servicing through the current month
				Integer i = 0;
				Integer expectedTracker = 0;
				Set<Integer> dontAssess = new Set<Integer>();
				if(monthlyTrackersByAgreement.containsKey(agreement.id)){
					for(StudentProgramMonthlyStatus__c monthlyTracker : monthlyTrackersByAgreement.get(agreement.id)){
						System.debug('....monthlyTracker:'+monthlyTracker);
						dontAssess.add((Integer)monthlyTracker.Sequence__c);
						if(i == 0){
							//monthly tracker should equal start of servicing
							System.debug('....servicingStartDate:'+agreement.ServicingStartDate__c);
							if(ssSequence == monthlyTracker.Sequence__c ){
								system.debug('....expected first tracker');
							} else if(ssSequence > monthlyTracker.Sequence__c ){
								system.debug('....first tracker is earlier than expected');
							} else if(ssSequence < monthlyTracker.Sequence__c ){
								system.debug('....first tracker is later than expected');
							}
						}
						i++;
					}					
				} else {
					//first tracker does not exist
					System.debug('....no monthly trackers exist for this agreement being assessed');
				}
				//Loop from servicing start to assessmentThrough					
				Integer assessingSeq = ssSequence;
				while(assessingSeq <= assessUntilSeq){
					System.debug('....assessingSeqBefore:'+assessingSeq);
			 		String guid = agreement.id + ':' + assessingSeq;					
					if(!dontAssess.contains(assessingSeq)){
						System.debug('....Assess this sequence:'+assessingSeq);

						DateTime assessmentDateTime;
						if(assessingSeq == assessUntilSeq){
							//current month
							assessmentDateTime = systemDate;
						} else {
							assessmentDateTime = Datetime.newInstance(Integer.valueOf(sequenceToYearStr(assessingSeq)),
																	  sequenceToMonthInt(assessingSeq), 
																	  (Integer)agreement.AssessmentDayOfMonth__c);
						}
						System.debug('....assessmentDateTime:'+assessmentDateTime);


						StudentProgramMonthlyStatus__c monthlyStatus = new StudentProgramMonthlyStatus__c(Agreement__c = agreement.id,
																											Activity__c = 'Payment',
																											Month__c = sequenceToMonthStr(assessingSeq),
																											Year__c = sequenceToYearStr(assessingSeq),
																											MonthlyStatusGUID__c = guid);

						//insert the monthly status upon successful income calculation



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
						IncomeVerification__c incomeToUse;
						//Loop through the income objects for the student based upon the following criteria
						//Begin Date <= first day of the month being assessed
						
						//If the assessor job is calculating amount due for May 2018, Income Verification objects with Begin Date of May 1, 2018 or earlier can be considered.
						//Any Income Verification object with a Begin Date of May 2, 2018 or later should not be considered.
						
						//There will often be more than one Income Verification object with a Begin Date earlier than the month in question. 
						//In these scenarios, the Income Verification object with a Begin Date closest to the assessment month should be used.
						Boolean incomeClear = true;
						try{
							for(IncomeVerification__c income : incomeByStudent.get(agreement.Student__c)){
								System.debug('....income:'+income);
								Date incomeConsiderationDate = Date.newInstance(assessmentDateTime.year(), assessmentDateTime.month(), 1);
								System.debug('....incomeConsiderationDate:'+incomeConsiderationDate);
								if(income.BeginDate__c <= incomeConsiderationDate){
									//can be considered
									System.debug('....can be considered based on date');
									if(incomeToUse == null){
										incomeToUse = income;	
										incomeClear = true;								
									} else {
										if(incomeToUse.BeginDate__c == income.BeginDate__c){
											System.debug('....both incomes have same date');
											if(incomeToUse.Type__c == 'Estimated' && income.Type__c == 'Reported'){
												System.debug('....use the reported');
												incomeToUse = income;
												incomeClear = true;
											} else if (incomeToUse.Type__c == income.Type__c){
												System.debug('....unclear based on same begin date/same type');
												incomeToUse = null;
												incomeClear = false;
											} else {
												System.debug('....do not change to the new income');
											}
										} else if(incomeToUse.BeginDate__c <= income.BeginDate__c){
											System.debug('....use the new income');
											incomeToUse = income;
											incomeClear = true;
										} else {
											System.debug('....do not change to this income');
										}
									}

								} else {
									//cannot be considered
									System.debug('....cannot be considered based on date');
								}
							}
							if(incomeToUse == null){
								System.debug('....unclear based on not finding anything valid for the assessment month');
								incomeClear = false;
							} else {
								System.debug('....clear income selected:'+incomeToUse);
								incomeClear = true;
							}

					
						} catch (Exception e){
							incomeToUse = null;
							incomeClear = false;

						}
						if(incomeClear){
							trackersMissingByAgreement.get(agreement.id).add(monthlyStatus);
							Decimal incomeAmount = incomeToUse.IncomePerMonth__c;

							if(incomeAmount>=programMap.get(agreement.Program__c).MinimumIncomePerMonth__c){

								//Assuming they are over the income threshold, add the monthly amount due
								Decimal amount = 0;
								try{
									amount = (incomeAmount * (agreement.IncomeSharePostCertification__c == null ? 0 :agreement.IncomeSharePostCertification__c)/100);							
								} catch (Exception e){
									System.debug('error calculating amount');
								}
								StudentProgramMonthlyStatus__c relatedMonthlyStatus= new StudentProgramMonthlyStatus__c(MonthlyStatusGUID__c = guid);

								amountDueToAdd.add(new StudentProgramAmountDue__c(Agreement__c = agreement.id,
																				Type__c = 'Monthly Amount',
																				AssessmentDateTime__c = assessmentDateTime,
																				Amount__c = amount,
																				ExcludeFromBalance__c = false,
																				StudentProgramMonthlyStatus__r = relatedMonthlyStatus,
																				IncomeShare__c = agreement.IncomeSharePostCertification__c,
																				IncomeVerification__c = incomeToUse.id));

							} else {
								//Open a case for servicing - not over minimum threshold
								casesToAdd.add(new Case(AccountID=agreement.Student__c,
														ContactID=studentMap.get(agreement.Student__c).PersonContactID,
														Status = 'New',
														Subject = 'Assessment Determined Income Under Minimum Threshold:'+assessingSeq,
														Type = 'Problem',
														Priority = 'Medium',
														Origin= 'System',
														Agreement__c = agreement.id));
							}
				
						} else {
							//enter a case - income not clear
							System.debug('....enter a case for servicing');		
							casesToAdd.add(new Case(AccountID=agreement.Student__c,
													ContactID=studentMap.get(agreement.Student__c).PersonContactID,
													Status = 'New',
													Subject = 'Assessment Determined Unclear Income for Assessment Month:'+assessingSeq,
													Type = 'Problem',
													Priority = 'Medium',
													Origin= 'System',
													Agreement__c = agreement.id));													
						}

					} else {
						System.debug('....Dont assess:'+assessingSeq);
					}	
					assessingSeq = determineNextSequence(assessingSeq);		
					System.debug('....assessingSeqAfter:'+assessingSeq);
				}         
            
                //////////////////////////////Update Assessment Date////////////////////////////////////////

                System.debug('agreement.AssessmentDate__c:'+agreement.AssessmentDate__c);
                System.debug('agreement.AssessmentDayOfMonth__c:'+agreement.AssessmentDayOfMonth__c);
                Boolean advanceAssessmentDate = false; 
                if(agreement.AssessmentDate__c <= systemDate || agreement.AssessmentDate__c == null) advanceAssessmentDate = true;
                if(advanceAssessmentDate){
                    System.debug('advanceAssessmentDate');
                    Integer nextAssessmentYear = systemDate.year();
                    Integer nextAssessmentMonth = systemDate.month();
                    if(agreement.AssessmentDayOfMonth__c < systemDate.day()){
                        //Advance the month
                        nextAssessmentYear = (systemDate.month() == 12) ? systemDate.year() + 1 : systemDate.year();
                        nextAssessmentMonth = (systemDate.month() == 12) ? 1 : systemDate.month() + 1;					
                    }

                    Integer nextAssessmentDay = Integer.valueOf(agreement.AssessmentDayOfMonth__c);
                    agreement.AssessmentDate__c = Date.newInstance(nextAssessmentYear, nextAssessmentMonth, nextAssessmentDay);		

                    System.debug('Set agreement.AssessmentDate__c:'+agreement.AssessmentDate__c);		
                }
                //////////////////////////////Update Due Date if the date is in the past AND the balance is zero////////////////////////////////////////
                Boolean advanceDueDate = false; 
                if((agreement.NextPaymentDueDate__c <= systemDate || agreement.NextPaymentDueDate__c == null) && 
                (agreement.NextPaymentDue__c <= 0)){
                    advanceDueDate = false; //for now
                }
                if(advanceDueDate){
                    Integer nextDueDateYear = systemDate.year();
                    Integer nextDueDateMonth = systemDate.month();
                    if(studentMap.get(agreement.Student__c).DueDayOfTheMonth__c < systemDate.day()){
                        //Advance the month
                        nextDueDateYear = (systemDate.month() == 12) ? systemDate.year() + 1 : systemDate.year();
                        nextDueDateMonth = (systemDate.month() == 12) ? 1 : systemDate.month() + 1;
                    }
                    Integer nextDueDateDay = Integer.valueOf(studentMap.get(agreement.Student__c).DueDayOfTheMonth__c);
                    agreement.NextPaymentDueDate__c = Date.newInstance(nextDueDateYear, nextDueDateMonth, nextDueDateDay);				
                }
                agreement.AssessContract__c = false;

            }


			//Add All Trackers
			monthlyTrackerToAdd.addAll(trackersMissingByAgreement.get(agreement.id));
        }



        if(monthlyTrackerToAdd.size()>0){
			System.debug('insert monthlyTrackers:'+monthlyTrackerToAdd);
            Database.insert(monthlyTrackerToAdd);
        }
        if(amountDueToAdd.size()>0){
			System.debug('insert amountDue:'+amountDueToAdd);
            Database.insert(amountDueToAdd);
        }
        if(casesToAdd.size()>0){
			System.debug('insert cases:'+casesToAdd);
            Database.insert(casesToAdd);
        }
		System.debug('update agreementMap');
        Database.update(agreementMap.values());
        LogService.writeLogs();        

    }

	private static String monthToMonthStr(Integer month){
		System.debug('....month:'+month);
		if(month == 1) return 'January';
		if(month == 2) return 'February';
		if(month == 3) return 'March';
		if(month == 4) return 'April';
		if(month == 5) return 'May';
		if(month == 6) return 'June';
		if(month == 7) return 'July';
		if(month == 8) return 'August';
		if(month == 9) return 'September';
		if(month == 10) return 'October';
		if(month == 11) return 'November';
		if(month == 12) return 'December';
		return '99';
	}
	private static String monthIntToMonthSeq(Integer monthSeq){
		System.debug('....monthSeq:'+monthSeq);
		return (monthSeq < 10 ? (String.valueOf('0' + String.valueOf(monthSeq))) : String.valueOf(monthSeq));
	}
	private static String sequenceToYearStr(Integer seq){
		System.debug('....seq:'+seq);
		String returnVal = String.valueOf(seq).subString(0,4);
		System.debug(returnVal);
		return returnVal;
	}
	private static String sequenceToMonthStr(Integer seq){
		System.debug('....seq:'+seq);
		System.debug(String.valueOf(seq).substring(4,6));
		String returnVal = monthToMonthStr(Integer.valueOf((String.valueOf(seq)).substring(4,6)));
		System.debug(returnVal);
		return returnVal;
	}
	private static Integer sequenceToMonthInt(Integer seq){
		System.debug('....seq:'+seq);
		System.debug(String.valueOf(seq).substring(4,6));
		Integer returnVal = (Integer.valueOf((String.valueOf(seq)).substring(4,6)));
		System.debug(returnVal);
		return returnVal;
	}
	private static Integer determineNextSequence(Integer currentSequence){
		String nextMonthStr;
		String nextYearStr;
		String currentSequenceStr = String.valueOf(currentSequence);
		String currentYearStr = currentSequenceStr.substring(0,4); 
		System.debug('....currentYearStr:'+currentYearStr);
		String currentMonthStr = currentSequenceStr.substring(4, 6);
		System.debug('....currentMonthStr:'+currentMonthStr);
		if(currentMonthStr == '12'){
			nextMonthStr = '01';
			nextYearStr = monthIntToMonthSeq(Integer.valueOf(currentYearStr)+1);
		}else{
			nextMonthStr = monthIntToMonthSeq(Integer.valueOf(currentMonthStr)+1);
			nextYearStr = currentYearStr;
		}
		System.debug('....nextMonthStr:'+nextMonthStr);
		System.debug('....nextYearStr:'+nextYearStr);
		return Integer.valueOf(nextYearStr + nextMonthStr);
	}
}
