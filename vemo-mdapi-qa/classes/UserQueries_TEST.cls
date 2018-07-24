/////////////////////////////////////////////////////////////////////////
// Class: UserQueries_TEST
// 
// Description: 
// 
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2016-12-13   Greg Cook       Created                                 
// 
/////////////////////////////////////////////////////////////////////////
@isTest
public with sharing class UserQueries_TEST {
	@TestSetup static void setupData(){
        TestUtil.createStandardTestConditions();
    }
	@isTest public static void validateGetUserMapByID() {
		UserQueries.getUserMapByID(); 
	}
}