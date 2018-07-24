public class SandboxSetupMaskData implements Database.Batchable<sObject>, Database.Stateful {
    
    public String query;
    public String sObj = 'Contact';
    public Integer contactCount = 0;

    public SandboxSetupMaskData() {
        
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        if(sObj == 'Contact'){
            query = 'SELECT id, FirstName, LastName, AuthSystemUserID__c, SSNTaxID__c, Birthdate, PrimarySchoolEmail__c, DriversLicenseOrStateID__c, Email, Phone, HomePhone, MobilePhone, OtherPhone,  MailingStreet, MailingCity, MailingState, MailingPostalCode, OtherStreet, OtherCity, OtherState, OtherPostalCode from Contact';

        } else if(sObj == 'StudentProgram__c'){
            query = 'SELECT id, Birthdate__c, BirthdateCertification__c, BirthdatePostCertification__c, BirthdatePreCertification__c, BirthdateStudent__c, StudentEmail__c, CertificationComments__c from StudentProgram__c';

        } else if(sObj == 'Case'){
            query = 'SELECT id from Case';

        } else if(sObj == 'StudentProgramAudit__c'){
            query = 'SELECT id from StudentProgramAudit__c';

        } else if(sObj == 'Task'){
            query = 'SELECT id from Task';

        } else if(sObj == 'CreditCheck__c'){
            query = 'SELECT id, ConsentIPAddress__c, JSONPayload__c, CreditCheckDeniedReasonText__c from CreditCheck__c';

        } else if(sObj == 'Notification__c'){
            query = 'SELECT id from Notification__c';

        } else if(sObj == 'Bill__c'){
            query = 'SELECT id, Name__c, StatementData__c, Email__c from Bill__c';

        } else if(sObj == 'Transaction__c'){
            query = 'SELECT id, NotificationEmail__c from Transaction__c';

        } else if(sObj == 'Attachment'){
            query = 'SELECT id from Attachment';

        } else if(sObj == 'StewardshipACHBatchDetail__c'){
            query = 'SELECT id from StewardshipACHBatchDetail__c';

        } else if(sObj == 'StewardshipACHBatch__c'){
            query = 'SELECT id from StewardshipACHBatch__c';

        } else if(sObj == 'OutboundEmail__c'){
            query = 'SELECT id from OutboundEmail__c';

        }  else if(sObj == 'Account'){
            query = 'SELECT id, StewardshipDisbursementDonorGUID__c, StewardshipPaymentDonorGUID__c from Account';

        }   else if(sObj == 'PaymentMethod__c'){
            query = 'SELECT id, BankRoutingNumber__c, BankAccountNumber__c, BankName__c, CreditCardNumber__c, Description__c, StewardshipDisbursementAccountGUID__c, StewardshipPaymentAccountGUID__c from PaymentMethod__c';

        } 
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        if(sObj == 'Contact'){
            contactCount++;
            for(Contact cont : (List<Contact>)(scope)){
                System.debug('cont:'+cont);
                cont.FirstName = 'Masked';
                cont.LastName = 'Contact'+contactCount;
                if(String.isNotEmpty(cont.SSNTaxID__c)) cont.SSNTaxID__c = '123-45-6789';
                if(String.isNotEmpty(cont.MailingStreet)) cont.MailingStreet = '123 Main Street';
                if(String.isNotEmpty(cont.MailingPostalCode)) cont.MailingPostalCode = '98765-4321';
                if(String.isNotEmpty(cont.OtherStreet)) cont.OtherStreet = '12345 Secondary Street';
                if(String.isNotEmpty(cont.OtherPostalCode)) cont.OtherPostalCode = '11223';
                if(String.isNotEmpty(cont.Phone)) cont.Phone = '(555) 123-4567';
                if(String.isNotEmpty(cont.MobilePhone)) cont.MobilePhone = '(555) 123-4567';
                if(String.isNotEmpty(cont.OtherPhone)) cont.OtherPhone = '(555) 123-4567';
                if(String.isNotEmpty(cont.HomePhone)) cont.HomePhone = '(555) 123-4567';            
                if(String.isNotEmpty(cont.Email)) cont.Email = 'masked.email@vemo.com';
                if(String.isNotEmpty(cont.AuthSystemUserID__c)) cont.AuthSystemUserID__c = 'auth|'+cont.id;
                if(cont.Birthdate != null) cont.Birthdate = Date.newInstance(2000, 1, 1);

            }               

            update scope;

        } else if(sObj == 'StudentProgram__c'){
            for(StudentProgram__c agreement : (List<StudentProgram__c>) (scope)){
                System.debug('agreement:'+agreement);
                if(String.isNotEmpty(agreement.StudentEmail__c)) agreement.StudentEmail__c = 'masked.email@vemo.com';
                if(agreement.Birthdate__c != null) agreement.Birthdate__c = Date.newInstance(2000, 1, 1);
                if(agreement.BirthdateCertification__c != null) agreement.BirthdateCertification__c = Date.newInstance(2000, 1, 1);
                if(agreement.BirthdatePostCertification__c != null) agreement.BirthdatePostCertification__c = Date.newInstance(2000, 1, 1);
                if(agreement.BirthdatePreCertification__c != null) agreement.BirthdatePreCertification__c = Date.newInstance(2000, 1, 1);
                if(agreement.BirthdateStudent__c != null) agreement.BirthdateStudent__c = Date.newInstance(2000, 1, 1);
                agreement.CertificationComments__c = '';
            }               
 
            update scope;
        } else if(sObj == 'Case'){
            delete scope;        
        } else if(sObj == 'StudentProgramAudit__c'){
            delete scope;        
        } else if(sObj == 'Task'){
            delete scope;        
        } else if(sObj == 'CreditCheck__c'){
            for(CreditCheck__c cc : (List<CreditCheck__c>) (scope)){
                cc.ConsentIPAddress__c = '';
                cc.JSONPayload__c = '';
                cc.CreditCheckDeniedReasonText__c = '';  
            }     
            update scope;
        } else if(sObj == 'Notification__c'){
            delete scope;        
        } else if(sObj == 'Bill__c'){
            for(Bill__c bill : (List<Bill__c>) (scope)){
                bill.Email__c = 'maked.email@vemo.com';
                bill.StatementData__c = '';
                bill.Name__c = 'maked name';
            }     
            update scope;
        } else if(sObj == 'Transaction__c'){
            for(Transaction__c tx : (List<Transaction__c>) (scope)){
                tx.NotificationEmail__c = 'maked.email@vemo.com';
            }     
            update scope;       
        } else if(sObj == 'Attachment'){  
            delete scope;       
        } else if(sObj == 'StewardshipACHBatchDetail__c'){  
            delete scope;       
        } else if(sObj == 'StewardshipACHBatch__c'){  
            delete scope;       
        } else if(sObj == 'Note'){  
            delete scope;       
        } else if(sObj == 'OutboundEmail__c'){  
            delete scope;       
        } else if(sObj == 'Account'){
            for(Account acct : (List<Account>) (scope)){
                acct.StewardshipDisbursementDonorGUID__c = '';
                acct.StewardshipPaymentDonorGUID__c = '';
            }     
            update scope;
        } else if(sObj == 'PaymentMethod__c'){
            for(PaymentMethod__c pay : (List<PaymentMethod__c>) (scope)){
                pay.BankAccountNumber__c = '123456789';
                pay.BankName__c = 'Bank Name';
                pay.BankRoutingNumber__c = '123456789';
                pay.CreditCardNumber__c = '';
                pay.Description__c = '';
                pay.StewardshipDisbursementAccountGUID__c = '';
                pay.StewardshipPaymentAccountGUID__c = '';
            }     
            update scope;
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        if(sObj == 'Contact'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'StudentProgram__c';
            //Database.executeBatch(job);
        } else if(sObj == 'StudentProgram__c'){
             SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'Case';
            Database.executeBatch(job);
        } else if(sObj == 'Case'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'StudentProgramAudit__c';
            Database.executeBatch(job);
        } else if(sObj == 'StudentProgramAudit__c'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'Task';
            Database.executeBatch(job);
        } else if(sObj == 'Task'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'CreditCheck__c';
            Database.executeBatch(job);
        } else if(sObj == 'CreditCheck__c'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'Notification__c';
            Database.executeBatch(job);
        } else if(sObj == 'Notification__c'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'Bill__c';
            Database.executeBatch(job);
        } else if(sObj == 'Bill__c'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'Transaction__c';
            Database.executeBatch(job);
        } else if(sObj == 'Transaction__c'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'Attachment';
            Database.executeBatch(job);
        } else if(sObj == 'Attachment'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'StewardshipACHBatchDetail__c';
            Database.executeBatch(job);
        } else if(sObj == 'StewardshipACHBatchDetail__c'){
             SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'StewardshipACHBatch__c';
            Database.executeBatch(job);
        } else if(sObj == 'StewardshipACHBatch__c'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'OutboundEmail__c';
            Database.executeBatch(job);
        } else if(sObj == 'OutboundEmail__c'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'Account';
            Database.executeBatch(job);
        } else if(sObj == 'Account'){
            SandboxSetupMaskData job = new SandboxSetupMaskData();
            job.sObj = 'PaymentMethod__c';
            Database.executeBatch(job);
        }  
        
    }
    
}