package com.shopDB.repository;

import com.shopDB.entities.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.transaction.annotation.Transactional;

/**
 * Trzeba stworzyc taka klase dla kazdej tabeli ale jej implementacje
 * generuje sam spring w tym JpaRepository
 */
public interface ClientRepository extends JpaRepository<Client, Long> {
    @Procedure(procedureName="add_client", outputParameterName = "exit_msg")
    @Transactional
    String addClient(String login, String password, String type, String email, String phone, String nip, boolean cookies);
}

