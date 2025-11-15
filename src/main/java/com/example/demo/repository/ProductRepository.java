package com.example.demo.repository;

import com.example.demo.domain.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, String>, JpaSpecificationExecutor<Product> {
    
    Page<Product> findAll(Pageable page);
    Page<Product> findAll(Specification<Product> spec, Pageable page);
    
    /**
     * Tìm sản phẩm theo cửa hàng (cho data partitioning)
     */
    List<Product> findByStoreId(String storeId);
    
    /**
     * Tìm sản phẩm theo cửa hàng với phân trang
     */
    Page<Product> findByStoreId(String storeId, Pageable pageable);
    
    /**
     * Tìm sản phẩm theo danh mục
     */
    List<Product> findByCategoryId(String categoryId);
    
    /**
     * Tìm sản phẩm theo cửa hàng và danh mục
     */
    List<Product> findByStoreIdAndCategoryId(String storeId, String categoryId);
    
    /**
     * Tìm sản phẩm theo tên và cửa hàng
     */
    Optional<Product> findByNameAndStoreId(String name, String storeId);
    
    /**
     * Tìm sản phẩm sắp hết hạn (low stock alert)
     */
    @Query("SELECT p FROM Product p WHERE p.quantity < :threshold AND p.store.id = :storeId")
    List<Product> findLowStockProducts(@Param("threshold") Integer threshold, 
                                       @Param("storeId") String storeId);
    
    /**
     * Tìm sản phẩm hết hàng
     */
    @Query("SELECT p FROM Product p WHERE p.quantity = 0 AND p.store.id = :storeId")
    List<Product> findOutOfStockProducts(@Param("storeId") String storeId);
    
    /**
     * Tìm sản phẩm sắp hết hạn (expiration alert)
     */
    @Query("SELECT p FROM Product p WHERE p.expDate <= :date AND p.store.id = :storeId")
    List<Product> findExpiringProducts(@Param("date") LocalDate date, 
                                       @Param("storeId") String storeId);
    
    /**
     * Tìm sản phẩm đã hết hạn
     */
    @Query("SELECT p FROM Product p WHERE p.expDate < :currentDate")
    List<Product> findExpiredProducts(@Param("currentDate") LocalDate currentDate);
    
    /**
     * Tìm sản phẩm theo khoảng giá
     */
    @Query("SELECT p FROM Product p WHERE p.price BETWEEN :minPrice AND :maxPrice AND p.store.id = :storeId")
    List<Product> findByPriceRange(@Param("minPrice") BigDecimal minPrice,
                                   @Param("maxPrice") BigDecimal maxPrice,
                                   @Param("storeId") String storeId);
    
    /**
     * Tìm sản phẩm theo tên (tìm kiếm gần đúng)
     */
    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :keyword, '%')) AND p.store.id = :storeId")
    List<Product> searchByName(@Param("keyword") String keyword, 
                               @Param("storeId") String storeId);
    
    /**
     * Đếm số lượng sản phẩm theo cửa hàng
     */
    Long countByStoreId(String storeId);
    
    /**
     * Đếm số lượng sản phẩm sắp hết hạn
     */
    @Query("SELECT COUNT(p) FROM Product p WHERE p.quantity < :threshold AND p.store.id = :storeId")
    Long countLowStockProducts(@Param("threshold") Integer threshold, 
                               @Param("storeId") String storeId);
    
    /**
     * Tính tổng giá trị kho hàng (inventory value)
     */
    @Query("SELECT COALESCE(SUM(p.price * p.quantity), 0) FROM Product p WHERE p.store.id = :storeId")
    BigDecimal calculateInventoryValue(@Param("storeId") String storeId);
}

