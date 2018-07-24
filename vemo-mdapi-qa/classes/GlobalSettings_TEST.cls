/////////////////////////////////////////////////////////////////////////
// Class: GlobalSettings_TEST
// 
// Description: 
//  Unit test for GlobalSettings
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-28  Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class GlobalSettings_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }

    static testMethod void testGetSettings(){
    	Test.startTest();
    	GlobalSettings settings = GlobalSettings.getSettings();    	
    	Test.stopTest();
    }
}