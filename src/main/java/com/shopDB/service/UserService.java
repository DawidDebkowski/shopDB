package com.shopDB.service;

import com.shopDB.entities.User;
import com.shopDB.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Tego typu klasy zarządzają danymi, są pośrednikiem między
 * controllerem (widokiem) a bazą (resources)
 *
 * wiec tutaj wszelkie
 * "wez wszystkich userow bez loginu"
 * i inne kwerendy
 */
@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @PersistenceContext
    private EntityManager entityManager;

    public String authenticateUser(String login, String plainPassword) {
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("auth_user");

        query.registerStoredProcedureParameter("login", String.class, ParameterMode.IN);

        query.registerStoredProcedureParameter("password", String.class, ParameterMode.OUT);
        query.registerStoredProcedureParameter("acc_type", String.class, ParameterMode.OUT);

        query.setParameter("login", login);

        query.execute();

        String password = (String) query.getOutputParameterValue("password");
        String accType = (String) query.getOutputParameterValue("acc_type");

        if (accType == null) return null;

        if (BCrypt.checkpw(plainPassword, password)) {
            return accType;
        }
        return null;
    }
}