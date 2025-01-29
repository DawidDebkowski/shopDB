package com.shopDB.dto;

import java.io.Serializable;

public class OrderDetailDTO implements Serializable {
    private String name;
    private String size;
    private double price;
    private Integer discount;
    private int amount;
    private double priceForOne;
    private double priceForAll;

    // Getters and setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(Integer discount) {
        this.discount = discount;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public double getPriceForOne() {
        return priceForOne;
    }

    public void setPriceForOne(double priceForOne) {
        this.priceForOne = priceForOne;
    }

    public double getPriceForAll() {
        return priceForAll;
    }

    public void setPriceForAll(double priceForAll) {
        this.priceForAll = priceForAll;
    }
}
