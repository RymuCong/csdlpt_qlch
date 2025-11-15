package com.example.demo.controller.admin;

import com.example.demo.domain.Store;
import com.example.demo.service.StoreService;
import com.example.demo.service.StoreService.StoreStatistics;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/store")
public class StoreController {
    
    private final StoreService storeService;

    @Autowired
    public StoreController(StoreService storeService) {
        this.storeService = storeService;
    }
    
    /**
     * Hiển thị danh sách cửa hàng
     */
    @GetMapping
    public String showStores(Model model) {
        List<Store> stores = storeService.getAllStores();
        model.addAttribute("stores", stores);
        return "admin/store/show";
    }
    
    /**
     * Hiển thị form tạo cửa hàng mới
     */
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("newStore", new Store());
        return "admin/store/create";
    }
    
    /**
     * Xử lý tạo cửa hàng mới
     */
    @PostMapping("/create")
    public String createStore(@ModelAttribute("newStore") @Valid Store store,
                             BindingResult bindingResult,
                             Model model) {
        if (bindingResult.hasErrors()) {
            return "admin/store/create";
        }
        
        try {
            storeService.createStore(store);
            return "redirect:/admin/store?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/store/create";
        }
    }
    
    /**
     * Hiển thị chi tiết cửa hàng với thống kê
     */
    @GetMapping("/{id}")
    public String showStoreDetail(@PathVariable String id, Model model) {
        Optional<Store> store = storeService.getStoreById(id);
        if (store.isEmpty()) {
            return "common/error-page";
        }
        
        StoreStatistics stats = storeService.getStoreStatistics(id);
        
        model.addAttribute("store", store.get());
        model.addAttribute("stats", stats);
        return "admin/store/detail";
    }
    
    /**
     * Hiển thị form cập nhật cửa hàng
     */
    @GetMapping("/update/{id}")
    public String showUpdateForm(@PathVariable String id, Model model) {
        Optional<Store> store = storeService.getStoreById(id);
        if (store.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("store", store.get());
        return "admin/store/update";
    }
    
    /**
     * Xử lý cập nhật cửa hàng
     */
    @PostMapping("/update")
    public String updateStore(@ModelAttribute("store") @Valid Store store,
                             BindingResult bindingResult,
                             Model model) {
        if (bindingResult.hasErrors()) {
            return "admin/store/update";
        }
        
        try {
            storeService.updateStore(store);
            return "redirect:/admin/store?success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/store/update";
        }
    }
    
    /**
     * Hiển thị form xác nhận xóa
     */
    @GetMapping("/delete/{id}")
    public String showDeleteForm(@PathVariable String id, Model model) {
        Optional<Store> store = storeService.getStoreById(id);
        if (store.isEmpty()) {
            return "common/error-page";
        }
        
        model.addAttribute("store", store.get());
        return "admin/store/delete";
    }
    
    /**
     * Xử lý xóa cửa hàng
     */
    @PostMapping("/delete")
    public String deleteStore(@RequestParam String id) {
        try {
            storeService.deleteStore(id);
            return "redirect:/admin/store?deleted";
        } catch (Exception e) {
            return "redirect:/admin/store?error=" + e.getMessage();
        }
    }
}

