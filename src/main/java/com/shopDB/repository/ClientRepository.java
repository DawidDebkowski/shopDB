package com.shopDB.repository;

import com.shopDB.entities.Client;
import com.shopDB.entities.User;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Trzeba stworzyc taka klase dla kazdej tabeli ale jej implementacje
 * generuje sam spring w tym JpaRepository
 */
public interface ClientRepository extends JpaRepository<Client, Long> {
	Client findByUser(User user);
}

