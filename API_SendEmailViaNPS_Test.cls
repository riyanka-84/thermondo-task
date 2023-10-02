/*************************************************************
 Class Name:API_SendEmailViaNPS_Test
 Description: Test class for API_SendEmailViaNPS apex class 
 Created By: Riyanka Bandyopadhyay
 Created Date: October 1, 2023
************************************************************/
@isTest
public class API_SendEmailViaNPS_Test {

    @isTest
    static void testSendEmail() {   
        Account accRec=new Account();
        accRec.Name='Test ABC';
        insert accRec;
        
        Contact contactRec=new Contact();
        contactRec.Email='abc@testemail.com';
        contactRec.LastName='Test';
        insert contactRec;
        
        Contract contractRec=new Contract();
        contractRec.AccountId=accRec.Id;
        contractRec.Status='Draft';
        contractRec.StartDate=System.today();
        contractRec.ContractTerm=12;
        insert contractRec;
        contractRec.Status='Activated';
        update contractRec;
        
        Product2 productRec = new Product2();
        productRec.Name = 'Test Product'; 
        productRec.IsActive = true;         
        insert productRec;           
              
        Pricebook2 standardPB = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPB;
		
        PricebookEntry standardPbe = new PricebookEntry(
            Pricebook2Id = standardPB.Id,
            Product2Id = productRec.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert standardPbe;       
  
        Order orderRec = new Order();  
        orderRec.AccountId=accRec.Id;
        orderRec.BillToContactId = contactRec.Id;
        orderRec.EffectiveDate=System.today();
        orderRec.Status='Draft';
        orderRec.Pricebook2Id=standardPB.Id;
		insert orderRec;            
        
        OrderItem orderItemRec = new OrderItem();
        orderItemRec.OrderId = orderRec.Id; 
        orderItemRec.Product2Id = productRec.Id; 
        orderItemRec.Quantity = 2; 
        orderItemRec.UnitPrice = 100.00;
        orderItemRec.PricebookEntryId=standardPbe.Id;
        insert orderItemRec;
        
        orderRec.Status='Fulfilled';
        update orderRec;
        
        List<Id> orderIdList = new List<Id>();
        orderIdList.add(orderRec.Id);        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());        
        Test.startTest();
        List<String> result = API_SendEmailViaNPS.sendEmail(orderIdList);
        Test.stopTest();        
        System.assertEquals(1, result.size());
        System.assertEquals('SUCCESS', result[0]);
    }
}