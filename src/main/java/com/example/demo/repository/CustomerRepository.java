package com.example.demo.repository;

import com.example.demo.domain.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, String> {
    
    /**
     * Tìm khách hàng theo số điện thoại
     */
    Optional<Customer> findByPhone(String phone);
    
    /**
     * Kiểm tra tồn tại khách hàng theo số điện thoại
     */
    boolean existsByPhone(String phone);
    
    /**
     * Tìm khách hàng theo level
     */
    List<Customer> findByLevel(Byte level);
    
    /**
     * Tìm khách hàng có tổng thanh toán >= một mức
     */
    List<Customer> findByTotalPaymentGreaterThanEqual(BigDecimal minPayment);
    
    /**
     * Tìm top khách hàng theo tổng thanh toán
     */
    @Query("SELECT c FROM Customer c ORDER BY c.totalPayment DESC")
    List<Customer> findTopCustomersByPayment();
    
    /**
     * Đếm số lượng khách hàng theo level
     */
    Long countByLevel(Byte level);
    
    /**
     * Tính tổng doanh thu từ khách hàng
     */
    @Query("SELECT COALESCE(SUM(c.totalPayment), 0) FROM Customer c")
    BigDecimal calculateTotalRevenue();
    
    /**
     * Đếm số lượng khách hàng theo chi nhánh (dựa vào prefix trong ID)
     * Ví dụ: CN02_CUS0001, CN02_CUS0002 -> count = 2
     */
    @Query("SELECT COUNT(c) FROM Customer c WHERE c.id LIKE :storeIdPrefix")
    Long countByStoreIdPrefix(@Param("storeIdPrefix") String storeIdPrefix);
}

