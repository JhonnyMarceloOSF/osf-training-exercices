public class CheckFulfillmentOrders_Schedule implements Schedulable{
    public void execute(SchedulableContext ctx) {
        FO_Batch_Size__mdt fO_Batch_Size = 
            [SELECT Batch_Size__c FROM FO_Batch_Size__mdt];
       
        Database.executeBatch(new CheckFulfillmentOrders_Batch(), fO_Batch_Size.Batch_Size__c.intValue());
    }
}