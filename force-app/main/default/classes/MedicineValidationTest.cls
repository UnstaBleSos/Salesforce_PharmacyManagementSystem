@isTest
public class MedicineValidationTest {

    @isTest
    static void testCategoryRequiredFails() {
        Medicine__c med = new Medicine__c(
            Name = 'Test Medicine',
            Stock__c = 10,
            Unit_Price__c = 20
        );

        Test.startTest();
        try {
            insert med;
            System.assert(false, 'Insert should fail for missing Category');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Category is required'));
        }
        Test.stopTest();
    }

    @isTest
    static void testMaxStockLimitFails() {
        Medicine__c med = new Medicine__c(
            Name = 'Test Medicine',
            Category__c = 'Tablet',
            Stock__c = 10001,
            Unit_Price__c = 20
        );

        Test.startTest();
        try {
            insert med;
            System.assert(false, 'Insert should fail for stock exceeding max limit');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Stock cannot exceed 10,00 units'));
        }
        Test.stopTest();
    }

    @isTest
    static void testStockNonNegativeFails() {
        Medicine__c med = new Medicine__c(
            Name = 'Test Medicine',
            Category__c = 'Tablet',
            Stock__c = -5,
            Unit_Price__c = 20
        );

        Test.startTest();
        try {
            insert med;
            System.assert(false, 'Insert should fail for negative stock');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Stock cannot be negative'));
        }
        Test.stopTest();
    }

    @isTest
    static void testStockNotDecimalFails() {
        Medicine__c med = new Medicine__c(
            Name = 'Test Medicine',
            Category__c = 'Tablet',
            Stock__c = 10.5,
            Unit_Price__c = 20
        );

        Test.startTest();
        try {
            insert med;
            System.assert(false, 'Insert should fail for decimal stock');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Stock Should not contain decimal'));
        }
        Test.stopTest();
    }

    @isTest
    static void testValidMedicinePasses() {
        Medicine__c med = new Medicine__c(
            Name = 'Test Medicine',
            Category__c = 'Tablet',
            Stock__c = 100,
            Unit_Price__c = 20
        );

        Test.startTest();
        insert med;
        Test.stopTest();

        med = [SELECT Id, Category__c, Stock__c FROM Medicine__c WHERE Id = :med.Id];
        System.assertEquals('Tablet', med.Category__c);
        System.assertEquals(100, med.Stock__c);
    }
}
