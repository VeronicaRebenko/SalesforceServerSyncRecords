@isTest
global class CalloutClassMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"name": "can not contain special symbols"}');
        response.setStatusCode(500);
        return response; 
    }
}