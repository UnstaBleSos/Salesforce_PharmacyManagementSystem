trigger PreventPrescriptionDeletion on Prescription__c (before delete) {
    Set<Id> prescriptionIds = new Set<Id>();
    for (Prescription__c pres : Trigger.old) {
        prescriptionIds.add(pres.Id);
    }
    Integer relatedSalesCount = [
        SELECT COUNT()
        FROM Sales_Item__c
        WHERE Prescription__c IN :prescriptionIds
    ];
    if (relatedSalesCount > 0) {
        for (Prescription__c pres : Trigger.old) {
            pres.addError('Cannot delete Prescription "' + pres.Name + '" because related Sales Items exist.');
        }
    }
}
