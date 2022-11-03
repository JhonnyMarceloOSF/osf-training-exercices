@isTest
private class CheckFulfillmentOrders_Schedule_Test {
    @isTest(SeeAllData=true)
    private static void testScheduledJob() {
         // Test data setup        
        String orderId = SOM_TestDataFactory.createOrderAction(Date.today().addDays(-3));   
        Id orderSummaryId = SOM_TestDataFactory.createOrderSummary(orderId).Id;
               
        Schema.Location locationAlbany = new Schema.Location (Name = 'Albany', LocationType = 'Warehouse', Assignment_Limit__c = 5);
        insert locationAlbany;

        FulfillmentOrder fulfillmentOrderToCreate = SOM_TestDataFactory.createFulfillmentOrders(
            orderSummaryId, locationAlbany.Id, SOM_FulfillmentOrderType.WAREHOUSE)[0];
            fulfillmentOrderToCreate.Status = SOM_FulfillmentOrderStatus.ASSIGNED.enumValue;
            SOM_DatabaseUtil.updateRecords(fulfillmentOrderToCreate, true);
                  
        FO_Batch_Size__mdt fO_Batch_Size = 
            [SELECT Batch_Size__c FROM FO_Batch_Size__mdt];
        
        Test.startTest();
        Database.executeBatch(new CheckFulfillmentOrders_Batch(), fO_Batch_Size.Batch_Size__c.intValue());
        Test.stopTest();
        
        FO_immediate_attention_delay__mdt fOImmediateAttentionDelayMdt = [SELECT Number_Of_Hours__c FROM FO_immediate_attention_delay__mdt];
        
        datetime searchDate = datetime.now().addHours(-fOImmediateAttentionDelayMdt.Number_Of_Hours__c.intValue());
        
        List<FulfillmentOrder> result = [SELECT Id, Status
            FROM FulfillmentOrder
            WHERE OrderSummary.OrderedDate < =: searchDate 
            AND StatusCategory = 'Fulfilling' AND Status != 'Require Immediate attention' ];               
        
        System.assertEquals(0, result.size());
    }
    
    
}