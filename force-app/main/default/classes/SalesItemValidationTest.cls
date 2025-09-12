@isTest
public class SalesItemValidationTest {

    @isTest
    static void testMedicineMustBeSelectedFails() {
        Customer__c cust = new Customer__c(
            Name='Cust1', Email__c='test@example.com', Phone__c='9712345678'
        );
        insert cust;

        Prescription__c pres = new Prescription__c(
            Customer__c=cust.Id, Date__c=Date.today()
        );
        insert pres;

        Sales_Item__c si = new Sales_Item__c(
            Prescription__c = pres.Id,
            Quantity__c = 5,
            Unit_Price__c = 10
        );

        Test.startTest();
        try {
            insert si;
            System.assert(false, 'Insert should fail when Medicine is not selected');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Medicine must be selected'));
        }
        Test.stopTest();
    }

    @isTest
    static void testPrescriptionMustBeSelectedFails() {
        Medicine__c med = new Medicine__c(
            Name='Med1', Category__c='Tablet', Stock__c=100, Unit_Price__c=10
        );
        insert med;

        Sales_Item__c si = new Sales_Item__c(
            Medicine__c = med.Id,
            Quantity__c = 5,
            Unit_Price__c = 10
        );

        Test.startTest();
        try {
            insert si;
            System.assert(false, 'Insert should fail when Prescription is not selected');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Prescription must be selected'));
        }
        Test.stopTest();
    }

    @isTest
    static void testPreventOverSellingFails() {
        Medicine__c med = new Medicine__c(
            Name='Med2', Category__c='Tablet', Stock__c=10, Unit_Price__c=10
        );
        insert med;

        Customer__c cust = new Customer__c(
            Name='Cust2', Email__c='test2@example.com', Phone__c='9812345678'
        );
        insert cust;

        Prescription__c pres = new Prescription__c(
            Customer__c=cust.Id, Date__c=Date.today()
        );
        insert pres;

        Sales_Item__c si = new Sales_Item__c(
            Medicine__c = med.Id,
            Prescription__c = pres.Id,
            Quantity__c = 20 // exceeds stock
        );

        Test.startTest();
        try {
            insert si;
            System.assert(false, 'Insert should fail due to exceeding stock');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Cannot proceed: "Med2" has only 10 in stock'),
                'Unexpected error message: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testQuantityMustBePositiveFails() {
        Medicine__c med = new Medicine__c(
            Name='Med3', Category__c='Tablet', Stock__c=100, Unit_Price__c=10
        );
        insert med;

        Customer__c cust = new Customer__c(
            Name='Cust3', Email__c='test3@example.com', Phone__c='9712345678'
        );
        insert cust;

        Prescription__c pres = new Prescription__c(
            Customer__c=cust.Id, Date__c=Date.today()
        );
        insert pres;

        Sales_Item__c si = new Sales_Item__c(
            Medicine__c = med.Id,
            Prescription__c = pres.Id,
            Quantity__c = 0
        );

        Test.startTest();
        try {
            insert si;
            System.assert(false, 'Insert should fail due to zero quantity');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Quantity must be greater than zero'));
        }
        Test.stopTest();
    }

    @isTest
    static void testUnitPriceMustBePositiveFails() {
        Medicine__c med = new Medicine__c(
            Name='Med4', Category__c='Tablet', Stock__c=100, Unit_Price__c=0
        );
        insert med;

        Customer__c cust = new Customer__c(
            Name='Cust4', Email__c='test4@example.com', Phone__c='9812345678'
        );
        insert cust;

        Prescription__c pres = new Prescription__c(
            Customer__c=cust.Id, Date__c=Date.today()
        );
        insert pres;

        Sales_Item__c si = new Sales_Item__c(
            Medicine__c = med.Id,
            Prescription__c = pres.Id,
            Quantity__c = 5
        );

        Test.startTest();
        try {
            insert si;
            System.assert(false, 'Insert should fail due to zero unit price');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Unit price must be greater than zero'));
        }
        Test.stopTest();
    }

    @isTest
    static void testValidSalesItemPasses() {
        Medicine__c med = new Medicine__c(
            Name='Med5', Category__c='Tablet', Stock__c=100, Unit_Price__c=10
        );
        insert med;

        Customer__c cust = new Customer__c(
            Name='Cust5', Email__c='test5@example.com', Phone__c='9712345678'
        );
        insert cust;

        Prescription__c pres = new Prescription__c(
            Customer__c=cust.Id, Date__c=Date.today()
        );
        insert pres;

        Sales_Item__c si = new Sales_Item__c(
            Medicine__c = med.Id,
            Prescription__c = pres.Id,
            Quantity__c = 5
        );

        Test.startTest();
        insert si;
        Test.stopTest();

        si = [SELECT Id, Quantity__c, Unit_Price__c FROM Sales_Item__c WHERE Id = :si.Id];
        System.assertEquals(5, si.Quantity__c);
        System.assertEquals(10, si.Unit_Price__c);
    }
}
