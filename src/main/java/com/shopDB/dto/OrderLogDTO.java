package com.shopDB.dto;

import java.io.Serializable;

public class OrderLogDTO implements Serializable {
    private String newStatus;
    private String date;

    // Getters and setters
    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
