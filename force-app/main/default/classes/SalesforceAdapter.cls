global class SalesforceAdapter implements commercepayments.PaymentGatewayAdapter {
    private static final commercepayments.SalesforceResultCodeInfo SUCCESS_SALESFORCE_RESULT_CODE_INFO = 
    		new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Success);
    private static final commercepayments.SalesforceResultCodeInfo DECLINE_SALESFORCE_RESULT_CODE_INFO = 
    		new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Decline);
    
    global SalesforceAdapter() {
    }
 
    global commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {
        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        commercepayments.GatewayResponse response;
        try 
        {
            if ( requestType == commercepayments.RequestType.Capture)
            {
                response =  createCaptureResponse((commercepayments.CaptureRequest)gatewayContext.getPaymentRequest()) ;
            }
            else if (requestType == commercepayments.RequestType.ReferencedRefund) {
            		response = createRefundResponse((commercepayments.ReferencedRefundRequest)gatewayContext.getPaymentRequest());
            }
           
            return response;
        }
        catch(SalesforceValidationException e)
        {
             commercepayments.GatewayErrorResponse error = new commercepayments.GatewayErrorResponse('400', e.getMessage());
             return error;
        }
    }
     
    public commercepayments.GatewayResponse createCaptureResponse(commercepayments.CaptureRequest captureRequest) {
        commercepayments.CaptureResponse captureResponse = new commercepayments.CaptureResponse();
        if(captureRequest.amount!=null )
        {
            captureResponse.setAmount(captureRequest.amount);
        }
        else
        {
             throw new SalesforceValidationException('Required Field Missing : Amount');             
        }
   
        system.debug('Response - success');
        captureResponse.setGatewayDate(system.now());
        captureResponse.setGatewayResultCode('00');
        captureResponse.setGatewayResultCodeDescription('Transaction Normal');
        captureResponse.setGatewayReferenceNumber('SF'+getRandomNumber(6));
        captureResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        return captureResponse;
    }
    
    public commercepayments.GatewayResponse createRefundResponse(commercepayments.ReferencedRefundRequest refundRequest) {
    		commercepayments.ReferencedRefundResponse refundResponse = new commercepayments.ReferencedRefundResponse();
    		if (refundRequest.amount != null) {
    			refundResponse.setAmount(refundRequest.amount);
    		} else {
    			throw new SalesforceValidationException('Required Field Missing : Amount');
    		}
        refundResponse.setGatewayResultCode('00');
        refundResponse.setGatewayDate(system.now());
        refundResponse.setGatewayResultCodeDescription('Transaction Normal');
        refundResponse.setGatewayReferenceNumber('SF'+getRandomNumber(6));
        refundResponse.setSalesforceResultCodeInfo(SUCCESS_SALESFORCE_RESULT_CODE_INFO);
        return refundResponse;
    }  
    private String getRandomNumber(integer stringLength){
        final integer MAX = integer.valueOf(Math.pow(10,stringLength) - 1);
        return String.valueOf(Math.Round(Math.Random() * MAX)).leftPad(stringLength,'0');
    }
}