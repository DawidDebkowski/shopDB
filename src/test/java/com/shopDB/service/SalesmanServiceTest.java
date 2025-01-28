package com.shopDB.service;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class SalesmanServiceTest {

    @Autowired
    private SalesmanService salesmanService;

    @Autowired
    private EntityManager entityManager;

    @Test
    @Transactional
    @Rollback
    void testAddTypeValidData() {
        String result = salesmanService.addType("NewType");
        assertEquals("Dodano nowy typ produktow.", result);
    }

//    @Test
//    @Transactional
//    @Rollback
//    void testAddTypeInvalidData() {
//        String result = salesmanService.addType("");
//        assertNotEquals("Dodano nowy typ produktow.", result);
//    }

    @Test
    @Transactional
    @Rollback
    void testAddProductValidData() {
        String result = salesmanService.addProduct("NewProduct", "men", 1, 1, 100.0);
        assertEquals("Dodano nowy produkt.", result);
    }

    @Test
    @Transactional
    @Rollback
    void testAddProductInvalidData() {
        String result = salesmanService.addProduct("", "men", 1, 1, 100.0);
        assertNotEquals("Dodano nowy produkt.", result);
    }
}
