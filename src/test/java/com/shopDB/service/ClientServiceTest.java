package com.shopDB.service;

import com.shopDB.repository.ClientRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class ClientServiceTest {

    @Autowired
    private ClientService clientService;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private ClientRepository clientRepository;

    @BeforeAll
    @Transactional
    @Rollback(false)
    static void setUp(@Autowired ClientService clientService) {
        clientService.addClient("testLogin", "testPassword", "individual", "test@example.com", "123456789", "1234567890", true);
        clientService.addClient("existingLogin", "testPassword", "individual", "tes1t@example.com", "123256789", "1234567890", true);
    }

    @Test
    @Transactional
    @Rollback
    void testAddClientValidData() {
        String result = clientService.addClient("validLogin", "validPassword", "individual", "valid@example.com", "923456789", "1234567890", true);
        assertEquals("Dodano nowego klienta: validLogin.", result);
    }

    @Test
    @Transactional
    @Rollback
    void testAddClientInvalidData() {
        clientService.addClient("existingLogin", "validPassword", "individual", "valid@example.com", "123456789", "1234567890", true);
        String result = clientService.addClient("existingLogin", "validPassword", "individual", "valid@example.com", "123454789", "1214567890", true);
        assertEquals("Uzytkownik z takim loginem juz istnieje.", result);
    }

    @Test
    @Transactional
    @Rollback
    void testChangeAccInfoIndividualValidData() {
        String result = clientService.changeAccInfoIndividual(1, "John", "Doe", "john.doe@example.com", "123456789");
        assertEquals("Zmieniono dane.", result);
    }

    @Test
    @Transactional
    @Rollback
    void testChangeAccInfoIndividualInvalidData() {
        String result = clientService.changeAccInfoIndividual(1, "John", "Doe", "invalid-email", "123456789");
        assertEquals("Niepoprawny adres email", result);
    }
}
