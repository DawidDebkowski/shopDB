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
class WarehouseServiceTest {

    @Autowired
    private WarehouseService warehouseService;

    @Autowired
    private EntityManager entityManager;

    @Test
    @Transactional
    @Rollback
    void testAddWarehouseValidData() {
        String result = warehouseService.addWarehouse(1, "M", 10);
        assertEquals("Dodano produkty do magazynu.", result);
    }

    @Test
    @Transactional
    @Rollback
    void testAddWarehouseInvalidData() {
        String result = warehouseService.addWarehouse(-1, "M", 10);
        assertNotEquals("Dodano produkty do magazynu.", result);
    }

    @Test
    @Transactional
    @Rollback
    void testCompleteOrderValidData() {
        String result = warehouseService.completeOrder(1);
        assertEquals("Zamowienie wykonane.", result);
    }

    @Test
    @Transactional
    @Rollback
    void testCompleteOrderInvalidData() {
        String result = warehouseService.completeOrder(-1);
        assertNotEquals("Zamowienie wykonane.", result);
    }
}
