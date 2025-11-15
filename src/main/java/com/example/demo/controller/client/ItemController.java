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

import java.util.Optional;

/**
 * Item Controller - Hiển thị và tìm kiếm sản phẩm
 * Note: Không còn chức năng giỏ hàng (Cart) - chỉ hiển thị thông tin sản phẩm
 */
@Controller
public class ItemController {

    private final ProductService productService;
    private final CategoryService categoryService;

    @Autowired
    public ItemController(ProductService productService, CategoryService categoryService) {
        this.productService = productService;
        this.categoryService = categoryService;
    }

    /**
     * Hiển thị danh sách sản phẩm
     */
    @GetMapping("/client/products")
    public String showProducts(Model model,
                              @RequestParam("page") Optional<String> pageOptional,
                              @RequestParam(required = false) String categoryId,
                              @RequestParam(required = false) String keyword) {
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

        return "client/product/show";
    }

    /**
     * Chi tiết sản phẩm
     */
    @GetMapping("/client/product/{id}")
    public String showProductDetail(@PathVariable String id, Model model) {
        Optional<Product> product = productService.getProductById(id);
        if (product.isEmpty()) {
            return "common/error-page";
        }

        model.addAttribute("product", product.get());
        return "client/product/detail";
    }

    /**
     * Tìm kiếm sản phẩm
     */
    @GetMapping("/client/search")
    public String searchProducts(@RequestParam String keyword,
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

        // TODO: Implement search with store context
        // For now, just show all products
        Pageable pageable = PageRequest.of(page - 1, 12);
        Page<Product> productsPage = productService.getAllProducts(pageable);

        model.addAttribute("products", productsPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", productsPage.getTotalPages());
        model.addAttribute("keyword", keyword);
        model.addAttribute("categories", categoryService.getAllCategories());

        return "client/product/show";
    }
}
