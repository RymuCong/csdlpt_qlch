package com.example.demo.repository;

import com.example.demo.domain.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StoreRepository extends JpaRepository<Store, String> {
    
    /**
     * Tìm cửa hàng theo số điện thoại
     */
    Optional<Store> findByPhone(String phone);
    
    /**
     * Kiểm tra tồn tại cửa hàng theo số điện thoại
     */
    boolean existsByPhone(String phone);
    
    /**
     * Đếm số lượng nhân viên của cửa hàng
     */
    @Query("SELECT COUNT(e) FROM Employee e WHERE e.store.id = :storeId")
    Long countEmployeesByStoreId(@Param("storeId") String storeId);
    
    /**
     * Đếm số lượng sản phẩm của cửa hàng
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.store.id = :storeId")
    Long countProductsByStoreId(@Param("storeId") String storeId);
}

