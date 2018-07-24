/////////////////////////////////////////////////////////////////////////
// Class: ApprovalSettings_TEST
// 
// Description: 
//  Unit test for ApprovalSettings
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2018-04-07   Greg Cook       Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class ApprovalSettings_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    @isTest
    public static void testCreate() {
        Test.startTest();
        ApprovalSettings.createApprovalSettings();
        Test.stopTest();
    }
}
