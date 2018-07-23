public with sharing class SESService {
    
    public static boolean sendEmail(Email m) {
        
        String boundary = 'gc0p4Jq0M2Yt08jU534c0p';
        String boundary2 = 'Yt08jU534c0pgc0p4Jq0M2';
        
        string key = SecureSettings.getValue('SESKey');
        string secret = SecureSettings.getValue('SESSecretKey');
        
        if(secret == null)secret = ' ';
        
        String urlStr = Test.isRunningTest() ? 'https://testendpoint.com ' : SESSettings__c.getInstance().Endpoint__c;
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        
        httpReq.setEndpoint(urlStr);
        
        httpReq.setHeader('myContent-Type','application/x-www-form-urlencoded');
        String awsFormattedNow = awsFormattedDate(Datetime.now());
        httpReq.setHeader('Date',awsFormattedNow);
        httpReq.setHeader('X-Amzn-Authorization', headerForAmazonAuthorization(key,signature(awsFormattedNow,secret)));
        
        String msg = '';
        // header
        //msg += 'From:' + 'Vemo Education <outbound@vemo.com>' + '\n';
        msg += 'From:' + 'Vemo Education <customerservice@vemo.com>' + '\n';
        msg += 'To:' + m.to + '\n';
        if(m.cc != null){
            msg += 'CC:' + m.cc + '\n';
        }
        if(m.bcc != null){
            msg += 'BCC:' + m.bcc + '\n';
        }
        msg += 'Subject:'+ m.subject + '\n';
        msg += 'MIME-Version:1.0\n';
        msg += 'Content-type:multipart/mixed; boundary="' + boundary + '"\n\n';
        
        msg += '--' + boundary + '\n';
        
        msg += 'Content-type:multipart/alternative; boundary="' + boundary2 + '"\n\n';
        
        // text
        if(m.bodyText != null){
            msg += '--' + boundary2 + '\n';
            msg += 'Content-type: text/plain;charset=utf-8\n';
            msg += 'Content-Transfer-Encoding: quoted-printable\n\n';
            msg += m.bodyText;
            msg += '\n\n';
        }
        
        // html
        if(m.bodyHtml != null){
            msg += '--' + boundary2 + '\n';
            msg += 'Content-Type: text/html; charset=utf-8\n\n';
            //msg += 'Content-Transfer-Encoding: 7bit\n\n';
            //msg += 'Content-Transfer-Encoding: quoted-printable\n\n';
            msg += '<!DOCTYPE html><html>'+m.bodyHtml+'</html>';
            msg += '\n\n';
        }
    // attachment
        if(m.attachmentList != null && m.attachmentList.size()>0) {
            for(MailAttachment mAttach : m.attachmentList){
                msg += '\n';
                msg += '--' + boundary + '\n';
                msg += 'Content-Transfer-Encoding: base64\n';
                msg += 'Content-Type: '+ mAttach.contentType +'; name="' + mAttach.name + '";\n';
                msg += 'Content-Disposition: attachment; filename="' + mAttach.name + '";\n\n';
                msg += EncodingUtil.base64Encode(mAttach.body);
                msg += '\n\n--' + boundary;
            }
            msg += '--\n';  // close
        }
        String encodedMessage = EncodingUtil.base64Encode(Blob.valueOf(msg));
        String requestBody = 'Action=SendRawEmail&RawMessage.Data=' + EncodingUtil.urlEncode(encodedMessage, 'UTF-8');
        httpReq.setBody(requestBody);
        Http http = new Http();
        HttpResponse response = http.send(httpReq);
        return response.getStatusCode() == 200;
    }
    
    public class MailAttachment {
        public String name;
        public Blob body;
        public String contentType;
    }
    
    public class Email {
        public String to;
        public String bcc;
        public String cc;
        public String subject;
        public String bodyText;
        public String bodyHtml;
        public List<MailAttachment> attachmentList;
    }
    
    private static string awsFormattedDate(Datetime now)
    {
        return now.formatGmt('EEE, d MMM yyyy HH:mm:ss Z');
    }
    
    private static string headerForAmazonAuthorization(String accessKey, String signature)
    {
        return 'AWS3-HTTPS AWSAccessKeyId='+accessKey+', Algorithm=HmacSHA256, Signature='+signature;
    }
    
    private static string signature(String awsNow, String s) {
        Blob bsig = Crypto.generateMac('HmacSHA256', Blob.valueOf(awsNow), Blob.valueOf(s));
        return EncodingUtil.base64Encode(bsig);
    }
}