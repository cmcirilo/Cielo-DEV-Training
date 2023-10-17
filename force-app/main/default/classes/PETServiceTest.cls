@isTest
public class PETServiceTest {

    @isTest
    static void testGetPetImageSucess() {
        // Criar um registro de PET para teste
        PET__c testPet = new PET__c(Name = 'Test Pet', Tipo__c = 'Cat');
        insert testPet;

        // Criar um JSON simulado para passar para o método
        String jsonPetRequest = '{"Id":"' + testPet.Id + '","Tipo__c":"Cat"}';

        // Configurar o mock para a chamada HTTP
        Test.setMock(HttpCalloutMock.class, new PETServiceMock());

        // Chamar o método que queremos testar
        Test.startTest();
        PETService.getPetImage(jsonPetRequest);
        Test.stopTest();

        // Realizar verificações para garantir que o método funcionou corretamente
        PET__c updatedPet = [SELECT Id, URL_Imagem__c FROM PET__c WHERE Id = :testPet.Id];
        System.assertNotEquals(null, updatedPet.URL_Imagem__c, 'A URL da imagem não deve ser nula após a chamada do método.');

        
    }

    @isTest
    static void testGetPetImageError() {
        // Criar um registro de PET para teste
        PET__c testPet = new PET__c(Name = 'Test Pet', Tipo__c = 'Dog');
        insert testPet;

        // Criar um JSON simulado para passar para o método
        String jsonPetRequest = '{"Id":"' + null + '","Tipo__c":"Dog"}';

        // Configurar o mock para a chamada HTTP
        Test.setMock(HttpCalloutMock.class, new PETServiceMock());

        // Chamar o método que queremos testar
        Test.startTest();
        try{
        	PETService.getPetImage(jsonPetRequest);    
        }catch(Exception ex){
            System.debug('ex: ' + ex.getMessage());
            System.Assert(ex.getMessage().contains('Invalid id'));
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetPETs() {
        // Criando alguns objetos PET__c para simular os dados
        List<PET__c> testPets = new List<PET__c>{
            new PET__c(Name = 'Test PET 1', Tipo__c = 'Dog' ),
            new PET__c(Name = 'Test PET 2', Tipo__c = 'Cat')
        };
        insert testPets;

        // Chamando o método a ser testado
        Test.startTest();
        List<PET__c> result = PETService.getPETs('test');
        Test.stopTest();

        // Verificando se o método retorna o número correto de registros
        System.assertEquals(2, result.size());
    }
}