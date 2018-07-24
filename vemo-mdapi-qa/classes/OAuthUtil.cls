public with sharing class OAuthUtil {
 	String username;
    String password;
    String clientId;
    String clientSecret;
    String testEndpoint = 'https://test.salesforce.com/services/oauth2/token';
    String prodEndPoint = 'https://login.salesforce.com/services/oauth2/token';
    String tokenEndpoint;

    public OAuthUtil(String endpoint, String username, String password, String clientId, String clientSecret) {
        this.tokenEndpoint = (endpoint == 'test' ? testEndpoint : prodEndPoint);
        this.username = username;
        this.password = password;
        this.clientId = clientId;
        this.clientSecret = clientSecret;

    }

    public String requestAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenEndpoint + '?grant_type=password&client_id=' + clientID + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password);
        req.setMethod('POST');


        Http http = new Http();

        system.debug('req:'+req);
        system.debug('body:'+req.getBody());
        HttpResponse resp = http.send(req);
        system.debug('resp:'+resp);
        system.debug('body'+resp.getBody());

        Map<String, Object> m =
            (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());

        return (String) m.get('access_token');
    }

    @TestVisible static String buildHttpQuery(Map<String, String> queryParams) {
        if (queryParams.isEmpty()) {
            return '';
        }

        String[] params = new String[] {};
        for (String k : queryParams.keySet()) {
            String v = EncodingUtil.urlEncode(queryParams.get(k), 'UTF-8');

            params.add(String.format('{0}={1}', new String[] { k, v }));
        }

        return String.join(params, '&');
    }
}