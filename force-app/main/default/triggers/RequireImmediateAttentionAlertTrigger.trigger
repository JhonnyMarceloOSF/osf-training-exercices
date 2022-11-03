trigger RequireImmediateAttentionAlertTrigger on FOStatusChangedEvent (after insert) {
    
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    
    for (FOStatusChangedEvent fOStatusChangedEvent : Trigger.new){
        if (fOStatusChangedEvent.NewStatus == 'Require Immediate attention'){
            
            FulfillmentOrder fulfillmentOrder = [SELECT FulfillmentOrderNumber 
                                                 FROM FulfillmentOrder 
                                                 WHERE Id =:fOStatusChangedEvent.FulfillmentOrderId LIMIT 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            List<String> sendTo = new List<String>();
            sendTo.add('jhonny.marcelo@osf.digital');
            email.setToAddresses(sendTo);
            
            email.setReplyTo('jhonny.marcelo@osf.digital');
      		email.setSenderDisplayName('Exercício 3');
            
            email.setSubject(fulfillmentOrder.FulfillmentOrderNumber + ' Require Immediate Attetion');
            String body = 'Dear employe the fulfilment Order Number: ' + fulfillmentOrder.FulfillmentOrderNumber + ' require your immediate attention';
            
            email.setHtmlBody(body);
            emails.add(email);
        }
        
		Messaging.sendEmail(emails);        
    }
}