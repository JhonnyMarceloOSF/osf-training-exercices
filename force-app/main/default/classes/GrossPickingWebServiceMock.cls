@isTest
global class GrossPickingWebServiceMock  implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('Out of Stock');
        response.setStatusCode(200);
        return response; 
    }
}