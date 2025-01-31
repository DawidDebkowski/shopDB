package com.shopDB.service;

import com.shopDB.entities.*;
import com.shopDB.entities.User;
import com.shopDB.entities.Warehouse;
import com.shopDB.repository.ClientRepository;
import com.shopDB.repository.OrderPoRepository;
import com.shopDB.repository.OrderRepository;
import com.shopDB.repository.WarehouseRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Klasa zarządza procedurami gdy aplikacji używa klient.
 */
@Service
public class ClientService {

    private final ClientRepository clientRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderPoRepository orderPoRepository;

    @Autowired
    private WarehouseRepository warehouseRepository;

    public ClientService(ClientRepository userRepository, ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    private String hashPassword(String plainTextPassword) {
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    @PersistenceContext
    private EntityManager entityManager;

    public String addClient(String login, String password, String type, String email, String phone, String NIP, Boolean cookies) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_client");

        query.registerStoredProcedureParameter("login", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("password", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("type", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("email", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("phone", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("NIP", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("cookies", Boolean.class, ParameterMode.IN);

        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        password = hashPassword(password);
        System.out.println("hashed password: " + password);

        query.setParameter("login", login);
        query.setParameter("password", password);
        query.setParameter("type", type);
        query.setParameter("email", email);
        query.setParameter("phone", phone);
        query.setParameter("NIP", NIP);
        query.setParameter("cookies", cookies);

        query.execute();

        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String changeAccInfoIndividual(int id, String name, String surname, String email, String phone) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("change_acc_info_individual");
        query.registerStoredProcedureParameter("id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("surname", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("email", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("phone", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("id", id);
        query.setParameter("name", name);
        query.setParameter("surname", surname);
        query.setParameter("email", email);
        query.setParameter("phone", phone);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String changeAccInfoCompany(int id, String companyName, String NIP, String email, String phone) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("change_acc_info_company");
        query.registerStoredProcedureParameter("id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("company_name", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("NIP", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("email", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("phone", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("id", id);
        query.setParameter("company_name", companyName);
        query.setParameter("NIP", NIP);
        query.setParameter("email", email);
        query.setParameter("phone", phone);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String changeAddress(int clientId, String street, Integer houseNumber, Integer apartmentNumber, String city, String postalCode) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("change_address");
        query.registerStoredProcedureParameter("client_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("street", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("house_number", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("apartment_number", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("city", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("postal_code", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("client_id", clientId);
        query.setParameter("street", street);
        query.setParameter("house_number", houseNumber);
        query.setParameter("apartment_number", apartmentNumber);
        query.setParameter("city", city);
        query.setParameter("postal_code", postalCode);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String addOrderPos(int clientId, int warehouseId, int amount) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_order_pos");
        query.registerStoredProcedureParameter("client_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("warehouse_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("amount", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("client_id", clientId);
        query.setParameter("warehouse_id", warehouseId);
        query.setParameter("amount", amount);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String editOrderPos(int clientId, int posId, int newAmount) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("edit_order_pos");
        query.registerStoredProcedureParameter("client_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("pos_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("new_amount", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("client_id", clientId);
        query.setParameter("pos_id", posId);
        query.setParameter("new_amount", newAmount);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String removeOrderPos(int clientId, int posId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("remove_order_pos");
        query.registerStoredProcedureParameter("client_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("pos_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("client_id", clientId);
        query.setParameter("pos_id", posId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String placeOrder(int clientId, boolean invoice) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("place_order");
        query.registerStoredProcedureParameter("client_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("invoice", Boolean.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("client_id", clientId);
        query.setParameter("invoice", invoice);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String payOrder(int orderId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pay_order");
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("order_id", orderId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String cancelOrder(int orderId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("cancel_order");
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("order_id", orderId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String reportReturn(int orderId) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("report_return");
        query.registerStoredProcedureParameter("order_id", Integer.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        query.setParameter("order_id", orderId);

        query.execute();
        return (String) query.getOutputParameterValue("exit_msg");
    }

    public String getTypebyUser(User user) {
        Client client = clientRepository.findByUser(user);
        if (client != null) {
            return client.getType();
        }
        return null;
    }

    public Integer getIdbyUser(User user) {
        Client client = clientRepository.findByUser(user);
        if (client != null) {
            return client.getId();
        }
        return null;
    }

    public Integer getCartId(Integer clientId) {
        return orderRepository.findCartId(clientRepository.findById(clientId));
    }

    public Integer getOrderPos(Integer clientId, Integer warehouseId) {
        Client client = clientRepository.findById(clientId);
        Order order = orderRepository.findById(orderRepository.findCartId(client)).get();
        Warehouse warehouse = warehouseRepository.findById(warehouseId).get();
        return orderPoRepository.findIdByData(order, warehouse);
    }

    public String getTypeFromId(Integer clientId) {
        Client client = clientRepository.findById(clientId);
        return client.getType();
    }
}