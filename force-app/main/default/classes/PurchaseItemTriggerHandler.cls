public with sharing class PurchaseItemTriggerHandler {
   public static void populateUnitPrice(List<Purchase_Item__c> purchaseItems) {
        Set<Id> medicineIds = new Set<Id>();
        for (Purchase_Item__c pi : purchaseItems) {
            if (pi.Medicine__c != null) {
                medicineIds.add(pi.Medicine__c);
            }
        }
        Map<Id, Medicine__c> medicineMap = new Map<Id, Medicine__c>(
            [SELECT Id, Unit_Price__c FROM Medicine__c WHERE Id IN :medicineIds]
        );
        for (Purchase_Item__c pi : purchaseItems) {
            if (pi.Medicine__c != null && medicineMap.containsKey(pi.Medicine__c)) {
                pi.Unit_Price__c = medicineMap.get(pi.Medicine__c).Unit_Price__c;
            }
        }
    }
}