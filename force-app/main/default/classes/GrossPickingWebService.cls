@RestResource(urlMapping='/Fulfillment/GrossPickingResult')
global with sharing class GrossPickingWebService {
    @HttpPost
    global static void getStock(){
        RestRequest request = RestContext.request;
        String requestBody = request.requestBody.toString();
        GrossPickingRequest grossPickingRequest = (GrossPickingRequest)JSON.deserialize(requestBody, GrossPickingRequest.class);

        Boolean itemOOS = false;
        for (GrossPickingRequestItem requestItem : grossPickingRequest.items){            
            if (requestItem.isOOS == true){
                itemOOS = true;
            }             
        }

        FulfillmentOrder fulfillmentOrder = [SELECT Id, Status, OrderSummary.OrderNumber 
                                                FROM FulfillmentOrder
                                                WHERE OrderSummary.OrderNumber =:grossPickingRequest.externalOrderNumber ];

        if (itemOOS == true) {
            fulfillmentOrder.Status = 'Out of Stock';
        } else {
            fulfillmentOrder.Status = 'Fulfilled';
        }

        update fulfillmentOrder;        
    }
}
