@isTest
private class Test_MyClass {
    @isTest(SeeAllData=true)
    private static void TestLocationResponse(){
        // Test data setup        
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
       
        Schema.Location location = [SELECT Id FROM Location WHERE Name = 'Albany' LIMIT 1];

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(
            orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);
             
        Test.startTest();
		List<String> results = MyClass.checkAssignmentLimit();
        Test.stopTest();
        
        System.assertEquals('1312D000000APITQA4', results[0]);        
    }
    
    @isTest(SeeAllData=true)
    private static void TestLocationResponseWith7Orders(){
        // Test data setup      
        Schema.Location location = [SELECT Id FROM Location WHERE Name = 'Albany' LIMIT 1];
        Id orderSummaryId;
        
        for(Integer i = 0; i<7;i++){  
            String orderId = SOM_TestDataFactory.createOrderAction();   
            orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
            
            FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(
                orderSummaryId, location.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
            fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
            SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);
        }
              
        Test.startTest();
		List<String> results = MyClass.checkAssignmentLimit();
        Test.stopTest();
        
        System.assertEquals('1312D000000APIYQA4', results[0]);        
    }
}