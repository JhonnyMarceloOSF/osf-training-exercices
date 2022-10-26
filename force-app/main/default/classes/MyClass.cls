public class MyClass {
   
    @InvocableMethod(label = 'Check Assignment Limit'
                     category = 'Location')
    public static List<String> checkAssignmentLimit(){

        List<String> result = new List<String>();

        List<Schema.Location> Albany = [SELECT Id, Name, AssignedFoCount, Assignment_Limit__c FROM Location WHERE Name = 'Albany'];
                                
        List<Schema.Location> NewJersey = [SELECT Id, Name FROM Location WHERE Name = 'New Jersey'];

        List<FulfillmentOrder> fO = [SELECT Id, Status FROM FulfillmentOrder WHERE Status =:SOM_FulfillmentOrderStatus.FULFILLED.enumValue];
       
        System.debug('Limit ' + Albany[0].Assignment_Limit__c);
        System.debug('Size' + fO.size());
        if (fO.size() < Albany[0].Assignment_Limit__c) {
            result.add(String.valueOf(Albany[0].Id));
            return result;

        } else{
            result.add(String.valueOf(NewJersey[0].Id));
            return result;            
        }         
    }
}