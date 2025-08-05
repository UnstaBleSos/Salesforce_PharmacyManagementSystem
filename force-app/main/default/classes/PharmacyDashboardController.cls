public without sharing class PharmacyDashboardController {

    @AuraEnabled(cacheable=true)
    public static Integer getTotalMedicineStock() {
        AggregateResult result = [SELECT SUM(Stock__c) totalStock FROM Medicine__c];
        if (result != null && result.get('totalStock') != null) {
            Integer total = ((Decimal)result.get('totalStock')).intValue();
            System.debug('### TOTAL STOCK (Medicine): ' + total);
            return total;
        } else {
            System.debug('### TOTAL STOCK (Medicine): 0');
            return 0;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalPurchasedQuantity() {
        AggregateResult result = [SELECT SUM(Quantity__c) totalQty FROM Purchase_Item__c];
        if (result != null && result.get('totalQty') != null) {
            Integer total = ((Decimal)result.get('totalQty')).intValue();
            System.debug('### TOTAL PURCHASED (Purchase_Item): ' + total);
            return total;
        } else {
            System.debug('### TOTAL PURCHASED (Purchase_Item): 0');
            return 0;
        }
    }
    @AuraEnabled(cacheable=true)
    public static Integer getTotalSales(){
        AggregateResult result = [Select Sum(Total__c) total From Sales_Item__c];
        if(result != null && result.get('total') != null){
            Integer total = ((Decimal)result.get('total')).intValue();
            return total;
        }
        return 0;
    }   

    @AuraEnabled(cacheable = true)
    public static Integer getTotalPurchases(){
        AggregateResult result = [Select Sum(Total_Amount__c) totalpur From Purchase__c];
        if(result != null && result.get('totalpur') != null){
            Integer total = ((Decimal)result.get('totalpur')).intValue();
            return total;
        }
        return 0;
    }
}
