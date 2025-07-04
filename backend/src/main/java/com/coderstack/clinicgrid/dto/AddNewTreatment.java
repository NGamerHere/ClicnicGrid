package com.coderstack.clinicgrid.dto;

import jakarta.validation.constraints.*;

public class AddNewTreatment {

    @NotBlank(message = "treatment name is required")
    private String name;
    @NotBlank(message = "treatment name is required")
    private String description;
    private Double basePrice;

    @Positive(message = "total price must be greater than 0")
    @NotNull(message = "Total price is required")
    private Double totalPrice;
    @Positive(message = "price per session must be greater than 0")
    @NotNull(message = "price per session is required")
    private Double pricePerSession;

    @Positive(message = "default Duration must be positive")
    private Integer defaultDuration;
    @Positive(message = "max Duration must be positive")
    private Integer maxDuration;
    @Positive(message = "total no of sessions must be greater than zero")
    @NotNull(message = "total no of sessions are required")
    private Integer totalSessions;

    @PositiveOrZero(message = "days Between Sessions must be greater than zero")
    @NotNull(message = "Days Between Sessions are required")
    private Integer daysBetweenSessions;

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(Double basePrice) {
        this.basePrice = basePrice;
    }

    public Integer getDefaultDuration() {
        return defaultDuration;
    }

    public void setDefaultDuration(Integer defaultDuration) {
        this.defaultDuration = defaultDuration;
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
}
