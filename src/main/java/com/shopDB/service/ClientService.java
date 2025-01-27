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

    public String testClient(String in) {
        String mes = clientRepository.testClient(in, "hej");
        return mes;
    }

    @PersistenceContext
    private EntityManager entityManager;

    public String addClient(String login, String password, String type, String email, String phone, String NIP, Boolean cookies) {
        // Tworzymy zapytanie dla procedury
        StoredProcedureQuery query = entityManager.createStoredProcedureQuery("add_client");

        // Rejestrujemy parametry wejściowe (IN)
        query.registerStoredProcedureParameter("login", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("password", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("type", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("email", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("phone", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("NIP", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("cookies", Boolean.class, ParameterMode.IN);

        // Rejestrujemy parametr wyjściowy (OUT)
        query.registerStoredProcedureParameter("exit_msg", String.class, ParameterMode.OUT);

        // Ustawiamy wartości dla parametrów wejściowych
        query.setParameter("login", login);
        query.setParameter("password", password);
        query.setParameter("type", type);
        query.setParameter("email", email);
        query.setParameter("phone", phone);
        query.setParameter("NIP", NIP);
        query.setParameter("cookies", cookies);

        // Wykonujemy procedurę
        query.execute();

        // Pobieramy wartość z parametru wyjściowego (OUT)
        return (String) query.getOutputParameterValue("exit_msg");
    }

//    public String addClient(String login, String password, String accountType, String email, String phone, String nip, boolean cookies) {
//        password = hashPassword(password);
//        String[] mes = new String[5];
//        clientRepository.addClient(login, password, accountType, email, phone, nip, cookies, mes);
//        System.out.println(mes[0]);
//        System.out.println(mes[1]);
//        System.out.println(mes[2]);
//        System.out.println(mes[3]);
//        return login;
//    }
}