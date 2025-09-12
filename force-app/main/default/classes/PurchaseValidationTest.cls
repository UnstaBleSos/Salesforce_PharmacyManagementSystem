@isTest
public class PurchaseValidationTest {
    @isTest
    static void testDateNotInFutureFails() {
        Purchase__c p = new Purchase__c(
            Supplier_Name__c = 'Test Supplier',
            Purchase_Date__c = Date.today().addDays(-1),
            Status__c = 'Pending',
            Total_Amount__c = 1000
        );

        Test.startTest();
        try {
            insert p;
            System.assert(false, 'Insert should fail for past date');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('date cannot be in the past'));
        }
        Test.stopTest();
    }
    @isTest
    static void testStatusChangeAfterCompletedFails() {
        Purchase__c p = new Purchase__c(
            Supplier_Name__c = 'Test Supplier',
            Purchase_Date__c = Date.today(),
            Status__c = 'Completed',
            Total_Amount__c = 1000
        );
        insert p;

        p.Status__c = 'Pending';

        Test.startTest();
        try {
            update p;
            System.assert(false, 'Update should fail for changing Completed status');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('cannot be changed once marked Completed'));
        }
        Test.stopTest();
    }
    @isTest
    static void testValidPurchasePasses() {
        Purchase__c p = new Purchase__c(
            Supplier_Name__c = 'Test Supplier',
            Purchase_Date__c = Date.today(),
            Status__c = 'Pending',
            Total_Amount__c = 1000
        );

        Test.startTest();
        insert p;
        Test.stopTest();

        p = [SELECT Id, Status__c FROM Purchase__c WHERE Id = :p.Id];
        System.assertEquals('Pending', p.Status__c);
    }
}
