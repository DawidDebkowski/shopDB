package com.shopDB.dto;

import java.io.Serializable;

public class PaidOrderDTO implements Serializable {
    private int orderId;

    // Getters and setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
}
