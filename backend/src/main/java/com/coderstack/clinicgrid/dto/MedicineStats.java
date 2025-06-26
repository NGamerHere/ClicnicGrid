package com.coderstack.clinicgrid.dto;

public interface MedicineStats {
    int getTotal();
    int getLowStock();
    int getExpired();
    int getOutOfStock();
}
