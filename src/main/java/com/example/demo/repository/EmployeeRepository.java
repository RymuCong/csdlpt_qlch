package com.example.demo.repository;

import com.example.demo.domain.Employee;
import com.example.demo.enums.PositionType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, String> {
    
    /**
     * Tìm nhân viên theo số điện thoại
     */
    Optional<Employee> findByPhone(String phone);
    
    /**
     * Tìm tất cả nhân viên của một cửa hàng
     */
    List<Employee> findByStoreId(String storeId);
    
    /**
     * Tìm nhân viên theo cửa hàng và chức vụ
     */
    List<Employee> findByStoreIdAndPosition(String storeId, PositionType position);
    
    /**
     * Kiểm tra tồn tại nhân viên theo số điện thoại và cửa hàng
     */
    boolean existsByPhoneAndStoreId(String phone, String storeId);
    
    /**
     * Tìm nhân viên theo chức vụ
     */
    List<Employee> findByPosition(PositionType position);
    
    /**
     * Đếm số lượng nhân viên theo chức vụ trong cửa hàng
     */
    @Query("SELECT COUNT(e) FROM Employee e WHERE e.store.id = :storeId AND e.position = :position")
    Long countByStoreIdAndPosition(@Param("storeId") String storeId, @Param("position") PositionType position);
    
    /**
     * Tìm nhân viên có lương cơ bản cao nhất trong cửa hàng
     */
    @Query("SELECT e FROM Employee e WHERE e.store.id = :storeId ORDER BY e.baseSalary DESC")
    List<Employee> findTopSalaryEmployeesByStore(@Param("storeId") String storeId);
}

