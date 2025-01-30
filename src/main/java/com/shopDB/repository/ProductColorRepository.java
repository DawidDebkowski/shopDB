package com.shopDB.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.ProductColor;

public interface ProductColorRepository extends JpaRepository<ProductColor, Integer> {
	List<ProductColor> findAll();

	@Query("SELECT c.id FROM ProductColor c WHERE c.name = :name")
	Integer getIdFromName(@Param("name") String name);
}
