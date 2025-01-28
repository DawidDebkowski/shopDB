package com.shopDB.service;

import com.shopDB.dto.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Service;

import java.util.List;

@SuppressWarnings("unchecked")
@Service
public class GeneralService {

    @PersistenceContext
    private EntityManager entityManager;

    public ClientInfoDTO showClientInfo(int clientId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_client_info", ClientInfoDTO.class);
        query.registerStoredProcedureParameter("client_id", Integer.class, ParameterMode.IN);

        query.setParameter("client_id", clientId);

        return (ClientInfoDTO) query.getSingleResult();
    }

    public List<ClientOrderDTO> showClientOrders(int clientId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_client_orders", ClientOrderDTO.class);
        query.registerStoredProcedureParameter("client_id", Integer.class, ParameterMode.IN);

        query.setParameter("client_id", clientId);

        return (List<ClientOrderDTO>) query.getResultList();
    }

    public List<OrderDetailDTO> showOrderDetails(int orderId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_order_details", OrderDetailDTO.class);
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);

        query.setParameter("order_id", orderId);

        return (List<OrderDetailDTO>) query.getResultList();
    }

    public List<OrderLogDTO> showOrderLogs(int orderId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_order_logs", OrderLogDTO.class);
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);

        query.setParameter("order_id", orderId);

        return (List<OrderLogDTO>) query.getResultList();
    }

    public InvoiceDTO showInvoice(int orderId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_invoice", InvoiceDTO.class);
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);

        query.setParameter("order_id", orderId);

        return (InvoiceDTO) query.getSingleResult();
    }

    public List<ProductDTO> showProducts(String category, String type, String color, double minPrice, double maxPrice, int orderBy) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_products", ProductDTO.class);
        query.registerStoredProcedureParameter("category", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("type", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("color", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("min_price", Double.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("max_price", Double.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("order_by", Integer.class, ParameterMode.IN);

        query.setParameter("category", category);
        query.setParameter("type", type);
        query.setParameter("color", color);
        query.setParameter("min_price", minPrice);
        query.setParameter("max_price", maxPrice);
        query.setParameter("order_by", orderBy);

        return (List<ProductDTO>) query.getResultList();
    }

    public List<ProductDetailDTO> showProductDetails(int productId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_product_details", ProductDetailDTO.class);
        query.registerStoredProcedureParameter("product_id", Integer.class, ParameterMode.IN);

        query.setParameter("product_id", productId);

        return (List<ProductDetailDTO>) query.getResultList();
    }

    public List<PaidOrderDTO> showPaidOrders() {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_paid_orders", PaidOrderDTO.class);

        return (List<PaidOrderDTO>) query.getResultList();
    }

    public List<ReportedReturnDTO> showReportedReturns() {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("show_reported_returns", ReportedReturnDTO.class);

        return (List<ReportedReturnDTO>) query.getResultList();
    }
}
