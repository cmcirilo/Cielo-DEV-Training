trigger PreventDuplicateAccountName on Account (before insert, before update) {
    
    System.debug('Execucação da trigger PreventDuplicateAccountName');
    Set<String> newAccountNames = new Set<String>();
    Set<String> existingAccountNames = new Set<String>(); 
    
    // Percorre as contas sendo inseridas para verificar duplicatas
    for (Account newAccount : Trigger.new) {
        newAccountNames.add(newAccount.Name);
    }
    
    // Consulta as contas existentes no banco de dados com os nomes das contas a serem inseridas
    for (Account existingAccount : [SELECT Name FROM Account WHERE Name IN :newAccountNames]) {
        existingAccountNames.add(existingAccount.Name);
    }
    
    // Percorre as contas sendo inseridas para verificar duplicatas
    for (Account newAccount : Trigger.new) {
        if (existingAccountNames.contains(newAccount.Name)) {
            newAccount.addError('Já existe uma conta com o mesmo nome.');
        }
    }
}