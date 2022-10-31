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
        
        List<FulfillmentOrder> fulfillmentOrders = [SELECT Id, Status, OrderSummary.OriginalOrderId  
          FROM FulfillmentOrder WHERE Status = 'Assigned'];

        List<Order> orders = new List<Order>();
        for (FulfillmentOrder fulfillmentOrder : fulfillmentOrders){
            Order order = [SELECT Id, OrderedDate FROM Order 
                           WHERE Id =: fulfillmentOrder.OrderSummary.OriginalOrderId ];            
            
            order.OrderedDate = Date.today().addDays(-3);
            orders.add(order);
        }
        update orders;
        
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        Datetime workTime = System.now().addMinutes(1);
        String CRON_EXP = '' + workTime.second() + ' ' + workTime.minute() + ' ' + workTime.hour()
        + ' ' + workTime.day() + ' ' + workTime.month() + ' ? ' + workTime.year();
        
        Test.startTest();
        String jobId = System.schedule('CheckFulfillmentOrdersScheduleTest',
            CRON_EXP,
            new CheckFulfillmentOrders_Schedule());
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