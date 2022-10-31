public class CheckFulfillmentOrders_Batch Implements Database.Batchable<sObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        FO_immediate_attention_delay__mdt fOImmediateAttentionDelayMdt = 
            [SELECT Number_Of_Hours__c FROM FO_immediate_attention_delay__mdt];

        datetime searchDate = datetime.now().addHours(-fOImmediateAttentionDelayMdt.Number_Of_Hours__c.intValue());

        List<Order> orders = [SELECT Id FROM Order WHERE OrderedDate < :searchDate];

        String ids = '';

        for (Integer i = 0; i < orders.size(); i++) {
            if (i < orders.size() - 1 ) {
                ids = ids + '\'' + orders[i].Id + '\',';
            } else {
                ids = ids + '\'' + orders[i].Id + '\'';
            }            
        }

        return Database.getQueryLocator(
            'SELECT Id, Status, OrderSummary.OrderedDate ' +
            'FROM FulfillmentOrder ' +
            'WHERE OrderSummary.OriginalOrderId IN (' + ids + ') ' +
            'AND Status IN (\'Assigned\', \'Pickpack\',\'Printed\',\'Pick Complete\') '
        );
    }

    public void execute(Database.BatchableContext bc, List<FulfillmentOrder> fulfillmentOrders){
        for (FulfillmentOrder fulfillmentOrder : fulfillmentOrders){
            fulfillmentOrder.Status = 'Require Immediate attention';
            update fulfillmentOrder;
        }
    }

    public void finish(Database.BatchableContext bc){
        
    }
}