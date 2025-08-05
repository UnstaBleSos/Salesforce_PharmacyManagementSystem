trigger PurchaseItemTrigger on Purchase_Item__c (before insert, before update) {
    PurchaseItemTriggerHandler.populateUnitPrice(Trigger.new);
}
