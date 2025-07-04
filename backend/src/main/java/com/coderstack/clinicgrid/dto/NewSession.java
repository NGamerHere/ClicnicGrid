package com.coderstack.clinicgrid.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.time.LocalDate;

public class NewSession {
    @NotNull(message = "treatment Id is required")
    @Positive(message = "the treatment ID need to be valid")
    private int treatmentId;

    public int getTreatmentId() {
        return treatmentId;
    }

    public void setTreatmentId(int treatmentId) {
        this.treatmentId = treatmentId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    @NotNull(message = "patient Id is required")
    @Positive(message = "the treatment ID need to be valid")
    private int patientId;

    @NotNull(message = "Start date is required")
    private LocalDate startDate;

}
