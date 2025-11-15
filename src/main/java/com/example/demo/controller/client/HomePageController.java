package com.example.demo.controller.client;

import com.example.demo.domain.Product;
import com.example.demo.service.ProductService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.StoreService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Home Page Controller - Trang chủ khách hàng
 * Note: Phần client hiện không còn chức năng cart/order online
 * Chỉ hiển thị thông tin sản phẩm cho khách hàng tham khảo
 */
@Controller
public class HomePageController {
    
    private final ProductService productService;
    private final CategoryService categoryService;
    private final StoreService storeService;

    public HomePageController(ProductService productService, CategoryService categoryService, StoreService storeService) {
        this.productService = productService;
        this.categoryService = categoryService;
        this.storeService = storeService;
    }

    /**
     * Trang chủ - Hiển thị sản phẩm mới nhất (8-12 sản phẩm)
     */
    @GetMapping("/")
    public String showHomePage(Model model) {
        // Lấy 12 sản phẩm mới nhất cho trang chủ
        List<Product> products = productService.getNewestProducts(12);
        
        model.addAttribute("products", products);
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("stores", storeService.getAllStores());
        
        return "client/homepage/show";
    }

    /**
     * Lọc sản phẩm theo danh mục
     * Trả về TẤT CẢ sản phẩm để client-side filtering và pagination
     */
    @GetMapping("/products")
    public String showProducts(@RequestParam(required = false) String categoryId,
                              @RequestParam(required = false) String keyword,
                              @RequestParam("page") Optional<String> pageOptional,
                              Model model) {
        // Lấy tất cả sản phẩm để client-side filtering
        List<Product> allProducts;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Nếu có keyword, search trước
            allProducts = productService.searchProductsAll(keyword.trim());
            // Sau đó filter theo category nếu có
            if (categoryId != null && !categoryId.isEmpty()) {
                allProducts = allProducts.stream()
                    .filter(p -> p.getCategory() != null && p.getCategory().getId().equals(categoryId))
                    .collect(Collectors.toList());
            }
        } else if (categoryId != null && !categoryId.isEmpty()) {
            allProducts = productService.getProductsByCategory(categoryId);
        } else {
            allProducts = productService.getAllProducts();
        }
        
        model.addAttribute("products", allProducts);
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("selectedCategory", categoryId);
        model.addAttribute("searchKeyword", keyword);
        model.addAttribute("stores", storeService.getAllStores());
        
        return "client/product/show";
    }

    /**
     * Chi tiết sản phẩm
     */
    @GetMapping("/product/{id}")
    public String showProductDetail(@PathVariable String id, Model model) {
        Optional<Product> product = productService.getProductById(id);
        if (product.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("product", product.get());
        model.addAttribute("stores", storeService.getAllStores());
        return "client/product/detail";
    }
    
    /**
     * Chi tiết sản phẩm (alias cho /product/{id})
     */
    @GetMapping("/product-detail/{id}")
    public String showProductDetailAlias(@PathVariable String id, Model model) {
        return showProductDetail(id, model);
    }
    
    /**
     * Tìm kiếm sản phẩm
     */
    @GetMapping("/search")
    public String searchProducts(@RequestParam(required = false) String keyword,
                                Model model) {
        List<Product> products;
        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productService.searchProductsAll(keyword.trim());
        } else {
            products = productService.getAllProducts();
        }
        
        model.addAttribute("products", products);
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("stores", storeService.getAllStores());
        model.addAttribute("searchKeyword", keyword);
        
        return "client/product/show";
    }
}
