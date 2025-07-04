package com.coderstack.clinicgrid.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "treatments")
public class Treatment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String description;

    private Double totalPrice;
    private Double pricePerSession;
    private Integer defaultDuration;
    private Integer maxDuration;
    private Integer totalSessions;
    private Integer daysBetweenSessions;

    @ManyToOne
    @JsonIgnore
    private Hospital hospital;

    public Integer getDefaultDuration() {
        return defaultDuration;
    }

    public void setDefaultDuration(Integer defaultDuration) {
        this.defaultDuration = defaultDuration;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getMaxDuration() {
        return maxDuration;
    }

    public void setMaxDuration(Integer maxDuration) {
        this.maxDuration = maxDuration;
    }

    public Integer getTotalSessions() {
        return totalSessions;
    }

    public void setTotalSessions(Integer totalSessions) {
        this.totalSessions = totalSessions;
    }

    public Hospital getHospital() {
        return hospital;
    }

    public void setHospital(Hospital hospital) {
        this.hospital = hospital;
    }
    public Integer getDaysBetweenSessions() {
        return daysBetweenSessions;
    }

    public void setDaysBetweenSessions(Integer daysBetweenSessions) {
        this.daysBetweenSessions = daysBetweenSessions;
    }

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Double getPricePerSession() {
        return pricePerSession;
    }

    public void setPricePerSession(Double pricePerSession) {
        this.pricePerSession = pricePerSession;
    }
}
