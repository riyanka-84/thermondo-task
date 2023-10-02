/*************************************************************
 Class Name:MockHttpResponse
 Description: Mock class for generating mock response for API callout in API_SendEmailViaNPS apex class 
 Created By: Riyanka Bandyopadhyay
 Created Date: October 1, 2023
************************************************************/
public class MockHttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200); 
        res.setBody('SUCCESS'); 
        
        return res;
    }
}