package com.shopDB.repository;

import java.sql.Blob;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.Photo;

public interface PhotoRepository extends JpaRepository<Photo, Integer> {
	@Query("SELECT p.photo FROM Photo p WHERE p.product.id = :product")
	List<Blob> findByProduct(@Param("product") Integer productId);
}
