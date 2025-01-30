package com.shopDB.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.Client;
import com.shopDB.entities.Order;

public interface OrderRepository extends JpaRepository<Order, Integer> {
	@Query("SELECT o.id FROM Order o WHERE o.client = :client AND o.status = \"cart\"")
	Integer findCartId(@Param("client") Client client);
}
