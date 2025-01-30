package com.shopDB.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.Product;

public interface ProductRepository extends JpaRepository<Product, Integer> {
	@Query("SELECT p.id FROM Product p WHERE p.name = :name AND p.category = :category AND p.type.id = :typeId AND p.color.id = :colorId ")
	Integer getIdFromData(@Param("name") String name, 
						  @Param("category") String category, 
						  @Param("typeId") Integer typeId, 
						  @Param("colorId") Integer colorId);	
}