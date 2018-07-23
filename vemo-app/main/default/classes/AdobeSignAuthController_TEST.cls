@isTest
public class AdobeSignAuthController_TEST {

    public static testMethod void testPage() {
        PageReference pageRef = Page.authorizeAdobe;
        Test.setCurrentPage(pageRef);
      
        AdobeSignAuthController controller = new AdobeSignAuthController();
 

        controller.redirectToAdobe();
		
		Test.setMock(HttpCalloutMock.class, new AdobeSignService_TEST.accessTokenRequestMockPass());
        controller.updateSettings();
    }
}