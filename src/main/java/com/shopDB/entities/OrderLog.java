package com.shopDB.entities;

import jakarta.persistence.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.time.Instant;

@Entity
@Table(name = "order_logs")
public class OrderLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "log_id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "order_id", nullable = false)
    private com.shopDB.entities.Order order;

    @Lob
    @Column(name = "old_status", nullable = false)
    private String oldStatus;

    @Lob
    @Column(name = "new_status", nullable = false)
    private String newStatus;

    @Column(name = "log_date", nullable = false)
    private Instant logDate;

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

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public Instant getLogDate() {
        return logDate;
    }

    public void setLogDate(Instant logDate) {
        this.logDate = logDate;
    }

}