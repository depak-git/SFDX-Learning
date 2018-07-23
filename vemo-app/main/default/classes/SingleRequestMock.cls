/////////////////////////////////////////////////////////////////////////
// Class: SingleRequestMock
// 
// Description: 
//  Generic response for testing HTTP Callouts
// 	Courtesy of https://developer.salesforce.com/blogs/developer-relations/2013/03/testing-apex-callouts-using-httpcalloutmock.html
//
// Version Log
// DATE---------AUTHOR----------DESCRIPTION-----------------------------
// 2017-05-28  Jared Hagemann  Created 
/////////////////////////////////////////////////////////////////////////
@isTest
public class SingleRequestMock implements HttpCalloutMock {
		protected Integer code;
		protected String status;
		protected String bodyAsString;
		protected Blob bodyAsBlob;
		protected Map<String, String> responseHeaders;

		public SingleRequestMock(Integer code, String status, String body,
                                         Map<String, String> responseHeaders) {
			this.code = code;
			this.status = status;
			this.bodyAsString = body;
			this.bodyAsBlob = null;
			this.responseHeaders = responseHeaders;
		}

		public SingleRequestMock(Integer code, String status, Blob body,
                                         Map<String, String> responseHeaders) {
			this.code = code;
			this.status = status;
			this.bodyAsBlob = body;
			this.bodyAsString = null;
			this.responseHeaders = responseHeaders;
		}

	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse resp = new HttpResponse();
			resp.setStatusCode(code);
			resp.setStatus(status);
			if (bodyAsBlob != null) {
				resp.setBodyAsBlob(bodyAsBlob);
			} else {
				resp.setBody(bodyAsString);
			}

			if (responseHeaders != null) {
			     for (String key : responseHeaders.keySet()) {
				resp.setHeader(key, responseHeaders.get(key));
			     }
			}
			return resp;
	    }
}