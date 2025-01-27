package com.shopDB.service;

import com.shopDB.entities.Client;
import com.shopDB.repository.ClientRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Klasa zarządza procedurami gdy aplikacji używa klient.
 */
@Service
public class ClientService {

    private final ClientRepository clientRepository;

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
}