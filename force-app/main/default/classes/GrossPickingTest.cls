@IsTest
private class GrossPickingTest {
    @isTest(SeeAllData=true)
    static void withOOS() {
        // Test data setup        
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
            
        Schema.Location locationAlbany = new Schema.Location (Name = 'Albany', LocationType = 'Warehouse', Assignment_Limit__c = 5);
        insert locationAlbany;

        FulfillmentOrder fulfillmentOrderToCreate = SOM_TestDataFactory.createFulfillmentOrders(
            orderSummaryId, locationAlbany.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
            fulfillmentOrderToCreate.Status = SOM_FulfillmentOrderStatus.ASSIGNED.enumValue;
            SOM_DatabaseUtil.updateRecords(fulfillmentOrderToCreate, true);

        OrderSummary orderSummary = [SELECT id, OrderNumber FROM OrderSummary WHERE id =:orderSummaryId];

        GrossPickingRequest grossPickingRequest = new GrossPickingRequest();
        grossPickingRequest.externalOrderNumber = orderSummary.OrderNumber;
        GrossPickingRequestItem requestItem = new GrossPickingRequestItem();
        requestItem.itemCode = 'PROD001';
        requestItem.isOOS = true;
        grossPickingRequest.items.add(requestItem);

        RestRequest request = new RestRequest();
        request.requestURI = 'https://flow-site-7766.scratch.my.salesforce.com/services/apexrest/Fulfilment/';
        request.requestBody = Blob.valueOf(JSON.serialize(grossPickingRequest));
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;

        Test.startTest();
        GrossPickingWebService.getStock();
        Test.stopTest();

        FulfillmentOrder  fulfillmentOrder = [SELECT Id, Status FROM FulfillmentOrder WHERE Id =:fulfillmentOrderToCreate.id];

        System.assertEquals(SOM_Constants.OUT_OF_STOCK, fulfillmentOrder.Status);
    }

    @isTest(SeeAllData=true)
    static void withOutOOS() {
        // Test data setup        
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
               
        Schema.Location locationAlbany = new Schema.Location (Name = 'Albany', LocationType = 'Warehouse', Assignment_Limit__c = 5);
        insert locationAlbany;

        FulfillmentOrder fulfillmentOrderToCreate = SOM_TestDataFactory.createFulfillmentOrders(
            orderSummaryId, locationAlbany.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
            fulfillmentOrderToCreate.Status = SOM_FulfillmentOrderStatus.ASSIGNED.enumValue;
            SOM_DatabaseUtil.updateRecords(fulfillmentOrderToCreate, true);

        OrderSummary orderSummary = [SELECT id, OrderNumber FROM OrderSummary WHERE id =:orderSummaryId];

        GrossPickingRequest grossPickingRequest = new GrossPickingRequest();
        grossPickingRequest.externalOrderNumber = orderSummary.OrderNumber;
        GrossPickingRequestItem requestItem = new GrossPickingRequestItem();
        requestItem.itemCode = 'PROD001';
        requestItem.isOOS = false;
        grossPickingRequest.items.add(requestItem);

        RestRequest request = new RestRequest();
        request.requestURI = 'https://flow-site-7766.scratch.my.salesforce.com/services/apexrest/Fulfilment/';
        request.requestBody = Blob.valueOf(JSON.serialize(grossPickingRequest));
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;

        Test.startTest();
        GrossPickingWebService.getStock();
        Test.stopTest();

        FulfillmentOrder  fulfillmentOrder = [SELECT Id, Status FROM FulfillmentOrder WHERE Id =:fulfillmentOrderToCreate.id];

        System.assertEquals(SOM_Constants.FULFILLED, fulfillmentOrder.Status);
   }
}
