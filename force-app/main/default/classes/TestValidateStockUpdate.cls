@IsTest
public class TestValidateStockUpdate {
    @IsTest
    static void testSinglePurchaseValidAndInvalid() {
        
        Purchase__c purchase = new Purchase__c(
            Total_Amount__c = 3000
        );
        insert purchase;

        Purchase_Item__c validItem = new Purchase_Item__c(
            Purchase__c = purchase.Id,
            Unit_Price__c = 100,
            Quantity__c = 20 
        );
        insert validItem; 
        Purchase_Item__c invalidItem = new Purchase_Item__c(
            Purchase__c = purchase.Id,
            Unit_Price__c = 100,
            Quantity__c = 40 
        );

        try {
            insert invalidItem;
            System.assert(false, 'Expected exception not thrown.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot restock more units than allowed'), 
                          'Error message did not contain expected text: ' + e.getMessage());
        }
    }

    @IsTest
    static void testBulkInsert() {
        List<Purchase__c> purchases = new List<Purchase__c>();
        for(Integer i = 0; i < 5; i++) {
            purchases.add(new Purchase__c(Total_Amount__c = 1000 + i*100));
        }
        insert purchases;

        List<Purchase_Item__c> items = new List<Purchase_Item__c>();
        for(Purchase__c p : purchases) {
            items.add(new Purchase_Item__c(
                Purchase__c = p.Id,
                Unit_Price__c = 50,
                Quantity__c = 30 
            ));
        }

        try {
            insert items;
        } catch (DmlException e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
    }
}
