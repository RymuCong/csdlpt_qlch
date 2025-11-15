package com.example.demo.service;

import com.example.demo.domain.Product;
import com.example.demo.domain.Store;
import com.example.demo.domain.Category;
import com.example.demo.repository.ProductRepository;
import com.example.demo.repository.StoreRepository;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.service.specification.ProductSpecs;
import com.example.demo.util.IdGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProductService {
    
    private static final Logger log = LoggerFactory.getLogger(ProductService.class);
    
    private final ProductRepository productRepository;
    private final StoreRepository storeRepository;
    private final CategoryRepository categoryRepository;
    private final IdGenerator idGenerator;
    
    public ProductService(ProductRepository productRepository, 
                         StoreRepository storeRepository,
                         CategoryRepository categoryRepository,
                         IdGenerator idGenerator) {
        this.productRepository = productRepository;
        this.storeRepository = storeRepository;
        this.categoryRepository = categoryRepository;
        this.idGenerator = idGenerator;
    }
    
    /**
     * Tạo sản phẩm mới
     */
    public Product createProduct(Product product) {
        // Kiểm tra cửa hàng có tồn tại không
        Optional<Store> store = storeRepository.findById(product.getStore().getId());
        if (store.isEmpty()) {
            log.error("❌ Cửa hàng không tồn tại: {}", product.getStore().getId());
            throw new IllegalArgumentException("Cửa hàng không tồn tại");
        }
        
        // Kiểm tra danh mục có tồn tại không
        Optional<Category> category = categoryRepository.findById(product.getCategory().getId());
        if (category.isEmpty()) {
            log.error("❌ Danh mục không tồn tại: {}", product.getCategory().getId());
            throw new IllegalArgumentException("Danh mục không tồn tại");
        }
        
        // Kiểm tra tên sản phẩm đã tồn tại trong cửa hàng chưa
        Optional<Product> existingProduct = productRepository.findByNameAndStoreId(
            product.getName(), product.getStore().getId());
        if (existingProduct.isPresent()) {
            log.error("❌ Sản phẩm đã tồn tại trong cửa hàng: {}", product.getName());
            throw new IllegalArgumentException("Sản phẩm đã tồn tại trong cửa hàng này");
        }
        
        // Generate Product ID
        String storeId = product.getStore().getId();
        long productCount = productRepository.findByStoreId(storeId).size();
        product.setId(idGenerator.generateProductId(storeId, productCount));
        
        Product savedProduct = productRepository.save(product);
        log.info("✅ Tạo sản phẩm thành công: {} - {} - Store: {}", 
                 savedProduct.getId(), savedProduct.getName(), savedProduct.getStore().getId());
        return savedProduct;
    }
    
    /**
     * Cập nhật sản phẩm
     */
    public Product updateProduct(Product product) {
        Optional<Product> existingProduct = productRepository.findById(product.getId());
        if (existingProduct.isEmpty()) {
            log.error("❌ Không tìm thấy sản phẩm: {}", product.getId());
            throw new IllegalArgumentException("Sản phẩm không tồn tại");
        }
        
        Product updatedProduct = productRepository.save(product);
        log.info("✅ Cập nhật sản phẩm thành công: {}", updatedProduct.getId());
        return updatedProduct;
    }
    
    /**
     * Xóa sản phẩm
     */
    public void deleteProduct(String productId) {
        Optional<Product> product = productRepository.findById(productId);
        if (product.isEmpty()) {
            log.error("❌ Không tìm thấy sản phẩm: {}", productId);
            throw new IllegalArgumentException("Sản phẩm không tồn tại");
        }
        
        productRepository.deleteById(productId);
        log.info("✅ Xóa sản phẩm thành công: {}", productId);
    }
    
    /**
     * Lấy sản phẩm theo ID
     */
    public Optional<Product> getProductById(String productId) {
        return productRepository.findById(productId);
    }
    
    /**
     * Lấy tất cả sản phẩm với phân trang
     */
    public Page<Product> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }
    
    /**
     * Lấy sản phẩm theo cửa hàng (Data Partitioning)
     */
    public List<Product> getProductsByStore(String storeId) {
        return productRepository.findByStoreId(storeId);
    }
    
    /**
     * Lấy sản phẩm theo cửa hàng với phân trang
     */
    public Page<Product> getProductsByStore(String storeId, Pageable pageable) {
        return productRepository.findByStoreId(storeId, pageable);
    }
    
    /**
     * Lấy sản phẩm theo danh mục
     */
    public List<Product> getProductsByCategory(String categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }
    
    /**
     * Lấy sản phẩm theo cửa hàng và danh mục
     */
    public List<Product> getProductsByStoreAndCategory(String storeId, String categoryId) {
        return productRepository.findByStoreIdAndCategoryId(storeId, categoryId);
    }
    
    /**
     * Tìm kiếm sản phẩm theo tên
     */
    public List<Product> searchProducts(String keyword, String storeId) {
        return productRepository.searchByName(keyword, storeId);
    }
    
    /**
     * Lấy sản phẩm theo khoảng giá
     */
    public List<Product> getProductsByPriceRange(BigDecimal minPrice, BigDecimal maxPrice, String storeId) {
        return productRepository.findByPriceRange(minPrice, maxPrice, storeId);
    }
    
    // ============= QUẢN LÝ KHO HÀNG =============
    
    /**
     * Cập nhật số lượng sản phẩm (nhập/xuất kho)
     */
    public Product updateProductQuantity(String productId, Integer quantity) {
        Optional<Product> productOpt = productRepository.findById(productId);
        if (productOpt.isEmpty()) {
            log.error("❌ Không tìm thấy sản phẩm: {}", productId);
            throw new IllegalArgumentException("Sản phẩm không tồn tại");
        }
        
        Product product = productOpt.get();
        product.setQuantity(quantity);
        
        Product updatedProduct = productRepository.save(product);
        log.info("✅ Cập nhật số lượng sản phẩm {} thành công: {}", productId, quantity);
        return updatedProduct;
    }
    
    /**
     * Thêm số lượng sản phẩm (nhập kho)
     */
    public Product addProductStock(String productId, Integer additionalQuantity) {
        Optional<Product> productOpt = productRepository.findById(productId);
        if (productOpt.isEmpty()) {
            log.error("❌ Không tìm thấy sản phẩm: {}", productId);
            throw new IllegalArgumentException("Sản phẩm không tồn tại");
        }
        
        Product product = productOpt.get();
        Integer newQuantity = product.getQuantity() + additionalQuantity;
        product.setQuantity(newQuantity);
        
        Product updatedProduct = productRepository.save(product);
        log.info("✅ Nhập kho sản phẩm {} thành công: +{} = {}", 
                 productId, additionalQuantity, newQuantity);
        return updatedProduct;
    }
    
    /**
     * Giảm số lượng sản phẩm (xuất kho/bán hàng)
     */
    public Product reduceProductStock(String productId, Integer reduceQuantity) {
        Optional<Product> productOpt = productRepository.findById(productId);
        if (productOpt.isEmpty()) {
            log.error("❌ Không tìm thấy sản phẩm: {}", productId);
            throw new IllegalArgumentException("Sản phẩm không tồn tại");
        }
        
        Product product = productOpt.get();
        
        // Kiểm tra đủ hàng không
        if (product.getQuantity() < reduceQuantity) {
            log.error("❌ Không đủ hàng trong kho: {} (có: {}, cần: {})", 
                     product.getName(), product.getQuantity(), reduceQuantity);
            throw new IllegalStateException("Không đủ hàng trong kho: " + product.getName());
        }
        
        Integer newQuantity = product.getQuantity() - reduceQuantity;
        product.setQuantity(newQuantity);
        
        Product updatedProduct = productRepository.save(product);
        log.info("✅ Xuất kho sản phẩm {} thành công: -{} = {}", 
                 productId, reduceQuantity, newQuantity);
        return updatedProduct;
    }
    
    /**
     * Kiểm tra tồn kho có đủ không
     */
    public boolean hasEnoughStock(String productId, Integer requiredQuantity) {
        Optional<Product> productOpt = productRepository.findById(productId);
        if (productOpt.isEmpty()) {
            return false;
        }
        
        Product product = productOpt.get();
        return product.getQuantity() >= requiredQuantity;
    }
    
    // ============= CẢNH BÁO VÀ BÁO CÁO =============
    
    /**
     * Lấy sản phẩm sắp hết hàng (Low Stock Alert)
     */
    public List<Product> getLowStockProducts(String storeId, Integer threshold) {
        return productRepository.findLowStockProducts(threshold, storeId);
    }
    
    /**
     * Lấy sản phẩm hết hàng
     */
    public List<Product> getOutOfStockProducts(String storeId) {
        return productRepository.findOutOfStockProducts(storeId);
    }
    
    /**
     * Lấy sản phẩm sắp hết hạn
     */
    public List<Product> getExpiringProducts(String storeId, Integer daysUntilExpiry) {
        LocalDate expiryDate = LocalDate.now().plusDays(daysUntilExpiry);
        return productRepository.findExpiringProducts(expiryDate, storeId);
    }
    
    /**
     * Lấy sản phẩm đã hết hạn
     */
    public List<Product> getExpiredProducts() {
        return productRepository.findExpiredProducts(LocalDate.now());
    }
    
    /**
     * Đếm số sản phẩm theo cửa hàng
     */
    public Long countProductsByStore(String storeId) {
        return productRepository.countByStoreId(storeId);
    }
    
    /**
     * Đếm số sản phẩm sắp hết hàng
     */
    public Long countLowStockProducts(String storeId, Integer threshold) {
        return productRepository.countLowStockProducts(threshold, storeId);
    }
    
    /**
     * Tính tổng giá trị kho hàng
     */
    public BigDecimal calculateInventoryValue(String storeId) {
        return productRepository.calculateInventoryValue(storeId);
    }
    
    // ============= TÌM KIẾM VỚI SPECIFICATION =============
    
    /**
     * Tìm kiếm sản phẩm với Specification và phân trang
     */
    public Page<Product> searchWithSpec(Specification<Product> spec, Pageable pageable) {
        return productRepository.findAll(spec, pageable);
    }
    
    /**
     * Tìm kiếm sản phẩm theo khoảng giá (với Specification)
     */
    public Page<Product> searchByPriceRange(String priceRange, Pageable pageable) {
        if (priceRange == null || priceRange.isEmpty()) {
            return productRepository.findAll(pageable);
        }
        
        // Xử lý các khoảng giá định sẵn
        switch (priceRange) {
            case "duoi-10k":
                return productRepository.findAll(
                    ProductSpecs.matchPrice(0, 10000), pageable);
            case "10k-50k":
                return productRepository.findAll(
                    ProductSpecs.matchPrice(10000, 50000), pageable);
            case "50k-100k":
                return productRepository.findAll(
                    ProductSpecs.matchPrice(50000, 100000), pageable);
            case "100k-500k":
                return productRepository.findAll(
                    ProductSpecs.matchPrice(100000, 500000), pageable);
            case "tren-500k":
                return productRepository.findAll(
                    ProductSpecs.minPrice(500000), pageable);
            default:
                return productRepository.findAll(pageable);
        }
    }
    
    /**
     * DTO cho báo cáo kho hàng
     */
    public InventoryReport getInventoryReport(String storeId) {
        InventoryReport report = new InventoryReport();
        report.setStoreId(storeId);
        report.setTotalProducts(countProductsByStore(storeId));
        report.setLowStockCount(countLowStockProducts(storeId, 10));
        report.setOutOfStockCount((long) getOutOfStockProducts(storeId).size());
        report.setExpiringCount((long) getExpiringProducts(storeId, 30).size());
        report.setInventoryValue(calculateInventoryValue(storeId));
        
        return report;
    }
    
    public static class InventoryReport {
        private String storeId;
        private Long totalProducts;
        private Long lowStockCount;
        private Long outOfStockCount;
        private Long expiringCount;
        private BigDecimal inventoryValue;
        
        // Getters and Setters
        public String getStoreId() { return storeId; }
        public void setStoreId(String storeId) { this.storeId = storeId; }
        public Long getTotalProducts() { return totalProducts; }
        public void setTotalProducts(Long totalProducts) { this.totalProducts = totalProducts; }
        public Long getLowStockCount() { return lowStockCount; }
        public void setLowStockCount(Long lowStockCount) { this.lowStockCount = lowStockCount; }
        public Long getOutOfStockCount() { return outOfStockCount; }
        public void setOutOfStockCount(Long outOfStockCount) { this.outOfStockCount = outOfStockCount; }
        public Long getExpiringCount() { return expiringCount; }
        public void setExpiringCount(Long expiringCount) { this.expiringCount = expiringCount; }
        public BigDecimal getInventoryValue() { return inventoryValue; }
        public void setInventoryValue(BigDecimal inventoryValue) { this.inventoryValue = inventoryValue; }
    }
}
