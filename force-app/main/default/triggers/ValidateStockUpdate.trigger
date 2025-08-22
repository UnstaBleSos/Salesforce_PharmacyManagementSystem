trigger ValidateStockUpdate on Purchase_Item__c (before insert, before update) {
  
    Set<Id> purchaseIds = new Set<Id>();
    for (Purchase_Item__c pi : Trigger.new) {
        if (pi.Purchase__c != null) {
            purchaseIds.add(pi.Purchase__c);
        }
    }

    Map<Id, Purchase__c> purchases = new Map<Id, Purchase__c>(
        [SELECT Id, Total_Amount__c FROM Purchase__c WHERE Id IN :purchaseIds]
    );

    for (Purchase_Item__c pi : Trigger.new) {
        if (pi.Purchase__c != null && purchases.containsKey(pi.Purchase__c)) {
            Purchase__c relatedPurchase = purchases.get(pi.Purchase__c);

            if (pi.Quantity__c != null && pi.Unit_Price__c != null) {
                Decimal actualTotal = pi.Quantity__c * pi.Unit_Price__c;
                Decimal allowedUnits = relatedPurchase.Total_Amount__c / pi.Unit_Price__c;

                if (actualTotal > relatedPurchase.Total_Amount__c) {
                    pi.addError(
                        'Cannot restock more units than allowed by this purchase. ' +
                        'With this purchase amount, you can restock up to ' + allowedUnits + ' units.'
                    );
                }
            }
        }
    }
}
