@isTest public with sharing class AuthorizeAdobeController_TEST {
	@isTest public static void testAuthorize(){
		PageReference pageRef = Page.authorizeAdobe;
		Test.setCurrentPage(pageRef);

		AuthorizeAdobeController cont = new AuthorizeAdobeController();
		cont.authorizeAdobe();
	}

}