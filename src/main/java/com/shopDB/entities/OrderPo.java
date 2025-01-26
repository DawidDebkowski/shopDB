package com.shopDB.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "order_pos")
public class OrderPo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pos_id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "order_id", nullable = false)
    private com.shopDB.entities.Order order;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "warehouse_id", nullable = false)
    private com.shopDB.entities.Warehouse warehouse;

    @Column(name = "amount", nullable = false)
    private Integer amount;

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

    public com.shopDB.entities.Warehouse getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(com.shopDB.entities.Warehouse warehouse) {
        this.warehouse = warehouse;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

}