/////////////////////////////////////////////////////////////////////////
// Class: VemoAPIContractTermsResource
// 
// Description: 
// 	Direction Central for Contract Terms API
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-04-25   Greg Cook       Created                          
/////////////////////////////////////////////////////////////////////////
public with sharing class VemoAPIContractTermsResource implements VemoAPI.ResourceHandler{
	public static Object handleAPI(VemoAPI.APIInfo api){
		if((api.version == 'v1') && (api.method == 'GET')){
			return handleGetV1(api);
		}
		if((api.version == 'v1') && (api.method == 'POST')){
			//todo return handlePostV1(api);
		}
		if((api.version == 'v1') && (api.method == 'PUT')){
			//todo return handlePutV1(api);
		}	
		if((api.version == 'v1') && (api.method == 'DELETE')){
			//todo return handleDeleteV1(api);
		}			
		throw new VemoAPI.VemoAPIFaultException('Not a supported method ('+api.method+') for resource: '+api.resource +' and version: '+ api.version);
		return null;
	}

	public static VemoAPI.ResultResponse handleGetV1(VemoAPI.APIInfo api){
		System.debug('VemoAPIContractTermsResource.handleGetV1()');

		
		String programIDparam = api.params.get('programID');

		String gradeLevelParam = api.params.get('gradeLevel');
		String schoolProgramOfStudyIDParam = api.params.get('schoolProgramOfStudyID');
system.debug('programID:'+programIDParam);
system.debug('gradeLevel:'+gradeLevelParam);
system.debug('major:'+schoolProgramOfStudyIDParam);
		Boolean withCriteriaMode = false;
		if(gradeLevelParam == null &&
		   schoolProgramOfStudyIDParam == null &&
		   programIDParam != null){
			withCriteriaMode = false;
		} else {
			withCriteriaMode = true;
		}

		List<ContractTermResourceOutputV1> results = new List<ContractTermResourceOutputV1>();
		if(withCriteriaMode){
			ContractTermsService.ContractTerm term = ContractTermsService.getContractTermsWithCriteria(programIDparam, 
																									   schoolProgramOfStudyIDParam,
																									   gradeLevelParam);
			results.add(new ContractTermResourceOutputV1(term));

		} else {
			Map<ID, Account> studentMap = AccountQueries.getStudentMapWithStudentID(VemoApi.parseParameterIntoIDSet(api.studentPersonAccountID));
			Map<ID, List<ContractTermsService.ContractTerm>> termMapByStudentID = ContractTermsService.getContractTermsByStudentIDWithStudentMap((ID)programIDparam, studentMap);
			//system.debug('termMapByStudentID:'+termMapByStudentID);

			if(termMapByStudentID.size()>0 && termMapByStudentID.containsKey(api.studentPersonAccountID)){
				for(ContractTermsService.ContractTerm term : termMapByStudentID.get(api.studentPersonAccountID)){
					results.add(new ContractTermResourceOutputV1(term));
				}			
			}			
		}



		return (new VemoAPI.ResultResponse(results, results.size()));
	}

/*
	public static OfferService.Offer offerResourceV1toOffer(OfferResourceInputV1 offerRes){
		OfferService.Offer offer = new OfferService.Offer();
		offer.programID = offerRes.programID;
		offer.programName = offerRes.programName;
		offer.schoolID = offerRes.schoolID;
		offer.programStatus = offerRes.programStatus;
		offer.agreementStatus = offerRes.agreementStatus;
		offer.studentID = offerRes.studentID;
		offer.agreementID = offerRes.agreementID;
		offer.enrollmentEndDate = offerRes.enrollmentEndDate;
		return offer;
	}

	public class OfferResourceInputV1{
		public String programID {get;set;}
		public String programName {get;set;}
		public String schoolID {get;set;}
		public String programStatus {get;set;}
		public String agreementStatus {get;set;}
		public String studentID {get;set;}
		public String agreementID {get;set;}
		public Date enrollmentEndDate {get;set;}
	}
*/
	public class ContractTermResourceOutputV1{
		public ContractTermResourceOutputV1(Boolean testValues){
			if(testValues){
				//todo

			}
		}
		public ContractTermResourceOutputV1(ContractTermsService.ContractTerm term){
			//this.contractTermID = term.contractTermID;
			this.minimumFundingAmount = term.minimumFundingAmount;
			this.maximumFundingAmount = term.maximumFundingAmount;
			//this.medianStartingSalary = term.MedianStartingSalary__c;
			this.incomeShare = term.incomeShare;
			this.paymentTerm = term.paymentTerm;
			this.adjustmentMethod = term.adjustmentMethod;
			this.paymentCapFactor = term.paymentCapFactor;
			this.programID = term.programID;				
			//this.gradeLevel = term.gradeLevel;
			//this.proportion = term.proportion;
			//this.earningsGroup = term.earningsGroup;
		}
		//public String contractTermID {get;set;}
		public String programID {get;set;}
		public Decimal minimumFundingAmount {get;set;}
		public Decimal maximumFundingAmount {get;set;}
		//public Decimal medianStartingSalary {get;set;}
		public Decimal incomeShare {get;set;}
		public Decimal paymentTerm {get;set;}
		public String adjustmentMethod {get;set;}
		public Decimal paymentCapFactor {get;set;}
		//public String gradeLevel {get;set;}
		//public Decimal proportion {get;set;}
		//public String earningsGroup {get;set;}

	}
	
}