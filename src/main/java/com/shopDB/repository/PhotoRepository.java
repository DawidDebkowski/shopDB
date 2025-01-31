package com.shopDB.repository;

import java.sql.Blob;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.shopDB.entities.Photo;
import com.shopDB.entities.Product;

public interface PhotoRepository extends JpaRepository<Photo, Integer> {
	@Query("SELECT p.photo FROM Photo p WHERE p.product =: product")
	Blob findByProduct(@Param("product") Product product);
}
