package com.shopDB.service;

import com.shopDB.dto.*;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class GeneralServiceTest {

    @Autowired
    private GeneralService generalService;

    @Autowired
    private EntityManager entityManager;

    @Test
    @Transactional
    @Rollback
    void testShowClientInfoValidData() {
        ClientInfoDTO result = generalService.showClientInfo(1);
        assertNotNull(result);
    }

    @Test
    @Transactional
    @Rollback
    void testShowClientInfoInvalidData() {
        ClientInfoDTO result = generalService.showClientInfo(-1);
        assertNull(result);
    }

    @Test
    @Transactional
    @Rollback
    void testShowClientOrdersValidData() {
        List<ClientOrderDTO> result = generalService.showClientOrders(1);
        assertNotNull(result);
    }

    @Test
    @Transactional
    @Rollback
    void testShowClientOrdersInvalidData() {
        List<ClientOrderDTO> result = generalService.showClientOrders(-1);
        assertTrue(result.isEmpty());
    }
}
