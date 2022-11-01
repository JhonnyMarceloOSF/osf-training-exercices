@isTest
private class CheckFulfillmentOrders_Schedule_Test {
    @isTest(SeeAllData=true)
    private static void testScheduledJob() {
         // Test data setup        
        String orderId = SOM_TestDataFactory.createOrderAction();   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
               
        Schema.Location locationAlbany = new Schema.Location (Name = 'Albany', LocationType = 'Warehouse', Assignment_Limit__c = 5);
        insert locationAlbany;

        FulfillmentOrder createfulfillmentOrder = SOM_TestDataFactory.createFulfillmentOrders(
            orderSummaryId, locationAlbany.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
        createfulfillmentOrder.Status = SOM_FulfillmentOrderStatus.ASSIGNED.enumValue;
        SOM_DatabaseUtil.updateRecords(createfulfillmentOrder, true);
                  
        
        Test.startTest();
        Database.executeBatch(new CheckFulfillmentOrders_Batch(), 10);
        Test.stopTest();
        
        FO_immediate_attention_delay__mdt fOImmediateAttentionDelayMdt = [SELECT Number_Of_Hours__c FROM FO_immediate_attention_delay__mdt];
        
        datetime searchDate = datetime.now().addHours(-fOImmediateAttentionDelayMdt.Number_Of_Hours__c.intValue());
        
        List<Order> orders = [SELECT Id FROM Order WHERE OrderedDate < :searchDate];
        
        List<Id> ids = new List<Id>();
        
        for(Order order : orders){
            ids.add(order.Id);
        }
        
        List<String> status = new List<String>{
            'Assigned', 'Pickpack','Printed','Pick Complete'};
        
        List<FulfillmentOrder> result = [SELECT Id, Status
            FROM FulfillmentOrder
            WHERE OrderSummary.OriginalOrderId In :ids
            AND Status IN :status ];               
        
        System.assertEquals(0, result.size());
    }
    
    
}