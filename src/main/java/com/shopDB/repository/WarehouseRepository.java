package com.shopDB.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.Product;
import com.shopDB.entities.Warehouse;

public interface WarehouseRepository extends JpaRepository<Warehouse, Integer> {
	@Query("SELECT w.id FROM Warehouse w WHERE w.product = :product AND w.size = :size")
	Integer getIdByData(@Param("product") Product product, @Param("size") String size);	

	Warehouse findById(int id);
}