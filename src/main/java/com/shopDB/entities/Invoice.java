package com.shopDB.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "invoices")
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "invoice_id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "order_id", nullable = false)
    private com.shopDB.entities.Order order;

    @Column(name = "NIP", nullable = false, length = 10)
    private String nip;

    @Column(name = "company_name", nullable = false)
    private String companyName;

    @Column(name = "address_id", nullable = false)
    private Integer addressId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public com.shopDB.entities.Order getOrder() {
        return order;
    }

    public void setOrder(com.shopDB.entities.Order order) {
        this.order = order;
    }

    public String getNip() {
        return nip;
    }

    public void setNip(String nip) {
        this.nip = nip;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

}