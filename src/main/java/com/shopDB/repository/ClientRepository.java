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
//    @Procedure(procedureName="add_client", outputParameterName = "exit_msg")
//    @Transactional
//    String addClient(String login, String password, String type, String email, String phone, String nip, boolean cookies);
    @Procedure(procedureName = "add_client")
    void addClient(
            @Param("login") String login,
            @Param("password") String password,
            @Param("type") String type,
            @Param("email") String email,
            @Param("phone") String phone,
            @Param("NIP") String NIP,
            @Param("cookies") Boolean cookies,
            @Param("exit_msg") String[] exitMsg // Wyjście jako tablica (Hibernate tego wymaga)
    );

    @Procedure(procedureName = "test_client", outputParameterName = "res")
    @Transactional
    String testClient(String arg, String arg1);
}

