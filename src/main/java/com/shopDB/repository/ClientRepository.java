package com.shopDB.repository;

import com.shopDB.entities.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

/**
 * Trzeba stworzyc taka klase dla kazdej tabeli ale jej implementacje
 * generuje sam spring w tym JpaRepository
 */
public interface ClientRepository extends JpaRepository<Client, Long> {
}

