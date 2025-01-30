package com.shopDB.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.Order;
import com.shopDB.entities.OrderPo;
import com.shopDB.entities.Warehouse;

public interface OrderPoRepository extends JpaRepository<OrderPo, Integer> {
	@Query("SELECT o.id FROM OrderPo o WHERE o.warehouse = :warehouse AND o.order = :order")
	Integer findIdByData(@Param("order") Order order, @Param("warehouse") Warehouse warehouse);
}
