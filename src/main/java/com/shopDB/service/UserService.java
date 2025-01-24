package com.shopDB.service;

import com.shopDB.entities.User;
import com.shopDB.repository.UserRepository;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import java.util.List;

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