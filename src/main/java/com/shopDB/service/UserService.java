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
        // Tworzymy zapytanie dla procedury
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("auth_user");

        // Rejestrujemy parametr wejściowy (IN)
        query.registerStoredProcedureParameter("login", String.class, ParameterMode.IN);

        // Rejestrujemy parametry wyjściowe (OUT)
        query.registerStoredProcedureParameter("password", String.class, ParameterMode.OUT);
        query.registerStoredProcedureParameter("acc_type", String.class, ParameterMode.OUT);

        // Ustawiamy wartość parametru wejściowego
        query.setParameter("login", login);

        // Wykonujemy procedurę
        query.execute();

        // Pobieramy wartości parametrów wyjściowych
        String password = (String) query.getOutputParameterValue("password");
        String accType = (String) query.getOutputParameterValue("acc_type");

        if(accType == null) return null;

        if(BCrypt.checkpw(plainPassword, password)) {
            return accType;
        }
        return null;
    }

    private String hashPassword(String plainTextPassword){
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    public boolean authenticate(String login, String password) {
        password = hashPassword(password);
        return userRepository.authenticateUser(login, password);
    }

    public User saveUser(String login, String password, String accountType) {
        User user = new User();
        user.setLogin(login);
        user.setPassword(password);
        user.setAccType(accountType);
        return userRepository.save(user);
    }
}