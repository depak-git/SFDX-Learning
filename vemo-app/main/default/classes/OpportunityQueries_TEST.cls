/////////////////////////////////////////////////////////////////////////
// Class: OpportunityQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class OpportunityQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
        TestDataFactory.createAndInsertOpportunities(TestUtil.TEST_THROTTLE);
    }
	@isTest public static void validateGetOpportunityMapByID() {
		//jared
		Map<ID, Opportunity> OpportunityMap = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(OpportunityMap.size(), TestUtil.TEST_THROTTLE);
	}
}