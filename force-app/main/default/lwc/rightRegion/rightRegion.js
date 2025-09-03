import { LightningElement, wire } from 'lwc';
import getTotalMedicineStock from '@salesforce/apex/PharmacyDashboardController.getTotalMedicineStock';
import getTotalPurchasedQuantity from '@salesforce/apex/PharmacyDashboardController.getTotalPurchasedQuantity';
import getTotalSales from '@salesforce/apex/PharmacyDashboardController.getTotalSales';
import getTotalPurchases from '@salesforce/apex/PharmacyDashboardController.getTotalPurchases';
import getStockByCategory from '@salesforce/apex/PharmacyDashboardController.getStockByCategory';

export default class RightRegion extends LightningElement {
    totalStock = 0;
    totalPurchased = 0;
    totalSales = 0;
    totalPur = 0;

    categoryStock = []; // Array to store category-wise stock

    dataLoaded = false;
    errorOccurred = false;

    checkIfAllLoaded() {
        if (
            this.totalStock !== null &&
            this.totalPurchased !== null &&
            this.totalSales !== null &&
            this.totalPur !== null &&
            this.categoryStock.length >= 0
        ) {
            this.dataLoaded = true;
        }
    }

    @wire(getTotalMedicineStock)
    wiredTotalStock({ error, data }) {
        if (data !== undefined) {
            this.totalStock = data;
        } else {
            console.error('Error getting total stock', error);
            this.errorOccurred = true;
        }
        this.checkIfAllLoaded();
    }

    @wire(getTotalPurchasedQuantity)
    wiredTotalPurchased({ error, data }) {
        if (data !== undefined) {
            this.totalPurchased = data;
        } else {
            console.error('Error getting total purchased quantity', error);
            this.errorOccurred = true;
        }
        this.checkIfAllLoaded();
    }

    @wire(getTotalSales)
    wiredTotalSales({ error, data }) {
        if (data !== undefined) {
            this.totalSales = data;
        } else {
            console.error('Error getting total sales', error);
            this.errorOccurred = true;
        }
        this.checkIfAllLoaded();
    }

    @wire(getTotalPurchases)
    wireTotalPur({ error, data }) {
        if (data !== undefined) {
            this.totalPur = data;
        } else {
            console.error('Error getting total Purchases', error);
            this.errorOccurred = true;
        }
        this.checkIfAllLoaded();
    }
    @wire(getStockByCategory)
    wiredStockByCategory({ error, data }) {
        if (data !== undefined) {
            this.categoryStock = data;
        } else {
            console.error('Error getting stock by category', error);
            this.errorOccurred = true;
        }
        this.checkIfAllLoaded();
    }

    

}
