package com.example.demo.controller.admin;

import com.example.demo.domain.Category;
import com.example.demo.service.CategoryService;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/category")
public class CategoryController {
    
    private final CategoryService categoryService;

    @Autowired
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }
    
    /**
     * Hiển thị danh sách danh mục
     */
    @GetMapping
    public String showCategories(Model model) {
        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        return "admin/category/show";
    }
    
    /**
     * Hiển thị form tạo danh mục mới
     */
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("newCategory", new Category());
        return "admin/category/create";
    }
    
    /**
     * Xử lý tạo danh mục mới
     */
    @PostMapping("/create")
    public String createCategory(@ModelAttribute("newCategory") @Valid Category category,
                                BindingResult bindingResult,
                                Model model) {
        if (bindingResult.hasErrors()) {
            return "admin/category/create";
        }
        
        try {
            categoryService.createCategory(category);
            return "redirect:/admin/category?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/category/create";
        }
    }
    
    /**
     * Hiển thị chi tiết danh mục
     */
    @GetMapping("/{id}")
    public String showCategoryDetail(@PathVariable String id, Model model) {
        Optional<Category> category = categoryService.getCategoryById(id);
        if (category.isEmpty()) {
            return "common/error-page";
        }
        
        Long productCount = categoryService.countProductsInCategory(id);
        
        model.addAttribute("category", category.get());
        model.addAttribute("productCount", productCount);
        return "admin/category/detail";
    }
    
    /**
     * Hiển thị form cập nhật danh mục
     */
    @GetMapping("/update/{id}")
    public String showUpdateForm(@PathVariable String id, Model model) {
        Optional<Category> category = categoryService.getCategoryById(id);
        if (category.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("category", category.get());
        return "admin/category/update";
    }
    
    /**
     * Xử lý cập nhật danh mục
     */
    @PostMapping("/update")
    public String updateCategory(@ModelAttribute("category") @Valid Category category,
                                BindingResult bindingResult,
                                Model model) {
        if (bindingResult.hasErrors()) {
            return "admin/category/update";
        }
        
        try {
            categoryService.updateCategory(category);
            return "redirect:/admin/category?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/category/update";
        }
    }
    
    /**
     * Hiển thị form xác nhận xóa
     */
    @GetMapping("/delete/{id}")
    public String showDeleteForm(@PathVariable String id, Model model) {
        Optional<Category> category = categoryService.getCategoryById(id);
        if (category.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("category", category.get());
        return "admin/category/delete";
    }
    
    /**
     * Xử lý xóa danh mục
     */
    @PostMapping("/delete")
    public String deleteCategory(@RequestParam String id) {
        try {
            categoryService.deleteCategory(id);
            return "redirect:/admin/category?deleted";
        } catch (Exception e) {
            return "redirect:/admin/category?error=" + e.getMessage();
        }
    }
}

