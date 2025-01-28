package com.shopDB.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Service;

/**
 * Klasa dla procedur Magazyniera
 * 
 * 4 proc
 */
@Service
public class WarehouseService {

    @PersistenceContext
    private EntityManager entityManager;

    public String addWarehouse(int productId, String size, int amount) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_warehouse");
        query.registerStoredProcedureParameter("product_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("size", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("amount", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("product_id", productId);
        query.setParameter("size", size);
        query.setParameter("amount", amount);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String editWarehouse(int warehouseId, int amount) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("edit_warehouse");
        query.registerStoredProcedureParameter("warehouse_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("amount", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("warehouse_id", warehouseId);
        query.setParameter("amount", amount);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String completeOrder(int orderId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("complete_order");
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("order_id", orderId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String considerReturn(int orderId, boolean accept) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("consider_return");
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("accept", Boolean.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("order_id", orderId);
        query.setParameter("accept", accept);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }
}
