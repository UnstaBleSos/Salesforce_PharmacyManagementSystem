import { LightningElement, wire } from 'lwc';
import getTotalMedicineStock from '@salesforce/apex/PharmacyDashboardController.getTotalMedicineStock';
import getTotalPurchasedQuantity from '@salesforce/apex/PharmacyDashboardController.getTotalPurchasedQuantity';
import getTotalSales from '@salesforce/apex/PharmacyDashboardController.getTotalSales';
import getTotalPurchases from '@salesforce/apex/PharmacyDashboardController.getTotalPurchases';

export default class RightRegion extends LightningElement {
    totalStock = 0;
    totalPurchased = 0;
    totalSales = 0;
    totalPur=0


    @wire(getTotalMedicineStock)
    wiredTotalStock({ error, data }) {
        if (data !== undefined) {
            this.totalStock = data;
        } else {
            console.error('Error getting total stock', error);
        }
    }

    @wire(getTotalPurchasedQuantity)
    wiredTotalPurchased({ error, data }) {
        if (data !== undefined) {
            this.totalPurchased = data;
        } else {
            console.error('Error getting total purchased quantity', error);
        }
    }
    
    @wire(getTotalSales)
    wiredTotalSales({error,data}){
        if(data !== undefined){
            this.totalSales = data;
        }else{
            console.error('Error getting total sales', error);
        }
    }

    @wire(getTotalPurchases)
    wireTotalPur({error,data}){
        if(data !== undefined){
            this.totalPur = data;
        }else{
            console.error("Error getting total Purchases",error);
        }
    }




}
