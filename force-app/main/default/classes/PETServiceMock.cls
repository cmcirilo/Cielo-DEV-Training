@isTest
global class PETServiceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Criar uma resposta de mock
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('[{"url": "https://www.example.com/cat.jpg"}]');
        return res;
    }
}