package com.shopDB.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.shopDB.entities.ProductType;

public interface ProductTypeRepository extends JpaRepository<ProductType, Integer> {
	List<ProductType> findAll();
}
