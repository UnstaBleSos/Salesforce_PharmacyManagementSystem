public with sharing class LowStockMedicineController {
	@AuraEnabled(cacheable=true)
    public static List<Medicine__c> getLowStockMedicine(){
        return [
            Select Id, Name, Stock__c
            From Medicine__c
            where Stock__c<10
            Order by Stock__c ASC
            LIMIT 50 
        ];
    } 
}