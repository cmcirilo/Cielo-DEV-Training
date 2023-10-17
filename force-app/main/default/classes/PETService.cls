public with sharing class PETService {
    
    private static final String ENDPOINT_CAT        = 'https://api.thecatapi.com/v1/images/search?breed_ids=beng&include_breeds=true';
    private static final String ENDPOINT_RANDOMDOG  = 'https://dog.ceo/api/breeds/image/random';
    
    @AuraEnabled
    public static void getPetImage(string jsonPetRequest){
        
        Map<String, Object> mapUntypedPet = (Map<String, Object>)JSON.deserializeUntyped(jsonPetRequest);
        
        PET__c pet = new PET__c(Id = (Id)mapUntypedPet.get('Id'));
        try {
            
            HttpRequest req = new HttpRequest();
            HttpResponse resp = new HttpResponse();
            
            req.setHeader('Content-Type', 'application/json');  
            req.setMethod('GET');
            
            if(mapUntypedPet.get('Tipo__c') == 'Cat'){
                req.setEndpoint(ENDPOINT_CAT);   
            }else{
                req.setEndpoint(ENDPOINT_RANDOMDOG);  
            }
            
            resp = new Http().send(req);
            
            if(resp.getStatusCode() == 200){
                string body = resp.getBody().removeStart('[').removeEnd(']');
                
                Map<String, Object> mapUntyped = (Map<String, Object>)JSON.deserializeUntyped(body);
                
                pet.URL_Imagem__c =  (mapUntyped.get('url') != null ? (String)mapUntyped.get('url') : (String)mapUntyped.get('message'));
                update pet;
                
            }else{
                throw new AuraHandledException('Falha ao realizar chamada API. ' + resp.getStatusCode() + ' - ' + resp.getBody());
            }
            
        } catch (Exception e) {
            delete pet;
            throw new AuraHandledException(e.getMessage());
        } 
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Pet__c> getPETs(string dontRemove ){
       
            
            return [Select Id, Name, Tipo__c, Solicitante__c, Porte__c, URL_Imagem__c 
                    FROM PET__c order by CreatedDate desc
                    limit 5];
        
    }
}