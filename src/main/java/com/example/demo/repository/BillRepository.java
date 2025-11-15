package com.example.demo.repository;

import com.example.demo.domain.Bill;
import com.example.demo.enums.PaymentMethodType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BillRepository extends JpaRepository<Bill, String> {
    
    /**
     * Tìm hóa đơn theo khách hàng
     */
    List<Bill> findByCustomerId(String customerId);
    
    /**
     * Tìm hóa đơn theo nhân viên
     */
    List<Bill> findByEmployeeId(String employeeId);
    
    /**
     * Tìm hóa đơn trong khoảng thời gian
     */
    @Query("SELECT b FROM Bill b WHERE b.paymentDate BETWEEN :startDate AND :endDate")
    List<Bill> findByDateRange(@Param("startDate") LocalDateTime startDate, 
                               @Param("endDate") LocalDateTime endDate);
    
    /**
     * Tìm hóa đơn theo phương thức thanh toán
     */
    List<Bill> findByPaymentMethod(PaymentMethodType paymentMethod);
    
    /**
     * Tìm hóa đơn sau một thời điểm (cho sync data)
     */
    List<Bill> findByCreatedDateAfter(LocalDateTime createdDate);
    
    /**
     * Đếm số lượng hóa đơn trong khoảng thời gian
     */
    @Query("SELECT COUNT(b) FROM Bill b WHERE b.paymentDate BETWEEN :startDate AND :endDate")
    Integer countByPaymentDateBetween(@Param("startDate") LocalDateTime startDate, 
                                      @Param("endDate") LocalDateTime endDate);
    
    /**
     * Tính doanh thu theo ngày
     */
    @Query("SELECT COALESCE(SUM(b.totalPrice), 0) FROM Bill b WHERE CAST(b.paymentDate AS DATE) = :date")
    BigDecimal calculateDailyRevenue(@Param("date") LocalDate date);
    
    /**
     * Tính doanh thu trong khoảng thời gian
     */
    @Query("SELECT COALESCE(SUM(b.totalPrice), 0) FROM Bill b WHERE b.paymentDate BETWEEN :startDate AND :endDate")
    BigDecimal calculateRevenueByDateRange(@Param("startDate") LocalDateTime startDate, 
                                           @Param("endDate") LocalDateTime endDate);
    
    /**
     * Tìm hóa đơn theo nhân viên và khoảng thời gian (cho báo cáo hiệu suất)
     */
    @Query("SELECT b FROM Bill b WHERE b.employee.id = :employeeId AND CAST(b.paymentDate AS DATE) BETWEEN :startDate AND :endDate")
    List<Bill> findByEmployeeIdAndDateRange(@Param("employeeId") String employeeId,
                                            @Param("startDate") LocalDate startDate,
                                            @Param("endDate") LocalDate endDate);
    
    /**
     * Đếm số hóa đơn của nhân viên theo tháng
     */
    @Query("SELECT COUNT(b) FROM Bill b WHERE b.employee.id = :employeeId AND MONTH(b.paymentDate) = :month AND YEAR(b.paymentDate) = :year")
    Long countByEmployeeIdAndMonth(@Param("employeeId") String employeeId, 
                                   @Param("month") Integer month, 
                                   @Param("year") Integer year);
    
    /**
     * Tính tổng doanh thu theo phương thức thanh toán
     */
    @Query("SELECT COALESCE(SUM(b.totalPrice), 0) FROM Bill b WHERE b.paymentMethod = :paymentMethod AND CAST(b.paymentDate AS DATE) = :date")
    BigDecimal calculateRevenueByPaymentMethod(@Param("paymentMethod") PaymentMethodType paymentMethod, 
                                               @Param("date") LocalDate date);
}

