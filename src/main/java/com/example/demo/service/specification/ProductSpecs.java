package com.example.demo.service.specification;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.springframework.data.jpa.domain.Specification;

import com.example.demo.domain.Product;
import com.example.demo.domain.Product_;
import com.example.demo.domain.Store_;
import com.example.demo.domain.Category_;

/**
 * Specification cho Product entity
 * Phù hợp với logic nghiệp vụ cửa hàng tiện lợi
 */
public class ProductSpecs {
    
    /**
     * Tìm kiếm theo tên sản phẩm (LIKE)
     */
    public static Specification<Product> nameLike(String name) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.like(criteriaBuilder.lower(root.get(Product_.NAME)), 
                               "%" + name.toLowerCase() + "%");
    }

    /**
     * Lọc theo giá tối thiểu
     */
    public static Specification<Product> minPrice(double price) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.ge(root.get(Product_.PRICE), BigDecimal.valueOf(price));
    }

    /**
     * Lọc theo giá tối đa
     */
    public static Specification<Product> maxPrice(double price) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.le(root.get(Product_.PRICE), BigDecimal.valueOf(price));
    }

    /**
     * Lọc theo khoảng giá
     */
    public static Specification<Product> matchPrice(double min, double max) {
        return (root, query, criteriaBuilder) -> criteriaBuilder.and(
            criteriaBuilder.ge(root.get(Product_.PRICE), BigDecimal.valueOf(min)),
            criteriaBuilder.le(root.get(Product_.PRICE), BigDecimal.valueOf(max))
        );
    }
    
    /**
     * Lọc theo cửa hàng (Data Partitioning)
     */
    public static Specification<Product> belongsToStore(String storeId) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get(Product_.STORE).get(Store_.ID), storeId);
    }
    
    /**
     * Lọc theo danh mục
     */
    public static Specification<Product> inCategory(String categoryId) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get(Product_.CATEGORY).get(Category_.ID), categoryId);
    }
    
    /**
     * Lọc sản phẩm còn hàng
     */
    public static Specification<Product> inStock() {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.gt(root.get(Product_.QUANTITY), 0);
    }
    
    /**
     * Lọc sản phẩm hết hàng
     */
    public static Specification<Product> outOfStock() {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get(Product_.QUANTITY), 0);
    }
    
    /**
     * Lọc sản phẩm sắp hết hàng (quantity < threshold)
     */
    public static Specification<Product> lowStock(Integer threshold) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.lt(root.get(Product_.QUANTITY), threshold);
    }
    
    /**
     * Lọc sản phẩm chưa hết hạn
     */
    public static Specification<Product> notExpired() {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.or(
                criteriaBuilder.isNull(root.get(Product_.EXP_DATE)),
                criteriaBuilder.greaterThan(root.get(Product_.EXP_DATE), LocalDate.now())
            );
    }
    
    /**
     * Lọc sản phẩm đã hết hạn
     */
    public static Specification<Product> expired() {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.and(
                criteriaBuilder.isNotNull(root.get(Product_.EXP_DATE)),
                criteriaBuilder.lessThan(root.get(Product_.EXP_DATE), LocalDate.now())
            );
    }
    
    /**
     * Lọc sản phẩm sắp hết hạn trong N ngày
     */
    public static Specification<Product> expiringInDays(Integer days) {
        LocalDate expiryDate = LocalDate.now().plusDays(days);
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.and(
                criteriaBuilder.isNotNull(root.get(Product_.EXP_DATE)),
                criteriaBuilder.between(root.get(Product_.EXP_DATE), LocalDate.now(), expiryDate)
            );
    }
}
