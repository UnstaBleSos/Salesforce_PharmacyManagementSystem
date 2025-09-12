@isTest
public class LowStockMedicineControllerTest {

    @testSetup
    static void setupData() {
        // Medicines with varying stock
        List<Medicine__c> meds = new List<Medicine__c>();
        meds.add(new Medicine__c(Name='MedLow1', Stock__c=5, Category__c='Tablet'));
        meds.add(new Medicine__c(Name='MedLow2', Stock__c=2, Category__c='Injection'));
        meds.add(new Medicine__c(Name='MedHigh', Stock__c=50, Category__c='Syrup'));
        insert meds;
    }

    @isTest
    static void testGetLowStockMedicine() {
        Test.startTest();
        List<Medicine__c> lowStock = LowStockMedicineController.getLowStockMedicine();
        Test.stopTest();

        System.assertEquals(2, lowStock.size(), 'Should return only medicines with stock < 10');
        for(Medicine__c med : lowStock){
            System.assert(med.Stock__c < 10, 'Medicine stock should be less than 10');
        }
    }
}
