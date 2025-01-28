package com.shopDB.repository;

import com.shopDB.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Trzeba stworzyc taka klase dla kazdej tabeli ale jej implementacje
 * generuje sam spring w tym JpaRepository
 */
public interface UserRepository extends JpaRepository<User, Long> {
	User findByLogin(String login);
	User findById(int id);
}

