@isTest
public class PreventDuplicateAccountNameTest {
	@isTest
    static void testDuplicateAccountName() {
        // Crie uma Account com um nome existente no banco de dados
        Account existingAccount = new Account(Name = 'Conta Existente');
        insert existingAccount;
        
        // Tente inserir uma Account com o mesmo nome
        Account duplicateAccount = new Account(Name = 'Conta Existente');
        
        Test.startTest();
        try {
            insert duplicateAccount;
            System.assert(false, 'A inserção da conta duplicada deveria ter falhado.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Já existe uma conta com o mesmo nome.'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUniqueAccountName() {
        // Tente inserir uma Account com um nome único
        Account uniqueAccount = new Account(Name = 'Conta Única');
        
        Test.startTest();
        insert uniqueAccount;
        Test.stopTest();
        
        // Verifique se a inserção ocorreu sem erros
        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Name = 'Conta Única' LIMIT 1];
        System.assertNotEquals(null, insertedAccount, 'A conta única não foi inserida.');
    } 
}