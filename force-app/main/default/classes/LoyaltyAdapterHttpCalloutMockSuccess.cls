@IsTest
public class LoyaltyAdapterHttpCalloutMockSuccess implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest request) {
        System.assertEquals('GET', request.getMethod());

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);

        List<String> jsonResponse = new List<String> {
            '"id":3203',
            '"uid":"a41005e9-9ab0-4752-8a8e-4a6e15507a54"',
            '"credit_card_number":"1228-1221-1221-1431"',
            '"credit_card_expiry_date":"2026-02-17"',
            '"credit_card_type":"visa"'         
        }; 

        response.setBody('{' + String.join(jsonResponse, ',') + '}');

        return response; 
    }
}
