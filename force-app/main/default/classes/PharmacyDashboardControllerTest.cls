@isTest
public class PharmacyDashboardControllerTest {

    @testSetup
    static void setupData() {
        // Medicines
        List<Medicine__c> meds = new List<Medicine__c>{
            new Medicine__c(Name='Med1', Stock__c=10, Category__c='Tablet'),
            new Medicine__c(Name='Med2', Stock__c=20, Category__c='Syrup'),
            new Medicine__c(Name='Med3', Stock__c=15, Category__c='Injection')
        };
        insert meds;

        // Customers
        Customer__c cust1 = new Customer__c(Name='Cust1', Email__c='cust1@example.com', Phone__c='9712345678');
        insert cust1;

        // Prescriptions
        Prescription__c pres1 = new Prescription__c(Customer__c=cust1.Id, Date__c=Date.today());
        Prescription__c pres2 = new Prescription__c(Customer__c=cust1.Id, Date__c=Date.today());
        insert new List<Prescription__c>{pres1, pres2};

        // Purchases
        Purchase__c pur1 = new Purchase__c(Purchase_Date__c=Date.today(), Supplier_Name__c='Sup1', Total_Amount__c=1000, Status__c='Pending');
        insert pur1;

        // Purchase Items
        List<Purchase_Item__c> pItems = new List<Purchase_Item__c>{
            new Purchase_Item__c(Purchase__c=pur1.Id, Medicine__c=meds[0].Id, Quantity__c=5, Unit_Price__c=10),
            new Purchase_Item__c(Purchase__c=pur1.Id, Medicine__c=meds[1].Id, Quantity__c=10, Unit_Price__c=20)
        };
        insert pItems;

        // Sales Items referencing valid Prescription__c
        List<Sales_Item__c> sItems = new List<Sales_Item__c>{
            new Sales_Item__c(Prescription__c=pres1.Id, Medicine__c=meds[0].Id, Quantity__c=2, Unit_Price__c=10),
            new Sales_Item__c(Prescription__c=pres1.Id, Medicine__c=meds[1].Id, Quantity__c=5, Unit_Price__c=20)
        };
        insert sItems;
    }

   @isTest
static void testGetTotalMedicineStock() {
    List<Medicine__c> meds = [SELECT Stock__c FROM Medicine__c WHERE Name IN ('Med1','Med2','Med3')];
Integer expectedTotal = 0;
for(Medicine__c m : meds) {
    expectedTotal += m.Stock__c != null ? ((Decimal)m.Stock__c).intValue() : 0;
}

Test.startTest();
Integer totalStock = PharmacyDashboardController.getTotalMedicineStock();
Test.stopTest();
System.assertEquals(expectedTotal, totalStock, 'Total stock should match sum of inserted medicine stocks');

}


    @isTest
    static void testGetTotalPurchasedQuantity() {
        Test.startTest();
        Integer totalPurchased = PharmacyDashboardController.getTotalPurchasedQuantity();
        Test.stopTest();
        System.assertEquals(15, totalPurchased);
    }

    @isTest
    static void testGetTotalSales() {
        Test.startTest();
        Integer totalSales = PharmacyDashboardController.getTotalSales();
        Test.stopTest();
        // Total__c is formula: Quantity__c * Unit_Price__c => 2*10 + 5*20 = 120
        System.assertEquals(120, totalSales);
    }

    @isTest
    static void testGetTotalPurchases() {
        Test.startTest();
        Integer totalPurchases = PharmacyDashboardController.getTotalPurchases();
        Test.stopTest();
        System.assertEquals(1000, totalPurchases);
    }

    @isTest
    static void testGetStockByCategory() {
        Test.startTest();
        List<PharmacyDashboardController.CategoryStockDTO> stockByCategory = PharmacyDashboardController.getStockByCategory();
        Test.stopTest();

        System.assertEquals(3, stockByCategory.size());
        for (PharmacyDashboardController.CategoryStockDTO row : stockByCategory) {
            System.assert(row.totalStock > 0);
            System.assertNotEquals(null, row.category);
        }
    }
}
