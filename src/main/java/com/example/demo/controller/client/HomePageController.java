package com.example.demo.controller.client;

import com.example.demo.domain.Product;
import com.example.demo.service.ProductService;
import com.example.demo.service.CategoryService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;

/**
 * Home Page Controller - Trang chủ khách hàng
 * Note: Phần client hiện không còn chức năng cart/order online
 * Chỉ hiển thị thông tin sản phẩm cho khách hàng tham khảo
 */
@Controller
public class HomePageController {
    
    private final ProductService productService;
    private final CategoryService categoryService;

    @Autowired
    public HomePageController(ProductService productService, CategoryService categoryService) {
        this.productService = productService;
        this.categoryService = categoryService;
    }

    /**
     * Trang chủ - Hiển thị sản phẩm
     */
    @GetMapping("/")
    public String showHomePage(Model model, 
                              @RequestParam("page") Optional<String> pageOptional) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.parseInt(pageOptional.get());
            }
        } catch (Exception e) {
            // Use default page
        }
        
        Pageable pageable = PageRequest.of(page - 1, 12);
        Page<Product> productsPage = productService.getAllProducts(pageable);
        
        model.addAttribute("products", productsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", productsPage.getTotalPages());
        model.addAttribute("categories", categoryService.getAllCategories());
        
        return "client/homepage/show";
    }

    /**
     * Lọc sản phẩm theo danh mục
     */
    @GetMapping("/products")
    public String showProducts(@RequestParam(required = false) String categoryId,
                              @RequestParam("page") Optional<String> pageOptional,
                              Model model) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.parseInt(pageOptional.get());
            }
        } catch (Exception e) {
            // Use default page
        }
        
        Pageable pageable = PageRequest.of(page - 1, 12);
        
        List<Product> products;
        int totalPages;
        if (categoryId != null && !categoryId.isEmpty()) {
            products = productService.getProductsByCategory(categoryId);
            totalPages = (int) Math.ceil((double) products.size() / 12);
        } else {
            Page<Product> productPage = productService.getAllProducts(pageable);
            products = productPage.getContent();
            totalPages = productPage.getTotalPages();
        }
        
        model.addAttribute("products", products);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("selectedCategory", categoryId);
        
        return "client/product/show";
    }

    /**
     * Chi tiết sản phẩm
     */
    @GetMapping("/product-detail/{id}")
    public String showProductDetail(@PathVariable String id, Model model) {
        Optional<Product> product = productService.getProductById(id);
        if (product.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("product", product.get());
        return "client/product/detail";
    }
}
