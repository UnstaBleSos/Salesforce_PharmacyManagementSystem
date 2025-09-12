@isTest
public class PreventPrescriptionDeletionTest {

    @testSetup
    static void setupData() {
        
        Customer__c cust = new Customer__c(
            Name = 'Test Customer',
            Email__c = 'test@example.com',
            Phone__c = '9712345678'
        );
        insert cust;

        
        Medicine__c med1 = new Medicine__c(
            Name = 'Paracetamol',
            Category__c = 'Tablet',
            Stock__c = 100,
            Unit_Price__c = 10
        );
        Medicine__c med2 = new Medicine__c(
            Name = 'Ibuprofen',
            Category__c = 'Tablet',
            Stock__c = 50,
            Unit_Price__c = 15
        );
        insert new List<Medicine__c>{med1, med2};

       
        Prescription__c presc1 = new Prescription__c(
            Customer__c = cust.Id,
            Date__c = Date.today()
        );
        Prescription__c presc2 = new Prescription__c(
            Customer__c = cust.Id,
            Date__c = Date.today()
        );
        insert new List<Prescription__c>{presc1, presc2};

       
        Sales_Item__c sale = new Sales_Item__c(
            Medicine__c = med1.Id,
            Prescription__c = presc1.Id,
            Quantity__c = 5,
            Unit_Price__c = 100
        );
        insert sale;
    }

    @isTest
    static void testPreventDeleteWithRelatedSales() {
      
        Prescription__c presc = [
            SELECT Id, Name FROM Prescription__c LIMIT 1
        ];

        Test.startTest();
        try {
            delete presc;
            System.assert(false, 'Expected deletion to fail, but it succeeded.');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Cannot delete Prescription'),
                'Error message not as expected: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testAllowDeleteWithoutRelatedSales() {
       
        Prescription__c presc = [
            SELECT Id, Name FROM Prescription__c
            WHERE Id NOT IN (SELECT Prescription__c FROM Sales_Item__c)
            LIMIT 1
        ];

        Test.startTest();
        delete presc; 
        Test.stopTest();

        Integer countAfterDelete = [
            SELECT COUNT() FROM Prescription__c
            WHERE Id = :presc.Id
        ];
        System.assertEquals(0, countAfterDelete, 'Prescription without sales should have been deleted.');
    }
}
