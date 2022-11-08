@IsTest
private class GrossPickingTest {
    @isTest(SeeAllData=true)
    static void withOOS() {
        List<String> DataSetup = TestDataSetup();

        PostRequest(CreateGrossPickingRequest(true, DataSetup[0]));

        Test.startTest();
        GrossPickingWebService.getStock();
        Test.stopTest();

        FulfillmentOrder  fulfillmentOrder = [SELECT Id, Status FROM FulfillmentOrder WHERE Id =:DataSetup[1]];

        System.assertEquals(SOM_Constants.OUT_OF_STOCK, fulfillmentOrder.Status);
    }

    @isTest(SeeAllData=true)
    static void withOutOOS() {
        List<String> DataSetup = TestDataSetup();
       
        PostRequest(CreateGrossPickingRequest(false, DataSetup[0]));

        Test.startTest();
        GrossPickingWebService.getStock();
        Test.stopTest();

        FulfillmentOrder  fulfillmentOrder = [SELECT Id, Status FROM FulfillmentOrder WHERE Id =:DataSetup[1]];

        System.assertEquals(SOM_Constants.FULFILLED, fulfillmentOrder.Status);
   }

   static List<String> TestDataSetup(){
    List<String> result = new List<String>();
    String orderId = SOM_TestDataFactory.createOrderAction();   
    Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
           
    Schema.Location locationAlbany = new Schema.Location (Name = 'Albany', LocationType = 'Warehouse', Assignment_Limit__c = 5);
    insert locationAlbany;

    FulfillmentOrder fulfillmentOrderToCreate = SOM_TestDataFactory.createFulfillmentOrders(
        orderSummaryId, locationAlbany.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        fulfillmentOrderToCreate.Status = SOM_FulfillmentOrderStatus.ASSIGNED.enumValue;
        SOM_DatabaseUtil.updateRecords(fulfillmentOrderToCreate, true);

    OrderSummary orderSummary = [SELECT id, OrderNumber FROM OrderSummary WHERE id =:orderSummaryId];

    result.add(orderSummary.OrderNumber);
    result.add(String.valueOf(fulfillmentOrderToCreate.id));

    return result;
    }

    static void PostRequest(GrossPickingRequest grossPickingRequest){
        RestRequest request = new RestRequest();
        request.requestURI = 'https://flow-site-7766.scratch.my.salesforce.com/services/apexrest/Fulfilment/';
        request.requestBody = Blob.valueOf(JSON.serialize(grossPickingRequest));
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
    }

    static GrossPickingRequest CreateGrossPickingRequest(Boolean isOOs, String externalOderNumber){
        GrossPickingRequest grossPickingRequest = new GrossPickingRequest();
        grossPickingRequest.externalOrderNumber = externalOderNumber;
        GrossPickingRequestItem requestItem = new GrossPickingRequestItem();
        requestItem.itemCode = 'PROD001';
        requestItem.isOOS = isOOs;
        grossPickingRequest.items.add(requestItem);

        return grossPickingRequest;
    }
}
