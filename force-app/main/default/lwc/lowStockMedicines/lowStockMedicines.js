import { LightningElement, wire } from 'lwc';
import getLowStockMedicine from '@salesforce/apex/LowStockMedicineController.getLowStockMedicine';

export default class LowStockMedicines extends LightningElement {
    medicines;

    @wire(getLowStockMedicine)
    wiredMedicines({ error, data }) {
        if (data) {
            this.medicines = data;
        } else if (error) {
            console.error('Error fetching medicines:', error);
        }
    }

    get hasMedicines() {
        return this.medicines && this.medicines.length > 0;
    }
}
