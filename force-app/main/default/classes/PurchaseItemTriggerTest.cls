@isTest
public class PurchaseItemTriggerTest {

    @testSetup
    static void setupData() {

       
        List<Medicine__c> medicines = new List<Medicine__c>{
            new Medicine__c(
                Name = 'Paracetamol',
                Category__c = 'Tablet',
                Stock__c = 100,
                Unit_Price__c = 50
            ),
            new Medicine__c(
                Name = 'Ibuprofen',
                Category__c = 'Tablet',
                Stock__c = 50,
                Unit_Price__c = 75
            )
        };
        insert medicines;

        Customer__c cust = new Customer__c(
            Name = 'Test Customer',
            Email__c = 'test@example.com',
            Phone__c = '9712345678'
        );
        insert cust;

        Prescription__c prescriptionWithSales = new Prescription__c(
            Customer__c = cust.Id,
            Date__c = Date.today()
        );
        insert prescriptionWithSales;

        Prescription__c prescriptionWithoutSales = new Prescription__c(
            Customer__c = cust.Id,
            Date__c = Date.today()
        );
        insert prescriptionWithoutSales;

        Sales_Item__c sale = new Sales_Item__c(
            Medicine__c = medicines[0].Id,
            Prescription__c = prescriptionWithSales.Id,
            Quantity__c = 10,
            Unit_Price__c = medicines[0].Unit_Price__c
        );
        insert sale;

        Purchase__c purchase = new Purchase__c(
            Purchase_Date__c = Date.today(),
            Total_Amount__c = 1000
        );
        insert purchase;
    }

    @isTest
    static void testPreventMedicineDeletion() {
        Medicine__c medWithSales = [SELECT Id FROM Medicine__c WHERE Name='Paracetamol' LIMIT 1];
        Medicine__c medWithoutSales = [SELECT Id FROM Medicine__c WHERE Name='Ibuprofen' LIMIT 1];

        try {
            delete medWithSales;
            System.assert(false, 'Deletion should fail for medicine with sales');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot delete Medicine'));
        }

        // Deletion should succeed for medicine without sales
        delete medWithoutSales;
        Integer countAfterDelete = [SELECT COUNT() FROM Medicine__c WHERE Id = :medWithoutSales.Id];
        System.assertEquals(0, countAfterDelete, 'Medicine without sales should be deleted');
    }

    @isTest
    static void testPreventPrescriptionDeletion() {
      
        Prescription__c presWithSales = [SELECT Id FROM Prescription__c LIMIT 1];

        try {
            delete presWithSales;
            System.assert(false, 'Deletion should fail for prescription with related sales items');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Cannot delete Prescription'),
                'Unexpected error message: ' + e.getMessage()
            );
        }

        
        Prescription__c presWithoutSales = [
            SELECT Id 
            FROM Prescription__c 
            WHERE Id NOT IN (SELECT Prescription__c FROM Sales_Item__c)
            LIMIT 1
        ];
        delete presWithoutSales;
        Integer countAfterDelete = [SELECT COUNT() FROM Prescription__c WHERE Id = :presWithoutSales.Id];
        System.assertEquals(0, countAfterDelete, 'Prescription without sales should be deleted');
    }

    @isTest
    static void testPurchaseItemTriggerInsert() {
        Medicine__c med = [SELECT Id, Unit_Price__c FROM Medicine__c WHERE Name='Paracetamol' LIMIT 1];
        Purchase__c purchase = [SELECT Id, Total_Amount__c FROM Purchase__c LIMIT 1];

        Purchase_Item__c pi = new Purchase_Item__c(
            Medicine__c = med.Id,
            Quantity__c = 10,
            Purchase__c = purchase.Id,
            Unit_Price__c = med.Unit_Price__c
        );

        Test.startTest();
        insert pi;
        Test.stopTest();

        pi = [SELECT Id, Unit_Price__c FROM Purchase_Item__c WHERE Id = :pi.Id];
        System.assertEquals(med.Unit_Price__c, pi.Unit_Price__c, 'Unit Price should populate from Medicine');
    }

    @isTest
    static void testPurchaseItemTriggerUpdate() {
        Medicine__c med = [SELECT Id, Unit_Price__c FROM Medicine__c WHERE Name='Ibuprofen' LIMIT 1];
        Purchase__c purchase = [SELECT Id, Total_Amount__c FROM Purchase__c LIMIT 1];

        Purchase_Item__c pi = new Purchase_Item__c(
            Medicine__c = med.Id,
            Quantity__c = 5,
            Purchase__c = purchase.Id,
            Unit_Price__c = med.Unit_Price__c
        );
        insert pi;

        Medicine__c newMed = [SELECT Id, Unit_Price__c FROM Medicine__c WHERE Name='Paracetamol' LIMIT 1];
        pi.Medicine__c = newMed.Id;

        Test.startTest();
        update pi;
        Test.stopTest();

        pi = [SELECT Id, Unit_Price__c FROM Purchase_Item__c WHERE Id = :pi.Id];
        System.assertEquals(newMed.Unit_Price__c, pi.Unit_Price__c, 'Unit Price should update from new Medicine');
    }
}
