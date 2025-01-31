package com.shopDB.service;

import com.shopDB.dto.*;
import com.shopDB.entities.*;
import com.shopDB.repository.*;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Blob;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("unchecked")
@Service
public class GeneralService {

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private ProductColorRepository productColorRepository;

    @Autowired
    private ProductTypeRepository productTypeRepository;
    
    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private WarehouseRepository warehouseRepository;

    @Autowired
    private PhotoRepository photoRepository;

    public ClientInfoDTO showClientInfo(int clientId) {
        Query query = entityManager.createNativeQuery("CALL show_client_info(:client_id)");
        query.setParameter("client_id", clientId);

        Object[] object = (Object[]) query.getSingleResult();
        ClientInfoDTO result = new ClientInfoDTO();
        try {result.setName((String) object[0]);} catch(Exception e) {}
        try {result.setSurname((String) object[1]);} catch(Exception e) {}
        try {result.setCompanyName((String) object[2]);} catch(Exception e) {}
        try {result.setEmail((String) object[3]);} catch(Exception e) {}
        try {result.setPhone((String) object[4]);} catch(Exception e) {}
        try {result.setNIP((String) object[5]);} catch(Exception e) {}
        try {result.setStreet((String) object[6]);} catch(Exception e) {}
        try {result.setHouseNumber((Integer) object[7]);} catch(Exception e) {}
        try {result.setApartmentNumber((Integer) object[8]);} catch(Exception e) {}
        try {result.setCity((String) object[9]);} catch(Exception e) {}
        try {result.setPostalCode((String) object[10]);} catch(Exception e) {}

        return result;
    }

    public List<ClientOrderDTO> showClientOrders(int clientId) {
        Query query = entityManager.createNativeQuery("CALL show_client_orders(:client_id)");
        query.setParameter("client_id", clientId);

        List<Object[]> results = query.getResultList();
        return results.stream().map(object -> {
            ClientOrderDTO dto = new ClientOrderDTO();
            try {dto.setOrderId((Integer) object[0]);} catch(Exception e) {}
            try {dto.setStatus((String) object[1]);} catch(Exception e) {}
            try {dto.setValue((Double) object[2]);} catch(Exception e) {}
            return dto;
        }).toList();
    }

    public List<OrderDetailDTO> showOrderDetails(int orderId) {
        Query query = entityManager.createNativeQuery("CALL show_order_details(:order_id)");
        query.setParameter("order_id", orderId);

        List<Object[]> results = query.getResultList();
        return results.stream().map(object -> {
            OrderDetailDTO dto = new OrderDetailDTO();
            try {dto.setProductId(Integer.parseInt(object[0].toString()));} catch(Exception e) {}
            try {dto.setName((String) object[1]);} catch(Exception e) {}
            try {dto.setSize((String) object[2]);} catch(Exception e) {}
            try {dto.setPrice(Double.parseDouble(object[3].toString()));} catch(Exception e) {}
            try {dto.setDiscount(Integer.parseInt(object[4].toString()));} catch(Exception e) {}
            try {dto.setAmount(Integer.parseInt(object[5].toString()));} catch(Exception e) {}
            try {dto.setPriceForOne(Double.parseDouble(object[6].toString()));} catch(Exception e) {}
            try {dto.setPriceForAll(Double.parseDouble(object[7].toString()));} catch(Exception e) {}
            return dto;
        }).toList();
    }

    public List<OrderLogDTO> showOrderLogs(int orderId) {
        Query query = entityManager.createNativeQuery("CALL show_order_logs(:order_id)");
        query.setParameter("order_id", orderId);

        List<Object[]> results = query.getResultList();
        return results.stream().map(object -> {
            OrderLogDTO dto = new OrderLogDTO();
            try {dto.setNewStatus((String) object[0]);} catch(Exception e) {}
            try {dto.setDate((String) object[1]);} catch(Exception e) {}
            return dto;
        }).toList();
    }


    // TODO: to
    public InvoiceDTO showInvoice(int orderId) {
        Query query = entityManager.createNativeQuery("CALL show_invoice(:order_id)");
        query.setParameter("order_id", orderId);

        // Object[] object = (Object[]) query.getSingleResult();
        // InvoiceDTO result = new InvoiceDTO();
        // try {result.setInvoiceId((Integer) object[0]);} catch(Exception e) {}
        // try {result.setOrderId((Integer) object[1]);} catch(Exception e) {}
        // try {result.setInvoiceDate((String) object[2]);} catch(Exception e) {}
        // try {result.setNIP((String) object[3]);} catch(Exception e) {}
        // try {result.setCompanyName((String) object[4]);} catch(Exception e) {}
        // try {result.setAddress((String) object[5]);} catch(Exception e) {}

        // return result;
        return null;
    }

    public List<ProductDTO> showProducts(String category, String type, String color, Double minPrice, Double maxPrice, int orderBy) {
        Query query = entityManager.createNativeQuery("CALL show_products(:category, :type, :color, :min_price, :max_price, :order_by)");
        query.setParameter("category", category);
        query.setParameter("type", type);
        query.setParameter("color", color);
        query.setParameter("min_price", minPrice);
        query.setParameter("max_price", maxPrice);
        query.setParameter("order_by", orderBy);

        List<Object[]> queryResult = query.getResultList();
        return queryResult.stream().map(object -> {
            ProductDTO dto = new ProductDTO();
            try {dto.setProductId((Integer) object[0]);} catch(Exception e) {}
            try {dto.setName((String) object[1]);} catch(Exception e) {}
            try {dto.setCategory((String) object[2]);} catch(Exception e) {}
            try {dto.setType((String) object[3]);} catch(Exception e) {}
            try {dto.setColor((String) object[4]);} catch(Exception e) {}
            try {dto.setPrice(Double.parseDouble(object[5].toString()));} catch(Exception e) {}
            try {dto.setDiscount((Integer) object[6]);} catch(Exception e) {}
            return dto;
        }).toList();
    }

    public List<ProductDetailDTO> showProductDetails(int productId) {
        Query query = entityManager.createNativeQuery("CALL show_product_details(:product_id)");
        query.setParameter("product_id", productId);

        List<Object[]> results = query.getResultList();
        return results.stream().map(object -> {
            ProductDetailDTO dto = new ProductDetailDTO();
            try {dto.setSize((String) object[0]);} catch(Exception e) {}
            try {dto.setAvailable(Integer.parseInt(object[1].toString()));} catch(Exception e) {}
            return dto;
        }).toList();
    }

    public List<PaidOrderDTO> showPaidOrders() {
        Query query = entityManager.createNativeQuery("CALL show_paid_orders()");

        List<Object[]> results = query.getResultList();
        return results.stream().map(object -> {
            PaidOrderDTO dto = new PaidOrderDTO();
            try {dto.setOrderId((Integer) object[0]);} catch(Exception e) {}
            return dto;
        }).toList();
    }

    public List<ReportedReturnDTO> showReportedReturns() {
        Query query = entityManager.createNativeQuery("CALL show_reported_returns()");

        List<Object[]> results = query.getResultList();
        return results.stream().map(object -> {
            ReportedReturnDTO dto = new ReportedReturnDTO();
            try {dto.setOrderId((Integer) object[0]);} catch(Exception e) {}
            return dto;
        }).toList();
    }

    public ObservableList<String> getAllColors() {
        List<ProductColor> list = productColorRepository.findAll();
        ObservableList<String> result = FXCollections.observableArrayList();

        for (ProductColor color : list) result.add(color.getName());
        return result;
    }

    public List<String> getAllTypes() {
        List<ProductType> list = productTypeRepository.findAll();
        List<String> result = new ArrayList<String>();

        for (ProductType type : list) result.add(type.getType());
        return result;
    }

    public Integer getProductId(String name, String category, String type, String color) {
        Integer typeId = productTypeRepository.getIdFromName(type);
        Integer colorId = productColorRepository.getIdFromName(color);
        return productRepository.getIdFromData(name, category, typeId, colorId);
    }

    public Integer getWarehouseId(Integer productId, String size) {
        Product product = productRepository.findById(productId).get();
        return warehouseRepository.getIdByData(product, size);
    }

    public Blob getPhotoFromProductId(Integer productId) {
        Product product = productRepository.findById(productId).get();
        return photoRepository.findByProduct(product);
    }
}
