package com.example.demo.repository;

import com.example.demo.domain.BillDetail;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BillDetailRepository extends JpaRepository<BillDetail, String> {
    
    /**
     * Tìm chi tiết hóa đơn theo bill ID
     */
    @Query("SELECT bd FROM BillDetail bd WHERE bd.bill.id = :billId")
    List<BillDetail> findByBillId(@Param("billId") String billId);
    
    /**
     * Tìm chi tiết hóa đơn theo product ID
     */
    @Query("SELECT bd FROM BillDetail bd WHERE bd.product.id = :productId")
    List<BillDetail> findByProductId(@Param("productId") String productId);
    
    /**
     * Tìm sản phẩm bán chạy nhất theo store
     */
    @Query("SELECT bd.product.id, bd.product.name, SUM(bd.quantity) as totalSold " +
           "FROM BillDetail bd " +
           "WHERE bd.product.store.id = :storeId " +
           "GROUP BY bd.product.id, bd.product.name " +
           "ORDER BY totalSold DESC")
    List<Object[]> findTopSellingProducts(@Param("storeId") String storeId, Pageable pageable);
    
    /**
     * Tính tổng số lượng bán của một sản phẩm
     */
    @Query("SELECT COALESCE(SUM(bd.quantity), 0) FROM BillDetail bd WHERE bd.product.id = :productId")
    Long calculateTotalSoldQuantity(@Param("productId") String productId);
    
    /**
     * Tìm sản phẩm bán chạy trong khoảng thời gian
     */
    @Query("SELECT bd.product.id, bd.product.name, SUM(bd.quantity) as totalSold " +
           "FROM BillDetail bd " +
           "WHERE bd.product.store.id = :storeId " +
           "AND bd.bill.paymentDate BETWEEN :startDate AND :endDate " +
           "GROUP BY bd.product.id, bd.product.name " +
           "ORDER BY totalSold DESC")
    List<Object[]> findTopSellingProductsByDateRange(
        @Param("storeId") String storeId,
        @Param("startDate") java.time.LocalDateTime startDate,
        @Param("endDate") java.time.LocalDateTime endDate,
        Pageable pageable
    );
}

