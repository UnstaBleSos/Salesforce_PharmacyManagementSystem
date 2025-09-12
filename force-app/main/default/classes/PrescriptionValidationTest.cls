@isTest
public class PrescriptionValidationTest {

    @isTest
    static void testCustomerMustBeSelectedFails() {
        Prescription__c pres = new Prescription__c(
            Date__c = Date.today()
        );

        Test.startTest();
        try {
            insert pres;
            System.assert(false, 'Insert should fail when Customer is not selected');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Customer must be selected'));
        }
        Test.stopTest();
    }

    @isTest
    static void testDateNotInFutureFails() {
        Customer__c cust = new Customer__c(
            Name = 'Test Customer',
            Email__c = 'test@example.com',
            Phone__c = '9712345678'
        );
        insert cust;

        Prescription__c pres = new Prescription__c(
            Customer__c = cust.Id,
            Date__c = Date.today().addDays(1)
        );

        Test.startTest();
        try {
            insert pres;
            System.assert(false, 'Insert should fail for future date');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Prescription date cannot be in the future'));
        }
        Test.stopTest();
    }

    @isTest
    static void testValidPrescriptionPasses() {
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

        Test.startTest();
        insert pres;
        Test.stopTest();

        pres = [SELECT Id, Customer__c, Date__c FROM Prescription__c WHERE Id = :pres.Id];
        System.assertEquals(cust.Id, pres.Customer__c);
        System.assertEquals(Date.today(), pres.Date__c);
    }
}
