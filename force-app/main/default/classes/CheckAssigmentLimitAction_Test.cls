@isTest
private class CheckAssigmentLimitAction_Test {
    @isTest(SeeAllData=true)
    private static void TestLocationResponse(){
        // Test data setup        
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
               
        Schema.Location locationAlbany = new Schema.Location (Name = 'Albany', LocationType = 'Warehouse', Assignment_Limit__c = 5);
        insert locationAlbany;

        FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(
            orderSummaryId, locationAlbany.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);
             
        Test.startTest();
		List<String> results = CheckAssigmentLimitAction.checkAssignmentLimit();
        Test.stopTest();
        
        System.assertEquals(locationAlbany.Id, results[0]);        
    }
    
    @isTest(SeeAllData=true)
    private static void TestLocationResponseWith7Orders(){
        // Test data setup              
        Id orderSummaryId;

        Schema.Location locationAlbany = new Schema.Location (Name = 'Albany', LocationType = 'Warehouse', Assignment_Limit__c = 5);
        insert locationAlbany;

        Schema.Location locationNewJersey = new Schema.Location (Name = 'New Jersey', LocationType = 'Warehouse', Assignment_Limit__c = 5);
        insert locationNewJersey;
        
        for(Integer i = 0; i<7;i++){  
            String orderId = SOM_TestDataFactory.createOrderAction();   
            orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
            
            FulfillmentOrder fulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(
                orderSummaryId, locationAlbany.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
            fulfillmentOrder.Status = SOM_FulfillmentOrderStatus.FULFILLED.enumValue;
            SOM_DatabaseUtil.updateRecords(fulfillmentOrder, true);
        }
              
        Test.startTest();
		List<String> results = CheckAssigmentLimitAction.checkAssignmentLimit();
        Test.stopTest();
        
        System.assertEquals(locationNewJersey.Id, results[0]);        
    }
}