/*************************************************************
 Class Name:API_SendEmailViaNPS
 Description: Apex Class with invocable method (from Flow: Flow Name) to send customer information to
			  external NPS system and trigger email.
 Created By: Riyanka Bandyopadhyay
 Created Date: October 1, 2023
************************************************************/
public with sharing class API_SendEmailViaNPS {
	@InvocableMethod(label='Send Email' description='send customer email via API call' callout='true')
    public static List<String> sendEmail(List <Id> orderIdList){
        List<Order> orderList=[SELECT Id, BillToContact.Email, OrderNumber
                               FROM Order
                               WHERE Id IN :orderIdList
                               AND BillToContact.Email!=NULL];
        String sfId;
        String orderNumber;
        String customerEmail;       
        Map<String,Object> jsonMap=new Map<String,Object>();
        String jsonObj;
        for(Order orderRec:orderList){
            jsonMap.put('sfId',orderRec.Id);
            jsonMap.put('orderNumber',orderRec.OrderNumber);
            jsonMap.put('customerEmail',orderRec.BillToContact.Email);
		}
        String jsonRequest=JSON.serialize(jsonMap);
        jsonRequest='['+jsonRequest+']';           
        String authHeader = 'Basic dG1vbmRvOk5veTg0TFJwWXZNWnVFVEI';
        String contentType = 'application/json';
        String reqBody=jsonRequest;
        HttpRequest req = new HttpRequest();
        Http http = new Http();                     
        req.setEndpoint('callout:NPS');
        req.setHeader('Authorization', authHeader);
        req.setHeader('Content-Type', contentType);   
        req.setMethod('POST');
        req.setBody(reqBody);            
        HttpResponse res = new HttpResponse();   
        res = http.send(req);
        Integer npsResponseCode=res.getStatusCode();
        List<String> npsResponseBody=new List<String>();
        npsResponseBody.add(res.getBody());
        return npsResponseBody;       
     
    }
}