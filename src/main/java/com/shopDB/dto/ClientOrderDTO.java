package com.shopDB.dto;

import java.io.Serializable;

public class ClientOrderDTO implements Serializable {
    private Integer orderId;
    private String status;
    private double value;

    @Override
    public String toString() {
        return "id: " + orderId + ", status: " + status + ", value: " + value;
    }

    // Getters and setters
    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
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
