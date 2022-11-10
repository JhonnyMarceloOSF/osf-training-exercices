@IsTest
public class LoyaltyAdapterTest {
    @isTest
    public static void ValidCardType() {
        PaymentAuthorization auth = initializeAuthObject();
        insert auth;
        
        Test.setMock(HttpCalloutMock.class, new LoyaltyAdapterHttpCalloutMockSuccess());
        
        commercepayments.CaptureRequest captureRequest = new commercepayments.CaptureRequest(80, auth.id);
        
        commercepayments.PaymentGatewayContext p = new commercepayments.PaymentGatewayContext(captureRequest, commercepayments.RequestType.capture);
        LoyaltyAdapter loyaltyAdapter = new LoyaltyAdapter();
        
        Test.startTest();
        commercepayments.GatewayResponse captureResponse = loyaltyAdapter.processRequest(p);        
        Test.stopTest();

        System.assert(captureResponse instanceOf commercepayments.CaptureResponse, 'Response is not a valid Capture response');
    }

    @isTest
    public static void InvalidCardType() {
        PaymentAuthorization auth = initializeAuthObject();
        insert auth;
        
        Test.setMock(HttpCalloutMock.class, new LoyaltyAdapterHttpCalloutMockFailure());
        
        commercepayments.CaptureRequest captureRequest = new commercepayments.CaptureRequest(80, auth.id);
        
        commercepayments.PaymentGatewayContext p = new commercepayments.PaymentGatewayContext(captureRequest, commercepayments.RequestType.capture);
        LoyaltyAdapter loyaltyAdapter = new LoyaltyAdapter();
        
        Test.startTest();
        commercepayments.GatewayResponse captureResponse = loyaltyAdapter.processRequest(p);        
        Test.stopTest();

        System.assert(captureResponse instanceOf commercepayments.CaptureResponse, 'Response is not a valid Capture response');
    }


    private static PaymentAuthorization initializeAuthObject()
    {
        PaymentAuthorization auth = new PaymentAuthorization();
        auth.amount = 1500;
        auth.Status = 'Processed';
        auth.ProcessingMode = 'External';
        auth.GatewayRefNumber = 'testreferencenumber';
        auth.GatewayRefDetails = '{"method":"credit_card","transaction_id":"ET119982"}';

        return auth;    
    }

  }
