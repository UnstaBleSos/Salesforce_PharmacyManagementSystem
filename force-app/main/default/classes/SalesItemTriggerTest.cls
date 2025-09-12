@isTest
public class SalesItemTriggerTest {

    @testSetup
    static void setupData() {
   
        List<Medicine__c> medicines = new List<Medicine__c>{
            new Medicine__c(Name = 'Paracetamol', Stock__c = 100, Unit_Price__c = 50, Category__c = 'Tablet'),
            new Medicine__c(Name = 'Ibuprofen', Stock__c = 10, Unit_Price__c = 75, Category__c = 'Tablet')
        };
        insert medicines;
    }

   @isTest
static void testSalesItemWithSufficientStock() {

    Customer__c cust = new Customer__c(
        Name = 'Test Customer',
        Email__c = 'test@example.com',
        Phone__c = '9712345678'
    );
    insert cust;

 
    Prescription__c pres = new Prescription__c(
        Customer__c = cust.Id,
        Date__c = Date.today()
    );
    insert pres;


    Medicine__c med = [SELECT Id, Stock__c, Unit_Price__c FROM Medicine__c WHERE Name='Paracetamol' LIMIT 1];

    Sales_Item__c sale = new Sales_Item__c(
        Medicine__c = med.Id,
        Prescription__c = pres.Id,
        Quantity__c = 20
    );

    Test.startTest();
    insert sale;
    Test.stopTest();

  
    sale = [SELECT Id, Unit_Price__c FROM Sales_Item__c WHERE Id = :sale.Id];
    System.assertEquals(med.Unit_Price__c, sale.Unit_Price__c, 'Unit Price should be populated from Medicine');
}


    @isTest
    static void testSalesItemWithInsufficientStock() {
        Medicine__c med = [SELECT Id, Stock__c FROM Medicine__c WHERE Name='Ibuprofen' LIMIT 1];

        Sales_Item__c sale = new Sales_Item__c(
            Medicine__c = med.Id,
            Quantity__c = 20 
        );

        Test.startTest();
        try {
            insert sale;
            System.assert(false, 'Expected insert to fail due to insufficient stock');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Cannot proceed'),
                'Error message did not contain expected text: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
static void testUpdateSalesItemUnitPrice() {
   
    Customer__c cust = new Customer__c(
        Name = 'Test Customer',
        Email__c = 'test@example.com',
        Phone__c = '9712345678'
    );
    insert cust;

   
    Prescription__c pres = new Prescription__c(
        Customer__c = cust.Id,
        Date__c = Date.today()
    );
    insert pres;

   
    Medicine__c med = [SELECT Id, Unit_Price__c FROM Medicine__c WHERE Name='Paracetamol' LIMIT 1];

   
    Sales_Item__c sale = new Sales_Item__c(
        Medicine__c = med.Id,
        Prescription__c = pres.Id,
        Quantity__c = 5
    );
    insert sale;

    
    sale.Quantity__c = 10;

    Test.startTest();
    update sale;
    Test.stopTest();

   
    sale = [SELECT Id, Unit_Price__c FROM Sales_Item__c WHERE Id = :sale.Id];
    System.assertEquals(med.Unit_Price__c, sale.Unit_Price__c, 'Unit Price should remain populated after update');
}

}
