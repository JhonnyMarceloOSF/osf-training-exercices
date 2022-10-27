public class CheckAssigmentLimitAction {
   
    @InvocableMethod(label = 'Check Assignment Limit'
                     category = 'Location')
    public static List<String> checkAssignmentLimit(){

        List<String> result = new List<String>();

        Schema.Location locationAlbany  = [SELECT Id, Assignment_Limit__c FROM Location WHERE Name = 'Albany' LIMIT 1];
        
        List<FulfillmentOrder> fulfillmentOrderList = [SELECT Id FROM FulfillmentOrder WHERE Status =:SOM_FulfillmentOrderStatus.FULFILLED.enumValue];
               
        if (fulfillmentOrderList.size() < locationAlbany.Assignment_Limit__c) {
            result.add(String.valueOf(locationAlbany .Id));

            return result;
        } else{
            Schema.Location locationNewJersey = [SELECT Id FROM Location WHERE Name = 'New Jersey' LIMIT 1];
            result.add(String.valueOf(locationNewJersey.Id));

            return result;
        }         
    }
}