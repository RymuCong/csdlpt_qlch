package com.example.demo.repository;

import com.example.demo.domain.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, String> {
    
    /**
     * Tìm danh mục theo tên
     */
    Optional<Category> findByName(String name);
    
    /**
     * Kiểm tra tồn tại danh mục theo tên
     */
    boolean existsByName(String name);
    
    /**
     * Đếm số lượng sản phẩm trong danh mục
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId")
    Long countProductsByCategoryId(@Param("categoryId") String categoryId);
    
    /**
     * Đếm số lượng sản phẩm trong danh mục theo cửa hàng
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.category.id = :categoryId AND p.store.id = :storeId")
    Long countProductsByCategoryIdAndStoreId(@Param("categoryId") String categoryId, @Param("storeId") String storeId);
}

