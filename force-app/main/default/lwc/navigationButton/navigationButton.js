import { LightningElement, wire } from 'lwc';
import getUserProfileName from '@salesforce/apex/UserInfoController.getUserProfileName';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigationButtons extends NavigationMixin(LightningElement) {
    profileName;
    profileLoaded = false;

    isSystemAdmin = false;
    isStockManager = false;
    isSalesHandlerStaff = false;

    @wire(getUserProfileName)
    wiredProfile({ data, error }) {
        console.log('Raw profile name:', data); 
        if (data) {
            this.profileName = data;
            this.profileLoaded = true;

            this.isSystemAdmin = data === 'System Administrator';
            this.isStockManager = data === 'Stock Manager';
            this.isSalesHandlerStaff = data === 'SalesHandler Staff';

            console.log('Booleans:', this.isSystemAdmin, this.isStockManager, this.isSalesHandlerStaff);
   

        } else if (error) {
            console.error('Error getting user profile:', error);
        }
    }

    goToMedicines() {
        this.navigateTo('Medicine__c');
    }

    goToPurchases() {
        this.navigateTo('Purchase__c');
    }

    goToSalesItems() {
        this.navigateTo('Sales_Item__c');
    }

    goToPrescriptions() {
        this.navigateTo('Prescription__c');
    }
    goToCustomers() {
    this.navigateTo('Customer__c');
}

    
goToPurchaseItems() {
    this.navigateTo('Purchase_Item__c');
}

    navigateTo(objectApiName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: objectApiName,
                actionName: 'new'
            }
        });
    }
}
