@isTest
public class PreventMedicineDeletion {
    
  @testSetup
static void setupData() {
  
    List<Medicine__c> meds = new List<Medicine__c>{
        new Medicine__c(
            Name = 'Paracetamol',
            Category__c = 'Tablet',
            Stock__c = 100,
            Unit_Price__c = 10
        ),
        new Medicine__c(
            Name = 'Ibuprofen',
            Category__c = 'Tablet',
            Stock__c = 50,
            Unit_Price__c = 15
        )
    };
    insert meds;

    Customer__c cust = new Customer__c(Name = 'Test Customer',Email__c='barsanewali@gmail.com', Phone__c = '9712345678');
    insert cust;

    Prescription__c presc = new Prescription__c(
        Customer__c = cust.Id,
        Date__c = Date.today()
    );
    insert presc;

    Sales_Item__c sale = new Sales_Item__c(
        Medicine__c = meds[0].Id,
        Prescription__c = presc.Id,
        Quantity__c = 5,
        Unit_Price__c = 100
    );
    insert sale;
}

    
    @isTest
    static void testPreventDeleteWithRelatedSales() {
        Medicine__c medWithSales = [
            SELECT Id, Name FROM Medicine__c WHERE Name = 'Paracetamol' LIMIT 1
        ];

        Test.startTest();
        try {
            delete medWithSales;
            System.assert(false, 'Expected deletion to fail, but it succeeded.');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Cannot delete Medicine'),
                'Error message not as expected: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testAllowDeleteWithoutRelatedSales() {
        Medicine__c medWithoutSales = [
            SELECT Id, Name FROM Medicine__c WHERE Name = 'Ibuprofen' LIMIT 1
        ];

        Test.startTest();
        delete medWithoutSales; 
        Test.stopTest();

        Integer countAfterDelete = [
            SELECT COUNT() FROM Medicine__c WHERE Name = 'Ibuprofen'
        ];
        System.assertEquals(0, countAfterDelete, 'Medicine without sales should have been deleted.');
    }
}
