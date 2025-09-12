@isTest
public class PurchaseItemValidationTest {

  
    private static Purchase__c createPurchase() {
        Purchase__c p = new Purchase__c(
            Supplier_Name__c = 'Test Supplier',
            Purchase_Date__c = Date.today().addDays(1), 
            Status__c = 'Pending',
            Total_Amount__c = 1000
        );
        insert p;
        return p;
    }

    
    private static Medicine__c createMedicine() {
        Medicine__c m = new Medicine__c(
            Name = 'Test Medicine',
            Category__c = 'Tablet',
            Stock__c = 50,
            Unit_Price__c = 20
        );
        insert m;
        return m;
    }

    @isTest
    static void testDecimalQuantityFails() {
        Purchase__c p = createPurchase();
        Medicine__c m = createMedicine();

        Purchase_Item__c pi = new Purchase_Item__c(
            Purchase__c = p.Id,
            Medicine__c = m.Id,
            Quantity__c = 10.5 
        );

        Test.startTest();
        try {
            insert pi;
            System.assert(false, 'Insert should have failed due to validation rule.');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Quantity should not be decimal'),
                'Unexpected error: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testWholeNumberQuantityPasses() {
        Purchase__c p = createPurchase();
        Medicine__c m = createMedicine();

        Purchase_Item__c pi = new Purchase_Item__c(
            Purchase__c = p.Id,
            Medicine__c = m.Id,
            Quantity__c = 10 
        );

        Test.startTest();
        insert pi; 
        Test.stopTest();

     
        pi = [SELECT Id, Quantity__c FROM Purchase_Item__c WHERE Id = :pi.Id];
        System.assertEquals(10, pi.Quantity__c, 'Quantity should have been saved correctly.');
    }
}
