package com.example.demo.service;

import com.example.demo.domain.Store;
import com.example.demo.repository.StoreRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class StoreService {
    
    private static final Logger log = LoggerFactory.getLogger(StoreService.class);
    
    private final StoreRepository storeRepository;
    
    public StoreService(StoreRepository storeRepository) {
        this.storeRepository = storeRepository;
    }
    
    /**
     * Tạo cửa hàng mới
     */
    public Store createStore(Store store) {
        // Kiểm tra số điện thoại đã tồn tại chưa
        if (storeRepository.existsByPhone(store.getPhone())) {
            log.error("❌ Số điện thoại đã tồn tại: {}", store.getPhone());
            throw new IllegalArgumentException("Số điện thoại cửa hàng đã tồn tại");
        }
        
        Store savedStore = storeRepository.save(store);
        log.info("✅ Tạo cửa hàng thành công: {} - {}", savedStore.getId(), savedStore.getAddress());
        return savedStore;
    }
    
    /**
     * Cập nhật thông tin cửa hàng
     */
    public Store updateStore(Store store) {
        Optional<Store> existingStore = storeRepository.findById(store.getId());
        if (existingStore.isEmpty()) {
            log.error("❌ Không tìm thấy cửa hàng: {}", store.getId());
            throw new IllegalArgumentException("Cửa hàng không tồn tại");
        }
        
        // Kiểm tra số điện thoại mới có trùng với cửa hàng khác không
        Optional<Store> storeWithPhone = storeRepository.findByPhone(store.getPhone());
        if (storeWithPhone.isPresent() && !storeWithPhone.get().getId().equals(store.getId())) {
            log.error("❌ Số điện thoại đã được sử dụng bởi cửa hàng khác: {}", store.getPhone());
            throw new IllegalArgumentException("Số điện thoại đã được sử dụng bởi cửa hàng khác");
        }
        
        Store updatedStore = storeRepository.save(store);
        log.info("✅ Cập nhật cửa hàng thành công: {}", updatedStore.getId());
        return updatedStore;
    }
    
    /**
     * Xóa cửa hàng
     */
    public void deleteStore(String storeId) {
        Optional<Store> store = storeRepository.findById(storeId);
        if (store.isEmpty()) {
            log.error("❌ Không tìm thấy cửa hàng: {}", storeId);
            throw new IllegalArgumentException("Cửa hàng không tồn tại");
        }
        
        // Kiểm tra xem cửa hàng có nhân viên hoặc sản phẩm không
        Long employeeCount = storeRepository.countEmployeesByStoreId(storeId);
        Long productCount = storeRepository.countProductsByStoreId(storeId);
        
        if (employeeCount > 0 || productCount > 0) {
            log.error("❌ Không thể xóa cửa hàng {} (có {} nhân viên, {} sản phẩm)", 
                     storeId, employeeCount, productCount);
            throw new IllegalStateException("Không thể xóa cửa hàng đang có nhân viên hoặc sản phẩm");
        }
        
        storeRepository.deleteById(storeId);
        log.info("✅ Xóa cửa hàng thành công: {}", storeId);
    }
    
    /**
     * Lấy thông tin cửa hàng theo ID
     */
    public Optional<Store> getStoreById(String storeId) {
        return storeRepository.findById(storeId);
    }
    
    /**
     * Lấy tất cả cửa hàng
     */
    public List<Store> getAllStores() {
        return storeRepository.findAll();
    }
    
    /**
     * Tìm cửa hàng theo số điện thoại
     */
    public Optional<Store> getStoreByPhone(String phone) {
        return storeRepository.findByPhone(phone);
    }
    
    /**
     * Lấy thống kê cửa hàng
     */
    public StoreStatistics getStoreStatistics(String storeId) {
        Long employeeCount = storeRepository.countEmployeesByStoreId(storeId);
        Long productCount = storeRepository.countProductsByStoreId(storeId);
        
        StoreStatistics stats = new StoreStatistics();
        stats.setStoreId(storeId);
        stats.setEmployeeCount(employeeCount);
        stats.setProductCount(productCount);
        
        return stats;
    }
    
    /**
     * DTO cho thống kê cửa hàng
     */
    public static class StoreStatistics {
        private String storeId;
        private Long employeeCount;
        private Long productCount;
        
        // Getters and Setters
        public String getStoreId() { return storeId; }
        public void setStoreId(String storeId) { this.storeId = storeId; }
        public Long getEmployeeCount() { return employeeCount; }
        public void setEmployeeCount(Long employeeCount) { this.employeeCount = employeeCount; }
        public Long getProductCount() { return productCount; }
        public void setProductCount(Long productCount) { this.productCount = productCount; }
    }
}

