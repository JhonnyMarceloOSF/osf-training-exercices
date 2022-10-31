public class CheckFulfillmentOrders_Schedule implements Schedulable{
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new CheckFulfillmentOrders_Batch(), 5);
    }
}