package com.coderstack.clinicgrid.dto;

import java.util.List;

public class NewSale {
    private int patientId;
    private Double amount;

    private List<NewMedSale> medSales;

    public List<NewMedSale> getMedSales() {
        return medSales;
    }

    public void setMedSales(List<NewMedSale> medSales) {
        this.medSales = medSales;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }
}
