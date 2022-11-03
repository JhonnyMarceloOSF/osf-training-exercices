public class CheckFulfillmentOrders_Batch Implements Database.Batchable<FulfillmentOrder>, Database.Stateful {

    public Iterable<FulfillmentOrder> start(Database.BatchableContext bc) {
        FO_immediate_attention_delay__mdt fOImmediateAttentionDelayMdt = 
            [SELECT Number_Of_Hours__c FROM FO_immediate_attention_delay__mdt];

        datetime searchDate = datetime.now().addHours(-fOImmediateAttentionDelayMdt.Number_Of_Hours__c.intValue());
    
        return [SELECT Id, Status
                FROM FulfillmentOrder
                WHERE OrderSummary.OrderedDate < =: searchDate 
                AND StatusCategory = 'Fulfilling' AND Status != 'Require Immediate attention' ];        
    }

    public void execute(Database.BatchableContext bc, List<FulfillmentOrder> fulfillmentOrders){
        for (FulfillmentOrder fulfillmentOrder : fulfillmentOrders){
            fulfillmentOrder.Status = 'Require Immediate attention';            
        }
        update fulfillmentOrders;
    }

    public void finish(Database.BatchableContext bc){
        
    }
}