package com.example.demo.controller.admin;

import com.example.demo.domain.Product;
import com.example.demo.service.ProductService;
import com.example.demo.service.StoreService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.UploadService;
import com.example.demo.service.ProductService.InventoryReport;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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

    @Autowired
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
     */
    @GetMapping
    public String showProducts(Model model, 
                              @RequestParam("page") Optional<String> pageOptional,
                              HttpSession session) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.parseInt(pageOptional.get());
            }
        } catch (Exception e) {
            // Sử dụng page mặc định
        }
        
        Pageable pageable = PageRequest.of(page - 1, 10);
        String storeId = (String) session.getAttribute("storeId");
        
        Page<Product> productsPage;
        if (storeId != null) {
            productsPage = productService.getProductsByStore(storeId, pageable);
        } else {
            productsPage = productService.getAllProducts(pageable);
        }
        
        model.addAttribute("products", productsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", productsPage.getTotalPages());
        
        // Thống kê nhanh
        if (storeId != null) {
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
                                      Model model,
                                      HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        if (storeId == null) {
            return "redirect:/admin/product?error=no_store";
        }
        
        List<Product> lowStockProducts = productService.getLowStockProducts(storeId, threshold);
        model.addAttribute("products", lowStockProducts);
        model.addAttribute("threshold", threshold);
        return "admin/product/low-stock";
    }

    /**
     * Hiển thị sản phẩm sắp hết hạn
     */
    @GetMapping("/expiring")
    public String showExpiringProducts(@RequestParam(defaultValue = "30") Integer days,
                                      Model model,
                                      HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        if (storeId == null) {
            return "redirect:/admin/product?error=no_store";
        }
        
        List<Product> expiringProducts = productService.getExpiringProducts(storeId, days);
        model.addAttribute("products", expiringProducts);
        model.addAttribute("days", days);
        return "admin/product/expiring";
    }

    /**
     * Báo cáo kho hàng
     */
    @GetMapping("/inventory-report")
    public String showInventoryReport(Model model, HttpSession session) {
        String storeId = (String) session.getAttribute("storeId");
        if (storeId == null) {
            return "redirect:/admin/product?error=no_store";
        }
        
        InventoryReport report = productService.getInventoryReport(storeId);
        model.addAttribute("report", report);
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
