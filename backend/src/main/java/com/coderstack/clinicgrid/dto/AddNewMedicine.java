package com.coderstack.clinicgrid.dto;

import jakarta.validation.constraints.*;

import java.time.LocalDate;
import java.util.Date;

public class AddNewMedicine {

    @NotBlank(message = "Name is required")
    private String name;

    @Size(max = 500, message = "Description cannot exceed 500 characters")
    private String description;

    @Positive(message = "Price must be positive")
    private double price;

    @Min(value = 1, message = "Quantity must be at least 1")
    private int quantity;

    @NotBlank(message = "Type is required")
    private String type;

    @PositiveOrZero(message = "Weight must be zero or positive")
    private double weight;

    @Min(value = 1, message = "Quantity must be at least 1")
    private int itemsPerStack;

    @NotNull @Future(message = "Expiration date must be in the future")
    private LocalDate expiresOn;

    @PositiveOrZero(message = "Volume must be zero or positive")
    private double volume;

    public LocalDate getExpiresOn() {
        return expiresOn;
    }

    public void setExpiresOn(LocalDate expiresOn) {
        this.expiresOn = expiresOn;
    }

    public int getItemsPerStack() {
        return itemsPerStack;
    }

    public void setItemsPerStack(int itemsPerStack) {
        this.itemsPerStack = itemsPerStack;
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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public double getVolume() {
        return volume;
    }

    public void setVolume(double volume) {
        this.volume = volume;
    }
}
