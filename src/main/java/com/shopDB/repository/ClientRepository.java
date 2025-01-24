package com.shopDB.repository;

import com.shopDB.entities.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

/**
 * Trzeba stworzyc taka klase dla kazdej tabeli ale jej implementacje
 * generuje sam spring w tym JpaRepository
 */
public interface ClientRepository extends JpaRepository<Client, Long> {
    @Procedure("add_client")
    void addClient(String login, String password, String type, String email, String phone, boolean cookies);
}

