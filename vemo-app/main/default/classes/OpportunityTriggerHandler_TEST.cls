/////////////////////////////////////////////////////////////////////////
// Class: OpportunityTriggerHandler_TEST
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2015-07-06   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
private class OpportunityTriggerHandler_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateOpportunityCreate
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateOpportunityCreate() {	
		TestUtil.setStandardConfiguration();

		Map<ID, Opportunity> oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),0,'No Opportunity Records Should Exist');
		
		Test.startTest();
		Map<ID, Opportunity> oppMap = TestDataFactory.createAndInsertOpportunities(TestUtil.TEST_THROTTLE);
		Test.stopTest();

		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');
		
	}    
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateOpportunityUpdate
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateOpportunityUpdate() {	
		TestUtil.setStandardConfiguration();

		Map<ID, Opportunity> oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),0,'No Opportunity Records Should Exist');
		

		Map<ID, Opportunity> oppMap = TestDataFactory.createAndInsertOpportunities(TestUtil.TEST_THROTTLE);
		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');

		for(Opportunity opp : oppMap.values()){
			opp.StageName = 'update';
		}
		Test.startTest();
		update oppMap.values();
		Test.stopTest();

		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');
	}   
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateOpportunityDelete
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateOpportunityDelete() {	
		TestUtil.setStandardConfiguration();

		Map<ID, Opportunity> oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),0,'No Opportunity Records Should Exist');
		

		Map<ID, Opportunity> oppMap = TestDataFactory.createAndInsertOpportunities(TestUtil.TEST_THROTTLE);
		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');

		Test.startTest();
		delete oppMap.values();
		Test.stopTest();

		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),0,'No Opportunity Records Should Exist');
	} 
    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateOpportunityUndelete
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateOpportunityUndelete() {	
		TestUtil.setStandardConfiguration();

		Map<ID, Opportunity> oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),0,'No Opportunity Records Should Exist');
		

		Map<ID, Opportunity> oppMap = TestDataFactory.createAndInsertOpportunities(TestUtil.TEST_THROTTLE);
		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');

		delete oppMap.values();
		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),0,'No Opportunity Records Should Exist');		

		Test.startTest();
		undelete oppMap.values();
		Test.stopTest();

		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');


	} 

    /////////////////////////////////////////////////////////////////////////
    //Test Case: validateOpportunityUpdate
    /////////////////////////////////////////////////////////////////////////  	
	@isTest
	static void validateClosedWonTriggersCase() {	
		TestUtil.setStandardConfiguration();

		Map<ID, Opportunity> oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),0,'No Opportunity Records Should Exist');
		

		Map<ID, Opportunity> oppMap = TestDataFactory.createAndInsertOpportunities(TestUtil.TEST_THROTTLE);
		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');

		for(Opportunity opp : oppMap.values()){
			opp.StageName = 'Closed Won';
		}
		Test.startTest();
		update oppMap.values();
		Test.stopTest();

		oppToValidate = OpportunityQueries.getOpportunityMapByID();
		system.assertEquals(oppToValidate.size(),TestUtil.TEST_THROTTLE,'Opportunity Records Should Exist');

		Map<ID, Case> casesToValidate = CaseQueries.getCaseMapByID();
		system.assertEquals(casesToValidate.size(),TestUtil.TEST_THROTTLE,'Case Records Should Exist');
		for(Case cs : casesToValidate.values()){
			system.assertEquals(cs.OwnerID, GlobalUtil.getQueueId(GlobalSettings.getSettings().closedWonCaseQueue), 'Wrong Case Queue Id');
		}	
	}  

}