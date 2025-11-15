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
     * Tìm bảng lương theo cửa hàng (tất cả tháng)
     */
    @Query("SELECT p FROM PayRoll p WHERE p.employee.store.id = :storeId ORDER BY p.payMonth DESC, p.employee.name ASC")
    List<PayRoll> findByStoreId(@Param("storeId") String storeId);
    
    /**
     * Tìm bảng lương theo nhân viên và tháng
     * Sử dụng BETWEEN để tìm trong khoảng từ ngày đầu tháng đến ngày cuối tháng
     */
    @Query("SELECT p FROM PayRoll p WHERE p.employee.id = :employeeId " +
           "AND p.payMonth >= :startOfMonth AND p.payMonth < :startOfNextMonth")
    Optional<PayRoll> findByEmployeeIdAndPayMonth(@Param("employeeId") String employeeId, 
                                                   @Param("startOfMonth") LocalDate startOfMonth,
                                                   @Param("startOfNextMonth") LocalDate startOfNextMonth);
    
    /**
     * Kiểm tra đã tồn tại bảng lương cho nhân viên trong tháng chưa
     * Sử dụng BETWEEN để tìm trong khoảng từ ngày đầu tháng đến ngày cuối tháng
     */
    @Query("SELECT CASE WHEN COUNT(p) > 0 THEN true ELSE false END FROM PayRoll p " +
           "WHERE p.employee.id = :employeeId AND p.payMonth >= :startOfMonth AND p.payMonth < :startOfNextMonth")
    boolean existsByEmployeeIdAndPayMonth(@Param("employeeId") String employeeId, 
                                         @Param("startOfMonth") LocalDate startOfMonth,
                                         @Param("startOfNextMonth") LocalDate startOfNextMonth);
    
    /**
     * Tìm bảng lương theo cửa hàng và tháng
     * Sử dụng BETWEEN để tìm trong khoảng từ ngày đầu tháng đến ngày cuối tháng
     */
    @Query("SELECT p FROM PayRoll p WHERE p.employee.store.id = :storeId " +
           "AND p.payMonth >= :startOfMonth AND p.payMonth < :startOfNextMonth")
    List<PayRoll> findByStoreIdAndPayMonth(@Param("storeId") String storeId, 
                                           @Param("startOfMonth") LocalDate startOfMonth,
                                           @Param("startOfNextMonth") LocalDate startOfNextMonth);
    
    /**
     * Tìm bảng lương theo tháng
     * Sử dụng BETWEEN để tìm trong khoảng từ ngày đầu tháng đến ngày cuối tháng
     */
    @Query("SELECT p FROM PayRoll p WHERE p.payMonth >= :startOfMonth AND p.payMonth < :startOfNextMonth")
    List<PayRoll> findByPayMonth(@Param("startOfMonth") LocalDate startOfMonth,
                                 @Param("startOfNextMonth") LocalDate startOfNextMonth);
    
    /**
     * Tính tổng lương của cửa hàng theo tháng
     * Sử dụng BETWEEN để tìm trong khoảng từ ngày đầu tháng đến ngày cuối tháng
     */
    @Query("SELECT COALESCE(SUM(p.total), 0) FROM PayRoll p WHERE p.employee.store.id = :storeId " +
           "AND p.payMonth >= :startOfMonth AND p.payMonth < :startOfNextMonth")
    Long calculateTotalPayrollByStoreAndMonth(@Param("storeId") String storeId, 
                                              @Param("startOfMonth") LocalDate startOfMonth,
                                              @Param("startOfNextMonth") LocalDate startOfNextMonth);
    
    /**
     * Tính tổng lương của tất cả cửa hàng theo tháng
     * Sử dụng BETWEEN để tìm trong khoảng từ ngày đầu tháng đến ngày cuối tháng
     */
    @Query("SELECT COALESCE(SUM(p.total), 0) FROM PayRoll p " +
           "WHERE p.payMonth >= :startOfMonth AND p.payMonth < :startOfNextMonth")
    Long calculateTotalPayrollByMonth(@Param("startOfMonth") LocalDate startOfMonth,
                                      @Param("startOfNextMonth") LocalDate startOfNextMonth);
    
    /**
     * Tìm nhân viên có lương cao nhất trong tháng
     * Sử dụng BETWEEN để tìm trong khoảng từ ngày đầu tháng đến ngày cuối tháng
     */
    @Query("SELECT p FROM PayRoll p WHERE p.payMonth >= :startOfMonth AND p.payMonth < :startOfNextMonth ORDER BY p.total DESC")
    List<PayRoll> findTopEarnersByMonth(@Param("startOfMonth") LocalDate startOfMonth,
                                        @Param("startOfNextMonth") LocalDate startOfNextMonth);
    
    /**
     * Lấy danh sách các tháng có dữ liệu bảng lương (distinct) - tất cả store
     */
    @Query("SELECT DISTINCT p.payMonth FROM PayRoll p ORDER BY p.payMonth DESC")
    List<LocalDate> findDistinctPayMonths();
    
    /**
     * Lấy danh sách các tháng có dữ liệu bảng lương (distinct) - theo store
     */
    @Query("SELECT DISTINCT p.payMonth FROM PayRoll p WHERE p.employee.store.id = :storeId ORDER BY p.payMonth DESC")
    List<LocalDate> findDistinctPayMonthsByStore(@Param("storeId") String storeId);
}

