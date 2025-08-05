public with sharing class SalesItemTriggerHandler {
    public static void validateStock(List<Sales_Item__c> salesItems) {
        Set<Id> medicineIds = new Set<Id>();
        for (Sales_Item__c item : salesItems) {
            if (item.Medicine__c != null) {
                medicineIds.add(item.Medicine__c);
            }
        }
        Map<Id, Medicine__c> medicineMap = new Map<Id, Medicine__c>(
            [SELECT Id, Name, Stock__c FROM Medicine__c WHERE Id IN :medicineIds]
        );
        for (Sales_Item__c item : salesItems) {
            if (item.Medicine__c != null && item.Quantity__c != null) {
                Medicine__c med = medicineMap.get(item.Medicine__c);
                if (med != null && (med.Stock__c == null || med.Stock__c < item.Quantity__c)) {
                    item.addError('Cannot proceed: "' + med.Name + '" has only ' + med.Stock__c + 
                                  ' in stock, but you are trying to sell ' + item.Quantity__c + '.');
                }
            }
        }
    }

     public static void populateUnitPrice(List<Sales_Item__c> salesItems) {
        Set<Id> medicineIds = new Set<Id>();
        for (Sales_Item__c item : salesItems) {
            if (item.Medicine__c != null) {
                medicineIds.add(item.Medicine__c);
            }
        }

        Map<Id, Medicine__c> medicineMap = new Map<Id, Medicine__c>(
            [SELECT Id, Unit_Price__c FROM Medicine__c WHERE Id IN :medicineIds]
        );

        for (Sales_Item__c item : salesItems) {
            Medicine__c med = medicineMap.get(item.Medicine__c);
            if (med != null && med.Unit_Price__c != null) {
                item.Unit_Price__c = med.Unit_Price__c;
            }
        }
    }
}