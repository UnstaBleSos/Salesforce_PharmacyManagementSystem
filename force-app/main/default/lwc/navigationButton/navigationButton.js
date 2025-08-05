import { LightningElement, wire } from 'lwc';
import getUserProfileName from '@salesforce/apex/UserInfoController.getUserProfileName';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigationButtons extends NavigationMixin(LightningElement) {
    profileName;
    profileLoaded = false;

    isSystemAdmin = false;
    isStockManager = false;
    isSalesHandler = false;

    @wire(getUserProfileName)
    wiredProfile({ data, error }) {
        if (data) {
            this.profileName = data;
            this.profileLoaded = true;

            // Match profile names exactly as they are in your org
            this.isSystemAdmin = data === 'System Administrator';
            this.isStockManager = data === 'Stock Manager';
            this.isSalesHandler = data === 'Sales Handler';
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
                actionName: 'list'
            }
        });
    }
}
