@isTest
public class CustomerValidationTest {

    @isTest
    static void testValidCustomer() {
        Customer__c cust = new Customer__c(
            Name = 'Valid Customer',
            Email__c = 'valid@example.com',
            Phone__c = '9712345678' 
        );

        Test.startTest();
        insert cust;
        Test.stopTest();

        System.assertNotEquals(null, cust.Id, 'Customer should be inserted successfully');
    }

    @isTest
    static void testEmailBlankFails() {
        Customer__c cust = new Customer__c(
            Name = 'Customer Email Blank',
            Email__c = '', 
            Phone__c = '9812345678'
        );

        Test.startTest();
        try {
            insert cust;
            System.assert(false, 'Expected failure when Email is blank');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Email cannot be blank'),
                'Unexpected error: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void testInvalidPhoneFails() {
        Customer__c cust = new Customer__c(
            Name = 'Customer Invalid Phone',
            Email__c = 'test@example.com',
            Phone__c = '8812345678' 
        );

        Test.startTest();
        try {
            insert cust;
            System.assert(false, 'Expected failure when phone is invalid');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Phone number must be exactly 10 digits'),
                'Unexpected error: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }
}
