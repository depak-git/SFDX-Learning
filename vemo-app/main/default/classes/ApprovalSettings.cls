public with sharing class ApprovalSettings {
    public static void createApprovalSettings(){

        List<ApprovalSettings__c> settings = new List<ApprovalSettings__c>();
        
        //Organizational Settings
        settings.add(new ApprovalSettings__c(SetupOwnerID = UserInfo.getOrganizationID(),
                                             AccountNameChangeAllowed__c = false,
                                             BypassTransactionFreeze__c = false));
        //User Settings
        settings.add(new ApprovalSettings__c(SetupOwnerID = UserInfo.getUserID(),
                                              AccountNameChangeAllowed__c = true,
                                              BypassTransactionFreeze__c = true));       
        
        insert settings;
    }
}
