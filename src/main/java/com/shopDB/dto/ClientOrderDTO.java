package com.shopDB.dto;

import java.io.Serializable;

public class ClientOrderDTO implements Serializable {
    private int orderId;
    private String status;
    private double value;

    // Getters and setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }
}
