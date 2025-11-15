package com.example.demo.repository;

import com.example.demo.domain.PayRoll;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface PayRollRepository extends JpaRepository<PayRoll, String> {
    
    /**
     * Tìm bảng lương theo nhân viên
     */
    List<PayRoll> findByEmployeeId(String employeeId);
    
    /**
     * Tìm bảng lương theo nhân viên và tháng
     */
    @Query("SELECT p FROM PayRoll p WHERE p.employee.id = :employeeId AND p.payMonth = :payMonth")
    Optional<PayRoll> findByEmployeeIdAndPayMonth(@Param("employeeId") String employeeId, 
                                                   @Param("payMonth") LocalDate payMonth);
    
    /**
     * Kiểm tra đã tồn tại bảng lương cho nhân viên trong tháng chưa
     */
    @Query("SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END FROM PayRoll p WHERE p.employee.id = :employeeId AND p.payMonth = :payMonth")
    boolean existsByEmployeeIdAndPayMonth(@Param("employeeId") String employeeId, 
                                         @Param("payMonth") LocalDate payMonth);
    
    /**
     * Tìm bảng lương theo cửa hàng và tháng
     */
    @Query("SELECT p FROM PayRoll p WHERE p.employee.store.id = :storeId AND p.payMonth = :payMonth")
    List<PayRoll> findByStoreIdAndPayMonth(@Param("storeId") String storeId, 
                                           @Param("payMonth") LocalDate payMonth);
    
    /**
     * Tìm bảng lương theo tháng
     */
    List<PayRoll> findByPayMonth(LocalDate payMonth);
    
    /**
     * Tính tổng lương của cửa hàng theo tháng
     */
    @Query("SELECT COALESCE(SUM(p.total), 0) FROM PayRoll p WHERE p.employee.store.id = :storeId AND p.payMonth = :payMonth")
    Long calculateTotalPayrollByStoreAndMonth(@Param("storeId") String storeId, 
                                              @Param("payMonth") LocalDate payMonth);
    
    /**
     * Tính tổng lương của tất cả cửa hàng theo tháng
     */
    @Query("SELECT COALESCE(SUM(p.total), 0) FROM PayRoll p WHERE p.payMonth = :payMonth")
    Long calculateTotalPayrollByMonth(@Param("payMonth") LocalDate payMonth);
    
    /**
     * Tìm nhân viên có lương cao nhất trong tháng
     */
    @Query("SELECT p FROM PayRoll p WHERE p.payMonth = :payMonth ORDER BY p.total DESC")
    List<PayRoll> findTopEarnersByMonth(@Param("payMonth") LocalDate payMonth);
}

