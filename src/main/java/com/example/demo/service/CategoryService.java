package com.example.demo.service;

import com.example.demo.domain.Category;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.util.IdGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CategoryService {
    
    private static final Logger log = LoggerFactory.getLogger(CategoryService.class);
    
    private final CategoryRepository categoryRepository;
    private final IdGenerator idGenerator;
    
    public CategoryService(CategoryRepository categoryRepository, IdGenerator idGenerator) {
        this.categoryRepository = categoryRepository;
        this.idGenerator = idGenerator;
    }
    
    /**
     * Tạo danh mục mới
     */
    public Category createCategory(Category category) {
        // Kiểm tra tên danh mục đã tồn tại chưa
        if (categoryRepository.existsByName(category.getName())) {
            log.error("❌ Tên danh mục đã tồn tại: {}", category.getName());
            throw new IllegalArgumentException("Tên danh mục đã tồn tại");
        }
        
        // Generate Category ID
        long categoryCount = categoryRepository.count();
        category.setId(idGenerator.generateCategoryId(categoryCount));
        
        Category savedCategory = categoryRepository.save(category);
        log.info("✅ Tạo danh mục thành công: {} - {}", savedCategory.getId(), savedCategory.getName());
        return savedCategory;
    }
    
    /**
     * Cập nhật danh mục
     */
    public Category updateCategory(Category category) {
        Optional<Category> existingCategory = categoryRepository.findById(category.getId());
        if (existingCategory.isEmpty()) {
            log.error("❌ Không tìm thấy danh mục: {}", category.getId());
            throw new IllegalArgumentException("Danh mục không tồn tại");
        }
        
        // Kiểm tra tên mới có trùng với danh mục khác không
        Optional<Category> categoryWithName = categoryRepository.findByName(category.getName());
        if (categoryWithName.isPresent() && !categoryWithName.get().getId().equals(category.getId())) {
            log.error("❌ Tên danh mục đã được sử dụng bởi danh mục khác: {}", category.getName());
            throw new IllegalArgumentException("Tên danh mục đã được sử dụng bởi danh mục khác");
        }
        
        Category updatedCategory = categoryRepository.save(category);
        log.info("✅ Cập nhật danh mục thành công: {}", updatedCategory.getId());
        return updatedCategory;
    }
    
    /**
     * Xóa danh mục
     */
    public void deleteCategory(String categoryId) {
        Optional<Category> category = categoryRepository.findById(categoryId);
        if (category.isEmpty()) {
            log.error("❌ Không tìm thấy danh mục: {}", categoryId);
            throw new IllegalArgumentException("Danh mục không tồn tại");
        }
        
        // Kiểm tra xem danh mục có sản phẩm không
        Long productCount = categoryRepository.countProductsByCategoryId(categoryId);
        if (productCount > 0) {
            log.error("❌ Không thể xóa danh mục {} (có {} sản phẩm)", categoryId, productCount);
            throw new IllegalStateException("Không thể xóa danh mục đang có sản phẩm");
        }
        
        categoryRepository.deleteById(categoryId);
        log.info("✅ Xóa danh mục thành công: {}", categoryId);
    }
    
    /**
     * Lấy danh mục theo ID
     */
    public Optional<Category> getCategoryById(String categoryId) {
        return categoryRepository.findById(categoryId);
    }
    
    /**
     * Lấy tất cả danh mục
     */
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
    
    /**
     * Tìm danh mục theo tên
     */
    public Optional<Category> getCategoryByName(String name) {
        return categoryRepository.findByName(name);
    }
    
    /**
     * Đếm số sản phẩm trong danh mục
     */
    public Long countProductsInCategory(String categoryId) {
        return categoryRepository.countProductsByCategoryId(categoryId);
    }
    
    /**
     * Đếm số sản phẩm trong danh mục theo cửa hàng
     */
    public Long countProductsInCategoryByStore(String categoryId, String storeId) {
        if (storeId == null) {
            return countProductsInCategory(categoryId);
        }
        return categoryRepository.countProductsByCategoryIdAndStoreId(categoryId, storeId);
    }
}

