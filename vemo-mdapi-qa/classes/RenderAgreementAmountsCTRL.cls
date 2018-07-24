/////////////////////////////////////////////////////////////////////////
// Class: RenderAgreementAmountsCTRL
// 
// Description: 
// 	Controller for RenderAgreementAmountsComponent
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-06-16   Jared Hagemann  Created              
/////////////////////////////////////////////////////////////////////////
public with sharing class RenderAgreementAmountsCTRL {
	public AgreementService.Agreement agreement {get;set;}
	public RenderAgreementAmountsCTRL() {
		Id agreementID = (Id)ApexPages.currentPage().getParameters().get('id');
		List<AgreementService.Agreement> agreements = AgreementService.getAgreementWithAgreementID(new Set<Id>{agreementID});
		AgreementService.determineAmountsDue(agreements);
		agreement = agreements.get(0);
	}
}