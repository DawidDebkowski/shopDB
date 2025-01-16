package com.shopDB.service;

import com.shopDB.entities.User;
import com.shopDB.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User saveUser(String login, String password, String accountType) {
        User user = new User();
        user.setLogin(login);
        user.setPassword(password);
        user.setAccType(accountType);
        return userRepository.save(user);
    }
}