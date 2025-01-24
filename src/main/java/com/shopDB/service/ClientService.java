package com.shopDB.service;

import com.shopDB.entities.Client;
import com.shopDB.repository.ClientRepository;
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
public class ClientService {

    private final ClientRepository clientRepository;

    public ClientService(ClientRepository userRepository, ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    public List<Client> getAllClients() {
        return clientRepository.findAll();
    }

    private String hashPassword(String plainTextPassword){
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    private boolean checkPass(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    public void addClient(String login, String password, String accountType, String email, String phone, boolean cookies) {
        password = hashPassword(password);
        clientRepository.addClient(login, password, accountType, email, phone, cookies);
    }
}