trigger SalesItemTrigger on Sales_Item__c (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        SalesItemTriggerHandler.validateStock(Trigger.new);
        SalesItemTriggerHandler.populateUnitPrice(Trigger.new);
    }
}
