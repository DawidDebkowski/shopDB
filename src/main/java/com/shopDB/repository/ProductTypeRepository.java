package com.shopDB.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.ProductType;

public interface ProductTypeRepository extends JpaRepository<ProductType, Integer> {
	List<ProductType> findAll();

	@Query("SELECT t.id FROM ProductType t WHERE t.type = :name")
	Integer getIdFromName(@Param("name") String name);
}
