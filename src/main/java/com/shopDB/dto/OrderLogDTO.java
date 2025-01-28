package com.shopDB.dto;

import java.util.Date;

public class OrderLogDTO {
    private String newStatus;
    private Date date;

    // Getters and setters
    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
