package com.shopDB.service;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;

import java.sql.Blob;

import org.springframework.stereotype.Service;

/**
 * Klasa dla procedur Sprzedawcy
 * 
 * 13 proc
 */
@Service
public class SalesmanService {

    @PersistenceContext
    private EntityManager entityManager;

    public String addType(String type) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_type");
        query.registerStoredProcedureParameter("type", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("type", type);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String editType(int typeId, String type) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("edit_type");
        query.registerStoredProcedureParameter("type_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("type", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("type_id", typeId);
        query.setParameter("type", type);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String removeType(int typeId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("remove_type");
        query.registerStoredProcedureParameter("type_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("type_id", typeId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String addColor(String name, String code) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_color");
        query.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("code", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("name", name);
        query.setParameter("code", code);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String editColor(int colorId, String name, String code) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("edit_color");
        query.registerStoredProcedureParameter("color_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("code", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("color_id", colorId);
        query.setParameter("name", name);
        query.setParameter("code", code);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String removeColor(int colorId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("remove_color");
        query.registerStoredProcedureParameter("color_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("color_id", colorId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String addProduct(String name, String category, int typeId, int colorId, double price) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_product");
        query.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("category", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("type_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("color_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("price", Double.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("name", name);
        query.setParameter("category", category);
        query.setParameter("type_id", typeId);
        query.setParameter("color_id", colorId);
        query.setParameter("price", price);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String editProduct(int productId, String name, String category, int typeId, int colorId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("edit_product");
        query.registerStoredProcedureParameter("product_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("category", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("type_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("color_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("product_id", productId);
        query.setParameter("name", name);
        query.setParameter("category", category);
        query.setParameter("type_id", typeId);
        query.setParameter("color_id", colorId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String addPhoto(int productId, Blob photo) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_photo");
        query.registerStoredProcedureParameter("product_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("path", Blob.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("product_id", productId);
        query.setParameter("path", photo);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String removePhoto(int photoId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("remove_photo");
        query.registerStoredProcedureParameter("photo_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("photo_id", photoId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String changePrice(int productId, double newPrice) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("change_price");
        query.registerStoredProcedureParameter("product_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("new_price", Double.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("product_id", productId);
        query.setParameter("new_price", newPrice);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String changeDiscount(int productId, int newDiscount) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("change_discount");
        query.registerStoredProcedureParameter("product_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("new_discount", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("product_id", productId);
        query.setParameter("new_discount", newDiscount);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }
}
