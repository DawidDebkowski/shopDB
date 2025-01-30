package com.shopDB.dto;

import java.io.Serializable;

public class ProductDTO implements Serializable {
    private int productId;
    private String name;
    private String category;
    private String type;
    private String color;
    private Double price;
    private Integer discount;

    public static ProductDTO getMockWithName(String mniejSuperKurtka, double v) {
        ProductDTO dto = new ProductDTO();
        dto.setProductId(1);
        dto.setName(mniejSuperKurtka);
        dto.setPrice(v);
        dto.setCategory("brak");
        dto.setType("brak typu");
        dto.setDiscount(2);
        return dto;
    }

    // Getters and setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(Integer discount) {
        this.discount = discount;
    }
}
