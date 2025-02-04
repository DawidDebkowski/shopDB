package com.shopDB.dto;

import java.io.Serializable;

public class ProductDetailDTO implements Serializable {
    private String size;
    private int available;

    // Getters and setters
    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public int getAvailable() {
        return available;
    }

    public void setAvailable(int available) {
        this.available = available;
    }
}
