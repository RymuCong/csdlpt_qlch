package com.example.demo.controller.admin;

import com.example.demo.domain.Product;
import com.example.demo.service.ProductService;
import com.example.demo.service.StoreService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.UploadService;
import com.example.demo.service.ProductService.InventoryReport;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Product Controller với logic quản lý kho hàng mới
 * - Quản lý sản phẩm theo cửa hàng (Data Partitioning)
 * - Low stock alerts
 * - Expiration alerts
 * - Inventory reports
 */
@Controller
@RequestMapping("/admin/product")
public class ProductController {

    private final ProductService productService;
    private final StoreService storeService;
    private final CategoryService categoryService;
    private final UploadService uploadService;

    public ProductController(ProductService productService,
                            StoreService storeService,
                            CategoryService categoryService,
                            UploadService uploadService) {
        this.productService = productService;
        this.storeService = storeService;
        this.categoryService = categoryService;
        this.uploadService = uploadService;
    }

    /**
     * Hiển thị danh sách sản phẩm (theo cửa hàng nếu có trong session)
     * Trả về TẤT CẢ dữ liệu để DataTables xử lý phân trang ở client-side
     */
    @GetMapping
    public String showProducts(Model model, 
                              HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        String employeePosition = (String) session.getAttribute("employeePosition");
        
        // Nếu là TS01 (trụ sở chính) hoặc ADMIN, hiển thị tất cả sản phẩm
        // Nếu là chi nhánh (CN01-CN07), chỉ hiển thị sản phẩm của chi nhánh đó
        boolean shouldFilterByStore = storeId != null && !storeId.equals("TS01") 
                                     && !"ADMIN".equals(employeePosition);
        
        List<Product> products;
        if (shouldFilterByStore) {
            products = productService.getProductsByStore(storeId);
        } else {
            // Lấy tất cả sản phẩm (không phân trang) - để DataTables xử lý phân trang ở client-side
            products = productService.getAllProducts();
        }
        
        model.addAttribute("products", products);
        
        // Thống kê nhanh - chỉ tính cho chi nhánh cụ thể
        if (shouldFilterByStore) {
            Long lowStockCount = productService.countLowStockProducts(storeId, 10);
            model.addAttribute("lowStockCount", lowStockCount);
        }
        
        return "admin/product/show";
    }

    /**
     * Hiển thị form tạo sản phẩm mới
     */
    @GetMapping("/create")
    public String showCreateForm(Model model, HttpSession session) {
        model.addAttribute("newProduct", new Product());
        model.addAttribute("stores", storeService.getAllStores());
        model.addAttribute("categories", categoryService.getAllCategories());
        
        // Pre-fill store nếu có trong session
        String storeId = (String) session.getAttribute("storeId");
        if (storeId != null) {
            model.addAttribute("defaultStoreId", storeId);
        }
        
        return "admin/product/create";
    }

    /**
     * Xử lý tạo sản phẩm mới
     */
    @PostMapping("/create")
    public String createProduct(@ModelAttribute("newProduct") @Valid Product product,
                               BindingResult bindingResult,
                               @RequestParam(value = "hoidanitFile", required = false) MultipartFile file,
                               Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("categories", categoryService.getAllCategories());
            return "admin/product/create";
        }

        try {
            // Upload ảnh sản phẩm
            if (file != null && !file.isEmpty()) {
                String image = uploadService.handleSaveUploadFile(file, "product");
                product.setImage(image);
            }
            
            productService.createProduct(product);
            return "redirect:/admin/product?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("categories", categoryService.getAllCategories());
            return "admin/product/create";
        }
    }

    /**
     * Hiển thị chi tiết sản phẩm
     */
    @GetMapping("/{id}")
    public String showProductDetail(@PathVariable String id, Model model) {
        Optional<Product> product = productService.getProductById(id);
        if (product.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("product", product.get());
        return "admin/product/detail";
    }

    /**
     * Hiển thị form cập nhật sản phẩm
     */
    @GetMapping("/update/{id}")
    public String showUpdateForm(@PathVariable String id, Model model) {
        Optional<Product> product = productService.getProductById(id);
        if (product.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("product", product.get());
        model.addAttribute("stores", storeService.getAllStores());
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/product/update";
    }

    /**
     * Xử lý cập nhật sản phẩm
     */
    @PostMapping("/update")
    public String updateProduct(@ModelAttribute("product") @Valid Product product,
                               BindingResult bindingResult,
                               @RequestParam(value = "hoidanitFile", required = false) MultipartFile file,
                               Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("categories", categoryService.getAllCategories());
            return "admin/product/update";
        }

        try {
            // Upload ảnh sản phẩm mới (nếu có)
            if (file != null && !file.isEmpty()) {
                String image = uploadService.handleSaveUploadFile(file, "product");
                product.setImage(image);
            }
            
            productService.updateProduct(product);
            return "redirect:/admin/product?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("stores", storeService.getAllStores());
            model.addAttribute("categories", categoryService.getAllCategories());
            return "admin/product/update";
        }
    }

    /**
     * Hiển thị form xóa sản phẩm
     */
    @GetMapping("/delete/{id}")
    public String showDeleteForm(@PathVariable String id, Model model) {
        Optional<Product> product = productService.getProductById(id);
        if (product.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("product", product.get());
        return "admin/product/delete";
    }

    /**
     * Xử lý xóa sản phẩm
     */
    @PostMapping("/delete")
    public String deleteProduct(@RequestParam String id) {
        try {
            productService.deleteProduct(id);
            return "redirect:/admin/product?deleted";
        } catch (Exception e) {
            return "redirect:/admin/product?error=" + e.getMessage();
        }
    }

    // ============= QUẢN LÝ KHO HÀNG =============

    /**
     * Hiển thị sản phẩm sắp hết hàng (Low Stock Alert)
     */
    @GetMapping("/low-stock")
    public String showLowStockProducts(@RequestParam(defaultValue = "10") Integer threshold,
                                      @RequestParam(required = false) String storeId,
                                      Model model,
                                      HttpSession session) {
        String sessionStoreId = (String) session.getAttribute("storeId");
        String employeePosition = (String) session.getAttribute("employeePosition");
        
        // Nếu không có storeId từ request, dùng từ session
        String filterStoreId = storeId != null ? storeId : sessionStoreId;
        
        // Nếu là TS01 hoặc ADMIN, hiển thị tất cả (hoặc có thể filter theo storeId nếu có)
        // Nếu là chi nhánh, chỉ hiển thị của chi nhánh đó
        boolean shouldFilterByStore = filterStoreId != null && !filterStoreId.equals("TS01") 
                                     && !"ADMIN".equals(employeePosition);
        
        List<Product> lowStockProducts;
        if (shouldFilterByStore && filterStoreId != null) {
            lowStockProducts = productService.getLowStockProducts(filterStoreId, threshold);
        } else {
            // Lấy tất cả sản phẩm sắp hết hàng từ tất cả chi nhánh
            List<Product> allProducts = productService.getAllProducts();
            lowStockProducts = allProducts.stream()
                .filter(p -> p.getQuantity() < threshold)
                .toList();
        }
        
        model.addAttribute("products", lowStockProducts);
        model.addAttribute("threshold", threshold);
        model.addAttribute("filterStoreId", filterStoreId);
        return "admin/product/low-stock";
    }

    /**
     * Hiển thị sản phẩm sắp hết hạn
     */
    @GetMapping("/expiring")
    public String showExpiringProducts(@RequestParam(defaultValue = "30") Integer days,
                                      @RequestParam(required = false) String storeId,
                                      Model model,
                                      HttpSession session) {
        String sessionStoreId = (String) session.getAttribute("storeId");
        String employeePosition = (String) session.getAttribute("employeePosition");
        
        // Nếu không có storeId từ request, dùng từ session
        String filterStoreId = storeId != null ? storeId : sessionStoreId;
        
        // Nếu là TS01 hoặc ADMIN, hiển thị tất cả (hoặc có thể filter theo storeId nếu có)
        // Nếu là chi nhánh, chỉ hiển thị của chi nhánh đó
        boolean shouldFilterByStore = filterStoreId != null && !filterStoreId.equals("TS01") 
                                     && !"ADMIN".equals(employeePosition);
        
        List<Product> expiringProducts;
        if (shouldFilterByStore && filterStoreId != null) {
            expiringProducts = productService.getExpiringProducts(filterStoreId, days);
        } else {
            // Lấy tất cả sản phẩm sắp hết hạn từ tất cả chi nhánh
            LocalDate expiryDate = LocalDate.now().plusDays(days);
            List<Product> allProducts = productService.getAllProducts();
            expiringProducts = allProducts.stream()
                .filter(p -> p.getExpDate() != null && p.getExpDate().isBefore(expiryDate))
                .toList();
        }
        
        model.addAttribute("products", expiringProducts);
        model.addAttribute("days", days);
        model.addAttribute("filterStoreId", filterStoreId);
        return "admin/product/expiring";
    }

    /**
     * Báo cáo kho hàng
     */
    @GetMapping("/inventory-report")
    public String showInventoryReport(@RequestParam(required = false) String storeId,
                                     Model model, 
                                     HttpSession session) {
        String sessionStoreId = (String) session.getAttribute("storeId");
        String employeePosition = (String) session.getAttribute("employeePosition");
        
        // Nếu không có storeId từ request, dùng từ session
        String filterStoreId = storeId != null ? storeId : sessionStoreId;
        
        // Nếu là TS01 hoặc ADMIN, có thể xem báo cáo tổng hợp hoặc theo chi nhánh
        // Nếu là chi nhánh, chỉ xem báo cáo của chi nhánh đó
        boolean shouldFilterByStore = filterStoreId != null && !filterStoreId.equals("TS01") 
                                     && !"ADMIN".equals(employeePosition);
        
        InventoryReport report;
        if (shouldFilterByStore && filterStoreId != null) {
            // Chi nhánh: lấy báo cáo của chi nhánh đó
            report = productService.getInventoryReport(filterStoreId);
        } else {
            // TS01 hoặc ADMIN: có thể xem tổng hợp hoặc theo chi nhánh cụ thể
            if (filterStoreId != null && !filterStoreId.equals("TS01")) {
                // Nếu có storeId cụ thể (không phải TS01), lấy báo cáo của chi nhánh đó
                report = productService.getInventoryReport(filterStoreId);
            } else {
                // Nếu là TS01 hoặc không có storeId, lấy báo cáo tổng hợp từ tất cả chi nhánh
                report = productService.getAggregatedInventoryReport();
            }
        }
        
        model.addAttribute("report", report);
        model.addAttribute("filterStoreId", filterStoreId);
        return "admin/product/inventory-report";
    }

    /**
     * Nhập kho (Add stock)
     */
    @PostMapping("/add-stock")
    public String addStock(@RequestParam String productId,
                          @RequestParam Integer quantity) {
        try {
            productService.addProductStock(productId, quantity);
            return "redirect:/admin/product/" + productId + "?stock_added";
        } catch (Exception e) {
            return "redirect:/admin/product/" + productId + "?error=" + e.getMessage();
        }
    }
}
