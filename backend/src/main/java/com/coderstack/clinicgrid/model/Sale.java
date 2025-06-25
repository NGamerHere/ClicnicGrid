package com.coderstack.clinicgrid.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
public class Sale {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "hospital_id",nullable = false)
    @JsonIgnore
    private Hospital hospital;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id",nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "addedBy",nullable = false)
    private User doneBy;

    @OneToMany(mappedBy = "sale", cascade = CascadeType.ALL)
    private List<MedSale> medSales;

    private LocalDateTime paymentDoneOn;
    private double amount;

    public List<MedSale> getMedSales() {
        return medSales;
    }

    public void setMedSales(List<MedSale> medSales) {
        this.medSales = medSales;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Hospital getHospital() {
        return hospital;
    }

    public void setHospital(Hospital hospital) {
        this.hospital = hospital;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public User getDoneBy() {
        return doneBy;
    }

    public void setDoneBy(User doneBy) {
        this.doneBy = doneBy;
    }

    public LocalDateTime getPaymentDoneOn() {
        return paymentDoneOn;
    }

    public void setPaymentDoneOn(LocalDateTime paymentDoneOn) {
        this.paymentDoneOn = paymentDoneOn;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }
}
