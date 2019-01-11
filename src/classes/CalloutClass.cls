public class CalloutClass {
    
    @future(callout=true)
    public static void makeCallout(Id id, Id OwnerId, String name, String address) {
        
        try{     
            HttpRequest request = new HttpRequest();
            
            String endpoint = 'http://f12d0250.ngrok.io/TestTask/restfulstocks/stock/';
            
            String userName = 'admin';
            String password = null;
            Blob headerValue = Blob.valueOf(userName + ':' + password);
            String authorizationHeader = 'Basic YWRtaW46 ' + EncodingUtil.base64Encode(headerValue);
            
            String stringBody = '{ \"name\":\"' +name+ '\", \"address\":\"' +address+ '\"}'; 
            
            request.setHeader('Authorization', authorizationHeader);             
            request.setHeader('Accept', 'application/json');  
            request.setHeader('Content-Type', 'application/json'); 
            request.setBody(stringBody);           
            request.setEndPoint(endpoint);
            request.setMethod('POST');
            
            HttpResponse response = new HTTP().send(request);
            
            System.debug('Response:'+ response.getStatusCode());
            
            if (response.getStatusCode() != 200) { 
                
                String messageError = '';
                
                // read custom error message from server
                if (response.getStatusCode() == 500) {
                    
                    Bar__c objTicketData = 
                        (Bar__c) System.JSON.deserialize(response.getbody(), Bar__c.class);
                    
                    if(objTicketData.Name != null)  
                        messageError = messageError + ' Name: ' + objTicketData.Name;
                    
                    if(objTicketData.Address__c != null) 
                        messageError = messageError + ' Address:' +objTicketData.Address__c;
                    
                    system.debug('messageError:' + messageError); 
                }
                
                Bar__c record = new Bar__c();
                record.Id = id;
                record.Apex_Rollback__c = true;
                record.Apex_Rollback_Description__c = messageError;
                record.MessageShow__c = 'ERROR';
                update record; 
                
                Task task = new Task();
                task.Bars__c = id;
                task.ActivityDate = date.today().adddays(1);
                task.Description = messageError;
                task.OwnerId = OwnerId;
                task.Priority = 'Normal';
                task.Status = 'Not Started';
                task.Subject = 'Review Your Record Errors';
                insert task;    
            } 
            
            // update record with valid values
            else {
                Bar__c record = new Bar__c();
                record.Id = id;
                record.Name = Name;
                record.Address__c = Address;
                record.Apex_Rollback__c = FALSE;
                record.Apex_Rollback_Description__c = '';
                record.MessageShow__c = 'CONFIRM';
                update record;         
            } 
            
        } catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
    }   
}