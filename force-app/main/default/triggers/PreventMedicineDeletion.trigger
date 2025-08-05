trigger PreventMedicineDeletion on Medicine__c (before delete) {
    Set<Id> medicineIds = new Set<Id>();
    for (Medicine__c med : Trigger.old) {
        medicineIds.add(med.Id);
    }
    Integer relatedSalesCount = [
        SELECT COUNT()
        FROM Sales_Item__c
        WHERE Medicine__c IN :medicineIds
    ];
    if (relatedSalesCount > 0) {
        for (Medicine__c med : Trigger.old) {
            med.addError('Cannot delete Medicine "' + med.Name + '" because related Sales Items exist.');
        }
    }
}
